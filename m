Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5E6C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2AB464F7A
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhCJCQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:16:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231607AbhCJCQe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 21:16:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615342593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DXK3I2SEudLz4KqFKJu+QsVHicwIr1DsfZsJTiugzPA=;
        b=h4EkHUDtcYWLRp1HKxjkIL6Rdbfy1DTTJQpl2MFgjbdIEMNmDXc9JPvVUIUakxBtxVPIOH
        s+M4LBxZJ2jEPG4PWTanQIxMxk7bbP1k/KbU230Y4LoCTumojUk1m3hsvSRz95TH5HgLsm
        QqSeJmqIX6+xhAvHFRvFFms8nDCIwFU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-dDjEY8DTNkWus7mjwO87SA-1; Tue, 09 Mar 2021 21:16:31 -0500
X-MC-Unique: dDjEY8DTNkWus7mjwO87SA-1
Received: by mail-pj1-f72.google.com with SMTP id oc10so3463704pjb.8
        for <linux-xfs@vger.kernel.org>; Tue, 09 Mar 2021 18:16:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DXK3I2SEudLz4KqFKJu+QsVHicwIr1DsfZsJTiugzPA=;
        b=CEJ+iQI5SzyjiMJcqfbGIHhGwvXYGGOaNPyo1hx458DNeUMYDqZQWMVI9f1dyWe6Ke
         lP0JTvGW1Iv+j09IK1PZWv5JKqtpWvWYVASUy+AR9m1Ii6q2p9UySk8jYV5wyz436TfU
         mWvLPj6X/ZmompFhMJ+yiWehjcP6vFOYBmvmHpyTy6Tj8sbtgJr/0baMKog2uGEJxIaq
         9brLFBdHkk6yCOpt/JUymlsIRR22EcfoAmSHfGrFhJVA9zEhKCj/zkve09eNgSVa1KR7
         KF8ftW1fg6iOjLWKZsasZ2dA8MShLYCjw+z1LEzKKC1x6uXC9ZCxqHo4e+nIouOTDT9e
         KaVw==
X-Gm-Message-State: AOAM532wV8LYP92ONQi09SmRgubRYZRS9hsHbEbz4dFMdYTE3iFoTeiy
        UX4VYvUFkLmPgPVDoFpwUvuwqAZAIwUlqc6q0MhpXy0pz0LAKNgIpIAfPSDYuZzx+JcPS5DtnL7
        COoTJpugPwrYzzdbqm33pLFk/ilMiKDxLnvutPSjFn1fBhPs2PZMQia90oCOfSGktiUDH0iy7tw
        ==
X-Received: by 2002:a65:6209:: with SMTP id d9mr746577pgv.206.1615342590574;
        Tue, 09 Mar 2021 18:16:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDHy8cR3YgDO1oOz+fIpXgSEu6E6B21r9rkqR0aeUKoXH97bwyNjMz4OvdQLjN3Oad8jkvrQ==
X-Received: by 2002:a65:6209:: with SMTP id d9mr746549pgv.206.1615342590123;
        Tue, 09 Mar 2021 18:16:30 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d19sm3995577pjs.55.2021.03.09.18.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 18:16:29 -0800 (PST)
Date:   Wed, 10 Mar 2021 10:16:20 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [WIP] [RFC PATCH] xfs: add test on shrinking unused space in the
 last AG
Message-ID: <20210310021620.GB4003044@xiangao.remote.csb>
References: <20201028230909.639698-1-hsiangkao@redhat.com>
 <20210310004324.GE3499219@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210310004324.GE3499219@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Zorro,

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

That is a good idea, yet in order to test this, currently it needs
some image to shrink. and for now it supports shrinking free space
in last AG, later it might support shrinking free space with no
limitation. So I'm not sure such require test is stable though.
what's your perference about this?

Thanks,
Gao Xiang

> 
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

