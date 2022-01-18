Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D806C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jan 2022 18:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347747AbiARSJO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jan 2022 13:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiARSJO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jan 2022 13:09:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D7CC061574;
        Tue, 18 Jan 2022 10:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C3C8614EE;
        Tue, 18 Jan 2022 18:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CA5C340E0;
        Tue, 18 Jan 2022 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642529352;
        bh=4NaqOihBfZZh/QuWLhZj3x1elvwto1d5Gh1w9E4qYH0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Y/1D/Q0FIcKOHqPKD8oY0C2fTsc0TeiGjwGgG+V5b8sHH03I4pb+kvnYBGgAEPEUm
         4u3HbNqeGy3PQhla/xl44CEnYUBuMRwiCjK9PZZa9u/+HYp5tYpv+BBsDLCLYXFsQH
         zTryWB/TKddayecgh5hGmSXWW5Q/dPX1wkxurajufRXu0fWQi5YirLr7rLilOnXt9N
         eoq86WX0679UxwpY1DKknmGmqSNe2V9Qx0lr/BMsAZBeGHt6lACp2MWR1NN7TfjCpE
         tnmeeTxpVfNk6Ya0flgwcVRichu+5tXFCgW0ChXms7syOWhceEio4NWP8mIFNrBeRr
         GiCx6bE5Gp0/Q==
Date:   Tue, 18 Jan 2022 10:09:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/8] xfs: regression test for allocsp handing out stale
 disk contents
Message-ID: <20220118180911.GB13540@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
 <164193783590.3008286.3623476203965250828.stgit@magnolia>
 <20220118033735.kva56rre5iahnnnc@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118033735.kva56rre5iahnnnc@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 18, 2022 at 11:37:35AM +0800, Zorro Lang wrote:
