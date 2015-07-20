Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4112A7F60
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 10:18:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 18C90304048
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 08:18:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4WaqF2GBWRM97tm8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 08:18:51 -0700 (PDT)
Date: Mon, 20 Jul 2015 11:18:49 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH] block: xfs: dm thin: train XFS to give up on retrying IO
	if thinp is out of space
Message-ID: <20150720151849.GA2282@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: axboe@kernel.dk, david@fromorbit.com, hch@lst.de, sandeen@redhat.com
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

If XFS fails to write metadata it will retry the write indefinitely
(with the hope that the write will succeed at some point in the future).

Others can possibly speak to historic reason(s) why this is a sane
default for XFS.  But when XFS is deployed ontop of DM thin provisioning
this infinite retry is very unwelcome -- especially if DM thinp was
configured to be automatically extended with free space but the admin
hasn't provided (or restored) adequate free space.

To fix this infinite retry a new bdev_has_space () hook is added to XFS
to break out of its metadata retry loop if the underlying block device
reports it no longer has free space.  DM thin provisioning is now
trained to respond accordingly, which enables XFS to not cause a cascade
of tasks blocked on IO waiting for XFS's infinite retry.

All other block devices, which don't implement a .has_space method in
block_device_operations, will always return true for bdev_has_space().

With this change XFS will fail the metadata IO, force shutdown, and the
XFS filesystem may be unmounted.  This enables an admin to recover from
their oversight, of not having provided enough free space, without
having to force a hard reset of the system to get XFS to unwedge.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c          | 27 +++++++++++++++++++++++++--
 drivers/md/dm.c               | 33 +++++++++++++++++++++++++++++++++
 fs/block_dev.c                | 10 ++++++++++
 fs/xfs/xfs_buf_item.c         |  3 +++
 include/linux/blkdev.h        |  3 +++
 include/linux/device-mapper.h |  8 ++++++++
 6 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1c50c58..55ee3cf 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3948,7 +3948,7 @@ static struct target_type pool_target = {
 	.name = "thin-pool",
 	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
 		    DM_TARGET_IMMUTABLE,
-	.version = {1, 16, 0},
+	.version = {1, 17, 0},
 	.module = THIS_MODULE,
 	.ctr = pool_ctr,
 	.dtr = pool_dtr,
@@ -4333,9 +4333,31 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->max_discard_sectors = 2048 * 1024 * 16; /* 16G */
 }
 
+static bool thin_has_space(struct dm_target *ti)
+{
+	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
+	enum pool_mode m = get_pool_mode(pool);
+
+	/*
+	 * The thin-pool has space if it is either in write mode _or_
+	 * it is still waiting for space to be added.
+	 *
+	 * If 'error_if_no_space' was configured the pool will not queue
+	 * IO at all, even though the pool will stay in OODS mode, so
+	 * there is no point having upper layers (e.g. XFS) retry IO
+	 * given 'error_if_no_space' is meant to _not_ queue IO.
+	 */
+	if (m == PM_WRITE ||
+	    (m == PM_OUT_OF_DATA_SPACE && !pool->pf.error_if_no_space))
+		return true;
+
+	return false;
+}
+
 static struct target_type thin_target = {
 	.name = "thin",
-	.version = {1, 16, 0},
+	.version = {1, 17, 0},
 	.module	= THIS_MODULE,
 	.ctr = thin_ctr,
 	.dtr = thin_dtr,
@@ -4348,6 +4370,7 @@ static struct target_type thin_target = {
 	.merge = thin_merge,
 	.iterate_devices = thin_iterate_devices,
 	.io_hints = thin_io_hints,
+	.has_space = thin_has_space,
 };
 
 /*----------------------------------------------------------------*/
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ab37ae1..14bf9df 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -597,6 +597,38 @@ out:
 	return r;
 }
 
+static bool dm_blk_has_space(struct block_device *bdev)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	int srcu_idx;
+	struct dm_table *map;
+	struct dm_target *tgt;
+	bool r = true;
+
+	map = dm_get_live_table(md, &srcu_idx);
+
+	if (!map || !dm_table_get_size(map))
+		goto out;
+
+	/* We only support devices that have a single target */
+	if (dm_table_get_num_targets(map) != 1)
+		goto out;
+
+	tgt = dm_table_get_target(map, 0);
+	if (!tgt->type->has_space)
+		goto out;
+
+	if (dm_suspended_md(md))
+		goto out;
+
+	r = tgt->type->has_space(tgt);
+
+out:
+	dm_put_live_table(md, srcu_idx);
+
+	return r;
+}
+
 static struct dm_io *alloc_io(struct mapped_device *md)
 {
 	return mempool_alloc(md->io_pool, GFP_NOIO);
@@ -3647,6 +3679,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
+	.has_space = dm_blk_has_space,
 	.owner = THIS_MODULE
 };
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1982437..5034361 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -469,6 +469,16 @@ long bdev_direct_access(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
 
+bool bdev_has_space(struct block_device *bdev)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (!ops->has_space)
+		return true;
+	return ops->has_space(bdev);
+}
+EXPORT_SYMBOL_GPL(bdev_has_space);
+
 /*
  * pseudo-fs
  */
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 092d652..98efbca 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1059,6 +1059,9 @@ xfs_buf_iodone_callbacks(
 	if (likely(!bp->b_error))
 		goto do_callbacks;
 
+	if (!bdev_has_space(bp->b_target->bt_bdev))
+		xfs_force_shutdown(mp, SHUTDOWN_REMOTE_REQ);
+
 	/*
 	 * If we've already decided to shutdown the filesystem because of
 	 * I/O errors, there's no point in giving this a retry.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d4068c17d..1ba66bc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1566,6 +1566,7 @@ struct block_device_operations {
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
 	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
+	bool (*has_space) (struct block_device *);
 	struct module *owner;
 };
 
@@ -1576,6 +1577,8 @@ extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, sector_t, void **addr,
 						unsigned long *pfn, long size);
+extern bool bdev_has_space(struct block_device *);
+
 #else /* CONFIG_BLOCK */
 
 struct block_device;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 51cc1de..c55053e 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -119,6 +119,13 @@ typedef void (*dm_io_hints_fn) (struct dm_target *ti,
  */
 typedef int (*dm_busy_fn) (struct dm_target *ti);
 
+/*
+ * Returns:
+ *    false: The target has no space that may be allocated.
+ *    true:  The target has space that may be allocated.
+ */
+typedef bool (*dm_has_space_fn) (struct dm_target *ti);
+
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -164,6 +171,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_has_space_fn has_space;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
2.3.2 (Apple Git-55)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
