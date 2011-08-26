Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7Q6pvNL043602 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 01:51:58 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7FFB192E7AC
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 23:51:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nIaQaZGC6cOJ8fXp for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2011 23:51:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QwqGS-0006js-S2
	for xfs@oss.sgi.com; Fri, 26 Aug 2011 16:51:40 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QwqGS-0006EO-Ks
	for xfs@oss.sgi.com; Fri, 26 Aug 2011 16:51:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: re-arrange all the xfsbufd delwri queue code
Date: Fri, 26 Aug 2011 16:51:36 +1000
Message-Id: <1314341497-23910-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1314341497-23910-1-git-send-email-david@fromorbit.com>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
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

In preparation for converting the xfsbufd to a workqueue, re-arrange
all the delayed write queue manipulation code above the buftarg
sections.  This allows us to avoid the need for forward declarations
of the new xfsbufd worker functions. This is pure code movement, not
changes to the code have been made.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_buf.c |  387 +++++++++++++++++++++++++++---------------------------
 1 files changed, 194 insertions(+), 193 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 594cea5..415ab71 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1383,199 +1383,6 @@ xfs_buf_iomove(
 }
 
 /*
- *	Handling of buffer targets (buftargs).
- */
-
-/*
- * Wait for any bufs with callbacks that have been submitted but have not yet
- * returned. These buffers will have an elevated hold count, so wait on those
- * while freeing all the buffers only held by the LRU.
- */
-void
-xfs_wait_buftarg(
-	struct xfs_buftarg	*btp)
-{
-	struct xfs_buf		*bp;
-
-restart:
-	spin_lock(&btp->bt_lru_lock);
-	while (!list_empty(&btp->bt_lru)) {
-		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
-		if (atomic_read(&bp->b_hold) > 1) {
-			spin_unlock(&btp->bt_lru_lock);
-			delay(100);
-			goto restart;
-		}
-		/*
-		 * clear the LRU reference count so the bufer doesn't get
-		 * ignored in xfs_buf_rele().
-		 */
-		atomic_set(&bp->b_lru_ref, 0);
-		spin_unlock(&btp->bt_lru_lock);
-		xfs_buf_rele(bp);
-		spin_lock(&btp->bt_lru_lock);
-	}
-	spin_unlock(&btp->bt_lru_lock);
-}
-
-int
-xfs_buftarg_shrink(
-	struct shrinker		*shrink,
-	struct shrink_control	*sc)
-{
-	struct xfs_buftarg	*btp = container_of(shrink,
-					struct xfs_buftarg, bt_shrinker);
-	struct xfs_buf		*bp;
-	int nr_to_scan = sc->nr_to_scan;
-	LIST_HEAD(dispose);
-
-	if (!nr_to_scan)
-		return btp->bt_lru_nr;
-
-	spin_lock(&btp->bt_lru_lock);
-	while (!list_empty(&btp->bt_lru)) {
-		if (nr_to_scan-- <= 0)
-			break;
-
-		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
-
-		/*
-		 * Decrement the b_lru_ref count unless the value is already
-		 * zero. If the value is already zero, we need to reclaim the
-		 * buffer, otherwise it gets another trip through the LRU.
-		 */
-		if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
-			list_move_tail(&bp->b_lru, &btp->bt_lru);
-			continue;
-		}
-
-		/*
-		 * remove the buffer from the LRU now to avoid needing another
-		 * lock round trip inside xfs_buf_rele().
-		 */
-		list_move(&bp->b_lru, &dispose);
-		btp->bt_lru_nr--;
-	}
-	spin_unlock(&btp->bt_lru_lock);
-
-	while (!list_empty(&dispose)) {
-		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
-		list_del_init(&bp->b_lru);
-		xfs_buf_rele(bp);
-	}
-
-	return btp->bt_lru_nr;
-}
-
-void
-xfs_free_buftarg(
-	struct xfs_mount	*mp,
-	struct xfs_buftarg	*btp)
-{
-	unregister_shrinker(&btp->bt_shrinker);
-
-	xfs_flush_buftarg(btp, 1);
-	if (mp->m_flags & XFS_MOUNT_BARRIER)
-		xfs_blkdev_issue_flush(btp);
-
-	kthread_stop(btp->bt_task);
-	kmem_free(btp);
-}
-
-STATIC int
-xfs_setsize_buftarg_flags(
-	xfs_buftarg_t		*btp,
-	unsigned int		blocksize,
-	unsigned int		sectorsize,
-	int			verbose)
-{
-	btp->bt_bsize = blocksize;
-	btp->bt_sshift = ffs(sectorsize) - 1;
-	btp->bt_smask = sectorsize - 1;
-
-	if (set_blocksize(btp->bt_bdev, sectorsize)) {
-		xfs_warn(btp->bt_mount,
-			"Cannot set_blocksize to %u on device %s\n",
-			sectorsize, xfs_buf_target_name(btp));
-		return EINVAL;
-	}
-
-	return 0;
-}
-
-/*
- *	When allocating the initial buffer target we have not yet
- *	read in the superblock, so don't know what sized sectors
- *	are being used is at this early stage.  Play safe.
- */
-STATIC int
-xfs_setsize_buftarg_early(
-	xfs_buftarg_t		*btp,
-	struct block_device	*bdev)
-{
-	return xfs_setsize_buftarg_flags(btp,
-			PAGE_SIZE, bdev_logical_block_size(bdev), 0);
-}
-
-int
-xfs_setsize_buftarg(
-	xfs_buftarg_t		*btp,
-	unsigned int		blocksize,
-	unsigned int		sectorsize)
-{
-	return xfs_setsize_buftarg_flags(btp, blocksize, sectorsize, 1);
-}
-
-STATIC int
-xfs_alloc_delwrite_queue(
-	xfs_buftarg_t		*btp,
-	const char		*fsname)
-{
-	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
-	spin_lock_init(&btp->bt_delwrite_lock);
-	btp->bt_flags = 0;
-	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
-	if (IS_ERR(btp->bt_task))
-		return PTR_ERR(btp->bt_task);
-	return 0;
-}
-
-xfs_buftarg_t *
-xfs_alloc_buftarg(
-	struct xfs_mount	*mp,
-	struct block_device	*bdev,
-	int			external,
-	const char		*fsname)
-{
-	xfs_buftarg_t		*btp;
-
-	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP);
-
-	btp->bt_mount = mp;
-	btp->bt_dev =  bdev->bd_dev;
-	btp->bt_bdev = bdev;
-	btp->bt_bdi = blk_get_backing_dev_info(bdev);
-	if (!btp->bt_bdi)
-		goto error;
-
-	INIT_LIST_HEAD(&btp->bt_lru);
-	spin_lock_init(&btp->bt_lru_lock);
-	if (xfs_setsize_buftarg_early(btp, bdev))
-		goto error;
-	if (xfs_alloc_delwrite_queue(btp, fsname))
-		goto error;
-	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
-	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
-	register_shrinker(&btp->bt_shrinker);
-	return btp;
-
-error:
-	kmem_free(btp);
-	return NULL;
-}
-
-
-/*
  *	Delayed write buffer handling
  */
 STATIC void
