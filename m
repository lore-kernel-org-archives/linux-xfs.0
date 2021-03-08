Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41C2C433E9
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FEF66148E
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 18:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhCHSSm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 13:18:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhCHSSL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 13:18:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F0B865230;
        Mon,  8 Mar 2021 18:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615227491;
        bh=P9ZldR8ZJ3Y92ITd4uifkHkocNkDJAtwr1quUWIBlOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oPoO4CVWdo6fK0/7HBBOIssvpAT7OiDaQeQq8KYrKtIGuINTprcWY+OCbw4n/4nQ7
         gpEckooj0d8bSrfm5MhXMVv0DhWom/mgGE2Hit0X+SnrOiXiuJvabKgk6w2ihgPcYK
         JkLsb40HdElYv8FwU8oi///HI08iSOHD8HBU34ucIk47x+eFlu1gEbQmEOYLsHOHOR
         biLI8zbhL7lolJiDd1tXOljVLQfUd+oUL5Khqz9AIbRcxgpag6+I6JaxuM+GbU5+NS
         aGaTxlgWyQm5bg0pO1OH953vyLITTUd65f7oiymyS+UcGleAfVTTKAEx8WjQbBBVtT
         OMqCZvourKYrQ==
Date:   Mon, 8 Mar 2021 10:18:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 10/13] xfs: Check for extent overflow when moving
 extent from cow to data fork
Message-ID: <20210308181810.GV3419940@magnolia>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
 <20210308155111.53874-11-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308155111.53874-11-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 09:21:08PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when writing to/funshare-ing a shared extent.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks fine,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/534     | 104 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/534.out |  12 ++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 117 insertions(+)
>  create mode 100755 tests/xfs/534
>  create mode 100644 tests/xfs/534.out
> 
> diff --git a/tests/xfs/534 b/tests/xfs/534
> new file mode 100755
> index 00000000..c2fa6cb6
> --- /dev/null
> +++ b/tests/xfs/534
> @@ -0,0 +1,104 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 534
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
> +_reflink $srcfile $dstfile >> $seqres.full
> +
> +echo "Buffered write to every other block of \$dstfile's shared extent"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $dstfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$dstfile's extent count"
> +nextents=$(xfs_get_fsxattr nextents $dstfile)
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
> +_reflink $srcfile $dstfile >> $seqres.full
> +
> +echo "Funshare every other block of \$dstfile's shared extent"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -s -c "funshare $((i * bsize)) $bsize" $dstfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
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
> + 
> diff --git a/tests/xfs/534.out b/tests/xfs/534.out
> new file mode 100644
> index 00000000..53288d12
> --- /dev/null
> +++ b/tests/xfs/534.out
> @@ -0,0 +1,12 @@
> +QA output created by 534
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
> index 3ad47d07..b4f0c777 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -531,3 +531,4 @@
>  531 auto quick attr
>  532 auto quick dir hardlink symlink
>  533 auto quick
> +534 auto quick reflink
> -- 
> 2.29.2
> 
