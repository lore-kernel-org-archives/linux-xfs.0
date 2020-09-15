Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F36C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 07:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8978E2080C
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 07:23:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USV0f2jw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgIOHXj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgIOHXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 03:23:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6F7C06174A;
        Tue, 15 Sep 2020 00:23:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t7so1306791pjd.3;
        Tue, 15 Sep 2020 00:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pqWu8xCLO5AybUadyWmMrev0JOISEe+kDQz4bZfO0ZU=;
        b=USV0f2jwSerK6ofoTh33JswAdqrvvGazki+xYAbFMP9KI7FZg0i+SFqmTJN+ZNbQCZ
         Oy4uvMnalj4K8qR0OYwA/Z54KTxIIT9bgIM8EBX0djee2lnYacoCTJxpSp35neaR+D9o
         2hl3HvbWb7nE6I+oAp/UJ+xYpmiRwz/C1ZKsB71cp04NrNYQcRTxWwJ9W5UroJ0KlngX
         YvM6XzL+RE0qDyQcdGWIZ2+G4F7gCOtGOPXqvQOw7A2dgU9ivWAjSQh49vA8h7lpUDbD
         1SmrSFQ+LT9knGO17oyxQujDzFFe4/37oiYnVmZ4EQcEE4bmrKuAuzL62i6GgQdgRmPr
         MHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pqWu8xCLO5AybUadyWmMrev0JOISEe+kDQz4bZfO0ZU=;
        b=P1lVeWwZTMO7aoLrgZbPuro9IcSVt86qM/+BbSCowQ0j2KOsniH5Aa7YpXtArvrsZK
         tjrhb0HxW/BDbfH2oQ5oGYr3+Wj6aHMDOYXKQRnLzMF9f5nzKLDsMYoCT4rts18b8kAV
         1eVXjYD1zIOMkuqF/Oie2jvWQ9dgnp0wFLz5OJWa7YNEYsAl2KB+pxhN7opYoWlkao1c
         C1iFfQtPm9aEs1bmGJpdkRwlnNIbiHMTBZR9poE5v8wiMUtCTLTe65g5t9BZAdD4flkl
         na8iGFF5P2UBzGMib7nKFH9AYl1/jU4X6H2fizR6+EKadEcB1L6cQe1NfulZUxvOzMRR
         Y10w==
X-Gm-Message-State: AOAM533qRempfXBWqzuvLAdRNRK3cz2mJBMZFONiAEmgOFrmVhCRHv9i
        GbH5FVFKAD4qmPaLZ+an5lCj9InNziw=
X-Google-Smtp-Source: ABdhPJzdO1arlSKGsLwM+l9KJtBhEvH35Zmv5EaoBCAwRl0F41lX45mLeiS6/p+1oo4WaV/HobVkcQ==
X-Received: by 2002:a17:90a:bf92:: with SMTP id d18mr2904633pjs.210.1600154607050;
        Tue, 15 Sep 2020 00:23:27 -0700 (PDT)
Received: from garuda.localnet ([122.179.36.63])
        by smtp.gmail.com with ESMTPSA id k62sm5511958pge.36.2020.09.15.00.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 00:23:26 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, darrick.wong@oracle.com
Subject: Re: [PATCH V2] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Tue, 15 Sep 2020 12:53:22 +0530
Message-ID: <2327937.js4hDJpFsT@garuda>
In-Reply-To: <20200915071922.GO2937@dhcp-12-102.nay.redhat.com>
References: <20200915054748.1765-1-chandanrlinux@gmail.com> <20200915071922.GO2937@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 15 September 2020 12:49:22 PM IST Zorro Lang wrote:
> On Tue, Sep 15, 2020 at 11:17:48AM +0530, Chandan Babu R wrote:
> > This commit adds a test to check if growing a real-time device can end
> > up logging an xfs_buf with the "type" subfield of
> > bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
> > occurs the following call trace is printed on the console,
> > 
> > XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> > Call Trace:
> >  xfs_buf_item_format+0x632/0x680
> >  ? kmem_alloc_large+0x29/0x90
> >  ? kmem_alloc+0x70/0x120
> >  ? xfs_log_commit_cil+0x132/0x940
> >  xfs_log_commit_cil+0x26f/0x940
> >  ? xfs_buf_item_init+0x1ad/0x240
> >  ? xfs_growfs_rt_alloc+0x1fc/0x280
> >  __xfs_trans_commit+0xac/0x370
> >  xfs_growfs_rt_alloc+0x1fc/0x280
> >  xfs_growfs_rt+0x1a0/0x5e0
> >  xfs_file_ioctl+0x3fd/0xc70
> >  ? selinux_file_ioctl+0x174/0x220
> >  ksys_ioctl+0x87/0xc0
> >  __x64_sys_ioctl+0x16/0x20
> >  do_syscall_64+0x3e/0x70
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
> > files" is required to fix this issue.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/260     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/260.out |  2 ++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 56 insertions(+)
> >  create mode 100755 tests/xfs/260
> >  create mode 100644 tests/xfs/260.out
> > 
> > diff --git a/tests/xfs/260 b/tests/xfs/260
> > new file mode 100755
> > index 00000000..078d4a11
> > --- /dev/null
> > +++ b/tests/xfs/260
> > @@ -0,0 +1,53 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 260
> > +#
> > +# Test to check if growing a real-time device can end up logging an xfs_buf with
> > +# the "type" subfield of bip->bli_formats->blf_flags set to
> > +# XFS_BLFT_UNKNOWN_BUF.
> > +#
> > +# This is a regression test for the kernel patch "xfs: Set xfs_buf type flag
> > +# when growing summary/bitmap files".
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_realtime
> > +
> > +_scratch_mkfs -r size=10M  >> $seqres.full
> > +
> > +_scratch_mount >> $seqres.full
> > +
> > +$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
> > +
> > +_scratch_unmount
> > +
> > +echo "Silence is golden"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/260.out b/tests/xfs/260.out
> > new file mode 100644
> > index 00000000..18ca517c
> > --- /dev/null
> > +++ b/tests/xfs/260.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 260
> > +Silence is golden
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index ed0d389e..68676064 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -257,6 +257,7 @@
> >  257 auto quick clone
> >  258 auto quick clone
> >  259 auto quick
> > +260 auto quick growfs realtime
> 
> There's not 'realtime' group before. Although I don't have a objection to add
> this group, if you'd like to add this one, my personal opinion is using another
> patch to add all 'rt' related cases into this group, or don't use this group
> name alone.

Ok. I will write another patch to collect all realtime tests in one group. I
will base the current patch on top of that. 

> 
> Besides this nitpicking, others looks good to me.
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> Thanks,
> Zorro
> 
> >  261 auto quick quota
> >  262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> >  263 auto quick quota
> 
> 

-- 
chandan



