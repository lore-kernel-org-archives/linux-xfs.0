Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2056EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 03:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32CC64F7C
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 03:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhCIDQc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 22:16:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229379AbhCIDQF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 22:16:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAFB165165;
        Tue,  9 Mar 2021 03:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615259765;
        bh=qcpVO6iG3mW0rqs4uRAW+eUH1Er1/CXQNtkJdMA81mY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PbcMWngIYlDa71Oghz3a0kqgIBQA/tS5FbSfAvxgbBoa5/zYmwgUY7ff1GBnPQ3Bl
         tSg4pz9+zRihIrnq9m8nT6SWUH5ua6mYwSwFCkQXHNOhVLzTJODv4IFkbgh0Bew9Ce
         P3RFXcIL1I42Z5rWNr+/BYjQ7Cb7ZvDsZx7PELQ4zHSIsCYhIOvmzc2QHC1V2o7JHv
         KYdr8FinVPZoQ0/7asSg0H3aa70yZtzrNWVWb47IzlU5cUv7m1FlpldGKnoMnLMG0Z
         cSTkT2Fi6+nc7V8+xfyoXO5WUHwlJ/J/BvJ9J9Ux+NzhKA+wpUnyN68DzIxsevlddk
         R+rS5yBy24xLw==
Date:   Mon, 8 Mar 2021 19:16:04 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/45] xfs: CIL context doesn't need to count iovecs
Message-ID: <20210309031604.GS3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-32-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-32-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:29PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we account for log opheaders in the log item formatting
> code, we don't actually use the aggregated count of log iovecs in
> the CIL for anything. Remove it and the tracking code that
> calculates it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 34abc3bae587..4047f95a0fc4 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -252,22 +252,18 @@ xlog_cil_alloc_shadow_bufs(
>  
>  /*
>   * Prepare the log item for insertion into the CIL. Calculate the difference in
> - * log space and vectors it will consume, and if it is a new item pin it as
> - * well.
> + * log space it will consume, and if it is a new item pin it as well.
>   */
>  STATIC void
>  xfs_cil_prepare_item(
>  	struct xlog		*log,
>  	struct xfs_log_vec	*lv,
>  	struct xfs_log_vec	*old_lv,
> -	int			*diff_len,
> -	int			*diff_iovecs)
> +	int			*diff_len)
>  {
>  	/* Account for the new LV being passed in */
> -	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
> +	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
>  		*diff_len += lv->lv_bytes;
> -		*diff_iovecs += lv->lv_niovecs;
> -	}
>  
>  	/*
>  	 * If there is no old LV, this is the first time we've seen the item in
> @@ -284,7 +280,6 @@ xfs_cil_prepare_item(
>  		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
>  
>  		*diff_len -= old_lv->lv_bytes;
> -		*diff_iovecs -= old_lv->lv_niovecs;
>  		lv->lv_item->li_lv_shadow = old_lv;
>  	}
>  
> @@ -333,12 +328,10 @@ static void
>  xlog_cil_insert_format_items(
>  	struct xlog		*log,
>  	struct xfs_trans	*tp,
> -	int			*diff_len,
> -	int			*diff_iovecs)
> +	int			*diff_len)
>  {
>  	struct xfs_log_item	*lip;
>  
> -
>  	/* Bail out if we didn't find a log item.  */
>  	if (list_empty(&tp->t_items)) {
>  		ASSERT(0);
> @@ -381,7 +374,6 @@ xlog_cil_insert_format_items(
>  			 * set the item up as though it is a new insertion so
>  			 * that the space reservation accounting is correct.
>  			 */
> -			*diff_iovecs -= lv->lv_niovecs;
>  			*diff_len -= lv->lv_bytes;
>  
>  			/* Ensure the lv is set up according to ->iop_size */
> @@ -406,7 +398,7 @@ xlog_cil_insert_format_items(
>  		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
>  		lip->li_ops->iop_format(lip, lv);
>  insert:
> -		xfs_cil_prepare_item(log, lv, old_lv, diff_len, diff_iovecs);
> +		xfs_cil_prepare_item(log, lv, old_lv, diff_len);
>  	}
>  }
>  
> @@ -426,7 +418,6 @@ xlog_cil_insert_items(
>  	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
>  	struct xfs_log_item	*lip;
>  	int			len = 0;
> -	int			diff_iovecs = 0;
>  	int			iclog_space;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
>  
> @@ -436,7 +427,7 @@ xlog_cil_insert_items(
>  	 * We can do this safely because the context can't checkpoint until we
>  	 * are done so it doesn't matter exactly how we update the CIL.
>  	 */
> -	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
> +	xlog_cil_insert_format_items(log, tp, &len);
>  
>  	spin_lock(&cil->xc_cil_lock);
>  
> @@ -471,7 +462,6 @@ xlog_cil_insert_items(
>  	}
>  	tp->t_ticket->t_curr_res -= len;
>  	ctx->space_used += len;
> -	ctx->nvecs += diff_iovecs;

If the tracking variable isn't necessary any more, should the field go
away from xfs_cil_ctx?

--D

>  
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before we move
> -- 
> 2.28.0
> 
