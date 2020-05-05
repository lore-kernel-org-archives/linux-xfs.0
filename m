Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE40DC47256
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 07:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 816F12064A
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 07:02:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sZZ6oO6g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgEEHC1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 03:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgEEHC0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 03:02:26 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926D1C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 00:02:26 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id y6so620173pjc.4
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 00:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xHjOyjXjp8qr20hVuDAjgZ+Vw9zu5TpKl+To0JUQTNc=;
        b=sZZ6oO6gITNvjuOJ4gwim34Y0Ah0ovpE8aVeEdJX7wzw32Ch2BrJLf3dT8W6JHAg3w
         +B5eivDqmde/IUxULYv+5jBKvoL6KFceTMgzocfuSJa1BRhSYRSfdY8aB+7ecF4bYkYW
         zC7M667BgGpq9Iz96n71CCb0dyC+nYtigTeqwFFpeC2nHett2dxXBB+RJcUXJmfuwhh5
         jPkCSs4jXuKLT0eA8vEherzbnwN9eExr83fassDcjgA8BgvgXCnHmd0gzXx8rMS6Z1Ml
         cjwZZJwOTWDYKPMWpG+oORln2BFOuZlv+i+T2TuTg598gJWyxg6Wr0SAP/76rxW26rgT
         +3Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xHjOyjXjp8qr20hVuDAjgZ+Vw9zu5TpKl+To0JUQTNc=;
        b=PsGd69beMCKj77u/uvts9PnFcmOfI06SGN6tC2+oDOgXq8Q2Ma41QqIZKDRZlj8iyp
         G5codY4aPt8q695t0iidqwhu7p+1ryVU5mj2d6h1ZbZOPxk7/HdLH1adH7u5WNty8czY
         wAeTNy66oSUfklkoFbyqNhp5syXM9bIp+0E/gLg9VBOYCtvJHZIPWh/E4X0GWXwb1977
         z2sFdfqDqlnqt/jC2hUV0lGxbpkqLH8sue+TqxBJ6ifoYKnkUKQnr8N++G5tYEO28ASW
         8n9mTFiK/bhlzx+tvhhfAuf0m/d7TpPCya/fVnOa0Zq46pMksxn6gFllI7hbMVjJV/N5
         UWZg==
X-Gm-Message-State: AGi0PuZcALtQ5coLMeNtQ6/GiYlAq0RFg28vouBQBZSIRv+W8hl60/Xm
        ztxGs3yWYh/2xL2HJCpa3VI=
X-Google-Smtp-Source: APiQypIy3UdRnbGtj9bgQwlKC3tiR3eg0frY+yOk2yJGiBpLsZtHvVZENf4paDCvicOKZXWUgesdKA==
X-Received: by 2002:a17:90a:ba84:: with SMTP id t4mr1222033pjr.81.1588662145769;
        Tue, 05 May 2020 00:02:25 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id r26sm1104522pfq.75.2020.05.05.00.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 00:02:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/28] xfs: refactor log recovery RUI item dispatch for pass2 commit functions
Date:   Tue, 05 May 2020 12:32:22 +0530
Message-ID: <3174700.nBGGL47d3n@garuda>
In-Reply-To: <158864109518.182683.10374774193978011328.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864109518.182683.10374774193978011328.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:41:35 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the rmap update intent and intent-done pass2 commit code into the
> per-item source code files and use dispatch functions to call them.  We
> do these one at a time because there's a lot of code to move.  No
> functional changes.
>

