Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751968AbdJKKLh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 06:11:37 -0400
Date: Wed, 11 Oct 2017 06:11:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] generic: test race when checking i_size on direct i/o
 read
Message-ID: <20171011101131.GD32909@bfoster.bfoster>
References: <20171010074208.15389-2-eguan@redhat.com>
 <20171011065202.25531-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011065202.25531-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@redhat.com>

On Wed, Oct 11, 2017 at 02:52:02PM +0800, Eryu Guan wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In this commit a new test case is added to test that i_size races
> don't occur under dio reads/writes.  We add a program in /src dir,
> which has a writer to issue some append dio writes.  Meanwhile it
> has a reader in this test to do some dio reads.  As we expect,
> reader should read nothing or data with 'a'. But it might read some
> data with '0'.
> 
> The bug can be reproduced by this test case [1].
> 
> 1.  http://patchwork.ozlabs.org/patch/311761/
> 
> This ostensibly tests commit:
> 9fe55eea7 Fix race when checking i_size on direct i/o read
> 
> Update by Eric Sandeen:
> - update to recent xfstests
> - update commit log
> 
> Update by Eryu Guan:
> - add aio-dio support to the test and add 'aio' group
> - add ability to test different alignments
> - move test from src/ to src/aio-dio-regress/
> - add .gitignore entry
> - rebase against latest xfstests with various minor fixes & cleanups
> - update commit log
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---

