Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2888 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754866AbcJQXRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 19:17:41 -0400
Date: Tue, 18 Oct 2016 10:07:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: fix unbalanced inode reclaim flush locking
Message-ID: <20161017230756.GX23194@dastard>
References: <1476727673-19109-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476727673-19109-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, zlang@redhat.com

On Mon, Oct 17, 2016 at 02:07:53PM -0400, Brian Foster wrote:
> Filesystem shutdown testing on an older distro kernel has uncovered an
> imbalanced locking pattern for the inode flush lock in
> xfs_reclaim_inode(). Specifically, there is a double unlock sequence
> between the call to xfs_iflush_abort() and xfs_reclaim_inode() at the
> "reclaim:" label.
> 
> This actually does not cause obvious problems on current kernels due to
> the current flush lock implementation. Older kernels use a counting
> based flush lock mechanism, however, which effectively breaks the lock
> indefinitely when an already unlocked flush lock is repeatedly unlocked.
> Though this only currently occurs on filesystem shutdown, it has
> reproduced the effect of elevating an fs shutdown to a system-wide crash
> or hang.
> 
> Because this problem exists on filesystem shutdown and thus only after
> unrelated catastrophic failure, issue the simple fix to reacquire the
> flush lock in xfs_reclaim_inode() before jumping to the reclaim code.
> Add an assert to xfs_ifunlock() to help prevent future occurrences of
> the same problem. Finally, update a couple places to bitwise-OR the
> reclaim flag to avoid smashing the flush lock in the process (which is
> based on an inode flag in current kernels). This avoids a (spurious)
> failure of the newly introduced xfs_ifunlock() assertion.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reported-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> v2:
> - Add comment in xfs_reclaim_inode() wrt to flush lock.
> - Fix XFS_IRECLAIM usage in xfs_inode_free().
> 
>  fs/xfs/xfs_icache.c |  9 +++++++--
>  fs/xfs/xfs_inode.h  | 11 ++++++-----
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 14796b7..2317b74 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -140,7 +140,7 @@ xfs_inode_free(
>  	 * races.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
> -	ip->i_flags = XFS_IRECLAIM;
> +	ip->i_flags |= XFS_IRECLAIM;
>  	ip->i_ino = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  
> @@ -981,7 +981,12 @@ restart:
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_iunpin_wait(ip);
> +		/*
> +		 * xfs_iflush_abort() drops the flush lock. Reacquire it as the
> +		 * reclaim code expects to drop the flush lock.
> +		 */
>  		xfs_iflush_abort(ip, false);
> +		xfs_iflock(ip);
>  		goto reclaim;
>  	}
>  	if (xfs_ipincount(ip)) {
> @@ -1044,7 +1049,7 @@ reclaim:
>  	 * skip.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
> -	ip->i_flags = XFS_IRECLAIM;
> +	ip->i_flags |= XFS_IRECLAIM;
>  	ip->i_ino = 0;
>  	spin_unlock(&ip->i_flags_lock);

I'd prefer that we don't change this - an inode that has had it's
inode number cleared should also only have XFS_IRECLAIM set in it's
flags.

FWIW, there is nothing that should be waiting on the flush lock by
this point - we hold the inode locked exclusively, there are not
other references to the inode, and we've got a clean inode. As long
as we've cycled the flush lock inside the current XFS_ILOCK_EXCL
hold, then we can guarantee the inode is clean and nothing is
waiting on the flush lock as you have to hold the ILOCK before
grabbing the flush lock.

Hence it doesn't matter if we hold or don't hold the flush lock
at the point where we set ip->i_flags = XFS_IRECLAIM and ip->i_ino =
0 - clearing the bit drops the flush lock if we hold it, and
clearing ip->i_ino means that any lookups inside the RCU grace
period (either from xfs_iflush_cluster or cache lookups) means
they'll drop the inode without doing anything with it.

Hence it think we can simple do something like:

 	}
 
-	xfs_iflock(ip);
 reclaim:
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always appears
 	 * to be reclaimed with an invalid inode number when in the free state.
 	 * We do this as early as possible under the ILOCK and flush lock so
 	 * that xfs_iflush_cluster() can be guaranteed to detect races with us
 	 * here. By doing this, we guarantee that once xfs_iflush_cluster has
 	 * locked both the XFS_ILOCK and the flush lock that it will see either
 	 * a valid, flushable inode that will serialise correctly against the
 	 * locks below, or it will see a clean (and invalid) inode that it can
 	 * skip.
+	 *
+	 * If we are currently holding the flush lock, then nothing else can
+	 * be waiting on it as we hold the XFS_ILOCK_EXCL. Resetting the i_flags
+	 * here effectively unlocks the flush lock if we currently hold it,
+	 * but it's a no-op if we don't hold it. This means we don't have to
+	 * add a lock cycle to the paths that drop the flush lock due to
+	 * IO completion or abort here.
 	 */
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
 	ip->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
-	xfs_ifunlock(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);

The rest of the code (adding the assert to xfs_ifunlock()) looks
fine, but this code here is quite special because of the way it
controls behaviour of the inode lookups within the RCU grace
period...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
