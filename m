Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E9CC433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 18:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2684461481
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 18:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhEJSCx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 14:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232063AbhEJSCx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 May 2021 14:02:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0007611BD;
        Mon, 10 May 2021 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620669708;
        bh=sBNEIu24mZodJZkV9Bh2FuTwjIid+UirOm0iVckAxAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kqNL5RmeQHsI6vN37YloaQsCXJTXNUzWzKCF8+8JJkmWtYaq+KY9aHdp/43x6Z3J/
         j3/KJi2TDYYjB6DcfV3KEASg+PDeKzTgUhjw76pW/Jc4BFl6c9JdKn4tfFdY/YHyt5
         cya5H97khfn6tM0lJiJ1aCZIIMkOUh+CcXRot+DA35EABK5mgKJvUU2gPDGsW4fMSx
         DanHn0KaujRReYzGbLV9Fa37AkLU8PcyWwBS3rbIEQI8wyuVG9DriUnbXqIw9nD8pd
         ousCbzBdOj8kxTgcS9rKvcGGSMpf/XLt6lpkaCG8u+R5JApwVn/MlAe+lZ06zIdDNS
         nAIcWm7fb0DCA==
Date:   Mon, 10 May 2021 11:01:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v4 2/3] xfs: basic functionality test for shrinking free
 space in the last AG
Message-ID: <20210510180147.GB8558@magnolia>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
 <20210402094937.4072606-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402094937.4072606-3-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 02, 2021 at 05:49:36PM +0800, Gao Xiang wrote:
> Add basic test to make sure the functionality works as expected.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
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
> index 00000000..322b09e1
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
> +# 2 AGs isn't fensible yet. So agcount = 3 is the minimum number now.

s/fensible/feasible/

> +_scratch_mkfs -dsize="$((512 * 1024 * 1024))" -dagcount=3 2>&1 | \
> +	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> +. $tmp.mkfs
> +t_dblocks=$dblocks
> +_scratch_mount >> $seqres.full
> +
> +echo "Shrink fs (small size)"
> +test_shrink $((t_dblocks-512*1024/dbsize)) || \
> +	_fail "Shrink fs (small size) failure"
> +
> +echo "Shrink fs (half AG)"
> +test_shrink $((t_dblocks-agsize/2)) || \
> +	_fail "Shrink fs (half AG) failure"
> +
> +echo "Shrink fs (out-of-bound)"
> +test_shrink $((t_dblocks-agsize-1)) && \
> +	_fail "Shrink fs (out-of-bound) failure"
> +[ $dblocks -ne $((t_dblocks-agsize/2)) ] && \
> +	_fail "dblocks changed after shrinking failure"

Can these be echo statements, since the diff in golden output will trip
anyway?

--D

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
