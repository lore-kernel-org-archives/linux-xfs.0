Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCF3C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 05:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A3E7216C4
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 05:40:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5EL/qqn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgIOFkr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 01:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgIOFkq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 01:40:46 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356BCC06174A;
        Mon, 14 Sep 2020 22:40:46 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh1so744706plb.12;
        Mon, 14 Sep 2020 22:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OXkoZP5GOTvGbbS2nPzjqUhqUqK2PiwGQdX51BUp73E=;
        b=N5EL/qqn3Ky2wr07SMtFurRRGbf1H0CMtCSUgPMmfOUGaUbBv2s7x7+yEjp7iJHX/8
         dQBjkILN6GcbfSZRlwraMvVaForH6AQytP7q6cRajDZ/jZhwTAPwyEWtU4a6en55KcB/
         +nE+fYEtVDaiCCAOS9x5nOY1ex7Kh982jHwO8aZ39eilr7hAK5OrnNms31gHNxsXXhGY
         IiFtvOONrCLuWXQj/TCBonHWlm5Ic7MQUsjFQ/EDh3tEuqSYO51NzLnypt4P0edQDOQb
         Wwuzfm5voF/cgqZhQaVNZFTYf6qBD0Oj2XUCc2nkDFPsPKltR1agFJ54M7Q9HK28FsY5
         zQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OXkoZP5GOTvGbbS2nPzjqUhqUqK2PiwGQdX51BUp73E=;
        b=AMZCWl/DDQ/7Fouo4jijY/1hZQ0ivC3NQFkyPGexMOmv9ez0iJtul/AQoc89mRZMEy
         CfmffWFt7LnQYDsoeMmftfx67Vl2RhUgGzZ+XD4ykaUwG8YD4kB0J11u2vjMTg8m7jN3
         fA6OAsLDdo3fw+8Mj8Z9A0CPwL9Zllf/VIzNxMlF1a4P7dSfoUZm/FzTC7GFBpW14qK0
         mliKWVq0zeFNQUXlbYY+Mw5gSlJ1VRT7zR3blQzoAALVOoD0ddEhzbRaTsyNuZ3U8kak
         bbmbVsjC/g59EGYq31to8U34fMWeDoIywqhODMc/3onD9xGKbTyAcOVaVcb5/UdtlBKY
         my/w==
X-Gm-Message-State: AOAM533TcQiSYA1aEpnLgNjhqHZ4JI8hNZcY03s6dLzyGFQUZqmPrLhy
        D4f4SRwY7iA8xQKG9L2EBtBO4EjExY8=
X-Google-Smtp-Source: ABdhPJwsJsitfbdNB09b5xAe4N0PdEcJmols0L2q5EDcOA3U848y8Wj61nN+K/zGPNhiUZlWS6Dzig==
X-Received: by 2002:a17:90b:2383:: with SMTP id mr3mr2645592pjb.29.1600148445698;
        Mon, 14 Sep 2020 22:40:45 -0700 (PDT)
Received: from garuda.localnet ([122.179.36.63])
        by smtp.gmail.com with ESMTPSA id u6sm10872435pjy.37.2020.09.14.22.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 22:40:45 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        guaneryu@gmail.com, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Tue, 15 Sep 2020 11:10:36 +0530
