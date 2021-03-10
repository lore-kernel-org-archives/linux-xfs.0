Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F3DC433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B40164E99
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhCJCKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:10:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhCJCJs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 21:09:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3091364E68;
        Wed, 10 Mar 2021 02:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615342188;
        bh=qU9RoGZjaBXY27t9JrsftmnlnAhoZKpJNOMzpz7L624=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=meFT0+5RgAiNZ3A71k62Mrbb6njoNxQHHBvCXMAbsfQgnfBJw8dxHRbXhnBqvyXWH
         3+59kFN9RmU5NNT8UxcpA/hPgTPUJmaH0p0B+0Bj34lqcVA1cgV3+dQ6VQ+j1obLFY
         n4SzA/Njx4amqzEEcDpuKXKR/KgzZoZH443fPlK6KUpbgFK7cbqU0FzSadfw+oabA7
         4HD06bx98YsHQZkTNQjIhdm95R4WFPUi8RhFi7V/KllrXOoUSxVwxH2PljSzzlW8ja
         juW0wSqxhucF+SuPgOqqDNP8pR3A/T5OwO66N/GKRYOfAxO4p7TM34m5W5g6uOow9/
         fwGAvN/eFH6KA==
Date:   Tue, 9 Mar 2021 18:09:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [WIP] [RFC PATCH] xfs: add test on shrinking unused space in the
 last AG
Message-ID: <20210310020947.GC3419940@magnolia>
References: <20201028230909.639698-1-hsiangkao@redhat.com>
 <20210310004324.GE3499219@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310004324.GE3499219@localhost.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 08:43:25AM +0800, Zorro Lang wrote:
