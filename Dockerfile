FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.13-php8

# set version label
ARG DOCKER_HUB_USER
ARG IMAGE_BUILD_DATE
ARG IMAGE_VERSION
ARG FILEGATOR_RELEASE
LABEL build_version="${DOCKER_HUB_USER} version:- ${IMAGE_VERSION} Build-date:- ${IMAGE_BUILD_DATE}"
LABEL maintainer="${DOCKER_HUB_USER}"

# install filegator
RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade \
	php8-ctype \
	php8-curl \
	php8-pdo_pgsql \
	php8-pdo_sqlite \
	php8-tokenizer \
	php8-zip \
	unzip \
        curl && \
 echo "**** install filegator ****" && \
 if [ -z ${FILEGATOR_RELEASE+x} ]; then \
	FILEGATOR_RELEASE=$(curl -sX GET "https://api.github.com/repos/filegator/filegator/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /filegator.zip -L \
	"https://github.com/filegator/filegator/releases/download/${FILEGATOR_RELEASE}/filegator_${FILEGATOR_RELEASE}.zip" && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /
