Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34501 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdJIIT2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 04:19:28 -0400
Date: Mon, 9 Oct 2017 16:19:22 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic: test race when checking i_size on direct i/o
 read
Message-ID: <20171009081922.GH10593@eguan.usersys.redhat.com>
References: <20170925101847.29539-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925101847.29539-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@redhat.com>

On Mon, Sep 25, 2017 at 06:18:47PM +0800, Eryu Guan wrote:
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
> This test fails on XFS, the following patch fixed the XFS failure
> https://www.spinics.net/lists/linux-xfs/msg10865.html

The xfs fix is now upstream. I really appreciate if someone could help
review this test case too.

Thanks,
Eryu

> 
> btrfs also fails when io alignment is not 4k, perhaps a btrfs bug?
> 
> Eric's original post
> http://www.spinics.net/lists/fstests/msg06978.html
> 
>  .gitignore                                         |   1 +
>  .../aio-dio-append-write-read-race.c               | 214 +++++++++++++++++++++
>  tests/generic/462                                  |  75 ++++++++
>  tests/generic/462.out                              |   3 +
>  tests/generic/group                                |   1 +
>  5 files changed, 294 insertions(+)
>  create mode 100644 src/aio-dio-regress/aio-dio-append-write-read-race.c
>  create mode 100755 tests/generic/462
>  create mode 100644 tests/generic/462.out
> 
> diff --git a/.gitignore b/.gitignore
> index 63928b481e7f..71c1eb5c7675 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -133,6 +133,7 @@
>  /src/writemod
>  /src/writev_on_pagefault
>  /src/xfsctl
> +/src/aio-dio-regress/aio-dio-append-write-read-race
>  /src/aio-dio-regress/aio-dio-cycle-write
>  /src/aio-dio-regress/aio-dio-extend-stat
>  /src/aio-dio-regress/aio-dio-fcntl-race
> diff --git a/src/aio-dio-regress/aio-dio-append-write-read-race.c b/src/aio-dio-regress/aio-dio-append-write-read-race.c
> new file mode 100644
> index 000000000000..dce2ab743f11
> --- /dev/null
> +++ b/src/aio-dio-regress/aio-dio-append-write-read-race.c
> @@ -0,0 +1,214 @@
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
> +struct writer_data {
> +	int fd;
> +	size_t blksize;
> +	off_t offset;
> +	char *buf;
> +};
> +
> +static void usage(const char *prog)
> +{
> +	fprintf(stderr, "usage: %s [-a] <file>\n", prog);
> +	fprintf(stderr, "\t-a\tuse aio-dio\n");
> +	exit(EXIT_FAILURE);
> +}
> +
> +static void *dio_writer(void *arg)
> +{
> +	struct writer_data *data = (struct writer_data *)arg;
> +	int ret;
> +
> +	ret = pwrite(data->fd, data->buf, data->blksize, data->offset);
> +	if (ret < 0)
> +		perror("write file failed");
> +
> +	return NULL;
> +}
> +
> +static void *aio_writer(void *arg)
> +{
> +	struct writer_data *data = (struct writer_data *)arg;
> +	struct io_context *ctx = NULL;
> +	struct io_event evs[1];
> +	struct iocb iocb;
> +	struct iocb *iocbs[] = { &iocb };
> +	int err;
> +
> +	err = io_setup(1, &ctx);
> +	if (err) {
> +		fprintf(stderr, "error %s during io_setup\n",
> +		        strerror(err));
> +		return NULL;
> +	}
> +	io_prep_pwrite(&iocb, data->fd, data->buf, data->blksize, data->offset);
> +	err = io_submit(ctx, 1, iocbs);
> +	if (err != 1) {
> +		fprintf(stderr, "error %s during io_submit\n",
> +			strerror(err));
> +		return NULL;
> +	}
> +	err = io_getevents(ctx, 1, 1, evs, NULL);
> +	if (err != 1) {
> +		fprintf(stderr, "error %s during io_getevents\n",
> +			strerror(err));
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	pthread_t tid;
> +	struct writer_data wdata;
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
> +
> +	for (i = 0; i < max_blocks; i++) {
> +		wdata.offset = i * blksize;
> +		if (use_aio)
> +			ret = pthread_create(&tid, NULL, aio_writer, &wdata);
> +		else
> +			ret = pthread_create(&tid, NULL, dio_writer, &wdata);
> +		if (ret) {
> +			fprintf(stderr, "create thread failed: %s\n",
> +				strerror(ret));
> +			ret = 1;
> +			goto err;
> +		}
> +
> +		memset(rbuf, 'b', blksize);
> +		do {
> +			ret = pread(rfd, rbuf, blksize, i * blksize);
> +			if (ret < 0)
> +				perror("read file");
> +		} while (ret <= 0);
> +
> +		ret = pthread_join(tid, NULL);
> +		if (ret) {
> +			fprintf(stderr, "pthread join failed: %s\n",
> +				strerror(ret));
> +			ret = 1;
> +			goto err;
> +		}
> +
> +		for (j = 0; j < blksize; j++) {
> +			if (rbuf[j] != 'a') {
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
> diff --git a/tests/generic/462 b/tests/generic/462
> new file mode 100755
> index 000000000000..7abadcb11921
> --- /dev/null
> +++ b/tests/generic/462
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# FS QA Test No. 462
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
> diff --git a/tests/generic/462.out b/tests/generic/462.out
> new file mode 100644
> index 000000000000..9a368005af49
> --- /dev/null
> +++ b/tests/generic/462.out
> @@ -0,0 +1,3 @@
> +QA output created by 462
> +non-aio dio test
> +aio-dio test
> diff --git a/tests/generic/group b/tests/generic/group
> index dfa86edc4a93..c65058976f1e 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -464,3 +464,4 @@
>  459 auto dangerous
>  460 auto quick rw
>  461 auto rw
> +462 auto rw quick aio
> -- 
> 2.13.5
> 
