Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA48CC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6A2A65230
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhCHSKe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 13:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhCHSKD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 13:10:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B07E5652AC;
        Mon,  8 Mar 2021 18:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615227002;
        bh=xckpKzq15IHurGyc2N259ePiZTmEPSywsDoFN2xFduQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JAtgCVSNpsjF+Lo5hBkOP8eGI9f2rUcZQ3eP+RMjsRZeF8QkVK90W6r+uhi28cULd
         FzLjzhP15aUM7Z+7V+XWduUGPqYSFbDY+6FjPUux6xexIHC+52tdEtOonkCOBgNs2C
         hgd+fjEv1AfDmc2H0dfhHxGGbjgX3TlWEztTuva+t6Hba1/hG6qRBspSW3zZ/z533j
         yvE4WfQkwam98jRPCy/8i0FCcCvGWqvJziTFQu/hhDLMl7EpcNaz0VViabodUVwAqS
         VCS/iYyRvRmuPQhqNjHi+qASgz7CrDUb42/m+lub0BroN/8371qLVYo7CeiE3zGJtH
         99kVnuKFUc+Bg==
Date:   Mon, 8 Mar 2021 10:10:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 05/13] xfs: Check for extent overflow when growing
 realtime bitmap/summary inodes
Message-ID: <20210308181002.GS3419940@magnolia>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
 <20210308155111.53874-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308155111.53874-6-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 09:21:03PM +0530, Chandan Babu R wrote:
> Verify that XFS does not cause realtime bitmap/summary inode fork's
> extent count to overflow when growing the realtime volume associated
> with a filesystem.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/529     | 124 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/529.out |  11 ++++
>  tests/xfs/group   |   1 +
>  3 files changed, 136 insertions(+)
>  create mode 100755 tests/xfs/529
>  create mode 100644 tests/xfs/529.out
> 
> diff --git a/tests/xfs/529 b/tests/xfs/529
> new file mode 100755
> index 00000000..dd7019f5
> --- /dev/null
> +++ b/tests/xfs/529
> @@ -0,0 +1,124 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 529
> +#
> +# Verify that XFS does not cause bitmap/summary inode fork's extent count to
> +# overflow when growing an the realtime volume of the filesystem.
> +#
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
> +	_scratch_unmount >> $seqres.full 2>&1
> +	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
> +	rm -f $tmp.* $TEST_DIR/$seq.rtvol
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
> +# Note that we don't _require_realtime because we synthesize a rt volume
> +# below.
> +_require_test
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +_require_scratch_nocheck
> +
> +echo "* Test extending rt inodes"
> +
> +_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +. $tmp.mkfs
> +
> +echo "Create fake rt volume"
> +nr_bitmap_blks=25
> +nr_bits=$((nr_bitmap_blks * dbsize * 8))
> +
> +# Realtime extent size has to be atleast 4k in size.
> +if (( $dbsize < 4096 )); then
> +	rtextsz=4096
> +else
> +	rtextsz=$dbsize
> +fi
> +
> +rtdevsz=$((nr_bits * rtextsz))
> +truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
> +rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
> +
> +echo "Format and mount rt volume"
> +
> +export USE_EXTERNAL=yes
> +export SCRATCH_RTDEV=$rtdev
> +_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
> +	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
> +_try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
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
> +echo "Grow realtime volume"
> +$XFS_GROWFS_PROG -r $SCRATCH_MNT >> $seqres.full 2>&1
> +if [[ $? == 0 ]]; then
> +	echo "Growfs succeeded; should have failed."
> +	exit 1
> +fi
> +
> +_scratch_unmount >> $seqres.full
> +
> +echo "Verify rbmino's and rsumino's extent count"
> +for rtino in rbmino rsumino; do
> +	ino=$(_scratch_xfs_get_metadata_field $rtino "sb 0")
> +	echo "$rtino = $ino" >> $seqres.full
> +
> +	nextents=$(_scratch_get_iext_count $ino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +done
> +
> +echo "Check filesystem"
> +_check_xfs_filesystem $SCRATCH_DEV none $rtdev
> +
> +losetup -d $rtdev
> +rm -f $TEST_DIR/$seq.rtvol
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/529.out b/tests/xfs/529.out
> new file mode 100644
> index 00000000..4ee113a4
> --- /dev/null
> +++ b/tests/xfs/529.out
> @@ -0,0 +1,11 @@
> +QA output created by 529
> +* Test extending rt inodes
> +Create fake rt volume
> +Format and mount rt volume
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Grow realtime volume
> +Verify rbmino's and rsumino's extent count
> +Check filesystem
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 2356c4a9..5dff7acb 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -526,3 +526,4 @@
>  526 auto quick mkfs
>  527 auto quick quota
>  528 auto quick quota
> +529 auto quick realtime growfs
> -- 
> 2.29.2
> 
