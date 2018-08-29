Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727316AbeH2Rw5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Aug 2018 13:52:57 -0400
Date: Wed, 29 Aug 2018 09:55:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: refactor xfs_buf_log_item reference count
 handling
Message-ID: <20180829135550.GB56494@bfoster>
References: <20180827142548.45029-1-bfoster@redhat.com>
 <20180827142548.45029-4-bfoster@redhat.com>
 <20180828225909.GB5631@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180828225909.GB5631@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 29, 2018 at 08:59:09AM +1000, Dave Chinner wrote:
> On Mon, Aug 27, 2018 at 10:25:48AM -0400, Brian Foster wrote:
> > The xfs_buf_log_item structure has a reference counter with slightly
> > tricky semantics. In the common case, a buffer is logged and
> > committed in a transaction, committed to the on-disk log (added to
> > the AIL) and then finally written back and removed from the AIL. The
> > bli refcount covers two potentially overlapping timeframes:
> > 
> >  1. the bli is held in an active transaction
> >  2. the bli is pinned by the log
> > 
> > The caveat to this approach is that the reference counter does not
> > purely dictate the lifetime of the bli. IOW, when a dirty buffer is
> > physically logged and unpinned, the bli refcount may go to zero as
> > the log item is inserted into the AIL. Only once the buffer is
> > written back can the bli finally be freed.
> > 
> > The above semantics means that it is not enough for the various
> > refcount decrementing contexts to release the bli on decrement to
> > zero. xfs_trans_brelse(), transaction commit (->iop_unlock()) and
> > unpin (->iop_unpin()) must all drop the associated reference and
> > make additional checks to determine if the current context is
> > responsible for freeing the item.
> > 
> > For example, if a transaction holds but does not dirty a particular
> > bli, the commit may drop the refcount to zero. If the bli itself is
> > clean, it is also not AIL resident and must be freed at this time.
> > The same is true for xfs_trans_brelse(). If the transaction dirties
> > a bli and then aborts or an unpin results in an abort due to a log
> > I/O error, the last reference count holder is expected to explicitly
> > remove the item from the AIL and release it (since an abort means
> > filesystem shutdown and metadata writeback will never occur).
> > 
> > This leads to fairly complex checks being replicated in a few
> > different places. Since ->iop_unlock() and xfs_trans_brelse() are
> > nearly identical, refactor the logic into a common helper that
> > implements and documents the semantics in one place. This patch does
> > not change behavior.
> 
> I think this improves the code further, because now we don't have to
> care about the buf item cleanup when dropping references.
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf_item.c  | 85 ++++++++++++++++++++++++------------------
> >  fs/xfs/xfs_buf_item.h  |  1 +
> >  fs/xfs/xfs_trans_buf.c | 22 +----------
> >  3 files changed, 51 insertions(+), 57 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index b39d1b5320e7..d0191451fe18 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -556,13 +556,12 @@ xfs_buf_item_unlock(
> >  {
> >  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> >  	struct xfs_buf		*bp = bip->bli_buf;
> > -	bool			freed;
> > -	bool			aborted;
> > +	bool			released;
> >  	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
> > -	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
> >  	bool			stale = bip->bli_flags & XFS_BLI_STALE;
> >  #if defined(DEBUG) || defined(XFS_WARN)
> >  	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
> > +	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
> >  #endif
> >  	trace_xfs_buf_item_unlock(bip);
> >  
> > @@ -574,8 +573,6 @@ xfs_buf_item_unlock(
> >  	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
> >  	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> >  
> > -	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags);
> > -
> >  	/*
> >  	 * Clear the buffer's association with this transaction and
> >  	 * per-transaction state from the bli, which has been copied above.
> > @@ -584,40 +581,16 @@ xfs_buf_item_unlock(
> >  	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
> >  
> >  	/*
> > -	 * Drop the transaction's bli reference and deal with the item if we had
> > -	 * the last one. We must free the item if clean or aborted since it
> > -	 * wasn't pinned by the log and this is the last chance to do so. If the
> > -	 * bli is freed and dirty (but non-aborted), the buffer was not dirty in
> > -	 * this transaction but modified by a previous one and still awaiting
> > -	 * writeback. In that case, the bli is freed on buffer writeback
> > -	 * completion.
> > +	 * Unref the item and unlock the buffer unless held or stale. Stale
> > +	 * buffers remain locked until final unpin unless the bli is freed by
> > +	 * the unref call. The latter implies shutdown because buffer
> > +	 * invalidation dirties the bli and transaction.
> >  	 */
> > -	freed = atomic_dec_and_test(&bip->bli_refcount);
> > -	if (freed) {
> > -		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
> > -		/*
> > -		 * An aborted item may be in the AIL regardless of dirty state.
> > -		 * For example, consider an aborted transaction that invalidated
> > -		 * a dirty bli and cleared the dirty state.
> > -		 */
> > -		if (aborted)
> > -			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> > -		if (aborted || !dirty)
> > -			xfs_buf_item_relse(bp);
> > -	} else if (stale) {
> > -		/*
> > -		 * Stale buffers remain locked until final unpin unless the bli
> > -		 * was freed in the branch above. A freed stale bli implies an
> > -		 * abort because buffer invalidation dirties the bli and
> > -		 * transaction.
> > -		 */
> > -		ASSERT(!freed);
> > +	released = xfs_buf_item_unref(bip);
> > +	if ((stale && !released) || hold)
> >  		return;
> 
> Personal preference, but I'd put the hold check first because it's
> not a compound logic statement.
> 

Ok.

> > +bool
> > +xfs_buf_item_unref(
> 
> "+xfs_buf_item_put()" to be consistent with dropping references on
> other reference counted objects (e.g.  iput, dput, bio_put,
> xfs_perag_put, xfs_log_ticket_put, etc).
> 

Works for me.

> > +	struct xfs_buf_log_item	*bip)
> > +{
> > +	struct xfs_log_item	*lip = &bip->bli_item;
> > +	bool			aborted;
> > +	bool			dirty;
> > +	bool			freed;
> > +
> > +	/* drop the bli ref and return if it wasn't the last one */
> > +	freed = atomic_dec_and_test(&bip->bli_refcount);
> > +	if (!freed)
> > +		return false;
> 
> We don't really need the freed variable here. This
> 
> 	if (!atomic_dec_and_test(refcount))
> 		return false
> 
> is a common enough "do something only when we drop the last
> reference" pattern that everyone should understand it by
> now.
> 

Yeah, I think I just missed that the associated asserts (where freed was
used) were made unnecessary by the simplified logic.

> > +	 * If the bli is dirty and non-aborted, the buffer was clean in the
> > +	 * transaction but still awaiting writeback from previous changes. In
> > +	 * that case, the bli is freed on buffer writeback completion.
> > +	 */
> > +	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
> > +		  XFS_FORCED_SHUTDOWN(lip->li_mountp);
> > +	dirty = bip->bli_flags & XFS_BLI_DIRTY;
> > +	if (!aborted && dirty)
> > +		return false;
> 
> Personal preference (again) is to check dirty first - same as the
> comment text mentions "dirty and not-aborted"...
> 

Makes sense. The dirty/clean state is also the more common/primary
consideration, whereas aborted == true should obviously be a
rare/outlier case.

> These are all minor things - I think it's a good improvement
> overall.
> 

Thanks. I'll send a v3 with the associated tweaks..

Brian

> Cheers,
> 
> dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
