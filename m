Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F368C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 07:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65ED764F85
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 07:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCLHN0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhCLHNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 02:13:08 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F74C061574;
        Thu, 11 Mar 2021 23:13:08 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id l7so1243892pfd.3;
        Thu, 11 Mar 2021 23:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Deub4AFyXBYQklPVU+9uf1fLTNFE6bVlnu3g/rETSuY=;
        b=WmC1lgrOcANKjPKridG1nYQGgvJkPoosXQg6G/AQ/Lln5KF/+hRh7Q9a+ZA0cCS/ft
         EepKe2lZLRKMPcO1FQ1yY0X5SvqHSRjl2YF+0sOhvKEJodaJUR/2Yp1gs6go64v09lxo
         zGUxKN1egmvLojQe3y7mMfUcXCocZOj0BQAIDHc3NuF3AhuTwGbHyJdUQb8OKRUrtVAR
         e9RRqcX/OYfa5FugcYX/PpTESEnVIApeHRgyg80N9TrcMj7LuETS9qK+sf59MGo02/NJ
         KuoZ5WVnYbqt/ZSM6GppmWjn9LqcThqd6LO/DSEuYWtT4dfhPkhZz66FdYDRpf3L4/cQ
         vogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Deub4AFyXBYQklPVU+9uf1fLTNFE6bVlnu3g/rETSuY=;
        b=RqMLFaXRX+24jbzjkMixjT0tUg8RIPqguh5M0/KT2LpER8p6PcfMRX0Zcc1IErW5/n
         3tI7hdt5PbZFeZ3QYGWLMukHsYPbs+Xo0LGXXLUGhH9CUaqkWJYMGdjST3FSR4H7VKgz
         Cr14Ko3mOI0uyT+S/lYQGv8ng8ILcoaUkIOZw0VHrfZbNJW9IfUgsB1aaXei59uJT5V+
         GMxzK2adMDtQr9qBRmjGUJc+YR/FVqowv30eRTO6HqTe3jeRl9D/z1f7gfvHAWkG2SAE
         FAPnncZSPwq7knjoCDHFXY9it8JCo9T8+4FLeD1qzH9f6MkY9VAIYjYjo8IRUl3jXd2o
         gzaA==
X-Gm-Message-State: AOAM533/SpHf0Vgl1kfUQWpWEh1aevnsEhsO3c7dhjlKwSCqWi81I+Qv
        3GgdxMxfcBGRWyA1DD6PhBjiipOTc8k=
X-Google-Smtp-Source: ABdhPJwZtWJTIBIVl9YPbCDXC0ItQ/vwvtrNvePTiBpbylcWIyfImgiPyGBscP3l/kR1TcXmGkPABQ==
X-Received: by 2002:a63:724a:: with SMTP id c10mr10689819pgn.124.1615533188095;
        Thu, 11 Mar 2021 23:13:08 -0800 (PST)
Received: from garuda ([122.179.18.33])
        by smtp.gmail.com with ESMTPSA id gk12sm1237894pjb.44.2021.03.11.23.13.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Mar 2021 23:13:07 -0800 (PST)
