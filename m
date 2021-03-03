Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A783BC4332D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C6E64EC4
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354917AbhCDAR6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344052AbhCCR6o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 12:58:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72BEC64EED;
        Wed,  3 Mar 2021 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614794177;
        bh=kFvPNVdfCAFGkP+YzVdtONNHlqRTWslZjwwisWUKQts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A98GtRj4dGSVlBofyBkpUWxfX3k1ix5aGcGekavpUCHF+hld8wtSHZZ+Cbfebn3VU
         G8osdUtBcw2nCSkgzDBLT/RnG2SvkCxfoJYVUdwbGL/eBdBroN/ur7MYTa3oFw7V4+
         Xlit+ybQEvguNA3O7MX09pP4bd2ugjUutmIA+NsXnwM6PRjytZjRsLF/5saQmadTo+
         rGg8wkQb3Ua1qnwlY+MRrbO39RRk6syD2ojPOORgXAxQXTHC2LWZq4nBMeSGhhq04K
         FJ5YYy1kGusf0AKwxCt87rNAejDydf40eXdItOwye44sTtxc//q4P2XPgdmx2BuKkB
         /qUvDLUHAzLTA==
Date:   Wed, 3 Mar 2021 09:56:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 05/11] xfs: Check for extent overflow when
 adding/removing xattrs
Message-ID: <20210303175616.GM7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-6-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:16AM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when adding/removing xattrs.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/525     | 141 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/525.out |  18 ++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 160 insertions(+)
>  create mode 100755 tests/xfs/525
>  create mode 100644 tests/xfs/525.out
> 
> diff --git a/tests/xfs/525 b/tests/xfs/525
> new file mode 100755
> index 00000000..bdca846d
> --- /dev/null
> +++ b/tests/xfs/525
> @@ -0,0 +1,141 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 525
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# Adding/removing xattrs.

Nit: 'adding' (no need to capitalize)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


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
> +. ./common/attr
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
> +_require_attrs
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +attr_len=255
> +
> +testfile=$SCRATCH_MNT/testfile
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
> +
> +echo "* Set xattrs"
> +
> +echo "Create \$testfile"
> +touch $testfile
> +
> +echo "Create xattrs"
> +nr_attrs=$((bsize * 20 / attr_len))
> +for i in $(seq 1 $nr_attrs); do
> +	attr="$(printf "trusted.%0247d" $i)"
> +	$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$testfile's naextent count"
> +
> +naextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep naextents)
> +naextents=${naextents##fsxattr.naextents = }
> +if (( $naextents > 10 )); then
> +	echo "Extent count overflow check failed: naextents = $naextents"
> +	exit 1
> +fi
> +
> +echo "Remove \$testfile"
> +rm $testfile
> +
> +echo "* Remove xattrs"
> +
> +echo "Create \$testfile"
> +touch $testfile
> +
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
> +
> +echo "Create initial xattr extents"
> +
> +naextents=0
> +last=""
> +start=1
> +nr_attrs=$((bsize / attr_len))
> +
> +while (( $naextents < 4 )); do
> +	end=$((start + nr_attrs - 1))
> +
> +	for i in $(seq $start $end); do
> +		attr="$(printf "trusted.%0247d" $i)"
> +		$SETFATTR_PROG -n $attr $testfile
> +	done
> +
> +	start=$((end + 1))
> +
> +	naextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep naextents)
> +	naextents=${naextents##fsxattr.naextents = }
> +done
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Remove xattr to trigger -EFBIG"
> +attr="$(printf "trusted.%0247d" 1)"
> +$SETFATTR_PROG -x "$attr" $testfile >> $seqres.full 2>&1
> +if [[ $? == 0 ]]; then
> +	echo "Xattr removal succeeded; Should have failed "
> +	exit 1
> +fi
> +
> +rm $testfile && echo "Successfully removed \$testfile"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/525.out b/tests/xfs/525.out
> new file mode 100644
> index 00000000..74b152d9
> --- /dev/null
> +++ b/tests/xfs/525.out
> @@ -0,0 +1,18 @@
> +QA output created by 525
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +* Set xattrs
> +Create $testfile
> +Create xattrs
> +Verify $testfile's naextent count
> +Remove $testfile
> +* Remove xattrs
> +Create $testfile
> +Disable reduce_max_iextents error tag
> +Create initial xattr extents
> +Inject reduce_max_iextents error tag
> +Remove xattr to trigger -EFBIG
> +Successfully removed $testfile
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 3fa38c36..bd38aff0 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -522,3 +522,4 @@
>  522 auto quick quota
>  523 auto quick realtime growfs
>  524 auto quick punch zero insert collapse
> +525 auto quick attr
> -- 
> 2.29.2
> 
