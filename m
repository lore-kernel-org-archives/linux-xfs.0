Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD97C433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 07:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E442173E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 07:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZtTy5PS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgJHHce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 03:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbgJHHce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 03:32:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4D0C061755
        for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2020 00:32:33 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o25so3558858pgm.0
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 00:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wT5ORfG3QXb9tTvt1D+dXHs8k6f9zLSjtV+mEONTRys=;
        b=dZtTy5PSeQhxnLzfcBK7P20E5SuH/vd6NzE3h+p6DLqfOh/gIO/4zA5bIiT7F4eCUS
         aT9JB3Kc+ZTSlYif18M0W3Zb109yq0S/VFu01ukRojKJSzIhlRYXliuzW/YoHUcVEVkX
         a3JvhZ7hX+BI4lW5gb6p2nvBEVaYV3I4DAbLW2wYaD00vCWad2QcZJ6verK26M1S22A0
         NJvjtw0XjOwn8GxJN28e/cLSlhDzRqJ7zUyklttAivFBcTrWZFojw6+0Qgu8/Od2K5Ix
         7AXOB2k0RjrbmcTn3NJrrPZ5z+jS943CVDeelQk1qKl+woCsvz8eVFXceZtskKDZNlNA
         K1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wT5ORfG3QXb9tTvt1D+dXHs8k6f9zLSjtV+mEONTRys=;
        b=q+9IxDGFnROXKbOhE6wrfMfY9jMP5O9eX0r6+MU8b+I9qHV/MavHpbSLmbzQzx+ijj
         uYEAf01riV8e+6heLIC5hYhP0eHTpJMEzJZWUB1csXJf1ViV9iGgi5NTwGkQUlfjTVlU
         wMi0tiC5WDV33K2Mtyh8VBUrw5ZTiXVapta6wVhBQYp+uMTLP3u83tzUgUrvWguDR6SJ
         AGamv02sGRJdj77cgmruWGuIZIKrKojItHa88O9Ev1dyMkWEW5rfXVbnE/7UrASgYFTa
         6Jr4ak7Jp33KbOODaCyhNRiQSdNBQw6hk6KmqR7K3l20I7PLOM4ZGgXPO0ylm9GEn1PT
         WETw==
X-Gm-Message-State: AOAM532dyidcuSFz5x9HkxoYJiXGYjghWatmmV10jN0KhVqFjYTG3fS7
        KvuOUqH1ooYkWZnbNTJkjkxQJg3e26rAEw==
X-Google-Smtp-Source: ABdhPJzRh060VDI/4xBkXXTiahMWhm2l+eqlKZhhoo32Bv2uq1O/RzcQLphD4TwRnKrEhFysx4h66w==
X-Received: by 2002:a65:5cc5:: with SMTP id b5mr6389292pgt.417.1602142352661;
        Thu, 08 Oct 2020 00:32:32 -0700 (PDT)
Received: from garuda.localnet ([122.171.164.182])
        by smtp.gmail.com with ESMTPSA id y5sm361241pgo.5.2020.10.08.00.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 00:32:32 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH 1/2] xfs: fix realtime bitmap/summary file truncation when growing rt volume
Date:   Thu, 08 Oct 2020 12:26:00 +0530
Message-ID: <2066566.8zdsQT0tCQ@garuda>
In-Reply-To: <160212936619.248573.5638028611780993013.stgit@magnolia>
References: <160212936001.248573.7813264584242634489.stgit@magnolia> <160212936619.248573.5638028611780993013.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 8 October 2020 9:26:06 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The realtime bitmap and summary files are regular files that are hidden
> away from the directory tree.  Since they're regular files, inode
> inactivation will try to purge what it thinks are speculative
> preallocations beyond the incore size of the file.  Unfortunately,
> xfs_growfs_rt forgets to update the incore size when it resizes the
> inodes, with the result that inactivating the rt inodes at unmount time
> will cause their contents to be truncated.
> 
> Fix this by updating the incore size when we change the ondisk size as
> part of updating the superblock.  Note that we don't do this when we're
> allocating blocks to the rt inodes because we actually want those blocks
> to get purged if the growfs fails.
> 
> This fixes corruption complaints from the online rtsummary checker when
> running xfs/233.  Since that test requires rmap, one can also trigger
> this by growing an rt volume, cycling the mount, and creating rt files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_rtalloc.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 9d4e33d70d2a..1c3969807fb9 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1027,10 +1027,13 @@ xfs_growfs_rt(
>  		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
>  		/*
> -		 * Update the bitmap inode's size.
> +		 * Update the bitmap inode's size ondisk and incore.  We need
> +		 * to update the incore size so that inode inactivation won't
> +		 * punch what it thinks are "posteof" blocks.
>  		 */
>  		mp->m_rbmip->i_d.di_size =
>  			nsbp->sb_rbmblocks * nsbp->sb_blocksize;
> +		i_size_write(VFS_I(mp->m_rbmip), mp->m_rbmip->i_d.di_size);
>  		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
>  		/*
>  		 * Get the summary inode into the transaction.
> @@ -1038,9 +1041,12 @@ xfs_growfs_rt(
>  		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
>  		/*
> -		 * Update the summary inode's size.
> +		 * Update the summary inode's size.  We need to update the
> +		 * incore size so that inode inactivation won't punch what it
> +		 * thinks are "posteof" blocks.
>  		 */
>  		mp->m_rsumip->i_d.di_size = nmp->m_rsumsize;
> +		i_size_write(VFS_I(mp->m_rsumip), mp->m_rsumip->i_d.di_size);
>  		xfs_trans_log_inode(tp, mp->m_rsumip, XFS_ILOG_CORE);
>  		/*
>  		 * Copy summary data from old to new sizes.
> 
> 


-- 
chandan



