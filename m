Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3040EC433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Jan 2022 07:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiAPHNB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 Jan 2022 02:13:01 -0500
Received: from out20-63.mail.aliyun.com ([115.124.20.63]:52537 "EHLO
        out20-63.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiAPHNB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Jan 2022 02:13:01 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436283|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.108821-0.00507935-0.886099;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.MdoCgde_1642317178;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.MdoCgde_1642317178)
          by smtp.aliyun-inc.com(10.147.41.199);
          Sun, 16 Jan 2022 15:12:59 +0800
Date:   Sun, 16 Jan 2022 15:12:58 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: regression test for allocsp handing out stale
 disk contents
Message-ID: <YePFeq+3wf9eq4ue@desktop>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
 <164193783590.3008286.3623476203965250828.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164193783590.3008286.3623476203965250828.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 11, 2022 at 01:50:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a regression test to check that XFS_IOC_ALLOCSP isn't handing out
> stale disk blocks for preallocation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  .gitignore        |    1 
>  src/Makefile      |    2 -
>  src/allocstale.c  |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/832     |   56 +++++++++++++++++++++++++
>  tests/xfs/832.out |    2 +
>  5 files changed, 177 insertions(+), 1 deletion(-)
>  create mode 100644 src/allocstale.c
>  create mode 100755 tests/xfs/832
>  create mode 100644 tests/xfs/832.out
> 
> 
> diff --git a/.gitignore b/.gitignore
> index 65b93307..ba0c572b 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -56,6 +56,7 @@ tags
>  # src/ binaries
>  /src/af_unix
>  /src/alloc
> +/src/allocstale
>  /src/append_reader
>  /src/append_writer
>  /src/attr_replace_test
> diff --git a/src/Makefile b/src/Makefile
> index 1737ed0e..111ce1d9 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -18,7 +18,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  	t_ext4_dax_journal_corruption t_ext4_dax_inline_corruption \
>  	t_ofd_locks t_mmap_collision mmap-write-concurrent \
>  	t_get_file_time t_create_short_dirs t_create_long_dirs t_enospc \
> -	t_mmap_writev_overlap checkpoint_journal mmap-rw-fault
> +	t_mmap_writev_overlap checkpoint_journal mmap-rw-fault allocstale
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> diff --git a/src/allocstale.c b/src/allocstale.c
> new file mode 100644
> index 00000000..6253fe4c
> --- /dev/null
> +++ b/src/allocstale.c
> @@ -0,0 +1,117 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <djwong@kernel.org>
> + *
> + * Test program to try to trip over XFS_IOC_ALLOCSP mapping stale disk blocks
> + * into a file.
> + */
> +#include <xfs/xfs.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <unistd.h>
> +#include <string.h>
> +
> +#ifndef XFS_IOC_ALLOCSP
> +# define XFS_IOC_ALLOCSP	_IOW ('X', 10, struct xfs_flock64)
> +#endif
> +
> +int
> +main(
> +	int		argc,
> +	char		*argv[])
> +{
> +	struct stat	sb;
> +	char		*buf, *zeroes;
> +	unsigned long	i;
> +	unsigned long	iterations;
> +	int		fd, ret;
> +
> +	if (argc != 3) {
> +		fprintf(stderr, "Usage: %s filename iterations\n", argv[0]);
> +		return 1;
> +	}
> +
> +	errno = 0;
> +	iterations = strtoul(argv[2], NULL, 0);
> +	if (errno) {
> +		perror(argv[2]);
> +		return 1;
> +	}
> +
> +	fd = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0600);
> +	if (fd < 0) {
> +		perror(argv[1]);
> +		return 1;
> +	}
> +
> +	ret = fstat(fd, &sb);
> +	if (ret) {
> +		perror(argv[1]);
> +		return 1;
> +	}
> +
> +	buf = malloc(sb.st_blksize);
> +	if (!buf) {
> +		perror("pread buffer");
> +		return 1;
> +	}
> +
> +	zeroes = calloc(1, sb.st_blksize);
> +	if (!zeroes) {
> +		perror("zeroes buffer");
> +		return 1;
> +	}
> +
> +	for (i = 1; i <= iterations; i++) {
> +		struct xfs_flock64	arg = { };
> +		ssize_t			read_bytes;
> +		off_t			offset = sb.st_blksize * i;
> +
> +		/* Ensure the last block of the file is a hole... */
> +		ret = ftruncate(fd, offset - 1);
> +		if (ret) {
> +			perror("truncate");
> +			return 1;
> +		}
> +
> +		/*
> +		 * ...then use ALLOCSP to allocate the last block in the file.
> +		 * An unpatched kernel neglects to mark the new mapping
> +		 * unwritten or to zero the ondisk block, so...
> +		 */
> +		arg.l_whence = SEEK_SET;
> +		arg.l_start = offset;
> +		ret = ioctl(fd, XFS_IOC_ALLOCSP, &arg);
> +		if (ret < 0) {
> +			perror("ioctl");
> +			return 1;
> +		}
> +
> +		/* ... we can read old disk contents here. */
> +		read_bytes = pread(fd, buf, sb.st_blksize,
> +						offset - sb.st_blksize);
> +		if (read_bytes < 0) {
> +			perror(argv[1]);
> +			return 1;
> +		}
> +		if (read_bytes != sb.st_blksize) {
> +			fprintf(stderr, "%s: short read of %zd bytes\n",
> +					argv[1], read_bytes);
> +			return 1;
> +		}
> +
> +		if (memcmp(zeroes, buf, sb.st_blksize) != 0) {
> +			fprintf(stderr, "%s: found junk near offset %zd!\n",
> +					argv[1], offset - sb.st_blksize);
> +			return 2;
> +		}
> +	}
> +
> +	return 0;
> +}
> diff --git a/tests/xfs/832 b/tests/xfs/832
> new file mode 100755
> index 00000000..3820ff8c
> --- /dev/null
> +++ b/tests/xfs/832
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 832
> +#
> +# Regression test for commit:
> +#
> +# 983d8e60f508 ("xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate")
> +#
> +. ./common/preamble
> +_begin_fstest auto quick prealloc
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_test
> +_require_scratch

