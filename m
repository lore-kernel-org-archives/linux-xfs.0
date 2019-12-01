Return-Path: <SRS0=WxS8=ZX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8831DC43141
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Dec 2019 14:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A5CC2146E
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Dec 2019 14:28:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kt3Osl4o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfLAO2r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Dec 2019 09:28:47 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33919 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLAO2q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Dec 2019 09:28:46 -0500
Received: by mail-pl1-f194.google.com with SMTP id h13so15095403plr.1;
        Sun, 01 Dec 2019 06:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DMj83np5g2+v6kgUgDxubAg3d0vlBwqpjy1VMyVGu7A=;
        b=Kt3Osl4o0wIyskQZ9a7hBTeSc/xYqxa76T90kLT8oj/lLOh02qdvzs4SqyZolE8ZDL
         A9uAk8dRKPVQZDKxwnnvWN5fU6+9JJRL+/+rAEt76jycG+FPIMrmUeA1OgKcldeXcaVY
         zgujFtV3Kj+3gnEtyo/gAj/xpZ/actfj6N4dg7keRYw7P63DzkrwmbbjRhgFvwiH5WHq
         ih31GPYvxkxplyWZ7E/ThRoSF6CKUmWsVrlwCp/7Lcej0m3rpfCG0SxNCUqHxauAu+5s
         x7unfXtYZ32Ejk7A0+hNS+nuuEDvMcvMifN6qjllMCrAKJDyJlsN++Y91mnKuu6J3N6g
         IS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DMj83np5g2+v6kgUgDxubAg3d0vlBwqpjy1VMyVGu7A=;
        b=f3eCpAz8/KxDv8VCyqECvZgpWIsaYe19mnsezuTqPVBk1EncLhRvbXIgVY/EOnLWV+
         S7Nzz4Vf17sYce/dk7nH2XbB9aHpGM02HOiYIg60r2Jvq+VH/qdYSCC3b+4/bQjiqtST
         JKa2svTsqu6wj4qEiRyF8Dk1aeD1O9KASfJyYgbK1+swSUPc1zsyMTyJSoQO3GzJ3xRQ
         m8C5BlSpqkuqjA7vH/4ghh+rLDB7uvh4mpZN2epfhx373bPJXZ6HaGndYl8Kxlgn0uHv
         UO1j9PQ0BSi/cvmLPaIYEWCuixn59Hga4Xyj//aaAHnmZNfjbKIBKOICEvyT6QZmDV5h
         fkpA==
X-Gm-Message-State: APjAAAW6zN2N8TlFERPtDSkunza/J0d2nwr7FsfkDhnTXtHinHZNECN+
        Eqw8cN/7Tau/d1hc4JrThtgBL+uz
X-Google-Smtp-Source: APXvYqyKJ5AhlBkjVMLQrTzsbFJ+EZ5KUVeGDWQ8zrE4g3flZ68iKbcShms6KvJmPMPrVpKsrKQfuw==
X-Received: by 2002:a17:90a:23a9:: with SMTP id g38mr30637473pje.128.1575210525852;
        Sun, 01 Dec 2019 06:28:45 -0800 (PST)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id r10sm28681493pgn.68.2019.12.01.06.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2019 06:28:44 -0800 (PST)
Date:   Sun, 1 Dec 2019 22:28:39 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic: test race between appending AIO DIO and
 fallocate
Message-ID: <20191201142824.GI8664@desktop>
References: <20191113024416.GH6235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113024416.GH6235@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 06:44:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Dave Chinner reports[1] that an appending AIO DIO write to the second
> block of a zero-length file and an fallocate request to the first block
> of the same file can race to set isize, with the user-visible end result
> that the file size is set incorrectly to one block long.  Write a small
> test to reproduce the results.
> 
> [1] https://lore.kernel.org/linux-xfs/20191029100342.GA41131@bfoster/T/
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  .../aio-dio-append-write-fallocate-race.c          |  212 ++++++++++++++++++++

I added an entry in .gitignore for it.

