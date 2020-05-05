Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8C9C47256
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 06:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA97206E6
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 06:46:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltwzJ8ox"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgEEGqp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 02:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgEEGqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 02:46:45 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA2BC061A0F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 23:46:45 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id e6so595669pjt.4
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3E9HqwizrsAquj+rWCsEsN/ZZAd+pbxNU2f8ChrFlCk=;
        b=ltwzJ8oxE6pO+8HFk0xFycfTeFbhlAgaUdT73K/9BuSTHd67YAWATBgoEBz+yTO5Mx
         z56/wZ8Ll76CqhsTFhJjv/3fybeFL4zMxPXtvWeaDRUhTz/1RVnmhJpRqvncQSndknpH
         UwCHxFdTvnWk9v+2lc71hJdWvgbiQ76wBgQleykOh3hy639rJZFE2DAqcg7t+SWYT9LR
         TWalXS2atEaJsA1OWoJcptprrs9V+dqTEGnUQFiNXTyTu7fKbF0egnSWyCe9N22roqOp
         sxKw/5hnV5JhwWXrPlc5MJvzLeotbPU+V1Ifvv5ZLXmBBbkoYfp9ChmgG+0snxAqktRS
         urnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3E9HqwizrsAquj+rWCsEsN/ZZAd+pbxNU2f8ChrFlCk=;
        b=rEW4CoAID6iUTiTlZip0VtpylrrZplvM2jp0xT9FPG0i8q4otfeVzIEWd9znDAW04B
         3Z6C1ViJOAu7yfXtdEIkZSSRbch5sJRBEgHaHFKK894Ln5IK9Sb1g7pG9FfF9fa7YGa1
         /DIwzgIEJ2sXRXIai0l9a7isnNHA0G3GPaPWDamiHdoqAoNgeLUujAFr8GMa4aNwV09f
         B/rOZSWSXqxr2Ukm8Zi/LJVy3a1LDXmZyRY4PsVOGAYyoeVzNdGRnshlYwYZ0L5/h0PS
         Q52dcgNz5iM4o7uIqyDNhi0nPn+vY7hatA6ScVJI33gVNg6Uu+pF9o/flWm+FMDKpYeZ
         lNTw==
X-Gm-Message-State: AGi0PuYsh0JTtHV0KUBpMq4wDNskEIyVAOhEw9saQsZ+hSVcLvkpeCpc
        2TXyf7yCt68PhjfPkooXjuE=
X-Google-Smtp-Source: APiQypI+YLuWdcWu2efaqf0L5ybdE50HlQYtVIY9nSdLb6wZkPO5611z0TXc7Q10w61SqyMFWg1V9A==
X-Received: by 2002:a17:90a:d0c3:: with SMTP id y3mr1150123pjw.25.1588661204338;
        Mon, 04 May 2020 23:46:44 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id n10sm816798pgk.49.2020.05.04.23.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 23:46:43 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/28] xfs: refactor log recovery EFI item dispatch for pass2 commit functions
Date:   Tue, 05 May 2020 12:16:41 +0530
Message-ID: <63550166.oIgbi9nrrY@garuda>
In-Reply-To: <158864108899.182683.16410690388562685610.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864108899.182683.16410690388562685610.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:41:29 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the extent free intent and intent-done pass2 commit code into the
> per-item source code files and use dispatch functions to call them.  We
> do these one at a time because there's a lot of code to move.  No
> functional changes.
>

