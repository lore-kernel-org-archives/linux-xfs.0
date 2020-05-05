Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FD8C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A0FB206A4
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 09:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUAQ/6gl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEJKl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 05:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgEEJKl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 05:10:41 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A199BC061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 02:10:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fu13so744119pjb.5
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 02:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lzamh3wvhZ9L1+W4Mj2yjzwJ6JThKNY6kzWpTh2b0cc=;
        b=KUAQ/6gl5GTdXCW3v2bJrSNfNvzEeK5YSAgrYZCTlqkpoGnvY6B9YDwpViig2WnX+K
         JDIMKGDAbNs2MapmRHLChMqd+3bMGU+Kc4Xlxm/bSO7m/JPeMJ1qQJ27RkzkQ/Kb0vSV
         fUTE1McfPd9KSIiCImQP7Ks0o7A2FWZXuYMb2qZUKunj6WlRKJ77eZvXyjBQM8Ub6/E6
         76QgSSrUlj7XrRhQJfGll6l6iBK8vC/7JjL5vpFet8X7DjyObrOt+M23R7lFniUg/E78
         5FjQwaQ0xviwdq+BOELZsLU04IjfSujU7DZPcMWMNHtZPeERGFkicJhydfk84WecA9qr
         4coA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lzamh3wvhZ9L1+W4Mj2yjzwJ6JThKNY6kzWpTh2b0cc=;
        b=iSCDBmB0118lpe1NxVQBKY688XFYJNt+TsTSh7kMmWSGK6L2VGItIQ3Hr7u5brTofa
         W4kVrUfCRcEMzqqu+dWrilOSJtvZlrSmN8CnD3GwLLxpxfjJ/QE5JJ7LiOYJIOR0i2Ex
         GZ67bS35jPb0/LSWQNgXCiiVLCBtEVOEYPDHXDNS1DN8F1D19f3pM0e6/G9XsQpqDfTC
         TWb0YhWxucRUhXriYle2cLcMVeMNWNRhWfLtyuN9KEQ9Nha3yqVhDpxjIoZy303CO5Y5
         9IwK30eM5c/wiJe79z0WQLvaD09UhlPlhQpBJWTVU0RawEqzQdROp4c0B0748IfCurrP
         kC2g==
X-Gm-Message-State: AGi0Puaj6EROBaQCLbCx4ruLuL89fOg7UbOXXdfLFKayikXAU+Cpv2fI
        sVzLV5c3vPB7RArhN4tpHQc=
X-Google-Smtp-Source: APiQypKCla4bMmbNBVaWtbFjTiLSVnDAJiOBjwH4vvN4yfdWe8BAZqAIfl+xwpRAkRhlfr6pnUjRQQ==
X-Received: by 2002:a17:902:c403:: with SMTP id k3mr1187570plk.12.1588669840128;
        Tue, 05 May 2020 02:10:40 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id d10sm1131426pgo.10.2020.05.05.02.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 02:10:39 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/28] xfs: refactor recovered RUI log item playback
