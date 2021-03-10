Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4732DC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D5B664E56
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhCJCIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:08:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhCJCIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 21:08:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615342086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pw5mj8qS/ISa5CFpENAilRCKZxv1wYw2x9xGekjYBUk=;
        b=XKzBM6oej3Mb0zXCZO2qihhqqvKDakrZR7ZaZo4uytBCO5V3IAsIOSm8WJDE6hclaNOuid
        0kzj/vyRRbkT6HDy89pqMSX0tJvkpdi1vCuNMZ2Le79zLI+pEfmv41hmRNBjWVk9KMU10j
        xaipyFe9z3UjGp5kTsCAZajbRgKLrs8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-hqjk2ENzOwGR4zqc2_HsaA-1; Tue, 09 Mar 2021 21:08:04 -0500
X-MC-Unique: hqjk2ENzOwGR4zqc2_HsaA-1
Received: by mail-pj1-f71.google.com with SMTP id p18so3268780pjo.8
        for <linux-xfs@vger.kernel.org>; Tue, 09 Mar 2021 18:08:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pw5mj8qS/ISa5CFpENAilRCKZxv1wYw2x9xGekjYBUk=;
        b=nzxfOSZuQM5cQy4ToHD2HOiCP3b3lQGrXEe0BQrEejy3TfSXALeGiab+fPLV2ZfU/S
         RBTjGJ0xbaD3ZUcGd9c9Zqvns7GWzznhWJPTUDyzKLkuB+NZW8EWdfr6tUVfxdpSe+c9
         Krit0zg3238874gsnAogXReJQUnb6Yg6YB/KT5szI28IJpw3Mnup/kg6SUQbyp8lO2Ob
         SOsMStVNI5nWTePiKIlYt5jBT9spErz94YJ8aUtQv02iJAqRH5QITNQMguCA6Pk5gms4
         k6sLKKDhu4U9DQ+oMTYmZI21qxIreSyANTQAdPjt82z+RIYboN16XhCINGd0LLWI/MIl
         T33A==
X-Gm-Message-State: AOAM531tYRPTHPLedbfFFmduSieWL9DrB+6SVQmRTxOzzbynuQVGbE5O
        lMzLxXHF0iGBKywedWxYmX8O7wFnwCJdG30SWz9wh4gaD1QF5URwJKPoSZLocMYtqm+H/86AJ9J
        eQW63Gww/vPW+kUKu3F9V
X-Received: by 2002:a17:90a:9f48:: with SMTP id q8mr966886pjv.53.1615342083425;
        Tue, 09 Mar 2021 18:08:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMq2AY72yHgSsItSRcsttuY91hONfjYKhbLDP+hHIJ3nA3LixrUy/yHn9/rRjHVkQTb9I0vQ==
X-Received: by 2002:a17:90a:9f48:: with SMTP id q8mr966863pjv.53.1615342083052;
        Tue, 09 Mar 2021 18:08:03 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t23sm14003406pgv.34.2021.03.09.18.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 18:08:02 -0800 (PST)
Date:   Wed, 10 Mar 2021 10:07:52 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [WIP] [RFC PATCH] xfs: add test on shrinking unused space in the
 last AG
Message-ID: <20210310020734.GA4003044@xiangao.remote.csb>
References: <20201028230909.639698-1-hsiangkao@redhat.com>
 <20210309180349.GC7269@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309180349.GC7269@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Mar 09, 2021 at 10:03:49AM -0800, Darrick J. Wong wrote:
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
> 
> Functions in tests do not need to be prefixed with "_" since they're not
> global symbols.

ok, will fix.

> 
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
> 
> So we run this six times?  Why six, specifically?  Should it be scaled
> by TIME_FACTOR?

er... no specific reason yet I think try one time may be not
enough though...

> 
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
> 
> _fill_fs ?

This was copied from xfs/104 with some modification, ok, will try _fill_fs
way since I didn't use it before.

> 
> > +
> > +	decsize=`expr  42 \* 1048576`	# shrink in chunks of this size at most
> 
> This could go outside the loop.

ok, will fix.

> 
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
> 
> Use $XFS_GROWFS_PROG, do not call xfs_growfs directly.

will fix.

> 
> > +				| tee -a $seqres.full | _filter_mkfs 2>$tmp.growfs > /dev/null
> > +
> > +			ret="${PIPESTATUS[0]}"
> > +			. $tmp.growfs
> > +
> > +			[ $ret -eq 0 ] && break
> > +
> > +			[ $decb -gt 100 ] && decb=`expr $decb + $RANDOM % 10`
> > +			decb=`expr $decb / 2`
> 
> So... uh... what does this decb logic do?  AFAICT we start by removing
> 42MB from the end of the filesystem, and then we ... add some random
> quantity to decb, halve it, then shrink by that amount?  And we keep
> doing smaller and smaller pieces until the shrink fails or decb becomes
> zero...
> 
> > +		done
> > +
> > +		wait
> > +		[ $decb -eq 0 ] && break
> 
> ...after which we wait for fsstress to end and then loop back to
> fsstress and shrinking?

yeah, roughly the logic above, yet I don't have some better idea
to test it so that shrink it as much as possible.

> 
> I was expecting to see two tests: a basic functionality test, and then a
> second one to race fsstress and shrink to see what happens.

May I ask what is your perference about the basic functionality test?
Just shrinking several fixed sizes is enough (to guarantee the basic
functionality works as expected?)

> 
> > +
> > +		size=`expr $size - $decb \* $dbsize`
> 
> Why don't we query the size of the filesystem instead of calculating it
> and hoping that reflects reality?

I remembered I tried before, but I forgot the reason why I used instead.
Will try again later.

One more thing is that "should we introduce a brand new argument for
shrinking in growfs?" I vaguely remembered Eric mentioned before.
It'd be better to get your idea about this as well so I could go further
on that patch as well...

Thanks,
Gao Xiang

> 
> --D
> 
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

