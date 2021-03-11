Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21C0C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 01:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64BA464FC0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 01:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229467AbhCKBA7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 20:00:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhCKBA1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 20:00:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71C7064FC3;
        Thu, 11 Mar 2021 01:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615424427;
        bh=a/MCGk/j448g4bO9ZouK3yEN6NWl7xw/89bw25kN+x4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iBmO9psb+VNoGKlGEDPYXlVZrv6Ln5SAofbI58xtwJM8D3M9kHVPklbK0NVVwlEpO
         u3C7NeJQM2HNnRTCUKa3bLY15jNqOwkCHDXiGqpadPfr54dYtnZEqtiq6Wq0rWIXTJ
         W+vBgIJ/i7GOKiiN3Edhx++/qbSGFSorpvORmFsOMt/bCDePHtawPEjw+B1gRBhvtR
         kF8kB5G7C5S4kZKWgRFFvJVCuiFVJ+VmxzVzHV+bdoIMQdg1I1P04qnC9UofbYr8tv
         ytFUeebgREEZMHXEbWQaFfdN1M/ByxOITF4uGmBTxBmxyYVArG7nJ4Mdv8nGE61xz/
         2D1Wh0Nc8JHvw==
Date:   Wed, 10 Mar 2021 17:00:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/45] xfs: Add order IDs to log items in CIL
Message-ID: <20210311010026.GM3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-40-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-40-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:37PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Before we split the ordered CIL up into per cpu lists, we need a
> mechanism to track the order of the items in the CIL. We need to do
> this because there are rules around the order in which related items
> must physically appear in the log even inside a single checkpoint
> transaction.
> 
> An example of this is intents - an intent must appear in the log
> before it's intent done record so taht log recovery can cancel the
> intent correctly. If we have these two records misordered in the
> CIL, then they will not be recovered correctly by journal replay.
> 
> We also will not be able to move items to the tail of
> the CIL list when they are relogged, hence the log items will need
> some mechanism to allow the correct log item order to be recreated
> before we write log items to the hournal.
> 
> Hence we need to have a mechanism for recording global order of
> transactions in the log items  so that we can recover that order
> from un-ordered per-cpu lists.
> 
> Do this with a simple monotonic increasing commit counter in the CIL
> context. Each log item in the transaction gets stamped with the
> current commit order ID before it is added to the CIL. If the item
> is already in the CIL, leave it where it is instead of moving it to
> the tail of the list and instead sort the list before we start the
> push work.
> 
> XXX: list_sort() under the cil_ctx_lock held exclusive starts
> hurting that >16 threads. Front end commits are waiting on the push
> to switch contexts much longer. The item order id should likely be
> moved into the logvecs when they are detacted from the items, then
> the sort can be done on the logvec after the cil_ctx_lock has been
> released. logvecs will need to use a list_head for this rather than
> a single linked list like they do now....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 34 ++++++++++++++++++++++++++--------
>  fs/xfs/xfs_log_priv.h |  1 +
>  fs/xfs/xfs_trans.h    |  1 +
>  3 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 7428b98c8279..7420389f4cee 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -434,6 +434,7 @@ xlog_cil_insert_items(
>  	int			len = 0;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
>  	int			space_used;
> +	int			order;
>  	struct xlog_cil_pcp	*cilpcp;
>  
>  	ASSERT(tp);
> @@ -523,10 +524,12 @@ xlog_cil_insert_items(
>  	}
>  
>  	/*
> -	 * Now (re-)position everything modified at the tail of the CIL.
> +	 * Now update the order of everything modified in the transaction
> +	 * and insert items into the CIL if they aren't already there.
>  	 * We do this here so we only need to take the CIL lock once during
>  	 * the transaction commit.
>  	 */
> +	order = atomic_inc_return(&ctx->order_id);
>  	spin_lock(&cil->xc_cil_lock);
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  
> @@ -534,13 +537,10 @@ xlog_cil_insert_items(
>  		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
>  			continue;
>  
> -		/*
> -		 * Only move the item if it isn't already at the tail. This is
> -		 * to prevent a transient list_empty() state when reinserting
> -		 * an item that is already the only item in the CIL.
> -		 */
> -		if (!list_is_last(&lip->li_cil, &cil->xc_cil))
> -			list_move_tail(&lip->li_cil, &cil->xc_cil);
> +		lip->li_order_id = order;
> +		if (!list_empty(&lip->li_cil))
> +			continue;
> +		list_add(&lip->li_cil, &cil->xc_cil);

If the goal here is to end up an xc_cil list where all the log items are
sorted in commit order, why isn't the existing strategy of moving dirty
items to the tail sufficient to keep them in sorted order?

Hm, looking at the /next/ patch, I see you start adding the items to the
per-CPU CIL structure and only combining them into a single list at push
time.  Maybe that's a better place to talk about this.

--D

>  	}
>  
>  	spin_unlock(&cil->xc_cil_lock);
> @@ -753,6 +753,22 @@ xlog_cil_build_trans_hdr(
>  	tic->t_curr_res -= lvhdr->lv_bytes;
>  }
>  
> +static int
> +xlog_cil_order_cmp(
> +	void			*priv,
> +	struct list_head	*a,
> +	struct list_head	*b)
> +{
> +	struct xfs_log_item	*l1 = container_of(a, struct xfs_log_item, li_cil);
> +	struct xfs_log_item	*l2 = container_of(b, struct xfs_log_item, li_cil);
> +
> +	if (l1->li_order_id > l2->li_order_id)
> +		return 1;
> +	if (l1->li_order_id < l2->li_order_id)
> +		return -1;
> +	return 0;
> +}
> +
>  /*
>   * Push the Committed Item List to the log.
>   *
> @@ -891,6 +907,7 @@ xlog_cil_push_work(
>  	 * needed on the transaction commit side which is currently locked out
>  	 * by the flush lock.
>  	 */
> +	list_sort(NULL, &cil->xc_cil, xlog_cil_order_cmp);
>  	lv = NULL;
>  	while (!list_empty(&cil->xc_cil)) {
>  		struct xfs_log_item	*item;
> @@ -898,6 +915,7 @@ xlog_cil_push_work(
>  		item = list_first_entry(&cil->xc_cil,
>  					struct xfs_log_item, li_cil);
>  		list_del_init(&item->li_cil);
> +		item->li_order_id = 0;
>  		if (!ctx->lv_chain)
>  			ctx->lv_chain = item->li_lv;
>  		else
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 278b9eaea582..92d9e1a03a07 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -229,6 +229,7 @@ struct xfs_cil_ctx {
>  	struct list_head	committing;	/* ctx committing list */
>  	struct work_struct	discard_endio_work;
>  	struct work_struct	push_work;
> +	atomic_t		order_id;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 6276c7d251e6..226c0f5e7870 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -44,6 +44,7 @@ struct xfs_log_item {
>  	struct xfs_log_vec		*li_lv;		/* active log vector */
>  	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
>  	xfs_csn_t			li_seq;		/* CIL commit seq */
> +	uint32_t			li_order_id;	/* CIL commit order */
>  };
>  
>  /*
> -- 
> 2.28.0
> 
