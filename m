Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F423C4724C
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 04:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E23E20757
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 04:07:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6GW+faP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgEFEHE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 00:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgEFEHE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 00:07:04 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C193C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 21:07:04 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m7so3877plt.5
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 21:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cbv4xxWvNVJJhWxp/J00ciFaQPrG/IKHW1rmJm12ha4=;
        b=a6GW+faPCx1onrnbuaifnaumswwPeyvcKplqvPkwrA1cW3G6t/lM//CC1nTdqx4fjV
         oi8ft9EF8ywrvkb7Uj90kWZNij/ptPHdCLpNAcW6CIib5md3/gauPYzjpibHhw4SUuba
         69EJyGQCSNajKHXSb1kX/AvjxLClhnavCDf3u0v2wOdNfHg5DvgunlxGqPQ0wuKEhFcF
         1a2uzFeiaiywqU5yZR7dBDF/ZtCW+gB+tBWfEsBeIy2HZeq7HyokdKgao8XoBdLAYeKt
         kXWkGhaf6JQxtGhSGezUMyCrQhViaUbsNXftRv3zAInWeeGJn+Ahqix+RPNb4T6yB5RH
         EYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cbv4xxWvNVJJhWxp/J00ciFaQPrG/IKHW1rmJm12ha4=;
        b=kpdNqXJvuinfeglGmKU4ZistqZOwKj/0U0XEmt1W+Aksg24J0/8/yvsZKh2f84+QXs
         rjpkTexFPNZjXCzKLs9cj75/iPgn8yyHst5BHbcOxBE8/rRDOsctxfjB23l+pGFTezqu
         7UwnLF3WZTsKXHjuYy4KHdvT69xCYb4ssEnyjTgKiLeaGi0SxF+7KRt8Gb2BerDrRSLC
         k++/mFA2TK584IyED5H/+dupoqCfl1qI7WDjlorjOy7EA4amy4t8FtNAe6UKzXngSBc/
         6YT7+UtBygqGqwkKWNOWzzY4wtpF0UMum84l6ufyfMOstuDxYcyC1kg28kOSvGOafB/S
         GQGA==
X-Gm-Message-State: AGi0PuYAPybxLUsOb1wRApn4hf3jevulRbEYhWOyRR1ZJUhoI2WVoC2f
        kcCWeroBlfIlk/XmUG5Yhs59tmTI0no=
X-Google-Smtp-Source: APiQypLzcHCCTFb0SGPeXzovebUMI/nTNcx7iO/9ZHdtOA+dOSsih/FThayg1QyqZx0BBpArlfKFpg==
X-Received: by 2002:a17:90a:17a6:: with SMTP id q35mr6672044pja.96.1588738023418;
        Tue, 05 May 2020 21:07:03 -0700 (PDT)
Received: from garuda.localnet ([122.171.200.101])
        by smtp.gmail.com with ESMTPSA id b11sm507603pgq.50.2020.05.05.21.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 21:07:02 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/28] xfs: refactor releasing finished intents during log recovery
Date:   Wed, 06 May 2020 09:36:59 +0530
Message-ID: <1624585.PyqrBo7VhX@garuda>
In-Reply-To: <158864116741.182683.12547831138234795563.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864116741.182683.12547831138234795563.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:42:47 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the open-coded AIL item walking with a proper helper when we're
> trying to release an intent item that has been finished.
>