@@ -1781,6 +1588,10 @@ xfsbufd(
 }
 
 /*
+ *	Handling of buffer targets (buftargs).
+ */
+
+/*
  *	Go through all incore buffers, and release buffers if they belong to
  *	the given device. This is used in filesystem error handling to
  *	preserve the consistency of its metadata.
@@ -1837,6 +1648,196 @@ xfs_flush_buftarg(
 	return pincount;
 }
 
+/*
+ * Wait for any bufs with callbacks that have been submitted but have not yet
+ * returned. These buffers will have an elevated hold count, so wait on those
+ * while freeing all the buffers only held by the LRU.
+ */
+void
+xfs_wait_buftarg(
+	struct xfs_buftarg	*btp)
+{
+	struct xfs_buf		*bp;
+
+restart:
+	spin_lock(&btp->bt_lru_lock);
+	while (!list_empty(&btp->bt_lru)) {
+		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
+		if (atomic_read(&bp->b_hold) > 1) {
+			spin_unlock(&btp->bt_lru_lock);
+			delay(100);
+			goto restart;
+		}
+		/*
+		 * clear the LRU reference count so the bufer doesn't get
+		 * ignored in xfs_buf_rele().
+		 */
+		atomic_set(&bp->b_lru_ref, 0);
+		spin_unlock(&btp->bt_lru_lock);
+		xfs_buf_rele(bp);
+		spin_lock(&btp->bt_lru_lock);
+	}
+	spin_unlock(&btp->bt_lru_lock);
+}
+
+int
+xfs_buftarg_shrink(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	struct xfs_buftarg	*btp = container_of(shrink,
+					struct xfs_buftarg, bt_shrinker);
+	struct xfs_buf		*bp;
+	int nr_to_scan = sc->nr_to_scan;
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
+	}
+	spin_unlock(&btp->bt_lru_lock);
+
+	while (!list_empty(&dispose)) {
+		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
+		list_del_init(&bp->b_lru);
+		xfs_buf_rele(bp);
+	}
+
+	return btp->bt_lru_nr;
+}
+
+void
+xfs_free_buftarg(
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*btp)
+{
+	unregister_shrinker(&btp->bt_shrinker);
+
+	xfs_flush_buftarg(btp, 1);
+	if (mp->m_flags & XFS_MOUNT_BARRIER)
+		xfs_blkdev_issue_flush(btp);
+
+	kthread_stop(btp->bt_task);
+	kmem_free(btp);
+}
+
+STATIC int
+xfs_setsize_buftarg_flags(
+	xfs_buftarg_t		*btp,
+	unsigned int		blocksize,
+	unsigned int		sectorsize,
+	int			verbose)
+{
+	btp->bt_bsize = blocksize;
+	btp->bt_sshift = ffs(sectorsize) - 1;
+	btp->bt_smask = sectorsize - 1;
+
+	if (set_blocksize(btp->bt_bdev, sectorsize)) {
+		xfs_warn(btp->bt_mount,
+			"Cannot set_blocksize to %u on device %s\n",
+			sectorsize, xfs_buf_target_name(btp));
+		return EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ *	When allocating the initial buffer target we have not yet
+ *	read in the superblock, so don't know what sized sectors
+ *	are being used is at this early stage.  Play safe.
+ */
+STATIC int
+xfs_setsize_buftarg_early(
+	xfs_buftarg_t		*btp,
+	struct block_device	*bdev)
+{
+	return xfs_setsize_buftarg_flags(btp,
+			PAGE_SIZE, bdev_logical_block_size(bdev), 0);
+}
+
+int
+xfs_setsize_buftarg(
+	xfs_buftarg_t		*btp,
+	unsigned int		blocksize,
+	unsigned int		sectorsize)
+{
+	return xfs_setsize_buftarg_flags(btp, blocksize, sectorsize, 1);
+}
+
+STATIC int
+xfs_alloc_delwrite_queue(
+	xfs_buftarg_t		*btp,
+	const char		*fsname)
+{
+	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
+	spin_lock_init(&btp->bt_delwrite_lock);
+	btp->bt_flags = 0;
+	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
+	if (IS_ERR(btp->bt_task))
+		return PTR_ERR(btp->bt_task);
+	return 0;
+}
+
+xfs_buftarg_t *
+xfs_alloc_buftarg(
+	struct xfs_mount	*mp,
+	struct block_device	*bdev,
+	int			external,
+	const char		*fsname)
+{
+	xfs_buftarg_t		*btp;
+
+	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP);
+
+	btp->bt_mount = mp;
+	btp->bt_dev =  bdev->bd_dev;
+	btp->bt_bdev = bdev;
+	btp->bt_bdi = blk_get_backing_dev_info(bdev);
+	if (!btp->bt_bdi)
+		goto error;
+
+	INIT_LIST_HEAD(&btp->bt_lru);
+	spin_lock_init(&btp->bt_lru_lock);
+	if (xfs_setsize_buftarg_early(btp, bdev))
+		goto error;
+	if (xfs_alloc_delwrite_queue(btp, fsname))
+		goto error;
+	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
+	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
+	register_shrinker(&btp->bt_shrinker);
+	return btp;
+
+error:
+	kmem_free(btp);
+	return NULL;
+}
+
+
+
 int __init
 xfs_buf_init(void)
 {
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
