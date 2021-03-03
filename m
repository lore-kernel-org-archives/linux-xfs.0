Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36711C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 099B86146D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354990AbhCDAR7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231989AbhCCSFw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:05:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A981864EBD;
        Wed,  3 Mar 2021 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614794709;
        bh=WDGSbBzTgy9G9AO/iUzjw+YdPBHUioTESYu2e9BbbaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I6biDLuBnIVHGkBtlHKCa1cnu5tGMAZN7FSgJcuqAjdD/fySNocV0acMr3Obsnn8T
         wF9IvHfOzqWoe5dJ838Fw5O+C3Kv/s23+/KZTQzTuTOXJInwYlzccbB7iN+VbWAHs1
         iYZ/fdAt+bXDLBxc7Cyg0j0lQ72oR8NW9X9QF8YeRnnLlp4avU24e755JFP4MDQXAh
         H55Ud1+ZPiPgi9pTx9MuD0QHZbHXT/J5004c4j59BXq1HDbNjhoRWhcuVwBjtoh9EC
         h6++7/8vgCMxcsqaAS0thRHZb3QfrWWs1GEazbcJFL2gpgUB6zaM3bKqvwjn5XSHaW
         zfNUl0Z83oEWw==
Date:   Wed, 3 Mar 2021 10:05:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 07/11] xfs: Check for extent overflow when writing to
 unwritten extent
Message-ID: <20210303180508.GO7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-8-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-8-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:18AM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when writing to an unwritten extent.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/527     | 89 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/527.out | 11 ++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 101 insertions(+)
>  create mode 100755 tests/xfs/527
>  create mode 100644 tests/xfs/527.out
> 
> diff --git a/tests/xfs/527 b/tests/xfs/527
> new file mode 100755
> index 00000000..cd67bce4
> --- /dev/null
> +++ b/tests/xfs/527
> @@ -0,0 +1,89 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 527
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

# First test buffered writes, then direct writes.
for $xfs_io_flag in "" "-d"; do ?

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

...because then you can skip this part.

> +
> +	echo "$io write to every other block of fallocated space"
> +	for i in $(seq 1 2 $((nr_blks - 1))); do
> +		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
> +		       $testfile >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	echo "Verify \$testfile's extent count"
> +	nextents=$($XFS_IO_PROG -c 'stat' $testfile | grep nextents)
> +	nextents=${nextents##fsxattr.nextents = }
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +
> +	rm $testfile
> +done
> +
> +# super_block->s_wb_err will have a newer seq value when compared to "/"'s
> +# file->f_sb_err. Consume it here so that xfs_scrub can does not error out.
> +$XFS_IO_PROG -c syncfs $SCRATCH_MNT >> $seqres.full 2>&1

I wonder, should _check_xfs_filesystem should syncfs to clear old EIOs
before running xfs_scrub?  I occasionally see this pop up on
generic/204.

(Everything else here looks ok.)

--D

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/527.out b/tests/xfs/527.out
> new file mode 100644
> index 00000000..3597ad92
> --- /dev/null
> +++ b/tests/xfs/527.out
> @@ -0,0 +1,11 @@
> +QA output created by 527
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
> index d089797b..627813fe 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -524,3 +524,4 @@
>  524 auto quick punch zero insert collapse
>  525 auto quick attr
>  526 auto quick dir hardlink symlink
> +527 auto quick
> -- 
> 2.29.2
> 
