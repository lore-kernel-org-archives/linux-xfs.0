Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310FCC47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0364220721
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YT3nBoGx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgEEJ3H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 05:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgEEJ3H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 05:29:07 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8232C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 02:29:05 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t9so791244pjw.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 02:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qx5u61FV/BOGCKrJ0i+vd0izGpTIGJDXXb471l6BoH4=;
        b=YT3nBoGxt282aiOc3PQoJtCDbXDW2iQ1TBeyWrSQF7yv2eGpJxTxeVb+186HHTMw86
         NTFRbimjPqvO1dbIKnDVye8hzhaxOj0bVgW6TfMlaAqsnYZpUC1mvb6AZgelmuPTeTs1
         WZThrqtLj6iTnZGcfEg/omykECrRkIrNIrxjdrvhcLfqvx+JKjdAey0ZqAGWuuDfV2DF
         paRefokEPXHLTLtbrEuICD1OiKln+l2GlgMvjOZkRV2VFwpUzLcrvxXTX5iCVORMR1fQ
         nxcJpbZGncEfm5BPN81wCX8fJEZYWc1f6OFD6U/cj7EI38BaQthczEttqvyxNIprjUTS
         8RDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qx5u61FV/BOGCKrJ0i+vd0izGpTIGJDXXb471l6BoH4=;
        b=CfB0OU8/LJMyl9LAF6YEZQI5YCgLzOxBHZ3wmdWBexOzWEeJZEwKOZgUAT4RTFqIaq
         TYijkvC6ZkFbCmwcU4DwwMQt6mBemqZi9z6M+BOqlms9zjnjM4R+HV+bJHaqi5Dor9pk
         LDqnUDva4rNAWBq+CzeBsTdTwEh1cqMr6RAxpMl5poGRMe7J3hBZ/1OlbtFZDczSxfX8
         z38H9FMMHqd+mvgcJau1IBg2Le81ld1+DZJyldde4W7UGojMqAVyQWRUOUPEW+kg0EyC
         IsQAb00wDf4ZfFhfontS7V3eoL+KF1xTMu4p4PstF0J+reizeADW1UDCIPGgHgp5G+op
         RsLg==
X-Gm-Message-State: AGi0PuZp+tbaffQXBmEwoyF1gRwGbrNoFOeMzFXvIAvdnCD3kxLDG8Wb
        reBUcQK9EaEBz7XV9KnNmlU=
X-Google-Smtp-Source: APiQypLw80DJPXP5ueJVWZo1aXqXGfIYlmyraDHPCHC/tGx43WyI/VHffmMbGfhVSqII2XXni/Fpag==
X-Received: by 2002:a17:90a:de8d:: with SMTP id n13mr1772533pjv.173.1588670945114;
        Tue, 05 May 2020 02:29:05 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id z5sm1513273pfz.109.2020.05.05.02.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 02:29:04 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/28] xfs: refactor recovered CUI log item playback
Date:   Tue, 05 May 2020 14:59:02 +0530
Message-ID: <1747593.SPgpe11F3s@garuda>
In-Reply-To: <158864113397.182683.5812513715201193839.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864113397.182683.5812513715201193839.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:42:14 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the code that processes the log items created from the recovered
> log items into the per-item source code files and use dispatch functions
> to call them.  No functional changes.
>

