Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8DGruuR082112 for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 11:53:56 -0500
Subject: Re: [PATCH 4/4] xfs: convert buffer cache hash to rbtree
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1283958778-28610-5-git-send-email-david@fromorbit.com>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-5-git-send-email-david@fromorbit.com>
Date: Mon, 13 Sep 2010 11:53:49 -0500
Message-ID: <1284396829.2404.52.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2010-09-09 at 01:12 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The buffer cache hash is starting to show typical hash scalability
> problems.  large scale testing is showing the number of cached items
> growing far larger than the hash can efficiently handle. Hence we
> need to move to a self-scaling cache indexing mechanism.
> 
> I have selected rbtrees for indexing becuse they can have O(log n)
> search scalability, and insert and remove cost is not excessive,
> even on large trees. Hence we should be able to cache large numbers
> of buffers without incurring the excessive cache miss search
> penalties that the hash is imposing on us.
> 
> To ensure we still have parallel access to the cache, we need
> multiple trees. Rather than hashing the buffers by disk address to
> select a tree, it seems more sensible to separate trees by typical
> access patterns. Most operations use buffers from within a single AG
> at a time, so rather than searching lots of different lists,
> separate the buffer indexes out into per-AG rbtrees. This means that
> searches during metadata operation have a much higher chance of
> hitting cache resident nodes, and that updates of the tree are less
> likely to disturb trees being accessed on other CPUs doing
> independent operations.

I found a bug in this, and have a bunch of other less
important comments for you to consider.  I haven't spent
any time contemplating your decision to use RB trees on
AG's but it seems quite reasonable.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c   |  139 +++++++++++++++++++++--------------------
>  fs/xfs/linux-2.6/xfs_buf.h   |   14 ++--
>  fs/xfs/linux-2.6/xfs_super.c |    6 +-
>  fs/xfs/xfs_ag.h              |    4 +
>  fs/xfs/xfs_mount.c           |    4 +-
>  5 files changed, 87 insertions(+), 80 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index b2b5dea..facd37e 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c

. . .

