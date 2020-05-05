Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D60C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2305B206A4
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rExvH0P2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgEEJtx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 05:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEEJtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 05:49:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B14C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 02:49:53 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 7so989553pjo.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 02:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w7j/KOIDGHx90TVVXeU6IO78N2eZ2NuXVBhifws9vms=;
        b=rExvH0P2pXGQCsFIpKDASJMq0ssuawiflqIzB0h4Uat/5ztQ0PWs+lJ4BWqoe13mbO
         AqSLu+ztYfus+jSBWR3tL7LX1G1p3yJztoaeCzKTFc4x7Uh1Hh1HDsxzIYJroLykSJhY
         qPrf5TP+OWIfKelzkidyGJ99OD6Y/5wNVasJB0uIfOeThHWInBurctf8C0eFVOh6aF7q
         SLU8cpBD1tQu3pZMbi3NpPRlxxZJIBUa6GyGL303VQKzHUJOi4Z8681vyMlG+a35H9Jl
         mY/epm1e+BiDa/Q5TsOT8dOoPOdrGwvDbHlX1YBW/JLGQNgeoEnQFFHL58h8O7VRSmUW
         Llkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w7j/KOIDGHx90TVVXeU6IO78N2eZ2NuXVBhifws9vms=;
        b=oqpJfVjP3ZXRLd6hjxD4EU9iL6mVXZdryXg1TLeN0PrSxYI9twXMpX52n2oQ/nr/C/
         qhta+Y7WrvRYQXkmDx4bE9SCdsBEjzUck7cdfCo/7Pjl0ocjfpi7cZPVWV5zCrWzGlj3
         o4ahu/N7BTKSmktPrhnUvPKsLUqkIaZRJCeRTGhsNqYMHQzbs/HSJUp3Ye258MjPLkP+
         DbFQwTMfjJVN+p81KgIySB2KEmbZDHt2T8pxMxAh1zRoncvet+yH0l6gdQlTo7CdLf5c
         CMp8s0SUIxTrXxLrsrA5yVE0j9+fW2V1Tp8NQu2ZN4fdWFIrp71q0JFvLJh8zrdkouYf
         vaDQ==
X-Gm-Message-State: AGi0PuZ3ssmp7pwmSwSdyuvBsfiHPGmc95FamEZQtQ2+yyRytSG0G9pS
        BZbQlcLOsYnOJvXn0Ezx218yqtg7XGw=
X-Google-Smtp-Source: APiQypKsG18KdTcCVlgx5r+p5OVFEGWT+KZaSeE/8/nJ2gRKn/TxDrPru30CEFztJpfnRFHPhIPgqw==
X-Received: by 2002:a17:902:108:: with SMTP id 8mr2407439plb.200.1588672192821;
        Tue, 05 May 2020 02:49:52 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id z25sm1551811pfa.213.2020.05.05.02.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 02:49:52 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/28] xfs: refactor recovered BUI log item playback
Date:   Tue, 05 May 2020 15:19:49 +0530
Message-ID: <1736184.xRe78XWrJr@garuda>
In-Reply-To: <158864114272.182683.11138860973756666002.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864114272.182683.11138860973756666002.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:42:22 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the code that processes the log items created from the recovered
> log items into the per-item source code files and use dispatch functions
> to call them.  No functional changes.
>