References: <161526480371.1214319.3263690953532787783.stgit@magnolia> <161526484769.1214319.11110389021630982078.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 08/10] generic: test file writers racing with FIDEDUPERANGE
In-reply-to: <161526484769.1214319.11110389021630982078.stgit@magnolia>
Date:   Fri, 12 Mar 2021 12:43:03 +0530
Message-ID: <87h7lgoneo.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09 Mar 2021 at 10:10, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Create a test to make sure that dedupe actually locks the file ranges
> correctly before starting the content comparison and keeps them locked
> until the operation completes.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  src/Makefile          |    2 
>  src/deduperace.c      |  370 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/949     |   51 +++++++
>  tests/generic/949.out |    2 
>  tests/generic/group   |    1 
>  5 files changed, 425 insertions(+), 1 deletion(-)
>  create mode 100644 src/deduperace.c
>  create mode 100755 tests/generic/949
>  create mode 100644 tests/generic/949.out
>
>
> diff --git a/src/Makefile b/src/Makefile
> index 811b24e4..38ee6718 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -21,7 +21,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> -	locktest unwritten_mmap bulkstat_unlink_test \
> +	locktest unwritten_mmap bulkstat_unlink_test deduperace \
>  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
>  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
>  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
> diff --git a/src/deduperace.c b/src/deduperace.c
> new file mode 100644
> index 00000000..b252d436
> --- /dev/null
> +++ b/src/deduperace.c
> @@ -0,0 +1,370 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (c) 2021 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <djwong@kernel.org>
> + *
> + * Race pwrite/mwrite with dedupe to see if we got the locking right.
> + *
> + * File writes and mmap writes should not be able to change the src_fd's
> + * contents after dedupe prep has verified that the file contents are the same.
> + */
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/mman.h>
> +#include <sys/ioctl.h>
> +#include <linux/fs.h>
> +#include <string.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +
> +#define GOOD_BYTE		0x58
> +#define BAD_BYTE		0x66
> +
> +#ifndef FIDEDUPERANGE
> +/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
> +#define FILE_DEDUPE_RANGE_SAME		0
> +#define FILE_DEDUPE_RANGE_DIFFERS	1
> +
> +/* from struct btrfs_ioctl_file_extent_same_info */
> +struct file_dedupe_range_info {
> +	__s64 dest_fd;		/* in - destination file */
> +	__u64 dest_offset;	/* in - start of extent in destination */
> +	__u64 bytes_deduped;	/* out - total # of bytes we were able
> +				 * to dedupe from this file. */
> +	/* status of this dedupe operation:
> +	 * < 0 for error
> +	 * == FILE_DEDUPE_RANGE_SAME if dedupe succeeds
> +	 * == FILE_DEDUPE_RANGE_DIFFERS if data differs
> +	 */
> +	__s32 status;		/* out - see above description */
> +	__u32 reserved;		/* must be zero */
> +};
> +
> +/* from struct btrfs_ioctl_file_extent_same_args */
> +struct file_dedupe_range {
> +	__u64 src_offset;	/* in - start of extent in source */
> +	__u64 src_length;	/* in - length of extent */
> +	__u16 dest_count;	/* in - total elements in info array */
> +	__u16 reserved1;	/* must be zero */
> +	__u32 reserved2;	/* must be zero */
> +	struct file_dedupe_range_info info[0];
> +};
> +#define FIDEDUPERANGE	_IOWR(0x94, 54, struct file_dedupe_range)
> +#endif /* FIDEDUPERANGE */
> +
> +static int fd1, fd2;
> +static loff_t offset = 37; /* Nice low offset to trick the compare */
> +static loff_t blksz;
> +
> +/* Continuously dirty the pagecache for the region being dupe-tested. */
> +void *
> +mwriter(
> +	void		*data)
> +{
> +	volatile char	*p;
> +
> +	p = mmap(NULL, blksz, PROT_WRITE, MAP_SHARED, fd1, 0);
> +	if (p == MAP_FAILED) {
> +		perror("mmap");
> +		exit(2);
> +	}
> +
> +	while (1) {
> +		*(p + offset) = BAD_BYTE;
> +		*(p + offset) = GOOD_BYTE;
> +	}
> +}
> +
> +/* Continuously write to the region being dupe-tested. */
> +void *
> +pwriter(
> +	void		*data)
> +{
> +	char		v;
> +	ssize_t		sz;
> +
> +	while (1) {
> +		v = BAD_BYTE;
> +		sz = pwrite(fd1, &v, sizeof(v), offset);
> +		if (sz != sizeof(v)) {
> +			perror("pwrite0");
> +			exit(2);
> +		}
> +
> +		v = GOOD_BYTE;
> +		sz = pwrite(fd1, &v, sizeof(v), offset);
> +		if (sz != sizeof(v)) {
> +			perror("pwrite1");
> +			exit(2);
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static inline void
> +complain(
> +	loff_t	offset,
> +	char	bad)
> +{
> +	fprintf(stderr, "ASSERT: offset %llu should be 0x%x, got 0x%x!\n",
> +			(unsigned long long)offset, GOOD_BYTE, bad);
> +	abort();
> +}
> +
> +/* Make sure the destination file pagecache never changes. */
> +void *
> +mreader(
> +	void		*data)
> +{
> +	volatile char	*p;
> +
> +	p = mmap(NULL, blksz, PROT_READ, MAP_SHARED, fd2, 0);
> +	if (p == MAP_FAILED) {
> +		perror("mmap");
> +		exit(2);
> +	}
> +
> +	while (1) {
> +		if (*(p + offset) != GOOD_BYTE)
> +			complain(offset, *(p + offset));
> +	}
> +}
> +
> +/* Make sure the destination file never changes. */
> +void *
> +preader(
> +	void		*data)
> +{
> +	char		v;
> +	ssize_t		sz;
> +
> +	while (1) {
> +		sz = pread(fd2, &v, sizeof(v), offset);
> +		if (sz != sizeof(v)) {
> +			perror("pwrite0");
> +			exit(2);
> +		}
> +
> +		if (v != GOOD_BYTE)
> +			complain(offset, v);
> +	}
> +
> +	return NULL;
> +}
> +
> +void
> +print_help(const char *progname)
> +{
> +	printf("Usage: %s [-b blksz] [-c dir] [-n nr_ops] [-o offset] [-r] [-w] [-v]\n",
> +			progname);
> +	printf("-b sets the block size (default is autoconfigured)\n");
> +	printf("-c chdir to this path before starting\n");
> +	printf("-n controls the number of dedupe ops (default 10000)\n");
> +	printf("-o reads and writes to this offset (default 37)\n");
> +	printf("-r uses pread instead of mmap read.\n");
> +	printf("-v prints status updates.\n");
> +	printf("-w uses pwrite instead of mmap write.\n");
> +}
> +
> +int
> +main(
> +	int		argc,
> +	char		*argv[])
> +{
> +	struct file_dedupe_range *fdr;
> +	char		*Xbuf;
> +	void		*(*reader_fn)(void *) = mreader;
> +	void		*(*writer_fn)(void *) = mwriter;
> +	unsigned long	same = 0;
> +	unsigned long	differs = 0;
> +	unsigned long	i, nr_ops = 10000;
> +	ssize_t		sz;
> +	pthread_t	reader, writer;
> +	int		verbose = 0;
> +	int		c;
> +	int		ret;
> +
> +	while ((c = getopt(argc, argv, "b:c:n:o:rvw")) != -1) {
> +		switch (c) {
> +		case 'b':
> +			errno = 0;
> +			blksz = strtoul(optarg, NULL, 0);
> +			if (errno) {
> +				perror(optarg);
> +				exit(1);
> +			}
> +			break;
> +		case 'c':
> +			ret = chdir(optarg);
> +			if (ret) {
> +				perror("chdir");
> +				exit(1);
> +			}
> +			break;
> +		case 'n':
> +			errno = 0;
> +			nr_ops = strtoul(optarg, NULL, 0);
> +			if (errno) {
> +				perror(optarg);
> +				exit(1);
> +			}
> +			break;
> +		case 'o':
> +			errno = 0;
> +			offset = strtoul(optarg, NULL, 0);
> +			if (errno) {
> +				perror(optarg);
> +				exit(1);
> +			}
> +			break;
> +		case 'r':
> +			reader_fn = preader;
> +			break;
> +		case 'v':
> +			verbose = 1;
> +			break;
> +		case 'w':
> +			writer_fn = pwriter;
> +			break;
> +		default:
> +			print_help(argv[0]);
> +			exit(1);
> +			break;
> +		}
> +	}
> +
> +	fdr = malloc(sizeof(struct file_dedupe_range) +
> +			sizeof(struct file_dedupe_range_info));
> +	if (!fdr) {
> +		perror("malloc");
> +		exit(1);
> +	}
> +
> +	/* Initialize both files. */
> +	fd1 = open("file1", O_RDWR | O_CREAT | O_TRUNC | O_NOATIME, 0600);
> +	if (fd1 < 0) {
> +		perror("file1");
> +		exit(1);
> +	}
> +
> +	fd2 = open("file2", O_RDWR | O_CREAT | O_TRUNC | O_NOATIME, 0600);
> +	if (fd2 < 0) {
> +		perror("file2");
> +		exit(1);
> +	}
> +
> +	if (blksz <= 0) {
> +		struct stat	statbuf;
> +
> +		ret = fstat(fd1, &statbuf);
> +		if (ret) {
> +			perror("file1 stat");
> +			exit(1);
> +		}
> +		blksz = statbuf.st_blksize;
> +	}
> +
> +	if (offset >= blksz) {
> +		fprintf(stderr, "offset (%llu) < blksz (%llu)?\n",
> +				(unsigned long long)offset,
> +				(unsigned long long)blksz);
> +		exit(1);
> +	}
> +
> +	Xbuf = malloc(blksz);
> +	if (!Xbuf) {
> +		perror("malloc buffer");
> +		exit(1);
> +	}
> +	memset(Xbuf, GOOD_BYTE, blksz);
> +
> +	sz = pwrite(fd1, Xbuf, blksz, 0);
> +	if (sz != blksz) {
> +		perror("file1 write");
> +		exit(1);
> +	}
> +
> +	sz = pwrite(fd2, Xbuf, blksz, 0);
> +	if (sz != blksz) {
> +		perror("file2 write");
> +		exit(1);
> +	}
> +
> +	ret = fsync(fd1);
> +	if (ret) {
> +		perror("file1 fsync");
> +		exit(1);
> +	}
> +
> +	ret = fsync(fd2);
> +	if (ret) {
> +		perror("file2 fsync");
> +		exit(1);
> +	}
> +
> +	/* Start our reader and writer threads. */
> +	ret = pthread_create(&reader, NULL, reader_fn, NULL);
> +	if (ret) {
> +		fprintf(stderr, "rthread: %s\n", strerror(ret));
> +		exit(1);
> +	}
> +
> +	ret = pthread_create(&writer, NULL, writer_fn, NULL);
> +	if (ret) {
> +		fprintf(stderr, "wthread: %s\n", strerror(ret));
> +		exit(1);
> +	}
> +
> +	/*
> +	 * Now start deduping.  If the contents match, fd1's blocks will be
> +	 * remapped into fd2, which is why the writer thread targets fd1 and
> +	 * the reader checks fd2 to make sure that none of fd1's writes ever
> +	 * make it into fd2.
> +	 */
> +	for (i = 1; i <= nr_ops; i++) {
> +		fdr->src_offset = 0;
> +		fdr->src_length = blksz;
> +		fdr->dest_count = 1;
> +		fdr->reserved1 = 0;
> +		fdr->reserved2 = 0;
> +		fdr->info[0].dest_fd = fd2;
> +		fdr->info[0].dest_offset = 0;
> +		fdr->info[0].reserved = 0;
> +
> +		ret = ioctl(fd1, FIDEDUPERANGE, fdr);
> +		if (ret) {
> +			perror("dedupe");
> +			exit(2);
> +		}
> +
> +		switch (fdr->info[0].status) {
> +		case FILE_DEDUPE_RANGE_DIFFERS:
> +			differs++;
> +			break;
> +		case FILE_DEDUPE_RANGE_SAME:
> +			same++;
> +			break;
> +		default:
> +			fprintf(stderr, "deduperange: %s\n",
> +					strerror(-fdr->info[0].status));
> +			exit(2);
> +			break;
> +		}
> +
> +		if (verbose && (i % 337) == 0)
> +			printf("nr_ops: %lu; same: %lu; differs: %lu\n",
> +					i, same, differs);
> +	}
> +
> +	if (verbose)
> +		printf("nr_ops: %lu; same: %lu; differs: %lu\n", i - 1, same,
> +				differs);
> +
> +	/* Program termination will kill the threads and close the files. */
> +	return 0;
> +}
> diff --git a/tests/generic/949 b/tests/generic/949
> new file mode 100755
> index 00000000..3951490b
> --- /dev/null
> +++ b/tests/generic/949
> @@ -0,0 +1,51 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 949
> +#
> +# Make sure that mmap and file writers racing with FIDEDUPERANGE cannot write
> +# to the file after the dedupe prep function has decided that the file contents
> +# are identical and we can therefore go ahead with the remapping.
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
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/reflink
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch_dedupe
> +
> +rm -f $seqres.full
> +
> +nr_ops=$((TIME_FACTOR * 10000))
> +
> +# Format filesystem
> +_scratch_mkfs > $seqres.full
> +_scratch_mount
> +
> +# Test once with mmap writes
> +$here/src/deduperace -c $SCRATCH_MNT -n $nr_ops
> +
> +# Test again with pwrites for the lulz
> +$here/src/deduperace -c $SCRATCH_MNT -n $nr_ops -w
> +
> +echo Silence is golden.
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/949.out b/tests/generic/949.out
> new file mode 100644
> index 00000000..2998b46c
> --- /dev/null
> +++ b/tests/generic/949.out
> @@ -0,0 +1,2 @@
> +QA output created by 949
> +Silence is golden.
> diff --git a/tests/generic/group b/tests/generic/group
> index d5cfdd51..778aa8c4 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -630,3 +630,4 @@
>  625 auto quick verity
>  947 auto quick rw clone
>  948 auto quick rw copy_range
> +949 auto quick rw dedupe clone


-- 
chandan
