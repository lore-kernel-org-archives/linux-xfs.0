Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAuPc7121294 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 120371E6531E
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 03:57:13 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	lyeiY0enbnvp6rCH for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 03:57:13 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39287372-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:27:11 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTCI-0004PF-0v
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:57:10 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTC0-0000Qi-KP
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/18] xfs: add a lru to the XFS buffer cache
Date: Tue, 14 Sep 2010 20:56:16 +1000
Message-Id: <1284461777-1496-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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

Introduce a per-buftarg LRU for memory reclaim to operate on. This
is the last piece we need to put in place so that we can fully
control the buffer lifecycle. This allows XFS to be responsibile for
maintaining the working set of buffers under memory pressure instead
of relying on the VM reclaim not to take pages we need out from
underneath us.

The implementation is currently a bit naive - it does not rotate
buffers on the LRU when they are accessed multiple times. Solving
this problem is for a later patch series that re-introduces the
buffer type specific reclaim reference counts to prioritise reclaim
more effectively.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   91 ++++++++++++++++++++++++++++++++++---------
 fs/xfs/linux-2.6/xfs_buf.h |    5 ++
 2 files changed, 77 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 3b54fee..12b37c6 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -182,6 +182,7 @@ _xfs_buf_initialize(
 	memset(bp, 0, sizeof(xfs_buf_t));
 	atomic_set(&bp->b_hold, 1);
 	init_completion(&bp->b_iowait);
+	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
 	RB_CLEAR_NODE(&bp->b_rbnode);
 	init_MUTEX_LOCKED(&bp->b_sema); /* held, no waiters */
@@ -257,6 +258,8 @@ xfs_buf_free(
 {
 	trace_xfs_buf_free(bp, _RET_IP_);
 
+	ASSERT(list_empty(&bp->b_lru));
+
 	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
 		uint		i;
 
@@ -471,6 +474,13 @@ _xfs_buf_find(
 		/* the buffer keeps the perag reference until it is freed */
 		new_bp->b_pag = pag;
 		spin_unlock(&pag->pag_buf_lock);
+
+		/* add to LRU */
+		spin_lock(&btp->bt_lru_lock);
+		list_add_tail(&new_bp->b_lru, &btp->bt_lru);
+		btp->bt_lru_nr++;
+		atomic_inc(&new_bp->b_hold);
+		spin_unlock(&btp->bt_lru_lock);
 	} else {
 		XFS_STATS_INC(xb_miss_locked);
 		spin_unlock(&pag->pag_buf_lock);
@@ -834,12 +844,14 @@ xfs_buf_rele(
 
 	if (!pag) {
 		ASSERT(!bp->b_relse);
+		ASSERT(list_empty(&bp->b_lru));
 		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
 		if (atomic_dec_and_test(&bp->b_hold))
 			xfs_buf_free(bp);
 		return;
 	}
 
+	ASSERT(!list_empty(&bp->b_lru));
 	ASSERT(!RB_EMPTY_NODE(&bp->b_rbnode));
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
@@ -848,6 +860,14 @@ xfs_buf_rele(
 			spin_unlock(&pag->pag_buf_lock);
 			bp->b_relse(bp);
 		} else {
+			struct xfs_buftarg *btp = bp->b_target;
+
+			/* remove from LRU */
+			spin_lock(&btp->bt_lru_lock);
+			list_del_init(&bp->b_lru);
+			btp->bt_lru_nr--;
+			spin_unlock(&btp->bt_lru_lock);
+
 			ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
 			rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
 			spin_unlock(&pag->pag_buf_lock);
@@ -1446,27 +1466,29 @@ xfs_buf_iomove(
  */
 
 /*
- *	Wait for any bufs with callbacks that have been submitted but
- *	have not yet returned... walk the hash list for the target.
+ * Wait for any bufs with callbacks that have been submitted but have not yet
+ * returned. These buffers will have an elevated hold count, so wait on those
+ * while freeing all the buffers only held by the LRU.
  */
 void
 xfs_wait_buftarg(
 	struct xfs_buftarg	*btp)
 {
-	struct xfs_perag	*pag;
-	uint			i;
-
-	for (i = 0; i < btp->bt_mount->m_sb.sb_agcount; i++) {
-		pag = xfs_perag_get(btp->bt_mount, i);
-		spin_lock(&pag->pag_buf_lock);
-		while (rb_first(&pag->pag_buf_tree)) {
-			spin_unlock(&pag->pag_buf_lock);
+	struct xfs_buf		*bp;
+restart:
+	spin_lock(&btp->bt_lru_lock);
+	while (!list_empty(&btp->bt_lru)) {
+		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
+		if (atomic_read(&bp->b_hold) > 1) {
+			spin_unlock(&btp->bt_lru_lock);
 			delay(100);
-			spin_lock(&pag->pag_buf_lock);
+			goto restart;
 		}
-		spin_unlock(&pag->pag_buf_lock);
-		xfs_perag_put(pag);
+		spin_unlock(&btp->bt_lru_lock);
+		xfs_buf_rele(bp);
+		spin_lock(&btp->bt_lru_lock);
 	}
+	spin_unlock(&btp->bt_lru_lock);
 }
 
 int
@@ -1477,15 +1499,44 @@ xfs_buftarg_shrink(
 {
 	struct xfs_buftarg	*btp = container_of(shrink,
 					struct xfs_buftarg, bt_shrinker);
-	if (nr_to_scan) {
-		if (test_bit(XBT_FORCE_SLEEP, &btp->bt_flags))
-			return -1;
-		if (list_empty(&btp->bt_delwrite_queue))
-			return -1;
+	struct xfs_buf		*bp, *n;
+
+	if (!nr_to_scan)
+		return btp->bt_lru_nr;
+
+	spin_lock(&btp->bt_lru_lock);
+	if (test_and_set_bit(XBT_SHRINKER_ACTIVE, &btp->bt_flags)) {
+		/* LRU walk already in progress */
+		spin_unlock(&btp->bt_lru_lock);
+		return -1;
+	}
+
+	list_for_each_entry_safe(bp, n, &btp->bt_lru, b_lru) {
+		if (nr_to_scan-- <= 0)
+			break;
+		/*
+		 * If the lru holds the only reference count on the buffer,
+		 * release it. Otherwise there is another user of the buffer
+		 * and it will be getting repositioned real soon.
+		 */
+		if (atomic_read(&bp->b_hold) > 1)
+			continue;
+		spin_unlock(&btp->bt_lru_lock);
+		xfs_buf_rele(bp);
+		spin_lock(&btp->bt_lru_lock);
+	}
+	clear_bit(XBT_SHRINKER_ACTIVE, &btp->bt_flags);
+	spin_unlock(&btp->bt_lru_lock);
+
+	/* kick the xfsbufd to write and release dirty buffers */
+	if (!test_bit(XBT_FORCE_SLEEP, &btp->bt_flags) &&
+	    !test_bit(XBT_FORCE_FLUSH, &btp->bt_flags) &&
+	    !list_empty(&btp->bt_delwrite_queue)) {
 		set_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
 		wake_up_process(btp->bt_task);
 	}
-	return list_empty(&btp->bt_delwrite_queue) ? -1 : 1;
+
+	return btp->bt_lru_nr;
 }
 
 void
@@ -1619,6 +1670,8 @@ xfs_alloc_buftarg(
 	btp->bt_mount = mp;
 	btp->bt_dev =  bdev->bd_dev;
 	btp->bt_bdev = bdev;
+	INIT_LIST_HEAD(&btp->bt_lru);
+	spin_lock_init(&btp->bt_lru_lock);
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
 	if (xfs_mapping_buftarg(btp, bdev))
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 6e9310b..36f71aa 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -119,6 +119,7 @@ typedef unsigned int xfs_buf_flags_t;
 typedef enum {
 	XBT_FORCE_SLEEP = 0,
 	XBT_FORCE_FLUSH = 1,
+	XBT_SHRINKER_ACTIVE = 2,
 } xfs_buftarg_flags_t;
 
 typedef struct xfs_bufhash {
@@ -143,6 +144,9 @@ typedef struct xfs_buftarg {
 
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
+	struct list_head	bt_lru;
+	spinlock_t		bt_lru_lock;
+	unsigned int		bt_lru_nr;
 } xfs_buftarg_t;
 
 /*
@@ -178,6 +182,7 @@ typedef struct xfs_buf {
 	xfs_buf_flags_t		b_flags;	/* status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
 
+	struct list_head	b_lru;		/* lru list */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
