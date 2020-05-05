Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BB9C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A1F8206CC
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pkXWpf6Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgEEJDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 05:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgEEJDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 05:03:17 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2663AC061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 02:03:17 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t16so551289plo.7
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 02:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHymTyQOz1lYV2nW2LN+JXjpU+Wbcor2gJ7sQ2B+vjY=;
        b=pkXWpf6ZEiWOUFlrvrk04//02MJwRVkmWk57OXURoQ/xmFxs+S+FfA395Eznihlbv9
         wHKp7xD6XlUmhiaJ4Q4/FRXRVX3h5iZ9+KSYjTeyDZnLrwnb4XIjWou+CMEd36z4quV2
         1a//dz8OPzVXK3bymThkuN1uMSQjLbu65x8Q04JW1kHCAUXHSvQYE5H0QaN+nsiHL74b
         0Hg9Pk82Gyr++9+36T8iT7cY2aLhgVV7DV6DnBZ8PbR/ORGImNjJ7UOzzEeGyQbm4con
         RZZL3RXHT2wr+rMcZ9gticDnAS6RLHbE+EaPeGnLAuazknnP9SPYOBlq2TRxvGKjFjxE
         GSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHymTyQOz1lYV2nW2LN+JXjpU+Wbcor2gJ7sQ2B+vjY=;
        b=RZf5VW2Enwn/GNl0qPXZqzGWkX6oOifDzwNbvrK0lpU3X8XmIP20KXTOZ/9QmlaOBM
         VqJ7jlQeiz+QtncGcV7U0Mz0RHOupN/+lZam/NMw5RuyDUSQy47/Qhikh3h5jBubWlAQ
         VyrsER9FPqHFrwufNGmW52iJE8V4hkjcuvSgYq62E98N/SKKboWLoMYDG3AqLNa8JU0U
         9TdZGlUW7JTOEU7+uLCLkepSTSeA4+FHcqkMmrHMyj8Tn4aRLkUBNYM6i/KLOllaX87g
         brxz2Lew7mLV51VxLQsF/kzaOGKQTMywVZJngNaCg8lWJKrlcGbS2zpgbeAg11BWDNVv
         C4/A==
X-Gm-Message-State: AGi0PuYUTOovp3JrZ6wDxJsTAJCHX+lZLppgbCMog5oXwOXbLNdx5Z5n
        48YZ+YjEYjeggnmbEs1F2Jw=
X-Google-Smtp-Source: APiQypLGQkuVMAa85I7OZPs8eRFMMUUZibmocQtobfdJlm0D2Xb1JLCVxZT7b61FUWmORDi8FlChIw==
X-Received: by 2002:a17:90a:cb0b:: with SMTP id z11mr1679951pjt.62.1588669396636;
        Tue, 05 May 2020 02:03:16 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id nu10sm1481157pjb.9.2020.05.05.02.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 02:03:15 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/28] xfs: refactor recovered EFI log item playback
Date:   Tue, 05 May 2020 14:33:13 +0530
Message-ID: <1670737.fYoo42gQZr@garuda>
In-Reply-To: <158864112169.182683.14030031632354525711.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864112169.182683.14030031632354525711.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:42:01 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the code that processes the log items created from the recovered
> log items into the per-item source code files and use dispatch functions
> to call them.  No functional changes.
>

