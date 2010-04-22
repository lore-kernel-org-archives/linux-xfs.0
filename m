Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MAxjaW191232 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 05:59:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 721C188C037
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 04:01:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0QyYuuZjHTh6YFqG for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 04:01:45 -0700 (PDT)
Date: Thu, 22 Apr 2010 07:01:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Improve scalability of busy extent tracking
Message-ID: <20100422110143.GA21867@infradead.org>
References: <1271828835-2094-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271828835-2094-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Having the patches merged into one certainly helps with readability.
This version also passes xfsqa fine while I had some problems with that
with the delayed logging tree.

> o busy extent transaction owner tracked by transaction id, not by
>   address of transaction structure. Tracking by address of the
>   transaction was triggering false ASSERT failures when searching for
>   busy extents with matching start block numbers.

I'm a bit confused by that.  How can we ever find a xfs_busy_extent
structure for a transaction that's been freed?  We always call
xfs_trans_free_busy before freeing the transaction, so this should
never happen.  And if it can happen we can also get a reuse of the tid,
even if it is much more likely.  So if there's a corner case I've
missed we really need to keep a pointer to the xlog_ticket and keep
a reference on it as long as we have busy extents belonging to it in
the rbtree.

Besides that here's a few cosmetic comments:

> -STATIC void
> -xfs_alloc_search_busy(xfs_trans_t *tp,
> -		    xfs_agnumber_t agno,
> -		    xfs_agblock_t bno,
> -		    xfs_extlen_t len);
> +static int
> +xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		    xfs_agblock_t bno, xfs_extlen_t len);

The switch in naming convention looks good to me, but it should
also be applied to xfs_alloc_clear_busy (-> xfs_alloc_busy_clear?)
and xfs_alloc_mark_busy (-> xfs_alloc_busy_add/insert?)

> +xfs_alloc_mark_busy(
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len)
>  {
> +	struct xfs_busy_extent	*busyp;
>  
> +	busyp = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
> +	if (!busyp) {
> +		/*
> +		 * No Memory!  Since it is now not possible to track the free
> +		 * block, make this a synchronous transaction to insure that
> +		 * the block is not reused before this transaction commits.
> +		 */
> +		trace_xfs_alloc_busy(tp, agno, bno, len, 1);
> +		xfs_trans_set_sync(tp);
> +		return;
>  	}
>  
> +	busyp->agno = agno;
> +	busyp->bno = bno;
> +	busyp->length = len;
> +	busyp->tid = xfs_trans_get_tid(tp);
> +	INIT_LIST_HEAD(&busyp->list);
>  
> +	/* trace before insert to be able to see failed inserts */
> +	trace_xfs_alloc_busy(tp, agno, bno, len, 0);
> +	xfs_alloc_busy_insert(tp, busyp);
> +}

I'd rather inline xfs_alloc_busy_insert into this function, there's no
good reason to keep it separate.

> -	xfs_trans_clear_busy_extents(tp);
> +	xfs_trans_free_busy(tp->t_mountp, &tp->t_busy);
>  	xfs_trans_free(tp);
>  }
>  
> @@ -1013,7 +1016,7 @@ xfs_trans_uncommit(
>  	xfs_trans_unreserve_and_mod_dquots(tp);
>  
>  	xfs_trans_free_items(tp, flags);
> -	xfs_trans_free_busy(tp);
> +	xfs_trans_free_busy(tp->t_mountp, &tp->t_busy);

There's no real need for the prototype change at this point.  I know
you'll need it for the delayed logging, but let's keep the prototype
change in that patchset.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
