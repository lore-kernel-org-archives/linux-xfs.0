Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8N0joN1092180 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 19:45:50 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 881AA940BC
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 17:46:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	eAVuqYwMDCcZ3Uxn for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 17:46:42 -0700 (PDT)
Date: Thu, 23 Sep 2010 10:46:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/16] xfs: convert buffer cache hash to rbtree
Message-ID: <20100923004640.GM2614@dastard>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285188932.2211.44.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285188932.2211.44.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 22, 2010 at 03:55:32PM -0500, Alex Elder wrote:
> On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> > This patchset started out as a "convert the buffer cache to rbtrees"
> > patch, and just gew from there as I peeled the onion from one
> > bottleneck to another. The second version of this patch does not go
> > as far as the first version - it drops the more radical changes as
> > they are not ready for integration yet.
> 
> I saw patches 01-14 and 16, but no 15.  Was that
> intentionally excluded, or an oversight?

No, it looks like it got eaten along the way - it was definitely
sent by the patchbomb script. It was the rbtree conversion. Patch
below.

-- 
Dave Chinner
david@fromorbit.com

commit 92473cd83181668e5785337db0441a0d90a626ec
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Sep 22 10:47:20 2010 +1000

    xfs: convert buffer cache hash to rbtree
    
    The buffer cache hash is showing typical hash scalability problems.
    In large scale testing the number of cached items growing far larger
    than the hash can efficiently handle. Hence we need to move to a
    self-scaling cache indexing mechanism.
    
    I have selected rbtrees for indexing becuse they can have O(log n)
    search scalability, and insert and remove cost is not excessive,
    even on large trees. Hence we should be able to cache large numbers
    of buffers without incurring the excessive cache miss search
    penalties that the hash is imposing on us.
    
    To ensure we still have parallel access to the cache, we need
    multiple trees. Rather than hashing the buffers by disk address to
    select a tree, it seems more sensible to separate trees by typical
    access patterns. Most operations use buffers from within a single AG
    at a time, so rather than searching lots of different lists,
    separate the buffer indexes out into per-AG rbtrees. This means that
    searches during metadata operation have a much higher chance of
    hitting cache resident nodes, and that updates of the tree are less
    likely to disturb trees being accessed on other CPUs doing
    independent operations.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Alex Elder <aelder@sgi.com>

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 6de9513..7a2b860 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -188,7 +188,7 @@ _xfs_buf_initialize(
 	atomic_set(&bp->b_hold, 1);
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_list);
-	INIT_LIST_HEAD(&bp->b_hash_list);
+	RB_CLEAR_NODE(&bp->b_rbnode);
 	init_MUTEX_LOCKED(&bp->b_sema); /* held, no waiters */
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
@@ -262,8 +262,6 @@ xfs_buf_free(
 {
 	trace_xfs_buf_free(bp, _RET_IP_);
 
-	ASSERT(list_empty(&bp->b_hash_list));
-
 	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
 		uint		i;
 
@@ -422,8 +420,10 @@ _xfs_buf_find(
 {
 	xfs_off_t		range_base;
 	size_t			range_length;
-	xfs_bufhash_t		*hash;
-	xfs_buf_t		*bp, *n;
+	struct xfs_perag	*pag;
+	struct rb_node		**rbp;
+	struct rb_node		*parent;
+	xfs_buf_t		*bp;
 
 	range_base = (ioff << BBSHIFT);
 	range_length = (isize << BBSHIFT);
@@ -432,14 +432,37 @@ _xfs_buf_find(
 	ASSERT(!(range_length < (1 << btp->bt_sshift)));
 	ASSERT(!(range_base & (xfs_off_t)btp->bt_smask));
 
-	hash = &btp->bt_hash[hash_long((unsigned long)ioff, btp->bt_hashshift)];
-
-	spin_lock(&hash->bh_lock);
-
-	list_for_each_entry_safe(bp, n, &hash->bh_list, b_hash_list) {
-		ASSERT(btp == bp->b_target);
-		if (bp->b_file_offset == range_base &&
-		    bp->b_buffer_length == range_length) {
+	/* get tree root */
+	pag = xfs_perag_get(btp->bt_mount,
+				xfs_daddr_to_agno(btp->bt_mount, ioff));
+
+	/* walk tree */
+	spin_lock(&pag->pag_buf_lock);
+	rbp = &pag->pag_buf_tree.rb_node;
+	parent = NULL;
+	bp = NULL;
+	while (*rbp) {
+		parent = *rbp;
+		bp = rb_entry(parent, struct xfs_buf, b_rbnode);
+
+		if (range_base < bp->b_file_offset)
+			rbp = &(*rbp)->rb_left;
+		else if (range_base > bp->b_file_offset)
+			rbp = &(*rbp)->rb_right;
+		else {
+			/*
+			 * found a block offset match. If the range doesn't
+			 * match, the only way this is allowed is if the buffer
+			 * in the cache is stale and the transaction that made
+			 * it stale has not yet committed. i.e. we are
+			 * reallocating a busy extent. Skip this buffer and
+			 * continue searching to the right for an exact match.
+			 */
+			if (bp->b_buffer_length != range_length) {
+				ASSERT(bp->b_flags & XBF_STALE);
+				rbp = &(*rbp)->rb_right;
+				continue;
+			}
 			atomic_inc(&bp->b_hold);
 			goto found;
 		}
@@ -449,17 +472,21 @@ _xfs_buf_find(
 	if (new_bp) {
 		_xfs_buf_initialize(new_bp, btp, range_base,
 				range_length, flags);
-		new_bp->b_hash = hash;
-		list_add(&new_bp->b_hash_list, &hash->bh_list);
+		rb_link_node(&new_bp->b_rbnode, parent, rbp);
+		rb_insert_color(&new_bp->b_rbnode, &pag->pag_buf_tree);
+		/* the buffer keeps the perag reference until it is freed */
+		new_bp->b_pag = pag;
+		spin_unlock(&pag->pag_buf_lock);
 	} else {
 		XFS_STATS_INC(xb_miss_locked);
+		spin_unlock(&pag->pag_buf_lock);
+		xfs_perag_put(pag);
 	}
-
-	spin_unlock(&hash->bh_lock);
 	return new_bp;
 
 found:
-	spin_unlock(&hash->bh_lock);
+	spin_unlock(&pag->pag_buf_lock);
+	xfs_perag_put(pag);
 
 	/* Attempt to get the semaphore without sleeping,
 	 * if this does not work then we need to drop the
@@ -809,27 +836,30 @@ void
 xfs_buf_rele(
 	xfs_buf_t		*bp)
 {
-	xfs_bufhash_t		*hash = bp->b_hash;
+	struct xfs_perag	*pag = bp->b_pag;
 
 	trace_xfs_buf_rele(bp, _RET_IP_);
 
-	if (unlikely(!hash)) {
+	if (!pag) {
 		ASSERT(!bp->b_relse);
+		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
 		if (atomic_dec_and_test(&bp->b_hold))
 			xfs_buf_free(bp);
 		return;
 	}
 
+	ASSERT(!RB_EMPTY_NODE(&bp->b_rbnode));
 	ASSERT(atomic_read(&bp->b_hold) > 0);
-	if (atomic_dec_and_lock(&bp->b_hold, &hash->bh_lock)) {
+	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
 		if (bp->b_relse) {
 			atomic_inc(&bp->b_hold);
-			spin_unlock(&hash->bh_lock);
-			(*(bp->b_relse)) (bp);
+			spin_unlock(&pag->pag_buf_lock);
+			bp->b_relse(bp);
 		} else {
 			ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
-			list_del_init(&bp->b_hash_list);
-			spin_unlock(&hash->bh_lock);
+			rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
+			spin_unlock(&pag->pag_buf_lock);
+			xfs_perag_put(pag);
 			xfs_buf_free(bp);
 		}
 	}
@@ -1429,56 +1459,24 @@ xfs_buf_iomove(
  */
 void
 xfs_wait_buftarg(
-	xfs_buftarg_t	*btp)
+	struct xfs_buftarg	*btp)
 {
-	xfs_bufhash_t	*hash;
-	uint		i;
+	struct xfs_perag	*pag;
+	uint			i;
 
-	for (i = 0; i < (1 << btp->bt_hashshift); i++) {
-		hash = &btp->bt_hash[i];
-		spin_lock(&hash->bh_lock);
-		while (!list_empty(&hash->bh_list)) {
-			spin_unlock(&hash->bh_lock);
+	for (i = 0; i < btp->bt_mount->m_sb.sb_agcount; i++) {
+		pag = xfs_perag_get(btp->bt_mount, i);
+		spin_lock(&pag->pag_buf_lock);
+		while (rb_first(&pag->pag_buf_tree)) {
+			spin_unlock(&pag->pag_buf_lock);
 			delay(100);
-			spin_lock(&hash->bh_lock);
+			spin_lock(&pag->pag_buf_lock);
 		}
-		spin_unlock(&hash->bh_lock);
-	}
-}
-
-/*
- *	Allocate buffer hash table for a given target.
- *	For devices containing metadata (i.e. not the log/realtime devices)
- *	we need to allocate a much larger hash table.
- */
-STATIC void
-xfs_alloc_bufhash(
-	xfs_buftarg_t		*btp,
-	int			external)
-{
-	unsigned int		i;
-
-	if (external) {
-		btp->bt_hash = NULL;
-		return;
-	}
-	btp->bt_hashshift = 12;	/* 4096 buckets */
-	btp->bt_hash = kmem_zalloc_large((1 << btp->bt_hashshift) *
-					 sizeof(xfs_bufhash_t));
-	for (i = 0; i < (1 << btp->bt_hashshift); i++) {
-		spin_lock_init(&btp->bt_hash[i].bh_lock);
-		INIT_LIST_HEAD(&btp->bt_hash[i].bh_list);
+		spin_unlock(&pag->pag_buf_lock);
+		xfs_perag_put(pag);
 	}
 }
 
-STATIC void
-xfs_free_bufhash(
-	xfs_buftarg_t		*btp)
-{
-	kmem_free_large(btp->bt_hash);
-	btp->bt_hash = NULL;
-}
-
 /*
  *	buftarg list for delwrite queue processing
  */
@@ -1511,7 +1509,6 @@ xfs_free_buftarg(
 	xfs_flush_buftarg(btp, 1);
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_blkdev_issue_flush(btp);
-	xfs_free_bufhash(btp);
 	iput(btp->bt_mapping->host);
 
 	/* Unregister the buftarg first so that we don't get a
@@ -1651,7 +1648,6 @@ xfs_alloc_buftarg(
 		goto error;
 	if (xfs_alloc_delwrite_queue(btp, fsname))
 		goto error;
-	xfs_alloc_bufhash(btp, external);
 	return btp;
 
 error:
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index d10a954..4f3c845 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -135,10 +135,6 @@ typedef struct xfs_buftarg {
 	unsigned int		bt_sshift;
 	size_t			bt_smask;
 
-	/* per device buffer hash table */
-	uint			bt_hashshift;
-	xfs_bufhash_t		*bt_hash;
-
 	/* per device delwri queue */
 	struct task_struct	*bt_task;
 	struct list_head	bt_list;
@@ -172,8 +168,8 @@ typedef struct xfs_buf {
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	xfs_buf_flags_t		b_flags;	/* status flags */
-	struct list_head	b_hash_list;	/* hash table list */
-	xfs_bufhash_t		*b_hash;	/* hash table list start */
+	struct rb_node		b_rbnode;	/* rbtree node */
+	struct xfs_perag	*b_pag;		/* contains rbtree root */
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
 	atomic_t		b_hold;		/* reference count */
 	xfs_daddr_t		b_bn;		/* block number for I/O */
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index baeec83..63c7a1a 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -233,6 +233,10 @@ typedef struct xfs_perag {
 	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
+	/* buffer cache index */
+	spinlock_t	pag_buf_lock;	/* lock for pag_buf_tree */
+	struct rb_root	pag_buf_tree;	/* ordered tree of active buffers */
+
 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 59859c3..cfa2fb4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -479,6 +479,8 @@ xfs_initialize_perag(
 		rwlock_init(&pag->pag_ici_lock);
 		mutex_init(&pag->pag_ici_reclaim_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+		spin_lock_init(&pag->pag_buf_lock);
+		pag->pag_buf_tree = RB_ROOT;
 
 		if (radix_tree_preload(GFP_NOFS))
 			goto out_unwind;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
