Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47471C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 15:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C7A61492
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 15:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhEKPYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 11:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231782AbhEKPYJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 11:24:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68E2661928;
        Tue, 11 May 2021 15:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620746581;
        bh=Mjw1/ZAhA+YHPeQY9bECU4nEmO6LJCQA9RJB7tt8U3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uOz2FX/GoeVmjuDM/3hpCYpUIvAEIMXO6BfB7MASjGYK+frecpYsw4srNaf76ayH1
         9WAFVuyOQOOHi0xygi/j9XVdnjW4DEA8f65JDx8RSq+RN+OJMukFuYOl6wzRxY95t/
         4iAe6BnM8F6LSXF1UGu7Dk4VNAgfybfjBrxMTDo/5/igoVlsURarA1Gyv5hYUNER3W
         zulF816DAjW8ovGVCmEPew+QXCq58zEgt8uWAs0tPffj0ut/oP0OcNpTrrlKO45jdG
         ZFTVlPvv6NHYTP1xy/izjeD9zBMbGvdD1dKnv2+Rb3XzyB1jXU/aPWS6GjDhpliyph
         26I/dvIVRRAqQ==
Date:   Tue, 11 May 2021 08:23:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v5 2/3] xfs: basic functionality test for shrinking free
 space in the last AG
Message-ID: <20210511152300.GN8582@magnolia>
References: <20210511073945.906127-1-hsiangkao@redhat.com>
 <20210511073945.906127-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511073945.906127-3-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 03:39:44PM +0800, Gao Xiang wrote:
> Add basic test to make sure the functionality works as expected.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks fine now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/990     | 73 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/990.out | 12 ++++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 86 insertions(+)
>  create mode 100755 tests/xfs/990
>  create mode 100644 tests/xfs/990.out
> 
> diff --git a/tests/xfs/990 b/tests/xfs/990
> new file mode 100755
> index 00000000..ec2592f6
> --- /dev/null
> +++ b/tests/xfs/990
> @@ -0,0 +1,73 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 990
> +#
> +# XFS shrinkfs basic functionality test
> +#
> +# This test attempts to shrink with a small size (512K), half AG size and
> +# an out-of-bound size (agsize + 1) to observe if it works as expected.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +test_shrink()
> +{
> +	$XFS_GROWFS_PROG -D"$1" $SCRATCH_MNT >> $seqres.full 2>&1
> +	ret=$?
> +
> +	_scratch_unmount
> +	_check_scratch_fs
> +	_scratch_mount
> +
> +	$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
> +	. $tmp.growfs
> +	[ $ret -eq 0 -a $1 -eq $dblocks ]
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_scratch_shrink
> +
> +rm -f $seqres.full
> +echo "Format and mount"
> +
> +# agcount = 1 is forbidden on purpose, and need to ensure shrinking to
> +# 2 AGs isn't feasible yet. So agcount = 3 is the minimum number now.
> +_scratch_mkfs -dsize="$((512 * 1024 * 1024))" -dagcount=3 2>&1 | \
> +	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> +. $tmp.mkfs
> +t_dblocks=$dblocks
> +_scratch_mount >> $seqres.full
> +
> +echo "Shrink fs (small size)"
> +test_shrink $((t_dblocks-512*1024/dbsize)) || \
> +	echo "Shrink fs (small size) failure"
> +
> +echo "Shrink fs (half AG)"
> +test_shrink $((t_dblocks-agsize/2)) || \
> +	echo "Shrink fs (half AG) failure"
> +
> +echo "Shrink fs (out-of-bound)"
> +test_shrink $((t_dblocks-agsize-1)) && \
> +	echo "Shrink fs (out-of-bound) failure"
> +[ $dblocks -ne $((t_dblocks-agsize/2)) ] && \
> +	echo "dblocks changed after shrinking failure"
> +
> +$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
> +echo "*** done"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/990.out b/tests/xfs/990.out
> new file mode 100644
> index 00000000..812f89ef
> --- /dev/null
> +++ b/tests/xfs/990.out
> @@ -0,0 +1,12 @@
> +QA output created by 990
> +Format and mount
> +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> +         = sunit=XXX swidth=XXX, unwritten=X
> +naming   =VERN bsize=XXX
> +log      =LDEV bsize=XXX blocks=XXX
> +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> +Shrink fs (small size)
> +Shrink fs (half AG)
> +Shrink fs (out-of-bound)
> +*** done
> diff --git a/tests/xfs/group b/tests/xfs/group
> index fe83f82d..472c8f9a 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -520,3 +520,4 @@
>  537 auto quick
>  538 auto stress
>  539 auto quick mount
> +990 auto quick growfs shrinkfs
> -- 
> 2.27.0
> 