Added the following require rule on commit.

_require_test_program "allocstale"

Thanks,
Eryu

> +
> +size_mb=32
> +# Write a known pattern to the disk so that we can detect stale disk blocks
> +# being mapped into the file.  In the test author's experience, the bug will
> +# reproduce within the first 500KB's worth of ALLOCSP calls, so running up
> +# to 16MB should suffice.
> +$XFS_IO_PROG -d -c "pwrite -S 0x58 -b 8m 0 ${size_mb}m" $SCRATCH_DEV > $seqres.full
> +MKFS_OPTIONS="-K $MKFS_OPTIONS" _scratch_mkfs_sized $((size_mb * 1048576)) >> $seqres.full
> +
> +_scratch_mount
> +
> +# Force the file to be created on the data device, which we pre-initialized
> +# with a known pattern.  The bug exists in the generic bmap code, so the choice
> +# of backing device does not matter, and ignoring the rt device gets us out of
> +# needing to detect things like rt extent size.
> +_xfs_force_bdev data $SCRATCH_MNT
> +testfile=$SCRATCH_MNT/a
> +
> +# Allow the test program to expand the file to consume half the free space.
> +blksz=$(_get_file_block_size $SCRATCH_MNT)
> +iterations=$(( (size_mb / 2) * 1048576 / blksz))
> +echo "Setting up $iterations runs for block size $blksz" >> $seqres.full
> +
> +# Run reproducer program and dump file contents if we see stale data.  Full
> +# details are in the source for the C program, but in a nutshell we run ALLOCSP
> +# one block at a time to see if it'll give us blocks full of 'X'es.
> +$here/src/allocstale $testfile $iterations
> +res=$?
> +test $res -eq 2 && od -tx1 -Ad -c $testfile
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/832.out b/tests/xfs/832.out
> new file mode 100644
> index 00000000..bb8a6c12
> --- /dev/null
> +++ b/tests/xfs/832.out
> @@ -0,0 +1,2 @@
> +QA output created by 832
> +Silence is golden