> @@ -432,14 +434,36 @@ _xfs_buf_find(
>  	ASSERT(!(range_length < (1 << btp->bt_sshift)));
>  	ASSERT(!(range_base & (xfs_off_t)btp->bt_smask));
>  
> -	hash = &btp->bt_hash[hash_long((unsigned long)ioff, btp->bt_hashshift)];
> -
> -	spin_lock(&hash->bh_lock);
> -
> -	list_for_each_entry_safe(bp, n, &hash->bh_list, b_hash_list) {
> -		ASSERT(btp == bp->b_target);
> -		if (bp->b_file_offset == range_base &&
> -		    bp->b_buffer_length == range_length) {
> +	/* get tree root */
> +	pag = xfs_perag_get(btp->bt_mp, xfs_daddr_to_agno(btp->bt_mp, ioff));
> +
> +	/* walk tree */
> +	spin_lock(&pag->pagbuf_lock);
> +	rbp = &pag->pagbuf_tree.rb_node;
> +	parent = NULL;

Could drop the above assignment and change the while
statement to read:  while ((parent = *rbp)) {
(I know that leads to a mildly controversial style.)

> +	bp = NULL;
> +	while (*rbp) {
> +		parent = *rbp;
> +		bp = rb_entry(parent, struct xfs_buf, b_rbnode);

Below here you might as well make use of the
value of "parent" in places where (*rbp) is used.
I realize you're just mimicking what's in the
rbtree.h file though...  If the result seems to
read funny, maybe you could rename "parent" to
be "entry" or something.

Here's the BUG:

> +		if (bp->b_file_offset < range_base)
> +			rbp = &(*rbp)->rb_left;
> +		else if (bp->b_file_offset > range_base)
> +			rbp = &(*rbp)->rb_right;

Your comparisons here are reversed.  In other words,
I believe it should be:

	if (range_base < bp->b_file_offset)	
		rbp = &parent->rb_left;
	else if (range_base > bp->b_file_offset)
		rbp = &parent->rb_right;

Maybe it mostly works in the order you have it,
but I'm pretty sure it's wrong.  (The "continue
searching to the right" below would be wrong though.)


> +		else {
> +			/*
> +			 * found a block offset match. If the range doesn't
> +			 * match, the only way this is allowed is if the buffer
> +			 * in the cache is stale and the transaction that made
> +			 * it stale has not yet committed. i.e. we are
> +			 * reallocating a busy extent. Skip this buffer and
> +			 * continue searching to the right for an exact match.
> +			 */
> +			if (bp->b_buffer_length != range_length) {
> +				ASSERT(bp->b_flags & XBF_STALE);

This assertion is new.  I trust it's correct, but
maybe it should go in separately (first).

> +				rbp = &(*rbp)->rb_right;
> +				continue;
> +			}
>  			atomic_inc(&bp->b_hold);
>  			goto found;
>  		}

When I first read the next hunk I thought you were
mistakenly not dropping the perag reference.  Later
I realized it was intentional--that the buffer holds
a reference on the perag until it (the buffer) is
released.  This is a minor point but I think it would
be helpful to see a comment explaining that.

> @@ -449,17 +473,20 @@ _xfs_buf_find(
>  	if (new_bp) {
>  		_xfs_buf_initialize(new_bp, btp, range_base,
>  				range_length, flags);
> -		new_bp->b_hash = hash;
> -		list_add(&new_bp->b_hash_list, &hash->bh_list);
> +		new_bp->b_pag = pag;
> +		rb_link_node(&new_bp->b_rbnode, parent, rbp);
> +		rb_insert_color(&new_bp->b_rbnode, &pag->pagbuf_tree);
> +		spin_unlock(&pag->pagbuf_lock);
>  	} else {
>  		XFS_STATS_INC(xb_miss_locked);
> +		spin_unlock(&pag->pagbuf_lock);
> +		xfs_perag_put(pag);
>  	}
> -
> -	spin_unlock(&hash->bh_lock);
>  	return new_bp;
>  
>  found:
> -	spin_unlock(&hash->bh_lock);
> +	spin_unlock(&pag->pagbuf_lock);
> +	xfs_perag_put(pag);
>  
>  	/* Attempt to get the semaphore without sleeping,
>  	 * if this does not work then we need to drop the
> @@ -810,27 +837,30 @@ void
>  xfs_buf_rele(
>  	xfs_buf_t		*bp)
>  {
> -	xfs_bufhash_t		*hash = bp->b_hash;
> +	struct xfs_perag	*pag = bp->b_pag;
>  
>  	trace_xfs_buf_rele(bp, _RET_IP_);
>  
> -	if (unlikely(!hash)) {
> +	if (!pag) {

I know this is not related to your change, but I'm
curious whether this can even happen, and if so, when?

>  		ASSERT(!bp->b_relse);
> +		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
>  		if (atomic_dec_and_test(&bp->b_hold))
>  			xfs_buf_free(bp);
>  		return;
>  	}
>  
> +	ASSERT(!RB_EMPTY_NODE(&bp->b_rbnode));
>  	ASSERT(atomic_read(&bp->b_hold) > 0);
> -	if (atomic_dec_and_lock(&bp->b_hold, &hash->bh_lock)) {
> +	if (atomic_dec_and_lock(&bp->b_hold, &pag->pagbuf_lock)) {
>  		if (bp->b_relse) {
>  			atomic_inc(&bp->b_hold);
> -			spin_unlock(&hash->bh_lock);
> +			spin_unlock(&pag->pagbuf_lock);
>  			(*(bp->b_relse)) (bp);

Drop the excess parentheses here (above) while you're at it.

>  		} else {
>  			ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
> -			list_del_init(&bp->b_hash_list);
> -			spin_unlock(&hash->bh_lock);
> +			rb_erase(&bp->b_rbnode, &pag->pagbuf_tree);
> +			spin_unlock(&pag->pagbuf_lock);
> +			xfs_perag_put(pag);
>  			xfs_buf_free(bp);
>  		}
>  	}
> @@ -1433,57 +1463,25 @@ xfs_buf_iomove(
>   */
>  void
>  xfs_wait_buftarg(
> -	xfs_buftarg_t	*btp)
> +	struct xfs_buftarg	*btp)
>  {
> -	xfs_bufhash_t	*hash;
> -	uint		i;
> +	struct xfs_perag	*pag;
> +	uint			i;
>  
> -	for (i = 0; i < (1 << btp->bt_hashshift); i++) {
> -		hash = &btp->bt_hash[i];
> -		spin_lock(&hash->bh_lock);
> -		while (!list_empty(&hash->bh_list)) {
> -			spin_unlock(&hash->bh_lock);
> +	for (i = 0; i < btp->bt_mp->m_sb.sb_agcount; i++) {
> +		pag = xfs_perag_get(btp->bt_mp, i);
> +		spin_lock(&pag->pagbuf_lock);
> +		while (rb_first(&pag->pagbuf_tree)) {
> +			spin_unlock(&pag->pagbuf_lock);
>  			delay(100);
> -			spin_lock(&hash->bh_lock);
> +			spin_lock(&pag->pagbuf_lock);
>  		}
> -		spin_unlock(&hash->bh_lock);
> +		spin_unlock(&pag->pagbuf_lock);
> +		xfs_perag_put(pag);
>  	}
>  }

This suggestion is again not related to your change, but...
Would this basic structure (not tested) be better than
the above?

	int more;

	do {
		more = 0;
		for (i = 0; i < btp->bt_mp->m_sb.sb_agcount; i++) {
			pag = xfs_perag_get(btp->bt_mp, i);
			spin_lock(&pag->pagbuf_lock);
			if (rb_first(&pag->pagbuf_tree))
				more++;
			spin_unlock(&pag->pagbuf_lock);
			xfs_perag_put(pag);
		}
		if (more)
			delay(100);
	} while (more);
>  
>  /*
> - *	Allocate buffer hash table for a given target.
> - *	For devices containing metadata (i.e. not the log/realtime devices)
> - *	we need to allocate a much larger hash table.

. . . 

> @@ -1645,6 +1643,12 @@ xfs_alloc_buftarg(
>  
>  	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP);
>  
> +	/*
> +	 * The buftarg cache should never be used by external devices.

I suggest that "buftarg cache" is not a good name for the
(now per-AG) buffer cache.

> +	 * Ensure we catch any users with extreme prejudice.
> +	 */
> +	btp->bt_mp = external ? NULL : mp;
> +
>  	btp->bt_dev =  bdev->bd_dev;
>  	btp->bt_bdev = bdev;
>  	if (xfs_setsize_buftarg_early(btp, bdev))
> @@ -1653,7 +1657,6 @@ xfs_alloc_buftarg(
>  		goto error;
>  	if (xfs_alloc_delwrite_queue(btp, fsname))
>  		goto error;
> -	xfs_alloc_bufhash(btp, external);
>  	return btp;
>  
>  error:
> diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
> index 802dc5e..3797ee8 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.h
> +++ b/fs/xfs/linux-2.6/xfs_buf.h
. . .
> @@ -171,8 +170,8 @@ typedef struct xfs_buf {
>  	wait_queue_head_t	b_waiters;	/* unpin waiters */
>  	struct list_head	b_list;
>  	xfs_buf_flags_t		b_flags;	/* status flags */
> -	struct list_head	b_hash_list;	/* hash table list */
> -	xfs_bufhash_t		*b_hash;	/* hash table list start */
> +	struct rb_node		b_rbnode;	/* rbtree node */
> +	struct xfs_perag	*b_pag;		/* rbtree root */

Rather, "contains rbtree root" (in the comment).

>  	xfs_buftarg_t		*b_target;	/* buffer target (device) */
>  	atomic_t		b_hold;		/* reference count */
>  	xfs_daddr_t		b_bn;		/* block number for I/O */

. . . 

> diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
> index 4917d4e..e01d4cf 100644
> --- a/fs/xfs/xfs_ag.h
> +++ b/fs/xfs/xfs_ag.h
> @@ -230,6 +230,10 @@ typedef struct xfs_perag {
>  	rwlock_t	pag_ici_lock;	/* incore inode lock */
>  	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
>  	int		pag_ici_reclaimable;	/* reclaimable inodes */
> +
> +	/* buffer cache index */
> +	spinlock_t	pagbuf_lock;	/* lock for pagbuf_tree */
> +	struct rb_root	pagbuf_tree;	/* ordered tree of active buffers */

I know it's in some way consistent with the rest of the
naming scheme for fields in this structure, maybe these
could be named pag_buf_lock and pag_buf_tree.  (The rest
of the fields here have a sort of strange convention and
maybe they've got strong enough history that they should
be left alone.)

>  #endif
>  	int		pagb_count;	/* pagb slots in use */
>  } xfs_perag_t;

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
