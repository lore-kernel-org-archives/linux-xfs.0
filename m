Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E5EFC47256
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 07:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2824206B8
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 07:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATKiOjKU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgEEHOV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 03:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgEEHOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 03:14:21 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B2CC061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 00:14:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r4so636864pgg.4
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 00:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yh3D+xG5ztTnfxF6hUQepEO1pgUeS+rYqP+xWd/9Pic=;
        b=ATKiOjKU3+lgeJn1jck1P2YF4mQ1tCkWLh7duF2mFMX73BEOQ4Bs0SDc3MnynwmEFV
         DRbgwYLNH52/TuQPlXxB+lumOQGQF3OF6npH/0PXdRsBAHA8T+vzz6P77XSk1OmkKdkt
         wAxOs2Uvgk01lD8D2EjJjxjbn48vk31mn3ZbVLS4jV26JQrSnmFzkOaEx0ELBDqFdqHX
         l4PxJKU5Rr9W751TSeOg9Arzb2mKyJnLNQ3+LFiFDXhK1Thg9FAPR6S4xyGE/IDjHDOx
         7T9wVtUw09xJCBIfqX4myJk+hz4xqSsPKEsJngyqwAC0t4QCYhvczuodm7Piy0MZKZ/y
         6DMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yh3D+xG5ztTnfxF6hUQepEO1pgUeS+rYqP+xWd/9Pic=;
        b=B0Nz7pM9nsg04VU0V0YLIBgUJAG6wBWJzVL0YyLYibRDlVinYmh28svZ67sJdCafXm
         L3kHOaE1va7kiUx2N5nv00JED0CK93EzKObqObBlfcwv3R3no2HIsbLYI8zqyB7faLF1
         O11MZ5/894XDb5Znq6MCfC6Ah0AZ/CErG8Kat+KMRNYyEMeJKHXf2n8jqfh+1U6W1HnK
         4lQewsu4Yq0Aq5h+wilVxnha7X6X343+kxEk+vaHUY/luaNSZs/33gAUIi5Towx3IuCB
         BkT8VlfvSQv0WZhaCnTA5SHrWNI8DkkO2zvhR2h/Sh2oWo+Pd569932QvEqCnVt57/m2
         1e9g==
X-Gm-Message-State: AGi0PuYnG1qTouN8hQ99eKcriJtNKHIF0a+wbnqQqcKTYUrOnFw9LsJ+
        wEdaZ50YcW3Oy0RdvLoF20Zbq9TFYqI=
X-Google-Smtp-Source: APiQypJ/kjA0NRZM4XPby1wRte8RpAZoLxFEcp9lOQkccCd0UJ+Gcx1tBJEz+cjsdEp9DLmdX4ujRA==
X-Received: by 2002:a62:7656:: with SMTP id r83mr1759968pfc.71.1588662860558;
        Tue, 05 May 2020 00:14:20 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id w126sm1121835pfb.117.2020.05.05.00.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 00:14:19 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/28] xfs: refactor log recovery BUI item dispatch for pass2 commit functions
Date:   Tue, 05 May 2020 12:44:17 +0530
Message-ID: <4542754.OeGbJGjiOF@garuda>
In-Reply-To: <158864110754.182683.16207546218311436217.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864110754.182683.16207546218311436217.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:41:47 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the bmap update intent and intent-done pass2 commit code into the
> per-item source code files and use dispatch functions to call them.  We
> do these one at a time because there's a lot of code to move.  No
> functional changes.
>