>  tests/generic/722                                  |   43 ++++
>  tests/generic/722.out                              |    2 
>  tests/generic/group                                |    1 
>  4 files changed, 258 insertions(+)
>  create mode 100644 src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
>  create mode 100755 tests/generic/722
>  create mode 100644 tests/generic/722.out
> 
> diff --git a/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c b/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
> new file mode 100644
> index 00000000..091b047d
> --- /dev/null
> +++ b/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0-or-newer
> +/*
> + * Copyright (c) 2019 Oracle.
> + * All Rights Reserved.
> + *
> + * Race appending aio dio and fallocate to make sure we get the correct file
> + * size afterwards.
> + */
> +#include <stdio.h>
> +#include <pthread.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <libaio.h>
> +#include <stdlib.h>
> +#include <stdbool.h>
> +#include <limits.h>
> +
> +static int fd;
> +static int blocksize;
> +
> +static void *
> +falloc_thread(
> +	void		*p)
> +{
> +	int		ret;
> +
> +	ret = fallocate(fd, 0, 0, blocksize);
> +	if (ret)
> +		perror("falloc");
> +
> +	return NULL;
> +}
> +
> +static int
> +test(
> +	const char	*fname,
> +	unsigned int	iteration,
> +	unsigned int	*passed)
> +{
> +	struct stat	sbuf;
> +	pthread_t	thread;
> +	io_context_t	ioctx = 0;
> +	struct iocb	iocb;
> +	struct iocb	*iocbp = &iocb;
> +	struct io_event	event;
> +	char		*buf;
> +	bool		wait_thread = false;
> +	int		ret;
> +
> +	/* Truncate file, allocate resources for doing IO. */
> +	fd = open(fname, O_DIRECT | O_RDWR | O_TRUNC | O_CREAT, 0644);
> +	if (fd < 0) {
> +		perror(fname);
> +		return -1;
> +	}
> +
> +	ret = fstat(fd, &sbuf);
> +	if (ret) {
> +		perror(fname);
> +		goto out;
> +	}
> +	blocksize = sbuf.st_blksize;
> +
> +	ret = posix_memalign((void **)&buf, blocksize, blocksize);
> +	if (ret) {
> +		errno = ret;
> +		perror("buffer");
> +		goto out;
> +	}
> +	memset(buf, 'X', blocksize);
> +	memset(&event, 0, sizeof(event));
> +
> +	ret = io_queue_init(1, &ioctx);
> +	if (ret) {
> +		errno = -ret;
> +		perror("io_queue_init");
> +		goto out_buf;
> +	}
> +
> +	/*
> +	 * Set ourselves up to race fallocate(0..blocksize) with aio dio
> +	 * pwrite(blocksize..blocksize * 2).  This /should/ give us a file
> +	 * with length (2 * blocksize).
> +	 */
> +	io_prep_pwrite(&iocb, fd, buf, blocksize, blocksize);
> +
> +	ret = pthread_create(&thread, NULL, falloc_thread, NULL);
> +	if (ret) {
> +		errno = ret;
> +		perror("pthread");
> +		goto out_io;
> +	}
> +	wait_thread = true;
> +
> +	ret = io_submit(ioctx, 1, &iocbp);
> +	if (ret != 1) {
> +		errno = -ret;
> +		perror("io_submit");
> +		goto out_join;
> +	}
> +
> +	ret = io_getevents(ioctx, 1, 1, &event, NULL);
> +	if (ret != 1) {
> +		errno = -ret;
> +		perror("io_getevents");
> +		goto out_join;
> +	}
> +
> +	if (event.res < 0) {
> +		errno = -event.res;
> +		perror("io_event.res");
> +		goto out_join;
> +	}
> +
> +	if (event.res2 < 0) {
> +		errno = -event.res2;
> +		perror("io_event.res2");
> +		goto out_join;
> +	}
> +
> +	wait_thread = false;
> +	ret = pthread_join(thread, NULL);
> +	if (ret) {
> +		errno = ret;
> +		perror("join");
> +		goto out_io;
> +	}
> +
> +	/* Make sure we actually got a file of size (2 * blocksize). */
> +	ret = fstat(fd, &sbuf);
> +	if (ret) {
> +		perror(fname);
> +		goto out_buf;
> +	}
> +
> +	if (sbuf.st_size != 2 * blocksize) {
> +		fprintf(stderr, "[%u]: sbuf.st_size=%llu, expected %llu.\n",
> +				iteration,
> +				(unsigned long long)sbuf.st_size,
> +				(unsigned long long)2 * blocksize);
> +	} else {
> +		printf("[%u]: passed.\n", iteration);
> +		(*passed)++;
> +	}
> +
> +out_join:
> +	if (wait_thread) {
> +		ret = pthread_join(thread, NULL);
> +		if (ret) {
> +			errno = ret;
> +			perror("join");
> +			goto out_io;
> +		}
> +	}
> +out_io:
> +	ret = io_queue_release(ioctx);
> +	if (ret) {
> +		errno = -ret;
> +		perror("io_queue_release");
> +	}
> +
> +out_buf:
> +	free(buf);
> +out:
> +	ret = close(fd);
> +	fd = -1;
> +	if (ret) {
> +		perror("close");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int		ret;
> +	long		l;
> +	unsigned int	i;
> +	unsigned int	passed = 0;
> +
> +	if (argc != 3) {
> +		printf("Usage: %s filename iterations\n", argv[0]);
> +		return 1;
> +	}
> +
> +	errno = 0;
> +	l = strtol(argv[2], NULL, 0);
> +	if (errno) {
> +		perror(argv[2]);
> +		return 1;
> +	}
> +	if (l < 1 || l > UINT_MAX) {
> +		fprintf(stderr, "%ld: must be between 1 and %u.\n",
> +				l, UINT_MAX);
> +		return 1;
> +	}
> +
> +	for (i = 0; i < l; i++) {
> +		ret = test(argv[1], i, &passed);
> +		if (ret)
> +			return 1;
> +	}
> +
> +	printf("pass rate: %u/%u (%.2f%%)\n", passed, i, 100.0 * passed / i);
> +
> +	return 0;
> +}
> diff --git a/tests/generic/722 b/tests/generic/722
> new file mode 100755
> index 00000000..937abf36
> --- /dev/null
> +++ b/tests/generic/722
> @@ -0,0 +1,43 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 722
> +#
> +# Race an appending aio dio write to the second block of a file while
> +# simultaneously fallocating to the first block.  Make sure that we end up
> +# with a two-block file.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.* $testfile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs generic
> +_require_aiodio "aio-dio-append-write-fallocate-race"
> +_require_test

Also added

_require_xfs_io_command "falloc"

Thanks,
Eryu

> +
> +rm -f $seqres.full
> +
> +testfile=$TEST_DIR/test-$seq
> +$AIO_TEST $testfile 100 >> $seqres.full
> +
> +echo Silence is golden.
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/722.out b/tests/generic/722.out
> new file mode 100644
> index 00000000..8621a87d
> --- /dev/null
> +++ b/tests/generic/722.out
> @@ -0,0 +1,2 @@
> +QA output created by 722
> +Silence is golden.
> diff --git a/tests/generic/group b/tests/generic/group
> index e5d0c1da..308f86f2 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -588,3 +588,4 @@
>  583 auto quick encrypt
>  584 auto quick encrypt
>  585 auto rename
> +722 auto quick rw falloc
