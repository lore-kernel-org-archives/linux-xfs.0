Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381A2C2BBD1
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0517420872
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:58:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oo/KI4K4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgIQD6A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQD57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:57:59 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 23:57:59 EDT
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF53C06178A;
        Wed, 16 Sep 2020 20:50:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so571137pgl.2;
        Wed, 16 Sep 2020 20:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Pq897mA0E+YiwpTXx+Y05awuEoIpZKeCAluqPqO8+E=;
        b=Oo/KI4K4YSSuVqjNVQfaYNXkqxT2o5RF/GIUXdfmOHWH7rUqDRL5Na/zoyS208UoaZ
         8d+UhEP5St8Cu0jNPyyHwGfPz+aIU5hXYC4dTYT+RP5CwbA/RFLXZXdjVLxe6G68ozvi
         Wcs7i2fU9lQYYM2wggUxyr/cW/oigYamqQ4TYWo5ZjfBxGt3gYkftFbDcAAToezMjf1w
         g963DtA1jcSw1cwJLi5w5KiFqLplUHMCPFz3XInjgyrMR/g+zcwEejj/0wepUIgoFOJF
         LxxxmmrgdcamDeGsfFFrchBNbt2Bbm/KJA7kQhsYQMPwqr+qVku18mceoT4+E1s8lSzn
         6XVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Pq897mA0E+YiwpTXx+Y05awuEoIpZKeCAluqPqO8+E=;
        b=rslLP+ECl0RdI26eoU0coAh+SlQfOeqx3zAiBUXxZ71YCdNYeIOPyZvLWhpNSXY1Zn
         AsBuN5+8WrKr2hlZJKwZPaS0gU/Xfkj1RKHeNT3xxO/GD+mCceZ1mwO/nsExkGt4oqTb
         vixRSgOddd6uKbVUyAF/nH72zshBvi6R9yBBbYmOQ+RNnUTgRYr9By3hw7IKIQfrazT9
         +4UU7SjviOInoN2b4k4f8y8v64eu44HPixG/0HRof6OLEI0O233mkjjnd9wiijSUbLy7
         ZJ8g+puKRbOUlwfIho546QT/bsoRCX6kXGuDVN60S1lIY6gRaos9FC+KFWfDEkLss6Am
         831w==
X-Gm-Message-State: AOAM530z3TZ6l1McEjLOpC9L5uq+i8qYNgwpVZxWH2KxwNVMKpH0+rBd
        YlZn6Us94CCk4ymrGclA0PQ=
X-Google-Smtp-Source: ABdhPJzgkXHuUAmU5sa1Qr6slsaqvQ5lYwN7nQiZvlS90ztjlhpzzb8hqiElgAVtRIX6Qh/E4qXCcA==
X-Received: by 2002:a62:5887:0:b029:142:2501:34f3 with SMTP id m129-20020a6258870000b0290142250134f3mr9228833pfb.76.1600314656878;
        Wed, 16 Sep 2020 20:50:56 -0700 (PDT)
Received: from garuda.localnet ([122.179.62.198])
        by smtp.gmail.com with ESMTPSA id f4sm17559081pfj.147.2020.09.16.20.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 20:50:56 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, zlang@redhat.com
Subject: Re: [PATCH V2 2/2] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Thu, 17 Sep 2020 09:20:48 +0530
Message-ID: <3165014.P34N0lVvxh@garuda>
In-Reply-To: <20200916165333.GE7954@magnolia>
References: <20200916053407.2036-1-chandanrlinux@gmail.com> <20200916053407.2036-2-chandanrlinux@gmail.com> <20200916165333.GE7954@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 16 September 2020 10:23:33 PM IST Darrick J. Wong wrote:
> On Wed, Sep 16, 2020 at 11:04:07AM +0530, Chandan Babu R wrote:
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
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
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
> Is this unmount crucial to exposing the bug?  Or does this post-test
> unmount and fsck suffice?

No, the above call to _scratch_unmount isn't required for recreating the
bug. I will remove it and post the patch once again.

> 
> (The rest of the logic looks ok to me.)
> 
> --D

-- 
chandan