EFI/EFD item pass2 processing is functionally consistent with what was done
before this patch is applied.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_extfree_item.c |  107 ++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_extfree_item.h |    4 --
>  fs/xfs/xfs_log_recover.c  |  100 ------------------------------------------
>  3 files changed, 104 insertions(+), 107 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index b43bb087aef3..dca098660753 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -22,6 +22,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_efi_zone;
> @@ -32,7 +33,7 @@ static inline struct xfs_efi_log_item *EFI_ITEM(struct xfs_log_item *lip)
>  	return container_of(lip, struct xfs_efi_log_item, efi_item);
>  }
>  
> -void
> +STATIC void
>  xfs_efi_item_free(
>  	struct xfs_efi_log_item	*efip)
>  {
> @@ -151,7 +152,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
>  /*
>   * Allocate and initialize an efi item with the given number of extents.
>   */
> -struct xfs_efi_log_item *
> +STATIC struct xfs_efi_log_item *
>  xfs_efi_init(
>  	struct xfs_mount	*mp,
>  	uint			nextents)
> @@ -185,7 +186,7 @@ xfs_efi_init(
>   * one of which will be the native format for this kernel.
>   * It will handle the conversion of formats if necessary.
>   */
> -int
> +STATIC int
>  xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
>  {
>  	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
> @@ -646,10 +647,110 @@ xfs_efi_recover(
>  	return error;
>  }
>  
> +/*
> + * This routine is called to create an in-core extent free intent
> + * item from the efi format structure which was logged on disk.
> + * It allocates an in-core efi, copies the extents from the format
> + * structure into it, and adds the efi to the AIL with the given
> + * LSN.
> + */
> +STATIC int
> +xlog_recover_extfree_intent_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_efi_log_item		*efip;
> +	struct xfs_efi_log_format	*efi_formatp;
> +	int				error;
> +
> +	efi_formatp = item->ri_buf[0].i_addr;
> +
> +	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
> +	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
> +	if (error) {
> +		xfs_efi_item_free(efip);
> +		return error;
> +	}
> +	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
> +
> +	spin_lock(&log->l_ailp->ail_lock);
> +	/*
> +	 * The EFI has two references. One for the EFD and one for EFI to ensure
> +	 * it makes it into the AIL. Insert the EFI into the AIL directly and
> +	 * drop the EFI reference. Note that xfs_trans_ail_update() drops the
> +	 * AIL lock.
> +	 */
> +	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
> +	xfs_efi_release(efip);
> +	return 0;
> +}
> +
>  const struct xlog_recover_item_ops xlog_extfree_intent_item_ops = {
>  	.item_type		= XFS_LI_EFI,
> +	.commit_pass2		= xlog_recover_extfree_intent_commit_pass2,
>  };
>  
> +/*
> + * This routine is called when an EFD format structure is found in a committed
> + * transaction in the log. Its purpose is to cancel the corresponding EFI if it
> + * was still in the log. To do this it searches the AIL for the EFI with an id
> + * equal to that in the EFD format structure. If we find it we drop the EFD
> + * reference, which removes the EFI from the AIL and frees it.
> + */
> +STATIC int
> +xlog_recover_extfree_done_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_ail_cursor		cur;
> +	struct xfs_efd_log_format	*efd_formatp;
> +	struct xfs_efi_log_item		*efip = NULL;
> +	struct xfs_log_item		*lip;
> +	struct xfs_ail			*ailp = log->l_ailp;
> +	uint64_t			efi_id;
> +
> +	efd_formatp = item->ri_buf[0].i_addr;
> +	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
> +		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
> +	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
> +		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
> +	efi_id = efd_formatp->efd_efi_id;
> +
> +	/*
> +	 * Search for the EFI with the id in the EFD format structure in the
> +	 * AIL.
> +	 */
> +	spin_lock(&ailp->ail_lock);
> +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	while (lip != NULL) {
> +		if (lip->li_type == XFS_LI_EFI) {
> +			efip = (struct xfs_efi_log_item *)lip;
> +			if (efip->efi_format.efi_id == efi_id) {
> +				/*
> +				 * Drop the EFD reference to the EFI. This
> +				 * removes the EFI from the AIL and frees it.
> +				 */
> +				spin_unlock(&ailp->ail_lock);
> +				xfs_efi_release(efip);
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
>  const struct xlog_recover_item_ops xlog_extfree_done_item_ops = {
>  	.item_type		= XFS_LI_EFD,
> +	.commit_pass2		= xlog_recover_extfree_done_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index a2a736a77fa9..876e3d237f48 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -78,10 +78,6 @@ struct xfs_efd_log_item {
>  extern struct kmem_zone	*xfs_efi_zone;
>  extern struct kmem_zone	*xfs_efd_zone;
>  
> -struct xfs_efi_log_item	*xfs_efi_init(struct xfs_mount *, uint);
> -int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
> -					    xfs_efi_log_format_t *dst_efi_fmt);
> -void			xfs_efi_item_free(struct xfs_efi_log_item *);
>  void			xfs_efi_release(struct xfs_efi_log_item *);
>  
>  int			xfs_efi_recover(struct xfs_mount *mp,
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 86bf2da28dcd..d7c5f75cf992 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2034,102 +2034,6 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> -/*
> - * This routine is called to create an in-core extent free intent
> - * item from the efi format structure which was logged on disk.
> - * It allocates an in-core efi, copies the extents from the format
> - * structure into it, and adds the efi to the AIL with the given
> - * LSN.
> - */
> -STATIC int
> -xlog_recover_efi_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item,
> -	xfs_lsn_t			lsn)
> -{
> -	int				error;
> -	struct xfs_mount		*mp = log->l_mp;
> -	struct xfs_efi_log_item		*efip;
> -	struct xfs_efi_log_format	*efi_formatp;
> -
> -	efi_formatp = item->ri_buf[0].i_addr;
> -
> -	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
> -	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
> -	if (error) {
> -		xfs_efi_item_free(efip);
> -		return error;
> -	}
> -	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
> -
> -	spin_lock(&log->l_ailp->ail_lock);
> -	/*
> -	 * The EFI has two references. One for the EFD and one for EFI to ensure
> -	 * it makes it into the AIL. Insert the EFI into the AIL directly and
> -	 * drop the EFI reference. Note that xfs_trans_ail_update() drops the
> -	 * AIL lock.
> -	 */
> -	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
> -	xfs_efi_release(efip);
> -	return 0;
> -}
> -
> -
> -/*
> - * This routine is called when an EFD format structure is found in a committed
> - * transaction in the log. Its purpose is to cancel the corresponding EFI if it
> - * was still in the log. To do this it searches the AIL for the EFI with an id
> - * equal to that in the EFD format structure. If we find it we drop the EFD
> - * reference, which removes the EFI from the AIL and frees it.
> - */
> -STATIC int
> -xlog_recover_efd_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item)
> -{
> -	xfs_efd_log_format_t	*efd_formatp;
> -	struct xfs_efi_log_item	*efip = NULL;
> -	struct xfs_log_item	*lip;
> -	uint64_t		efi_id;
> -	struct xfs_ail_cursor	cur;
> -	struct xfs_ail		*ailp = log->l_ailp;
> -
> -	efd_formatp = item->ri_buf[0].i_addr;
> -	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
> -		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
> -	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
> -		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
> -	efi_id = efd_formatp->efd_efi_id;
> -
> -	/*
> -	 * Search for the EFI with the id in the EFD format structure in the
> -	 * AIL.
> -	 */
> -	spin_lock(&ailp->ail_lock);
> -	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> -	while (lip != NULL) {
> -		if (lip->li_type == XFS_LI_EFI) {
> -			efip = (struct xfs_efi_log_item *)lip;
> -			if (efip->efi_format.efi_id == efi_id) {
> -				/*
> -				 * Drop the EFD reference to the EFI. This
> -				 * removes the EFI from the AIL and frees it.
> -				 */
> -				spin_unlock(&ailp->ail_lock);
> -				xfs_efi_release(efip);
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
>   * This routine is called to create an in-core extent rmap update
>   * item from the rui format structure which was logged on disk.
> @@ -2481,10 +2385,6 @@ xlog_recover_commit_pass2(
>  				trans->r_lsn);
>  
>  	switch (ITEM_TYPE(item)) {
> -	case XFS_LI_EFI:
> -		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
> -	case XFS_LI_EFD:
> -		return xlog_recover_efd_pass2(log, item);
>  	case XFS_LI_RUI:
>  		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_RUD:
> 
> 


-- 
chandan



