Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81338C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 05:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538F2206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 05:14:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mwLmAQ1w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEFFOy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 01:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725771AbgEFFOy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 01:14:54 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F73C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 22:14:53 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 207so578567pgc.6
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 22:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqB5uOjQSa43LMkK3Dl6OsEMDfYQRtSaYFpCxqGmHg4=;
        b=mwLmAQ1wutfzVKhzPgLPLBRTVK2hI8H6/X3OIzPjmFAQyhkul5hiAA/VbEt47/EdPu
         7QRdTXZ+6XElv8/vKcGsgAhOpZqw5kNi9t7mFwjaCOfEvaUoDbEWcN9zimR6AVGM7J7d
         XNeVuA87LGBSvzT2tMmR9O2UIqzNaVtpGjoXSOCmxva0H63LGdzOAdg8g/HsBiHh5DqK
         kHdxNUZZtIz52l34KZfNdaJalhyPOGmcsgin0LlFqwmPgSz4ABgflcZNz5FKQh8SLGtJ
         mAgWAxEQhTjV6ewQkvCPO4PQrdyPnRG1uN4/mvIKddQ7dQcUUNBzahAghHdYsaDOa0xj
         4pEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqB5uOjQSa43LMkK3Dl6OsEMDfYQRtSaYFpCxqGmHg4=;
        b=jSTe9geVaGKCgtkF2MF223xUwP36UMyGCjyFIs+l6d3bQiBkuAw1FH8W6Zsa3jY1rC
         UlQXhz+PpYBp0CWPgtj9/+b4Vr9xWZuhdy9MIT1vOeh9/8mtgTT1LuDz0hGIaIwn0mPN
         SA4EV2jSXD5x1YTTCgsWmBe1vih4B3TKA4Um6MhrSM/oox2+suT+jb4m+kWNy40ICGJn
         ZhiJKncvzkMtdkYwqYT6zsLMmrs8/DMCgT1kkOzr5HmVcWwg4Hka/5pcPdOGVECulefk
         9cDlAkKd4vSBIFU+hSN4Ij8Lk1sAnBFJp0frs6jI7dvvREdK9ecNOfSiKOlZiC7MQ4z0
         UdbQ==
X-Gm-Message-State: AGi0PuYvlxZcv1PsuKB40nCmIz9g3BDZCRzDOP8eoNOgU4ad2SSVpSfS
        XOAjQxyFEssVph6Nrgw/VRI=
X-Google-Smtp-Source: APiQypJgOXFcMvlIkdPahhKgBDxDeiiL6LZlirTESZ3+XEmeI+2Vyo7ot3yQu7vx/0Pv9UGamNBMdQ==
X-Received: by 2002:a62:7f07:: with SMTP id a7mr4017877pfd.34.1588742092327;
        Tue, 05 May 2020 22:14:52 -0700 (PDT)
Received: from garuda.localnet ([122.171.200.101])
        by smtp.gmail.com with ESMTPSA id e135sm551170pfh.37.2020.05.05.22.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 22:14:51 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/28] xfs: refactor intent item iop_recover calls
