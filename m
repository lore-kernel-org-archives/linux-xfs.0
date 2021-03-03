Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59539C43332
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3436F64F14
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354996AbhCDASD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237751AbhCCSIl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:08:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B8864EE9;
        Wed,  3 Mar 2021 18:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614794870;
        bh=c/0Nw26Evz1ipPg2E91Z3z57/L/m1hJeG8RBYeOW+w0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q32em7TxZVO9bjiiK9UE+mfyq+suEgWS89//PxiO91WfYVPQSuIdFm55mL3fJzOgl
         3tefQRbtbRkLrb+MV5ulWi9p51CXiKBU89c+L20KTGb9kBrtM2R4P9AeurritSUl75
         6P3kijw4cR4PZoxK/kWrNVbkscxfPeJNP6aZGGXI3D3JyLmpuIciNP94quZJ+OHz8o
         tqs5W1dRwovQ5dCdJmD6sTlQzSOqs5MSVRlqxtd8ctCyQSoPN+3bfq3j5BjqtAPxux
         tS7LJMOKw1sWpqsLWtU8Hu8hNftmKYYJQzjWNyxpIdXTbaYp0nRkMyizCbsN9fAcoY
         hhVSML4W0BFZw==
Date:   Wed, 3 Mar 2021 10:07:50 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 08/11] xfs: Check for extent overflow when moving
 extent from cow to data fork
Message-ID: <20210303180750.GP7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-9-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-9-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:19AM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when writing to/funshare-ing a shared extent.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/528     | 110 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/528.out |  12 +++++
>  tests/xfs/group   |   1 +
>  3 files changed, 123 insertions(+)
>  create mode 100755 tests/xfs/528
>  create mode 100644 tests/xfs/528.out
> 
> diff --git a/tests/xfs/528 b/tests/xfs/528
> new file mode 100755
> index 00000000..269d368d
> --- /dev/null
> +++ b/tests/xfs/528
> @@ -0,0 +1,110 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 528
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# writing to a shared extent.
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
> +. ./common/reflink
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_reflink
> +_require_xfs_debug
> +_require_xfs_io_command "reflink"
> +_require_xfs_io_command "funshare"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +nr_blks=15
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +dstfile=${SCRATCH_MNT}/dstfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Create a \$srcfile having an extent of length $nr_blks blocks"
> +$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $srcfile  >> $seqres.full
> +
> +echo "* Write to shared extent"
> +
> +echo "Share the extent with \$dstfile"
> +$XFS_IO_PROG -f -c "reflink $srcfile" $dstfile >> $seqres.full

_reflink?

> +
> +echo "Buffered write to every other block of \$dstfile's shared extent"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $dstfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$dstfile's extent count"
> +nextents=$($XFS_IO_PROG -c 'stat' $dstfile | grep nextents)
> +nextents=${nextents##fsxattr.nextents = }
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm $dstfile
> +
> +echo "* Funshare shared extent"
> +
> +echo "Share the extent with \$dstfile"
> +$XFS_IO_PROG -f -c "reflink $srcfile" $dstfile >> $seqres.full
> +
> +echo "Funshare every other block of \$dstfile's shared extent"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -s -c "funshare $((i * bsize)) $bsize" $dstfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$dstfile's extent count"
> +nextents=$($XFS_IO_PROG -c 'stat' $dstfile | grep nextents)
> +nextents=${nextents##fsxattr.nextents = }
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +# super_block->s_wb_err will have a newer seq value when compared to "/"'s
> +# file->f_sb_err. Consume it here so that xfs_scrub can does not error out.
> +$XFS_IO_PROG -c syncfs $SCRATCH_MNT >> $seqres.full 2>&1

Same code, hence same comments as the previous patch.

--D

> +
> +# success, all done
> +status=0
> +exit
> + 
> diff --git a/tests/xfs/528.out b/tests/xfs/528.out
> new file mode 100644
> index 00000000..d0f2c878
> --- /dev/null
> +++ b/tests/xfs/528.out
> @@ -0,0 +1,12 @@
> +QA output created by 528
> +Format and mount fs
> +Inject reduce_max_iextents error tag
> +Create a $srcfile having an extent of length 15 blocks
> +* Write to shared extent
> +Share the extent with $dstfile
> +Buffered write to every other block of $dstfile's shared extent
> +Verify $dstfile's extent count
> +* Funshare shared extent
> +Share the extent with $dstfile
> +Funshare every other block of $dstfile's shared extent
> +Verify $dstfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 627813fe..c85aac6b 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -525,3 +525,4 @@
>  525 auto quick attr
>  526 auto quick dir hardlink symlink
>  527 auto quick
> +528 auto quick reflink
> -- 
> 2.29.2
> 
