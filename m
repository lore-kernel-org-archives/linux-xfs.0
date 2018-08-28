Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:8853 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727067AbeH2CaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 22:30:16 -0400
Date: Wed, 29 Aug 2018 08:36:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: clean up xfs_trans_brelse()
Message-ID: <20180828223625.GA5631@dastard>
References: <20180827142548.45029-1-bfoster@redhat.com>
 <20180827142548.45029-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180827142548.45029-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 27, 2018 at 10:25:47AM -0400, Brian Foster wrote:
> xfs_trans_brelse() is a bit of a historical mess, similar to
> xfs_buf_item_unlock(). It is unnecessarily verbose, has snippets of
> commented out code, inconsistency with regard to stale items, etc.
> 
> Clean up xfs_trans_brelse() to use similar logic and flow as
> xfs_buf_item_unlock() with regard to bli reference count handling.
> This patch makes no functional changes, but facilitates further
> refactoring of the common bli reference count handling code.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Nice! I like it a lot. Couple of minor things....

> -	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
> -
>  	/*
> -	 * Free up the log item descriptor tracking the released item.
> +	 * Unlink the log item from the transaction and clear the hold flag, if
> +	 * set. We wouldn't want the next user of the buffer to get confused.
>  	 */
> +	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
>  	xfs_trans_del_item(&bip->bli_item);
> -
> -	/*
> -	 * Clear the hold flag in the buf log item if it is set.
> -	 * We wouldn't want the next user of the buffer to
> -	 * get confused.
> -	 */
> -	if (bip->bli_flags & XFS_BLI_HOLD) {
> +	if (bip->bli_flags & XFS_BLI_HOLD)
>  		bip->bli_flags &= ~XFS_BLI_HOLD;
> -	}

May as well just unconditionally clear XFS_BLI_HOLD - the cache line
is already dirty by this point, so it's less code than checking to
see if we do need to clear it.

>  	/*
> -	 * Drop our reference to the buf log item.
> +	 * Drop the reference to the bli. At this point, the bli must be either
> +	 * freed or dirty (or both). If freed, there are a couple cases where we
> +	 * are responsible to free the item. If the bli is clean, we're the last
> +	 * user of it. If the fs has shut down, the bli may be dirty and AIL
> +	 * resident, but won't ever be written back.
						    so we may also need to
	 * remove it from the AIL before freeing it
>  	 */
>  	freed = atomic_dec_and_test(&bip->bli_refcount);
> -
> -	/*
> -	 * If the buf item is not tracking data in the log, then we must free it
> -	 * before releasing the buffer back to the free pool.
> -	 *
> -	 * If the fs has shutdown and we dropped the last reference, it may fall
> -	 * on us to release a (possibly dirty) bli if it never made it to the
> -	 * AIL (e.g., the aborted unpin already happened and didn't release it
> -	 * due to our reference). Since we're already shutdown and need
> -	 * ail_lock, just force remove from the AIL and release the bli here.
> -	 */
> -	if (XFS_FORCED_SHUTDOWN(tp->t_mountp) && freed) {
> -		xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
> -		xfs_buf_item_relse(bp);
> -	} else if (!(bip->bli_flags & XFS_BLI_DIRTY)) {
> -/***
> -		ASSERT(bp->b_pincount == 0);
> -***/
> -		ASSERT(atomic_read(&bip->bli_refcount) == 0);
> -		ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
> -		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
> -		xfs_buf_item_relse(bp);
> +	dirty = bip->bli_flags & XFS_BLI_DIRTY;
> +	ASSERT(freed || dirty);
> +	if (freed) {
> +		bool abort = XFS_FORCED_SHUTDOWN(tp->t_mountp);
> +		ASSERT(abort || !test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
> +		if (abort)
> +			xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
> +		if (!dirty || abort)
> +			xfs_buf_item_relse(bp);
>  	}

That, overall, is much nicer than the current code and worth doing,
I think.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