BUI log item playback is consistent with what was done before the patch is
applied.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c   |   44 ++++++++++++++++++----
>  fs/xfs/xfs_bmap_item.h   |    3 --
>  fs/xfs/xfs_log_recover.c |   91 ++++++----------------------------------------
>  3 files changed, 47 insertions(+), 91 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 0fbebef69e26..f88ebf8634c4 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -28,6 +28,8 @@
>  kmem_zone_t	*xfs_bui_zone;
>  kmem_zone_t	*xfs_bud_zone;
>  
> +static const struct xfs_item_ops xfs_bui_item_ops;
> +
>  static inline struct xfs_bui_log_item *BUI_ITEM(struct xfs_log_item *lip)
>  {
>  	return container_of(lip, struct xfs_bui_log_item, bui_item);
> @@ -47,7 +49,7 @@ xfs_bui_item_free(
>   * committed vs unpin operations in bulk insert operations. Hence the reference
>   * count to ensure only the last caller frees the BUI.
>   */
> -void
> +STATIC void
>  xfs_bui_release(
>  	struct xfs_bui_log_item	*buip)
>  {
> @@ -126,13 +128,6 @@ xfs_bui_item_release(
>  	xfs_bui_release(BUI_ITEM(lip));
>  }
>  
> -static const struct xfs_item_ops xfs_bui_item_ops = {
> -	.iop_size	= xfs_bui_item_size,
> -	.iop_format	= xfs_bui_item_format,
> -	.iop_unpin	= xfs_bui_item_unpin,
> -	.iop_release	= xfs_bui_item_release,
> -};
> -
>  /*
>   * Allocate and initialize an bui item with the given number of extents.
>   */
> @@ -425,7 +420,7 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
>   * Process a bmap update intent item that was recovered from the log.
>   * We need to update some inode's bmbt.
>   */
> -int
> +STATIC int
>  xfs_bui_recover(
>  	struct xfs_trans		*parent_tp,
>  	struct xfs_bui_log_item		*buip)
> @@ -560,6 +555,37 @@ xfs_bui_recover(
>  	return error;
>  }
>  
> +/* Recover the BUI if necessary. */
> +STATIC int
> +xfs_bui_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_ail			*ailp = lip->li_ailp;
> +	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
> +	int				error;
> +
> +	/*
> +	 * Skip BUIs that we've already processed.
> +	 */
> +	if (test_bit(XFS_BUI_RECOVERED, &buip->bui_flags))
> +		return 0;
> +
> +	spin_unlock(&ailp->ail_lock);
> +	error = xfs_bui_recover(tp, buip);
> +	spin_lock(&ailp->ail_lock);
> +
> +	return error;
> +}
> +
> +static const struct xfs_item_ops xfs_bui_item_ops = {
> +	.iop_size	= xfs_bui_item_size,
> +	.iop_format	= xfs_bui_item_format,
> +	.iop_unpin	= xfs_bui_item_unpin,
> +	.iop_release	= xfs_bui_item_release,
> +	.iop_recover	= xfs_bui_item_recover,
> +};
> +
>  /*
>   * Copy an BUI format buffer from the given buf, and into the destination
>   * BUI format structure.  The BUI/BUD items were designed not to need any
> diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
> index 515b1d5d6ab7..44d06e62f8f9 100644
> --- a/fs/xfs/xfs_bmap_item.h
> +++ b/fs/xfs/xfs_bmap_item.h
> @@ -74,7 +74,4 @@ struct xfs_bud_log_item {
>  extern struct kmem_zone	*xfs_bui_zone;
>  extern struct kmem_zone	*xfs_bud_zone;
>  
> -void xfs_bui_release(struct xfs_bui_log_item *);
> -int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
> -
>  #endif	/* __XFS_BMAP_ITEM_H__ */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ad5ac97ed0c7..20ee32c2652d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2553,60 +2553,6 @@ xlog_recover_process_data(
>  	return 0;
>  }
>  
> -/* Recover the BUI if necessary. */
> -STATIC int
> -xlog_recover_process_bui(
> -	struct xfs_trans		*parent_tp,
> -	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip)
> -{
> -	struct xfs_bui_log_item		*buip;
> -	int				error;
> -
> -	/*
> -	 * Skip BUIs that we've already processed.
> -	 */
> -	buip = container_of(lip, struct xfs_bui_log_item, bui_item);
> -	if (test_bit(XFS_BUI_RECOVERED, &buip->bui_flags))
> -		return 0;
> -
> -	spin_unlock(&ailp->ail_lock);
> -	error = xfs_bui_recover(parent_tp, buip);
> -	spin_lock(&ailp->ail_lock);
> -
> -	return error;
> -}
> -
> -/* Release the BUI since we're cancelling everything. */
> -STATIC void
> -xlog_recover_cancel_bui(
> -	struct xfs_mount		*mp,
> -	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip)
> -{
> -	struct xfs_bui_log_item		*buip;
> -
> -	buip = container_of(lip, struct xfs_bui_log_item, bui_item);
> -
> -	spin_unlock(&ailp->ail_lock);
> -	xfs_bui_release(buip);
> -	spin_lock(&ailp->ail_lock);
> -}
> -
> -/* Is this log item a deferred action intent? */
> -static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
> -{
> -	switch (lip->li_type) {
> -	case XFS_LI_EFI:
> -	case XFS_LI_RUI:
> -	case XFS_LI_CUI:
> -	case XFS_LI_BUI:
> -		return true;
> -	default:
> -		return false;
> -	}
> -}
> -
>  /* Take all the collected deferred ops and finish them in order. */
>  static int
>  xlog_finish_defer_ops(
> @@ -2641,6 +2587,12 @@ xlog_finish_defer_ops(
>  	return xfs_trans_commit(tp);
>  }
>  
> +/* Is this log item a deferred action intent? */
> +static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
> +{
> +	return lip->li_ops->iop_recover != NULL;
> +}
> +
>  /*
>   * When this is called, all of the log intent items which did not have
>   * corresponding log done items should be in the AIL.  What we do now
> @@ -2711,20 +2663,11 @@ xlog_recover_process_intents(
>  
>  		/*
>  		 * NOTE: If your intent processing routine can create more
> -		 * deferred ops, you /must/ attach them to the dfops in this
> -		 * routine or else those subsequent intents will get
> +		 * deferred ops, you /must/ attach them to the transaction in
> +		 * this routine or else those subsequent intents will get
>  		 * replayed in the wrong order!
>  		 */
> -		switch (lip->li_type) {
> -		case XFS_LI_EFI:
> -		case XFS_LI_RUI:
> -		case XFS_LI_CUI:
> -			error = lip->li_ops->iop_recover(lip, parent_tp);
> -			break;
> -		case XFS_LI_BUI:
> -			error = xlog_recover_process_bui(parent_tp, ailp, lip);
> -			break;
> -		}
> +		error = lip->li_ops->iop_recover(lip, parent_tp);
>  		if (error)
>  			goto out;
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> @@ -2767,19 +2710,9 @@ xlog_recover_cancel_intents(
>  			break;
>  		}
>  
> -		switch (lip->li_type) {
> -		case XFS_LI_EFI:
> -		case XFS_LI_RUI:
> -		case XFS_LI_CUI:
> -			spin_unlock(&ailp->ail_lock);
> -			lip->li_ops->iop_release(lip);
> -			spin_lock(&ailp->ail_lock);
> -			break;
> -		case XFS_LI_BUI:
> -			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
> -			break;
> -		}
> -
> +		spin_unlock(&ailp->ail_lock);
> +		lip->li_ops->iop_release(lip);
> +		spin_lock(&ailp->ail_lock);
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
>  	}
>  
> 
> 


-- 
chandan



