Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726387AbeHXSbj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Aug 2018 14:31:39 -0400
Date: Fri, 24 Aug 2018 10:56:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't unlock invalidated buf on aborted tx commit
Message-ID: <20180824145634.GA29695@bfoster>
References: <20180821140116.15900-1-bfoster@redhat.com>
 <20180822002840.GP31495@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180822002840.GP31495@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 22, 2018 at 10:28:40AM +1000, Dave Chinner wrote:
> On Tue, Aug 21, 2018 at 10:01:16AM -0400, Brian Foster wrote:
> > xfstests generic/388,475 occasionally reproduce assertion failures
> > in xfs_buf_item_unpin() when the final bli reference is dropped on
> > an invalidated buffer and the buffer is not locked as it is expected
> > to be. Invalidated buffers should remain locked on transaction
> > commit until the final unpin, at which point the buffer is removed
> > from the AIL and the bli is freed since stale buffers are not
> > written back.
> > 
> > The assert failures are associated with filesystem shutdown,
> > typically due to log I/O errors injected by the test. The
> > problematic situation can occur if the shutdown happens to cause a
> > race between an active transaction that has invalidated a particular
> > buffer and an I/O error on a log buffer that contains the bli
> > associated with the same (now stale) buffer.
> > 
> > Both transaction and log contexts acquire a bli reference. If the
> > transaction has already invalidated the buffer by the time the I/O
> > error occurs and ends up aborting due to shutdown, the transaction
> > and log hold the last two references to a stale bli. If the
> > transaction cancel occurs first, it treats the buffer as non-stale
> > due to the aborted state: the bli reference is dropped and the
> > buffer is released/unlocked. The log buffer I/O error handling
> > eventually calls into xfs_buf_item_unpin(), drops the final
> > reference to the bli and treats it as stale. The buffer wasn't left
> > locked by xfs_buf_item_unlock(), however, so the assert fails and
> > the buffer is double unlocked. The latter problem is mitigated by
> > the fact that the fs is shutdown and no further damage is possible.
> > 
> > ->iop_unlock() of an invalidated buffer should behave consistently
> > with respect to the bli refcount, regardless of aborted state. If
> > the refcount remains elevated on commit, we know the bli is awaiting
> > an unpin (since it can't be in another transaction) and will be
> > handled appropriately on log buffer completion. If the final bli
> > reference of an invalidated buffer is dropped in ->iop_unlock(), we
> > can assume the transaction has aborted because invalidation implies
> > a dirty transaction. In the non-abort case, the log would have
> > acquired a bli reference in ->iop_pin() and prevented bli release at
> > ->iop_unlock() time. In the abort case the item must be freed and
> > buffer unlocked because it wasn't pinned by the log.
> > 
> > Rework xfs_buf_item_unlock() to simplify the currently circuitous
> > and duplicate logic and leave invalidated buffers locked based on
> > bli refcount, regardless of aborted state. This ensures that a
> > pinned, stale buffer is always found locked when eventually
> > unpinned.
> 
> Sounds reasonable to me.
> 
> BTW, can you follow this up by checking the freeing logic in
> xfs_trans_brelse()? There's a commented out assert that the pincount
> should be zero, implying that at some point there was a similar
> free within transaction context vs unpin from log io completion
> race occurring there.
> 

Circling back to this...

This function is a little bit of a mess as well. For example, we assert
for !stale but check for it further down in the function and treat it as
a dirty buffer. I don't think there's any similar stale buffer handling
issue simply because of that check; we aren't allowed to release an
invalidated buffer from the transaction. This implies that a stale bli
must ultimately be handled by ->iop_unlock() on transaction abort.

Moving further down in the function to bli_refcount handling... I think
the only xfs_trans_brelse() vs. ->iop_unpin() scenario is a pinned
buffer with a dirty bli modified by a previously committed transaction
vs. the buffer being released in another transaction in which it is
clean. The logic seems Ok to me there because on the brelse side, the
freed+shutdown case is essentially equivalent to the transaction abort.
Either side deals with the log item in the event of a shutdown and
dropping the last reference. If we are !shutdown, then the bli ref is
dropped to zero either by the transaction or the log, and the only way
the latter can occur is if the bli itself is dirty. IOW, if !dirty, then
brelse knows it just dropped the final reference (hence the bli_refcount
== 0 assert). If it is dirty, then we're back to the (confusing) state
where the bli hangs around until the buffer is written back, regardless
of the refcount going to zero.

I'm not really sure why the pincount assert is commented out. Based on
the current code, it looks like the pincount is essentially a subset of
the bli refcount. Looking at the old xfs repo, that line was commented
out in commit 9e99e135 ("Merge of 2.3.99pre2-xfs:slinx:44904a by
ananth."), which doesn't provide any useful info. It also commented out
another b_pincount check in xfs_buf_item_unpin() which was eventually
removed by commit 254f6311ed ("Implement deletion of inode clusters in
XFS.").

Brian

P.S., FWIW, I think the brelse() refcount handling could also be
refactored into something like the following (untested pseudocode):

        /*
         * At this point, the bli must be either freed or dirty (or both). If
         * freed, there are a couple additional conditions we must consider to
         * free the item properly. If the bli is clean, we're the last user of
         * the item. If the fs has shut down, the bli may be dirty and AIL
         * resident, but won't ever be written back.
         */
        ASSERT(freed || dirty);
        if (freed) {
                bool abort = XFS_FORCED_SHUTDOWN(tp->t_mountp);
                ASSERT(dirty || !test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
                if (abort)
                        xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
                if (!dirty || abort)
                        xfs_buf_item_relse(bp);
        }

I'd be hesitant to mess with this code just for aesthetic purposes.
OTOH, this looks quite like the refactored xfs_buf_item_unlock() bli
handling, which means it could be factored into a separate helper,
potentially simplifying the logic further. E.g., consider a "bool
released" return value that encapsulates whether the bli actually went
away and thus could be used to determine when to unlock a stale buffer
in ->iop_unlock(). Just a thought.

> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > This survives the assert reproducer, several xfstests runs with v4/v5
> > superblock filesystems, and fsstress and fsx workloads over a few hours.
> > 
> > Brian
> > 
> >  fs/xfs/xfs_buf_item.c | 85 +++++++++++++++++++------------------------
> >  1 file changed, 37 insertions(+), 48 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 1c9d1398980b..5e8b91543d93 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -556,73 +556,62 @@ xfs_buf_item_unlock(
> >  {
> >  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> >  	struct xfs_buf		*bp = bip->bli_buf;
> > +	int			freed;
> 
> atomic_dec_and_test() returns a bool.
> 
> >  	bool			aborted;
> >  	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
> >  	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
> > +	bool			stale = !!(bip->bli_flags & XFS_BLI_STALE);
> >  #if defined(DEBUG) || defined(XFS_WARN)
> >  	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
> >  #endif
> 
> Can we get rid of the "!!" here? The variables are booleans, so
> there's not need to do a double negation to squash the value down to
> 0 or 1 as the compiler will do that implicitly...
> 
> > +	/*
> > +	 * The bli dirty state should match whether the blf has logged segments
> > +	 * except for ordered buffers, where only the bli should be dirty.
> > +	 */
> > +	ASSERT((!ordered && dirty == xfs_buf_item_dirty_format(bip)) ||
> > +	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
> > +	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> > +	trace_xfs_buf_item_unlock(bip);
> 
> Can you put the trace before the asserts? If an assert fires, we
> want the ibuf item state in the event trace record...
> 
> Speaking of trace events, the trace_xfs_buf_item_unlock_stale()
> event is no longer called by this function. Can you remove it or
> or re-add it as per below?
> 
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
> 
> This logic is still a bit circuitous. We have one action if the item
> is freed, and another action if it not freed. But they are separated
> by large comments and it's not clear that we do one or the other,
> but not both. Maybe it would be clearer if it were structured like
> this:
> 
> 	/*
> 	 * Comment explaining life, the universe and everything.
> 	 */
> 	freed = atomic_dec_and_test(&bip->bli_refcount);
> 	if (freed) {
> 		if (aborted || !dirty) {
> 		....
> 	} else if (stale) {
> 		trace_xfs_buf_item_unlock_stale(bip);
> 		return;
> 	}
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
