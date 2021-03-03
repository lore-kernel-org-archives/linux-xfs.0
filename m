Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB64C4332B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 970A764EF4
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354985AbhCDAR6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835209AbhCCSCg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:02:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C74F564DE8;
        Wed,  3 Mar 2021 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614794514;
        bh=Yzkb9ZueVGugzndRm8yE6bTt9dtFl1TrM3MbB2C6AgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sgGxQrwfTb1JOY+XyGWfhBT3IPYhOPVYayZykbPt1T1hvb50BLmZ8OKkXer7wnW1p
         tly2L1F/95MspdQoPOqAfs5DVm8SUPPHAVW84H8oEsZnoW10GKZvGTBCUg1IbqrgTG
         KHxQJpsFO7Nj7/DMyh6zz+qGOM3ix1kDWhj8YJX7xr9DDieqnaXeMvow+j+2U9TT1d
         hVNIE9HNbu5QMuHpBT+im5plnOmx188xumRV+uwYTGgXB66mgzTkj6Wa+6LkhCbHeI
         fM6ZND/hLD8EDm5SmO9ohC4cZ7IFp7WuRwt1z4ugwU9w82JK9ilMBNj/CFC4E9o9yv
         iI9E9LNqtHrZQ==
Date:   Wed, 3 Mar 2021 10:01:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 06/11] xfs: Check for extent overflow when
 adding/removing dir entries
Message-ID: <20210303180154.GN7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-7-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-7-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:17AM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when adding/removing directory entries.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/526     | 186 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/526.out |  17 +++++
>  tests/xfs/group   |   1 +
>  3 files changed, 204 insertions(+)
>  create mode 100755 tests/xfs/526
>  create mode 100644 tests/xfs/526.out
> 
> diff --git a/tests/xfs/526 b/tests/xfs/526
> new file mode 100755
> index 00000000..5a789d61
> --- /dev/null
> +++ b/tests/xfs/526
> @@ -0,0 +1,186 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 526
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
> +if (( $dbsize != $dirbsize )); then
> +	_notrun "FSB size ($dbsize) and directory block size ($dirbsize) do not match"
> +fi

But what about the case where fsb is 1k and dirblocks are 4k? :)

I admit I'm reacting to my expectation that we would _notrun here based
on the output of a more computation, not just fsb != dirblocksize.  But
I dunno, maybe you've already worked that out?

(The rest of the test looks good to me.)

--D

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
> +nextents=$($XFS_IO_PROG -c 'stat' $testdir | grep nextents)
> +nextents=${nextents##fsxattr.nextents = }
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
> +nextents=$($XFS_IO_PROG -c 'stat' $dstdir | grep nextents)
> +nextents=${nextents##fsxattr.nextents = }
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
> +nextents=$($XFS_IO_PROG -c 'stat' $testdir | grep nextents)
> +nextents=${nextents##fsxattr.nextents = }
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
> +nextents=$($XFS_IO_PROG -c 'stat' $testdir | grep nextents)
> +nextents=${nextents##fsxattr.nextents = }
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
> diff --git a/tests/xfs/526.out b/tests/xfs/526.out
> new file mode 100644
> index 00000000..d055f56d
> --- /dev/null
> +++ b/tests/xfs/526.out
> @@ -0,0 +1,17 @@
> +QA output created by 526
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
> index bd38aff0..d089797b 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -523,3 +523,4 @@
>  523 auto quick realtime growfs
>  524 auto quick punch zero insert collapse
>  525 auto quick attr
> +526 auto quick dir hardlink symlink
> -- 
> 2.29.2
> 
