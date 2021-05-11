Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C616C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 15:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB8E61400
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 15:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhEKP0k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 11:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhEKP0h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 11:26:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66E9361400;
        Tue, 11 May 2021 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620746730;
        bh=y9cLC6rhTC6UaJLcg4FxfkzgR/EJdSxCxRpaRJI72S4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PVM14MqI0ezkRwoY2wRjuPADtewZIAnVM1IxW8WX3pcLKQuJv3uUt6vZiAzGJHGtF
         lLUXu3dXEZoVZ237CwVf4gS33+c7KPXN+v5LqFEsN2hkjZqF7ekt9xKJ8Pi/RCV6Ny
         V4u4uZLJ8RX6XJy//iaxn/z5y6069+USe6VpJ6ffVBdhsQEJyvN88D+JqDsUiuUTLf
         gY4AR7sO/mp/F18bNVe91fBLR0WrkDYrCbMRElKBIfpj1kUR7xrIohCmo3Z1h2CcrD
         BRRUGsAjaqqx5eMXlLz03ursiRuqe/MYjJvs1/6nEKLZlqYa/EdopLAlGrtntvFiIS
         Ih5YHIFIineDA==
Date:   Tue, 11 May 2021 08:25:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v5 3/3] xfs: stress test for shrinking free space in the
 last AG
Message-ID: <20210511152529.GO8582@magnolia>
References: <20210511073945.906127-1-hsiangkao@redhat.com>
 <20210511073945.906127-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511073945.906127-4-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 03:39:45PM +0800, Gao Xiang wrote:
> This adds a stress testcase to shrink free space as much as
> possible in the last AG with background fsstress workload.
> 
> The expectation is that no crash happens with expected output.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  tests/xfs/991     | 120 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/991.out |   8 ++++
>  tests/xfs/group   |   1 +
>  3 files changed, 129 insertions(+)
>  create mode 100755 tests/xfs/991
>  create mode 100644 tests/xfs/991.out
> 
> diff --git a/tests/xfs/991 b/tests/xfs/991
> new file mode 100755
> index 00000000..3561bfab
> --- /dev/null
> +++ b/tests/xfs/991
> @@ -0,0 +1,120 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020-2021 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 991
> +#
> +# XFS online shrinkfs stress test
> +#
> +# This test attempts to shrink unused space as much as possible with
> +# background fsstress workload. It will decrease the shrink size if
> +# larger size fails. And totally repeat 2 * TIME_FACTOR times.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +create_scratch()
> +{
> +	_scratch_mkfs_xfs $@ | tee -a $seqres.full | \
> +		_filter_mkfs 2>$tmp.mkfs >/dev/null
> +	. $tmp.mkfs
> +
> +	_scratch_mount
> +	# fix the reserve block pool to a known size so that the enospc
> +	# calculations work out correctly.
> +	_scratch_resvblks 1024 > /dev/null 2>&1
> +}
> +
> +fill_scratch()
> +{
> +	$XFS_IO_PROG -f -c "falloc 0 $1" $SCRATCH_MNT/resvfile
> +}
> +
> +stress_scratch()
> +{
> +	local procs=3
> +	local nops=1000
> +	# -w ensures that the only ops are ones which cause write I/O
> +	local FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w \
> +		-p $procs -n $nops $FSSTRESS_AVOID`
> +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_scratch_shrink
> +_require_xfs_io_command "falloc"
> +
> +rm -f $seqres.full
> +_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> +. $tmp.mkfs	# extract blocksize and data size for scratch device
> +
> +endsize=`expr 125 \* 1048576`	# stop after shrinking this big
> +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> +
> +nags=2
> +totalcount=$((2 * TIME_FACTOR))
> +
> +while [ $totalcount -gt 0 ]; do
> +	size=`expr 1010 \* 1048576`	# 1010 megabytes initially
> +	logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
> +
> +	create_scratch -lsize=${logblks}b -dsize=${size} -dagcount=${nags}
> +
> +	for i in `seq 125 -1 90`; do
> +		fillsize=`expr $i \* 1048576`
> +		out="$(fill_scratch $fillsize 2>&1)"
> +		echo "$out" | grep -q 'No space left on device' && continue
> +		test -n "${out}" && echo "$out"
> +		break
> +	done
> +
> +	# shrink in chunks of this size at most
> +	decsize=`expr  41 \* 1048576 + 1 + $RANDOM \* $RANDOM % 1048576`
> +
> +	while [ $size -gt $endsize ]; do
> +		stress_scratch &
> +		sleep 1
> +
> +		decb=`expr $decsize / $dbsize`    # in data blocks
> +		while [ $decb -gt 0 ]; do
> +			sizeb=`expr $size / $dbsize - $decb`
> +
> +			$XFS_GROWFS_PROG -D ${sizeb} $SCRATCH_MNT \
> +				>> $seqres.full 2>&1 && break
> +
> +			[ $decb -gt 100 ] && decb=`expr $decb + $RANDOM % 10`
> +			decb=`expr $decb / 2`
> +		done
> +
> +		wait
> +		[ $decb -eq 0 ] && break
> +
> +		# get latest dblocks
> +		$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
> +		. $tmp.growfs
> +
> +		size=`expr $dblocks \* $dbsize`
> +		_scratch_unmount
> +		_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair failed"

Might be nice to print $sizeb with the error message so that one can
correlate with tracepoints/growfs output without having to dig through
$seqres.full...

With that changed, I'd say:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +		_scratch_mount
> +	done
> +
> +	_scratch_unmount
> +	_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair failed"
> +	totalcount=`expr $totalcount - 1`
> +done
> +
> +echo "*** done"
> +status=0
> +exit
> diff --git a/tests/xfs/991.out b/tests/xfs/991.out
> new file mode 100644
> index 00000000..e8209672
> --- /dev/null
> +++ b/tests/xfs/991.out
> @@ -0,0 +1,8 @@
> +QA output created by 991
> +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> +         = sunit=XXX swidth=XXX, unwritten=X
> +naming   =VERN bsize=XXX
> +log      =LDEV bsize=XXX blocks=XXX
> +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> +*** done
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 472c8f9a..53e68bea 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -521,3 +521,4 @@
>  538 auto stress
>  539 auto quick mount
>  990 auto quick growfs shrinkfs
> +991 auto growfs shrinkfs ioctl prealloc stress
> -- 
> 2.27.0
> 