The functionality is the same as was before applying this patch.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_recover.h |    3 +++
>  fs/xfs/xfs_bmap_item.c          |   42 +++++++++------------------------------
>  fs/xfs/xfs_extfree_item.c       |   42 +++++++++------------------------------
>  fs/xfs/xfs_log_recover.c        |   35 ++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_refcount_item.c      |   42 +++++++++------------------------------
>  fs/xfs/xfs_rmap_item.c          |   42 +++++++++------------------------------
>  fs/xfs/xfs_trans.h              |    1 +
>  7 files changed, 78 insertions(+), 129 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index d4d6d4f84fda..b875819a1c04 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -126,4 +126,7 @@ bool xlog_put_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>  void xlog_recover_iodone(struct xfs_buf *bp);
>  int xlog_recover_process_unlinked(struct xlog *log);
>  
> +void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
> +		uint64_t intent_id);
> +
>  #endif	/* __XFS_LOG_RECOVER_H__ */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index f88ebf8634c4..96627ea800c8 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -578,12 +578,21 @@ xfs_bui_item_recover(
>  	return error;
>  }
>  
> +STATIC bool
> +xfs_bui_item_match(
> +	struct xfs_log_item	*lip,
> +	uint64_t		intent_id)
> +{
> +	return BUI_ITEM(lip)->bui_format.bui_id == intent_id;
> +}
> +
>  static const struct xfs_item_ops xfs_bui_item_ops = {
>  	.iop_size	= xfs_bui_item_size,
>  	.iop_format	= xfs_bui_item_format,
>  	.iop_unpin	= xfs_bui_item_unpin,
>  	.iop_release	= xfs_bui_item_release,
>  	.iop_recover	= xfs_bui_item_recover,
> +	.iop_match	= xfs_bui_item_match,
>  };
>  
>  /*
> @@ -675,45 +684,14 @@ xlog_recover_bmap_done_commit_pass2(
>  	xfs_lsn_t			lsn)
>  {
>  	struct xfs_bud_log_format	*bud_formatp;
> -	struct xfs_bui_log_item		*buip = NULL;
> -	struct xfs_log_item		*lip;
> -	uint64_t			bui_id;
> -	struct xfs_ail_cursor		cur;
> -	struct xfs_ail			*ailp = log->l_ailp;
>  
>  	bud_formatp = item->ri_buf[0].i_addr;
>  	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
>  		return -EFSCORRUPTED;
>  	}
> -	bui_id = bud_formatp->bud_bui_id;
> -
> -	/*
> -	 * Search for the BUI with the id in the BUD format structure in the
> -	 * AIL.
> -	 */
> -	spin_lock(&ailp->ail_lock);
> -	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> -	while (lip != NULL) {
> -		if (lip->li_type == XFS_LI_BUI) {
> -			buip = (struct xfs_bui_log_item *)lip;
> -			if (buip->bui_format.bui_id == bui_id) {
> -				/*
> -				 * Drop the BUD reference to the BUI. This
> -				 * removes the BUI from the AIL and frees it.
> -				 */
> -				spin_unlock(&ailp->ail_lock);
> -				xfs_bui_release(buip);
> -				spin_lock(&ailp->ail_lock);
> -				break;
> -			}
> -		}
> -		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> -	}
> -
> -	xfs_trans_ail_cursor_done(&cur);
> -	spin_unlock(&ailp->ail_lock);
>  
> +	xlog_recover_release_intent(log, XFS_LI_BUI, bud_formatp->bud_bui_id);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 3fc8a9864217..4e1b10ab17a5 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -665,12 +665,21 @@ xfs_efi_item_recover(
>  	return error;
>  }
>  
> +STATIC bool
> +xfs_efi_item_match(
> +	struct xfs_log_item	*lip,
> +	uint64_t		intent_id)
> +{
> +	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
> +}
> +
>  static const struct xfs_item_ops xfs_efi_item_ops = {
>  	.iop_size	= xfs_efi_item_size,
>  	.iop_format	= xfs_efi_item_format,
>  	.iop_unpin	= xfs_efi_item_unpin,
>  	.iop_release	= xfs_efi_item_release,
>  	.iop_recover	= xfs_efi_item_recover,
> +	.iop_match	= xfs_efi_item_match,
>  };
>  
>  
> @@ -734,46 +743,15 @@ xlog_recover_extfree_done_commit_pass2(
>  	struct xlog_recover_item	*item,
>  	xfs_lsn_t			lsn)
>  {
> -	struct xfs_ail_cursor		cur;
>  	struct xfs_efd_log_format	*efd_formatp;
> -	struct xfs_efi_log_item		*efip = NULL;
> -	struct xfs_log_item		*lip;
> -	struct xfs_ail			*ailp = log->l_ailp;
> -	uint64_t			efi_id;
>  
>  	efd_formatp = item->ri_buf[0].i_addr;
>  	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
>  		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
>  	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
>  		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
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
>  
> +	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 0ccc09c004f1..55477b9b9311 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1779,6 +1779,38 @@ xlog_clear_stale_blocks(
>  	return 0;
>  }
>  
> +/*
> + * Release the recovered intent item in the AIL that matches the given intent
> + * type and intent id.
> + */
> +void
> +xlog_recover_release_intent(
> +	struct xlog		*log,
> +	unsigned short		intent_type,
> +	uint64_t		intent_id)
> +{
> +	struct xfs_ail_cursor	cur;
> +	struct xfs_log_item	*lip;
> +	struct xfs_ail		*ailp = log->l_ailp;
> +
> +	spin_lock(&ailp->ail_lock);
> +	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0); lip != NULL;
> +	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
> +		if (lip->li_type != intent_type)
> +			continue;
> +		if (!lip->li_ops->iop_match(lip, intent_id))
> +			continue;
> +
> +		spin_unlock(&ailp->ail_lock);
> +		lip->li_ops->iop_release(lip);
> +		spin_lock(&ailp->ail_lock);
> +		break;
> +	}
> +
> +	xfs_trans_ail_cursor_done(&cur);
> +	spin_unlock(&ailp->ail_lock);
> +}
> +
>  /******************************************************************************
>   *
>   *		Log recover routines
> @@ -2590,7 +2622,8 @@ xlog_finish_defer_ops(
>  /* Is this log item a deferred action intent? */
>  static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  {
> -	return lip->li_ops->iop_recover != NULL;
> +	return lip->li_ops->iop_recover != NULL &&
> +	       lip->li_ops->iop_match != NULL;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 5b72eebd8764..27126b136b5a 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -591,12 +591,21 @@ xfs_cui_item_recover(
>  	return error;
>  }
>  
> +STATIC bool
> +xfs_cui_item_match(
> +	struct xfs_log_item	*lip,
> +	uint64_t		intent_id)
> +{
> +	return CUI_ITEM(lip)->cui_format.cui_id == intent_id;
> +}
> +
>  static const struct xfs_item_ops xfs_cui_item_ops = {
>  	.iop_size	= xfs_cui_item_size,
>  	.iop_format	= xfs_cui_item_format,
>  	.iop_unpin	= xfs_cui_item_unpin,
>  	.iop_release	= xfs_cui_item_release,
>  	.iop_recover	= xfs_cui_item_recover,
> +	.iop_match	= xfs_cui_item_match,
>  };
>  
>  /*
> @@ -684,45 +693,14 @@ xlog_recover_refcount_done_commit_pass2(
>  	xfs_lsn_t			lsn)
>  {
>  	struct xfs_cud_log_format	*cud_formatp;
> -	struct xfs_cui_log_item		*cuip = NULL;
> -	struct xfs_log_item		*lip;
> -	uint64_t			cui_id;
> -	struct xfs_ail_cursor		cur;
> -	struct xfs_ail			*ailp = log->l_ailp;
>  
>  	cud_formatp = item->ri_buf[0].i_addr;
>  	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
>  		return -EFSCORRUPTED;
>  	}
> -	cui_id = cud_formatp->cud_cui_id;
> -
> -	/*
> -	 * Search for the CUI with the id in the CUD format structure in the
> -	 * AIL.
> -	 */
> -	spin_lock(&ailp->ail_lock);
> -	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> -	while (lip != NULL) {
> -		if (lip->li_type == XFS_LI_CUI) {
> -			cuip = (struct xfs_cui_log_item *)lip;
> -			if (cuip->cui_format.cui_id == cui_id) {
> -				/*
> -				 * Drop the CUD reference to the CUI. This
> -				 * removes the CUI from the AIL and frees it.
> -				 */
> -				spin_unlock(&ailp->ail_lock);
> -				xfs_cui_release(cuip);
> -				spin_lock(&ailp->ail_lock);
> -				break;
> -			}
> -		}
> -		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> -	}
> -
> -	xfs_trans_ail_cursor_done(&cur);
> -	spin_unlock(&ailp->ail_lock);
>  
> +	xlog_recover_release_intent(log, XFS_LI_CUI, cud_formatp->cud_cui_id);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index e763dd8ed0a6..3987f217415c 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -606,12 +606,21 @@ xfs_rui_item_recover(
>  	return error;
>  }
>  
> +STATIC bool
> +xfs_rui_item_match(
> +	struct xfs_log_item	*lip,
> +	uint64_t		intent_id)
> +{
> +	return RUI_ITEM(lip)->rui_format.rui_id == intent_id;
> +}
> +
>  static const struct xfs_item_ops xfs_rui_item_ops = {
>  	.iop_size	= xfs_rui_item_size,
>  	.iop_format	= xfs_rui_item_format,
>  	.iop_unpin	= xfs_rui_item_unpin,
>  	.iop_release	= xfs_rui_item_release,
>  	.iop_recover	= xfs_rui_item_recover,
> +	.iop_match	= xfs_rui_item_match,
>  };
>  
>  /*
> @@ -675,42 +684,11 @@ xlog_recover_rmap_done_commit_pass2(
>  	xfs_lsn_t			lsn)
>  {
>  	struct xfs_rud_log_format	*rud_formatp;
> -	struct xfs_rui_log_item		*ruip = NULL;
> -	struct xfs_log_item		*lip;
> -	uint64_t			rui_id;
> -	struct xfs_ail_cursor		cur;
> -	struct xfs_ail			*ailp = log->l_ailp;
>  
>  	rud_formatp = item->ri_buf[0].i_addr;
>  	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
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
>  
> +	xlog_recover_release_intent(log, XFS_LI_RUI, rud_formatp->rud_rui_id);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 3f6a79108991..3e8808bb07c5 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -78,6 +78,7 @@ struct xfs_item_ops {
>  	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
>  	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
>  	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
> +	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
>  };
>  
>  /*
> 
> 


-- 
chandan