EFI log item playback is consistent with what was done before the patch is
applied.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_extfree_item.c |   47 +++++++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_extfree_item.h |    5 -----
>  fs/xfs/xfs_log_recover.c  |   46 ++++----------------------------------------
>  fs/xfs/xfs_trans.h        |    1 +
>  4 files changed, 42 insertions(+), 57 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index dca098660753..3fc8a9864217 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -28,6 +28,8 @@
>  kmem_zone_t	*xfs_efi_zone;
>  kmem_zone_t	*xfs_efd_zone;
>  
> +static const struct xfs_item_ops xfs_efi_item_ops;
> +
>  static inline struct xfs_efi_log_item *EFI_ITEM(struct xfs_log_item *lip)
>  {
>  	return container_of(lip, struct xfs_efi_log_item, efi_item);
> @@ -51,7 +53,7 @@ xfs_efi_item_free(
>   * committed vs unpin operations in bulk insert operations. Hence the reference
>   * count to ensure only the last caller frees the EFI.
>   */
> -void
> +STATIC void
>  xfs_efi_release(
>  	struct xfs_efi_log_item	*efip)
>  {
> @@ -141,14 +143,6 @@ xfs_efi_item_release(
>  	xfs_efi_release(EFI_ITEM(lip));
>  }
>  
> -static const struct xfs_item_ops xfs_efi_item_ops = {
> -	.iop_size	= xfs_efi_item_size,
> -	.iop_format	= xfs_efi_item_format,
> -	.iop_unpin	= xfs_efi_item_unpin,
> -	.iop_release	= xfs_efi_item_release,
> -};
> -
> -
>  /*
>   * Allocate and initialize an efi item with the given number of extents.
>   */
> @@ -586,7 +580,7 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
>   * Process an extent free intent item that was recovered from
>   * the log.  We need to free the extents that it describes.
>   */
> -int
> +STATIC int
>  xfs_efi_recover(
>  	struct xfs_mount	*mp,
>  	struct xfs_efi_log_item	*efip)
> @@ -647,6 +641,39 @@ xfs_efi_recover(
>  	return error;
>  }
>  
> +/* Recover the EFI if necessary. */
> +STATIC int
> +xfs_efi_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_ail			*ailp = lip->li_ailp;
> +	struct xfs_efi_log_item		*efip;
> +	int				error;
> +
> +	/*
> +	 * Skip EFIs that we've already processed.
> +	 */
> +	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
> +	if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
> +		return 0;
> +
> +	spin_unlock(&ailp->ail_lock);
> +	error = xfs_efi_recover(tp->t_mountp, efip);
> +	spin_lock(&ailp->ail_lock);
> +
> +	return error;
> +}
> +
> +static const struct xfs_item_ops xfs_efi_item_ops = {
> +	.iop_size	= xfs_efi_item_size,
> +	.iop_format	= xfs_efi_item_format,
> +	.iop_unpin	= xfs_efi_item_unpin,
> +	.iop_release	= xfs_efi_item_release,
> +	.iop_recover	= xfs_efi_item_recover,
> +};
> +
> +
>  /*
>   * This routine is called to create an in-core extent free intent
>   * item from the efi format structure which was logged on disk.
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index 876e3d237f48..4b2c2c5c5985 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -78,9 +78,4 @@ struct xfs_efd_log_item {
>  extern struct kmem_zone	*xfs_efi_zone;
>  extern struct kmem_zone	*xfs_efd_zone;
>  
> -void			xfs_efi_release(struct xfs_efi_log_item *);
> -
> -int			xfs_efi_recover(struct xfs_mount *mp,
> -					struct xfs_efi_log_item *efip);
> -
>  #endif	/* __XFS_EXTFREE_ITEM_H__ */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 929e2caeeb42..f12e14719202 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2553,46 +2553,6 @@ xlog_recover_process_data(
>  	return 0;
>  }
>  
> -/* Recover the EFI if necessary. */
> -STATIC int
> -xlog_recover_process_efi(
> -	struct xfs_mount		*mp,
> -	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip)
> -{
> -	struct xfs_efi_log_item		*efip;
> -	int				error;
> -
> -	/*
> -	 * Skip EFIs that we've already processed.
> -	 */
> -	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
> -	if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
> -		return 0;
> -
> -	spin_unlock(&ailp->ail_lock);
> -	error = xfs_efi_recover(mp, efip);
> -	spin_lock(&ailp->ail_lock);
> -
> -	return error;
> -}
> -
> -/* Release the EFI since we're cancelling everything. */
> -STATIC void
> -xlog_recover_cancel_efi(
> -	struct xfs_mount		*mp,
> -	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip)
> -{
> -	struct xfs_efi_log_item		*efip;
> -
> -	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
> -
> -	spin_unlock(&ailp->ail_lock);
> -	xfs_efi_release(efip);
> -	spin_lock(&ailp->ail_lock);
> -}
> -
>  /* Recover the RUI if necessary. */
>  STATIC int
>  xlog_recover_process_rui(
> @@ -2837,7 +2797,7 @@ xlog_recover_process_intents(
>  		 */
>  		switch (lip->li_type) {
>  		case XFS_LI_EFI:
> -			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
> +			error = lip->li_ops->iop_recover(lip, parent_tp);
>  			break;
>  		case XFS_LI_RUI:
>  			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
> @@ -2893,7 +2853,9 @@ xlog_recover_cancel_intents(
>  
>  		switch (lip->li_type) {
>  		case XFS_LI_EFI:
> -			xlog_recover_cancel_efi(log->l_mp, ailp, lip);
> +			spin_unlock(&ailp->ail_lock);
> +			lip->li_ops->iop_release(lip);
> +			spin_lock(&ailp->ail_lock);
>  			break;
>  		case XFS_LI_RUI:
>  			xlog_recover_cancel_rui(log->l_mp, ailp, lip);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 752c7fef9de7..3f6a79108991 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -77,6 +77,7 @@ struct xfs_item_ops {
>  	void (*iop_release)(struct xfs_log_item *);
>  	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
>  	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
> +	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
>  };
>  
>  /*
> 
> 


-- 
chandan



