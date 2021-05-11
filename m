Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80E9C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 02:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A926761554
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 02:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhEKCGM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 22:06:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230201AbhEKCGM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 May 2021 22:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620698706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bxQhJjwosaMf62SQwJwBiTG2HfGlvwofNXowXcF6PXs=;
        b=itxk26qeviRzsmNPn/UEuVhik18pTQsuJ22wnCt2oO/ocPX1MPk4mU2pjXI17F6+kXMsHp
        vljTKPRjON+i2qMNvIbsLdHxphqnHbTVWWnsWuVKeqcL7XIklg4IzOFTU6KJBpPj3Vi+Al
        Gb/yPSGYDj/zixgPy3jjjNrjQA+b+HE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-1vRXyr03P1CrVxJIqBLM6w-1; Mon, 10 May 2021 22:05:04 -0400
X-MC-Unique: 1vRXyr03P1CrVxJIqBLM6w-1
Received: by mail-pl1-f200.google.com with SMTP id i6-20020a170902c946b02900ef606230faso160201pla.4
        for <linux-xfs@vger.kernel.org>; Mon, 10 May 2021 19:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bxQhJjwosaMf62SQwJwBiTG2HfGlvwofNXowXcF6PXs=;
        b=cGBHvq8jImfOe8J4R4Wyo/rzfQcg9r5uARFS0PNHPb07kwrZwDpErrRfguNY85a9Z4
         Wguf8YN6ndiOw4O9MailogcgRfLVbiI6JnP4rfrWLXGNR7EL/LrYSANFg0KTPa7e6MRP
         Y40aY4A5iL9S0E9Cb5d6DOrs291NfN6WMrwX3ZwrF0swZqgzr29q2kpUFECbSwf2+fdD
         OHiNgTnhyly1Cjyd5jK+vyVo6mr2q8DGZ4lP+NaoYUczCkUKphoImGxG/yrW/0b7iQCt
         4+RcGl585LhkJ9tiYJtSP+rehAQgwL9nTDraoFDX93f1WLR64i3fkug7t5k+PeiNj5ZQ
         CQMg==
X-Gm-Message-State: AOAM531bMtbIe6ED5SHNM0DR8qrs8YHS9tG2341b9rWVVKsN3LSSv/Hf
        y9gkGMyCoVSfE2ckZfFZC5iJ8e9FBOIQTszdk0aAJadjnbqmiy2wfMEieplbVkAZc7iPalwhucE
        WB++wXr5DSSgNo2o02TS+
X-Received: by 2002:a17:90a:cf8a:: with SMTP id i10mr30835372pju.188.1620698703477;
        Mon, 10 May 2021 19:05:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhraMy7WfYWT9TNhbNAHZqkipJfyuR9ZY7PCuEFOdG4vZl5rjF+1FJr9bAC96A8zlHxouSCA==
X-Received: by 2002:a17:90a:cf8a:: with SMTP id i10mr30835343pju.188.1620698703224;
        Mon, 10 May 2021 19:05:03 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z17sm599920pjr.31.2021.05.10.19.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:05:02 -0700 (PDT)
Date:   Tue, 11 May 2021 10:04:52 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v4 2/3] xfs: basic functionality test for shrinking free
 space in the last AG
Message-ID: <20210511020452.GD741809@xiangao.remote.csb>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
 <20210402094937.4072606-3-hsiangkao@redhat.com>
 <20210510180147.GB8558@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210510180147.GB8558@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 10, 2021 at 11:01:47AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 02, 2021 at 05:49:36PM +0800, Gao Xiang wrote:
> > Add basic test to make sure the functionality works as expected.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  tests/xfs/990     | 73 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/990.out | 12 ++++++++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 86 insertions(+)
> >  create mode 100755 tests/xfs/990
> >  create mode 100644 tests/xfs/990.out
> > 
> > diff --git a/tests/xfs/990 b/tests/xfs/990
> > new file mode 100755
> > index 00000000..322b09e1
> > --- /dev/null
> > +++ b/tests/xfs/990
> > @@ -0,0 +1,73 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 990
> > +#
> > +# XFS shrinkfs basic functionality test
> > +#
> > +# This test attempts to shrink with a small size (512K), half AG size and
> > +# an out-of-bound size (agsize + 1) to observe if it works as expected.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +test_shrink()
> > +{
> > +	$XFS_GROWFS_PROG -D"$1" $SCRATCH_MNT >> $seqres.full 2>&1
> > +	ret=$?
> > +
> > +	_scratch_unmount
> > +	_check_scratch_fs
> > +	_scratch_mount
> > +
> > +	$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
> > +	. $tmp.growfs
> > +	[ $ret -eq 0 -a $1 -eq $dblocks ]
> > +}
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_xfs_scratch_shrink
> > +
> > +rm -f $seqres.full
> > +echo "Format and mount"
> > +
> > +# agcount = 1 is forbidden on purpose, and need to ensure shrinking to
> > +# 2 AGs isn't fensible yet. So agcount = 3 is the minimum number now.
> 
> s/fensible/feasible/
> 
> > +_scratch_mkfs -dsize="$((512 * 1024 * 1024))" -dagcount=3 2>&1 | \
> > +	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> > +. $tmp.mkfs
> > +t_dblocks=$dblocks
> > +_scratch_mount >> $seqres.full
> > +
> > +echo "Shrink fs (small size)"
> > +test_shrink $((t_dblocks-512*1024/dbsize)) || \
> > +	_fail "Shrink fs (small size) failure"
> > +
> > +echo "Shrink fs (half AG)"
> > +test_shrink $((t_dblocks-agsize/2)) || \
> > +	_fail "Shrink fs (half AG) failure"
> > +
> > +echo "Shrink fs (out-of-bound)"
> > +test_shrink $((t_dblocks-agsize-1)) && \
> > +	_fail "Shrink fs (out-of-bound) failure"
> > +[ $dblocks -ne $((t_dblocks-agsize/2)) ] && \
> > +	_fail "dblocks changed after shrinking failure"
> 
> Can these be echo statements, since the diff in golden output will trip
> anyway?

Ok, will update.

Thanks,
Gao Xiang

> 
> --D

