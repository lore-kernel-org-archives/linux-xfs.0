Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932224AbdAFKoe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Jan 2017 05:44:34 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55F3415561
        for <linux-xfs@vger.kernel.org>; Fri,  6 Jan 2017 10:44:35 +0000 (UTC)
Date: Fri, 6 Jan 2017 11:44:30 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] [RFC] Propagate error state from buffers to the objects
 attached
Message-ID: <20170106104430.gixpqeqdlhdlqxy3@eorzea.usersys.redhat.com>
References: <20170104184609.1102-1-cmaiolino@redhat.com>
 <20170105150113.GB3345@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170105150113.GB3345@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hi,

On Thu, Jan 05, 2017 at 10:01:14AM -0500, Brian Foster wrote:
> On Wed, Jan 04, 2017 at 07:46:09PM +0100, Carlos Maiolino wrote:
> > Hi folks,
> > 
> > I've been working on a problem regarding buffers that failed to be written back
> > not being retried as they should, because the items attached to it were flush
> > locked.
> > 
> > Discussing the problem previously with Dave and Brian, Dave suggested that first
> > we create an error propagation model, so notify items in case of a failure with
> > the buffer.
> > 
> 
> Hi Carlos,
> 
> Firstly, it's probably a good idea to reference the previous discussion
> for context. That is available here:
> 
>   http://www.spinics.net/lists/linux-xfs/msg01018.html
> 
> There is some noise due to confusion between Dave and I, but the last
> couple messages or so describe the design required to resolve the
> problem.
> 

Right, I tent to think that everybody remember things, my bad, I'll make sure to
keep the history :)


> > Based on that discussion, I've been playing with a prototype for this, and I
> > thought about sending it here so I can get some extra input about the model and
> > if I'm on the right direction (or not :)
> > 
> > The basic idea is to modify xfs_buf_iodone_callbacks() to trigger the iodone
> > callbacks of the items attached to the buffer, or, in case of failure, trigger a
> > callback to notify the items about the error, where, we can propagate the buffer
> > error flags to the items attached to it.
> > 
> > Currently, we only run the callbacks in case of success or a permanent error,
> > items are not aware of any temporary error, since no callbacks are triggered,
> > which (in my specific case), can lead to an item to be flush locked forever.
> > 
> 
> Right.. so the core issue is that log item retry (after non-permanent
> metadata I/O failure) for flush locked items is broken. This is because
> 1.) the first item push flush locks the object and it must remain flush
> locked until the associated buffer makes it to disk and 2.) a subsequent
> AIL push skips any object that is already flush locked. The example
> we're running into is for inodes, but IIRC this problem applies to
> xfs_dquot's as well, so we'll want to cover that with this work as well.
> 

Yeah, I know inode items are not the only item with the problem here, my idea of
this RFC was to get inputs about the model about how to propagate errors back to
the item, once I have a reproducer for problems with the inodes, I believed the
prototype only caring about xfs inode would give an idea of the model, then it
is just a matter of duplicating it into dquots.


> (It's good to provide such a problem summary in a cover letter and/or
> commit log description for follow on posts. Feel free to steal from the
> example I wrote up in the old thread..).

I think you pretty much described it above, again, I should have described it
better here, or pointed out the old discussion, as you did :)
> 
> > I though that xfs_item_ops structure fits well for an error notification
> > callback.
> > 
> > xfs_inode_item_push() is a place where we keep spinning in the items deadly
> > flush locked, so I've added some code there just for my testing here.
> > 
> > Does this notification model makes sense? Anything that I am missing? This is
> > the first time I'm working into buffer code, so I'm not much sure if what I'm
> > doing is right or not, so any comments are much appreciated.
> > 
> > I expect to send a 'final version' of this patch together with the fix for the
> > flush deadlocked items, but I want to make sure that I'm following the right
> > direction with this error propagation model.
> > 
> > +STATIC void
> > +xfs_buf_do_callbacks_fail(
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_log_item	*lip, *next;
> > +	unsigned int		bflags = bp->b_flags;
> > +
> > +	lip = bp->b_fspriv;
> > +	while (lip != NULL) {
> > +		next = lip->li_bio_list;
> > +
> > +		if(lip->li_ops->iop_error)
> > +			lip->li_ops->iop_error(lip, bflags);
> > +
> > +		lip = next;
> > +	}
> > +}
> 
> Do we really need a new iop callback for this? Could we define a new
> xfs_log_item->li_flags flag (XFS_LI_FAILED) that we can set directly
> from the iodone path instead?

