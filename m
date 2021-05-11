Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC20AC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 02:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65D9616EA
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 02:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhEKCUr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 22:20:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230417AbhEKCUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 May 2021 22:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620699581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R5ICgoEcBEPAuwKwmSj7N49//KAKBFz52G3hz/e8j64=;
        b=EpMTHhnk4Wh+b95lH2dJzMI9QICcplpkQAqCfR9FCRpdbJz4IiGSAiZK0jNUDynDemDQmp
        FhBYZmQNITFVVSongzqIKXvVol9LRDhx+cAdUVF7n0AbIqr4HDKXNaN1oVevHH6I6nf27m
        PRPz5jFlj6023y5unIqBEbURFiGWg2E=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-OZu04HoUO5S3DwKWU5pyfQ-1; Mon, 10 May 2021 22:19:39 -0400
X-MC-Unique: OZu04HoUO5S3DwKWU5pyfQ-1
Received: by mail-pg1-f199.google.com with SMTP id g26-20020a63565a0000b0290209e5bf0fd4so11456946pgm.11
        for <linux-xfs@vger.kernel.org>; Mon, 10 May 2021 19:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R5ICgoEcBEPAuwKwmSj7N49//KAKBFz52G3hz/e8j64=;
        b=boAM8z8Y/P7XyDwh9LaSdmMxDH+ztPOSKSDNGl1AqHGpZHHouDoZsxWw7oNgNl4TVa
         s9liD5XW7nNJWDrbxJIR10GVj9BWERMIn8JAjKxF0IiScpz9nyvwZeJ1bk7efgY6Y0mv
         7wjfymJkY4/TqwkHTfn+V+1PtMbEHmP6BxvHYTl123lGLs81YgyWHuKyNq9fd0zWinFH
         dbmaHToJhksonkXLFCE+XiKGtB+UHN/QUn/0Ia6UPIBbrQZD8PBrT427goL+ovvmVg3H
         Q6sR9MeAHOomEJRa9xqQbdVajGT9+gGyaWWy5e0yUWFLBvsHMKcBhFfOei2bxhAVzeoN
         gXOw==
X-Gm-Message-State: AOAM530etf6J8rV+cvR+tCI+ZALj4GOd/RaC+BAtE2AHhaQGxqwF0Rdl
        Dg97J46i0APnhmtQDe146y0PAPR0uc/oauOU0sFjaCCpgnZi3ADR3tj/7qyVbLrACebgwRUR2nL
        EBiUL8zv3F4DnkYLyBsyi
X-Received: by 2002:a65:62da:: with SMTP id m26mr14798702pgv.195.1620699578307;
        Mon, 10 May 2021 19:19:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd7D+ovnyAR4LznR7nf9osp65qFpCpVT281gpt9HKoS9nqCsskdsqn4rmQBb2Fn3YnCTZHXg==
X-Received: by 2002:a65:62da:: with SMTP id m26mr14798679pgv.195.1620699578015;
        Mon, 10 May 2021 19:19:38 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z29sm12328102pga.52.2021.05.10.19.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:19:37 -0700 (PDT)
Date:   Tue, 11 May 2021 10:19:27 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v4 3/3] xfs: stress test for shrinking free space in the
 last AG
Message-ID: <20210511021927.GE741809@xiangao.remote.csb>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
 <20210402094937.4072606-4-hsiangkao@redhat.com>
 <20210510180836.GC8558@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210510180836.GC8558@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 10, 2021 at 11:08:36AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 02, 2021 at 05:49:37PM +0800, Gao Xiang wrote:
