Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF43C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 16:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443324AbiEFQGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 12:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443321AbiEFQGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 12:06:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEED869CCB;
        Fri,  6 May 2022 09:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91B46B832EB;
        Fri,  6 May 2022 16:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34871C385A9;
        Fri,  6 May 2022 16:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651852937;
        bh=QXH+OPuHJNMDOY/M5AGaVhF+yHNv7bwLrQ8jZlJq8SU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N5jQnI92MTvTl0J8tJsIYNgfnvgzuwfZI5WcU6U6T1N2C4/bru2hwmoWtPTmX285E
         oRlsHMnJmIg551VHmN1BYheA4uezOqSx4vB/VYqbixZT3XAY0Tobj3LYJmChuLr0bx
         0VcXj6W86305GWC68bEmY2koLCHtosbhL8YZrQ/81JBLzlKYkBOUTYGGNkEOqHDh4j
         ef79tJYj7HWwim+mq7L7gzPhmzFGHE8//y6gKSc1VrdYYWzulIRhBlZ/m6w7nx238C
         Sc/upbGRA+4gPb+nSkm7MNnbFxK5/n+Du6nDUuX2ezbTAJJiLZoLiCdpfcw3u2SroB
         p6m63bnGsJgEA==
Date:   Fri, 6 May 2022 09:02:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/533: Delete test since directory's extent count can
 never overflow
