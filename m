Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D71EC433E6
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C7E065230
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCHSRG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 13:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230522AbhCHSQb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 13:16:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F31F26518A;
        Mon,  8 Mar 2021 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615227391;
        bh=+/l3ItmTnnwBNhmG3m1j45wN9HrJJSnSevZ8JAk6RDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M8xDBwjDhHVCsO6yQRPUfxRJ1bJGhxRHBcOpX/QzEVUFUnwFM90i1KtN/+6kaY8d3
         WamyjqtWtTpglCwaKyEhHkKAcrTakyarIyUzx9NoDLJtGDrjR14ftLqGB9WgjSIdH0
         MQmFDKbw/dEBkDP5MrKqFp+dKXEyENbH4UTArvsGL3rBbmbSiS88HsKJCPIW7i5OWF
         WfuCAtYEoCYekaitzolzcOQXgorG3uSTwbVonQ0sgR9PHbi3SP1Civvp9qkqBGOf3J
         mg9LjDgEoexJKf1UruzjCW8UXGFb0JYLnxQjF35PEtoq6fGiElD8jIf5zZMvD/RPhY
         17w+8xP4lERnQ==
Date:   Mon, 8 Mar 2021 10:16:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 09/13] xfs: Check for extent overflow when writing to
 unwritten extent
Message-ID: <20210308181630.GU3419940@magnolia>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
 <20210308155111.53874-10-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308155111.53874-10-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 09:21:07PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when writing to an unwritten extent.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---

Looks fine to me now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  tests/xfs/533     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/533.out | 11 +++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 96 insertions(+)
>  create mode 100755 tests/xfs/533
>  create mode 100644 tests/xfs/533.out
> 
> diff --git a/tests/xfs/533 b/tests/xfs/533
> new file mode 100755
> index 00000000..af7475f0
> --- /dev/null
> +++ b/tests/xfs/533
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 533
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# writing to an unwritten extent.
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
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_debug
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +
> +testfile=${SCRATCH_MNT}/testfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +nr_blks=15
> +
> +for io in Buffered Direct; do
> +	echo "* $io write to unwritten extent"
> +
> +	echo "Fallocate $nr_blks blocks"
> +	$XFS_IO_PROG -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
> +
> +	if [[ $io == "Buffered" ]]; then
> +		xfs_io_flag=""
> +	else
> +		xfs_io_flag="-d"
> +	fi
> +
> +	echo "$io write to every other block of fallocated space"
> +	for i in $(seq 1 2 $((nr_blks - 1))); do
> +		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
> +		       $testfile >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	echo "Verify \$testfile's extent count"
> +	nextents=$(xfs_get_fsxattr nextents $testfile)
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +
> +	rm $testfile
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/533.out b/tests/xfs/533.out
> new file mode 100644
> index 00000000..5b93964a
> --- /dev/null
> +++ b/tests/xfs/533.out
> @@ -0,0 +1,11 @@
> +QA output created by 533
> +Format and mount fs
> +Inject reduce_max_iextents error tag
> +* Buffered write to unwritten extent
> +Fallocate 15 blocks
> +Buffered write to every other block of fallocated space
> +Verify $testfile's extent count
> +* Direct write to unwritten extent
> +Fallocate 15 blocks
> +Direct write to every other block of fallocated space
> +Verify $testfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 77abeefa..3ad47d07 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -530,3 +530,4 @@
>  530 auto quick punch zero insert collapse
>  531 auto quick attr
>  532 auto quick dir hardlink symlink
> +533 auto quick
> -- 
> 2.29.2
> 
