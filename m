Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C16B17F86
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 10:50:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C146AC007
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 08:50:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0FCDF1l5ep7LmnQu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 08:50:35 -0700 (PDT)
Date: Thu, 23 Jul 2015 11:50:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH] block: dm thin: export how block device handles -ENOSPC
Message-ID: <20150723155032.GA7246@redhat.com>
References: <55AE6670.40903@redhat.com> <20150721174753.GA8563@redhat.com>
	<20150722000923.GB7943@dastard> <20150722010056.GC7943@dastard>
	<20150722014029.GA10628@redhat.com> <20150722023711.GD7943@dastard>
	<20150722133451.GB16842@redhat.com> <55AFC496.4000009@redhat.com>
	<20150723051043.GB3902@dastard> <20150723143352.GA23921@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150723143352.GA23921@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de, Vivek Goyal <vgoyal@redhat.com>

On Thu, Jul 23 2015 at 10:33P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> If you just want to stub out the call to bdev_get_nospace_strategy() I
> can crank through implementing it once I get a few minutes.

I didn't use a 4th EOPNOTSUPP enum since if a device doesn't have any
special -ENOSPC handling it'd implicitly be FAST_FAILS_IF_NOSPACE.
But if I overlooked some need for it please let me know.

>From 1def7c15911bf15dbee96217591856806bd94b80 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 23 Jul 2015 11:28:43 -0400
Subject: [PATCH] block: dm thin: export how block device handles -ENOSPC

DM thin provisioning's handling of -ENOSPC from the underlying data
device is configurable.  Export this information so that upper layers
(e.g. XFS) may train their -ENOSPC handling accordingly.

By default all normal block devices won't have any specialized handling
(FAST_FAILS_IF_NOSPACE), if the device queues IO for a specified time it
will fail slowly (SLOW_FAILS_IF_NOSPACE), otherwise it queues IO
indefinitely (NEVER_FAILS_IF_NOSPACE).

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c          | 19 +++++++++++++++++--
 drivers/md/dm.c               | 33 +++++++++++++++++++++++++++++++++
 fs/block_dev.c                | 10 ++++++++++
 include/linux/blkdev.h        |  9 +++++++++
 include/linux/device-mapper.h |  6 ++++++
 5 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d2bbe8c..11cbdf1 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3953,7 +3953,7 @@ static struct target_type pool_target = {
 	.name = "thin-pool",
 	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
 		    DM_TARGET_IMMUTABLE,
-	.version = {1, 16, 0},
+	.version = {1, 17, 0},
 	.module = THIS_MODULE,
 	.ctr = pool_ctr,
 	.dtr = pool_dtr,
@@ -4338,9 +4338,23 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->max_discard_sectors = 2048 * 1024 * 16; /* 16G */
 }
 
+static enum blk_nospace_strategy thin_get_nospace_strategy(struct dm_target *ti)
+{
+	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
+
+	if (pool->pf.error_if_no_space)
+		return FAST_FAILS_IF_NOSPACE;
+
+	else if (!ACCESS_ONCE(no_space_timeout_secs))
+		return NEVER_FAILS_IF_NOSPACE;
+
+	return SLOW_FAILS_IF_NOSPACE;
+}
+
 static struct target_type thin_target = {
 	.name = "thin",
-	.version = {1, 16, 0},
+	.version = {1, 17, 0},
 	.module	= THIS_MODULE,
 	.ctr = thin_ctr,
 	.dtr = thin_dtr,
@@ -4353,6 +4367,7 @@ static struct target_type thin_target = {
 	.merge = thin_merge,
 	.iterate_devices = thin_iterate_devices,
 	.io_hints = thin_io_hints,
+	.get_nospace_strategy = thin_get_nospace_strategy,
 };
 
 /*----------------------------------------------------------------*/
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ab37ae1..226d856 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -597,6 +597,38 @@ out:
 	return r;
 }
 
+static enum blk_nospace_strategy dm_blk_get_nospace_strategy(struct block_device *bdev)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	int srcu_idx;
+	struct dm_table *map;
+	struct dm_target *tgt;
+	enum blk_nospace_strategy nospace_strategy = FAST_FAILS_IF_NOSPACE;
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
+	if (!tgt->type->get_nospace_strategy)
+		goto out;
+
+	if (dm_suspended_md(md))
+		goto out;
+
+	nospace_strategy = tgt->type->get_nospace_strategy(tgt);
+
+out:
+	dm_put_live_table(md, srcu_idx);
+
+	return nospace_strategy;
+}
+
 static struct dm_io *alloc_io(struct mapped_device *md)
 {
 	return mempool_alloc(md->io_pool, GFP_NOIO);
@@ -3647,6 +3679,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
+	.get_nospace_strategy = dm_blk_get_nospace_strategy,
 	.owner = THIS_MODULE
 };
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1982437..a492644 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -469,6 +469,16 @@ long bdev_direct_access(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
 
+enum blk_nospace_strategy bdev_get_nospace_strategy(struct block_device *bdev)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (!ops->get_nospace_strategy)
+		return FAST_FAILS_IF_NOSPACE;
+	return ops->get_nospace_strategy(bdev);
+}
+EXPORT_SYMBOL_GPL(bdev_get_nospace_strategy);
+
 /*
  * pseudo-fs
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d4068c17d..fab5482 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1549,6 +1549,12 @@ static inline bool blk_integrity_is_initialized(struct gendisk *g)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+enum blk_nospace_strategy {
+	FAST_FAILS_IF_NOSPACE,	      /* immediate ENOSPC (no special handling) */
+	SLOW_FAILS_IF_NOSPACE,	      /* queue IO for some time, then ENOSPC */
+	NEVER_FAILS_IF_NOSPACE,	      /* queue IO forever */
+};
+
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
@@ -1566,6 +1572,7 @@ struct block_device_operations {
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
 	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
+	enum blk_nospace_strategy (*get_nospace_strategy) (struct block_device *);
 	struct module *owner;
 };
 
@@ -1576,6 +1583,8 @@ extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, sector_t, void **addr,
 						unsigned long *pfn, long size);
+extern enum blk_nospace_strategy bdev_get_nospace_strategy(struct block_device *);
+
 #else /* CONFIG_BLOCK */
 
 struct block_device;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 51cc1de..2e3c5d5 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -119,6 +119,11 @@ typedef void (*dm_io_hints_fn) (struct dm_target *ti,
  */
 typedef int (*dm_busy_fn) (struct dm_target *ti);
 
+/*
+ * Returns how the target handles -ENOSPC from lower layers.
+ */
+typedef enum blk_nospace_strategy (*dm_get_nospace_strategy_fn) (struct dm_target *ti);
+
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -164,6 +169,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_get_nospace_strategy_fn get_nospace_strategy;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
2.3.2 (Apple Git-55)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