RUI log item playback is consistent with what was done before the patch is
applied.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log_recover.c   |   48 ++------------------------------------------
>  fs/xfs/xfs_refcount_item.c |   44 ++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_refcount_item.h |    3 ---
>  3 files changed, 37 insertions(+), 58 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index da66484acaa7..ad5ac97ed0c7 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2553,46 +2553,6 @@ xlog_recover_process_data(
>  	return 0;
>  }
>  
> -/* Recover the CUI if necessary. */
> -STATIC int
> -xlog_recover_process_cui(
> -	struct xfs_trans		*parent_tp,
> -	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip)
> -{
> -	struct xfs_cui_log_item		*cuip;
> -	int				error;
> -
> -	/*
> -	 * Skip CUIs that we've already processed.
> -	 */
> -	cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
> -	if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags))
> -		return 0;
> -
> -	spin_unlock(&ailp->ail_lock);
> -	error = xfs_cui_recover(parent_tp, cuip);
> -	spin_lock(&ailp->ail_lock);
> -
> -	return error;
> -}
> -
> -/* Release the CUI since we're cancelling everything. */
> -STATIC void
> -xlog_recover_cancel_cui(
> -	struct xfs_mount		*mp,
> -	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip)
> -{
> -	struct xfs_cui_log_item		*cuip;
> -
> -	cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
> -
> -	spin_unlock(&ailp->ail_lock);
> -	xfs_cui_release(cuip);
> -	spin_lock(&ailp->ail_lock);
> -}
> -
>  /* Recover the BUI if necessary. */
>  STATIC int
>  xlog_recover_process_bui(
> @@ -2758,10 +2718,8 @@ xlog_recover_process_intents(
>  		switch (lip->li_type) {
>  		case XFS_LI_EFI:
>  		case XFS_LI_RUI:
> -			error = lip->li_ops->iop_recover(lip, parent_tp);
> -			break;
>  		case XFS_LI_CUI:
> -			error = xlog_recover_process_cui(parent_tp, ailp, lip);
> +			error = lip->li_ops->iop_recover(lip, parent_tp);
>  			break;
>  		case XFS_LI_BUI:
>  			error = xlog_recover_process_bui(parent_tp, ailp, lip);
> @@ -2812,13 +2770,11 @@ xlog_recover_cancel_intents(
>  		switch (lip->li_type) {
>  		case XFS_LI_EFI:
>  		case XFS_LI_RUI:
> +		case XFS_LI_CUI:
>  			spin_unlock(&ailp->ail_lock);
>  			lip->li_ops->iop_release(lip);
>  			spin_lock(&ailp->ail_lock);
>  			break;
> -		case XFS_LI_CUI:
> -			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
> -			break;
>  		case XFS_LI_BUI:
>  			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
>  			break;
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 28b41f5dd6bc..5b72eebd8764 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -24,6 +24,8 @@
>  kmem_zone_t	*xfs_cui_zone;
>  kmem_zone_t	*xfs_cud_zone;
>  
> +static const struct xfs_item_ops xfs_cui_item_ops;
> +
>  static inline struct xfs_cui_log_item *CUI_ITEM(struct xfs_log_item *lip)
>  {
>  	return container_of(lip, struct xfs_cui_log_item, cui_item);
> @@ -46,7 +48,7 @@ xfs_cui_item_free(
>   * committed vs unpin operations in bulk insert operations. Hence the reference
>   * count to ensure only the last caller frees the CUI.
>   */
> -void
> +STATIC void
>  xfs_cui_release(
>  	struct xfs_cui_log_item	*cuip)
>  {
> @@ -125,13 +127,6 @@ xfs_cui_item_release(
>  	xfs_cui_release(CUI_ITEM(lip));
>  }
>  
> -static const struct xfs_item_ops xfs_cui_item_ops = {
> -	.iop_size	= xfs_cui_item_size,
> -	.iop_format	= xfs_cui_item_format,
> -	.iop_unpin	= xfs_cui_item_unpin,
> -	.iop_release	= xfs_cui_item_release,
> -};
> -
>  /*
>   * Allocate and initialize an cui item with the given number of extents.
>   */
> @@ -425,7 +420,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
>   * Process a refcount update intent item that was recovered from the log.
>   * We need to update the refcountbt.
>   */
> -int
> +STATIC int
>  xfs_cui_recover(
>  	struct xfs_trans		*parent_tp,
>  	struct xfs_cui_log_item		*cuip)
> @@ -573,6 +568,37 @@ xfs_cui_recover(
>  	return error;
>  }
>  
> +/* Recover the CUI if necessary. */
> +STATIC int
> +xfs_cui_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_ail			*ailp = lip->li_ailp;
> +	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
> +	int				error;
> +
> +	/*
> +	 * Skip CUIs that we've already processed.
> +	 */
> +	if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags))
> +		return 0;
> +
> +	spin_unlock(&ailp->ail_lock);
> +	error = xfs_cui_recover(tp, cuip);
> +	spin_lock(&ailp->ail_lock);
> +
> +	return error;
> +}
> +
> +static const struct xfs_item_ops xfs_cui_item_ops = {
> +	.iop_size	= xfs_cui_item_size,
> +	.iop_format	= xfs_cui_item_format,
> +	.iop_unpin	= xfs_cui_item_unpin,
> +	.iop_release	= xfs_cui_item_release,
> +	.iop_recover	= xfs_cui_item_recover,
> +};
> +
>  /*
>   * Copy an CUI format buffer from the given buf, and into the destination
>   * CUI format structure.  The CUI/CUD items were designed not to need any
> diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> index ebe12779eaac..cfaa857673a6 100644
> --- a/fs/xfs/xfs_refcount_item.h
> +++ b/fs/xfs/xfs_refcount_item.h
> @@ -77,7 +77,4 @@ struct xfs_cud_log_item {
>  extern struct kmem_zone	*xfs_cui_zone;
>  extern struct kmem_zone	*xfs_cud_zone;
>  
> -void xfs_cui_release(struct xfs_cui_log_item *);
> -int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
> -
>  #endif	/* __XFS_REFCOUNT_ITEM_H__ */
> 
> 


-- 
chandan



