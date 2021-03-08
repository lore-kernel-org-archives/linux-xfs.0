Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7028C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979D465230
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhCHSP7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 13:15:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhCHSPl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 13:15:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5A3E64EEA;
        Mon,  8 Mar 2021 18:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615227340;
        bh=p3q9l5AtbgCDBqk99CnSqUUj2iTxIepLMjEUCh8jyGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=olVODp3VPpBu3/lo4mlvDZgAiV4hh+xx2KFLni88PS1v3su03/YvldOGFpc6sWXIO
         zLxax2RVjrJ1sCFUr78ZIQMTu/sNFlyXcgPO1luhEgJ1OuIL1nLWx28yqzVGJ4oxRt
         4n4otxvueIJJxlEPd29R91GguEh7VFmAdNXyv/AmdpGbq/MV2B9H5/Rx1l3Rpfu9Gg
         UNsEgf3SLgprAbShxmlgJRrIGsy40HaB5HL5/kiWyW8H3WURV63iiQGKl3Ja+ZqDB5
         t9AIISjbaVyShb2K/QlGZ41E7jpnR+du/HZtNjw2uG2eMhwADmHXGhdIuK15oM8/Ju
         1mVaAO4D9ERrA==
Date:   Mon, 8 Mar 2021 10:15:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 08/13] xfs: Check for extent overflow when
 adding/removing dir entries
Message-ID: <20210308181538.GT3419940@magnolia>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
 <20210308155111.53874-9-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308155111.53874-9-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 09:21:06PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when adding/removing directory entries.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks reasonable,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/532     | 182 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/532.out |  17 +++++
>  tests/xfs/group   |   1 +
>  3 files changed, 200 insertions(+)
>  create mode 100755 tests/xfs/532
>  create mode 100644 tests/xfs/532.out
> 
> diff --git a/tests/xfs/532 b/tests/xfs/532
> new file mode 100755
> index 00000000..235b60b5
> --- /dev/null
> +++ b/tests/xfs/532
> @@ -0,0 +1,182 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 532
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# adding/removing directory entries.
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
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +. $tmp.mkfs
> +
> +# Filesystems with directory block size greater than one FSB will not be tested,
> +# since "7 (i.e. XFS_DA_NODE_MAXDEPTH + 1 data block + 1 free block) * 2 (fsb
> +# count) = 14" is greater than the pseudo max extent count limit of 10.
> +# Extending the pseudo max limit won't help either.  Consider the case where 1
> +# FSB is 1k in size and 1 dir block is 64k in size (i.e. fsb count = 64). In
> +# this case, the pseudo max limit has to be greater than 7 * 64 = 448 extents.
> +if (( $dirbsize > $dbsize )); then
> +	_notrun "Directory block size ($dirbsize) is larger than FSB size ($dbsize)"
> +fi
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +echo "Consume free space"
> +fillerdir=$SCRATCH_MNT/fillerdir
> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> +nr_free_blks=$((nr_free_blks * 90 / 100))
> +
> +_fill_fs $((dbsize * nr_free_blks)) $fillerdir $dbsize 0 >> $seqres.full 2>&1
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
> +
> +dent_len=255
> +
> +echo "* Create directory entries"
> +
> +testdir=$SCRATCH_MNT/testdir
> +mkdir $testdir
> +
> +nr_dents=$((dbsize * 20 / dent_len))
> +for i in $(seq 1 $nr_dents); do
> +	dentry="$(printf "%0255d" $i)"
> +	touch ${testdir}/$dentry >> $seqres.full 2>&1 || break
> +done
> +
> +echo "Verify directory's extent count"
> +nextents=$(xfs_get_fsxattr nextents $testdir)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm -rf $testdir
> +
> +echo "* Rename: Populate destination directory"
> +
> +dstdir=$SCRATCH_MNT/dstdir
> +mkdir $dstdir
> +
> +nr_dents=$((dirbsize * 20 / dent_len))
> +
> +echo "Populate \$dstdir by moving new directory entries"
> +for i in $(seq 1 $nr_dents); do
> +	dentry="$(printf "%0255d" $i)"
> +	dentry=${SCRATCH_MNT}/${dentry}
> +	touch $dentry || break
> +	mv $dentry $dstdir >> $seqres.full 2>&1 || break
> +done
> +
> +rm $dentry
> +
> +echo "Verify \$dstdir's extent count"
> +
> +nextents=$(xfs_get_fsxattr nextents $dstdir)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm -rf $dstdir
> +
> +echo "* Create multiple hard links to a single file"
> +
> +testdir=$SCRATCH_MNT/testdir
> +mkdir $testdir
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +nr_dents=$((dirbsize * 20 / dent_len))
> +
> +echo "Create multiple hardlinks"
> +for i in $(seq 1 $nr_dents); do
> +	dentry="$(printf "%0255d" $i)"
> +	ln $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break
> +done
> +
> +rm $testfile
> +
> +echo "Verify directory's extent count"
> +nextents=$(xfs_get_fsxattr nextents $testdir)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm -rf $testdir
> +
> +echo "* Create multiple symbolic links to a single file"
> +
> +testdir=$SCRATCH_MNT/testdir
> +mkdir $testdir
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +nr_dents=$((dirbsize * 20 / dent_len))
> +
> +echo "Create multiple symbolic links"
> +for i in $(seq 1 $nr_dents); do
> +	dentry="$(printf "%0255d" $i)"
> +	ln -s $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break;
> +done
> +
> +rm $testfile
> +
> +echo "Verify directory's extent count"
> +nextents=$(xfs_get_fsxattr nextents $testdir)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm -rf $testdir
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/532.out b/tests/xfs/532.out
> new file mode 100644
> index 00000000..2766c211
> --- /dev/null
> +++ b/tests/xfs/532.out
> @@ -0,0 +1,17 @@
> +QA output created by 532
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +* Create directory entries
> +Verify directory's extent count
> +* Rename: Populate destination directory
> +Populate $dstdir by moving new directory entries
> +Verify $dstdir's extent count
> +* Create multiple hard links to a single file
> +Create multiple hardlinks
> +Verify directory's extent count
> +* Create multiple symbolic links to a single file
> +Create multiple symbolic links
> +Verify directory's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 7e284841..77abeefa 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -529,3 +529,4 @@
>  529 auto quick realtime growfs
>  530 auto quick punch zero insert collapse
>  531 auto quick attr
> +532 auto quick dir hardlink symlink
> -- 
> 2.29.2
> 