Looks good, thanks Eryu:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> v3:
> - fix reader/writer synchronization race
> 
> v2:
> - start background reader in a thread first then start writer only after
>   reader starts issuing reads
> 
>  .gitignore                                         |   1 +
>  .../aio-dio-append-write-read-race.c               | 230 +++++++++++++++++++++
>  tests/generic/464                                  |  75 +++++++
>  tests/generic/464.out                              |   3 +
>  tests/generic/group                                |   1 +
>  5 files changed, 310 insertions(+)
>  create mode 100644 src/aio-dio-regress/aio-dio-append-write-read-race.c
>  create mode 100755 tests/generic/464
>  create mode 100644 tests/generic/464.out
> 
> diff --git a/.gitignore b/.gitignore
> index ae7ef87ab384..2dface41d485 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -142,6 +142,7 @@
>  /src/writemod
>  /src/writev_on_pagefault
>  /src/xfsctl
> +/src/aio-dio-regress/aio-dio-append-write-read-race
>  /src/aio-dio-regress/aio-dio-cycle-write
>  /src/aio-dio-regress/aio-dio-eof-race
>  /src/aio-dio-regress/aio-dio-extend-stat
> diff --git a/src/aio-dio-regress/aio-dio-append-write-read-race.c b/src/aio-dio-regress/aio-dio-append-write-read-race.c
> new file mode 100644
> index 000000000000..1a78009eb18a
> --- /dev/null
> +++ b/src/aio-dio-regress/aio-dio-append-write-read-race.c
> @@ -0,0 +1,230 @@
> +/*
> + * Copyright (c) 2013 Alibaba Group.
> + * Copyright (c) 2017 Red Hat Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +/*
> + * This is a normal case that we do some append dio writes and meanwhile
> + * we do some dio reads.  Currently in vfs we don't ensure that i_size
> + * is updated properly.  Hence the reader will read some data with '0'.
> + * But we expect that the reader should read nothing or data with 'a'.
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +
> +#include <libaio.h>
> +#include <pthread.h>
> +
> +struct io_data {
> +	int fd;
> +	size_t blksize;
> +	off_t offset;
> +	char *buf;
> +	int use_aio;
> +};
> +
> +int reader_ready = 0;
> +
> +static void usage(const char *prog)
> +{
> +	fprintf(stderr, "usage: %s [-a] <file>\n", prog);
> +	fprintf(stderr, "\t-a\tuse aio-dio\n");
> +	exit(EXIT_FAILURE);
> +}
> +
> +static void *reader(void *arg)
> +{
> +	struct io_data *data = (struct io_data *)arg;
> +	int ret;
> +
> +	memset(data->buf, 'b', data->blksize);
> +	reader_ready = 1;
> +	do {
> +		ret = pread(data->fd, data->buf, data->blksize, data->offset);
> +		if (ret < 0)
> +			perror("read file");
> +	} while (ret <= 0);
> +
> +	return NULL;
> +}
> +
> +static void *writer(struct io_data *data)
> +{
> +	int ret;
> +
> +	while (!reader_ready)
> +		usleep(1);
> +
> +	if (data->use_aio) {
> +		struct io_context *ctx = NULL;
> +		struct io_event evs[1];
> +		struct iocb iocb;
> +		struct iocb *iocbs[] = { &iocb };
> +
> +		ret = io_setup(1, &ctx);
> +		if (ret) {
> +			fprintf(stderr, "error %s during io_setup\n",
> +				strerror(ret));
> +			return NULL;
> +		}
> +		io_prep_pwrite(&iocb, data->fd, data->buf, data->blksize, data->offset);
> +		ret = io_submit(ctx, 1, iocbs);
> +		if (ret != 1) {
> +			fprintf(stderr, "error %s during io_submit\n",
> +				strerror(ret));
> +			return NULL;
> +		}
> +		ret = io_getevents(ctx, 1, 1, evs, NULL);
> +		if (ret != 1) {
> +			fprintf(stderr, "error %s during io_getevents\n",
> +				strerror(ret));
> +			return NULL;
> +		}
> +	} else {
> +		ret = pwrite(data->fd, data->buf, data->blksize, data->offset);
> +		if (ret < 0)
> +			perror("write file failed");
> +	}
> +
> +	return NULL;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	pthread_t tid;
> +	struct io_data wdata;
> +	struct io_data rdata;
> +	size_t max_blocks = 128;		/* 128 */
> +	size_t blksize = 1 * 1024 * 1024;	/* 1M */
> +	char *rbuf = NULL, *wbuf = NULL;
> +	int rfd = 0, wfd = 0;
> +	int i, j, c;
> +	int use_aio = 1;
> +	int ret = 0;
> +	int io_align = 4096;
> +	char *prog;
> +	char *testfile;
> +
> +
> +	prog = basename(argv[0]);
> +
> +	while ((c = getopt(argc, argv, "a:d")) != -1) {
> +		switch (c) {
> +		case 'a':
> +			io_align = strtol(optarg, NULL, 0);
> +			break;
> +		case 'd':
> +			use_aio = 0;
> +			break;
> +		default:
> +			usage(prog);
> +		}
> +	}
> +	if (optind != argc - 1)
> +		usage(prog);
> +	testfile = argv[optind];
> +
> +	wfd = open(testfile, O_CREAT|O_DIRECT|O_WRONLY|O_TRUNC, 0644);
> +	if (wfd < 0) {
> +		perror("open for write");
> +		exit(1);
> +	}
> +
> +	rfd = open(testfile, O_DIRECT|O_RDONLY, 0644);
> +	if (rfd < 0) {
> +		perror("open for read");
> +		ret = 1;
> +		goto err;
> +	}
> +
> +	ret = posix_memalign((void **)&wbuf, io_align, blksize);
> +	if (ret) {
> +		fprintf(stderr, "failed to alloc memory: %s\n", strerror(ret));
> +		ret = 1;
> +		goto err;
> +	}
> +
> +	ret = posix_memalign((void **)&rbuf, io_align, blksize);
> +	if (ret) {
> +		fprintf(stderr, "failed to alloc memory: %s\n", strerror(ret));
> +		ret = 1;
> +		goto err;
> +	}
> +
> +	memset(wbuf, 'a', blksize);
> +	wdata.fd = wfd;
> +	wdata.blksize = blksize;
> +	wdata.buf = wbuf;
> +	wdata.use_aio = use_aio;
> +	rdata.fd = rfd;
> +	rdata.blksize = blksize;
> +	rdata.buf = rbuf;
> +
> +	for (i = 0; i < max_blocks; i++) {
> +		wdata.offset = rdata.offset = i * blksize;
> +
> +		/* reset reader_ready, it will be set in reader thread */
> +		reader_ready = 0;
> +		ret = pthread_create(&tid, NULL, reader, &rdata);
> +		if (ret) {
> +			fprintf(stderr, "create reader thread failed: %s\n",
> +				strerror(ret));
> +			ret = 1;
> +			goto err;
> +		}
> +
> +		writer(&wdata);
> +
> +		ret = pthread_join(tid, NULL);
> +		if (ret) {
> +			fprintf(stderr, "pthread join reader failed: %s\n",
> +				strerror(ret));
> +			ret = 1;
> +			goto err;
> +		}
> +
> +		for (j = 0; j < blksize; j++) {
> +			if (rdata.buf[j] != 'a') {
> +				fprintf(stderr, "encounter an error: "
> +					"block %d offset %d, content %x\n",
> +					i, j, rbuf[j]);
> +				ret = 1;
> +				goto err;
> +			}
> +		}
> +	}
> +
> +err:
> +	if (rfd)
> +		close(rfd);
> +	if (wfd)
> +		close(wfd);
> +	if (rbuf)
> +		free(rbuf);
> +	if (wbuf)
> +		free(wbuf);
> +
> +	exit(ret);
> +}
> diff --git a/tests/generic/464 b/tests/generic/464
> new file mode 100755
> index 000000000000..b0423c91a7cf
> --- /dev/null
> +++ b/tests/generic/464
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# FS QA Test No. 464
> +#
> +# Test i_size is updated properly under dio read/write
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Alibaba Group.  All Rights Reserved.
> +# Copyright (c) 2017 Red Hat Inc. All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.* $testfile.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +
> +_require_aiodio aio-dio-append-write-read-race
> +_require_test_program "feature"
> +
> +testfile=$TEST_DIR/$seq.$$
> +min_dio_align=`_min_dio_alignment $TEST_DEV`
> +page_size=`$here/src/feature -s`
> +
> +rm -f $seqres.full
> +
> +echo "non-aio dio test"
> +align=$min_dio_align
> +while [ $align -le $page_size ]; do
> +	echo "$AIO_TEST -a $align -d $testfile.$align" >> $seqres.full
> +	$AIO_TEST -a $align -d $testfile.$align 2>&1 | tee -a $seqres.full
> +	align=$((align * 2))
> +done
> +
> +echo "aio-dio test"
> +align=$min_dio_align
> +while [ $align -le $page_size ]; do
> +	echo "$AIO_TEST -a $align $testfile.$align" >> $seqres.full
> +	$AIO_TEST -a $align $testfile.$align 2>&1 | tee -a $seqres.full
> +	align=$((align * 2))
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/464.out b/tests/generic/464.out
> new file mode 100644
> index 000000000000..14e66fe7d778
> --- /dev/null
> +++ b/tests/generic/464.out
> @@ -0,0 +1,3 @@
> +QA output created by 464
> +non-aio dio test
> +aio-dio test
> diff --git a/tests/generic/group b/tests/generic/group
> index 9f173e7a63c9..556add16286b 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -466,3 +466,4 @@
>  461 auto shutdown stress
>  462 auto quick dax
>  463 auto rw
> +464 auto rw quick aio
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
