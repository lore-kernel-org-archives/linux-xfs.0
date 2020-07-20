Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE7BC433E4
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 05:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CA1B21775
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 05:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EUg8pA7U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgGTFid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 01:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGTFid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 01:38:33 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42638C0619D2
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2020 22:38:33 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so9628542pje.0
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2020 22:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5V/ccJ0QWicIjnpCSXrFuUIvhDQbSqp+jRyNCcabuK0=;
        b=EUg8pA7UG03/zMFblxBvvHHXxM0PTIAxcDK7+AAF3NCaMSMFUrTS1Hmq6WOiaucTN7
         VkReX0mxkeyydCdcJ2eWYdvPfq4im1DW6HynwzXQ7fDTHHMEQhi0NQ3kNrBRkaVoAiZw
         uZ8AtTuLInweUdix1U46V3oeyq0ZMjH4WLmwyZQgncl4FQlOx9rRAjuW5MDciSeDXCHn
         mHHza09l43bgaPltii40vPxRe+60yyvQTovVFPAOXffonmj6JSXJvGcIWj+IZg2mAeMJ
         1MgV1brY/F+obOO9JsPYhWYHwhZRTMDNGxFNSGfDJJ6K3uOtuAU94JfhJV+jKEg0Gdkl
         Tb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5V/ccJ0QWicIjnpCSXrFuUIvhDQbSqp+jRyNCcabuK0=;
        b=oIELdRg69zjghUEbgx+ZpuWbspAjn2rRW2x+AC5CSSh8R9CYIp6+VakD59QJQ9VRBu
         V/bweVGz04mHwiPWtGFQb4LEQyht7az1lfdqKiYBj/lTrg+AyPFLVxv54NnWBdSHGCFo
         2lVfdZlHYBuRltZpEcY0iRzTb1sOi2ifa/6XNhhQmpria6vdtb54OpGOrPuu1miAeu/i
         adg7JDuo+7XtYQL0NEUn6eIGkre6VQpZsP/KgJi2Yew8PpxK2rqJp5nSAKDlseEvrZhR
         Tm08JaQ2+5LrGqDHc/yvxz1IHGlHWsgwkW9so1h8lVwKAoRKDbLXg0Qoq+3WfjSk3XLJ
         KNfQ==
X-Gm-Message-State: AOAM531Ww0roSieNlZeavwLYDi+qc2MEuAEFmJb2SKYf4cBk/p9xm6En
        uFB/i+Ev13UZJvzdjlpYIvh6iCTp
X-Google-Smtp-Source: ABdhPJwL9vOw/kRYlC3cixM82CRXEaMgDtB94tn/w3zaFBX3bnAQ4fvL8MkCOXEjOQEJgz1mx0M3iA==
X-Received: by 2002:a17:902:7281:: with SMTP id d1mr14269120pll.247.1595223512800;
        Sun, 19 Jul 2020 22:38:32 -0700 (PDT)
Received: from garuda.localnet ([122.171.166.148])
        by smtp.gmail.com with ESMTPSA id a16sm14198606pgj.27.2020.07.19.22.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 22:38:32 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/26] xfs: make XFS_DQUOT_CLUSTER_SIZE_FSB part of the ondisk format
Date:   Mon, 20 Jul 2020 11:07:45 +0530
Message-ID: <1785002.aZXFcyIeaH@garuda>
In-Reply-To: <159477789339.3263162.3626376647868941894.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia> <159477789339.3263162.3626376647868941894.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 15 July 2020 7:21:33 AM IST Darrick xJ. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the dquot cluster size #define to xfs_format.h.  It is an important
> part of the ondisk format because the ondisk dquot record size is not an
> even power of two, which means that the buffer size we use is
> significant here because the kernel leaves slack space at the end of the
> buffer to avoid having to deal with a dquot record crossing a block
> boundary.
> 
> This is also an excuse to fix one of the longstanding discrepancies
> between kernel and userspace libxfs headers.

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h |   16 ++++++++++++++++
>  fs/xfs/xfs_qm.h            |   11 -----------
>  2 files changed, 16 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 79fbabeb476c..76d34b77031a 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1209,6 +1209,22 @@ typedef struct xfs_dqblk {
>  
>  #define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
>  
> +/*
> + * This defines the unit of allocation of dquots.
> + *
> + * Currently, it is just one file system block, and a 4K blk contains 30
> + * (136 * 30 = 4080) dquots. It's probably not worth trying to make
> + * this more dynamic.
> + *
> + * However, if this number is changed, we have to make sure that we don't
> + * implicitly assume that we do allocations in chunks of a single filesystem
> + * block in the dquot/xqm code.
> + *
> + * This is part of the ondisk format because the structure size is not a power
> + * of two, which leaves slack at the end of the disk block.
> + */
> +#define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
> +
>  /*
>   * Remote symlink format and access functions.
>   */
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 27789272da95..c5d0716b378e 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -30,17 +30,6 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>  	!dqp->q_core.d_rtbcount && \
>  	!dqp->q_core.d_icount)
>  
> -/*
> - * This defines the unit of allocation of dquots.
> - * Currently, it is just one file system block, and a 4K blk contains 30
> - * (136 * 30 = 4080) dquots. It's probably not worth trying to make
> - * this more dynamic.
> - * XXXsup However, if this number is changed, we have to make sure that we don't
> - * implicitly assume that we do allocations in chunks of a single filesystem
> - * block in the dquot/xqm code.
> - */
> -#define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
> -
>  /* Defaults for each quota type: time limits, warn limits, usage limits */
>  struct xfs_def_quota {
>  	time64_t	btimelimit;	/* limit for blks timer */
> 
> 


-- 
chandan



