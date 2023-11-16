Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C57C197A0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 07:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjKPHb6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 02:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjKPHb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 02:31:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52108AD
        for <linux-xfs@vger.kernel.org>; Wed, 15 Nov 2023 23:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700119911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xhnvVtFWDMtZ47f0eEZqUbqpwChXvBPtjcx/Fx2NtoQ=;
        b=BBf9HlQLbFqyrmTgsU/v2WjyJZp1KLJBqxNcciV8Qvoc4uHEfaQpmDBtv5qmTfEU2CLSiW
        XqjNzZUSy/cdDzQsZCbiU4hwE7VjYd2Tup/R31ezTm1+ax/JGm9wMcoe7po6RoDom1Lgof
        y5Hz9n5mWi+GAE8ZdOGdhVlR7oH53zU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-dv_YrY4hNIGdxcAXaChZeA-1; Thu, 16 Nov 2023 02:31:49 -0500
X-MC-Unique: dv_YrY4hNIGdxcAXaChZeA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1cc385e90e2so6778825ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 15 Nov 2023 23:31:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700119907; x=1700724707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xhnvVtFWDMtZ47f0eEZqUbqpwChXvBPtjcx/Fx2NtoQ=;
        b=hNwMYVAPfXcaXwrw2VPMuD6qOq49lWwqHovDD8f1V5c17S6jhIQe7bBvJS9xqb0Lc/
         zE8a7QpRcTMKql5MZzs6YpowIRrr9X+V5fvhe1+nY4NnRymUa2TdQXSOaSkr2dxprDDt
         ijuKSAfhSprp6mfSkqV6avflAhTpebL83ilRbXCf0b+9od3cgs3MGLIed9j+YbE6VBc0
         HcmhHmI4DzbNDwBCfxcPgFR5lztsaqCDEnNYOtTM5lhk6qu9PeBF/iwxuRnEBU7HTd3m
         JVBFDr9+RLRLKZWH3UCS82ySjMEQ2O9xtbyGBfJhQYVnMoluu+o1cV4rypKq27Torw7i
         t/lA==
X-Gm-Message-State: AOJu0YyQucD8/rrugbgYxqM4kh9HxF2t7Bc3l+C8eFqxMhB3CycQTtoQ
        dMaM32vU5prPjBVFxKeJitboMeEdggU8Q4sdfMqaXmsUi8B1/rNt3i74alq6sUVYX6Wr61H4v51
        4oiL8EPUXpmKeKX/HlDoJ839/hq0L
X-Received: by 2002:a17:902:d2c1:b0:1cc:251c:c381 with SMTP id n1-20020a170902d2c100b001cc251cc381mr8257667plc.29.1700119907447;
        Wed, 15 Nov 2023 23:31:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwDJs/WodUp/zz9MRtEM0jP0Dqm8AUmMf9zC7U2xlivT+X/X21GPfAQXeDNmbGKmOmAzB9OQ==
X-Received: by 2002:a17:902:d2c1:b0:1cc:251c:c381 with SMTP id n1-20020a170902d2c100b001cc251cc381mr8257653plc.29.1700119907073;
        Wed, 15 Nov 2023 23:31:47 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902740a00b001cc1dff5b86sm8512933pll.244.2023.11.15.23.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 23:31:46 -0800 (PST)
Date:   Thu, 16 Nov 2023 15:31:42 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] generic: test reads racing with slow reflink
 operations
Message-ID: <20231116073142.qlu4cy54siv2ooms@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <169989531418.1034466.15629933501843921475.stgit@frogsfrogsfrogs>
 <169989531989.1034466.10430740786795917744.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169989531989.1034466.10430740786795917744.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 13, 2023 at 09:08:39AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS has a rather slow reflink operation.  While a reflink operation is
> running, other programs cannot read the contents of the source file,
> which is causing latency spikes.  Catherine Hoang wrote a patch to
> permit reads, since the source file contents do not change.  This is a
> functionality test for that patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---

