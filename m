Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1581C4346E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 04:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D1AD238D6
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 04:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EJ///leN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIXEoW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 00:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXEoW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 00:44:22 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612FFC0613CE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 21:44:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q12so980089plr.12
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 21:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yVFBzFYmFQnFysAZik6jAA7hf4IlZo90CxAWu4Foats=;
        b=EJ///leN3ZVtTUeKmxfQNbn8dsz9fmscm7QbQPgtJvb9QERLGXia0Wlj7gcK2+F1SN
         TjVfv84ZA5LgjaoiJJqU46erkUhifvyH+BYtsjhYHwrthcZlkXnd5TC0PmIorRm87+C9
         C49cukDil5SMpGWlvG9KKBvOJWdxNi80Yrip7aPX+N+sIP+e0wS5xqrcAof4eX449cc0
         giw3b0SNdRz/HrkteUIGDwkBg5F9xoa6aDw+wV+l5gRYWiNlOPYcbszozGiX+HfXCLXD
         0Keiveg4YeNDw19pAb+DzKRq1NpYF6LnfbthFCVjr6w/Hf9QbQ3Hc6GyPOm8x56ElrId
         fSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yVFBzFYmFQnFysAZik6jAA7hf4IlZo90CxAWu4Foats=;
        b=eGWeC0GZKfxoQ3uGR0T8D28zECIIvZMaDNNAypvRL0sNyKQr4L7yHuzlYLFcxADHEl
         uF+ybikqXD/Iy3Kkgn2+5PIeehAqc0WDk63nAliZOXZJcWqJ/mpveVkmb/tDIS2H2bHt
         Z9oQLO+5w6LT/nUHRyvH7ADyayOggI52mNc+KosH46R7qo3PUjEKdMJ5bCg0HBkOME+U
         B+QAs5D1SrGUATf5eBM7YwUn9VoiMwZ0QHjhpbLnpxzjds0IXm+lw/H5v7JIbTqkHZ95
         gtE1HyfAOCGkQSqI6oOgBPP9JeeI2NF3wtFsT4oU1xCh/2ZHJIf1OqY/C0rfrKds3rn6
         7EyQ==
X-Gm-Message-State: AOAM533u5rmBk4BbUiYh3h8d4+kM8eduyZ5Eownu/rRPrnB1Alc3wfir
        LlOGmzzXkczZLyNFdtMIyH8uUUc0W6o=
X-Google-Smtp-Source: ABdhPJy/nVqBYcdARZmv2lm1C1jXULn3ymvPOMAG7x+hYGlvtyrpDPwen4h8a8dGYdZy9GSuxUWJYA==
X-Received: by 2002:a17:902:8347:b029:d1:f365:6fb5 with SMTP id z7-20020a1709028347b02900d1f3656fb5mr2822897pln.61.1600922660456;
        Wed, 23 Sep 2020 21:44:20 -0700 (PDT)
Received: from garuda.localnet ([122.171.52.9])
        by smtp.gmail.com with ESMTPSA id v6sm1181517pfi.38.2020.09.23.21.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 21:44:19 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid shared rmap operations for attr fork extents
Date:   Thu, 24 Sep 2020 10:14:13 +0530
Message-ID: <20014204.GQ1xNvM1QS@garuda>
In-Reply-To: <20200923182340.GV7955@magnolia>
References: <20200923182340.GV7955@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 23 September 2020 11:53:40 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During code review, I noticed that the rmap code uses the (slower)
> shared mappings rmap functions for any extent of a reflinked file, even
> if those extents are for the attr fork, which doesn't support sharing.
> We can speed up rmap a tiny bit by optimizing out this case.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> ---
>  fs/xfs/libxfs/xfs_rmap.c |   27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 27c39268c31f..340c83f76c80 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2505,12 +2505,15 @@ xfs_rmap_map_extent(
>  	int			whichfork,
>  	struct xfs_bmbt_irec	*PREV)
>  {
> +	enum xfs_rmap_intent_type type = XFS_RMAP_MAP;
> +
>  	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
>  		return;
>  
> -	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
> -			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
> -			whichfork, PREV);
> +	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
> +		type = XFS_RMAP_MAP_SHARED;
> +
> +	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
>  }
>  
>  /* Unmap an extent out of a file. */
> @@ -2521,12 +2524,15 @@ xfs_rmap_unmap_extent(
>  	int			whichfork,
>  	struct xfs_bmbt_irec	*PREV)
>  {
> +	enum xfs_rmap_intent_type type = XFS_RMAP_UNMAP;
> +
>  	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
>  		return;
>  
> -	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
> -			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
> -			whichfork, PREV);
> +	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
> +		type = XFS_RMAP_UNMAP_SHARED;
> +
> +	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
>  }
>  
>  /*
> @@ -2543,12 +2549,15 @@ xfs_rmap_convert_extent(
>  	int			whichfork,
>  	struct xfs_bmbt_irec	*PREV)
>  {
> +	enum xfs_rmap_intent_type type = XFS_RMAP_CONVERT;
> +
>  	if (!xfs_rmap_update_is_needed(mp, whichfork))
>  		return;
>  
> -	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
> -			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
> -			whichfork, PREV);
> +	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
> +		type = XFS_RMAP_CONVERT_SHARED;
> +
> +	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
>  }
>  
>  /* Schedule the creation of an rmap for non-file data. */
> 


-- 
chandan



