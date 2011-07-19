Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6JNaoa3198870 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 18:36:50 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 788EF17FEF15
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 16:36:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	okXJryKb7QN4sVly for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2011 16:36:48 -0700 (PDT)
Date: Wed, 20 Jul 2011 09:36:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: use a cursor for bulk AIL insertion
Message-ID: <20110719233644.GB9359@dastard>
References: <1310960419-9875-1-git-send-email-david@fromorbit.com>
	<1310960419-9875-2-git-send-email-david@fromorbit.com>
	<1311116624.1964.38.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311116624.1964.38.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 19, 2011 at 06:03:44PM -0500, Alex Elder wrote:
> On Mon, 2011-07-18 at 13:40 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Delayed logging can insert tens of thousands of log items into the
> > AIL at the same LSN. When the committing of log commit records
> > occur, we can get insertions occurring at an LSN that is not at the
> > end of the AIL. If there are thousands of items in the AIL on the
> > tail LSN, each insertion has to walk the AIL to find the correct
> > place to insert the new item into the AIL. This can consume large
> > amounts of CPU time and block other operations from occurring while
> > the traversals are in progress.
> > 
> > To avoid this repeated walk, use a AIL cursor to record
> > where we should be inserting the new items into the AIL without
> > having to repeat the walk. The cursor infrastructure already
> > provides this functionality for push walks, so is a simple extension
> > of existing code. While this will not avoid the initial walk, it
> > will avoid repeating it tens of thousands of times during a single
> > checkpoint commit.
> > 
> > This version includes logic improvements from Christoph Hellwig.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I think there's a case that can be improved (though
> it isn't wrong as-is), and assuming I'm right, I have
> provided a modified splice function (not tested), below.
> 
> But if you don't want to change anything, this code
> looks OK to me, so:
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> . . .
> 
> > +
> > +/*
> > + * splice the log item list into the AIL at the given LSN. We splice to the
> > + * tail of the given LSN to maintain insert order for push traversals. The
> > + * cursor is optional, allowing repeated updates to the same LSN to avoid
> > + * repeated traversals.
> >   */
> >  static void
> >  xfs_ail_splice(
> > -	struct xfs_ail  *ailp,
> > -	struct list_head *list,
> > -	xfs_lsn_t       lsn)
> > +	struct xfs_ail		*ailp,
> > +	struct xfs_ail_cursor	*cur,
> > +	struct list_head	*list,
> > +	xfs_lsn_t		lsn)
> >  {
> > -	xfs_log_item_t  *next_lip;
> > +	struct xfs_log_item	*lip = cur ? cur->item : NULL;
> > +	struct xfs_log_item	*next_lip;
> >  
> > -	/* If the list is empty, just insert the item.  */
> > -	if (list_empty(&ailp->xa_ail)) {
> > -		list_splice(list, &ailp->xa_ail);
> > -		return;
> > +	/*
> > +	 * Get a new cursor if we don't have a placeholder or the existing one
> > +	 * has been invalidated.
> > +	 */
> > +	if (!lip || (__psint_t)lip & 1) {
> > +		lip = __xfs_trans_ail_cursor_last(ailp, lsn);
> > +
> > +		if (!lip) {
> > +			/* The list is empty, so just splice and return.  */
> > +			if (cur)
> > +				cur->item = NULL;
> 
> If the AIL was empty, I think we still want to
> make the cursor point to the end of the list that's
> being spliced in, don't we?

Not sure - we do get different LSNs in the same commit and the
insertions are interleaved. Hence I was defensive here and revalidate
the cursor on the next use of it.

> > +		cur->item = next_lip;
> >  	}
> > -
> > -	ASSERT(&next_lip->li_ail == &ailp->xa_ail ||
> > -	       XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0);
> > -
> > -	list_splice_init(list, &next_lip->li_ail);
> > +	list_splice(list, &lip->li_ail);
> >  }
> >  
> >  /*
> 
> 
> So assuming my comment above is right, how about this:
> 
> static void
> xfs_ail_splice(
>         struct xfs_ail          *ailp,
>         struct xfs_ail_cursor   *cur,
>         struct list_head        *list,
>         xfs_lsn_t               lsn)
> {
>         struct xfs_log_item     *lip;
> 
>         /*
>          * Use the cursor to determine the insertion point if one is
>          * provided.
>          */
>         lip = cur ? cur->item : NULL;
>         if (!lip || (__psint_t) lip & 1)
>                 lip = __xfs_trans_ail_cursor_last(ailp, lsn);
> 
>         /*
>          * If a cursor is provided, we know we're processing the AIL
>          * in lsn order, and future items to be spliced in will
>          * follow the last one being inserted now.  Update the
>          * cursor to point to that last item, now while we have a
>          * reliable pointer to it.
>          */
>         if (cur)
>                 cur->item = list_entry(list->prev, struct xfs_log_item,
> li_ail);
> 
>         /*
>          * Finally perform the splice.  Unless the AIL was empty,
>          * lip points to the item in the AIL _after_ which the new
>          * items should go.  If lip is null the AIL was empty, so
>          * the new items go at the head of the AIL.
>          */
>         if (lip)
>                 list_splice(list, &lip->li_ail);
>         else
>                 list_splice(list, &ailp->xa_ail);
> }


Looks cleaner, but I'll need to test it. Right now all my test
resources are busy with non-mainline stuff, so it's going to be next
week sometime before I can do this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