Thanks Darrick, this version looks good to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  configure.ac              |    1 
>  include/builddefs.in      |    1 
>  m4/package_libcdev.m4     |   13 ++
>  src/Makefile              |    4 +
>  src/t_reflink_read_race.c |  339 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1953        |   75 ++++++++++
>  tests/generic/1953.out    |    6 +
>  7 files changed, 439 insertions(+)
>  create mode 100644 src/t_reflink_read_race.c
>  create mode 100755 tests/generic/1953
>  create mode 100644 tests/generic/1953.out
> 
> 
> diff --git a/configure.ac b/configure.ac
> index 4687d8a3c0..7333045330 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -71,6 +71,7 @@ AC_HAVE_BMV_OF_SHARED
>  AC_HAVE_NFTW
>  AC_HAVE_RLIMIT_NOFILE
>  AC_HAVE_FIEXCHANGE
> +AC_HAVE_FICLONE
>  
>  AC_CHECK_FUNCS([renameat2])
>  AC_CHECK_FUNCS([reallocarray])
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 969acf0da2..446350d5fc 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -73,6 +73,7 @@ HAVE_NFTW = @have_nftw@
>  HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
>  HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
>  HAVE_FIEXCHANGE = @have_fiexchange@
> +HAVE_FICLONE = @have_ficlone@
>  
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 7f73104405..0f4b8063f3 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -174,3 +174,16 @@ AC_DEFUN([AC_HAVE_FIEXCHANGE],
>         AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
>      AC_SUBST(have_fiexchange)
>    ])
> +
> +# Check if we have FICLONE
> +AC_DEFUN([AC_HAVE_FICLONE],
> +  [ AC_MSG_CHECKING([for FICLONE])
> +    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
> +#include <sys/ioctl.h>
> +#include <linux/fs.h>
> +    ]], [[
> +	 ioctl(-1, FICLONE, -1);
> +    ]])],[have_ficlone=yes
> +       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
> +    AC_SUBST(have_ficlone)
> +  ])
> diff --git a/src/Makefile b/src/Makefile
> index 2815f919b2..49dd2f6c1e 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -94,6 +94,10 @@ ifeq ($(HAVE_SEEK_DATA), yes)
>   endif
>  endif
>  
> +ifeq ($(HAVE_FICLONE),yes)
> +     TARGETS += t_reflink_read_race
> +endif
> +
>  CFILES = $(TARGETS:=.c)
>  LDIRT = $(TARGETS) fssum
>  
> diff --git a/src/t_reflink_read_race.c b/src/t_reflink_read_race.c
> new file mode 100644
> index 0000000000..00c19d7c05
> --- /dev/null
> +++ b/src/t_reflink_read_race.c
> @@ -0,0 +1,339 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Race reads with reflink to see if reads continue while we're cloning.
> + * Copyright 2023 Oracle.  All rights reserved.
> + */
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/ioctl.h>
> +#include <linux/fs.h>
> +#include <time.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <signal.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <stdio.h>
> +#include <errno.h>
> +#include <string.h>
> +
> +static pid_t mypid;
> +
> +static FILE *outcome_fp;
> +
> +/* Significant timestamps.  Initialized to zero */
> +static double program_start, clone_start, clone_end;
> +
> +/* Coordinates access to timestamps */
> +static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
> +
> +struct readinfo {
> +	int fd;
> +	unsigned int blocksize;
> +	char *descr;
> +};
> +
> +struct cloneinfo {
> +	int src_fd, dst_fd;
> +};
> +
> +#define MSEC_PER_SEC	1000
> +#define NSEC_PER_MSEC	1000000
> +
> +/*
> + * Assume that it shouldn't take longer than 100ms for the FICLONE ioctl to
> + * enter the kernel and take locks on an uncontended file.  This is also the
> + * required CLOCK_MONOTONIC granularity.
> + */
> +#define EARLIEST_READ_MS	(MSEC_PER_SEC / 10)
> +
> +/*
> + * We want to be reasonably sure that the FICLONE takes long enough that any
> + * read initiated after clone operation locked the source file could have
> + * completed a disk IO before the clone finishes.  Therefore, we require that
> + * the clone operation must take at least 4x the maximum setup time.
> + */
> +#define MINIMUM_CLONE_MS	(EARLIEST_READ_MS * 5)
> +
> +static double timespec_to_msec(const struct timespec *ts)
> +{
> +	return (ts->tv_sec * (double)MSEC_PER_SEC) +
> +	       (ts->tv_nsec / (double)NSEC_PER_MSEC);
> +}
> +
> +static void sleep_ms(unsigned int len)
> +{
> +	struct timespec time = {
> +		.tv_nsec = len * NSEC_PER_MSEC,
> +	};
> +
> +	nanosleep(&time, NULL);
> +}
> +
> +static void outcome(const char *str)
> +{
> +	fprintf(outcome_fp, "%s\n", str);
> +	fflush(outcome_fp);
> +}
> +
> +static void *reader_fn(void *arg)
> +{
> +	struct timespec now;
> +	struct readinfo *ri = arg;
> +	char *buf = malloc(ri->blocksize);
> +	loff_t pos = 0;
> +	ssize_t copied;
> +	int ret;
> +
> +	if (!buf) {
> +		perror("alloc buffer");
> +		goto kill_error;
> +	}
> +
> +	/* Wait for the FICLONE to start */
> +	pthread_mutex_lock(&lock);
> +	while (clone_start < program_start) {
> +		pthread_mutex_unlock(&lock);
> +#ifdef DEBUG
> +		printf("%s read waiting for clone to start; cs=%.2f ps=%.2f\n",
> +				ri->descr, clone_start, program_start);
> +		fflush(stdout);
> +#endif
> +		sleep_ms(1);
> +		pthread_mutex_lock(&lock);
> +	}
> +	pthread_mutex_unlock(&lock);
> +	sleep_ms(EARLIEST_READ_MS);
> +
> +	/* Read from the file... */
> +	while ((copied = read(ri->fd, buf, ri->blocksize)) > 0) {
> +		double read_completion;
> +
> +		ret = clock_gettime(CLOCK_MONOTONIC, &now);
> +		if (ret) {
> +			perror("clock_gettime");
> +			goto kill_error;
> +		}
> +		read_completion = timespec_to_msec(&now);
> +
> +		/*
> +		 * If clone_end is still zero, the FICLONE is still running.
> +		 * If the read completion occurred a safe duration after the
> +		 * start of the ioctl, then report that as an early read
> +		 * completion.
> +		 */
> +		pthread_mutex_lock(&lock);
> +		if (clone_end < program_start &&
> +		    read_completion > clone_start + EARLIEST_READ_MS) {
> +			pthread_mutex_unlock(&lock);
> +
> +			/* clone still running... */
> +			printf("finished %s read early at %.2fms\n",
> +					ri->descr,
> +					read_completion - program_start);
> +			fflush(stdout);
> +			outcome("finished read early");
> +			goto kill_done;
> +		}
> +		pthread_mutex_unlock(&lock);
> +
> +		sleep_ms(1);
> +		pos += copied;
> +	}
> +	if (copied < 0) {
> +		perror("read");
> +		goto kill_error;
> +	}
> +
> +	return NULL;
> +kill_error:
> +	outcome("reader error");
> +kill_done:
> +	kill(mypid, SIGTERM);
> +	return NULL;
> +}
> +
> +static void *clone_fn(void *arg)
> +{
> +	struct timespec now;
> +	struct cloneinfo *ci = arg;
> +	int ret;
> +
> +	/* Record the approximate start time of this thread */
> +	ret = clock_gettime(CLOCK_MONOTONIC, &now);
> +	if (ret) {
> +		perror("clock_gettime clone start");
> +		goto kill_error;
> +	}
> +	pthread_mutex_lock(&lock);
> +	clone_start = timespec_to_msec(&now);
> +	pthread_mutex_unlock(&lock);
> +
> +	printf("started clone at %.2fms\n", clone_start - program_start);
> +	fflush(stdout);
> +
> +	/* Kernel call, only killable with a fatal signal */
> +	ret = ioctl(ci->dst_fd, FICLONE, ci->src_fd);
> +	if (ret) {
> +		perror("FICLONE");
> +		goto kill_error;
> +	}
> +
> +	/* If the ioctl completes, note the completion time */
> +	ret = clock_gettime(CLOCK_MONOTONIC, &now);
> +	if (ret) {
> +		perror("clock_gettime clone end");
> +		goto kill_error;
> +	}
> +
> +	pthread_mutex_lock(&lock);
> +	clone_end = timespec_to_msec(&now);
> +	pthread_mutex_unlock(&lock);
> +
> +	printf("finished clone at %.2fms\n",
> +			clone_end - program_start);
> +	fflush(stdout);
> +
> +	/* Complain if we didn't take long enough to clone. */
> +	if (clone_end < clone_start + MINIMUM_CLONE_MS) {
> +		printf("clone did not take enough time (%.2fms)\n",
> +				clone_end - clone_start);
> +		fflush(stdout);
> +		outcome("clone too fast");
> +		goto kill_done;
> +	}
> +
> +	outcome("clone finished before any reads");
> +	goto kill_done;
> +
> +kill_error:
> +	outcome("clone error");
> +kill_done:
> +	kill(mypid, SIGTERM);
> +	return NULL;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct cloneinfo ci;
> +	struct readinfo bufio = { .descr = "buffered" };
> +	struct readinfo directio = { .descr = "directio" };
> +	struct timespec now;
> +	pthread_t clone_thread, bufio_thread, directio_thread;
> +	double clockres;
> +	int ret;
> +
> +	if (argc != 4) {
> +		printf("Usage: %s src_file dst_file outcome_file\n", argv[0]);
> +		return 1;
> +	}
> +
> +	mypid = getpid();
> +
> +	/* Check for sufficient clock precision. */
> +	ret = clock_getres(CLOCK_MONOTONIC, &now);
> +	if (ret) {
> +		perror("clock_getres MONOTONIC");
> +		return 2;
> +	}
> +	printf("CLOCK_MONOTONIC resolution: %llus %luns\n",
> +			(unsigned long long)now.tv_sec,
> +			(unsigned long)now.tv_nsec);
> +	fflush(stdout);
> +
> +	clockres = timespec_to_msec(&now);
> +	if (clockres > EARLIEST_READ_MS) {
> +		fprintf(stderr, "insufficient CLOCK_MONOTONIC resolution\n");
> +		return 2;
> +	}
> +
> +	/*
> +	 * Measure program start time since the MONOTONIC time base is not
> +	 * all that well defined.
> +	 */
> +	ret = clock_gettime(CLOCK_MONOTONIC, &now);
> +	if (ret) {
> +		perror("clock_gettime MONOTONIC");
> +		return 2;
> +	}
> +	if (now.tv_sec == 0 && now.tv_nsec == 0) {
> +		fprintf(stderr, "Uhoh, start time is zero?!\n");
> +		return 2;
> +	}
> +	program_start = timespec_to_msec(&now);
> +
> +	outcome_fp = fopen(argv[3], "w");
> +	if (!outcome_fp) {
> +		perror(argv[3]);
> +		return 2;
> +	}
> +
> +	/* Open separate fds for each thread */
> +	ci.src_fd = open(argv[1], O_RDONLY);
> +	if (ci.src_fd < 0) {
> +		perror(argv[1]);
> +		return 2;
> +	}
> +
> +	ci.dst_fd = open(argv[2], O_RDWR | O_CREAT, 0600);
> +	if (ci.dst_fd < 0) {
> +		perror(argv[2]);
> +		return 2;
> +	}
> +
> +	bufio.fd = open(argv[1], O_RDONLY);
> +	if (bufio.fd < 0) {
> +		perror(argv[1]);
> +		return 2;
> +	}
> +	bufio.blocksize = 37;
> +
> +	directio.fd = open(argv[1], O_RDONLY | O_DIRECT);
> +	if (directio.fd < 0) {
> +		perror(argv[1]);
> +		return 2;
> +	}
> +	directio.blocksize = 512;
> +
> +	/* Start threads */
> +	ret = pthread_create(&clone_thread, NULL, clone_fn, &ci);
> +	if (ret) {
> +		fprintf(stderr, "create clone thread: %s\n", strerror(ret));
> +		return 2;
> +	}
> +
> +	ret = pthread_create(&bufio_thread, NULL, reader_fn, &bufio);
> +	if (ret) {
> +		fprintf(stderr, "create bufio thread: %s\n", strerror(ret));
> +		return 2;
> +	}
> +
> +	ret = pthread_create(&directio_thread, NULL, reader_fn, &directio);
> +	if (ret) {
> +		fprintf(stderr, "create directio thread: %s\n", strerror(ret));
> +		return 2;
> +	}
> +
> +	/* Wait for threads */
> +	ret = pthread_join(clone_thread, NULL);
> +	if (ret) {
> +		fprintf(stderr, "join clone thread: %s\n", strerror(ret));
> +		return 2;
> +	}
> +
> +	ret = pthread_join(bufio_thread, NULL);
> +	if (ret) {
> +		fprintf(stderr, "join bufio thread: %s\n", strerror(ret));
> +		return 2;
> +	}
> +
> +	ret = pthread_join(directio_thread, NULL);
> +	if (ret) {
> +		fprintf(stderr, "join directio thread: %s\n", strerror(ret));
> +		return 2;
> +	}
> +
> +	printf("Program should have killed itself?\n");
> +	outcome("program failed to end early");
> +	return 0;
> +}
> diff --git a/tests/generic/1953 b/tests/generic/1953
> new file mode 100755
> index 0000000000..c14de7060d
> --- /dev/null
> +++ b/tests/generic/1953
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 1953
> +#
> +# Race file reads with a very slow reflink operation to see if the reads
> +# actually complete while the reflink is ongoing.  This is a functionality
> +# test for XFS commit f3ba4762fa56 "xfs: allow read IO and FICLONE to run
> +# concurrently".
> +#
> +. ./common/preamble
> +_begin_fstest auto clone punch
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +. ./common/reflink
> +
> +# real QA test starts here
> +_require_scratch_reflink
> +_require_cp_reflink
> +_require_xfs_io_command "fpunch"
> +_require_test_program "punch-alternating"
> +_require_test_program "t_reflink_read_race"
> +_require_command "$TIMEOUT_PROG" timeout
> +
> +rm -f "$seqres.full"
> +
> +echo "Format and mount"
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount >> "$seqres.full" 2>&1
> +
> +testdir="$SCRATCH_MNT/test-$seq"
> +mkdir "$testdir"
> +
> +calc_space() {
> +	blocks_needed=$(( 2 ** (fnr + 1) ))
> +	space_needed=$((blocks_needed * blksz * 5 / 4))
> +}
> +
> +# Figure out the number of blocks that we need to get the reflink runtime above
> +# 1 seconds
> +echo "Create a many-block file"
> +for ((fnr = 1; fnr < 40; fnr++)); do
> +	free_blocks=$(stat -f -c '%a' "$testdir")
> +	blksz=$(_get_file_block_size "$testdir")
> +	space_avail=$((free_blocks * blksz))
> +	calc_space
> +	test $space_needed -gt $space_avail && \
> +		_notrun "Insufficient space for stress test; would only create $blocks_needed extents."
> +
> +	off=$(( (2 ** fnr) * blksz))
> +	$XFS_IO_PROG -f -c "pwrite -S 0x61 -b 4194304 $off $off" "$testdir/file1" >> "$seqres.full"
> +	"$here/src/punch-alternating" "$testdir/file1" >> "$seqres.full"
> +
> +	$TIMEOUT_PROG 1s cp --reflink=always "$testdir/file1" "$testdir/garbage" || break
> +done
> +echo "fnr=$fnr" >> $seqres.full
> +
> +echo "Reflink the big file"
> +$here/src/t_reflink_read_race "$testdir/file1" "$testdir/file2" \
> +	"$testdir/outcome" &>> $seqres.full
> +
> +if [ ! -e "$testdir/outcome" ]; then
> +	echo "Could not set up program"
> +elif grep -q "finished read early" "$testdir/outcome"; then
> +	echo "test completed successfully"
> +else
> +	cat "$testdir/outcome"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1953.out b/tests/generic/1953.out
> new file mode 100644
> index 0000000000..8eaacb7ff0
> --- /dev/null
> +++ b/tests/generic/1953.out
> @@ -0,0 +1,6 @@
> +QA output created by 1953
> +Format and mount
> +Create a many-block file
> +Reflink the big file
> +Terminated
> +test completed successfully
> 

