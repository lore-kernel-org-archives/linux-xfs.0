Return-Path: <SRS0=3Xx9=C6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB795C43465
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Sep 2020 04:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90949212CC
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Sep 2020 04:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/XNKz6S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgIUEvd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 00:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgIUEvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Sep 2020 00:51:32 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802CEC061755;
        Sun, 20 Sep 2020 21:51:32 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q4so6779336pjh.5;
        Sun, 20 Sep 2020 21:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xioL1e29/11rRgWKhJcIyn5+WiQmSWuNnc3SUci2W00=;
        b=E/XNKz6STeLynLb7Im8ZGdESTLYGVuaCjy+0G/9d/XfLQ82toYvGfBmf6U89sNaREv
         FH9PaPj/7znapH1PiKnH2AbUFcRwAeN8fNAKwAsAEFX+ex5bvOaURwagvPzPfYpL2gYy
         fblkB0MOW735KTHsa3HEpzlLQQOXIairL+q/j7jWH4ndXNCR6u0zogDH9/Flm+SgzhvS
         MASIBFBe3Db4Iyr6QJY2W6VgRMu8UAw/0fT2M5ZbLxZOX+p1TbuT5WwbfCvXlIQpt5B6
         UdMFobO50zbcbVlWpixcgfkryS1JYuOtYPmFK+cduNvQYACJQiTWT6WNS0tRJdvdWdkN
         VK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xioL1e29/11rRgWKhJcIyn5+WiQmSWuNnc3SUci2W00=;
        b=FHfCm7+sOb8CAxEsoVgEBoAThUsoTPhRI0fsvJCy9X1YK+NZaeBHjUDkKdpL+VHrmU
         P4MEoH3jpbey/QIVCWeKrsSRkmd9F1o7yUc6WdaXTbj1KNjBuNOoSnE+WrX0XPTvYKOy
         fzwuRDL2TRd1IU4ZgAw0b1pvgBiakygnsj04WliG57nvI70W8JuNq9Ma0E1v3PUh8Pyj
         u5Ff3UMUc4OlxRCNWazqcBfCRm5f8e+F87BDFjBbMIiRe3z2b6wd+232EpdAmi26m8Dl
         mw33BYsclsc9pEED5YpolmyCMQ3xSOHuJcxX6C4vjLbEMv0/noz0J4nE+LhI5Zvla3Dt
         UEYw==
X-Gm-Message-State: AOAM530sp2pRN3/o/+bWdgBFFOusHAMzDGg3eOe3Zu9OfaMWM7IRIwlS
        NtyF+2EvnYK2IkNxKvvoT87IloFCscU=
X-Google-Smtp-Source: ABdhPJxP3q5jeCnNLypt8vwktxPFDMV9+jwBP8sPfJtYeHn7SU62eDnu0HULbsC1vJrlejrIEcbqmA==
X-Received: by 2002:a17:90a:e015:: with SMTP id u21mr22701526pjy.33.1600663892027;
        Sun, 20 Sep 2020 21:51:32 -0700 (PDT)
Received: from garuda.localnet ([171.61.71.218])
        by smtp.gmail.com with ESMTPSA id w14sm828748pfu.87.2020.09.20.21.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 21:51:31 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Eryu Guan <guan@eryu.me>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com
Subject: Re: [PATCH V2] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Mon, 21 Sep 2020 10:21:27 +0530
Message-ID: <228668426.18PeWd7I2F@garuda>
In-Reply-To: <20200920155118.GN3853@desktop>
References: <20200915054748.1765-1-chandanrlinux@gmail.com> <20200920155118.GN3853@desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday 20 September 2020 9:21:18 PM IST Eryu Guan wrote:
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
> 
> Thanks for the patch! Also thanks to Darrick and Zorro for reviewing!
> 
> The test would crash kernel without above fix, so I'd merge it after the
> fix landing upstream.
> 
> Would you please remind me when the fix is merged by replying this
> thread? And perhaps with the correct commit ID updated :)

Sure, I will keep an eye on when the patch gets merged with upstream kernel
and will respond to the mail thread.

> 
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
> 
> Any reason to do umount manually here? The test harness will umount it
> after test anyway.

This was pointed out by Darrick as well. I have removed the invocation of
_scratch_unmount() and posted V3 version of the patch
(https://www.spinics.net/lists/linux-xfs/msg45162.html).

-- 
chandan



