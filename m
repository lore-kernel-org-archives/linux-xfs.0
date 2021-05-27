Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A922C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 19:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B2C611C9
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 19:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbhE0TB7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 15:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235610AbhE0TB5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 15:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E777A610CE;
        Thu, 27 May 2021 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622142024;
        bh=GNrL4h8u+ComMNsw7sRcyKrpQo+W/UtFdH0NJGgxLwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nIp1l3yDgmGwb6zcUzT56mjETYKSYHsQmi7IL6jJHDSeLQnGGa/i6s9nbxaYvPGNd
         LdYhm0u7wJiYz5szkplPrIH3fxeNPalwbpEcNmYFx9QmERu5/FZnpzqUUi4EXCB2kS
         Ndx7xyIevUgDq4DhVHndl603xQCEk549cvaiZcnBrdvojQBhzrESzRWnf45GxWb1nb
         kBvCr8aP/Zr8fpPUeMKpJz0bj2CYmiS0FIVfjXKLFq7CnLAxs+R3SM1AZICYnDqE/L
         khoGZ1MOmZJ1wDZvasByJLehm+PvO3iyxMZaKNDiuYLKIponqAt4XVc3ATm8JY/dbf
         swVpyUCI4chaw==
Date:   Thu, 27 May 2021 12:00:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/39] xfs: Add order IDs to log items in CIL
Message-ID: <20210527190023.GK2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-34-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-34-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:11PM +1000, Dave Chinner wrote:
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

s/taht/that/

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

...which I guess happens in patch 35 now?

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 38 ++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_log_priv.h |  1 +
>  fs/xfs/xfs_trans.h    |  1 +
>  3 files changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b12a2f9ba23a..ca6e411e388e 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -461,6 +461,7 @@ xlog_cil_insert_items(
>  	int			len = 0;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
>  	int			space_used;
> +	int			order;
>  	struct xlog_cil_pcp	*cilpcp;
>  
>  	ASSERT(tp);
> @@ -550,10 +551,12 @@ xlog_cil_insert_items(
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
> @@ -561,13 +564,10 @@ xlog_cil_insert_items(
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
> +		list_add_tail(&lip->li_cil, &cil->xc_cil);
>  	}
>  
>  	spin_unlock(&cil->xc_cil_lock);
> @@ -780,6 +780,26 @@ xlog_cil_build_trans_hdr(
>  	tic->t_curr_res -= lvhdr->lv_bytes;
>  }
>  
> +/*
> + * CIL item reordering compare function. We want to order in ascending ID order,
> + * but we want to leave items with the same ID in the order they were added to

When do we have items with the same id?

I guess that happens if we have multiple transactions adding items to
the cil at the same time?  I guess that's not a big deal since each of
those threads will hold a disjoint set of locks, so even if the order
ids are the same for a bunch of items, they're never going to be
touching the same AG/inode/metadata object, right?

If that's correct, then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> + * the list. This is important for operations like reflink where we log 4 order
> + * dependent intents in a single transaction when we overwrite an existing
> + * shared extent with a new shared extent. i.e. BUI(unmap), CUI(drop),
> + * CUI (inc), BUI(remap)...
> + */
> +static int
> +xlog_cil_order_cmp(
> +	void			*priv,
> +	const struct list_head	*a,
> +	const struct list_head	*b)
> +{
> +	struct xfs_log_item	*l1 = container_of(a, struct xfs_log_item, li_cil);
> +	struct xfs_log_item	*l2 = container_of(b, struct xfs_log_item, li_cil);
> +
> +	return l1->li_order_id > l2->li_order_id;
> +}
> +
>  /*
>   * Push the Committed Item List to the log.
>   *
> @@ -900,6 +920,7 @@ xlog_cil_push_work(
>  	 * needed on the transaction commit side which is currently locked out
>  	 * by the flush lock.
>  	 */
> +	list_sort(NULL, &cil->xc_cil, xlog_cil_order_cmp);
>  	lv = NULL;
>  	while (!list_empty(&cil->xc_cil)) {
>  		struct xfs_log_item	*item;
> @@ -907,6 +928,7 @@ xlog_cil_push_work(
>  		item = list_first_entry(&cil->xc_cil,
>  					struct xfs_log_item, li_cil);
>  		list_del_init(&item->li_cil);
> +		item->li_order_id = 0;
>  		if (!ctx->lv_chain)
>  			ctx->lv_chain = item->li_lv;
>  		else
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b80cb3a0edb7..466862a943ba 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -225,6 +225,7 @@ struct xfs_cil_ctx {
>  	struct list_head	committing;	/* ctx committing list */
>  	struct work_struct	discard_endio_work;
>  	struct work_struct	push_work;
> +	atomic_t		order_id;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 50da47f23a07..2d1cc1ff93c7 100644
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
> 2.31.1
> 