Date:   Tue, 05 May 2020 14:40:36 +0530
Message-ID: <2835571.ZlxoLBq2qq@garuda>
In-Reply-To: <158864112778.182683.3049865779495487697.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864112778.182683.3049865779495487697.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:42:07 AM IST Darrick J. Wong wrote:
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
>  fs/xfs/xfs_log_recover.c |   48 ++--------------------------------------------
>  fs/xfs/xfs_rmap_item.c   |   44 ++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_rmap_item.h   |    3 ---
>  3 files changed, 37 insertions(+), 58 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index f12e14719202..da66484acaa7 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2553,46 +2553,6 @@ xlog_recover_process_data(
>  	return 0;
>  }
>  
> -/* Recover the RUI if necessary. */
> -STATIC int
> -xlog_recover_process_rui(
> -	struct xfs_mount		*mp,
> -	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip)
> -{
> -	struct xfs_rui_log_item		*ruip;
> -	int				error;
> -
> -	/*
> -	 * Skip RUIs that we've already processed.
> -	 */
> -	ruip = container_of(lip, struct xfs_rui_log_item, rui_item);
> -	if (test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags))
> -		return 0;
> -
> -	spin_unlock(&ailp->ail_lock);
> -	error = xfs_rui_recover(mp, ruip);
> -	spin_lock(&ailp->ail_lock);
> -
> -	return error;
> -}
> -
> -/* Release the RUI since we're cancelling everything. */
> -STATIC void
> -xlog_recover_cancel_rui(
> -	struct xfs_mount		*mp,
> -	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip)
> -{
> -	struct xfs_rui_log_item		*ruip;
> -
> -	ruip = container_of(lip, struct xfs_rui_log_item, rui_item);
> -
> -	spin_unlock(&ailp->ail_lock);
> -	xfs_rui_release(ruip);
> -	spin_lock(&ailp->ail_lock);
> -}
> -
>  /* Recover the CUI if necessary. */
>  STATIC int
>  xlog_recover_process_cui(
> @@ -2797,10 +2757,8 @@ xlog_recover_process_intents(
>  		 */
>  		switch (lip->li_type) {
>  		case XFS_LI_EFI:
> -			error = lip->li_ops->iop_recover(lip, parent_tp);
> -			break;
>  		case XFS_LI_RUI:
> -			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
> +			error = lip->li_ops->iop_recover(lip, parent_tp);
>  			break;
>  		case XFS_LI_CUI:
>  			error = xlog_recover_process_cui(parent_tp, ailp, lip);
> @@ -2853,13 +2811,11 @@ xlog_recover_cancel_intents(
>  
>  		switch (lip->li_type) {
>  		case XFS_LI_EFI:
> +		case XFS_LI_RUI:
>  			spin_unlock(&ailp->ail_lock);
>  			lip->li_ops->iop_release(lip);
>  			spin_lock(&ailp->ail_lock);
>  			break;
> -		case XFS_LI_RUI:
> -			xlog_recover_cancel_rui(log->l_mp, ailp, lip);
> -			break;
>  		case XFS_LI_CUI:
>  			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
>  			break;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index c87f4e429c12..e763dd8ed0a6 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -24,6 +24,8 @@
>  kmem_zone_t	*xfs_rui_zone;
>  kmem_zone_t	*xfs_rud_zone;
>  
> +static const struct xfs_item_ops xfs_rui_item_ops;
> +
>  static inline struct xfs_rui_log_item *RUI_ITEM(struct xfs_log_item *lip)
>  {
>  	return container_of(lip, struct xfs_rui_log_item, rui_item);
> @@ -46,7 +48,7 @@ xfs_rui_item_free(
>   * committed vs unpin operations in bulk insert operations. Hence the reference
>   * count to ensure only the last caller frees the RUI.
>   */
> -void
> +STATIC void
>  xfs_rui_release(
>  	struct xfs_rui_log_item	*ruip)
>  {
> @@ -124,13 +126,6 @@ xfs_rui_item_release(
>  	xfs_rui_release(RUI_ITEM(lip));
>  }
>  
> -static const struct xfs_item_ops xfs_rui_item_ops = {
> -	.iop_size	= xfs_rui_item_size,
> -	.iop_format	= xfs_rui_item_format,
> -	.iop_unpin	= xfs_rui_item_unpin,
> -	.iop_release	= xfs_rui_item_release,
> -};
> -
>  /*
>   * Allocate and initialize an rui item with the given number of extents.
>   */
> @@ -468,7 +463,7 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
>   * Process an rmap update intent item that was recovered from the log.
>   * We need to update the rmapbt.
>   */
> -int
> +STATIC int
>  xfs_rui_recover(
>  	struct xfs_mount		*mp,
>  	struct xfs_rui_log_item		*ruip)
> @@ -588,6 +583,37 @@ xfs_rui_recover(
>  	return error;
>  }
>  
> +/* Recover the RUI if necessary. */
> +STATIC int
> +xfs_rui_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_ail			*ailp = lip->li_ailp;
> +	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
> +	int				error;
> +
> +	/*
> +	 * Skip RUIs that we've already processed.
> +	 */
> +	if (test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags))
> +		return 0;
> +
> +	spin_unlock(&ailp->ail_lock);
> +	error = xfs_rui_recover(tp->t_mountp, ruip);
> +	spin_lock(&ailp->ail_lock);
> +
> +	return error;
> +}
> +
> +static const struct xfs_item_ops xfs_rui_item_ops = {
> +	.iop_size	= xfs_rui_item_size,
> +	.iop_format	= xfs_rui_item_format,
> +	.iop_unpin	= xfs_rui_item_unpin,
> +	.iop_release	= xfs_rui_item_release,
> +	.iop_recover	= xfs_rui_item_recover,
> +};
> +
>  /*
>   * This routine is called to create an in-core extent rmap update
>   * item from the rui format structure which was logged on disk.
> diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
> index 89bd192779f8..48a77a6f5c94 100644
> --- a/fs/xfs/xfs_rmap_item.h
> +++ b/fs/xfs/xfs_rmap_item.h
> @@ -77,7 +77,4 @@ struct xfs_rud_log_item {
>  extern struct kmem_zone	*xfs_rui_zone;
>  extern struct kmem_zone	*xfs_rud_zone;
>  
> -void xfs_rui_release(struct xfs_rui_log_item *);
> -int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
> -
>  #endif	/* __XFS_RMAP_ITEM_H__ */
> 
> 


-- 
chandan



