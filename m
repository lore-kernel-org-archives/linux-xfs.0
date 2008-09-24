Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 20:10:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O3A7J4031269
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:10:07 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFE281327695
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:11:40 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id rIOG5OnIVJWNVPXD for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:11:40 -0700 (PDT)
Date: Wed, 24 Sep 2008 13:11:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/8] XFS: Use a cursor for AIL traversal.
Message-ID: <20080924031137.GF5448@disturbed>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-3-git-send-email-david@fromorbit.com> <20080919092444.GB11443@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919092444.GB11443@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Sep 19, 2008 at 05:24:44AM -0400, Christoph Hellwig wrote:
> On Sun, Sep 14, 2008 at 12:57:51AM +1000, Dave Chinner wrote:
> > -	int			orig_gen = gen;
> > -
> >  	do {
> >  		ASSERT(lip->li_type != XFS_LI_EFI);
> > -		lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
> > -		/*
> > -		 * The check will be bogus if we restart from the
> > -		 * beginning of the AIL, so ASSERT that we don't.
> > -		 * We never should since we're holding the AIL lock
> > -		 * the entire time.
> > -		 */
> > -		ASSERT(gen == orig_gen);
> > +		lip = xfs_trans_next_ail(mp, cur);
> >  	} while (lip != NULL);
> 
> 	for (tmp = lip ; tmp = xfs_rans_next_ail(mp, tmp, &gen, NULL); tmp)
> 		ASSERT(tmp->li_type != XFS_LI_EFI);
> 
> ?

Doesn't really matter. I'd prefer to avoid needing another temporary
variable, so it can become:

	for (; lip; lip = xfs_trans_next_ail(mp, cur))
		ASSERT(lip->li_type != XFS_LI_EFI);

And at that point, I can probably kill the debug wrapper function
altogether. Hmmm - will the compiler optimise out the empty loop?
(i.e. do i need #ifdef DEBUG around it?)

> > +void
> > +xfs_trans_ail_cursor_init(
> 
> A little comment describing the function would be nice.

Sure.

> > +	struct xfs_ail		*ailp,
> > +	struct xfs_ail_cursor	*cur)
> > +{
> > +	cur->item = NULL;
> > +	if (cur == &ailp->xa_cursors)
> > +		return;
> 
> What is this check for?  It mans we'll do nothing if the cursor is the
> one embedded into the ail.  But we should never do this anyway, should
> we?

It means that we don't link the embedded push cursor into the list.
That is, initialisation of the push cursor simply clears the "next
item".

> > +/*
> > + * Set the cursor to the next item, because when we look
> > + * up the cursor the current item may have been freed.
> > + */
> > +STATIC void
> > +xfs_trans_ail_cursor_set(
> > +	struct xfs_ail		*ailp,
> > +	struct xfs_ail_cursor	*cur,
> > +	struct xfs_log_item	*lip)
> > +{
> > +	if (lip)
> > +		cur->item = xfs_ail_next(ailp, lip);
> > +}
> 
> Does it make sense to have the NULL check here and not in the caller?

Doesn't really matter - this saves having to check in every place
we call the function....

> 
> > +STATIC struct xfs_log_item *
> > +xfs_trans_ail_cursor_next(
> > +	struct xfs_ail		*ailp,
> > +	struct xfs_ail_cursor	*cur)
> > +{
> > +	struct xfs_log_item	*lip = cur->item;
> > +
> > +	xfs_trans_ail_cursor_set(ailp, cur, lip);
> > +	return lip;
> > +}
> 
> I'd say kill this wrapper, it's only used once anyway.

Ah - should be at least twice - I note that the push code uses
the xfs_mount version rather than the xfs_ail version.

Also, I realised that I forgot to add the traversal restart code
into this function, so it's definitely necessary....

> > +void
> > +xfs_trans_ail_cursor_done(
> > +	struct xfs_ail		*ailp,
> > +	struct xfs_ail_cursor	*done)
> 
> A little comment describing it, please.

Done.

> > +	if (done == &ailp->xa_cursors)
> > +		return;
> > +	prev = &ailp->xa_cursors;
> > +	for (cur = prev->next; cur; prev = cur, cur = prev->next) {
> > +		if (cur == done) {
> > +			prev->next = cur->next;
> > +			break;
> > +		}
> > +	}
> > +}
> 
> Add an assert somewhere that the cursor actually is on the list?

Done.

I'll repost the entire patch series with the fixes in a while

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
