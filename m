Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2F3C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 07:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BE15207C3
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 07:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oz/8zSeR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389873AbgJMHDx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 03:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389872AbgJMHDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 03:03:52 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD225C0613D0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 00:03:52 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gv6so128863pjb.4
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 00:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8O2C2I3KOCyekE6z1NYJ2n725VChyT1f4bC5PEyMBVY=;
        b=oz/8zSeRBxQ/QNH9puy9kH88+Rf27iG39Yfc/nGEZ3O+J1rGo7LkVi9fSz856izj/5
         kNJ8SW06cH+oXHRZvZ8DlKVu23e4gjcCbEqdBQZSU35akvhOzjVDcuMs699B3VRhsdee
         hIdNWBEyiTWADQAT90UaJ5PHdnZIPE6z6w2O1lEVVeef0Ltkdi78BPmNaF+zMlt14ZxQ
         iPKxETpvIc2LpClIgWVr6gb5l14BB6ycpPhLIdiE+mdrh10mjqY6xdARgUsu2TYndl5c
         FyHhiTiO1erCYWXnfEFW/siJFIR43VA2CPuT/g62EXxbO+Ttd3mzq/83uBIImqEVOeHE
         t5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8O2C2I3KOCyekE6z1NYJ2n725VChyT1f4bC5PEyMBVY=;
        b=oaMG0cGH+t5DZwDYDNf3kyQ8MljUxY1tzPDYLjxEz55IEVM7JI14LwiP8rN2t4oe81
         mK7Qe/d/RX5f99OUzYNQ+Pehb8Sr1aNAhzwTTQexvlHeD1g1jgK6OvHM+F4eiKm0TOk4
         hyHMAs5KEy0anPie8I5xy49VcSodxIM+1Ca5k7taXQhZrwInS0gOp8SJfkLj8psKjfX8
         HzHkewglQjK+kma4IrQBAv/ohiSjSl6wU7LWVDbQd0Pa2QbFGLrucksKIsLSTOjPuKqa
         3eh2pAuIgY/xolVjDHf/x64jqY/HwNfBm+95p/F7ttxqw1vyERKLgl3mkJjtBQM6bfRC
         SoWw==
X-Gm-Message-State: AOAM530oM9gXphsQBllgAszzX5wLtEO+MBUQ42O7jHlf7gbCMCX2IA1N
        1TJcT9vSm1ZQ1Vb4/GHsFUs=
X-Google-Smtp-Source: ABdhPJw1HF8qS0ixVD6o7Y3xuz93R+uAsz/d+DzHPKUqPBmxK2zpFtwncecmXCN+fMSLWWb4ZNec3g==
X-Received: by 2002:a17:90a:ec13:: with SMTP id l19mr25125824pjy.51.1602572631807;
        Tue, 13 Oct 2020 00:03:51 -0700 (PDT)
Received: from garuda.localnet ([122.171.32.165])
        by smtp.gmail.com with ESMTPSA id s10sm10166563pji.7.2020.10.13.00.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 00:03:51 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: annotate grabbing the realtime bitmap/summary locks in growfs
Date:   Tue, 13 Oct 2020 12:33:47 +0530
Message-ID: <33389409.c8MGsxpk1H@garuda>
In-Reply-To: <160235126770.1384192.7924916439728391885.stgit@magnolia>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia> <160235126770.1384192.7924916439728391885.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 10 October 2020 11:04:27 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use XFS_ILOCK_RT{BITMAP,SUM} to annotate grabbing the rt bitmap and
> summary locks when we grow the realtime volume, just like we do most
> everywhere else.  This shuts up lockdep warnings about grabbing the
> ILOCK class of locks recursively:
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.9.0-rc4-djw #rc4 Tainted: G           O
> --------------------------------------------
> xfs_growfs/4841 is trying to acquire lock:
> ffff888035acc230 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_ilock+0xac/0x1a0 [xfs]
> 
> but task is already holding lock:
> ffff888035acedb0 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_ilock+0xac/0x1a0 [xfs]
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&xfs_nondir_ilock_class);
>   lock(&xfs_nondir_ilock_class);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
>

The changes in the patch are correct since it uses different lockdep
subclasses for rt bitmap and rt summary inodes.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_rtalloc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index f9119ba3e9d0..ede1baf31413 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1024,7 +1024,7 @@ xfs_growfs_rt(
>  		/*
>  		 * Lock out other callers by grabbing the bitmap inode lock.
>  		 */
> -		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
> +		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
>  		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
>  		/*
>  		 * Update the bitmap inode's size ondisk and incore.  We need
> @@ -1038,7 +1038,7 @@ xfs_growfs_rt(
>  		/*
>  		 * Get the summary inode into the transaction.
>  		 */
> -		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
> +		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
>  		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
>  		/*
>  		 * Update the summary inode's size.  We need to update the
> 
> 


-- 
chandan



