Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02750C41535
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 16:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiLUQ34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 11:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbiLUQ3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 11:29:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C858FE0;
        Wed, 21 Dec 2022 08:29:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED0161804;
        Wed, 21 Dec 2022 16:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA698C433EF;
        Wed, 21 Dec 2022 16:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671640191;
        bh=C1Vr6fmSIagYamAgfuEKem59cRb+RoCzIvlXvMjsMQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gPo6VzddwDGTHKPM5XH2JCRxiz8+4Xunzb5cNQNhfnupPjCldaBotfZA45x9aDy13
         hkJjn/entotVddhIyPSrcy7lsZweq4td44ANykRqN1VEhoppPk02wDlsoyDyjbtDUn
         cYrLDOYLNjF3y8gd5EbZb4ZSWHuSnhdEKLj0WydTcaGEQqG/VlxRZJluwChFfMnioV
         hR7njsknCHCIoDIjssHtJCNHVKAHxnNSRy0knYSWb0Awody2pTlWekj3zEDuwcTPXE
         Y4G+2huE7dUl4UqZKoZQzq5GLgrew2UHfSD6iExwyKOgyhGKF9pux66+UrrG11HSPC
         v8YF9gXXq2L9g==
Date:   Wed, 21 Dec 2022 08:29:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Hironori Shiina <shiina.hironori@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: Re: [PATCH] xfs: Test bulkstat special query for root inode
Message-ID: <Y6M0f5Dc19M31xoe@magnolia>
References: <20221221161843.124707-1-shiina.hironori@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221161843.124707-1-shiina.hironori@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 21, 2022 at 11:18:43AM -0500, Hironori Shiina wrote:
> This is a test for the fix:
>   bf3cb3944792 xfs: allow single bulkstat of special inodes
> This fix added a feature to query the root inode number of a filesystem.
> This test creates a file with a lower inode number than the root and run
> a query for the root inode.

oooh, a regression test, sweet!

> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
> ---
>  common/xfs               |  7 +++++
>  src/Makefile             |  2 +-
>  src/xfs_get_root_inode.c | 49 +++++++++++++++++++++++++++++++
>  tests/xfs/557            | 63 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/557.out        |  2 ++
>  5 files changed, 122 insertions(+), 1 deletion(-)
>  create mode 100644 src/xfs_get_root_inode.c
>  create mode 100644 tests/xfs/557
>  create mode 100644 tests/xfs/557.out
> 
> diff --git a/common/xfs b/common/xfs
> index 7eee76c0..9275a79c 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1547,3 +1547,10 @@ _xfs_get_inode_core_bytes()
>  		echo 96
>  	fi
>  }
> +
> +_require_xfs_bulkstat_special_root()
> +{
> +	if $here/src/xfs_get_root_inode 2>&1 | grep -q 'not supported'; then
> +		_notrun 'XFS_BULK_IREQ_SPECIAL_ROOT is not supported.'
> +	fi
> +}
> diff --git a/src/Makefile b/src/Makefile
> index afdf6b30..c850fdcb 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -19,7 +19,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  	t_ofd_locks t_mmap_collision mmap-write-concurrent \
>  	t_get_file_time t_create_short_dirs t_create_long_dirs t_enospc \
>  	t_mmap_writev_overlap checkpoint_journal mmap-rw-fault allocstale \
> -	t_mmap_cow_memory_failure fake-dump-rootino
> +	t_mmap_cow_memory_failure fake-dump-rootino xfs_get_root_inode
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> diff --git a/src/xfs_get_root_inode.c b/src/xfs_get_root_inode.c
> new file mode 100644
> index 00000000..d1b4f38d
> --- /dev/null
> +++ b/src/xfs_get_root_inode.c
> @@ -0,0 +1,49 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <fcntl.h>
> +#include <xfs/xfs.h>
> +
> +int main(int argc, char *argv[]) {
> +
> +#ifdef XFS_BULK_IREQ_SPECIAL_ROOT
> +
> +	if (argc < 2) {
> +		fprintf(stderr, "%s: requires path argument\n", argv[0]);
> +		return 1;
> +	}
> +
> +	char *path = argv[1];
> +
> +	int fd = open(path, O_RDONLY);
> +	if (fd < 0) {
> +		perror("open failed");
> +		return 1;
> +	}
> +
> +	size_t size = sizeof(struct xfs_bulkstat_req) + sizeof(struct xfs_bulkstat);
> +	struct xfs_bulkstat_req *req = malloc(size);

Is there something about this C code that xfs_io -c 'bulkstat_single
root' doesn't cover?

(If you /do/ keep the C program, its binary needs to be listed in
.gitignore.)

> +	if (req == NULL) {
> +		perror("malloc failed");
> +		return 1;
> +	}
> +	memset(req, 0, sizeof(size));
> +	req->hdr.flags = XFS_BULK_IREQ_SPECIAL;
> +	req->hdr.ino = XFS_BULK_IREQ_SPECIAL_ROOT;
> +	req->hdr.icount = 1;
> +
> +	int ret = ioctl(fd, XFS_IOC_BULKSTAT, req);
> +	if (ret < 0) {
> +		perror("ioctl failed");
> +		return 1;
> +	}
> +	printf("%lu\n", req->bulkstat[0].bs_ino);
> +
> +	return 0;
> +
> +#else
> +	fprintf(stderr, "XFS_BULK_IREQ_SPECIAL_ROOT is not supported\n");
> +	return 1;
> +#endif
> +
> +}
> diff --git a/tests/xfs/557 b/tests/xfs/557
> new file mode 100644
> index 00000000..95b59088
> --- /dev/null
> +++ b/tests/xfs/557
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
> +#
> +# FS QA Test No. 557
> +#
> +# This is a test for:
> +#   bf3cb3944792 (xfs: allow single bulkstat of special inodes)
> +# Create a filesystem which contains an inode with a lower number
> +# than the root inode. Then verify that XFS_BULK_IREQ_SPECIAL_ROOT gets
> +# the correct root inode number.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +_supported_fs xfs
> +_require_xfs_io_command "falloc"
> +_require_scratch
> +_require_xfs_bulkstat_special_root
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"xfs: get root inode correctly at bulkstat"
> +
> +# A large stripe unit will put the root inode out quite far
> +# due to alignment, leaving free blocks ahead of it.
> +_scratch_mkfs_xfs -d sunit=1024,swidth=1024 > $seqres.full 2>&1 || _fail "mkfs failed"
> +
> +# Mounting /without/ a stripe should allow inodes to be allocated
> +# in lower free blocks, without the stripe alignment.
> +_scratch_mount -o sunit=0,swidth=0
> +
> +root_inum=$(stat -c %i $SCRATCH_MNT)
> +
> +# Consume space after the root inode so that the blocks before
> +# root look "close" for the next inode chunk allocation
> +$XFS_IO_PROG -f -c "falloc 0 16m" $SCRATCH_MNT/fillfile
> +
> +# And make a bunch of inodes until we (hopefully) get one lower
> +# than root, in a new inode chunk.
> +echo "root_inum: $root_inum" >> $seqres.full
> +for i in $(seq 0 4096) ; do
> +	fname=$SCRATCH_MNT/$(printf "FILE_%03d" $i)
> +	touch $fname
> +	inum=$(stat -c "%i" $fname)
> +	[[ $inum -lt $root_inum ]] && break
> +done
> +
> +echo "created: $inum" >> $seqres.full
> +
> +[[ $inum -lt $root_inum ]] || _notrun "Could not set up test"
> +
> +# Get root ino with XFS_BULK_IREQ_SPECIAL_ROOT
> +bulkstat_root_inum=$($here/src/xfs_get_root_inode $SCRATCH_MNT)
> +echo "bulkstat_root_inum: $bulkstat_root_inum" >> $seqres.full
> +if [ $root_inum -ne $bulkstat_root_inum ]; then
> +	echo "root ino mismatch: expected:${root_inum}, actual:${bulkstat_root_inum}"
> +fi
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit

Looks good to me otherwise. :)

--D

> diff --git a/tests/xfs/557.out b/tests/xfs/557.out
> new file mode 100644
> index 00000000..1f1ae1d4
> --- /dev/null
> +++ b/tests/xfs/557.out
> @@ -0,0 +1,2 @@
> +QA output created by 557
> +Silence is golden
> -- 
> 2.38.1
> 
