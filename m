Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6995C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 03:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiD0DSs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239226AbiD0DSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 23:18:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ABB1658A
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 20:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B0BFB824A0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 03:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15E3C385A0;
        Wed, 27 Apr 2022 03:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651029331;
        bh=RaVwNCQuu3vFNa6hdr8s+OZiMyueyIOB+1XRPSFm7jQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=utfFf9j+cn3AExuugMtFXFbBuHj3kSG5EjzEWXDZFiwr8T97KcR+2Yi25t3IQd1Oh
         P6Dm85HiglsfkclrXT66P6i4Nnuv0Q/omvnG1fleYl6k0kNH04+5TZv3TRNrzU+N6X
         N9wQN5z0IV8pv/PfPBXnnXRXk8tFsRCpBG0IYjPJiwuoSBcOFWRD9QEWljSefuuYYB
         9pL8bOucv+oC5RMQfhPbeWNGtNZshi1aOPdyKFmLeqRjR6mBt6SH3D1azdodlm05Bp
         sUXvgEiixrDd4RiDM9qbUstD+WyWgZSfftLHhP9Na/A1wJ0KjKDx7tNGZxbLs9L2+c
         djUZZNFydMNnQ==
Date:   Tue, 26 Apr 2022 20:15:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor and move some code in xfs_log_cil.c
Message-ID: <20220427031530.GE17025@magnolia>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 12:22:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In preparation for adding support for intent item whiteouts.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks like a straight hoist?
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c | 119 ++++++++++++++++++++++++-------------------
>  1 file changed, 67 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index e5ab62f08c19..0d8d092447ad 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -47,6 +47,38 @@ xlog_cil_ticket_alloc(
>  	return tic;
>  }
>  
> +/*
> + * Check if the current log item was first committed in this sequence.
> + * We can't rely on just the log item being in the CIL, we have to check
> + * the recorded commit sequence number.
> + *
> + * Note: for this to be used in a non-racy manner, it has to be called with
> + * CIL flushing locked out. As a result, it should only be used during the
> + * transaction commit process when deciding what to format into the item.
> + */
> +static bool
> +xlog_item_in_current_chkpt(
> +	struct xfs_cil		*cil,
> +	struct xfs_log_item	*lip)
> +{
> +	if (list_empty(&lip->li_cil))
> +		return false;
> +
> +	/*
> +	 * li_seq is written on the first commit of a log item to record the
> +	 * first checkpoint it is written to. Hence if it is different to the
> +	 * current sequence, we're in a new checkpoint.
> +	 */
> +	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
> +}
> +
> +bool
> +xfs_log_item_in_current_chkpt(
> +	struct xfs_log_item *lip)
> +{
> +	return xlog_item_in_current_chkpt(lip->li_log->l_cilp, lip);
> +}
> +
>  /*
>   * Unavoidable forward declaration - xlog_cil_push_work() calls
>   * xlog_cil_ctx_alloc() itself.
> @@ -934,6 +966,40 @@ xlog_cil_build_trans_hdr(
>  	tic->t_curr_res -= lvhdr->lv_bytes;
>  }
>  
> +/*
> + * Pull all the log vectors off the items in the CIL, and remove the items from
> + * the CIL. We don't need the CIL lock here because it's only needed on the
> + * transaction commit side which is currently locked out by the flush lock.
> + */
> +static void
> +xlog_cil_build_lv_chain(
> +	struct xfs_cil		*cil,
> +	struct xfs_cil_ctx	*ctx,
> +	uint32_t		*num_iovecs,
> +	uint32_t		*num_bytes)
> +{
> +	struct xfs_log_vec	*lv = NULL;
> +
> +	while (!list_empty(&cil->xc_cil)) {
> +		struct xfs_log_item	*item;
> +
> +		item = list_first_entry(&cil->xc_cil,
> +					struct xfs_log_item, li_cil);
> +		list_del_init(&item->li_cil);
> +		if (!ctx->lv_chain)
> +			ctx->lv_chain = item->li_lv;
> +		else
> +			lv->lv_next = item->li_lv;
> +		lv = item->li_lv;
> +		item->li_lv = NULL;
> +		*num_iovecs += lv->lv_niovecs;
> +
> +		/* we don't write ordered log vectors */
> +		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> +			*num_bytes += lv->lv_bytes;
> +	}
> +}
> +
>  /*
>   * Push the Committed Item List to the log.
>   *
> @@ -956,7 +1022,6 @@ xlog_cil_push_work(
>  		container_of(work, struct xfs_cil_ctx, push_work);
>  	struct xfs_cil		*cil = ctx->cil;
>  	struct xlog		*log = cil->xc_log;
> -	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*new_ctx;
>  	int			num_iovecs = 0;
>  	int			num_bytes = 0;
> @@ -1033,31 +1098,7 @@ xlog_cil_push_work(
>  	list_add(&ctx->committing, &cil->xc_committing);
>  	spin_unlock(&cil->xc_push_lock);
>  
> -	/*
> -	 * Pull all the log vectors off the items in the CIL, and remove the
> -	 * items from the CIL. We don't need the CIL lock here because it's only
> -	 * needed on the transaction commit side which is currently locked out
> -	 * by the flush lock.
> -	 */
> -	lv = NULL;
> -	while (!list_empty(&cil->xc_cil)) {
> -		struct xfs_log_item	*item;
> -
> -		item = list_first_entry(&cil->xc_cil,
> -					struct xfs_log_item, li_cil);
> -		list_del_init(&item->li_cil);
> -		if (!ctx->lv_chain)
> -			ctx->lv_chain = item->li_lv;
> -		else
> -			lv->lv_next = item->li_lv;
> -		lv = item->li_lv;
> -		item->li_lv = NULL;
> -		num_iovecs += lv->lv_niovecs;
> -
> -		/* we don't write ordered log vectors */
> -		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> -			num_bytes += lv->lv_bytes;
> -	}
> +	xlog_cil_build_lv_chain(cil, ctx, &num_iovecs, &num_bytes);
>  
>  	/*
>  	 * Switch the contexts so we can drop the context lock and move out
> @@ -1508,32 +1549,6 @@ xlog_cil_force_seq(
>  	return 0;
>  }
>  
> -/*
> - * Check if the current log item was first committed in this sequence.
> - * We can't rely on just the log item being in the CIL, we have to check
> - * the recorded commit sequence number.
> - *
> - * Note: for this to be used in a non-racy manner, it has to be called with
> - * CIL flushing locked out. As a result, it should only be used during the
> - * transaction commit process when deciding what to format into the item.
> - */
> -bool
> -xfs_log_item_in_current_chkpt(
> -	struct xfs_log_item	*lip)
> -{
> -	struct xfs_cil		*cil = lip->li_log->l_cilp;
> -
> -	if (list_empty(&lip->li_cil))
> -		return false;
> -
> -	/*
> -	 * li_seq is written on the first commit of a log item to record the
> -	 * first checkpoint it is written to. Hence if it is different to the
> -	 * current sequence, we're in a new checkpoint.
> -	 */
> -	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
> -}
> -
>  /*
>   * Perform initial CIL structure initialisation.
>   */
> -- 
> 2.35.1
> 
