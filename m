Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEB6C6369E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 07:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C435B214DB
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 07:23:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y6zL7Jho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgJ2HVZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 03:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJ2HVB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 03:21:01 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AC8C08E750;
        Wed, 28 Oct 2020 23:45:26 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j18so1554085pfa.0;
        Wed, 28 Oct 2020 23:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hzhmc22DJRpPAi0cmRK+04lfxbZmgdcrPj0UsBGZmOQ=;
        b=Y6zL7Jho/cdHZT0xnoCICLR5/y0c5kzgY7YEu6ekJYv3WlEmu+f8akgEaRVBFrwVu1
         +JiM+IiWf0pX0z+BhN1aKqOEO2NlZag9lVawYH5rqZfGqxi4gDXY1VhbU5WtyKe5Eif8
         MUM0ItYgfjstWinRbchEtSsB8rQxrOlaxW08A02JogeHt/JRZvrBumrZvZx9xTxiDmyz
         cQoQG0E2dK9jfyljLX1BBTtHmF4nqRyAiD5+hA0+TKZq9jvzeUM7E3iPnElWfxPoip55
         XO/i1myYSUAdVklADWsOU1eUD7UNXcij0YkDII65wGBrE8eoFI1pKQQlR7kImGVaFrDn
         6fxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hzhmc22DJRpPAi0cmRK+04lfxbZmgdcrPj0UsBGZmOQ=;
        b=poC8xwpAK8fKijmbWLCIf8sXGZgZHGdKsfFNYHaxjBMdp/jY0RQw0JbuiZA+fSCiEw
         HV0uRySzBvO69rAN3Jc7UKJtjf+z94l7vHwuu1UiSC8ZcbiyugykRn1E3wALHWKfFnhA
         x4ng1j0gjNbXJEcFqU8O+WbH5heF44eYh4LW2cNBGNlwHsRZWsFzN2p6fHm3mHdWwa4v
         mwTSqbuZT9YC8QybQysmz4VlN/QVNDY52lxUHdn81sTXvge4lnel5NlXrd4tycDd1wcq
         HSZI8fam1piRG212tyS+kDBVL3TSbFE369QJ+SyCZFGSJc5flsGiQiTs0ag/obGH04ix
         HBHw==
X-Gm-Message-State: AOAM533IPjbliFY8wvndgLZHYl1HHM0bRmFaJSPnmvSZ7RoTAKIQhka9
        IweWsq21hyu/PiCePy6QQyA=
X-Google-Smtp-Source: ABdhPJx90LTo/G8SNn9E28b5ptY1haFY6RuzOezFDtzygEGH8cHjjQG+aBI2m+6IcifOgH2u5GTRVg==
X-Received: by 2002:a17:90b:14ca:: with SMTP id jz10mr2284419pjb.180.1603953926245;
        Wed, 28 Oct 2020 23:45:26 -0700 (PDT)
Received: from garuda.localnet ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id g15sm1372073pgi.89.2020.10.28.23.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 23:45:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: test regression in xfs_bmap_validate_extent
Date:   Thu, 29 Oct 2020 12:15:22 +0530
Message-ID: <2826717.ElUu2ovCxt@garuda>
In-Reply-To: <160382536365.1203387.5299416996869850602.stgit@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia> <160382536365.1203387.5299416996869850602.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 28 October 2020 12:32:43 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is a regression test to make sure that we can have realtime files
> with xattr blocks and not trip the verifiers.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/758     |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/758.out |    2 ++
>  tests/xfs/group   |    1 +
>  3 files changed, 62 insertions(+)
>  create mode 100755 tests/xfs/758
>  create mode 100644 tests/xfs/758.out
> 
> 
> diff --git a/tests/xfs/758 b/tests/xfs/758
> new file mode 100755
> index 00000000..e522ae28
> --- /dev/null
> +++ b/tests/xfs/758
> @@ -0,0 +1,59 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 758
> +#
> +# This is a regression test for "xfs: fix xfs_bmap_validate_extent_raw when
> +# checking attr fork of rt files", which fixes the bmap record validator so
> +# that it will not check the attr fork extent mappings of a realtime file
> +# against the size of the realtime volume.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_realtime
> +
> +rm -f $seqres.full
> +
> +# Format filesystem with very tiny realtime volume
> +_scratch_mkfs -r size=256k > $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +# Create a realtime file
> +$XFS_IO_PROG -f -R -c 'pwrite 0 64k' -c stat $SCRATCH_MNT/v >> $seqres.full
> +
> +# Add enough xattr data to force creation of xattr blocks at a higher address
> +# on the data device than the size of the realtime volume
> +for i in `seq 0 16`; do
> +	$ATTR_PROG -s user.test$i $SCRATCH_MNT/v < $SCRATCH_MNT/v >> $seqres.full
> +done
> +
> +# Force flushing extent maps to disk to trip the verifier
> +_scratch_cycle_mount
> +
> +# Now let that unmount
> +echo Silence is golden.
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/758.out b/tests/xfs/758.out
> new file mode 100644
> index 00000000..6d219f8e
> --- /dev/null
> +++ b/tests/xfs/758.out
> @@ -0,0 +1,2 @@
> +QA output created by 758
> +Silence is golden.
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ffd18166..771680cf 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -519,4 +519,5 @@
>  519 auto quick reflink
>  520 auto quick reflink
>  521 auto quick realtime growfs
> +758 auto quick rw attr realtime
>  763 auto quick rw realtime
> 
> 


-- 
chandan