> > This adds a stress testcase to shrink free space as much as
> > possible in the last AG with background fsstress workload.
> > 
> > The expectation is that no crash happens with expected output.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  tests/xfs/991     | 118 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/991.out |   8 ++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 127 insertions(+)
> >  create mode 100755 tests/xfs/991
> >  create mode 100644 tests/xfs/991.out
> > 
> > diff --git a/tests/xfs/991 b/tests/xfs/991
> > new file mode 100755
> > index 00000000..8ad0b8c7
> > --- /dev/null
> > +++ b/tests/xfs/991
> > @@ -0,0 +1,118 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020-2021 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 991
> > +#
> > +# XFS online shrinkfs stress test
> > +#
> > +# This test attempts to shrink unused space as much as possible with
> > +# background fsstress workload. It will decrease the shrink size if
> > +# larger size fails. And totally repeat 2 * TIME_FACTOR times.
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
> > +create_scratch()
> > +{
> > +	_scratch_mkfs_xfs $@ | tee -a $seqres.full | \
> > +		_filter_mkfs 2>$tmp.mkfs >/dev/null
> > +	. $tmp.mkfs
> > +
> > +	_scratch_mount
> > +	# fix the reserve block pool to a known size so that the enospc
> > +	# calculations work out correctly.
> > +	_scratch_resvblks 1024 > /dev/null 2>&1
> > +}
> > +
> > +fill_scratch()
> > +{
> > +	$XFS_IO_PROG -f -c "falloc 0 $1" $SCRATCH_MNT/resvfile
> > +}
> > +
> > +stress_scratch()
> > +{
> > +	local procs=3
> > +	local nops=$((1000 * LOAD_FACTOR))
> 
> Um... _scale_fsstress_args already scales the -p and -n arguments, why
> is it necessary to scale nops by time /and/ load?

Yeah, I forgot to check what _scale_fsstress_args's implemented.
Yes, it's unnecessary. will fix.

> 
> > +	# -w ensures that the only ops are ones which cause write I/O
> > +	local FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w \
> > +		-p $procs -n $nops $FSSTRESS_AVOID`
> > +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1
> > +}
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_xfs_scratch_shrink
> > +_require_xfs_io_command "falloc"
> > +
> > +rm -f $seqres.full
> > +_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> > +. $tmp.mkfs	# extract blocksize and data size for scratch device
> > +
> > +decsize=`expr  42 \* 1048576`	# shrink in chunks of this size at most
> 
> Might it be nice to inject a little bit of randomness here?

okay, will update.

> 
> > +endsize=`expr 125 \* 1048576`	# stop after shrinking this big
> > +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> > +
> > +nags=2
> > +totalcount=$((2 * TIME_FACTOR))
> > +
> > +while [ $totalcount -gt 0 ]; do
> > +	size=`expr 1010 \* 1048576`	# 1010 megabytes initially
> > +	logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
> 
> (Does all this logic still work if an external log device is present?)

I didn't check the external log device case, but it seems
_scratch_find_xfs_min_logblocks was used in many cases before?
(e.g. xfs/104, how such cases work with an external log device?)

> 
> > +
> > +	create_scratch -lsize=${logblks}b -dsize=${size} -dagcount=${nags}
> > +
> > +	for i in `seq 125 -1 90`; do
> > +		fillsize=`expr $i \* 1048576`
> > +		out="$(fill_scratch $fillsize 2>&1)"
> > +		echo "$out" | grep -q 'No space left on device' && continue
> > +		test -n "${out}" && echo "$out"
> > +		break
> > +	done
> > +
> > +	while [ $size -gt $endsize ]; do
> > +		stress_scratch &
> > +		sleep 1
> > +
> > +		decb=`expr $decsize / $dbsize`    # in data blocks
> > +		while [ $decb -gt 0 ]; do
> > +			sizeb=`expr $size / $dbsize - $decb`
> > +
> > +			$XFS_GROWFS_PROG -D ${sizeb} $SCRATCH_MNT \
> > +				>> $seqres.full 2>&1 && break
> > +
> > +			[ $decb -gt 100 ] && decb=`expr $decb + $RANDOM % 10`
> > +			decb=`expr $decb / 2`
> > +		done
> > +
> > +		wait
> > +		[ $decb -eq 0 ] && break
> > +
> > +		# get latest dblocks
> > +		$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
> > +		. $tmp.growfs
> > +
> > +		size=`expr $dblocks \* $dbsize`
> > +		_scratch_unmount
> > +		_repair_scratch_fs >> $seqres.full
> 
> Why isn't "_scratch_xfs_repair -n" here sufficient?

That sounds better if '-n' can detect all cases without '-n' (since I've
heard previously some buggy fsckxxx doesn't produce the same result with
or without '-n'...)

Will update.

> 
> > +		_scratch_mount
> > +	done
> > +
> > +	_scratch_unmount
> > +	_repair_scratch_fs >> $seqres.full
> 
> ...and here?

Will update too.

Thanks,
Gao Xiang


> 
> > +	totalcount=`expr $totalcount - 1`
> > +done
> > +
> > +echo "*** done"
> > +status=0
> > +exit
> > diff --git a/tests/xfs/991.out b/tests/xfs/991.out
> > new file mode 100644
> > index 00000000..e8209672
> > --- /dev/null
> > +++ b/tests/xfs/991.out
> > @@ -0,0 +1,8 @@
> > +QA output created by 991
> > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > +         = sunit=XXX swidth=XXX, unwritten=X
> > +naming   =VERN bsize=XXX
> > +log      =LDEV bsize=XXX blocks=XXX
> > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > +*** done
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 472c8f9a..53e68bea 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -521,3 +521,4 @@
> >  538 auto stress
> >  539 auto quick mount
> >  990 auto quick growfs shrinkfs
> > +991 auto growfs shrinkfs ioctl prealloc stress
> > -- 
> > 2.27.0
> > 
> 

