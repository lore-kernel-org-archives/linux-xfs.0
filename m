Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7SCUG244695 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:12 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94DF2212024
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:30:08 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	nBqU59KB1bMQQxgI for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:30:08 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50071179-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 18:00:06 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfc-0001D5-Pa
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:04 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfH-0006ZF-Ef
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/34] xfs: add a lru to the XFS buffer cache
Date: Tue, 21 Dec 2010 18:29:08 +1100
Message-Id: <1292916570-25015-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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

The implementation introduces a b_lru_ref counter into the buffer.
This is currently set to 1 whenever the buffer is referenced and so is used to
determine if the buffer should be added to the LRU or not when freed.
Effectively it allows lazy LRU initialisation of the buffer so we do not need
to touch the LRU list and locks in xfs_buf_find().

Instead, when the buffer is being released and we drop the last
reference to it, we check the b_lru_ref count and if it is none zero
we re-add the buffer reference and add the inode to the LRU. The
b_lru_ref counter is decremented by the shrinker, and whenever the
shrinker comes across a buffer with a zero b_lru_ref counter, if
released the LRU reference on the buffer. In the absence of a lookup
race, this will result in the buffer being freed.

This counting mechanism is used instead of a reference flag so that
it is simple to re-introduce buffer-type specific reclaim reference
counts to prioritise reclaim more effectively. We still have all
those hooks in the XFS code, so this will provide the infrastructure
to re-implement that functionality.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_buf.c |  166 ++++++++++++++++++++++++++++++++++++++------
 fs/xfs/linux-2.6/xfs_buf.h |    8 ++-
 2 files changed, 151 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 0a00d7a..92f1f2a 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -163,8 +163,79 @@ test_page_region(
 }
 
 /*
- *	Internal xfs_buf_t object manipulation
+ * xfs_buf_lru_add - add a buffer to the LRU.
+ *
+ * The LRU takes a new reference to the buffer so that it will only be freed
+ * once the shrinker takes the buffer off the LRU.
  */
