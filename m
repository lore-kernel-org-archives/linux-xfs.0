Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE33C47256
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 07:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 900C2206A5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 07:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUP6FfUb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEHG5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 03:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgEEHG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 03:06:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7A6C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 00:06:56 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 18so440352pfv.8
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 00:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ju5UtYnQ/Ab2e4GMXDeEH9TZax5mtRPVCv12RPhseaM=;
        b=LUP6FfUbwm6jaqXN5F1V5ifiN5/NHGJF9758s7l5PujboOk5aMB5cP+XYeBx80tFP4
         3Zsq9oa7qSQqU2VdYGLOCl2m0Lflx1uWLN7RR3QYv0iAJT5AGfErjpwDIQ0g52KnvJAC
         MkuosA6fo9csgX9KAC9tpwv/DYDHAkE+cGEOdRZ6Oyg3UtYp9oE9jAH7Euu+r6N0TfT8
         rhKT5leTj/RoxtCOnXOh40upwcvgRmFtsPnb0NJy2GcYOLLt3QOnXvoYQUKZESso2S7L
         CEOvXEBAfCciO3PWTzIgaYGYlVWysXUjP2DUFDgoPVOnIaiRV7Wr2pFSIlfjGR42wLWs
         +q+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ju5UtYnQ/Ab2e4GMXDeEH9TZax5mtRPVCv12RPhseaM=;
        b=jbZQVdOM9f6Tg8qT6znN0hSwWgKOPp0p2AkIpjaqunwcbvxqskICCXEyvyGsN3bwVb
         naKPaF0pQPrXnN91Re+5wOO4XP3a5SHM9ikrDMp+42hSpP8BBlrDyzNmliKdCp3lpSYM
         dm0IGWZ7Gn7nrmYOvnos0FpGX6wYGKSgkL4qbwzskC743iwzUr8iTUkIp5dPEL1cAQN0
         UBboBwSpE+4rL0rT1p3TUGkA0KzHdQu5jco3z6kdYU2fImSdDpRuei5b16y397isZWXn
         L3wosh2NAbws1p95VYGpWIHTcXzOeu7NYT044DnJTtxX6NhxpYk2+JrkPqlgPjhvuJL/
         +ebA==
X-Gm-Message-State: AGi0PuZwJvUL3PCkWy1jKpFefPIIHO9pUEArrSO/pKaEgt/yQx5hYZQO
        9lNxVgugdaBlCMs8RcE9sbEQX7dXVfk=
X-Google-Smtp-Source: APiQypLJRNdLLiakltHg2hmt9NtTNhpgOHbN5nObqskoylC1br4ZWXR4iyRDRGSu96G+I2pOoMwC9Q==
X-Received: by 2002:a63:111e:: with SMTP id g30mr1715319pgl.446.1588662416095;
        Tue, 05 May 2020 00:06:56 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id o1sm1035373pjs.39.2020.05.05.00.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 00:06:55 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/28] xfs: refactor log recovery CUI item dispatch for pass2 commit functions
Date:   Tue, 05 May 2020 12:36:52 +0530
Message-ID: <2032661.Ojnu08z7lC@garuda>
In-Reply-To: <158864110138.182683.14407149575371476288.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864110138.182683.14407149575371476288.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:41:41 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the refcount update intent and intent-done pass2 commit code into
> the per-item source code files and use dispatch functions to call them.
> We do these one at a time because there's a lot of code to move.  No
> functional changes.
>