> On Tue, Jan 11, 2022 at 01:50:35PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a regression test to check that XFS_IOC_ALLOCSP isn't handing out
> > stale disk blocks for preallocation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Hi Darrick,
> 
> This case is easily failed on some multi-striped storage[1]. The full output
> as [2], the out.bad output as [3].
> 
> Thanks,
> Zorro
> 
> [1]
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 xxx-xxxxx-xx 5.14.0-xxx #1 SMP PREEMPT Fri Jan 14 09:24:44 UTC 2022
> MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=0,reflink=1,bigtime=1,inobtcount=1 -i sparse=1 /dev/sda4
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda4 /mnt/xfstests/scratch
> 
> xfs/832	_check_xfs_filesystem: filesystem on /dev/sda4 is inconsistent (r)
> (see /var/lib/xfstests/results//xfs/832.full for details)
> - output mismatch (see /var/lib/xfstests/results//xfs/832.out.bad)
>     --- tests/xfs/832.out	2022-01-15 22:18:35.175245791 -0500
>     +++ /var/lib/xfstests/results//xfs/832.out.bad	2022-01-15 22:20:46.630697627 -0500
>     @@ -1,2 +1,3 @@
>      QA output created by 832
>     +ioctl: No space left on device
>      Silence is golden
>     ...
>     (Run 'diff -u /var/lib/xfstests/tests/xfs/832.out /var/lib/xfstests/results//xfs/832.out.bad'  to see the entire diff)
> Ran: xfs/832
> Failures: xfs/832
> Failed 1 of 1 tests
> 
> [2]
> wrote 33554432/33554432 bytes at offset 0
> 32 MiB, 4 ops; 0.1368 sec (233.848 MiB/sec and 29.2310 ops/sec)
> meta-data=/dev/sda4              isize=512    agcount=1, agsize=4112 blks

Single AG filesystems aren't a supported configuration.  Is sda4
actually 16MB?  I'm a little surprised that this was the outcome of
"_scratch_mkfs_sized 33554432" on line 32.

--D

>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1
> data     =                       bsize=4096   blocks=4112, imaxpct=25
>          =                       sunit=16     swidth=32 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=1872, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Setting up 4096 runs for block size 4096
> _check_xfs_filesystem: filesystem on /dev/sda4 is inconsistent (r)
> *** xfs_repair -n output ***
> Phase 1 - find and verify superblock...
> Only one AG detected - cannot validate filesystem geometry.
> Use the -o force_geometry option to proceed.
> *** end xfs_repair output
> ...
> 
> [3]
> QA output created by 832
> ioctl: No space left on device
> Silence is golden
> 
> 
> >  .gitignore        |    1 
> >  src/Makefile      |    2 -
> >  src/allocstale.c  |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/832     |   56 +++++++++++++++++++++++++
> >  tests/xfs/832.out |    2 +
> >  5 files changed, 177 insertions(+), 1 deletion(-)
> >  create mode 100644 src/allocstale.c
> >  create mode 100755 tests/xfs/832
> >  create mode 100644 tests/xfs/832.out
> > 
> > 
> > diff --git a/.gitignore b/.gitignore
> > index 65b93307..ba0c572b 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -56,6 +56,7 @@ tags
> >  # src/ binaries
> >  /src/af_unix
> >  /src/alloc
> > +/src/allocstale
> >  /src/append_reader
> >  /src/append_writer
> >  /src/attr_replace_test
> > diff --git a/src/Makefile b/src/Makefile
> > index 1737ed0e..111ce1d9 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -18,7 +18,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
> >  	t_ext4_dax_journal_corruption t_ext4_dax_inline_corruption \
> >  	t_ofd_locks t_mmap_collision mmap-write-concurrent \
> >  	t_get_file_time t_create_short_dirs t_create_long_dirs t_enospc \
> > -	t_mmap_writev_overlap checkpoint_journal mmap-rw-fault
> > +	t_mmap_writev_overlap checkpoint_journal mmap-rw-fault allocstale
> >  
> >  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> > diff --git a/src/allocstale.c b/src/allocstale.c
> > new file mode 100644
> > index 00000000..6253fe4c
> > --- /dev/null
> > +++ b/src/allocstale.c
> > @@ -0,0 +1,117 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2022 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <djwong@kernel.org>
> > + *
> > + * Test program to try to trip over XFS_IOC_ALLOCSP mapping stale disk blocks
> > + * into a file.
> > + */
> > +#include <xfs/xfs.h>
> > +#include <stdlib.h>
> > +#include <stdio.h>
> > +#include <unistd.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <errno.h>
> > +#include <unistd.h>
> > +#include <string.h>
> > +
> > +#ifndef XFS_IOC_ALLOCSP
> > +# define XFS_IOC_ALLOCSP	_IOW ('X', 10, struct xfs_flock64)
> > +#endif
> > +
> > +int
> > +main(
> > +	int		argc,
> > +	char		*argv[])
> > +{
> > +	struct stat	sb;
> > +	char		*buf, *zeroes;
> > +	unsigned long	i;
> > +	unsigned long	iterations;
> > +	int		fd, ret;
> > +
> > +	if (argc != 3) {
> > +		fprintf(stderr, "Usage: %s filename iterations\n", argv[0]);
> > +		return 1;
> > +	}
> > +
> > +	errno = 0;
> > +	iterations = strtoul(argv[2], NULL, 0);
> > +	if (errno) {
> > +		perror(argv[2]);
> > +		return 1;
> > +	}
> > +
> > +	fd = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0600);
> > +	if (fd < 0) {
> > +		perror(argv[1]);
> > +		return 1;
> > +	}
> > +
> > +	ret = fstat(fd, &sb);
> > +	if (ret) {
> > +		perror(argv[1]);
> > +		return 1;
> > +	}
> > +
> > +	buf = malloc(sb.st_blksize);
> > +	if (!buf) {
> > +		perror("pread buffer");
> > +		return 1;
> > +	}
> > +
> > +	zeroes = calloc(1, sb.st_blksize);
> > +	if (!zeroes) {
> > +		perror("zeroes buffer");
> > +		return 1;
> > +	}
> > +
> > +	for (i = 1; i <= iterations; i++) {
> > +		struct xfs_flock64	arg = { };
> > +		ssize_t			read_bytes;
> > +		off_t			offset = sb.st_blksize * i;
> > +
> > +		/* Ensure the last block of the file is a hole... */
> > +		ret = ftruncate(fd, offset - 1);
> > +		if (ret) {
> > +			perror("truncate");
> > +			return 1;
> > +		}
> > +
> > +		/*
> > +		 * ...then use ALLOCSP to allocate the last block in the file.
> > +		 * An unpatched kernel neglects to mark the new mapping
> > +		 * unwritten or to zero the ondisk block, so...
> > +		 */
> > +		arg.l_whence = SEEK_SET;
> > +		arg.l_start = offset;
> > +		ret = ioctl(fd, XFS_IOC_ALLOCSP, &arg);
> > +		if (ret < 0) {
> > +			perror("ioctl");
> > +			return 1;
> > +		}
> > +
> > +		/* ... we can read old disk contents here. */
> > +		read_bytes = pread(fd, buf, sb.st_blksize,
> > +						offset - sb.st_blksize);
> > +		if (read_bytes < 0) {
> > +			perror(argv[1]);
> > +			return 1;
> > +		}
> > +		if (read_bytes != sb.st_blksize) {
> > +			fprintf(stderr, "%s: short read of %zd bytes\n",
> > +					argv[1], read_bytes);
> > +			return 1;
> > +		}
> > +
> > +		if (memcmp(zeroes, buf, sb.st_blksize) != 0) {
> > +			fprintf(stderr, "%s: found junk near offset %zd!\n",
> > +					argv[1], offset - sb.st_blksize);
> > +			return 2;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > diff --git a/tests/xfs/832 b/tests/xfs/832
> > new file mode 100755
> > index 00000000..3820ff8c
> > --- /dev/null
> > +++ b/tests/xfs/832
> > @@ -0,0 +1,56 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 832
> > +#
> > +# Regression test for commit:
> > +#
> > +# 983d8e60f508 ("xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate")
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick prealloc
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs
> > +_require_test
> > +_require_scratch
> > +
> > +size_mb=32
> > +# Write a known pattern to the disk so that we can detect stale disk blocks
> > +# being mapped into the file.  In the test author's experience, the bug will
> > +# reproduce within the first 500KB's worth of ALLOCSP calls, so running up
> > +# to 16MB should suffice.
> > +$XFS_IO_PROG -d -c "pwrite -S 0x58 -b 8m 0 ${size_mb}m" $SCRATCH_DEV > $seqres.full
> > +MKFS_OPTIONS="-K $MKFS_OPTIONS" _scratch_mkfs_sized $((size_mb * 1048576)) >> $seqres.full
> > +
> > +_scratch_mount
> > +
> > +# Force the file to be created on the data device, which we pre-initialized
> > +# with a known pattern.  The bug exists in the generic bmap code, so the choice
> > +# of backing device does not matter, and ignoring the rt device gets us out of
> > +# needing to detect things like rt extent size.
> > +_xfs_force_bdev data $SCRATCH_MNT
> > +testfile=$SCRATCH_MNT/a
> > +
> > +# Allow the test program to expand the file to consume half the free space.
> > +blksz=$(_get_file_block_size $SCRATCH_MNT)
> > +iterations=$(( (size_mb / 2) * 1048576 / blksz))
> > +echo "Setting up $iterations runs for block size $blksz" >> $seqres.full
> > +
> > +# Run reproducer program and dump file contents if we see stale data.  Full
> > +# details are in the source for the C program, but in a nutshell we run ALLOCSP
> > +# one block at a time to see if it'll give us blocks full of 'X'es.
> > +$here/src/allocstale $testfile $iterations
> > +res=$?
> > +test $res -eq 2 && od -tx1 -Ad -c $testfile
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/832.out b/tests/xfs/832.out
> > new file mode 100644
> > index 00000000..bb8a6c12
> > --- /dev/null
> > +++ b/tests/xfs/832.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 832
> > +Silence is golden
> > 
> 
