Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AE3C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3759520872
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:33:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WY1OAqet"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgIQEdL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 00:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQEdK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 00:33:10 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59B6C06174A;
        Wed, 16 Sep 2020 21:33:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z18so432968pfg.0;
        Wed, 16 Sep 2020 21:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FyR5fyi5w0XjCKQksRNkLLJN1QZEUOz9EQM8RCV5ts4=;
        b=WY1OAqetVElOBy/d2WM9dkpsmVAp1OBQSvc31HxOJh5kf1SD5KMPvRiZALLHMnvs54
         CqUtGuWeUegeUE9QDewdQAePlPYarSBHUF/sKUUHV2N9Md2aDAUBshHc4DA7OrElg3HN
         ZJ6rrIH7zvXNjlx6swKHuj260JLEqEohBfnVrFUREnKYW3uQJvoRqjMeCul31ekzbqSn
         dmXCaFroj1/EiUxmG5LmZiCKE+6InNyeUr+1Me/Hycwo1R56MwrYcnRUOrJFNyf7aQFR
         mt1h5InTnh/9fr4oexDCSsOvNIRjIXa6KTB5fatxJRb8WtaleszzhBhO0Q0qkrxi376l
         9vaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FyR5fyi5w0XjCKQksRNkLLJN1QZEUOz9EQM8RCV5ts4=;
        b=HmcSdwo3Zqowq9Xn4dUzdMJFMPRq/R/Dxdhv6fa6Rcr8EbTGR1r9eSfuGBUC0AxF7D
         O9r+ASelSGvvmCccjH1hg310IClaIQm66kIYcCbj1cFmpDpfN1abwsE8nsuaGSOnpcIy
         9/ocG32GcaLmrfVx5Tdhw90hPZvfrVIiXnnCLcZ26GXN5gYM1G/dSFC1QM+fzIzXIJlG
         5J+Ydh1+8gqeFcWsHYXs7zkxVfyMpzU4XWdxhBqPjmp8seV3N25yUllEjEu6iHJM8O0Q
         RJXXdm8nIQnsxMPJuMAUHdhEpo/uHIqeUWDGc6RC4NVuV0TgTIoEQ+0LrUvMlAvQUN4r
         aCdg==
X-Gm-Message-State: AOAM5320KiFgaJ1IGZZE7iQ7s2nNEes03HfPlJRk7H11bmdnHq/wLCfo
        FZXqeIeLYK8PnmESHsY70DTTNuNFM5A=
X-Google-Smtp-Source: ABdhPJyEE7tyhmAukCwG76pd3nKnDazHfQZ7MEw0F66+sAZlc75mCQd5hm5ppn1gy6ng2avjmtJ89g==
X-Received: by 2002:a62:7d91:0:b029:13e:d13d:a061 with SMTP id y139-20020a627d910000b029013ed13da061mr25503133pfc.39.1600317189075;
        Wed, 16 Sep 2020 21:33:09 -0700 (PDT)
Received: from garuda.localnet ([122.179.62.198])
        by smtp.gmail.com with ESMTPSA id 1sm12255382pfx.126.2020.09.16.21.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 21:33:08 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: Re: [PATCH 2/2] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Thu, 17 Sep 2020 10:03:00 +0530
Message-ID: <13119690.9hPdCOARrb@garuda>
In-Reply-To: <20200917042844.6063-2-chandanrlinux@gmail.com>
References: <20200917042844.6063-1-chandanrlinux@gmail.com> <20200917042844.6063-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 17 September 2020 9:58:44 AM IST Chandan Babu R wrote:
> This commit adds a test to check if growing a real-time device can end
> up logging an xfs_buf with the "type" subfield of
> bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
> occurs the following call trace is printed on the console,
> 
> XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> Call Trace:
>  xfs_buf_item_format+0x632/0x680
>  ? kmem_alloc_large+0x29/0x90
>  ? kmem_alloc+0x70/0x120
>  ? xfs_log_commit_cil+0x132/0x940
>  xfs_log_commit_cil+0x26f/0x940
>  ? xfs_buf_item_init+0x1ad/0x240
>  ? xfs_growfs_rt_alloc+0x1fc/0x280
>  __xfs_trans_commit+0xac/0x370
>  xfs_growfs_rt_alloc+0x1fc/0x280
>  xfs_growfs_rt+0x1a0/0x5e0
>  xfs_file_ioctl+0x3fd/0xc70
>  ? selinux_file_ioctl+0x174/0x220
>  ksys_ioctl+0x87/0xc0
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x3e/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
> files" is required to fix this issue.
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---

Sorry, I forgot to add version number and also a changelog.

V2 -> V3:
  1. Remove unnecessary invocation of _scratch_unmount at the end of the test.
  
>  tests/xfs/260     | 51 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/260.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 54 insertions(+)
>  create mode 100755 tests/xfs/260
>  create mode 100644 tests/xfs/260.out
> 
> diff --git a/tests/xfs/260 b/tests/xfs/260
> new file mode 100755
> index 00000000..1cafa368
> --- /dev/null
> +++ b/tests/xfs/260
> @@ -0,0 +1,51 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 260
> +#
> +# Test to check if growing a real-time device can end up logging an xfs_buf with
> +# the "type" subfield of bip->bli_formats->blf_flags set to
> +# XFS_BLFT_UNKNOWN_BUF.
> +#
> +# This is a regression test for the kernel patch "xfs: Set xfs_buf type flag
> +# when growing summary/bitmap files".
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
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
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_realtime
> +
> +_scratch_mkfs -r size=10M  >> $seqres.full
> +
> +_scratch_mount >> $seqres.full
> +
> +$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/260.out b/tests/xfs/260.out
> new file mode 100644
> index 00000000..18ca517c
> --- /dev/null
> +++ b/tests/xfs/260.out
> @@ -0,0 +1,2 @@
> +QA output created by 260
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index b99ca082..d6d4425d 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -257,6 +257,7 @@
>  257 auto quick clone
>  258 auto quick clone
>  259 auto quick
> +260 auto quick growfs realtime
>  261 auto quick quota
>  262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  263 auto quick quota
> 


-- 
chandan



