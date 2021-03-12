Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC499C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 16:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A0C765006
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 16:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhCLQFF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:05:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232009AbhCLQEd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 11:04:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615565072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dBLdbwi6TqAdEtuGliJe7RaMIVZ8I9onl5831WS/njE=;
        b=HKLsF6J0noGMlirrsvB4UZhrAhnkpihugxfTkG7bNZLh0vKxc47udUCFbm7AABfI+8hVAI
        BokPFmA1vdqwINrs7dZ4igHLDbMlEA5aoevgXP9qPgxAN4HNsz/iGpMi2v3KJSqXD4quov
        pQu5D41sQSKoqY5Yp6sNymCOOs6K3ic=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-KHKgHRoCNrKn16iK0YkfvQ-1; Fri, 12 Mar 2021 11:04:28 -0500
X-MC-Unique: KHKgHRoCNrKn16iK0YkfvQ-1
Received: by mail-pg1-f200.google.com with SMTP id h5so13565154pgi.12
        for <linux-xfs@vger.kernel.org>; Fri, 12 Mar 2021 08:04:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dBLdbwi6TqAdEtuGliJe7RaMIVZ8I9onl5831WS/njE=;
        b=NL7Xc6Zc85LWIQA/WPXPrErloAQxBc9XKoiY8W9N+4tikrxvAfi62AZgeD7+gJM/Lv
         ZeCatqoB10Azt2Ayq9WEBG6TTwPn/Xz2K19Xd/7hsC7tH2wJMHbnXx41uKJv3HyJ//1I
         ns/qeGIRbg5VX3btbIYWQMGs3BrjEl9TLkqFGI3jNqN9suq8qwdDyUezfvg7OYA/NCCS
         Fsggt1Jf6sUd5mXhgOUlw7MkENv9XDTieLxFWECTkTitBfxKOB9Ra6yBcjToNKH+hNBi
         bXQGlxRG3jyQT+ur6VrZyC9vmyHevbb98n+sMxry6wvVrqtLYXF6OtltI8NnkaxqGCZW
         4qNA==
X-Gm-Message-State: AOAM5319nGB90TZ1D/0L6ElRYHykTe3eR7C0ZJWQv5tMgK5SKCC+Rmdd
        Luql3/Bb47nZRmPHv3HadACOdw/i9B2WPAw6Kp6Ihxn6+M6NhPHIEZt90TfRarV4TtFi+88+7tm
        tXAHLLMXP+F65DRNhA9WJen2Q+xKV1pV2HxqupnyxaBwtxci3pqGkgiyQgdCqFduWqmGm86wAhQ
        ==
X-Received: by 2002:a62:ea19:0:b029:1ee:5911:c516 with SMTP id t25-20020a62ea190000b02901ee5911c516mr12976511pfh.67.1615565066991;
        Fri, 12 Mar 2021 08:04:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxb2KLOCwkxEm6jeqmXCfEhkAlNUqaUum1MGHxfZ8OXsGFDQ5HSdKwXCxkXIXSVL1v+uV0NQ==
X-Received: by 2002:a62:ea19:0:b029:1ee:5911:c516 with SMTP id t25-20020a62ea190000b02901ee5911c516mr12976482pfh.67.1615565066627;
        Fri, 12 Mar 2021 08:04:26 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c128sm5122851pfc.76.2021.03.12.08.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:04:26 -0800 (PST)
Date:   Sat, 13 Mar 2021 00:04:17 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [RFC PATCH v2 2/3] xfs: basic functionality test for shrinking
 free space in the last AG
Message-ID: <20210312160417.GA276830@xiangao.remote.csb>
References: <20210312132300.259226-1-hsiangkao@redhat.com>
 <20210312132300.259226-3-hsiangkao@redhat.com>
 <20210312155613.GK3499219@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210312155613.GK3499219@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 12, 2021 at 11:56:13PM +0800, Zorro Lang wrote:
> On Fri, Mar 12, 2021 at 09:22:59PM +0800, Gao Xiang wrote:
> > Add basic test to make sure the functionality works as expected.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  tests/xfs/990     | 59 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/990.out | 12 ++++++++++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 72 insertions(+)
> >  create mode 100755 tests/xfs/990
> >  create mode 100644 tests/xfs/990.out
> > 
> > diff --git a/tests/xfs/990 b/tests/xfs/990
> > new file mode 100755
> > index 00000000..551c4784
> > --- /dev/null
> > +++ b/tests/xfs/990
> > @@ -0,0 +1,59 @@
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
> > +# real QA test starts here
> > +_supported_fs xfs
> 
> _require_scratch

Will fix.

> 
> > +_require_xfs_shrink
> > +
> > +rm -f $seqres.full
> > +echo "Format and mount"
> > +size="$((512 * 1024 * 1024))"
> 
> Is the fixed size necessary? Is that better to let testers run this test with
> their different device/XFS geometry.

I'm fine with either way since it's a simple functionality test, yet for most
common cases, stratch devices are somewhat large. I tend to use a relative
controllable small value.

Actually, this case was from xfs/127 with some modification.

> 
> > +_scratch_mkfs -dsize=$size -dagcount=3 2>&1 | \
> > +	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> > +. $tmp.mkfs
> > +_scratch_mount >> $seqres.full 2>&1
> > +
> > +echo "Shrink fs (small size)"
> > +$XFS_GROWFS_PROG -D $((dblocks-512*1024/dbsize)) $SCRATCH_MNT \
> > +	>> $seqres.full 2>&1 || echo failure
> > +_scratch_cycle_mount
> 
> I don't understand the XFS Shrink new feature that much, is the "cycle_mount"
> necessary? If it's not, can we get more chances to find bugs without
> "cycle_mount", or with a fsck?

maybe it's useful to test unmount here. Yeah, I think it's better to try fsck
here. Good idea.

> 
> Another question is, should we verify the new size after shrink?

Yeah, will add xfs_info.

> 
> > +
> > +echo "Shrink fs (half AG)"
> > +$XFS_GROWFS_PROG -D $((dblocks-agsize/2)) $SCRATCH_MNT \
> > +	>> $seqres.full 2>&1 || echo failure
> > +_scratch_cycle_mount
> > +
> > +echo "Shrink fs (out-of-bound)"
> > +$XFS_GROWFS_PROG -D $((dblocks-agsize-1)) $SCRATCH_MNT \
> > +	>> $seqres.full 2>&1 && echo failure
> > +_scratch_cycle_mount
> > +
> > +$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
> > +
> > +_scratch_unmount
>    ^^^
>    It's not necessary.

ok. It seems that ./check will fsck scratch device as well.
Will update it.

Thanks,
Gao Xiang