Yes, I don't see why not, but I'm new on this part of the code, but I certainly
can do some little experimenting today and reply with the results, now that I
know which knobs to twist, it shouldn't be hard to experiment with that. My idea
of having a callback, was to give the item some flexibility about what to do
when we get an error, but I think having the flag in xfs_log_item would achieve
at least a close enough result.

> 
> > +
> >  static bool
> >  xfs_buf_iodone_callback_error(
> >  	struct xfs_buf		*bp)
> > @@ -1148,13 +1170,16 @@ void
> >  xfs_buf_iodone_callbacks(
> >  	struct xfs_buf		*bp)
> >  {
> > +
> >  	/*
> >  	 * If there is an error, process it. Some errors require us
> >  	 * to run callbacks after failure processing is done so we
> >  	 * detect that and take appropriate action.
> >  	 */
> > -	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
> > +	if (bp->b_error && xfs_buf_iodone_callback_error(bp)) {
> > +		xfs_buf_do_callbacks_fail(bp);
> 
> However we set the failed state on the log item, we probably want to
> invoke it from inside of xfs_buf_iodone_callback_error() (in particular,
> in the case where we've already done the single retry and failed).
> 
> With the current logic, it looks like we'd actually mark the items as
> failed after the latter function has also issued the single automatic
> retry before the AIL becomes responsible for further retries. A generic
> flag would also result in less code for each item (as previously noted,
> we also need to deal with xfs_dquot).
> 
> >  		return;
> > +	}
> >  
> >  	/*
> >  	 * Successful IO or permanent error. Either way, we can clear the
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 10dcf27..f98b0c6 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -232,6 +232,8 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
> >   */
> >  #define XFS_IRECOVERY		(1 << 11)
> >  
> > +#define XFS_IBFAIL		(1 << 12) /* Failed to flush buffer */
> > +
> >  /*
> >   * Per-lifetime flags need to be reset when re-using a reclaimable inode during
> >   * inode lookup. This prevents unintended behaviour on the new inode from
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index d90e781..70206c61 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -475,6 +475,17 @@ xfs_inode_item_unpin(
> >  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> >  }
> >  
> > +STATIC void
> > +xfs_inode_item_error(
> > +	struct xfs_log_item	*lip,
> > +	unsigned int		bflags)
> > +{
> > +	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
> > +
> > +	if (bflags & XBF_WRITE_FAIL)
> > +		ip->i_flags |= XFS_IBFAIL;
> > +}
> > +
> >  STATIC uint
> >  xfs_inode_item_push(
> >  	struct xfs_log_item	*lip,
> > @@ -512,6 +523,16 @@ xfs_inode_item_push(
> >  	}
> >  
> >  	/*
> > +	 * EXAMPLE:
> > +	 *	Have we already tried to submit the buffer attached to this
> > +	 *	inode, and has it failed?
> > +	 */
> > +	if (ip->i_flags & XFS_IBFAIL) {
> > +		printk("XFS: %s: inode buffer already submitted. ino: %llu\n",
> > +		       __func__, ip->i_ino);
> > +	}
> 
> I think we only care about the new failure case when the flush lock is
> not acquired. At that point we have to continue on and verify that the
> buffer was marked as failed as well and then resubmit the buffer.

Yup, code above was a tentative to exemplify where we might need to use this
model, but, sounds like an unfortunate bad example :)

Regarding about the verification if the buffer has failed or not, I don't know
if we really need to do that there. I mean, the idea of the model is to capture
the errors and pass it back to the log item, if we already have the log item
(flag or callback or whatever) notified of the error, why should we need to test
if the buffer failed or not? I mean, the log_item should be notified the buffer
has been already failed. Am I missing something else here that I am not seeing?

> 
> FWIW, I think it might be a good idea to break this down into at least a
> few patches. One to add generic error propagation infrastructure and
> subsequent to process the error state in the appropriate log item
> handlers.
> 

Yes, that's the idea as I wrote in the description (not sure if it was clear
enough), but I want to have a model 'accepted' before actually trying add the
error state processing over a model that will not work very well :)


Thanks for the review, I'll give a shot with the flag instead of a callback and
see how it goes.

Cheers
-- 
Carlos
