Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A6AC433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 02:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33544613BD
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 02:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhEFC5M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 May 2021 22:57:12 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57986 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhEFC5L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 May 2021 22:57:11 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 993531043AB8;
        Thu,  6 May 2021 12:56:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leUBP-005UPe-0d; Thu, 06 May 2021 12:56:11 +1000
Date:   Thu, 6 May 2021 12:56:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: hold buffer across unpin and potential shutdown
 processing
Message-ID: <20210506025611.GM63242@dread.disaster.area>
References: <20210503121816.561340-1-bfoster@redhat.com>
 <20210503232539.GI63242@dread.disaster.area>
 <YJKGeUrMLvD7VK4l@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJKGeUrMLvD7VK4l@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=RpNfp87aCd9pj2b8WsIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 05, 2021 at 07:50:17AM -0400, Brian Foster wrote:
> On Tue, May 04, 2021 at 09:25:39AM +1000, Dave Chinner wrote:
> > On Mon, May 03, 2021 at 08:18:16AM -0400, Brian Foster wrote:
> > i.e. the problem here is that we've dropped the bip->bli_refcount
> > before we've locked the buffer and taken a reference to it for
> > the fail path?
> > 
> > OK, I see that xfs_buf_item_done() (called from ioend processing)
> > simply frees the buf log item and doesn't care about the bli
> > refcount at all. So the first ioend caller will free the buf log
> > item regardless of whether there are other references to it at all.
> > 
> > IOWs, once we unpin the buffer, the bli attached to the buffer and
> > being tracked in the AIL has -zero- references to the bli and so it
> > gets freed unconditionally on IO completion.
> > 
> > That seems to the be the problem here - the bli is not reference
> > counted while it is the AIL....
> > 
> 
> I think it depends on how you look at it. As you point out, we've had
> this odd bli reference count pattern for as long as I can remember where

Yes, and it's been a constant source of use-after free bugs in
shutdown processing for as long as I can remember. I want to fix it
so we don't have to keep band-aiding this code every time we change
how some part of log item or stale inode/buffer processing works...