RUI/RUD item pass2 processing is functionally consistent with what was done
before this patch is applied.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log_recover.c |   97 -------------------------------------------
>  fs/xfs/xfs_rmap_item.c   |  104 +++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_rmap_item.h   |    4 --
>  3 files changed, 101 insertions(+), 104 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index d7c5f75cf992..0c0ce7bfc30e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2034,99 +2034,6 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> -/*
> - * This routine is called to create an in-core extent rmap update
> - * item from the rui format structure which was logged on disk.
> - * It allocates an in-core rui, copies the extents from the format
> - * structure into it, and adds the rui to the AIL with the given
> - * LSN.
> - */
> -STATIC int
> -xlog_recover_rui_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item,
> -	xfs_lsn_t			lsn)
> -{
> -	int				error;
> -	struct xfs_mount		*mp = log->l_mp;
> -	struct xfs_rui_log_item		*ruip;
> -	struct xfs_rui_log_format	*rui_formatp;
> -
> -	rui_formatp = item->ri_buf[0].i_addr;
> -
> -	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
> -	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
> -	if (error) {
> -		xfs_rui_item_free(ruip);
> -		return error;
> -	}
> -	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
> -
> -	spin_lock(&log->l_ailp->ail_lock);
> -	/*
> -	 * The RUI has two references. One for the RUD and one for RUI to ensure
> -	 * it makes it into the AIL. Insert the RUI into the AIL directly and
> -	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
> -	 * AIL lock.
> -	 */
> -	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
> -	xfs_rui_release(ruip);
> -	return 0;
> -}
> -
> -
> -/*
> - * This routine is called when an RUD format structure is found in a committed
> - * transaction in the log. Its purpose is to cancel the corresponding RUI if it
> - * was still in the log. To do this it searches the AIL for the RUI with an id
> - * equal to that in the RUD format structure. If we find it we drop the RUD
> - * reference, which removes the RUI from the AIL and frees it.
> - */
> -STATIC int
> -xlog_recover_rud_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item)
> -{
> -	struct xfs_rud_log_format	*rud_formatp;
> -	struct xfs_rui_log_item		*ruip = NULL;
> -	struct xfs_log_item		*lip;
> -	uint64_t			rui_id;
> -	struct xfs_ail_cursor		cur;
> -	struct xfs_ail			*ailp = log->l_ailp;
> -
> -	rud_formatp = item->ri_buf[0].i_addr;
> -	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
> -	rui_id = rud_formatp->rud_rui_id;
> -
> -	/*
> -	 * Search for the RUI with the id in the RUD format structure in the
> -	 * AIL.
> -	 */
> -	spin_lock(&ailp->ail_lock);
> -	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> -	while (lip != NULL) {
> -		if (lip->li_type == XFS_LI_RUI) {
> -			ruip = (struct xfs_rui_log_item *)lip;
> -			if (ruip->rui_format.rui_id == rui_id) {
> -				/*
> -				 * Drop the RUD reference to the RUI. This
> -				 * removes the RUI from the AIL and frees it.
> -				 */
> -				spin_unlock(&ailp->ail_lock);
> -				xfs_rui_release(ruip);
> -				spin_lock(&ailp->ail_lock);
> -				break;
> -			}
> -		}
> -		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> -	}
> -
> -	xfs_trans_ail_cursor_done(&cur);
> -	spin_unlock(&ailp->ail_lock);
> -
> -	return 0;
> -}
> -
>  /*
>   * Copy an CUI format buffer from the given buf, and into the destination
>   * CUI format structure.  The CUI/CUD items were designed not to need any
> @@ -2385,10 +2292,6 @@ xlog_recover_commit_pass2(
>  				trans->r_lsn);
>  
>  	switch (ITEM_TYPE(item)) {
> -	case XFS_LI_RUI:
> -		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
> -	case XFS_LI_RUD:
> -		return xlog_recover_rud_pass2(log, item);
>  	case XFS_LI_CUI:
>  		return xlog_recover_cui_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_CUD:
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 3eb538674cb9..c87f4e429c12 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -18,6 +18,7 @@
>  #include "xfs_log.h"
>  #include "xfs_rmap.h"
>  #include "xfs_error.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_rui_zone;
> @@ -28,7 +29,7 @@ static inline struct xfs_rui_log_item *RUI_ITEM(struct xfs_log_item *lip)
>  	return container_of(lip, struct xfs_rui_log_item, rui_item);
>  }
>  
> -void
> +STATIC void
>  xfs_rui_item_free(
>  	struct xfs_rui_log_item	*ruip)
>  {
> @@ -133,7 +134,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
>  /*
>   * Allocate and initialize an rui item with the given number of extents.
>   */
> -struct xfs_rui_log_item *
> +STATIC struct xfs_rui_log_item *
>  xfs_rui_init(
>  	struct xfs_mount		*mp,
>  	uint				nextents)
> @@ -161,7 +162,7 @@ xfs_rui_init(
>   * RUI format structure.  The RUI/RUD items were designed not to need any
>   * special alignment handling.
>   */
> -int
> +STATIC int
>  xfs_rui_copy_format(
>  	struct xfs_log_iovec		*buf,
>  	struct xfs_rui_log_format	*dst_rui_fmt)
> @@ -587,10 +588,107 @@ xfs_rui_recover(
>  	return error;
>  }
>  
> +/*
> + * This routine is called to create an in-core extent rmap update
> + * item from the rui format structure which was logged on disk.
> + * It allocates an in-core rui, copies the extents from the format
> + * structure into it, and adds the rui to the AIL with the given
> + * LSN.
> + */
> +STATIC int
> +xlog_recover_rmap_intent_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	int				error;
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_rui_log_item		*ruip;
> +	struct xfs_rui_log_format	*rui_formatp;
> +
> +	rui_formatp = item->ri_buf[0].i_addr;
> +
> +	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
> +	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
> +	if (error) {
> +		xfs_rui_item_free(ruip);
> +		return error;
> +	}
> +	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
> +
> +	spin_lock(&log->l_ailp->ail_lock);
> +	/*
> +	 * The RUI has two references. One for the RUD and one for RUI to ensure
> +	 * it makes it into the AIL. Insert the RUI into the AIL directly and
> +	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
> +	 * AIL lock.
> +	 */
> +	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
> +	xfs_rui_release(ruip);
> +	return 0;
> +}
> +
>  const struct xlog_recover_item_ops xlog_rmap_intent_item_ops = {
>  	.item_type		= XFS_LI_RUI,
> +	.commit_pass2		= xlog_recover_rmap_intent_commit_pass2,
>  };
>  
> +/*
> + * This routine is called when an RUD format structure is found in a committed
> + * transaction in the log. Its purpose is to cancel the corresponding RUI if it
> + * was still in the log. To do this it searches the AIL for the RUI with an id
> + * equal to that in the RUD format structure. If we find it we drop the RUD
> + * reference, which removes the RUI from the AIL and frees it.
> + */
> +STATIC int
> +xlog_recover_rmap_done_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_rud_log_format	*rud_formatp;
> +	struct xfs_rui_log_item		*ruip = NULL;
> +	struct xfs_log_item		*lip;
> +	uint64_t			rui_id;
> +	struct xfs_ail_cursor		cur;
> +	struct xfs_ail			*ailp = log->l_ailp;
> +
> +	rud_formatp = item->ri_buf[0].i_addr;
> +	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
> +	rui_id = rud_formatp->rud_rui_id;
> +
> +	/*
> +	 * Search for the RUI with the id in the RUD format structure in the
> +	 * AIL.
> +	 */
> +	spin_lock(&ailp->ail_lock);
> +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	while (lip != NULL) {
> +		if (lip->li_type == XFS_LI_RUI) {
> +			ruip = (struct xfs_rui_log_item *)lip;
> +			if (ruip->rui_format.rui_id == rui_id) {
> +				/*
> +				 * Drop the RUD reference to the RUI. This
> +				 * removes the RUI from the AIL and frees it.
> +				 */
> +				spin_unlock(&ailp->ail_lock);
> +				xfs_rui_release(ruip);
> +				spin_lock(&ailp->ail_lock);
> +				break;
> +			}
> +		}
> +		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> +	}
> +
> +	xfs_trans_ail_cursor_done(&cur);
> +	spin_unlock(&ailp->ail_lock);
> +
> +	return 0;
> +}
> +
>  const struct xlog_recover_item_ops xlog_rmap_done_item_ops = {
>  	.item_type		= XFS_LI_RUD,
> +	.commit_pass2		= xlog_recover_rmap_done_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
> index 8708e4a5aa5c..89bd192779f8 100644
> --- a/fs/xfs/xfs_rmap_item.h
> +++ b/fs/xfs/xfs_rmap_item.h
> @@ -77,10 +77,6 @@ struct xfs_rud_log_item {
>  extern struct kmem_zone	*xfs_rui_zone;
>  extern struct kmem_zone	*xfs_rud_zone;
>  
> -struct xfs_rui_log_item *xfs_rui_init(struct xfs_mount *, uint);
> -int xfs_rui_copy_format(struct xfs_log_iovec *buf,
> -		struct xfs_rui_log_format *dst_rui_fmt);
> -void xfs_rui_item_free(struct xfs_rui_log_item *);
>  void xfs_rui_release(struct xfs_rui_log_item *);
>  int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
>  
> 
> 


-- 
chandan