BUI/BUD item pass2 processing is functionally consistent with what was done
before this patch is applied.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c   |  133 +++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_bmap_item.h   |    2 -
>  fs/xfs/xfs_log_recover.c |  128 --------------------------------------------
>  3 files changed, 131 insertions(+), 132 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 42354403fec7..0fbebef69e26 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -22,6 +22,7 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_error.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_bui_zone;
> @@ -32,7 +33,7 @@ static inline struct xfs_bui_log_item *BUI_ITEM(struct xfs_log_item *lip)
>  	return container_of(lip, struct xfs_bui_log_item, bui_item);
>  }
>  
> -void
> +STATIC void
>  xfs_bui_item_free(
>  	struct xfs_bui_log_item	*buip)
>  {
> @@ -135,7 +136,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
>  /*
>   * Allocate and initialize an bui item with the given number of extents.
>   */
> -struct xfs_bui_log_item *
> +STATIC struct xfs_bui_log_item *
>  xfs_bui_init(
>  	struct xfs_mount		*mp)
>  
> @@ -559,10 +560,138 @@ xfs_bui_recover(
>  	return error;
>  }
>  
> +/*
> + * Copy an BUI format buffer from the given buf, and into the destination
> + * BUI format structure.  The BUI/BUD items were designed not to need any
> + * special alignment handling.
> + */
> +static int
> +xfs_bui_copy_format(
> +	struct xfs_log_iovec		*buf,
> +	struct xfs_bui_log_format	*dst_bui_fmt)
> +{
> +	struct xfs_bui_log_format	*src_bui_fmt;
> +	uint				len;
> +
> +	src_bui_fmt = buf->i_addr;
> +	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
> +
> +	if (buf->i_len == len) {
> +		memcpy(dst_bui_fmt, src_bui_fmt, len);
> +		return 0;
> +	}
> +	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> +	return -EFSCORRUPTED;
> +}
> +
> +/*
> + * This routine is called to create an in-core extent bmap update
> + * item from the bui format structure which was logged on disk.
> + * It allocates an in-core bui, copies the extents from the format
> + * structure into it, and adds the bui to the AIL with the given
> + * LSN.
> + */
> +STATIC int
> +xlog_recover_bmap_intent_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	int				error;
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_bui_log_item		*buip;
> +	struct xfs_bui_log_format	*bui_formatp;
> +
> +	bui_formatp = item->ri_buf[0].i_addr;
> +
> +	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		return -EFSCORRUPTED;
> +	}
> +	buip = xfs_bui_init(mp);
> +	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
> +	if (error) {
> +		xfs_bui_item_free(buip);
> +		return error;
> +	}
> +	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
> +
> +	spin_lock(&log->l_ailp->ail_lock);
> +	/*
> +	 * The RUI has two references. One for the RUD and one for RUI to ensure
> +	 * it makes it into the AIL. Insert the RUI into the AIL directly and
> +	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
> +	 * AIL lock.
> +	 */
> +	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
> +	xfs_bui_release(buip);
> +	return 0;
> +}
> +
>  const struct xlog_recover_item_ops xlog_bmap_intent_item_ops = {
>  	.item_type		= XFS_LI_BUI,
> +	.commit_pass2		= xlog_recover_bmap_intent_commit_pass2,
>  };
>  
> +/*
> + * This routine is called when an BUD format structure is found in a committed
> + * transaction in the log. Its purpose is to cancel the corresponding BUI if it
> + * was still in the log. To do this it searches the AIL for the BUI with an id
> + * equal to that in the BUD format structure. If we find it we drop the BUD
> + * reference, which removes the BUI from the AIL and frees it.
> + */
> +STATIC int
> +xlog_recover_bmap_done_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_bud_log_format	*bud_formatp;
> +	struct xfs_bui_log_item		*buip = NULL;
> +	struct xfs_log_item		*lip;
> +	uint64_t			bui_id;
> +	struct xfs_ail_cursor		cur;
> +	struct xfs_ail			*ailp = log->l_ailp;
> +
> +	bud_formatp = item->ri_buf[0].i_addr;
> +	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		return -EFSCORRUPTED;
> +	}
> +	bui_id = bud_formatp->bud_bui_id;
> +
> +	/*
> +	 * Search for the BUI with the id in the BUD format structure in the
> +	 * AIL.
> +	 */
> +	spin_lock(&ailp->ail_lock);
> +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	while (lip != NULL) {
> +		if (lip->li_type == XFS_LI_BUI) {
> +			buip = (struct xfs_bui_log_item *)lip;
> +			if (buip->bui_format.bui_id == bui_id) {
> +				/*
> +				 * Drop the BUD reference to the BUI. This
> +				 * removes the BUI from the AIL and frees it.
> +				 */
> +				spin_unlock(&ailp->ail_lock);
> +				xfs_bui_release(buip);
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
>  const struct xlog_recover_item_ops xlog_bmap_done_item_ops = {
>  	.item_type		= XFS_LI_BUD,
> +	.commit_pass2		= xlog_recover_bmap_done_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
> index ad479cc73de8..515b1d5d6ab7 100644
> --- a/fs/xfs/xfs_bmap_item.h
> +++ b/fs/xfs/xfs_bmap_item.h
> @@ -74,8 +74,6 @@ struct xfs_bud_log_item {
>  extern struct kmem_zone	*xfs_bui_zone;
>  extern struct kmem_zone	*xfs_bud_zone;
>  
> -struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
> -void xfs_bui_item_free(struct xfs_bui_log_item *);
>  void xfs_bui_release(struct xfs_bui_log_item *);
>  int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 23008b7cf93c..a5158e9e0662 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2034,130 +2034,6 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> -/*
> - * Copy an BUI format buffer from the given buf, and into the destination
> - * BUI format structure.  The BUI/BUD items were designed not to need any
> - * special alignment handling.
> - */
> -static int
> -xfs_bui_copy_format(
> -	struct xfs_log_iovec		*buf,
> -	struct xfs_bui_log_format	*dst_bui_fmt)
> -{
> -	struct xfs_bui_log_format	*src_bui_fmt;
> -	uint				len;
> -
> -	src_bui_fmt = buf->i_addr;
> -	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
> -
> -	if (buf->i_len == len) {
> -		memcpy(dst_bui_fmt, src_bui_fmt, len);
> -		return 0;
> -	}
> -	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> -	return -EFSCORRUPTED;
> -}
> -
> -/*
> - * This routine is called to create an in-core extent bmap update
> - * item from the bui format structure which was logged on disk.
> - * It allocates an in-core bui, copies the extents from the format
> - * structure into it, and adds the bui to the AIL with the given
> - * LSN.
> - */
> -STATIC int
> -xlog_recover_bui_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item,
> -	xfs_lsn_t			lsn)
> -{
> -	int				error;
> -	struct xfs_mount		*mp = log->l_mp;
> -	struct xfs_bui_log_item		*buip;
> -	struct xfs_bui_log_format	*bui_formatp;
> -
> -	bui_formatp = item->ri_buf[0].i_addr;
> -
> -	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> -		return -EFSCORRUPTED;
> -	}
> -	buip = xfs_bui_init(mp);
> -	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
> -	if (error) {
> -		xfs_bui_item_free(buip);
> -		return error;
> -	}
> -	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
> -
> -	spin_lock(&log->l_ailp->ail_lock);
> -	/*
> -	 * The RUI has two references. One for the RUD and one for RUI to ensure
> -	 * it makes it into the AIL. Insert the RUI into the AIL directly and
> -	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
> -	 * AIL lock.
> -	 */
> -	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
> -	xfs_bui_release(buip);
> -	return 0;
> -}
> -
> -
> -/*
> - * This routine is called when an BUD format structure is found in a committed
> - * transaction in the log. Its purpose is to cancel the corresponding BUI if it
> - * was still in the log. To do this it searches the AIL for the BUI with an id
> - * equal to that in the BUD format structure. If we find it we drop the BUD
> - * reference, which removes the BUI from the AIL and frees it.
> - */
> -STATIC int
> -xlog_recover_bud_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item)
> -{
> -	struct xfs_bud_log_format	*bud_formatp;
> -	struct xfs_bui_log_item		*buip = NULL;
> -	struct xfs_log_item		*lip;
> -	uint64_t			bui_id;
> -	struct xfs_ail_cursor		cur;
> -	struct xfs_ail			*ailp = log->l_ailp;
> -
> -	bud_formatp = item->ri_buf[0].i_addr;
> -	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> -		return -EFSCORRUPTED;
> -	}
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
> -
> -	return 0;
> -}
> -
>  STATIC int
>  xlog_recover_commit_pass2(
>  	struct xlog			*log,
> @@ -2172,10 +2048,6 @@ xlog_recover_commit_pass2(
>  				trans->r_lsn);
>  
>  	switch (ITEM_TYPE(item)) {
> -	case XFS_LI_BUI:
> -		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
> -	case XFS_LI_BUD:
> -		return xlog_recover_bud_pass2(log, item);
>  	case XFS_LI_QUOTAOFF:
>  		/* nothing to do in pass2 */
>  		return 0;
> 
> 


-- 
chandan



