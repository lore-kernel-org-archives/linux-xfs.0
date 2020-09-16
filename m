Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC389C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96A2921D43
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:29:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FReByZtt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgIPS3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 14:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgIPS2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 14:28:49 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F445C014DC9;
        Wed, 16 Sep 2020 06:12:01 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bg9so3169893plb.2;
        Wed, 16 Sep 2020 06:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lN1y5ZTbcI1+0bV+O1/fXyIzONA1l1uRaxiHigfQAzc=;
        b=FReByZttRw5q+oiP4c3s1yT3kiNpuVOSF/U1uHq56d4clZhv3DeBcB+BLcJkn2gIaO
         xNTDVJZ+Zuzeb4KcTz0Lf1rbvHwZ47ibuseKWo5AqgrqZC80WxXZs3zkTc5mlRc5c14M
         ADUJKuoC0ORb4sQTJRTReVharmNxmgqxwUy6lOXP4hUNHqBegpCxsLahzxuQZmFYthPQ
         WtsCE9cV5n0zIIJeIbbRUUnFvZcMr38rMj1+7YRTxo3YntPgxWrFa/cbB0c9u4LlJIS0
         dHiIiG+4QJXhkA1n+dxWNVqDz+Z4OFx3ktVqTwbchbKNgVH8I0UqpoZ9FgEwpstEePG/
         5sCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lN1y5ZTbcI1+0bV+O1/fXyIzONA1l1uRaxiHigfQAzc=;
        b=bKZywDb5fBx6VlEKPy53yJUDAh5Drymjg2FZny7RtAvJQLRZRshIv6756jQozw/LjZ
         bTyEvo2Gw5kT45aidFUeCFSUNpyJBq8H0rpS/4XoiCF7Mzd1E+GxSL6rHjHmNmtmnTqf
         TBksW7vwMnWCSGXiilIRfolE0ucS17TyuSQaITkwcuYGf8heVReVwtLRK4v6Pusvq8CR
         Z/2JnabQHdE3y4CEdj/OpRcPiUjHQUlvMx/QqaBzydD5Yfi6DvtItk3OHlUKhjZ1edim
         IpvX73QzrW3uA3r8QHZ4CbkdVH7cqE8/F0IsLk5bxvx8PNWnNOZJkIXwr27qA0MYbFSZ
         4MdQ==
X-Gm-Message-State: AOAM533784u66z1+zxaggGQ5AmTOrOydoZSIgJgTURuE8wHdlF1oSeTH
        YSXWBBEjnw542AGBaidr4n4=
X-Google-Smtp-Source: ABdhPJxurqrYk6oFjBlW+DX8ptvO0wC1UXx7GcJ5j5j/1VYxwVNRM5mq7wV6lHfUxI4+uesGRDJSXw==
X-Received: by 2002:a17:90a:8981:: with SMTP id v1mr4096218pjn.54.1600261920629;
        Wed, 16 Sep 2020 06:12:00 -0700 (PDT)
Received: from garuda.localnet ([171.48.17.146])
        by smtp.gmail.com with ESMTPSA id d77sm17084222pfd.121.2020.09.16.06.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 06:11:59 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     guaneryu@gmail.com
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: Re: [PATCH V2 2/2] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Wed, 16 Sep 2020 18:41:55 +0530
Message-ID: <2438001.59BAfK7u84@garuda>
In-Reply-To: <20200916053407.2036-2-chandanrlinux@gmail.com>
References: <20200916053407.2036-1-chandanrlinux@gmail.com> <20200916053407.2036-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 16 September 2020 11:04:07 AM IST Chandan Babu R wrote:
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

Eryu,

Sorry, I forgot to add Darrick's RVB tag. Please let me know if I have to
resend the patch with the missing RVB.

> Reviewed-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan



