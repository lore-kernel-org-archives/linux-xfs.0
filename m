Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:52782 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756145AbcJRWnv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 18:43:51 -0400
Date: Wed, 19 Oct 2016 09:43:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: switch buffer cache entries to RCU freeing
Message-ID: <20161018224347.GE23194@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
 <1476821653-2595-3-git-send-email-dev@lynxeye.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476821653-2595-3-git-send-email-dev@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2016 at 10:14:13PM +0200, Lucas Stach wrote:
> The buffer cache hash as the indexing data structure into the buffer
> cache is already protected by RCU. By freeing the entries itself by
> RCU we can get rid of the buffer cache lock altogether.
> 
> Signed-off-by: Lucas Stach <dev@lynxeye.de>
> ---
>  fs/xfs/xfs_buf.c   | 41 +++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_buf.h   |  2 ++
>  fs/xfs/xfs_mount.h |  1 -
>  3 files changed, 29 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 50c5b01..3ee0a3d1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -326,6 +326,16 @@ xfs_buf_free(
>  	kmem_zone_free(xfs_buf_zone, bp);
>  }
>  
> +STATIC void
> +__xfs_buf_rcu_free(
> +	struct rcu_head	*head)
> +{
> +	xfs_buf_t *bp = container_of(head, struct xfs_buf, rcu_head);
> +
> +	ASSERT(atomic_read(&bp->b_hold) == 0);
> +	xfs_buf_free(bp);
> +}
> +
>  /*
>   * Allocates all the pages for buffer in question and builds it's page list.
>   */
> @@ -491,6 +501,14 @@ _xfs_buf_cmp(
>  	BUILD_BUG_ON(offsetof(struct xfs_buf_cmp_arg, blkno) != 0);
>  
>  	if (bp->b_bn == cmp_arg->blkno) {
> +		/*
> +		 * Skip matches with a hold count of zero, as they are about to
> +		 * be freed by RCU. Continue searching as another valid entry
> +		 * might have already been inserted into the hash.
> +		 */
> +		if (unlikely(atomic_read(&bp->b_hold) == 0))
> +			return 1;

This is an invalid assumption. Buffers transition through a hold
count of zero when they get moved to the LRU list, which then adds
a reference for the LRU list so the hold count goes back above zero.
The pag_buf_lock serialised this 1->0->1 hold count change so it
wasn't ever seen by lookups or concurrent xfs_buf_rele() calls.

Removing the pag_buf_lock around freeing of buffers and lookup
exposes this transition to lookup and so b_hold cannot be used like
this to determine if a buffer is being freed or not.

Like I said, there is some really subtle stuff in the buffer
lifecycle management....

Hmmmm - because this is now all RCU-ised, we are going to need some
form of memory barrier to ensure that whatever we use to detect
buffers in the RCU grace period is race free. I suspect the easiest
thing to do is to use the bp->b_lock spinlock to set a noticable
"buffer being freed" state in xfs_buf_rele() that we can check in
lookup under the spinlock. That way the lock provides the memory
barrier we need and it also provides serialisation against
transient hold count values in xfs_buf_rele() similar to what the
pag_buf_lock used to provide....

(FYI: the internal object spinlock pattern is what we use for the
RCU lookup vs freeing serialisation in the XFS inode cache....)

> @@ -580,14 +597,16 @@ _xfs_buf_find(
>  	pag = xfs_perag_get(btp->bt_mount,
>  			    xfs_daddr_to_agno(btp->bt_mount, cmp_arg.blkno));
>  
> +	rcu_read_lock();
>  	/* lookup buf in pag hash */
> -	spin_lock(&pag->pag_buf_lock);
>  	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmp_arg,
>  				    xfs_buf_hash_params);
> -	if (bp) {
> -		atomic_inc(&bp->b_hold);
> +
> +	/* if the hold count is zero the buffer is about to be freed by RCU */
> +	if (bp && atomic_inc_not_zero(&bp->b_hold))
>  		goto found;
> -	}
> +
> +	rcu_read_unlock();

This has the same problem with transient 0 hold counts in
xfs_buf_rele(). I suspect that we need to take the hold reference in
the xfs_buf_rhash_compare() function where we need to take the
bp->b_lock() to check for the buffer being in the rcu grace
period. If it's not being freed, we should take a reference right
then so that it doesn't get freed between the lookup check and the
buffer being returned...

> @@ -975,9 +991,8 @@ xfs_buf_rele(
>  
>  	ASSERT(atomic_read(&bp->b_hold) > 0);
>  
> -	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
>  	spin_lock(&bp->b_lock);
> -	if (!release) {
> +	if (!atomic_dec_and_test(&bp->b_hold)) {
>  		/*
>  		 * Drop the in-flight state if the buffer is already on the LRU
>  		 * and it holds the only reference. This is racy because we
> @@ -1001,7 +1016,6 @@ xfs_buf_rele(
>  			bp->b_state &= ~XFS_BSTATE_DISPOSE;
>  			atomic_inc(&bp->b_hold);
>  		}
> -		spin_unlock(&pag->pag_buf_lock);

This is the atomic_inc that makes the hold count go from 0->1 again
after adding the buffer to the LRU instead of freeing it. It is
inside the bp->b_lock, so we should be able to serialise lookups
using that lock.

Perhaps a new state flag that is only set when we are about to free
the buffer (XFS_BSTATE_FREE) is what we should add here, rather than
trying to play games checking and serialising bp->b_hold updates....

> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -210,6 +210,8 @@ typedef struct xfs_buf {
>  
>  	const struct xfs_buf_ops	*b_ops;
>  
> +	struct rcu_head		rcu_head;

Make it a union with the b_lru field so the structure doesn't grow
just for RCU freeing support.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