Message-ID: <30774216.rA1kxOikNk@garuda>
In-Reply-To: <20200914151346.GX7955@magnolia>
References: <20200914090053.7220-1-chandanrlinux@gmail.com> <20200914103456.GN2937@dhcp-12-102.nay.redhat.com> <20200914151346.GX7955@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 14 September 2020 8:43:46 PM IST Darrick J. Wong wrote:
> On Mon, Sep 14, 2020 at 06:34:56PM +0800, Zorro Lang wrote:
> > On Mon, Sep 14, 2020 at 02:30:53PM +0530, Chandan Babu R wrote:
> > > This commit adds a test to check if growing a real-time device can end
> > > up logging an xfs_buf with the "type" subfield of
> > > bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
> > > occurs the following call trace is printed on the console,
> > > 
> > > XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> > > Call Trace:
> > >  xfs_buf_item_format+0x632/0x680
> > >  ? kmem_alloc_large+0x29/0x90
> > >  ? kmem_alloc+0x70/0x120
> > >  ? xfs_log_commit_cil+0x132/0x940
> > >  xfs_log_commit_cil+0x26f/0x940
> > >  ? xfs_buf_item_init+0x1ad/0x240
> > >  ? xfs_growfs_rt_alloc+0x1fc/0x280
> > >  __xfs_trans_commit+0xac/0x370
> > >  xfs_growfs_rt_alloc+0x1fc/0x280
> > >  xfs_growfs_rt+0x1a0/0x5e0
> > >  xfs_file_ioctl+0x3fd/0xc70
> > >  ? selinux_file_ioctl+0x174/0x220
> > >  ksys_ioctl+0x87/0xc0
> > >  __x64_sys_ioctl+0x16/0x20
> > >  do_syscall_64+0x3e/0x70
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > 
> > > The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
> > > files" is required to fix this issue.
> > > 
> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > ---
> > >  tests/xfs/260     | 52 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/260.out |  2 ++
> > >  tests/xfs/group   |  1 +
> > >  3 files changed, 55 insertions(+)
> > >  create mode 100755 tests/xfs/260
> > >  create mode 100644 tests/xfs/260.out
> > > 
> > > diff --git a/tests/xfs/260 b/tests/xfs/260
> > > new file mode 100755
> > > index 00000000..5fc1a5fc
> > > --- /dev/null
> > > +++ b/tests/xfs/260
> > > @@ -0,0 +1,52 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 260
> > > +#
> > > +# Test to check if growing a real-time device can end up logging an
> > > +# xfs_buf with the "type" subfield of bip->bli_formats->blf_flags set
> > > +# to XFS_BLFT_UNKNOWN_BUF.
> 
> Please state explicitly that this is a regression test for "xfs: Set
> xfs_buf type flag when growing summary/bitmap files".
>

Sure. I will add a description to the comment header.

> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> >      ^^^^
> > I think this comment line is useless

Sorry, I missed out on removing that.

> > 
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_realtime
> > > +
> > > +MKFS_OPTIONS="-f -m reflink=0,rmapbt=0 -r rtdev=${SCRATCH_RTDEV},size=10M" \
> > > + 	    _mkfs_dev $SCRATCH_DEV >> $seqres.full
> > 
> > Hmm... if you need a sized rtdev, the _scratch_mkfs really can't help that
> > for now. You have to use _mkfs_dev(as you did) or make the helper to support
> > rtdev size:)
> 
> Does "_scratch_mkfs -r size=10M" not work here?

It works! Thanks for the suggestion.

> 
> > I don't know why you need "reflink=0,rmapbt=0", but not old xfsprogs doesn't
> > supports this two options, so you might need _scratch_mkfs_xfs_supported()
> > to check that. If they're not supported, they won't be enabled either. And
> > better to add comment to explain why make sure reflink and rmapbt are disabled.
> 
> That's a bug in mkfs.xfs, which should be fixed by "mkfs: fix
> reflink/rmap logic w.r.t.  realtime devices and crc=0 support".

I have replaced this part with just
_scratch_mkfs -r size=10M >> $seqres.full.

IMHO, the tester has to specify reflink=0 explicitly when testing realtime
configurations when using xfsprogs which support reflink and don't have
"mkfs: fix reflink/rmap logic w.r.t.  realtime devices and crc=0 support"
patch applied . Otherwise, the call to _scratch_mkfs() inside "check" script
will fail.

> 
> > > +_scratch_mount -o rtdev=$SCRATCH_RTDEV
> > 
> > As I known, xfstests deal with SCRATCH_RTDEV things in common/rc _scratch_options()
> > properly, _require_realtime with _scratch_mount are enough, don't need the
> > "-o rtdev=$SCRATCH_RTDEV".

You are right. I will remove it before posting the next version.

> > 
> > > +
> > > +$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
> > > +
> > > +_scratch_unmount
> > > +
> > > +echo "Silence is golden"
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/260.out b/tests/xfs/260.out
> > > new file mode 100644
> > > index 00000000..18ca517c
> > > --- /dev/null
> > > +++ b/tests/xfs/260.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 260
> > > +Silence is golden
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index ed0d389e..6f30a2e7 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -257,6 +257,7 @@
> > >  257 auto quick clone
> > >  258 auto quick clone
> > >  259 auto quick
> > > +260 auto
> > 
> > Better to add 'growfs' group, and if the case is quick enough, 'quick' is acceptable:)
> 
> And maybe the 'realtime' group.
>

Sure, will do.

Darrick and Zorro, Thanks for your review comments.

> 
> > >  261 auto quick quota
> > >  262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> > >  263 auto quick quota
> > 
> 


-- 
chandan



