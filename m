Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B5BC43381
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 457CE64E56
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354026AbhCDAR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1386195AbhCCRrG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 12:47:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C51364EDB;
        Wed,  3 Mar 2021 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614793104;
        bh=eFrWIDgP/60oeCf7aD2PKsX9NXrln57dUOYK7CUj2XE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lr0wygCPSc1hbojEkPIcso9KgBMNCjTIdBTUeaS5N09ZASYygfjeMVH1icjUukdeV
         I61M7gaLdMDLL8PAEakyCTipM4+RodiSM4lokBk1z/nvPd5tZ+f7W6AiMIU2DNYPcB
         X2KI0koQ9yzXF28kIGZXh4uRBK66GiJPnyDrzybxeQMMsZ5eWrDk4eygQnuo/VelkK
         ttjsJ6olElI7DGD+hdAXmD1OFrHonMxeKeVX0tSUMeu9hVWnv+jfJYYao8RQNM+wNP
         bgPyC7RnntV695T+2jhVaVm+36lZB1MmpAJO7Pfm+micpNkPfbRnzVg+JaylB+3tuT
         DwrGsS92HJ5dA==
Date:   Wed, 3 Mar 2021 09:38:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 02/11] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20210303173823.GJ7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-3-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:13AM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when adding a single extent while there's no possibility of
> splitting an existing mapping.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/522     | 173 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/522.out |  20 ++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 194 insertions(+)
>  create mode 100755 tests/xfs/522
>  create mode 100644 tests/xfs/522.out
> 
> diff --git a/tests/xfs/522 b/tests/xfs/522
> new file mode 100755
> index 00000000..33f0591e
> --- /dev/null
> +++ b/tests/xfs/522
> @@ -0,0 +1,173 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 522
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# adding a single extent while there's no possibility of splitting an existing
> +# mapping.
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
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
> +. ./common/inject
> +. ./common/populate
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_quota
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount -o uquota >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +
> +echo "* Delalloc to written extent conversion"

What happens if delalloc is disabled?  e.g. the mkfs parameters have
extent size hints set on the root directory?

(I think it'll be fine since you write every other block...)

> +testfile=$SCRATCH_MNT/testfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +nr_blks=$((15 * 2))
> +
> +echo "Create fragmented file"
> +for i in $(seq 0 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $testfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$testfile's extent count"
> +
> +nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
> +nextents=${nextents##fsxattr.nextents = }

/me wonders if it's time for a helper to extract these fields...

> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm $testfile
> +
> +echo "* Fallocate unwritten extents"
> +
> +echo "Fallocate fragmented file"
> +for i in $(seq 0 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -c "falloc $((i * bsize)) $bsize" $testfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$testfile's extent count"
> +
> +nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
> +nextents=${nextents##fsxattr.nextents = }
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm $testfile
> +
> +echo "* Directio write"
> +
> +echo "Create fragmented file via directio writes"
> +for i in $(seq 0 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -d -s -f -c "pwrite $((i * bsize)) $bsize" $testfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$testfile's extent count"
> +
> +nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
> +nextents=${nextents##fsxattr.nextents = }
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm $testfile
> +
> +echo "* Extend quota inodes"
> +
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
> +
> +echo "Consume free space"
> +fillerdir=$SCRATCH_MNT/fillerdir
> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> +nr_free_blks=$((nr_free_blks * 90 / 100))
> +
> +_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 >> $seqres.full 2>&1
> +
> +echo "Create fragmented filesystem"
> +for dentry in $(ls -1 $fillerdir/); do
> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> +done
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1

Are we testing to see if the fs blows up when the quota inodes hit max
iext count?  If so, please put that in the comments for this section.

> +
> +nr_blks=20
> +
> +# This is a rough calculation; It doesn't take block headers into
> +# consideration.
> +# gdb -batch vmlinux -ex 'print sizeof(struct xfs_dqblk)'
> +# $1 = 136
> +nr_quotas_per_block=$((bsize / 136))
> +nr_quotas=$((nr_quotas_per_block * nr_blks))
> +
> +echo "Extend uquota file"
> +for i in $(seq 0 $nr_quotas_per_block $nr_quotas); do
> +	chown $i $testfile >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +_scratch_unmount >> $seqres.full
> +
> +echo "Verify uquota inode's extent count"
> +uquotino=$(_scratch_xfs_db -c sb -c "print uquotino")
> +uquotino=${uquotino##uquotino = }

_scratch_xfs_get_metadata_field

> +
> +nextents=$(_scratch_get_iext_count $uquotino data || \
> +		   _fail "Unable to obtain inode fork's extent count")
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/522.out b/tests/xfs/522.out
> new file mode 100644
> index 00000000..debeb004
> --- /dev/null
> +++ b/tests/xfs/522.out
> @@ -0,0 +1,20 @@
> +QA output created by 522
> +Format and mount fs
> +* Delalloc to written extent conversion
> +Inject reduce_max_iextents error tag
> +Create fragmented file
> +Verify $testfile's extent count
> +* Fallocate unwritten extents
> +Fallocate fragmented file
> +Verify $testfile's extent count
> +* Directio write
> +Create fragmented file via directio writes
> +Verify $testfile's extent count
> +* Extend quota inodes
> +Disable reduce_max_iextents error tag
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Extend uquota file
> +Verify uquota inode's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index b89c0a4e..1831f0b5 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -519,3 +519,4 @@
>  519 auto quick reflink
>  520 auto quick reflink
>  521 auto quick realtime growfs
> +522 auto quick quota
> -- 
> 2.29.2
> 