> On Thu, Oct 29, 2020 at 07:09:09AM +0800, Gao Xiang wrote:
> > This adds a testcase to test shrinking unused space as much
> > as possible in the last AG with background fsstress workload.
> > 
> > The expectation is that no crash happens with expected output.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  tests/xfs/522     | 125 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/522.out |  73 +++++++++++++++++++++++++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 199 insertions(+)
> >  create mode 100755 tests/xfs/522
> >  create mode 100644 tests/xfs/522.out
> > 
> > diff --git a/tests/xfs/522 b/tests/xfs/522
> > new file mode 100755
> > index 00000000..e427a33a
> > --- /dev/null
> > +++ b/tests/xfs/522
> > @@ -0,0 +1,125 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 522
> > +#
> > +# XFS online shrinkfs-while-allocating tests
> > +#
> > +# This test attempts to shrink unused space as much as possible with
> > +# background fsstress workload. It will decrease the shrink size if
> > +# larger size fails. And totally repeat 6 times.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +_create_scratch()
> > +{
> > +	echo "*** mkfs"
> > +	_scratch_mkfs_xfs $@ | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> > +	. $tmp.mkfs
> > +
> > +	echo "*** mount"
> > +	if ! _try_scratch_mount 2>/dev/null
> > +	then
> > +		echo "failed to mount $SCRATCH_DEV"
> > +		exit 1
> > +	fi
> > +
> > +	# fix the reserve block pool to a known size so that the enospc
> > +	# calculations work out correctly.
> > +	_scratch_resvblks 1024 >  /dev/null 2>&1
> > +}
> > +
> > +_fill_scratch()
> > +{
> > +	$XFS_IO_PROG -f -c "resvsp 0 ${1}" $SCRATCH_MNT/resvfile
> > +}
> > +
> > +_stress_scratch()
> > +{
> > +	procs=3
> > +	nops=1000
> > +	# -w ensures that the only ops are ones which cause write I/O
> > +	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
> > +	    -n $nops $FSSTRESS_AVOID`
> > +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
> > +}
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_io_command "falloc"
> > +
> > +rm -f $seqres.full
> > +_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> > +. $tmp.mkfs	# extract blocksize and data size for scratch device
> > +
> > +endsize=`expr 125 \* 1048576`	# stop after shrinking this big
> > +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> > +
> > +nags=2
> > +totalcount=6
> > +
> > +while [ $totalcount -gt 0 ]; do
> > +	size=`expr 1010 \* 1048576`	# 1010 megabytes initially
> > +	echo "*** creating scratch filesystem"
> > +	logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
> > +
> > +	_create_scratch -lsize=${logblks}b -dsize=${size} -dagcount=${nags}
> > +
> > +	echo "*** using some initial space on scratch filesystem"
> > +	for i in `seq 125 -1 90`; do
> > +		fillsize=`expr $i \* 1048576`
> > +		out="$(_fill_scratch $fillsize 2>&1)"
> > +		echo "$out" | grep -q 'No space left on device' && continue
> > +		test -n "${out}" && echo "$out"
> > +		break
> > +	done
> > +
> > +	decsize=`expr  42 \* 1048576`	# shrink in chunks of this size at most
> > +
> > +	echo "*** stressing filesystem"
> > +	while [ $size -gt $endsize ]; do
> > +		_stress_scratch
> > +		sleep 1
> > +
> > +		decb=`expr $decsize / $dbsize`    # in data blocks
> > +		while [ $decb -gt 0 ]; do
> > +			sizeb=`expr $size / $dbsize - $decb`
> > +
> > +			xfs_growfs -D ${sizeb} $SCRATCH_MNT 2>&1 \
> > +				| tee -a $seqres.full | _filter_mkfs 2>$tmp.growfs > /dev/null
> 
> As Darrick has reviewed, I have one more question. Looks like we can shrink a
> mounted xfs via giving a smaller size to xfs_growfs.
> 
> If xfs_growfs or kernel doesn't support 'shrink', I think the whole test will
> be failed. So maybe we need a _require_* function to check if current xfs
> support shrinking feature at first?

Also, it's time to send the xfs_growfs patches to the list so I can
replicate the tests on my own test vms.

--D

> Thanks,
> Zorro
> 
> > +
> > +			ret="${PIPESTATUS[0]}"
> > +			. $tmp.growfs
> > +
> > +			[ $ret -eq 0 ] && break
> > +
> > +			[ $decb -gt 100 ] && decb=`expr $decb + $RANDOM % 10`
> > +			decb=`expr $decb / 2`
> > +		done
> > +
> > +		wait
> > +		[ $decb -eq 0 ] && break
> > +
> > +		size=`expr $size - $decb \* $dbsize`
> > +	done
> > +
> > +	_scratch_unmount
> > +	_repair_scratch_fs >> $seqres.full
> > +	totalcount=`expr $totalcount - 1`
> > +done
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/522.out b/tests/xfs/522.out
> > new file mode 100644
> > index 00000000..03d512f5
> > --- /dev/null
> > +++ b/tests/xfs/522.out
> > @@ -0,0 +1,73 @@
> > +QA output created by 522
> > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > +         = sunit=XXX swidth=XXX, unwritten=X
> > +naming   =VERN bsize=XXX
> > +log      =LDEV bsize=XXX blocks=XXX
> > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > +*** creating scratch filesystem
> > +*** mkfs
> > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > +         = sunit=XXX swidth=XXX, unwritten=X
> > +naming   =VERN bsize=XXX
> > +log      =LDEV bsize=XXX blocks=XXX
> > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > +*** mount
> > +*** using some initial space on scratch filesystem
> > +*** stressing filesystem
> > +*** creating scratch filesystem
> > +*** mkfs
> > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > +         = sunit=XXX swidth=XXX, unwritten=X
> > +naming   =VERN bsize=XXX
> > +log      =LDEV bsize=XXX blocks=XXX
> > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > +*** mount
> > +*** using some initial space on scratch filesystem
> > +*** stressing filesystem
> > +*** creating scratch filesystem
> > +*** mkfs
> > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > +         = sunit=XXX swidth=XXX, unwritten=X
> > +naming   =VERN bsize=XXX
> > +log      =LDEV bsize=XXX blocks=XXX
> > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > +*** mount
> > +*** using some initial space on scratch filesystem
> > +*** stressing filesystem
> > +*** creating scratch filesystem
> > +*** mkfs
> > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > +         = sunit=XXX swidth=XXX, unwritten=X
> > +naming   =VERN bsize=XXX
> > +log      =LDEV bsize=XXX blocks=XXX
> > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > +*** mount
> > +*** using some initial space on scratch filesystem
> > +*** stressing filesystem
> > +*** creating scratch filesystem
> > +*** mkfs
> > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > +         = sunit=XXX swidth=XXX, unwritten=X
> > +naming   =VERN bsize=XXX
> > +log      =LDEV bsize=XXX blocks=XXX
> > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > +*** mount
> > +*** using some initial space on scratch filesystem
> > +*** stressing filesystem
> > +*** creating scratch filesystem
> > +*** mkfs
> > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > +         = sunit=XXX swidth=XXX, unwritten=X
> > +naming   =VERN bsize=XXX
> > +log      =LDEV bsize=XXX blocks=XXX
> > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > +*** mount
> > +*** using some initial space on scratch filesystem
> > +*** stressing filesystem
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index b89c0a4e..ab762ed6 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -519,3 +519,4 @@
> >  519 auto quick reflink
> >  520 auto quick reflink
> >  521 auto quick realtime growfs
> > +522 auto quick growfs
> > -- 
> > 2.18.1
> > 
> 
