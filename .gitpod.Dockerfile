
FROM ubuntu:18.04

USER khalid
USER gitpod

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        bmake \
        build-essential \
        bzip2 \
        ca-certificates \
        curl \
        devscripts \
        dh-make \
        fakeroot \
        git \
        libcap-dev \
        libelf-dev \
        libseccomp-dev \
        lintian \
        lsb-release \
        m4 \
        pkg-config \
        xz-utils && \
    rm -rf /var/lib/apt/lists/*

ENV GPG_TTY /dev/console

WORKDIR /tmp/libnvidia-container
COPY . .

ARG WITH_LIBELF=no
ARG WITH_TIRPC=no
ARG WITH_SECCOMP=yes
ENV WITH_LIBELF=${WITH_LIBELF}
ENV WITH_TIRPC=${WITH_TIRPC}
ENV WITH_SECCOMP=${WITH_SECCOMP}

RUN make distclean && make -j"$(nproc)"

ENV DIST_DIR /dist
VOLUME $DIST_DIR
CMD make dist && make deb