Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47277EB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Jun 2023 21:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjFUVyj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 17:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjFUVyj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 17:54:39 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ADF1989
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 14:54:27 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-39eab4bcee8so3983269b6e.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 14:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687384467; x=1689976467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L6bw2fpHizSpDCtxTF1r7lZnT7ZL6iFZaiRFqmMlFyw=;
        b=zDh3tql2n7AGRtEWGetIbZ3wsi15YM02kay+5k0Rg0kz2xownNP/qkTpwnDGVW75pN
         eQkNy+1UqBMrdSGZQDGBcWsMyDPiQVM5xVREpPVR7dVTwO+LaJjOQ9QAkhInMYcUdjIu
         swfOrPCn7rQzaCDLQsQ0ft4Bcu7N867a/StwYVRarDNA40olvOwKSnFAJsgesPlY/QrE
         A+QgHGRyLHI/Pbqyo0Fr39crPwBw1l0NBsR6P1QE1t7iM5iFE9YeElc6EAfaGLe3O+My
         5le+G+FiZX7jaagkWic2nYQ2EdG/DjS3QjXJrgRv/U/t7N4nn3M906s0CQBwUoeBItXP
         WLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687384467; x=1689976467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L6bw2fpHizSpDCtxTF1r7lZnT7ZL6iFZaiRFqmMlFyw=;
        b=J/SGPC1F63FWDVM5N4vO94pMJ4bZKpXMTu0bnK+4EH3yFgOpsK4JUHuaxlGM9OGxIJ
         kWQ/jLhYrvs549BiSJzIFS8VNVgu2ylncwmzN9nxdbTj9yaJdAfTutnBRdxa9bCRam+F
         SiPWPy46rfd8hel5vbuw5c8zmuMlUwVe5dq8mWU6AK2UT0T1ouKI6BIPRkoovBzO7JhH
         2mdr1M1qSMbQVM8VzUxfdRB7HS/n+dhN+9jixTnoiFhqjwpBtTwMmqaL8VTRs2t+L/ay
         jKL2cNnxY9SOOIzEkpxZILJI2VEobOuwob0AB6HcOpRzFt1oszENkIY1snhv0ugsEq1p
         ijzw==
X-Gm-Message-State: AC+VfDxEgW/azFCdFqSeK+fUK71PhLj5JxXaJwQBD/C+bWwcFun+uG6z
        vJ6PgXB4OWy5DcwB8srZWHZrjQ==
X-Google-Smtp-Source: ACHHUZ77I9N7UsBVLp8zsDNL4ASGtlJixyrE9gPYQW7w9Kr/+/6QXsZxT613zrsCc4q9ECgkjagcEw==
X-Received: by 2002:a54:4585:0:b0:394:4642:7148 with SMTP id z5-20020a544585000000b0039446427148mr16557583oib.48.1687384466967;
        Wed, 21 Jun 2023 14:54:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id x18-20020a17090abc9200b002533ce5b261sm9406432pjr.10.2023.06.21.14.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 14:54:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qC5mR-00EbTg-0l;
        Thu, 22 Jun 2023 07:54:23 +1000
Date:   Thu, 22 Jun 2023 07:54:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     cem@kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, louhongxiang@huawei.com,
        liuzhiqiang26@huawei.com
Subject: Re: [PATCH] mkfs.xfs: fix segmentation fault caused by accessing a
 null pointer
Message-ID: <ZJNxj+Tm0cIDKaAR@dread.disaster.area>
References: <48402a8a-95db-f7b5-196e-32f3b4b2bf4e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48402a8a-95db-f7b5-196e-32f3b4b2bf4e@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 21, 2023 at 05:25:27PM +0800, Wu Guanghao wrote:
> We encountered a segfault while testing the mkfs.xfs + iscsi.
> 
> (gdb) bt
> #0 libxfs_log_sb (tp=0xaaaafaea0630) at xfs_sb.c:810
> #1 0x0000aaaaca991468 in __xfs_trans_commit (tp=<optimized out>, tp@entry=0xaaaafaea0630, regrant=regrant@entry=true) at trans.c:995
> #2 0x0000aaaaca991790 in libxfs_trans_roll (tpp=tpp@entry=0xfffffe1f3018) at trans.c:103
> #3 0x0000aaaaca9bcde8 in xfs_dialloc_roll (agibp=0xaaaafaea2fa0, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1561
> #4 xfs_dialloc_try_ag (ok_alloc=true, new_ino=<synthetic pointer>, parent=0, pag=0xaaaafaea0210, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1698
> #5 xfs_dialloc (tpp=tpp@entry=0xfffffe1f31c8, parent=0, mode=mode@entry=16877, new_ino=new_ino@entry=0xfffffe1f3128) at xfs_ialloc.c:1776
> #6 0x0000aaaaca9925b0 in libxfs_dir_ialloc (tpp=tpp@entry=0xfffffe1f31c8, dp=dp@entry=0x0, mode=mode@entry=16877, nlink=nlink@entry=1, rdev=rdev@entry=0, cr=cr@entry=0xfffffe1f31d0,
>     fsx=fsx@entry=0xfffffe1f36a4, ipp=ipp@entry=0xfffffe1f31c0) at util.c:525
> #7 0x0000aaaaca988fac in parseproto (mp=0xfffffe1f36c8, pip=0x0, fsxp=0xfffffe1f36a4, pp=0xfffffe1f3370, name=0x0) at proto.c:552
> #8 0x0000aaaaca9867a4 in main (argc=<optimized out>, argv=<optimized out>) at xfs_mkfs.c:4217
> 
> (gdb) p bp
> $1 = 0x0
> 
> ```
> void
> xfs_log_sb(
>         struct xfs_trans        *tp)
> {
>         // iscsi offline
>         ...
>         // failed to read sb, bp = NULL
>         struct xfs_buf          *bp = xfs_trans_getsb(tp);
>         ...
> }
> ```
> 
> When writing data to sb, if the device is abnormal at this time,
> the bp may be empty. Using it without checking will result in
> a segfault.

xfs_trans_getsb() is not supposed to fail. In the kernel code (which
this is a copy of) it can't fail because the superblock buffer is
always pinned in memory at mount time and so is *never read from the
storage* after mount.

Hence something similar needs to be in userspace with libxfs_getsb()
so that the superblock is only read when setting up the initial
mount state in libxfs....

> diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
> index 6cac2531..73079df1 100644
> --- a/libxfs/xfs_attr_leaf.c
> +++ b/libxfs/xfs_attr_leaf.c
> @@ -668,7 +668,7 @@ xfs_sbversion_add_attr2(
>         spin_lock(&mp->m_sb_lock);
>         xfs_add_attr2(mp);
>         spin_unlock(&mp->m_sb_lock);
> -       xfs_log_sb(tp);
> +       ASSERT(!xfs_log_sb(tp));

FWIW, that's never a valid conversion nor a valid way to handle
something that can fail. That turns the code into code that is only
executed on debug builds, and it will panic the debug build rather
than handle the error.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
