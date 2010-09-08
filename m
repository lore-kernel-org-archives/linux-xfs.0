Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88FCUH0042716 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 10:12:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3C9F14EC51B
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 08:24:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	zHfjnaXWkeNjKDpB for <xfs@oss.sgi.com>;
	Wed, 08 Sep 2010 08:24:26 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38170600-1927428
	for <xfs@oss.sgi.com>; Thu, 09 Sep 2010 00:43:12 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OtMKj-0003zD-Kq
	for xfs@oss.sgi.com; Thu, 09 Sep 2010 01:13:09 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OtMKc-0007TW-HK
	for xfs@oss.sgi.com; Thu, 09 Sep 2010 01:13:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: convert buffer cache hash to rbtree
Date: Thu,  9 Sep 2010 01:12:58 +1000
Message-Id: <1283958778-28610-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1283958778-28610-1-git-send-email-david@fromorbit.com>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The buffer cache hash is starting to show typical hash scalability
problems.  large scale testing is showing the number of cached items
growing far larger than the hash can efficiently handle. Hence we
need to move to a self-scaling cache indexing mechanism.

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
---
 fs/xfs/linux-2.6/xfs_buf.c   |  139 +++++++++++++++++++++--------------------
 fs/xfs/linux-2.6/xfs_buf.h   |   14 ++--
 fs/xfs/linux-2.6/xfs_super.c |    6 +-
 fs/xfs/xfs_ag.h              |    4 +
 fs/xfs/xfs_mount.c           |    4 +-
 5 files changed, 87 insertions(+), 80 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index b2b5dea..facd37e 100644
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
@@ -422,8 +422,10 @@ _xfs_buf_find(
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
@@ -432,14 +434,36 @@ _xfs_buf_find(
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
+	pag = xfs_perag_get(btp->bt_mp, xfs_daddr_to_agno(btp->bt_mp, ioff));
+
+	/* walk tree */
+	spin_lock(&pag->pagbuf_lock);
+	rbp = &pag->pagbuf_tree.rb_node;
+	parent = NULL;
+	bp = NULL;
+	while (*rbp) {
+		parent = *rbp;
+		bp = rb_entry(parent, struct xfs_buf, b_rbnode);
+
+		if (bp->b_file_offset < range_base)
+			rbp = &(*rbp)->rb_left;
+		else if (bp->b_file_offset > range_base)
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
@@ -449,17 +473,20 @@ _xfs_buf_find(
 	if (new_bp) {
 		_xfs_buf_initialize(new_bp, btp, range_base,
 				range_length, flags);
-		new_bp->b_hash = hash;
-		list_add(&new_bp->b_hash_list, &hash->bh_list);
+		new_bp->b_pag = pag;
+		rb_link_node(&new_bp->b_rbnode, parent, rbp);
+		rb_insert_color(&new_bp->b_rbnode, &pag->pagbuf_tree);
+		spin_unlock(&pag->pagbuf_lock);
 	} else {
 		XFS_STATS_INC(xb_miss_locked);
+		spin_unlock(&pag->pagbuf_lock);
+		xfs_perag_put(pag);
 	}
-
-	spin_unlock(&hash->bh_lock);
 	return new_bp;
 
 found:
-	spin_unlock(&hash->bh_lock);
+	spin_unlock(&pag->pagbuf_lock);
+	xfs_perag_put(pag);
 
 	/* Attempt to get the semaphore without sleeping,
 	 * if this does not work then we need to drop the
@@ -810,27 +837,30 @@ void
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
+	if (atomic_dec_and_lock(&bp->b_hold, &pag->pagbuf_lock)) {
 		if (bp->b_relse) {
 			atomic_inc(&bp->b_hold);
-			spin_unlock(&hash->bh_lock);
+			spin_unlock(&pag->pagbuf_lock);
 			(*(bp->b_relse)) (bp);
 		} else {
 			ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
-			list_del_init(&bp->b_hash_list);
-			spin_unlock(&hash->bh_lock);
+			rb_erase(&bp->b_rbnode, &pag->pagbuf_tree);
+			spin_unlock(&pag->pagbuf_lock);
+			xfs_perag_put(pag);
 			xfs_buf_free(bp);
 		}
 	}
@@ -1433,57 +1463,25 @@ xfs_buf_iomove(
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
+	for (i = 0; i < btp->bt_mp->m_sb.sb_agcount; i++) {
+		pag = xfs_perag_get(btp->bt_mp, i);
+		spin_lock(&pag->pagbuf_lock);
+		while (rb_first(&pag->pagbuf_tree)) {
+			spin_unlock(&pag->pagbuf_lock);
 			delay(100);
-			spin_lock(&hash->bh_lock);
+			spin_lock(&pag->pagbuf_lock);
 		}
-		spin_unlock(&hash->bh_lock);
+		spin_unlock(&pag->pagbuf_lock);
+		xfs_perag_put(pag);
 	}
 }
 
 /*
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
-	}
-}
-
-STATIC void
-xfs_free_bufhash(
-	xfs_buftarg_t		*btp)
-{
-	kmem_free_large(btp->bt_hash);
-	btp->bt_hash = NULL;
-}
-
-/*
  *	buftarg list for delwrite queue processing
  */
 static LIST_HEAD(xfs_buftarg_list);
@@ -1515,7 +1513,6 @@ xfs_free_buftarg(
 	xfs_flush_buftarg(btp, 1);
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_blkdev_issue_flush(btp);
-	xfs_free_bufhash(btp);
 	iput(btp->bt_mapping->host);
 
 	/* Unregister the buftarg first so that we don't get a
@@ -1637,6 +1634,7 @@ out_error:
 
 xfs_buftarg_t *
 xfs_alloc_buftarg(
+	struct xfs_mount	*mp,
 	struct block_device	*bdev,
 	int			external,
 	const char		*fsname)
@@ -1645,6 +1643,12 @@ xfs_alloc_buftarg(
 
 	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP);
 
+	/*
+	 * The buftarg cache should never be used by external devices.
+	 * Ensure we catch any users with extreme prejudice.
+	 */
+	btp->bt_mp = external ? NULL : mp;
+
 	btp->bt_dev =  bdev->bd_dev;
 	btp->bt_bdev = bdev;
 	if (xfs_setsize_buftarg_early(btp, bdev))
@@ -1653,7 +1657,6 @@ xfs_alloc_buftarg(
 		goto error;
 	if (xfs_alloc_delwrite_queue(btp, fsname))
 		goto error;
-	xfs_alloc_bufhash(btp, external);
 	return btp;
 
 error:
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 802dc5e..3797ee8 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -126,18 +126,17 @@ typedef struct xfs_bufhash {
 	spinlock_t		bh_lock;
 } xfs_bufhash_t;
 
+struct xfs_mount;
+
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
 	struct address_space	*bt_mapping;
+	struct xfs_mount	*bt_mp;
 	unsigned int		bt_bsize;
 	unsigned int		bt_sshift;
 	size_t			bt_smask;
 
-	/* per device buffer hash table */
-	uint			bt_hashshift;
-	xfs_bufhash_t		*bt_hash;
-
 	/* per device delwri queue */
 	struct task_struct	*bt_task;
 	struct list_head	bt_list;
@@ -171,8 +170,8 @@ typedef struct xfs_buf {
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	xfs_buf_flags_t		b_flags;	/* status flags */
-	struct list_head	b_hash_list;	/* hash table list */
-	xfs_bufhash_t		*b_hash;	/* hash table list start */
+	struct rb_node		b_rbnode;	/* rbtree node */
+	struct xfs_perag	*b_pag;		/* rbtree root */
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
 	atomic_t		b_hold;		/* reference count */
 	xfs_daddr_t		b_bn;		/* block number for I/O */
@@ -374,7 +373,8 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
 /*
  *	Handling of buftargs.
  */
-extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int, const char *);
+extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
+				struct block_device *, int, const char *);
 extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a4e0797..7426319 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -758,18 +758,18 @@ xfs_open_devices(
 	 * Setup xfs_mount buffer target pointers
 	 */
 	error = ENOMEM;
-	mp->m_ddev_targp = xfs_alloc_buftarg(ddev, 0, mp->m_fsname);
+	mp->m_ddev_targp = xfs_alloc_buftarg(mp, ddev, 0, mp->m_fsname);
 	if (!mp->m_ddev_targp)
 		goto out_close_rtdev;
 
 	if (rtdev) {
-		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1, mp->m_fsname);
+		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev, 1, mp->m_fsname);
 		if (!mp->m_rtdev_targp)
 			goto out_free_ddev_targ;
 	}
 
 	if (logdev && logdev != ddev) {
-		mp->m_logdev_targp = xfs_alloc_buftarg(logdev, 1, mp->m_fsname);
+		mp->m_logdev_targp = xfs_alloc_buftarg(mp, logdev, 1, mp->m_fsname);
 		if (!mp->m_logdev_targp)
 			goto out_free_rtdev_targ;
 	} else {
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 4917d4e..e01d4cf 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -230,6 +230,10 @@ typedef struct xfs_perag {
 	rwlock_t	pag_ici_lock;	/* incore inode lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
+
+	/* buffer cache index */
+	spinlock_t	pagbuf_lock;	/* lock for pagbuf_tree */
+	struct rb_root	pagbuf_tree;	/* ordered tree of active buffers */
 #endif
 	int		pagb_count;	/* pagb slots in use */
 } xfs_perag_t;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2c8dd69..5d9f49c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -210,8 +210,6 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
 	if (pag) {
 		ASSERT(atomic_read(&pag->pag_ref) >= 0);
-		/* catch leaks in the positive direction during testing */
-		ASSERT(atomic_read(&pag->pag_ref) < 1000);
 		ref = atomic_inc_return(&pag->pag_ref);
 	}
 	spin_unlock(&mp->m_perag_lock);
@@ -445,6 +443,8 @@ xfs_initialize_perag(
 		pag->pag_mount = mp;
 		rwlock_init(&pag->pag_ici_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+		spin_lock_init(&pag->pagbuf_lock);
+		pag->pagbuf_tree = RB_ROOT;
 
 		if (radix_tree_preload(GFP_NOFS))
 			goto out_unwind;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
