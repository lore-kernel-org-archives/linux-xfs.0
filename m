Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF58C432C3
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF9264F14
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243297AbhCDASE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243468AbhCCSNJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:13:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D6DF64EF6;
        Wed,  3 Mar 2021 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614795029;
        bh=9l6fWymWzWU8UebVBsO//46r3x1kyep6FPNCGXarAXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z111x1/3IWOxl9jU9MC10pR5vaWNv0M3i/y7La5PhVJcq3FvAEtweT59X7mSJu8eN
         0f55kcSBPHgrjwJM/gvj1ImfYvAGStaamwLWBr0FrSyn5vcMCH45Pnwk3K0+7a/mW/
         77agXTBp1Otwns59n5kJ7YheKvPoMZ+/HdFwk5rMipXi8jOddl0i94n5JTSm1sIa5m
         NgzocIVcubCZZjguOjnYf2gCmXK9sh/ZC4rsxlsCgwGQX5Uaz96wc++xQ0yVckJ2di
         8EHVNduETVNLZKjzumizgTdK8qT7Lxq+8znTh604NY3fHC0QJ4MmJDnw0y3tmLfr44
         5drGguuj0U6iQ==
Date:   Wed, 3 Mar 2021 10:10:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 10/11] xfs: Check for extent overflow when swapping
 extents
Message-ID: <20210303181028.GR7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-11-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-11-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:21AM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when swapping forks across two files.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/530     | 109 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/530.out |  13 ++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 123 insertions(+)
>  create mode 100755 tests/xfs/530
>  create mode 100644 tests/xfs/530.out
> 
> diff --git a/tests/xfs/530 b/tests/xfs/530
> new file mode 100755
> index 00000000..0986d8bf
> --- /dev/null
> +++ b/tests/xfs/530
> @@ -0,0 +1,109 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.

2021? :D

Otherwise this looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +#
> +# FS QA Test 530
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# swapping forks between files
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
> +_require_xfs_scratch_rmapbt
> +_require_xfs_io_command "fcollapse"
> +_require_xfs_io_command "swapext"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "* Swap extent forks"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +donorfile=${SCRATCH_MNT}/donorfile
> +
> +echo "Create \$donorfile having an extent of length 67 blocks"
> +$XFS_IO_PROG -f -s -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" $donorfile \
> +       >> $seqres.full
> +
> +# After the for loop the donor file will have the following extent layout
> +# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
> +echo "Fragment \$donorfile"
> +for i in $(seq 5 10); do
> +	start_offset=$((i * bsize))
> +	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
> +done
> +
> +echo "Create \$srcfile having an extent of length 18 blocks"
> +$XFS_IO_PROG -f -s -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" $srcfile \
> +       >> $seqres.full
> +
> +echo "Fragment \$srcfile"
> +# After the for loop the src file will have the following extent layout
> +# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
> +for i in $(seq 1 7); do
> +	start_offset=$((i * bsize))
> +	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
> +done
> +
> +echo "Collect \$donorfile's extent count"
> +donor_nr_exts=$($XFS_IO_PROG -c 'stat' $donorfile | grep nextents)
> +donor_nr_exts=${donor_nr_exts##fsxattr.nextents = }
> +
> +echo "Collect \$srcfile's extent count"
> +src_nr_exts=$($XFS_IO_PROG -c 'stat' $srcfile | grep nextents)
> +src_nr_exts=${src_nr_exts##fsxattr.nextents = }
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Swap \$srcfile's and \$donorfile's extent forks"
> +$XFS_IO_PROG -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
> +
> +echo "Check for \$donorfile's extent count overflow"
> +nextents=$($XFS_IO_PROG -c 'stat' $donorfile | grep nextents)
> +nextents=${nextents##fsxattr.nextents = }
> +
> +if (( $nextents == $src_nr_exts )); then
> +	echo "\$donorfile: Extent count overflow check failed"
> +fi
> +
> +echo "Check for \$srcfile's extent count overflow"
> +nextents=$($XFS_IO_PROG -c 'stat' $srcfile | grep nextents)
> +nextents=${nextents##fsxattr.nextents = }
> +
> +if (( $nextents == $donor_nr_exts )); then
> +	echo "\$srcfile: Extent count overflow check failed"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/530.out b/tests/xfs/530.out
> new file mode 100644
> index 00000000..9f55608b
> --- /dev/null
> +++ b/tests/xfs/530.out
> @@ -0,0 +1,13 @@
> +QA output created by 530
> +* Swap extent forks
> +Format and mount fs
> +Create $donorfile having an extent of length 67 blocks
> +Fragment $donorfile
> +Create $srcfile having an extent of length 18 blocks
> +Fragment $srcfile
> +Collect $donorfile's extent count
> +Collect $srcfile's extent count
> +Inject reduce_max_iextents error tag
> +Swap $srcfile's and $donorfile's extent forks
> +Check for $donorfile's extent count overflow
> +Check for $srcfile's extent count overflow
> diff --git a/tests/xfs/group b/tests/xfs/group
> index bc3958b3..81a15582 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -527,3 +527,4 @@
>  527 auto quick
>  528 auto quick reflink
>  529 auto quick reflink
> +530 auto quick
> -- 
> 2.29.2
> 
