Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:38749 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbeHVDwB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Aug 2018 23:52:01 -0400
Date: Wed, 22 Aug 2018 10:28:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't unlock invalidated buf on aborted tx commit
Message-ID: <20180822002840.GP31495@dastard>
References: <20180821140116.15900-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180821140116.15900-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 21, 2018 at 10:01:16AM -0400, Brian Foster wrote:
> xfstests generic/388,475 occasionally reproduce assertion failures
> in xfs_buf_item_unpin() when the final bli reference is dropped on
> an invalidated buffer and the buffer is not locked as it is expected
> to be. Invalidated buffers should remain locked on transaction
> commit until the final unpin, at which point the buffer is removed
> from the AIL and the bli is freed since stale buffers are not
> written back.
> 
> The assert failures are associated with filesystem shutdown,
> typically due to log I/O errors injected by the test. The
> problematic situation can occur if the shutdown happens to cause a
> race between an active transaction that has invalidated a particular
> buffer and an I/O error on a log buffer that contains the bli
> associated with the same (now stale) buffer.
> 
> Both transaction and log contexts acquire a bli reference. If the
> transaction has already invalidated the buffer by the time the I/O
> error occurs and ends up aborting due to shutdown, the transaction
> and log hold the last two references to a stale bli. If the
> transaction cancel occurs first, it treats the buffer as non-stale
> due to the aborted state: the bli reference is dropped and the
> buffer is released/unlocked. The log buffer I/O error handling
> eventually calls into xfs_buf_item_unpin(), drops the final
> reference to the bli and treats it as stale. The buffer wasn't left
> locked by xfs_buf_item_unlock(), however, so the assert fails and
> the buffer is double unlocked. The latter problem is mitigated by
> the fact that the fs is shutdown and no further damage is possible.
> 
> ->iop_unlock() of an invalidated buffer should behave consistently
> with respect to the bli refcount, regardless of aborted state. If
> the refcount remains elevated on commit, we know the bli is awaiting
> an unpin (since it can't be in another transaction) and will be
> handled appropriately on log buffer completion. If the final bli
> reference of an invalidated buffer is dropped in ->iop_unlock(), we
> can assume the transaction has aborted because invalidation implies
> a dirty transaction. In the non-abort case, the log would have
> acquired a bli reference in ->iop_pin() and prevented bli release at
> ->iop_unlock() time. In the abort case the item must be freed and
> buffer unlocked because it wasn't pinned by the log.
> 
> Rework xfs_buf_item_unlock() to simplify the currently circuitous
> and duplicate logic and leave invalidated buffers locked based on
> bli refcount, regardless of aborted state. This ensures that a
> pinned, stale buffer is always found locked when eventually
> unpinned.

Sounds reasonable to me.

BTW, can you follow this up by checking the freeing logic in
xfs_trans_brelse()? There's a commented out assert that the pincount
should be zero, implying that at some point there was a similar
free within transaction context vs unpin from log io completion
race occurring there.

> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This survives the assert reproducer, several xfstests runs with v4/v5
> superblock filesystems, and fsstress and fsx workloads over a few hours.
> 
> Brian
> 
>  fs/xfs/xfs_buf_item.c | 85 +++++++++++++++++++------------------------
>  1 file changed, 37 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1c9d1398980b..5e8b91543d93 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -556,73 +556,62 @@ xfs_buf_item_unlock(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> +	int			freed;

atomic_dec_and_test() returns a bool.

>  	bool			aborted;
>  	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
>  	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
> +	bool			stale = !!(bip->bli_flags & XFS_BLI_STALE);
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
>  #endif

Can we get rid of the "!!" here? The variables are booleans, so
there's not need to do a double negation to squash the value down to
0 or 1 as the compiler will do that implicitly...

> +	/*
> +	 * The bli dirty state should match whether the blf has logged segments
> +	 * except for ordered buffers, where only the bli should be dirty.
> +	 */
> +	ASSERT((!ordered && dirty == xfs_buf_item_dirty_format(bip)) ||
> +	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
> +	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> +	trace_xfs_buf_item_unlock(bip);

Can you put the trace before the asserts? If an assert fires, we
want the ibuf item state in the event trace record...

Speaking of trace events, the trace_xfs_buf_item_unlock_stale()
event is no longer called by this function. Can you remove it or
or re-add it as per below?

> +	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags);
>  
>  	/*
> +	 * Clear the buffer's association with this transaction and
> +	 * per-transaction state from the bli, which has been copied above.
>  	 */
> +	bp->b_transp = NULL;
>  	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
>  
>  	/*
> +	 * Drop the transaction bli reference and free the item if clean or
> +	 * aborted and we had the last reference. In either case this is the
> +	 * last opportunity to free the item since it won't be written back.
> +	 * Otherwise, the bli is still referenced or dirty and will be freed on
> +	 * final unpin of the buffer (if stale) or writeback completion.
>  	 */
> +	freed = atomic_dec_and_test(&bip->bli_refcount);
> +	if (freed && (aborted || !dirty)) {
> +		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
> +		ASSERT(!stale || aborted);
> +		/* an aborted item may be in the AIL, remove it first */
> +		if (aborted)
> +			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_buf_item_relse(bp);
>  	}
>  
>  	/*
> +	 * If the buffer was invalidated, leave it locked on transaction commit
> +	 * unless we just dropped the final reference. The latter case should
> +	 * only ever happen on abort because invalidation dirties the
> +	 * transaction and the log would have grabbed another bli reference when
> +	 * the buffer was pinned. In the non-abort case, the buffer is unlocked
> +	 * on final unpin and the bli freed since stale buffers are not written
> +	 * back.
>  	 */
> +	if (stale && !freed)
> +		return;

This logic is still a bit circuitous. We have one action if the item
is freed, and another action if it not freed. But they are separated
by large comments and it's not clear that we do one or the other,
but not both. Maybe it would be clearer if it were structured like
this:

	/*
	 * Comment explaining life, the universe and everything.
	 */
	freed = atomic_dec_and_test(&bip->bli_refcount);
	if (freed) {
		if (aborted || !dirty) {
		....
	} else if (stale) {
		trace_xfs_buf_item_unlock_stale(bip);
		return;
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