Date:   Wed, 06 May 2020 10:44:49 +0530
Message-ID: <1832116.EI6kFzkkEO@garuda>
In-Reply-To: <158864118627.182683.12692460464900065895.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864118627.182683.12692460464900065895.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:43:06 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've made the recovered item tests all the same, we can hoist
> the test and the ail locking code to the ->iop_recover caller and call
> the recovery function directly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c     |   48 ++++++++++++--------------------------------
>  fs/xfs/xfs_extfree_item.c  |   44 ++++++++++------------------------------
>  fs/xfs/xfs_log_recover.c   |    8 ++++++-
>  fs/xfs/xfs_refcount_item.c |   46 +++++++++++-------------------------------
>  fs/xfs/xfs_rmap_item.c     |   45 +++++++++++------------------------------
>  5 files changed, 54 insertions(+), 137 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 8dd157fc44fa..8f0dc6d550d1 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -421,25 +421,26 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
>   * We need to update some inode's bmbt.
>   */
>  STATIC int
> -xfs_bui_recover(
> -	struct xfs_trans		*parent_tp,
> -	struct xfs_bui_log_item		*buip)
> +xfs_bui_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct xfs_trans		*parent_tp)
>  {
> -	int				error = 0;
> -	unsigned int			bui_type;
> +	struct xfs_bmbt_irec		irec;
> +	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
> +	struct xfs_trans		*tp;
> +	struct xfs_inode		*ip = NULL;
> +	struct xfs_mount		*mp = parent_tp->t_mountp;
>  	struct xfs_map_extent		*bmap;
> +	struct xfs_bud_log_item		*budp;
>  	xfs_fsblock_t			startblock_fsb;
>  	xfs_fsblock_t			inode_fsb;
>  	xfs_filblks_t			count;
> -	bool				op_ok;
> -	struct xfs_bud_log_item		*budp;
> +	xfs_exntst_t			state;
>  	enum xfs_bmap_intent_type	type;
> +	bool				op_ok;
> +	unsigned int			bui_type;
>  	int				whichfork;
> -	xfs_exntst_t			state;
> -	struct xfs_trans		*tp;
> -	struct xfs_inode		*ip = NULL;
> -	struct xfs_bmbt_irec		irec;
> -	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	int				error = 0;
>  
>  	ASSERT(!test_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags));
>  
> @@ -555,29 +556,6 @@ xfs_bui_recover(
>  	return error;
>  }
>  
> -/* Recover the BUI if necessary. */
> -STATIC int
> -xfs_bui_item_recover(
> -	struct xfs_log_item		*lip,
> -	struct xfs_trans		*tp)
> -{
> -	struct xfs_ail			*ailp = lip->li_ailp;
> -	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
> -	int				error;
> -
> -	/*
> -	 * Skip BUIs that we've already processed.
> -	 */
> -	if (test_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags))
> -		return 0;
> -
> -	spin_unlock(&ailp->ail_lock);
> -	error = xfs_bui_recover(tp, buip);
> -	spin_lock(&ailp->ail_lock);
> -
> -	return error;
> -}
> -
>  STATIC bool
>  xfs_bui_item_match(
>  	struct xfs_log_item	*lip,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 635c99fdda85..ec8a79fe6cab 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -581,16 +581,18 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
>   * the log.  We need to free the extents that it describes.
>   */
>  STATIC int
> -xfs_efi_recover(
> -	struct xfs_mount	*mp,
> -	struct xfs_efi_log_item	*efip)
> +xfs_efi_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct xfs_trans		*parent_tp)
>  {
> -	struct xfs_efd_log_item	*efdp;
> -	struct xfs_trans	*tp;
> -	int			i;
> -	int			error = 0;
> -	xfs_extent_t		*extp;
> -	xfs_fsblock_t		startblock_fsb;
> +	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
> +	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	struct xfs_efd_log_item		*efdp;
> +	struct xfs_trans		*tp;
> +	struct xfs_extent		*extp;
> +	xfs_fsblock_t			startblock_fsb;
> +	int				i;
> +	int				error = 0;
>  
>  	ASSERT(!test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags));
>  
> @@ -641,30 +643,6 @@ xfs_efi_recover(
>  	return error;
>  }
>  
> -/* Recover the EFI if necessary. */
> -STATIC int
> -xfs_efi_item_recover(
> -	struct xfs_log_item		*lip,
> -	struct xfs_trans		*tp)
> -{
> -	struct xfs_ail			*ailp = lip->li_ailp;
> -	struct xfs_efi_log_item		*efip;
> -	int				error;
> -
> -	/*
> -	 * Skip EFIs that we've already processed.
> -	 */
> -	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
> -	if (test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags))
> -		return 0;
> -
> -	spin_unlock(&ailp->ail_lock);
> -	error = xfs_efi_recover(tp->t_mountp, efip);
> -	spin_lock(&ailp->ail_lock);
> -
> -	return error;
> -}
> -
>  STATIC bool
>  xfs_efi_item_match(
>  	struct xfs_log_item	*lip,
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a2c03d87c374..8ff957da2845 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2667,7 +2667,7 @@ xlog_recover_process_intents(
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_log_item	*lip;
>  	struct xfs_ail		*ailp;
> -	int			error;
> +	int			error = 0;

'error' variable's value gets set unconditionally by the return value of
xfs_trans_alloc_empty(). Hence it does not need to be initialized
explicitly. This is also seen in the individual ->iop_recover() methods as
well (However those weren't set by this patch).

Apart from the above nit, the rest looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>  #if defined(DEBUG) || defined(XFS_WARN)
>  	xfs_lsn_t		last_lsn;
>  #endif
> @@ -2717,7 +2717,11 @@ xlog_recover_process_intents(
>  		 * this routine or else those subsequent intents will get
>  		 * replayed in the wrong order!
>  		 */
> -		error = lip->li_ops->iop_recover(lip, parent_tp);
> +		if (!test_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
> +			spin_unlock(&ailp->ail_lock);
> +			error = lip->li_ops->iop_recover(lip, parent_tp);
> +			spin_lock(&ailp->ail_lock);
> +		}
>  		if (error)
>  			goto out;
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 4b242b3b33a3..fab821fce76b 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -421,25 +421,26 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
>   * We need to update the refcountbt.
>   */
>  STATIC int
> -xfs_cui_recover(
> -	struct xfs_trans		*parent_tp,
> -	struct xfs_cui_log_item		*cuip)
> +xfs_cui_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct xfs_trans		*parent_tp)
>  {
> -	int				i;
> -	int				error = 0;
> -	unsigned int			refc_type;
> +	struct xfs_bmbt_irec		irec;
> +	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
>  	struct xfs_phys_extent		*refc;
> -	xfs_fsblock_t			startblock_fsb;
> -	bool				op_ok;
>  	struct xfs_cud_log_item		*cudp;
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*rcur = NULL;
> -	enum xfs_refcount_intent_type	type;
> +	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	xfs_fsblock_t			startblock_fsb;
>  	xfs_fsblock_t			new_fsb;
>  	xfs_extlen_t			new_len;
> -	struct xfs_bmbt_irec		irec;
> +	unsigned int			refc_type;
> +	bool				op_ok;
>  	bool				requeue_only = false;
> -	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	enum xfs_refcount_intent_type	type;
> +	int				i;
> +	int				error = 0;
>  
>  	ASSERT(!test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags));
>  
> @@ -568,29 +569,6 @@ xfs_cui_recover(
>  	return error;
>  }
>  
> -/* Recover the CUI if necessary. */
> -STATIC int
> -xfs_cui_item_recover(
> -	struct xfs_log_item		*lip,
> -	struct xfs_trans		*tp)
> -{
> -	struct xfs_ail			*ailp = lip->li_ailp;
> -	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
> -	int				error;
> -
> -	/*
> -	 * Skip CUIs that we've already processed.
> -	 */
> -	if (test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags))
> -		return 0;
> -
> -	spin_unlock(&ailp->ail_lock);
> -	error = xfs_cui_recover(tp, cuip);
> -	spin_lock(&ailp->ail_lock);
> -
> -	return error;
> -}
> -
>  STATIC bool
>  xfs_cui_item_match(
>  	struct xfs_log_item	*lip,
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 625eaf954d74..c9233a220551 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -464,21 +464,23 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
>   * We need to update the rmapbt.
>   */
>  STATIC int
> -xfs_rui_recover(
> -	struct xfs_mount		*mp,
> -	struct xfs_rui_log_item		*ruip)
> +xfs_rui_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct xfs_trans		*parent_tp)
>  {
> -	int				i;
> -	int				error = 0;
> +	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
>  	struct xfs_map_extent		*rmap;
> -	xfs_fsblock_t			startblock_fsb;
> -	bool				op_ok;
>  	struct xfs_rud_log_item		*rudp;
> -	enum xfs_rmap_intent_type	type;
> -	int				whichfork;
> -	xfs_exntst_t			state;
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*rcur = NULL;
> +	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	xfs_fsblock_t			startblock_fsb;
> +	enum xfs_rmap_intent_type	type;
> +	xfs_exntst_t			state;
> +	bool				op_ok;
> +	int				i;
> +	int				whichfork;
> +	int				error = 0;
>  
>  	ASSERT(!test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags));
>  
> @@ -583,29 +585,6 @@ xfs_rui_recover(
>  	return error;
>  }
>  
> -/* Recover the RUI if necessary. */
> -STATIC int
> -xfs_rui_item_recover(
> -	struct xfs_log_item		*lip,
> -	struct xfs_trans		*tp)
> -{
> -	struct xfs_ail			*ailp = lip->li_ailp;
> -	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
> -	int				error;
> -
> -	/*
> -	 * Skip RUIs that we've already processed.
> -	 */
> -	if (test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags))
> -		return 0;
> -
> -	spin_unlock(&ailp->ail_lock);
> -	error = xfs_rui_recover(tp->t_mountp, ruip);
> -	spin_lock(&ailp->ail_lock);
> -
> -	return error;
> -}
> -
>  STATIC bool
>  xfs_rui_item_match(
>  	struct xfs_log_item	*lip,
> 
> 


-- 
chandan



