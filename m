Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C1FC43333
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F39C64EE6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhCDASF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347605AbhCCSNS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:13:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6142064EE4;
        Wed,  3 Mar 2021 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614795123;
        bh=jyaYGhe7SHBLFJN63XZPxmo0g2Gv8zD6NDmqEY8ZEI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jMTSMzrl6udR7QuL6g3aJSp1fMCQVS5iSQUq/WJHgmGAE/lPFcGrD0rB7PVlsT4Ke
         LJhVZzzlio2RPV9wLz95RIWWsj+zjM4isVbyW2sHgpF9ZqOTUTn9MF6yM4UFCPPP0O
         Tvq9Cl4hVibkecjPLFBN272VCd+NpQPFrVeMOTsQzY4NBE4x6Cb0f1baNHChmORXeL
         EreXoqq3+gmEcnZcteLN21NYBsMOuQnKlWPpOg1jmfeamHxELcegauR24Vd5yX6ABE
         hzyzG6zHo1ayG0UAipwr8nLEOyRmL1F2Ur3pxPHQ7+27GjSOWr6wE/637ScA7i95xQ
         3ZKUmhXERyU3Q==
Date:   Wed, 3 Mar 2021 10:12:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 11/11] xfs: Stress test with bmap_alloc_minlen_extent
 error tag enabled
Message-ID: <20210303181202.GS7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-12-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-12-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:22AM +0530, Chandan Babu R wrote:
> This commit adds a stress test that executes fsstress with
> bmap_alloc_minlen_extent error tag enabled.

Haha, yikes.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/531     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/531.out |  7 ++++
>  tests/xfs/group   |  1 +
>  3 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/531
>  create mode 100644 tests/xfs/531.out
> 
> diff --git a/tests/xfs/531 b/tests/xfs/531
> new file mode 100755
> index 00000000..fd92c3ea
> --- /dev/null
> +++ b/tests/xfs/531
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 531
> +#
> +# Execute fsstress with bmap_alloc_minlen_extent error tag enabled.
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
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
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
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +echo "Scale fsstress args"
> +args=$(_scale_fsstress_args -p $((LOAD_FACTOR * 75)) -n $((TIME_FACTOR * 1000)))
> +
> +echo "Execute fsstress in background"
> +$FSSTRESS_PROG -d $SCRATCH_MNT $args \
> +		 -f bulkstat=0 \
> +		 -f bulkstat1=0 \
> +		 -f fiemap=0 \
> +		 -f getattr=0 \
> +		 -f getdents=0 \
> +		 -f getfattr=0 \
> +		 -f listfattr=0 \
> +		 -f mread=0 \
> +		 -f read=0 \
> +		 -f readlink=0 \
> +		 -f readv=0 \
> +		 -f stat=0 \
> +		 -f aread=0 \
> +		 -f dread=0 > /dev/null 2>&1
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/531.out b/tests/xfs/531.out
> new file mode 100644
> index 00000000..67f40654
> --- /dev/null
> +++ b/tests/xfs/531.out
> @@ -0,0 +1,7 @@
> +QA output created by 531
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject bmap_alloc_minlen_extent error tag
> +Scale fsstress args
> +Execute fsstress in background
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 81a15582..f4cb5af6 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -528,3 +528,4 @@
>  528 auto quick reflink
>  529 auto quick reflink
>  530 auto quick
> +531 auto stress
> -- 
> 2.29.2
> 
