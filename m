Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917C8C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 19:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C1CF613AB
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 19:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhE0TQa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 15:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhE0TQa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 15:16:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0119D6135F;
        Thu, 27 May 2021 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622142897;
        bh=ppMy4Bew9e2YWvnIyVIPcx4ct+cUXVraO6JIlBZ2KCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VXWgC/RV7so8hPlF8puOyhWotuVmQ7AstbbfjT5eRu0h6KxFOxxld/XO2r3jxIGUA
         5iAxX/O/H6moAo4FR6HaA6ZHLTfTrUY863WI03DmhipjtLwnskiUX9nnfQg3qgbufe
         EBaED8Uh7el//CaPWe1yNUhZffck59O1N+sTzSymFXbcVGC2b7G6+K1vNBxTvvdMW1
         UzCUEAmfN1q0AHgla1QhLyJ3pgfr2fwifSZK3a3+D04A9FM6xKpbLPTiDTBKIidfDr
         qK+KFB7SNJ97W2pN9Qn6G7qFNsruyvJsDZeawNmcpKC9nWryDcxuR63BmDmxgO31Wz
         3RDWOeeDfl4rQ==
Date:   Thu, 27 May 2021 12:14:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/39] xfs: move CIL ordering to the logvec chain
Message-ID: <20210527191456.GN2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-37-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-37-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:14PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Adding a list_sort() call to the CIL push work while the xc_ctx_lock
> is held exclusively has resulted in fairly long lock hold times and
> that stops all front end transaction commits from making progress.
> 
> We can move the sorting out of the xc_ctx_lock if we can transfer
> the ordering information to the log vectors as they are detached
> from the log items and then we can sort the log vectors.  With these
> changes, we can move the list_sort() call to just before we call
> xlog_write() when we aren't holding any locks at all.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.h     |  1 +
>  fs/xfs/xfs_log_cil.c | 23 ++++++++++++++---------
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index b4ad0e37a0c5..93aaee7c276e 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -10,6 +10,7 @@ struct xfs_cil_ctx;
>  
>  struct xfs_log_vec {
>  	struct list_head	lv_list;	/* CIL lv chain ptrs */
> +	uint32_t		lv_order_id;	/* chain ordering info */
>  	int			lv_niovecs;	/* number of iovecs in lv */
>  	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
>  	struct xfs_log_item	*lv_item;	/* owner */
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 035f0a60040a..cfd3128399f6 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -791,10 +791,10 @@ xlog_cil_order_cmp(
>  	const struct list_head	*a,
>  	const struct list_head	*b)
>  {
> -	struct xfs_log_item	*l1 = container_of(a, struct xfs_log_item, li_cil);
> -	struct xfs_log_item	*l2 = container_of(b, struct xfs_log_item, li_cil);
> +	struct xfs_log_vec	*l1 = container_of(a, struct xfs_log_vec, lv_list);
> +	struct xfs_log_vec	*l2 = container_of(b, struct xfs_log_vec, lv_list);
>  
> -	return l1->li_order_id > l2->li_order_id;
> +	return l1->lv_order_id > l2->lv_order_id;
>  }
>  
>  /*
> @@ -911,24 +911,22 @@ xlog_cil_push_work(
>  
>  	xlog_cil_pcp_aggregate(cil, ctx);
>  
> -	list_sort(NULL, &ctx->log_items, xlog_cil_order_cmp);
>  	while (!list_empty(&ctx->log_items)) {
>  		struct xfs_log_item	*item;
>  
>  		item = list_first_entry(&ctx->log_items,
>  					struct xfs_log_item, li_cil);
>  		lv = item->li_lv;
> -		list_del_init(&item->li_cil);
> -		item->li_order_id = 0;
> -		item->li_lv = NULL;
> -
> +		lv->lv_order_id = item->li_order_id;
>  		num_iovecs += lv->lv_niovecs;
>  		/* we don't write ordered log vectors */
>  		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
>  			num_bytes += lv->lv_bytes;
>  
>  		list_add_tail(&lv->lv_list, &ctx->lv_chain);
> -
> +		list_del_init(&item->li_cil);
> +		item->li_order_id = 0;
> +		item->li_lv = NULL;
>  	}
>  
>  	/*
> @@ -961,6 +959,13 @@ xlog_cil_push_work(
>  	spin_unlock(&cil->xc_push_lock);
>  	up_write(&cil->xc_ctx_lock);
>  
> +	/*
> +	 * Sort the log vector chain before we add the transaction headers.
> +	 * This ensures we always have the transaction headers at the start
> +	 * of the chain.
> +	 */
> +	list_sort(NULL, &ctx->lv_chain, xlog_cil_order_cmp);
> +
>  	/*
>  	 * Build a checkpoint transaction header and write it to the log to
>  	 * begin the transaction. We need to account for the space used by the
> -- 
> 2.31.1
> 