CUI/CUD item pass2 processing is functionally consistent with what was done
before this patch is applied.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log_recover.c   |  124 ------------------------------------------
>  fs/xfs/xfs_refcount_item.c |  129 +++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_refcount_item.h |    2 -
>  3 files changed, 127 insertions(+), 128 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 0c0ce7bfc30e..23008b7cf93c 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2034,126 +2034,6 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> -/*
> - * Copy an CUI format buffer from the given buf, and into the destination
> - * CUI format structure.  The CUI/CUD items were designed not to need any
> - * special alignment handling.
> - */
> -static int
> -xfs_cui_copy_format(
> -	struct xfs_log_iovec		*buf,
> -	struct xfs_cui_log_format	*dst_cui_fmt)
> -{
> -	struct xfs_cui_log_format	*src_cui_fmt;
> -	uint				len;
> -
> -	src_cui_fmt = buf->i_addr;
> -	len = xfs_cui_log_format_sizeof(src_cui_fmt->cui_nextents);
> -
> -	if (buf->i_len == len) {
> -		memcpy(dst_cui_fmt, src_cui_fmt, len);
> -		return 0;
> -	}
> -	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> -	return -EFSCORRUPTED;
> -}
> -
> -/*
> - * This routine is called to create an in-core extent refcount update
> - * item from the cui format structure which was logged on disk.
> - * It allocates an in-core cui, copies the extents from the format
> - * structure into it, and adds the cui to the AIL with the given
> - * LSN.
> - */
> -STATIC int
> -xlog_recover_cui_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item,
> -	xfs_lsn_t			lsn)
> -{
> -	int				error;
> -	struct xfs_mount		*mp = log->l_mp;
> -	struct xfs_cui_log_item		*cuip;
> -	struct xfs_cui_log_format	*cui_formatp;
> -
> -	cui_formatp = item->ri_buf[0].i_addr;
> -
> -	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
> -	error = xfs_cui_copy_format(&item->ri_buf[0], &cuip->cui_format);
> -	if (error) {
> -		xfs_cui_item_free(cuip);
> -		return error;
> -	}
> -	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
> -
> -	spin_lock(&log->l_ailp->ail_lock);
> -	/*
> -	 * The CUI has two references. One for the CUD and one for CUI to ensure
> -	 * it makes it into the AIL. Insert the CUI into the AIL directly and
> -	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
> -	 * AIL lock.
> -	 */
> -	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
> -	xfs_cui_release(cuip);
> -	return 0;
> -}
> -
> -
> -/*
> - * This routine is called when an CUD format structure is found in a committed
> - * transaction in the log. Its purpose is to cancel the corresponding CUI if it
> - * was still in the log. To do this it searches the AIL for the CUI with an id
> - * equal to that in the CUD format structure. If we find it we drop the CUD
> - * reference, which removes the CUI from the AIL and frees it.
> - */
> -STATIC int
> -xlog_recover_cud_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item)
> -{
> -	struct xfs_cud_log_format	*cud_formatp;
> -	struct xfs_cui_log_item		*cuip = NULL;
> -	struct xfs_log_item		*lip;
> -	uint64_t			cui_id;
> -	struct xfs_ail_cursor		cur;
> -	struct xfs_ail			*ailp = log->l_ailp;
> -
> -	cud_formatp = item->ri_buf[0].i_addr;
> -	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> -		return -EFSCORRUPTED;
> -	}
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
> -
> -	return 0;
> -}
> -
>  /*
>   * Copy an BUI format buffer from the given buf, and into the destination
>   * BUI format structure.  The BUI/BUD items were designed not to need any
> @@ -2292,10 +2172,6 @@ xlog_recover_commit_pass2(
>  				trans->r_lsn);
>  
>  	switch (ITEM_TYPE(item)) {
> -	case XFS_LI_CUI:
> -		return xlog_recover_cui_pass2(log, item, trans->r_lsn);
> -	case XFS_LI_CUD:
> -		return xlog_recover_cud_pass2(log, item);
>  	case XFS_LI_BUI:
>  		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_BUD:
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 0e8e8bab4344..28b41f5dd6bc 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -18,6 +18,7 @@
>  #include "xfs_log.h"
>  #include "xfs_refcount.h"
>  #include "xfs_error.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_cui_zone;
> @@ -28,7 +29,7 @@ static inline struct xfs_cui_log_item *CUI_ITEM(struct xfs_log_item *lip)
>  	return container_of(lip, struct xfs_cui_log_item, cui_item);
>  }
>  
> -void
> +STATIC void
>  xfs_cui_item_free(
>  	struct xfs_cui_log_item	*cuip)
>  {
> @@ -134,7 +135,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
>  /*
>   * Allocate and initialize an cui item with the given number of extents.
>   */
> -struct xfs_cui_log_item *
> +STATIC struct xfs_cui_log_item *
>  xfs_cui_init(
>  	struct xfs_mount		*mp,
>  	uint				nextents)
> @@ -572,10 +573,134 @@ xfs_cui_recover(
>  	return error;
>  }
>  
> +/*
> + * Copy an CUI format buffer from the given buf, and into the destination
> + * CUI format structure.  The CUI/CUD items were designed not to need any
> + * special alignment handling.
> + */
> +static int
> +xfs_cui_copy_format(
> +	struct xfs_log_iovec		*buf,
> +	struct xfs_cui_log_format	*dst_cui_fmt)
> +{
> +	struct xfs_cui_log_format	*src_cui_fmt;
> +	uint				len;
> +
> +	src_cui_fmt = buf->i_addr;
> +	len = xfs_cui_log_format_sizeof(src_cui_fmt->cui_nextents);
> +
> +	if (buf->i_len == len) {
> +		memcpy(dst_cui_fmt, src_cui_fmt, len);
> +		return 0;
> +	}
> +	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> +	return -EFSCORRUPTED;
> +}
> +
> +/*
> + * This routine is called to create an in-core extent refcount update
> + * item from the cui format structure which was logged on disk.
> + * It allocates an in-core cui, copies the extents from the format
> + * structure into it, and adds the cui to the AIL with the given
> + * LSN.
> + */
> +STATIC int
> +xlog_recover_refcount_intent_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	int				error;
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_cui_log_item		*cuip;
> +	struct xfs_cui_log_format	*cui_formatp;
> +
> +	cui_formatp = item->ri_buf[0].i_addr;
> +
> +	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
> +	error = xfs_cui_copy_format(&item->ri_buf[0], &cuip->cui_format);
> +	if (error) {
> +		xfs_cui_item_free(cuip);
> +		return error;
> +	}
> +	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
> +
> +	spin_lock(&log->l_ailp->ail_lock);
> +	/*
> +	 * The CUI has two references. One for the CUD and one for CUI to ensure
> +	 * it makes it into the AIL. Insert the CUI into the AIL directly and
> +	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
> +	 * AIL lock.
> +	 */
> +	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
> +	xfs_cui_release(cuip);
> +	return 0;
> +}
> +
>  const struct xlog_recover_item_ops xlog_refcount_intent_item_ops = {
>  	.item_type		= XFS_LI_CUI,
> +	.commit_pass2		= xlog_recover_refcount_intent_commit_pass2,
>  };
>  
> +/*
> + * This routine is called when an CUD format structure is found in a committed
> + * transaction in the log. Its purpose is to cancel the corresponding CUI if it
> + * was still in the log. To do this it searches the AIL for the CUI with an id
> + * equal to that in the CUD format structure. If we find it we drop the CUD
> + * reference, which removes the CUI from the AIL and frees it.
> + */
> +STATIC int
> +xlog_recover_refcount_done_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_cud_log_format	*cud_formatp;
> +	struct xfs_cui_log_item		*cuip = NULL;
> +	struct xfs_log_item		*lip;
> +	uint64_t			cui_id;
> +	struct xfs_ail_cursor		cur;
> +	struct xfs_ail			*ailp = log->l_ailp;
> +
> +	cud_formatp = item->ri_buf[0].i_addr;
> +	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		return -EFSCORRUPTED;
> +	}
> +	cui_id = cud_formatp->cud_cui_id;
> +
> +	/*
> +	 * Search for the CUI with the id in the CUD format structure in the
> +	 * AIL.
> +	 */
> +	spin_lock(&ailp->ail_lock);
> +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	while (lip != NULL) {
> +		if (lip->li_type == XFS_LI_CUI) {
> +			cuip = (struct xfs_cui_log_item *)lip;
> +			if (cuip->cui_format.cui_id == cui_id) {
> +				/*
> +				 * Drop the CUD reference to the CUI. This
> +				 * removes the CUI from the AIL and frees it.
> +				 */
> +				spin_unlock(&ailp->ail_lock);
> +				xfs_cui_release(cuip);
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
>  const struct xlog_recover_item_ops xlog_refcount_done_item_ops = {
>  	.item_type		= XFS_LI_CUD,
> +	.commit_pass2		= xlog_recover_refcount_done_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> index e47530f30489..ebe12779eaac 100644
> --- a/fs/xfs/xfs_refcount_item.h
> +++ b/fs/xfs/xfs_refcount_item.h
> @@ -77,8 +77,6 @@ struct xfs_cud_log_item {
>  extern struct kmem_zone	*xfs_cui_zone;
>  extern struct kmem_zone	*xfs_cud_zone;
>  
> -struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
> -void xfs_cui_item_free(struct xfs_cui_log_item *);
>  void xfs_cui_release(struct xfs_cui_log_item *);
>  int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
>  
> 
> 


-- 
chandan



