Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4265 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965157AbcJRWSy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 18:18:54 -0400
Date: Wed, 19 Oct 2016 09:18:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: use rhashtable to track buffer cache
Message-ID: <20161018221849.GD23194@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
 <1476821653-2595-2-git-send-email-dev@lynxeye.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476821653-2595-2-git-send-email-dev@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2016 at 10:14:12PM +0200, Lucas Stach wrote:
> On filesystems with a lot of metadata and in metadata intensive workloads
> xfs_buf_find() is showing up at the top of the CPU cycles trace. Most of
> the CPU time is spent on CPU cache misses while traversing the rbtree.
> 
> As the buffer cache does not need any kind of ordering, but fast lookups
> a hashtable is the natural data structure to use. The rhashtable
> infrastructure provides a self-scaling hashtable implementation and
> allows lookups to proceed while the table is going through a resize
> operation.
> 
> This reduces the CPU-time spent for the lookups to 1/3 even for small
> filesystems with a relatively small number of cached buffers, with
> possibly much larger gains on higher loaded filesystems.
> 
> The minimum size of 4096 buckets was chosen as it was the size of the
> xfs buffer cache hash before it was converted to an rbtree.

That hashs table size was for the /global/ hash table. We now have a
cache per allocation group, so we most definitely don't want 4k
entries per AG as the default. THink of filesystems with hundreds of
even thousands of AGs....

I'd suggest that we want to make the default something much smaller;
maybe even as low as 32 buckets. It will grow quickly as the load
comes onto the filesystem....

