Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 02:23:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J9NC7i009783
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:23:12 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BCF491DFF1
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:24:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 5Pvyl17wRKfFr5PM for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:24:45 -0700 (PDT)
Date: Fri, 19 Sep 2008 05:24:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] XFS: Use a cursor for AIL traversal.
Message-ID: <20080919092444.GB11443@infradead.org>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221317877-8333-3-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:57:51AM +1000, Dave Chinner wrote:
> To replace the current generation number ensuring sanity of the AIL
> traversal, replace it with an external cursor that is linked to the
> AIL.
> 
> Basically, we store the next item in the cursor whenever we want to
> drop the AIL lock to do something to the current item.  When we
> regain the lock. the current item may already be free, so we can't
> reference it, but the next item in the traversal is already held in
> the cursor.
> 
> When we move or delete an object, we search all the active cursors
> and if there is an item match we clear the cursor(s) that point to
> the object. This forces the traversal to restart transparently.
> 
> We don't invalidate the cursor on insert because the cursor still
> points to a valid item. If the intem is inserted between the current
> item and the cursor it does not matter; the traversal is considered
> to be past the insertion point so it will be picked up in the next
> traversal.
> 
> Hence traversal restarts pretty much disappear altogether with this
> method of traversal, which should substantially reduce the overhead
> of pushing on a busy AIL.

>  {
> -	int			orig_gen = gen;
> -
>  	do {
>  		ASSERT(lip->li_type != XFS_LI_EFI);
> -		lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
> -		/*
> -		 * The check will be bogus if we restart from the
> -		 * beginning of the AIL, so ASSERT that we don't.
> -		 * We never should since we're holding the AIL lock
> -		 * the entire time.
> -		 */
> -		ASSERT(gen == orig_gen);
> +		lip = xfs_trans_next_ail(mp, cur);
>  	} while (lip != NULL);

	for (tmp = lip ; tmp = xfs_rans_next_ail(mp, tmp, &gen, NULL); tmp)
		ASSERT(tmp->li_type != XFS_LI_EFI);

?
		
> +void
> +xfs_trans_ail_cursor_init(

A little comment describing the function would be nice.

> +	struct xfs_ail		*ailp,
> +	struct xfs_ail_cursor	*cur)
> +{
> +	cur->item = NULL;
> +	if (cur == &ailp->xa_cursors)
> +		return;

What is this check for?  It mans we'll do nothing if the cursor is the
one embedded into the ail.  But we should never do this anyway, should
we?

> +	cur->next = ailp->xa_cursors.next;
> +	ailp->xa_cursors.next = cur;

> +/*
> + * Set the cursor to the next item, because when we look
> + * up the cursor the current item may have been freed.
> + */
> +STATIC void
> +xfs_trans_ail_cursor_set(
> +	struct xfs_ail		*ailp,
> +	struct xfs_ail_cursor	*cur,
> +	struct xfs_log_item	*lip)
> +{
> +	if (lip)
> +		cur->item = xfs_ail_next(ailp, lip);
> +}

Does it make sense to have the NULL check here and not in the caller?

> +STATIC struct xfs_log_item *
> +xfs_trans_ail_cursor_next(
> +	struct xfs_ail		*ailp,
> +	struct xfs_ail_cursor	*cur)
> +{
> +	struct xfs_log_item	*lip = cur->item;
> +
> +	xfs_trans_ail_cursor_set(ailp, cur, lip);
> +	return lip;
> +}

I'd say kill this wrapper, it's only used once anyway.

> +void
> +xfs_trans_ail_cursor_done(
> +	struct xfs_ail		*ailp,
> +	struct xfs_ail_cursor	*done)

A little comment describing it, please.

> +	if (done == &ailp->xa_cursors)
> +		return;
> +	prev = &ailp->xa_cursors;
> +	for (cur = prev->next; cur; prev = cur, cur = prev->next) {
> +		if (cur == done) {
> +			prev->next = cur->next;
> +			break;
> +		}
> +	}
> +}

Add an assert somewhere that the cursor actually is on the list?
