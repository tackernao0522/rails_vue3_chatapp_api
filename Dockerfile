FROM node:16.13.1-alpine as node

FROM ruby:2.6.4-alpine

COPY --from=node /usr/local/bin/node /usr/local/bin/node

ARG WORKDIR

ARG RUNTIME_PACKAGES="tzdata postgresql-dev postgresql git"

ARG DEV_PACKAGES="build-base curl-dev"

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${HOME}

COPY Gemfile* ./

RUN apk update && \
  apk upgrade && \
  apk add --no-cache ${RUNTIME_PACKAGES} && \
  apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
  bundle install -j4 && \
  apk del build-dependencies

COPY . ./

CMD ["rails", "server", "-b", "0.0.0.0"]