Message-ID: <20220506160216.GN27195@magnolia>
References: <20220506095746.1014345-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506095746.1014345-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 03:27:46PM +0530, Chandan Babu R wrote:
> The maximum file size that can be represented by the data fork extent counter
> in the worst case occurs when all extents are 1 block in length and each block
> is 1KB in size.
> 
> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
> 1KB sized blocks, a file can reach upto,
> (2^31) * 1KB = 2TB
> 
> This is much larger than the theoretical maximum size of a directory
> i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.
> 
> Since a directory can never overflow its data fork extent counter, the xfs
> kernel driver removed code which checked for such a situation before any
> directory modification operation could be executed. Instead, the kernel driver
> verifies the sanity of directory's data fork extent counter when the inode is
> read from disk.
> 
> This commit removes the test xfs/533 due to the reasons mentioned above.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Yeah, all this functionality is being removed from 5.19, so the test
is no longer needed.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/533     | 170 ----------------------------------------------
>  tests/xfs/533.out |  17 -----
>  2 files changed, 187 deletions(-)
>  delete mode 100755 tests/xfs/533
>  delete mode 100644 tests/xfs/533.out
> 
> diff --git a/tests/xfs/533 b/tests/xfs/533
> deleted file mode 100755
> index b85b5298..00000000
> --- a/tests/xfs/533
> +++ /dev/null
> @@ -1,170 +0,0 @@
> -#! /bin/bash
> -# SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> -#
> -# FS QA Test 533
> -#
> -# Verify that XFS does not cause inode fork's extent count to overflow when
> -# adding/removing directory entries.
> -. ./common/preamble
> -_begin_fstest auto quick dir hardlink symlink
> -
> -# Import common functions.
> -. ./common/filter
> -. ./common/inject
> -. ./common/populate
> -
> -# real QA test starts here
> -
> -_supported_fs xfs
> -_require_scratch
> -_require_xfs_debug
> -_require_test_program "punch-alternating"
> -_require_xfs_io_error_injection "reduce_max_iextents"
> -_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> -
> -_scratch_mkfs_sized $((1024 * 1024 * 1024)) | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> -. $tmp.mkfs
> -
> -# Filesystems with directory block size greater than one FSB will not be tested,
> -# since "7 (i.e. XFS_DA_NODE_MAXDEPTH + 1 data block + 1 free block) * 2 (fsb
> -# count) = 14" is greater than the pseudo max extent count limit of 10.
> -# Extending the pseudo max limit won't help either.  Consider the case where 1
> -# FSB is 1k in size and 1 dir block is 64k in size (i.e. fsb count = 64). In
> -# this case, the pseudo max limit has to be greater than 7 * 64 = 448 extents.
> -if (( $dirbsize > $dbsize )); then
> -	_notrun "Directory block size ($dirbsize) is larger than FSB size ($dbsize)"
> -fi
> -
> -echo "Format and mount fs"
> -_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> -_scratch_mount >> $seqres.full
> -
> -# Disable realtime inherit flag (if any) on root directory so that space on data
> -# device gets fragmented rather than realtime device.
> -_xfs_force_bdev data $SCRATCH_MNT
> -
> -echo "Consume free space"
> -fillerdir=$SCRATCH_MNT/fillerdir
> -nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> -nr_free_blks=$((nr_free_blks * 90 / 100))
> -
> -_fill_fs $((dbsize * nr_free_blks)) $fillerdir $dbsize 0 >> $seqres.full 2>&1
> -
> -echo "Create fragmented filesystem"
> -for dentry in $(ls -1 $fillerdir/); do
> -	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> -done
> -
> -echo "Inject reduce_max_iextents error tag"
> -_scratch_inject_error reduce_max_iextents 1
> -
> -echo "Inject bmap_alloc_minlen_extent error tag"
> -_scratch_inject_error bmap_alloc_minlen_extent 1
> -
> -dent_len=255
> -
> -echo "* Create directory entries"
> -
> -testdir=$SCRATCH_MNT/testdir
> -mkdir $testdir
> -
> -nr_dents=$((dbsize * 20 / dent_len))
> -for i in $(seq 1 $nr_dents); do
> -	dentry="$(printf "%0255d" $i)"
> -	touch ${testdir}/$dentry >> $seqres.full 2>&1 || break
> -done
> -
> -echo "Verify directory's extent count"
> -nextents=$(_xfs_get_fsxattr nextents $testdir)
> -if (( $nextents > 10 )); then
> -	echo "Extent count overflow check failed: nextents = $nextents"
> -	exit 1
> -fi
> -
> -rm -rf $testdir
> -
> -echo "* Rename: Populate destination directory"
> -
> -dstdir=$SCRATCH_MNT/dstdir
> -mkdir $dstdir
> -
> -nr_dents=$((dirbsize * 20 / dent_len))
> -
> -echo "Populate \$dstdir by moving new directory entries"
> -for i in $(seq 1 $nr_dents); do
> -	dentry="$(printf "%0255d" $i)"
> -	dentry=${SCRATCH_MNT}/${dentry}
> -	touch $dentry || break
> -	mv $dentry $dstdir >> $seqres.full 2>&1 || break
> -done
> -
> -rm $dentry
> -
> -echo "Verify \$dstdir's extent count"
> -
> -nextents=$(_xfs_get_fsxattr nextents $dstdir)
> -if (( $nextents > 10 )); then
> -	echo "Extent count overflow check failed: nextents = $nextents"
> -	exit 1
> -fi
> -
> -rm -rf $dstdir
> -
> -echo "* Create multiple hard links to a single file"
> -
> -testdir=$SCRATCH_MNT/testdir
> -mkdir $testdir
> -
> -testfile=$SCRATCH_MNT/testfile
> -touch $testfile
> -
> -nr_dents=$((dirbsize * 20 / dent_len))
> -
> -echo "Create multiple hardlinks"
> -for i in $(seq 1 $nr_dents); do
> -	dentry="$(printf "%0255d" $i)"
> -	ln $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break
> -done
> -
> -rm $testfile
> -
> -echo "Verify directory's extent count"
> -nextents=$(_xfs_get_fsxattr nextents $testdir)
> -if (( $nextents > 10 )); then
> -	echo "Extent count overflow check failed: nextents = $nextents"
> -	exit 1
> -fi
> -
> -rm -rf $testdir
> -
> -echo "* Create multiple symbolic links to a single file"
> -
> -testdir=$SCRATCH_MNT/testdir
> -mkdir $testdir
> -
> -testfile=$SCRATCH_MNT/testfile
> -touch $testfile
> -
> -nr_dents=$((dirbsize * 20 / dent_len))
> -
> -echo "Create multiple symbolic links"
> -for i in $(seq 1 $nr_dents); do
> -	dentry="$(printf "%0255d" $i)"
> -	ln -s $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break;
> -done
> -
> -rm $testfile
> -
> -echo "Verify directory's extent count"
> -nextents=$(_xfs_get_fsxattr nextents $testdir)
> -if (( $nextents > 10 )); then
> -	echo "Extent count overflow check failed: nextents = $nextents"
> -	exit 1
> -fi
> -
> -rm -rf $testdir
> -
> -# success, all done
> -status=0
> -exit
> diff --git a/tests/xfs/533.out b/tests/xfs/533.out
> deleted file mode 100644
> index c3cbe2e0..00000000
> --- a/tests/xfs/533.out
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -QA output created by 533
> -Format and mount fs
> -Consume free space
> -Create fragmented filesystem
> -Inject reduce_max_iextents error tag
> -Inject bmap_alloc_minlen_extent error tag
> -* Create directory entries
> -Verify directory's extent count
> -* Rename: Populate destination directory
> -Populate $dstdir by moving new directory entries
> -Verify $dstdir's extent count
> -* Create multiple hard links to a single file
> -Create multiple hardlinks
> -Verify directory's extent count
> -* Create multiple symbolic links to a single file
> -Create multiple symbolic links
> -Verify directory's extent count
> -- 
> 2.30.2
> 
