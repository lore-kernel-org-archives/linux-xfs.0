Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49056 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934344AbcJQPyU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:54:20 -0400
Subject: Re: [PATCH] xfs: fix unbalanced inode reclaim flush locking
References: <1476716576-14427-1-git-send-email-bfoster@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5b9824d0-2cce-93a9-09ce-aa3c5825e4df@sandeen.net>
Date: Mon, 17 Oct 2016 10:54:18 -0500
MIME-Version: 1.0
In-Reply-To: <1476716576-14427-1-git-send-email-bfoster@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Cc: zlang@redhat.com

On 10/17/16 10:02 AM, Brian Foster wrote:
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
> the same problem. Finally, update xfs_reclaim_inode() to bitwise-OR the
> reclaim flag to avoid smashing the flush lock in the process (which is
> based on an inode flag in current kernels). This avoids a (spurious)
> failure of the newly introduced xfs_ifunlock() assertion.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reported-by: Zorro Lang <zlang@redhat.com>
> ---
>  fs/xfs/xfs_icache.c |  3 ++-
>  fs/xfs/xfs_inode.h  | 11 ++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 14796b7..7375313 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -982,6 +982,7 @@ restart:
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_iunpin_wait(ip);

I suppose comments here might help...

Other callers of xfs_iflush_abort include:

        /*
         * Unlocks the flush lock
         */

and immediately re-locking it here might be worth explaining as well.

>  		xfs_iflush_abort(ip, false);
> +		xfs_iflock(ip);
>  		goto reclaim;
>  	}
>  	if (xfs_ipincount(ip)) {

> @@ -1044,7 +1045,7 @@ reclaim:
>  	 * skip.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
> -	ip->i_flags = XFS_IRECLAIM;
> +	ip->i_flags |= XFS_IRECLAIM;
>  	ip->i_ino = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  

I think xfs_inode_free() should get the same |= treatment?

-Eric


> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index f14c1de..71e8a81 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -246,6 +246,11 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
>   * Synchronize processes attempting to flush the in-core inode back to disk.
>   */
>  
> +static inline int xfs_isiflocked(struct xfs_inode *ip)
> +{
> +	return xfs_iflags_test(ip, XFS_IFLOCK);
> +}
> +
>  extern void __xfs_iflock(struct xfs_inode *ip);
>  
>  static inline int xfs_iflock_nowait(struct xfs_inode *ip)
> @@ -261,16 +266,12 @@ static inline void xfs_iflock(struct xfs_inode *ip)
>  
>  static inline void xfs_ifunlock(struct xfs_inode *ip)
>  {
> +	ASSERT(xfs_isiflocked(ip));
>  	xfs_iflags_clear(ip, XFS_IFLOCK);
>  	smp_mb();
>  	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
>  }
>  
> -static inline int xfs_isiflocked(struct xfs_inode *ip)
> -{
> -	return xfs_iflags_test(ip, XFS_IFLOCK);
> -}
> -
>  /*
>   * Flags for inode locking.
>   * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
> 
