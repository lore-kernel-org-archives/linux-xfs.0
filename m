Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728464AbeHVQaO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Aug 2018 12:30:14 -0400
Date: Wed, 22 Aug 2018 09:05:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't unlock invalidated buf on aborted tx commit
Message-ID: <20180822130520.GD26084@bfoster>
References: <20180821140116.15900-1-bfoster@redhat.com>
 <20180822060100.GA5665@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180822060100.GA5665@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 21, 2018 at 11:01:00PM -0700, Christoph Hellwig wrote:
> > +	int			freed;
> 
> I think this should be a bool..
> 

Yep.

> >  	bool			aborted;
> >  	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
> >  	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
> > +	bool			stale = !!(bip->bli_flags & XFS_BLI_STALE);
> >  #if defined(DEBUG) || defined(XFS_WARN)
> >  	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
> >  #endif
> > +	/*
> > +	 * The bli dirty state should match whether the blf has logged segments
> > +	 * except for ordered buffers, where only the bli should be dirty.
> > +	 */
> > +	ASSERT((!ordered && dirty == xfs_buf_item_dirty_format(bip)) ||
> > +	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
> > +	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> >  
> > +	trace_xfs_buf_item_unlock(bip);
> >  
> > +	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags);
> >  
> >  	/*
> > +	 * Clear the buffer's association with this transaction and
> > +	 * per-transaction state from the bli, which has been copied above.
> >  	 */
> > +	bp->b_transp = NULL;
> >  	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
> >  
> >  	/*
> > +	 * Drop the transaction bli reference and free the item if clean or
> > +	 * aborted and we had the last reference. In either case this is the
> > +	 * last opportunity to free the item since it won't be written back.
> > +	 * Otherwise, the bli is still referenced or dirty and will be freed on
> > +	 * final unpin of the buffer (if stale) or writeback completion.
> >  	 */
> > +	freed = atomic_dec_and_test(&bip->bli_refcount);
> > +	if (freed && (aborted || !dirty)) {
> > +		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
> > +		ASSERT(!stale || aborted);
> > +		/* an aborted item may be in the AIL, remove it first */
> > +		if (aborted)
> > +			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> > +		xfs_buf_item_relse(bp);
> >  	}
> >  
> >  	/*
> > +	 * If the buffer was invalidated, leave it locked on transaction commit
> > +	 * unless we just dropped the final reference. The latter case should
> > +	 * only ever happen on abort because invalidation dirties the
> > +	 * transaction and the log would have grabbed another bli reference when
> > +	 * the buffer was pinned. In the non-abort case, the buffer is unlocked
> > +	 * on final unpin and the bli freed since stale buffers are not written
> > +	 * back.
> >  	 */
> > +	if (stale && !freed)
> > +		return;
> > +	ASSERT(!stale || (aborted && freed));
> >  
> >  	if (!hold)
> >  		xfs_buf_relse(bp);
> 
> I find the logic much more convoluted than what was there before.
> 
> I seems like we could apply your stale fix without reshuffling the
> code like this:
> 
> 	if (atomic_dec_and_test(&bip->bli_refcount)) {
> 		if (aborted) {
> 			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
> 			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> 			xfs_buf_item_relse(bp);
> 		} else if (!dirty) {
> 			ASSERT(!stale);
> 			xfs_buf_item_relse(bp);
> 		}
> 	} else {
> 		if (stale)
> 			return;
> 	}
> 	
> 	if (!hold)
> 		xfs_buf_relse(bp);
> 
> which at least to me is a lot easier to read.

What you have here looks logically equivalent and exactly like the 1-2
liner I originally introduced to test the fix. I refactored the function
because I found it duplicated some logic, was unnecessarily long and
some of the comments actually look stale/out of place.

The logic fix here is indeed very small, as you and Dave have both
pointed out. I think what Dave proposed is roughly equivalent to what
you suggest and more closely resembles the original flow, so I'll take a
closer look at that and post a v2.

Brian
