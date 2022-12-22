Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1762CC001B2
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Dec 2022 18:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiLVSKc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Dec 2022 13:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiLVSKb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2022 13:10:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B3513EA3;
        Thu, 22 Dec 2022 10:10:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1460FB81F3F;
        Thu, 22 Dec 2022 18:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B3DC433D2;
        Thu, 22 Dec 2022 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671732627;
        bh=rFlJ5umulmnQkWwQiL8LQ//9yzUdQ47Bd3CzEt5sEqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LpmWJV6PwDlhm0CMyXVQ+RMaYy33g6F5JuBroPdia13vLCWAJvs98afnXP7MRGQ3D
         OoPdB2Do29ezUmPSVBJJCiPaya2qU16wneb4Y8a/ce5JyG4lD2g+x1zr5Z6Fy/v44Y
         gOv3FRZBJdp7TBWIpIAxT6H7ag+iMJ0etVVoRUM1VZWlPysqFHt4/1YUVhmXUE2JWd
         zWRwa0Pz2kw10zF6l+MT0ZfAbNMy9wTREYYY6h5nnYoy+dJtqZTq0qolKlYS3ex4EK
         JtCttVKI5voDE5fAnEqgwBy8UcxZLftEvs3X5nxbks8wW1lJvj/nQ/ePKshxbnpUS9
         Q0+hjGGnlTMfw==
Date:   Thu, 22 Dec 2022 10:10:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Hironori Shiina <shiina.hironori@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: Re: [PATCH v2] xfs: Test bulkstat special query for root inode
Message-ID: <Y6SdkwtvvMfvkakG@magnolia>
References: <20221221161843.124707-1-shiina.hironori@fujitsu.com>
 <20221221223805.148788-1-shiina.hironori@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221223805.148788-1-shiina.hironori@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 21, 2022 at 05:38:05PM -0500, Hironori Shiina wrote:
> This is a test for the fix:
>   bf3cb3944792 xfs: allow single bulkstat of special inodes
> This fix added a feature to query the root inode number of a filesystem.
> This test creates a file with a lower inode number than the root and run
> a query for the root inode.
> 
> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/557     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/557.out |  2 ++
>  2 files changed, 65 insertions(+)
>  create mode 100644 tests/xfs/557
>  create mode 100644 tests/xfs/557.out
> 
> diff --git a/tests/xfs/557 b/tests/xfs/557
> new file mode 100644
> index 00000000..608ce13c
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
> +_require_xfs_io_command "bulkstat_single"
> +_require_scratch
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
> +bulkstat_root_inum=$($XFS_IO_PROG -c 'bulkstat_single root' $SCRATCH_MNT | grep bs_ino | awk '{print $3;}')
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