+STATIC void
+xfs_buf_lru_add(
+	struct xfs_buf	*bp)
+{
+	struct xfs_buftarg *btp = bp->b_target;
+
+	spin_lock(&btp->bt_lru_lock);
+	if (list_empty(&bp->b_lru)) {
+		atomic_inc(&bp->b_hold);
+		list_add_tail(&bp->b_lru, &btp->bt_lru);
+		btp->bt_lru_nr++;
+	}
+	spin_unlock(&btp->bt_lru_lock);
+}
+
+/*
+ * xfs_buf_lru_del - remove a buffer from the LRU
+ *
+ * The unlocked check is safe here because it only occurs when there are not
+ * b_lru_ref counts left on the inode under the pag->pag_buf_lock. it is there
+ * to optimise the shrinker removing the buffer from the LRU and calling
+ * xfs_buf_free(). i.e. it removes an unneccessary round trip on the
+ * bt_lru_lock.
+ */
+STATIC void
+xfs_buf_lru_del(
+	struct xfs_buf	*bp)
+{
+	struct xfs_buftarg *btp = bp->b_target;
+
+	if (list_empty(&bp->b_lru))
+		return;
+
+	spin_lock(&btp->bt_lru_lock);
+	if (!list_empty(&bp->b_lru)) {
+		list_del_init(&bp->b_lru);
+		btp->bt_lru_nr--;
+	}
+	spin_unlock(&btp->bt_lru_lock);
+}
+
+/*
+ * When we mark a buffer stale, we remove the buffer from the LRU and clear the
+ * b_lru_ref count so that the buffer is freed immediately when the buffer
+ * reference count falls to zero. If the buffer is already on the LRU, we need
+ * to remove the reference that LRU holds on the buffer.
+ *
+ * This prevents build-up of stale buffers on the LRU.
+ */
+void
+xfs_buf_stale(
+	struct xfs_buf	*bp)
+{
+	bp->b_flags |= XBF_STALE;
+	atomic_set(&(bp)->b_lru_ref, 0);
+	if (!list_empty(&bp->b_lru)) {
+		struct xfs_buftarg *btp = bp->b_target;
+
+		spin_lock(&btp->bt_lru_lock);
+		if (!list_empty(&bp->b_lru)) {
+			list_del_init(&bp->b_lru);
+			btp->bt_lru_nr--;
+			atomic_dec(&bp->b_hold);
+		}
+		spin_unlock(&btp->bt_lru_lock);
+	}
+	ASSERT(atomic_read(&bp->b_hold) >= 1);
+}
 
 STATIC void
 _xfs_buf_initialize(
@@ -181,7 +252,9 @@ _xfs_buf_initialize(
 
 	memset(bp, 0, sizeof(xfs_buf_t));
 	atomic_set(&bp->b_hold, 1);
+	atomic_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
+	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
 	RB_CLEAR_NODE(&bp->b_rbnode);
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
@@ -257,6 +330,8 @@ xfs_buf_free(
 {
 	trace_xfs_buf_free(bp, _RET_IP_);
 
+	ASSERT(list_empty(&bp->b_lru));
+
 	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
 		uint		i;
 
@@ -822,6 +897,7 @@ xfs_buf_rele(
 
 	if (!pag) {
 		ASSERT(!bp->b_relse);
+		ASSERT(list_empty(&bp->b_lru));
 		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
 		if (atomic_dec_and_test(&bp->b_hold))
 			xfs_buf_free(bp);
@@ -829,13 +905,19 @@ xfs_buf_rele(
 	}
 
 	ASSERT(!RB_EMPTY_NODE(&bp->b_rbnode));
+
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
 		if (bp->b_relse) {
 			atomic_inc(&bp->b_hold);
 			spin_unlock(&pag->pag_buf_lock);
 			bp->b_relse(bp);
+		} else if (!(bp->b_flags & XBF_STALE) &&
+			   atomic_read(&bp->b_lru_ref)) {
+			xfs_buf_lru_add(bp);
+			spin_unlock(&pag->pag_buf_lock);
 		} else {
+			xfs_buf_lru_del(bp);
 			ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
 			rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
 			spin_unlock(&pag->pag_buf_lock);
@@ -1432,27 +1514,35 @@ xfs_buf_iomove(
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
+	struct xfs_buf		*bp;
 
-	for (i = 0; i < btp->bt_mount->m_sb.sb_agcount; i++) {
-		pag = xfs_perag_get(btp->bt_mount, i);
-		spin_lock(&pag->pag_buf_lock);
-		while (rb_first(&pag->pag_buf_tree)) {
-			spin_unlock(&pag->pag_buf_lock);
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
+		/*
+		 * clear the LRU reference count so the bufer doesn't get
+		 * ignored in xfs_buf_rele().
+		 */
+		atomic_set(&bp->b_lru_ref, 0);
+		spin_unlock(&btp->bt_lru_lock);
+		xfs_buf_rele(bp);
+		spin_lock(&btp->bt_lru_lock);
 	}
+	spin_unlock(&btp->bt_lru_lock);
 }
 
 int
@@ -1463,15 +1553,45 @@ xfs_buftarg_shrink(
 {
 	struct xfs_buftarg	*btp = container_of(shrink,
 					struct xfs_buftarg, bt_shrinker);
-	if (nr_to_scan) {
-		if (test_bit(XBT_FORCE_SLEEP, &btp->bt_flags))
-			return -1;
-		if (list_empty(&btp->bt_delwrite_queue))
-			return -1;
-		set_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
-		wake_up_process(btp->bt_task);
+	struct xfs_buf		*bp;
+	LIST_HEAD(dispose);
+
+	if (!nr_to_scan)
+		return btp->bt_lru_nr;
+
+	spin_lock(&btp->bt_lru_lock);
+	while (!list_empty(&btp->bt_lru)) {
+		if (nr_to_scan-- <= 0)
+			break;
+
+		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
+
+		/*
+		 * Decrement the b_lru_ref count unless the value is already
+		 * zero. If the value is already zero, we need to reclaim the
+		 * buffer, otherwise it gets another trip through the LRU.
+		 */
+		if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+			list_move_tail(&bp->b_lru, &btp->bt_lru);
+			continue;
+		}
+
+		/*
+		 * remove the buffer from the LRU now to avoid needing another
+		 * lock round trip inside xfs_buf_rele().
+		 */
+		list_move(&bp->b_lru, &dispose);
+		btp->bt_lru_nr--;
 	}
-	return list_empty(&btp->bt_delwrite_queue) ? -1 : 1;
+	spin_unlock(&btp->bt_lru_lock);
+
+	while (!list_empty(&dispose)) {
+		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
+		list_del_init(&bp->b_lru);
+		xfs_buf_rele(bp);
+	}
+
+	return btp->bt_lru_nr;
 }
 
 void
@@ -1606,6 +1726,8 @@ xfs_alloc_buftarg(
 	btp->bt_mount = mp;
 	btp->bt_dev =  bdev->bd_dev;
 	btp->bt_bdev = bdev;
+	INIT_LIST_HEAD(&btp->bt_lru);
+	spin_lock_init(&btp->bt_lru_lock);
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
 	if (xfs_mapping_buftarg(btp, bdev))
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 9344103..4601eab 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -134,6 +134,9 @@ typedef struct xfs_buftarg {
 
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
+	struct list_head	bt_lru;
+	spinlock_t		bt_lru_lock;
+	unsigned int		bt_lru_nr;
 } xfs_buftarg_t;
 
 /*
@@ -166,9 +169,11 @@ typedef struct xfs_buf {
 	xfs_off_t		b_file_offset;	/* offset in file */
 	size_t			b_buffer_length;/* size of buffer in bytes */
 	atomic_t		b_hold;		/* reference count */
+	atomic_t		b_lru_ref;	/* lru reclaim ref count */
 	xfs_buf_flags_t		b_flags;	/* status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
 
+	struct list_head	b_lru;		/* lru list */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
@@ -266,7 +271,8 @@ extern void xfs_buf_terminate(void);
 #define XFS_BUF_ZEROFLAGS(bp)	((bp)->b_flags &= \
 		~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED))
 
-#define XFS_BUF_STALE(bp)	((bp)->b_flags |= XBF_STALE)
+void xfs_buf_stale(struct xfs_buf *bp);
+#define XFS_BUF_STALE(bp)	xfs_buf_stale(bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
 #define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
 #define XFS_BUF_SUPER_STALE(bp)	do {				\
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
