Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DC5C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E02B65218
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCHSTP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 13:19:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230517AbhCHSTD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 13:19:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87CE164DA3;
        Mon,  8 Mar 2021 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615227543;
        bh=EDOVQcjsxktf/57dRLoO9NBtPoY2YucaJIj2qVe1+R4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L7SyQuaYZIwLgmhuQggaQKRyxZueyn9y7AwoWWn8KFz8UQuko5KBNS8cDAaYS/qN+
         EeLZ+OUJ2hsnNvXa2YQKhpVHmoOiCR5KY5HnY0zPpAcBjLiQLShb0IFfyOZ/flxb96
         OXCbpu4tXDIXz0QnOIsrJ8SjqSVXBWt0AXU4DG+bXZrBtsA9pBQuem45vtC1Vsw+EY
         yHoWsdjFLcctuYP3GpqWhIXtRo5EJlErHPGttS8/1yiwWkrB7Trk9herpq1dP6MPUZ
         0G9O7a40Hq4CDOpEYhFQkr/ntay1HzZZc3+hgG+UJKJMkjIABFM2TrYd7EIfQMPCSA
         s/boHN0cdHYOQ==
Date:   Mon, 8 Mar 2021 10:19:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 11/13] xfs: Check for extent overflow when remapping
 an extent
Message-ID: <20210308181902.GW3419940@magnolia>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
 <20210308155111.53874-12-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308155111.53874-12-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 09:21:09PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when remapping extents from one file's inode fork to another.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Seems sensible,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/535     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/535.out |  8 +++++
>  tests/xfs/group   |  1 +
>  3 files changed, 90 insertions(+)
>  create mode 100755 tests/xfs/535
>  create mode 100644 tests/xfs/535.out
> 
> diff --git a/tests/xfs/535 b/tests/xfs/535
> new file mode 100755
> index 00000000..6bb27c92
> --- /dev/null
> +++ b/tests/xfs/535
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 535
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# remapping extents from one file's inode fork to another.
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
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "* Reflink remap extents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +dstfile=${SCRATCH_MNT}/dstfile
> +
> +nr_blks=15
> +
> +echo "Create \$srcfile having an extent of length $nr_blks blocks"
> +$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $srcfile >> $seqres.full
> +
> +echo "Create \$dstfile having an extent of length $nr_blks blocks"
> +$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $dstfile >> $seqres.full
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Reflink every other block from \$srcfile into \$dstfile"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	_reflink_range $srcfile $((i * bsize)) $dstfile $((i * bsize)) $bsize \
> +		       >> $seqres.full 2>&1
> +done
> +
> +echo "Verify \$dstfile's extent count"
> +nextents=$(xfs_get_fsxattr nextents $dstfile)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/535.out b/tests/xfs/535.out
> new file mode 100644
> index 00000000..cfe50f45
> --- /dev/null
> +++ b/tests/xfs/535.out
> @@ -0,0 +1,8 @@
> +QA output created by 535
> +* Reflink remap extents
> +Format and mount fs
> +Create $srcfile having an extent of length 15 blocks
> +Create $dstfile having an extent of length 15 blocks
> +Inject reduce_max_iextents error tag
> +Reflink every other block from $srcfile into $dstfile
> +Verify $dstfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index b4f0c777..aed06494 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -532,3 +532,4 @@
>  532 auto quick dir hardlink symlink
>  533 auto quick
>  534 auto quick reflink
> +535 auto quick reflink
> -- 
> 2.29.2
> 