> 
> Signed-off-by: Lucas Stach <dev@lynxeye.de>
> ---
>  fs/xfs/xfs_buf.c   | 118 ++++++++++++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_buf.h   |   2 +-
>  fs/xfs/xfs_linux.h |   1 +
>  fs/xfs/xfs_mount.c |   7 +++-
>  fs/xfs/xfs_mount.h |   7 +++-
>  5 files changed, 88 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b5b9bff..50c5b01 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -219,7 +219,6 @@ _xfs_buf_alloc(
>  	init_completion(&bp->b_iowait);
>  	INIT_LIST_HEAD(&bp->b_lru);
>  	INIT_LIST_HEAD(&bp->b_list);
> -	RB_CLEAR_NODE(&bp->b_rbnode);
>  	sema_init(&bp->b_sema, 0); /* held, no waiters */
>  	spin_lock_init(&bp->b_lock);
>  	XB_SET_OWNER(bp);
> @@ -473,7 +472,66 @@ _xfs_buf_map_pages(
>  /*
>   *	Finding and Reading Buffers
>   */
> +struct xfs_buf_cmp_arg {
> +	xfs_daddr_t	blkno;
> +	int		numblks;
> +};

That's a struct xfs_buf_map.

> +int
> +_xfs_buf_cmp(

static? Also, no leading underscore, and perhaps it should be called
xfs_buf_rhash_compare()....

> +	struct rhashtable_compare_arg *arg,
> +	const void *obj)
> +{
> +	const struct xfs_buf_cmp_arg *cmp_arg = arg->key;
> +	const struct xfs_buf *bp = obj;

Tab spacing for variables.

	struct rhashtable_compare_arg	*arg,
	const void			*obj)
{
	const struct xfs_buf_map	*map = arg->key;
	const struct xfs_buf		*bp = obj;


> +
> +	/*
> +	 * The key hashing in the lookup path depends on the key being the
> +	 * first element of the compare_arg, make sure to assert this.
> +	 */
> +	BUILD_BUG_ON(offsetof(struct xfs_buf_cmp_arg, blkno) != 0);
> +
> +	if (bp->b_bn == cmp_arg->blkno) {
> +		if (unlikely(bp->b_length != cmp_arg->numblks)) {
> +			/*
> +			 * found a block number match. If the range doesn't
> +			 * match, the only way this is allowed is if the buffer
> +			 * in the cache is stale and the transaction that made
> +			 * it stale has not yet committed. i.e. we are
> +			 * reallocating a busy extent. Skip this buffer and
> +			 * continue searching for an exact match.
> +			 */
> +			ASSERT(bp->b_flags & XBF_STALE);
> +			return 1;
> +		}
> +
> +		return 0;
> +	}
> +
> +	return 1;

Change the logic to reduce indentation, and don't use unlikely().
gcc already hints branches that return as unlikely for code layout
purposes. However, it's been shown repeatedly that static hints like
this are wrong in the vast majority of the places they are used and
the hardware branch predictors do a far better job than humans.
So something like:

	if (bp->b_bn != map->bm_bn)
		return 1;

	/*
	 * Found a block number match. If the range doesn't match,
	 * the only way this is allowed is if the buffer in the
	 * cache is stale and the transaction that made it stale has
	 * not yet committed. i.e. we are reallocating a busy
	 * extent. Skip this buffer and continue searching for an
	 * exact match.
	 */
	if (unlikely(bp->b_length != cmp_arg->numblks)) {
		ASSERT(bp->b_flags & XBF_STALE);
		return 1;
	}

	return 0;

> +}
> +static const struct rhashtable_params xfs_buf_hash_params = {
> +	.min_size = 4096,
> +	.nelem_hint = 3072,

What does this hint do?

> +	.key_len = sizeof(xfs_daddr_t),
> +	.key_offset = offsetof(struct xfs_buf, b_bn),
> +	.head_offset = offsetof(struct xfs_buf, b_rhash_head),
> +	.automatic_shrinking = true,

Hmmm - so memory pressure is going to cause this hash to be resized
as the shrinker frees buffers. That, in turn, will cause the
rhashtable code to run GFP_KERNEL allocations, which could result in
it re-entering the shrinker and trying to free buffers which will
modify the hash table.

That doesn't seem like a smart thing to do to me - it seems to me
like it introduces a whole new avenue for memory reclaim deadlocks
(or, at minimum, lockdep false positives) to occur....

> +	.obj_cmpfn = _xfs_buf_cmp,
> +};
> +
> +int xfs_buf_hash_init(
> +	struct xfs_perag *pag)
> +{
> +	spin_lock_init(&pag->pag_buf_lock);
> +	return rhashtable_init(&pag->pag_buf_hash, &xfs_buf_hash_params);
> +}
>  
> +void
> +xfs_buf_hash_destroy(
> +	struct xfs_perag *pag)
> +{
> +	rhashtable_destroy(&pag->pag_buf_hash);
> +}
>  /*
>   *	Look up, and creates if absent, a lockable buffer for
>   *	a given range of an inode.  The buffer is returned
> @@ -488,16 +546,13 @@ _xfs_buf_find(
>  	xfs_buf_t		*new_bp)
>  {
>  	struct xfs_perag	*pag;
> -	struct rb_node		**rbp;
> -	struct rb_node		*parent;
>  	xfs_buf_t		*bp;
> -	xfs_daddr_t		blkno = map[0].bm_bn;
> +	struct xfs_buf_cmp_arg	cmp_arg = { .blkno = map[0].bm_bn };

it's a compare map, so maybe call it cmap? And I'd move the
initialisation down to where the block count is initialised,
too.

> -	/* get tree root */
> +	/* get pag */

Comment is now redundant.

>  	pag = xfs_perag_get(btp->bt_mount,
> -				xfs_daddr_to_agno(btp->bt_mount, blkno));
> +			    xfs_daddr_to_agno(btp->bt_mount, cmp_arg.blkno));
>  
> -	/* walk tree */
> +	/* lookup buf in pag hash */

Comment is also now redundant.

[...]
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index fc78739..b9a9a58 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -157,6 +157,7 @@ xfs_free_perag(
>  		spin_unlock(&mp->m_perag_lock);
>  		ASSERT(pag);
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
> +		xfs_buf_hash_destroy(pag);
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
>  	}
>  }
> @@ -212,8 +213,8 @@ xfs_initialize_perag(
>  		spin_lock_init(&pag->pag_ici_lock);
>  		mutex_init(&pag->pag_ici_reclaim_lock);
>  		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
> -		spin_lock_init(&pag->pag_buf_lock);
> -		pag->pag_buf_tree = RB_ROOT;
> +		if (xfs_buf_hash_init(pag))
> +			goto out_unwind;
>  
>  		if (radix_tree_preload(GFP_NOFS))
>  			goto out_unwind;
> @@ -239,9 +240,11 @@ xfs_initialize_perag(
>  	return 0;
>  
>  out_unwind:
> +	xfs_buf_hash_destroy(pag);

I don't think this is correct for the case that xfs_buf_hash_init()
fails as the rhashtable_destroy() function assumes the init
completed successfully. i.e. this will oops with a null pointer.
So I think an error stack like this is needed:

 		if (radix_tree_preload(GFP_NOFS))
-			goto out_unwind;
+			goto out_destroy_hash;
....
+out_destroy_hash:
+	xfs_buf_hash_destroy(pag);
+out_unwind:
>  	kmem_free(pag);
>  	for (; index > first_initialised; index--) {
>  		pag = radix_tree_delete(&mp->m_perag_tree, index);
> +		xfs_buf_hash_destroy(pag);
>  		kmem_free(pag);
>  	}
>  	return error;

> index 819b80b..84f7852 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -393,8 +393,8 @@ typedef struct xfs_perag {
>  	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
>  
>  	/* buffer cache index */
> -	spinlock_t	pag_buf_lock;	/* lock for pag_buf_tree */
> -	struct rb_root	pag_buf_tree;	/* ordered tree of active buffers */
> +	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
> +	struct rhashtable pag_buf_hash;
>  
>  	/* for rcu-safe freeing */
>  	struct rcu_head	rcu_head;
> @@ -424,6 +424,9 @@ xfs_perag_resv(
>  	}
>  }
>  
> +int xfs_buf_hash_init(xfs_perag_t *pag);
> +void xfs_buf_hash_destroy(xfs_perag_t *pag);

No typedefs, please. Also, shouldn't these be defined in
fs/xfs/xfs_buf.h?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
