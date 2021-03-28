Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99467C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 20:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C51361948
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 20:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhC1UJj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Mar 2021 16:09:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230447AbhC1UJ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Mar 2021 16:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616962168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bXbAn5I6K5RTZ3mjK7jSISgKa6cABUfBmvoB+kBx3jc=;
        b=Tx3ZrocS5nWMgis3eRayQjSmhL3pA/Kl8NDVTmPASeuuijujGRHySGKA3q60ox8svXo8HV
        zCWQQYZC6cdxyY/Js5R2eDFnKXtYlPbWsYmGHXl9muMMKZAiRe1ZUwN4XGTescX6DJyR9J
        HnYVHLkYMK4OGZqNd8DEPl1TeQkvT3o=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-pEwpaeQHPwipW55erUP35Q-1; Sun, 28 Mar 2021 16:09:24 -0400
X-MC-Unique: pEwpaeQHPwipW55erUP35Q-1
Received: by mail-pf1-f199.google.com with SMTP id e6so9796369pfe.3
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 13:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bXbAn5I6K5RTZ3mjK7jSISgKa6cABUfBmvoB+kBx3jc=;
        b=CBrqt614Z4Jv8y/iVu/rfGjTkK1VROHHfHNjGn/xbyN8DVfHUZrbMCa3VuAITI/Y7e
         8Sf1hUC4/gDzTkuEzGATgsDKcpUFEevlaGYdiI8APxL1R9K0DeCGCH+/NYQFgF/Ai7jS
         B5xblVniGOODJBUa1/mF5Kh43ZeoXLJFFxm15MVf4oRTG2K9nDBmktoyjdHET1gyW0G4
         1WokECK4bUZPxMRO1zXKnUsY8qrux19RT8THRZn9tUj/Ahbgztts5h04ANnVss64rWKW
         q9eptkAJUcIZsWDIdwP5itI8n++16m7xJWXljrkob66i6zs2W8sxcsTkDXdj55MPUqHY
         LtMw==
X-Gm-Message-State: AOAM530xyNdA2rV+KpDtPCFpgcKohHKIP+OE6+L38+cBwBFTaTPcj0H0
        2OMEA+6qxY3bnVXB0QZDW9I1US7mXopw17g4TDQbOL9vCp+YF9MTyXdtGYEUbMY57uB+RB25p1b
        Obl1p9e50zPZxQyEMCJgc
X-Received: by 2002:a05:6a00:b86:b029:205:c773:5c69 with SMTP id g6-20020a056a000b86b0290205c7735c69mr22116739pfj.60.1616962162837;
        Sun, 28 Mar 2021 13:09:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw81E2lxvBvSH4A0GgwZ3zDp6TIQuZITmK6xPKRaRcBhf/DNliEov1mMIwxCSiZ6GwSBDjUcA==
X-Received: by 2002:a05:6a00:b86:b029:205:c773:5c69 with SMTP id g6-20020a056a000b86b0290205c7735c69mr22116731pfj.60.1616962162579;
        Sun, 28 Mar 2021 13:09:22 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r10sm13649871pgj.29.2021.03.28.13.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:09:22 -0700 (PDT)
Date:   Mon, 29 Mar 2021 04:09:12 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eryu Guan <guan@eryu.me>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [RFC PATCH v3 3/3] xfs: stress test for shrinking free space in
 the last AG
Message-ID: <20210328200912.GC3213575@xiangao.remote.csb>
References: <20210315111926.837170-1-hsiangkao@redhat.com>
 <20210315111926.837170-4-hsiangkao@redhat.com>
 <YGCy5W+4coMuM7y1@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGCy5W+4coMuM7y1@desktop>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 12:46:29AM +0800, Eryu Guan wrote:
> On Mon, Mar 15, 2021 at 07:19:26PM +0800, Gao Xiang wrote:
> > This adds a stress testcase to shrink free space as much as
> > possible in the last AG with background fsstress workload.
> > 
> > The expectation is that no crash happens with expected output.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  tests/xfs/991     | 122 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/991.out |   8 +++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 131 insertions(+)
> >  create mode 100755 tests/xfs/991
> >  create mode 100644 tests/xfs/991.out
> > 
> > diff --git a/tests/xfs/991 b/tests/xfs/991
> > new file mode 100755
> > index 00000000..7e7d318e
> > --- /dev/null
> > +++ b/tests/xfs/991
> > @@ -0,0 +1,122 @@
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
> > +	if ! _try_scratch_mount 2>/dev/null; then
> > +		echo "failed to mount $SCRATCH_DEV"
> > +		exit 1
> > +	fi
> 
> _scratch_mount will do the check and _fail the test on mount failure.

It was just copied & pasted from somewhere else rather than wrote from
scratch.

> 
> > +
> > +	# fix the reserve block pool to a known size so that the enospc
> > +	# calculations work out correctly.
> > +	_scratch_resvblks 1024 > /dev/null 2>&1
> > +}
> > +
> > +fill_scratch()
> > +{
> > +	$XFS_IO_PROG -f -c "falloc -k 0 $1" $SCRATCH_MNT/resvfile
> > +}
> > +
> > +stress_scratch()
> > +{
> > +	procs=3
> > +	nops=$((1000 * LOAD_FACTOR))
> 
> Declare procs and nops as local.

Will update, thanks for the suggestion.

> 
> > +	# -w ensures that the only ops are ones which cause write I/O
> > +	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
> > +	    -n $nops $FSSTRESS_AVOID`
> > +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
> 
> I think it's more explicit to run run stress_scratch in background,
> instead run fsstress in background implicit.

Will update as well.

> 
> > +}
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> 
> _require_scratch

No, _require_xfs_shrink also checks this.

> 
> > +_require_xfs_shrink
> > +_require_xfs_io_command "falloc"
> > +
> > +rm -f $seqres.full
> > +_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> > +. $tmp.mkfs	# extract blocksize and data size for scratch device
> > +
> > +decsize=`expr  42 \* 1048576`	# shrink in chunks of this size at most
> > +endsize=`expr 125 \* 1048576`	# stop after shrinking this big
> > +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> > +
> > +nags=2
> > +totalcount=$((2 * TIME_FACTOR))
> > +
> > +while [ $totalcount -gt 0 ]; do
> > +	size=`expr 1010 \* 1048576`	# 1010 megabytes initially
> > +	logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
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
> > +		stress_scratch
> 
> So just call
> 
> stress_scratch &
> 
> here? So it's clear that we put stress_scratch in background, and the
> 'wait' below is waiting for it.

Will update.

Thanks,
Gao Xiang

> 
> Thanks,
> Eryu
> 
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
> > +		_scratch_mount
> > +	done
> > +
> > +	_scratch_unmount
> > +	_repair_scratch_fs >> $seqres.full
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
> > index a7981b67..cf190b59 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -526,3 +526,4 @@
> >  526 auto quick mkfs
> >  527 auto quick quota
> >  990 auto quick growfs
> > +991 auto growfs ioctl prealloc stress
> > -- 
> > 2.27.0
> 

