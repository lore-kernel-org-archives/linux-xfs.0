Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DF0C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFEA3613C3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhE0SKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 14:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231226AbhE0SKG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 14:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 627E4613BE;
        Thu, 27 May 2021 18:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622138913;
        bh=DYpU7rPhNOKjDcL4/vxPxSqvo+QpwM3wfS6+hHmVrcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKchIoAwngv6b5no0YDdtqDGY51aPN86nk53nfdt7MZX61GhQuZ3I3oT/ehjAQNM0
         0Z8ptWkfPNo7k4K+5USQIwqAN7kW5ZM9Cp+SnLxAiAeNlRo938fT4tsOnEgVSe4wyv
         zj/O/Mdrzg7CfIw5CvQba3qy9BP1HOj7CuVmZkxn6kLJ71Q4CEb+meY0Swd/i14AJo
         mjl1U6ov23o6ElMk75KqQKLXmuXZ9td576vfsDy0df7wXcWacDaSwnB+k2P2ibo46J
         7TQmZTQKo2EcWFbuDZRr5YhkW35TMrmH6D086wiVYIvyxkHlcKZRUudn+HWA8USH8x
         qKzs5eHgb2law==
Date:   Thu, 27 May 2021 11:08:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/39] xfs: CIL context doesn't need to count iovecs
Message-ID: <20210527180833.GF2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-26-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-26-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:03PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we account for log opheaders in the log item formatting
> code, we don't actually use the aggregated count of log iovecs in
> the CIL for anything. Remove it and the tracking code that
> calculates it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good this time around,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c  | 22 ++++++----------------
>  fs/xfs/xfs_log_priv.h |  1 -
>  2 files changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index dbe3a8267e2f..eca5c82c0d60 100644
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
>  
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before we move
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index a16ffdc8ae97..02c94b6d0642 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -217,7 +217,6 @@ struct xfs_cil_ctx {
>  	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
>  	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
>  	struct xlog_ticket	*ticket;	/* chkpt ticket */
> -	int			nvecs;		/* number of regions */
>  	int			space_used;	/* aggregate size of regions */
>  	struct list_head	busy_extents;	/* busy extents in chkpt */
>  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
> -- 
> 2.31.1
> 