> >  
> > -	freed = atomic_dec_and_test(&bip->bli_refcount);
> > -
> > +	/*
> > +	 * We can wake pin waiters safely now because we still hold the
> > +	 * bli_refcount that was taken when the pin was gained.
> > +	 */
> >  	if (atomic_dec_and_test(&bp->b_pin_count))
> >  		wake_up_all(&bp->b_waiters);
> >  
> > -	if (freed && stale) {
> > -		ASSERT(bip->bli_flags & XFS_BLI_STALE);
> > -		ASSERT(xfs_buf_islocked(bp));
> > -		ASSERT(bp->b_flags & XBF_STALE);
> > -		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
> > -
> > -		trace_xfs_buf_item_unpin_stale(bip);
> > -
> > -		if (remove) {
> > -			/*
> > -			 * If we are in a transaction context, we have to
> > -			 * remove the log item from the transaction as we are
> > -			 * about to release our reference to the buffer.  If we
> > -			 * don't, the unlock that occurs later in
> > -			 * xfs_trans_uncommit() will try to reference the
> > -			 * buffer which we no longer have a hold on.
> > -			 */
> > -			if (!list_empty(&lip->li_trans))
> > -				xfs_trans_del_item(lip);
> > -
> > -			/*
> > -			 * Since the transaction no longer refers to the buffer,
> > -			 * the buffer should no longer refer to the transaction.
> > -			 */
> > -			bp->b_transp = NULL;
> > +	if (!stale) {
> > +		if (!remove) {
> > +			/* Nothing to do but drop the refcount the pin owned. */
> > +			atomic_dec(&bip->bli_refcount);
> > +			return;
> >  		}
> 
> Hmm.. this seems a bit wonky to me. This code historically acts on the
> drop of the final reference to the bli.

Yes, and that's the problem that needs fixing. The AIL needs a
reference so that we aren't racing with writeback from the AIL to
free the object because both sets of code run without actually
holding an active reference to the BLI...

> This is not critical for the
> common (!stale && !remove) case because that's basically a no-op here
> outside of dropping the reference, and it looks like the stale buffer
> handling code further down continues to follow that model, but in this
> branch it seems we're trying to be clever in how the reference is
> managed and as a result can act on a bli that might actually have
> additional references.

Who cares? If something else has active references, then we must not
free the bli or buffer here, anyway. The lack of active references
by active BLI usres is why we keep getting use-after-free bugs in
this code.....

> If so, I don't think it's appropriate to run
> through the error sequence that follows.
> 
> >  
> >  		/*
> > -		 * If we get called here because of an IO error, we may or may
> > -		 * not have the item on the AIL. xfs_trans_ail_delete() will
> > -		 * take care of that situation. xfs_trans_ail_delete() drops
> > -		 * the AIL lock.
> > -		 */
> > -		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
> > -			xfs_buf_item_done(bp);
> > -			xfs_buf_inode_iodone(bp);
> > -			ASSERT(list_empty(&bp->b_li_list));
> > -		} else {
> > -			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
> > -			xfs_buf_item_relse(bp);
> > -			ASSERT(bp->b_log_item == NULL);
> > -		}
> > -		xfs_buf_relse(bp);
> > -	} else if (freed && remove) {
> > -		/*
> > +		 * Fail the IO before we drop the bli refcount. This guarantees
> > +		 * that a racing writeback completion also failing the buffer
> > +		 * and running completion will not remove the last reference to
> > +		 * the bli and free it from under us.
> > +		 *
> >  		 * The buffer must be locked and held by the caller to simulate
> >  		 * an async I/O failure.
> >  		 */
> > @@ -559,7 +555,62 @@ xfs_buf_item_unpin(
> >  		xfs_buf_hold(bp);
> >  		bp->b_flags |= XBF_ASYNC;
> >  		xfs_buf_ioend_fail(bp);
> > +		xfs_buf_item_relse(bp);
> 
> Did you mean for this to be xfs_buf_item_put() instead of _relse()? The

Yes. I did say "untested" which implies the patch isn't complete or will
work. It's just a demonstration of how this reference counting might
be done, not a complete, working solution. Patches are a much faster
way of explaining the overall solution that plain text...

> >  	}
> > +
> > +	/*
> > +	 * Stale buffer - only process it if this is the last reference to the
> > +	 * BLI. If this is the last BLI reference, then the buffer will be
> > +	 * locked and have two references - once from the transaction commit and
> > +	 * one from the BLI - and we do not unlock and release transaction
> > +	 * reference until we've finished cleaning up the BLI.
> > +	 */
> > +	if (!atomic_dec_and_test(&bip->bli_refcount))
> > +		return;
> > +
> 
> If the buffer is stale, will this ever be the last reference now that
> _item_committed() bumps the refcount?

If the AIL has a reference, then no.

> This change also seems to have
> ramifications for the code that follows, such as if a staled buffer is
> already in the AIL (with a bli ref), would this code ever get to the
> point of removing it?

That's easy enough to handle - if the buffer is stale and we are in
this code, we hold the buffer locked. Hence we can remove from the
AIL if it is in the AIL and drop that reference, too. Indeed, this
code already does the AIL removal, so all this requires is a simple
rearrangement of the logic in this function....

The only difference is that we have to do this before we drop the
current reference we have on the BLI, which is not what we do now
and that's where all the problems lie.

> All in all, I'll reiterate that I think it would be nice to fix up the
> bli reference count handling in general, but I think the scope and
> complexity of that work is significantly beyond what is reasonably
> necessary to fix this bug.

And so leaving the underlying problem in the code for the next set
of changes someone does to trigger the problem in a differen way.
We've indentified what the root cause is, so can we please spend
the time to fix it properly?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
