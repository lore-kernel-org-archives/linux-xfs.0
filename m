Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E529C4332E
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2056D64EC4
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354993AbhCDASA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235125AbhCCSHM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:07:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D0364EE8;
        Wed,  3 Mar 2021 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614794084;
        bh=pweVE7sRsvmpi/wnf92VkKu15qkfy8yGAeYAZvf5Ipw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cfPc3FyJNdHvR+bX3JywyEpP01JeDKHkwHr/eKQEg4Js1sV4w2seWcN3y+5rkV+xJ
         atatbRo0BDA7QetSNmytApH0STnW0AbNNqCsViGljdsZj8WV9C2DERHmy6K57MC0av
         9JE5bG4BSGVyUeuCxLo/VH60/NQKREaRVZliv8L6Lxyoz+O3e/NJaZM3TFZIUSMjoK
         aiTC6L95uhOhH5KCy/FkOQJBln3POk0YdxpW+9qqP2LzJrjkNLCvLQvhqMyQ5VskdE
         HEPy3JfH7jtwwSwo8vj45/zte97ud3oT/L8oq5Pxp0/BKVth+v6k4Yiq5FIVl+baud
         Pkag/BnQyEEmw==
Date:   Wed, 3 Mar 2021 09:54:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 04/11] xfs: Check for extent overflow when punching a
 hole
Message-ID: <20210303175443.GL7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-5-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:15AM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when punching out an extent.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/524     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/524.out | 19 +++++++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 104 insertions(+)
>  create mode 100755 tests/xfs/524
>  create mode 100644 tests/xfs/524.out
> 
> diff --git a/tests/xfs/524 b/tests/xfs/524
> new file mode 100755
> index 00000000..79fa31d8
> --- /dev/null
> +++ b/tests/xfs/524
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 524
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# punching out an extent.
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
> +_require_xfs_io_command "fpunch"
> +_require_xfs_io_command "finsert"
> +_require_xfs_io_command "fcollapse"
> +_require_xfs_io_command "fzero"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +nr_blks=30
> +
> +testfile=$SCRATCH_MNT/testfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +for op in fpunch finsert fcollapse fzero; do
> +	echo "* $op regular file"
> +
> +	echo "Create \$testfile"
> +	$XFS_IO_PROG -f -s \
> +		     -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> +		     $testfile  >> $seqres.full
> +
> +	echo "$op alternating blocks"
> +	for i in $(seq 1 2 $((nr_blks - 1))); do
> +		$XFS_IO_PROG -f -c "$op $((i * bsize)) $bsize" $testfile \
> +		       >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	echo "Verify \$testfile's extent count"
> +
> +	nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
> +	nextents=${nextents##fsxattr.nextents = }

Modulo my comment about refactoring fsgetxattr output into a common
helper, the rest looks ok:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

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
> diff --git a/tests/xfs/524.out b/tests/xfs/524.out
> new file mode 100644
> index 00000000..a957f9c7
> --- /dev/null
> +++ b/tests/xfs/524.out
> @@ -0,0 +1,19 @@
> +QA output created by 524
> +Format and mount fs
> +Inject reduce_max_iextents error tag
> +* fpunch regular file
> +Create $testfile
> +fpunch alternating blocks
> +Verify $testfile's extent count
> +* finsert regular file
> +Create $testfile
> +finsert alternating blocks
> +Verify $testfile's extent count
> +* fcollapse regular file
> +Create $testfile
> +fcollapse alternating blocks
> +Verify $testfile's extent count
> +* fzero regular file
> +Create $testfile
> +fzero alternating blocks
> +Verify $testfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 018c70ef..3fa38c36 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -521,3 +521,4 @@
>  521 auto quick realtime growfs
>  522 auto quick quota
>  523 auto quick realtime growfs
> +524 auto quick punch zero insert collapse
> -- 
> 2.29.2
> 
