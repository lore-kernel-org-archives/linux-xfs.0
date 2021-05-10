Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FADC43461
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 18:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7627611F0
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 18:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhEJSJo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 14:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230357AbhEJSJn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 May 2021 14:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E582611BF;
        Mon, 10 May 2021 18:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620670118;
        bh=ekFHxO046+EStxvnakE4IyjlrXc26qirAtfF/RISydk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bLFYbTjK0J6V0PpJ5js6xPbYQA32LmZTJV79/+tNHfEI4bLqWISAEf2S0aKYvPWQH
         JBytUTXjgCED5t37e/CoXiaUzgqABhD23SeRJUaEMExhvNvBTzuqCccFdYj0XB6jbp
         cilPZMCyHFoqD4z9mrnZ6sUNhnxZFA+uoRWPDJLqrcMbCjvrQ8LeAuwCKIWs/L24kz
         whSo9N3JaN9CDJ8e4P7aV25DsyG7AVIjAUGcU81svs8h/7tItL1UuvqOc0v3Pv0jVs
         HPWXeDHnljIjd9rB0SvXnQl0rj+bgKT//H2pcyGuB6bpL5ELZ5c7BTj2ZkDJMUiKQU
         EjHbs3OjFg3Dg==
Date:   Mon, 10 May 2021 11:08:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v4 3/3] xfs: stress test for shrinking free space in the
 last AG
Message-ID: <20210510180836.GC8558@magnolia>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
 <20210402094937.4072606-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402094937.4072606-4-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 02, 2021 at 05:49:37PM +0800, Gao Xiang wrote:
> This adds a stress testcase to shrink free space as much as
> possible in the last AG with background fsstress workload.
> 
> The expectation is that no crash happens with expected output.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  tests/xfs/991     | 118 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/991.out |   8 ++++
>  tests/xfs/group   |   1 +
>  3 files changed, 127 insertions(+)
>  create mode 100755 tests/xfs/991
>  create mode 100644 tests/xfs/991.out
> 
> diff --git a/tests/xfs/991 b/tests/xfs/991
> new file mode 100755
> index 00000000..8ad0b8c7
> --- /dev/null
> +++ b/tests/xfs/991
> @@ -0,0 +1,118 @@
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
> +	local nops=$((1000 * LOAD_FACTOR))

Um... _scale_fsstress_args already scales the -p and -n arguments, why
is it necessary to scale nops by time /and/ load?

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
> +decsize=`expr  42 \* 1048576`	# shrink in chunks of this size at most

Might it be nice to inject a little bit of randomness here?

> +endsize=`expr 125 \* 1048576`	# stop after shrinking this big
> +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> +
> +nags=2
> +totalcount=$((2 * TIME_FACTOR))
> +
> +while [ $totalcount -gt 0 ]; do
> +	size=`expr 1010 \* 1048576`	# 1010 megabytes initially
> +	logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})

(Does all this logic still work if an external log device is present?)

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
> +		_repair_scratch_fs >> $seqres.full

Why isn't "_scratch_xfs_repair -n" here sufficient?

> +		_scratch_mount
> +	done
> +
> +	_scratch_unmount
> +	_repair_scratch_fs >> $seqres.full

...and here?

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
