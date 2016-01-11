Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BDD4329E78
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 14:23:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38E20AC001
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:23:04 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 648OoA10IJGmskOF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:23:01 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 34/35] block: add QUEUE_FLAGs for flush and fua
Date: Mon, 11 Jan 2016 14:21:32 -0600
Message-Id: <1452543693-4440-35-git-send-email-mchristi@redhat.com>
In-Reply-To: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
References: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

The last patch added a REQ_OP_FLUSH for request_fn drivers
and the next patch renames REQ_FLUSH to REQ_PREFLUSH which
will be used by file systems and make_request_fn drivers.

This leaves REQ_FLUSH/REQ_FUA defined for drivers to tell
the block layer if flush/fua is supported. The names are
confusing and I bet will will accidentally be used by
people to request flushes. To avoid that, this patch adds
QUEUE_FLAGs for flush and fua which drivers will use to
indicate what they support.

v2:

1. Fix kbuild failures. Forgot to update ubd driver.

v3:

1. Rename dm_table_supports_flush callout function argument to
callout_fn.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 arch/um/drivers/ubd_kern.c          |  2 +-
 block/blk-core.c                    |  3 +-
 block/blk-flush.c                   | 12 ++++----
 block/blk-settings.c                | 20 --------------
 drivers/block/drbd/drbd_main.c      |  3 +-
 drivers/block/loop.c                |  2 +-
 drivers/block/mtip32xx/mtip32xx.c   |  3 +-
 drivers/block/nbd.c                 |  6 ++--
 drivers/block/osdblk.c              |  2 +-
 drivers/block/ps3disk.c             |  2 +-
 drivers/block/skd_main.c            |  3 +-
 drivers/block/virtio_blk.c          |  4 +--
 drivers/block/xen-blkback/xenbus.c  |  2 +-
 drivers/block/xen-blkfront.c        | 55 ++++++++++++++++++++++---------------
 drivers/ide/ide-disk.c              |  6 ++--
 drivers/md/bcache/super.c           |  4 +--
 drivers/md/dm-table.c               | 32 +++++++++++++--------
 drivers/md/md.c                     |  3 +-
 drivers/md/raid5-cache.c            |  3 +-
 drivers/mmc/card/block.c            |  3 +-
 drivers/mtd/mtd_blkdevs.c           |  2 +-
 drivers/nvme/host/core.c            |  6 ++--
 drivers/scsi/sd.c                   | 13 +++++----
 drivers/target/target_core_iblock.c |  6 ++--
 include/linux/blkdev.h              |  6 ++--
 25 files changed, 108 insertions(+), 95 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index a7dc382..44380d6 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -862,7 +862,7 @@ static int ubd_add(int n, char **error_out)
 		goto out;
 	}
 	ubd_dev->queue->queuedata = ubd_dev;
-	blk_queue_flush(ubd_dev->queue, REQ_FLUSH);
+	queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, ubd_dev->queue);
 
 	blk_queue_max_segments(ubd_dev->queue, MAX_SG);
 	err = ubd_disk_register(UBD_MAJOR, ubd_dev->size, n, &ubd_gendisk[n]);
diff --git a/block/blk-core.c b/block/blk-core.c
index 1681f7e..cfa70f7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1968,7 +1968,8 @@ generic_make_request_checks(struct bio *bio)
 	 * drivers without flush support don't have to worry
 	 * about them.
 	 */
-	if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
+	if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) &&
+	    !(blk_queue_flush(q) || blk_queue_fua(q))) {
 		bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
 		if (!nr_sectors) {
 			err = 0;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 070d7c7..e07ca6c 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -95,17 +95,18 @@ enum {
 static bool blk_kick_flush(struct request_queue *q,
 			   struct blk_flush_queue *fq);
 
-static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
+static unsigned int blk_flush_policy(struct request *rq)
 {
+	struct request_queue *q = rq->q;
 	unsigned int policy = 0;
 
 	if (blk_rq_sectors(rq))
 		policy |= REQ_FSEQ_DATA;
 
-	if (fflags & REQ_FLUSH) {
+	if (blk_queue_flush(q)) {
 		if (rq->cmd_flags & REQ_FLUSH)
 			policy |= REQ_FSEQ_PREFLUSH;
-		if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
+		if (!blk_queue_fua(q) && (rq->cmd_flags & REQ_FUA))
 			policy |= REQ_FSEQ_POSTFLUSH;
 	}
 	return policy;
@@ -385,8 +386,7 @@ static void mq_flush_data_end_io(struct request *rq, int error)
 void blk_insert_flush(struct request *rq)
 {
 	struct request_queue *q = rq->q;
-	unsigned int fflags = q->flush_flags;	/* may change, cache */
-	unsigned int policy = blk_flush_policy(fflags, rq);
+	unsigned int policy = blk_flush_policy(rq);
 	struct blk_flush_queue *fq = blk_get_flush_queue(q, rq->mq_ctx);
 
 	/*
@@ -394,7 +394,7 @@ void blk_insert_flush(struct request *rq)
 	 * REQ_FLUSH and FUA for the driver.
 	 */
 	rq->cmd_flags &= ~REQ_FLUSH;
-	if (!(fflags & REQ_FUA))
+	if (!blk_queue_fua(q))
 		rq->cmd_flags &= ~REQ_FUA;
 
 	/*
diff --git a/block/blk-settings.c b/block/blk-settings.c
index dd49735..3cef016 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -820,26 +820,6 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
-/**
- * blk_queue_flush - configure queue's cache flush capability
- * @q:		the request queue for the device
- * @flush:	0, REQ_FLUSH or REQ_FLUSH | REQ_FUA
- *
- * Tell block layer cache flush capability of @q.  If it supports
- * flushing, REQ_FLUSH should be set.  If it supports bypassing
- * write cache for individual writes, REQ_FUA should be set.
- */
-void blk_queue_flush(struct request_queue *q, unsigned int flush)
-{
-	WARN_ON_ONCE(flush & ~(REQ_FLUSH | REQ_FUA));
-
-	if (WARN_ON_ONCE(!(flush & REQ_FLUSH) && (flush & REQ_FUA)))
-		flush &= ~REQ_FUA;
-
-	q->flush_flags = flush & (REQ_FLUSH | REQ_FUA);
-}
-EXPORT_SYMBOL_GPL(blk_queue_flush);
-
 void blk_queue_flush_queueable(struct request_queue *q, bool queueable)
 {
 	q->flush_not_queueable = !queueable;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 76ff804..8a767d3 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2762,7 +2762,8 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	q->backing_dev_info.congested_data = device;
 
 	blk_queue_make_request(q, drbd_make_request);
-	blk_queue_flush(q, REQ_FLUSH | REQ_FUA);
+	queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_FUA, q);
 	/* Setting the max_hw_sectors to an odd value of 8kibyte here
 	   This triggers a max_bio_size message upon first attach or connect */
 	blk_queue_max_hw_sectors(q, DRBD_MAX_BIO_SIZE_SAFE >> 8);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a3d1293..297a91f 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -937,7 +937,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
-		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
+		queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, lo->lo_queue);
 
 	loop_update_dio(lo);
 	set_capacity(lo->lo_disk, size);
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 3995a9e..0c41ce4 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3910,7 +3910,8 @@ skip_create_disk:
 	 * write back cache is not supported in the device. FUA depends on
 	 * write back cache support, hence setting flush support to zero.
 	 */
-	blk_queue_flush(dd->queue, 0);
+	queue_flag_clear_unlocked(QUEUE_FLAG_FLUSH, dd->queue);
+	queue_flag_clear_unlocked(QUEUE_FLAG_FUA, dd->queue);
 
 	/* Signal trim support */
 	if (dd->trim_supp == true) {
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 3b4be71..f6bda16 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -750,9 +750,11 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
 				nbd->disk->queue);
 		if (nbd->flags & NBD_FLAG_SEND_FLUSH)
-			blk_queue_flush(nbd->disk->queue, REQ_FLUSH);
+			queue_flag_set_unlocked(QUEUE_FLAG_FLUSH,
+						nbd->disk->queue);
 		else
-			blk_queue_flush(nbd->disk->queue, 0);
+			queue_flag_clear_unlocked(QUEUE_FLAG_FLUSH,
+						  nbd->disk->queue);
 
 		thread = kthread_run(nbd_thread_send, nbd, "%s",
 				     nbd_name(nbd));
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 3f8a0a0..d03f06a 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -437,7 +437,7 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
 	blk_queue_stack_limits(q, osd_request_queue(osdev->osd));
 
 	blk_queue_prep_rq(q, blk_queue_start_tag);
-	blk_queue_flush(q, REQ_FLUSH);
+	queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, q);
 
 	disk->queue = q;
 
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 95c524b..5985fdc 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -468,7 +468,7 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_logical_block_size(queue, dev->blk_size);
 
-	blk_queue_flush(queue, REQ_FLUSH);
+	queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, queue);
 
 	blk_queue_max_segments(queue, -1);
 	blk_queue_max_segment_size(queue, dev->bounce_size);
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index a15cc2e..68d0e22 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4409,7 +4409,8 @@ static int skd_cons_disk(struct skd_device *skdev)
 	disk->queue = q;
 	q->queuedata = skdev;
 
-	blk_queue_flush(q, REQ_FLUSH | REQ_FUA);
+	queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_FUA, q);
 	blk_queue_max_segments(q, skdev->sgs_per_request);
 	blk_queue_max_hw_sectors(q, SKD_N_MAX_SECTORS);
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c6d3bc2..b8a508b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -489,9 +489,9 @@ static void virtblk_update_cache_mode(struct virtio_device *vdev)
 	struct virtio_blk *vblk = vdev->priv;
 
 	if (writeback)
-		blk_queue_flush(vblk->disk->queue, REQ_FLUSH);
+		queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, vblk->disk->queue);
 	else
-		blk_queue_flush(vblk->disk->queue, 0);
+		queue_flag_clear_unlocked(QUEUE_FLAG_FLUSH, vblk->disk->queue);
 
 	revalidate_disk(vblk->disk);
 }
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index f53cff4..4569692 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -413,7 +413,7 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 		vbd->type |= VDISK_REMOVABLE;
 
 	q = bdev_get_queue(bdev);
-	if (q && q->flush_flags)
+	if (q && (blk_queue_flush(q) || blk_queue_fua(q)))
 		vbd->flush_support = true;
 
 	if (q && blk_queue_secdiscard(q))
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 1d48f0a..6007c86 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -146,6 +146,7 @@ struct blkfront_info
 	unsigned int persistent_gnts_c;
 	unsigned long shadow_free;
 	unsigned int feature_flush;
+	unsigned int feature_fua;
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
 	unsigned int discard_granularity;
@@ -655,19 +656,15 @@ static int blkif_queue_rw_req(struct request *req)
 			 * implement it the same way.  (It's also a FLUSH+FUA,
 			 * since it is guaranteed ordered WRT previous writes.)
 			 */
-			switch (info->feature_flush &
-				((REQ_FLUSH|REQ_FUA))) {
-			case REQ_FLUSH|REQ_FUA:
+			if (blk_queue_flush(info->rq) &&
+			    blk_queue_fua(info->rq))
 				ring_req->operation =
 					BLKIF_OP_WRITE_BARRIER;
-				break;
-			case REQ_FLUSH:
+			else if (blk_queue_flush(info->rq))
 				ring_req->operation =
 					BLKIF_OP_FLUSH_DISKCACHE;
-				break;
-			default:
+			else
 				ring_req->operation = 0;
-			}
 		}
 		ring_req->u.rw.nr_segments = num_grant;
 	}
@@ -740,9 +737,9 @@ static inline bool blkif_request_flush_invalid(struct request *req,
 {
 	return ((req->cmd_type != REQ_TYPE_FS) ||
 		((req->op == REQ_OP_FLUSH) &&
-		 !(info->feature_flush & REQ_FLUSH)) ||
+		 !(blk_queue_flush(info->rq))) ||
 		((req->cmd_flags & REQ_FUA) &&
-		 !(info->feature_flush & REQ_FUA)));
+		 !(blk_queue_fua(info->rq))));
 }
 
 static int blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
@@ -838,23 +835,30 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 	return 0;
 }
 
-static const char *flush_info(unsigned int feature_flush)
+static const char *flush_info(struct blkfront_info *info)
 {
-	switch (feature_flush & ((REQ_FLUSH | REQ_FUA))) {
-	case REQ_FLUSH|REQ_FUA:
+	if (blk_queue_flush(info->rq) && blk_queue_fua(info->rq))
 		return "barrier: enabled;";
-	case REQ_FLUSH:
+	else if (blk_queue_flush(info->rq))
 		return "flush diskcache: enabled;";
-	default:
+	else
 		return "barrier or flush: disabled;";
-	}
 }
 
 static void xlvbd_flush(struct blkfront_info *info)
 {
-	blk_queue_flush(info->rq, info->feature_flush);
+	if (info->feature_flush)
+		queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, info->rq);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_FLUSH, info->rq);
+
+	if (info->feature_fua)
+		queue_flag_set_unlocked(QUEUE_FLAG_FUA, info->rq);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_FUA, info->rq);
+
 	pr_info("blkfront: %s: %s %s %s %s %s\n",
-		info->gd->disk_name, flush_info(info->feature_flush),
+		info->gd->disk_name, flush_info(info),
 		"persistent grants:", info->feature_persistent ?
 		"enabled;" : "disabled;", "indirect descriptors:",
 		info->max_indirect_segments ? "enabled;" : "disabled;");
@@ -1373,6 +1377,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 			if (unlikely(error)) {
 				if (error == -EOPNOTSUPP)
 					error = 0;
+				info->feature_fua = 0;
 				info->feature_flush = 0;
 				xlvbd_flush(info);
 			}
@@ -1936,6 +1941,7 @@ static int blkfront_gather_backend_features(struct blkfront_info *info)
 	unsigned int indirect_segments;
 
 	info->feature_flush = 0;
+	info->feature_fua = 0;
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			"feature-barrier", "%d", &barrier,
@@ -1948,8 +1954,11 @@ static int blkfront_gather_backend_features(struct blkfront_info *info)
 	 *
 	 * If there are barriers, then we use flush.
 	 */
-	if (!err && barrier)
-		info->feature_flush = REQ_FLUSH | REQ_FUA;
+	if (!err && barrier) {
+		info->feature_flush = 1;
+		info->feature_fua = 1;
+	}
+
 	/*
 	 * And if there is "feature-flush-cache" use that above
 	 * barriers.
@@ -1958,8 +1967,10 @@ static int blkfront_gather_backend_features(struct blkfront_info *info)
 			"feature-flush-cache", "%d", &flush,
 			NULL);
 
-	if (!err && flush)
-		info->feature_flush = REQ_FLUSH;
+	if (!err && flush) {
+		info->feature_flush = 1;
+		info->feature_fua = 0;
+	}
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			"feature-discard", "%d", &discard,
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 6474ed3..4501ca7 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -522,8 +522,8 @@ static int ide_do_setfeature(ide_drive_t *drive, u8 feature, u8 nsect)
 static void update_flush(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
-	unsigned flush = 0;
 
+	queue_flag_clear_unlocked(QUEUE_FLAG_FLUSH, drive->queue);
 	if (drive->dev_flags & IDE_DFLAG_WCACHE) {
 		unsigned long long capacity;
 		int barrier;
@@ -546,12 +546,10 @@ static void update_flush(ide_drive_t *drive)
 		       drive->name, barrier ? "" : "not ");
 
 		if (barrier) {
-			flush = REQ_FLUSH;
 			blk_queue_prep_rq(drive->queue, idedisk_prep_fn);
+			queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, drive->queue);
 		}
 	}
-
-	blk_queue_flush(drive->queue, flush);
 }
 
 ide_devset_get_flag(wcache, IDE_DFLAG_WCACHE);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index b11f7f4..3d75a0f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -820,8 +820,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	clear_bit(QUEUE_FLAG_ADD_RANDOM, &d->disk->queue->queue_flags);
 	set_bit(QUEUE_FLAG_DISCARD,	&d->disk->queue->queue_flags);
 
-	blk_queue_flush(q, REQ_FLUSH|REQ_FUA);
-
+	queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_FUA, q);
 	return 0;
 }
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 061152a..9a4b3cb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1312,13 +1312,21 @@ static void dm_table_verify_integrity(struct dm_table *t)
 static int device_flush_capable(struct dm_target *ti, struct dm_dev *dev,
 				sector_t start, sector_t len, void *data)
 {
-	unsigned flush = (*(unsigned *)data);
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && (q->flush_flags & flush);
+	return q && blk_queue_flush(q);
 }
 
-static bool dm_table_supports_flush(struct dm_table *t, unsigned flush)
+static int device_fua_capable(struct dm_target *ti, struct dm_dev *dev,
+			      sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && blk_queue_fua(q);
+}
+
+static bool dm_table_supports_flush(struct dm_table *t,
+				    iterate_devices_callout_fn callout_fn)
 {
 	struct dm_target *ti;
 	unsigned i = 0;
@@ -1339,7 +1347,7 @@ static bool dm_table_supports_flush(struct dm_table *t, unsigned flush)
 			return true;
 
 		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, device_flush_capable, &flush))
+		    ti->type->iterate_devices(ti, callout_fn, NULL))
 			return true;
 	}
 
@@ -1470,8 +1478,6 @@ static bool dm_table_supports_discards(struct dm_table *t)
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
-	unsigned flush = 0;
-
 	/*
 	 * Copy table's limits to the DM device's request_queue
 	 */
@@ -1482,12 +1488,14 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 
-	if (dm_table_supports_flush(t, REQ_FLUSH)) {
-		flush |= REQ_FLUSH;
-		if (dm_table_supports_flush(t, REQ_FUA))
-			flush |= REQ_FUA;
-	}
-	blk_queue_flush(q, flush);
+	if (dm_table_supports_flush(t, device_flush_capable)) {
+		queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, q);
+		if (dm_table_supports_flush(t, device_fua_capable))
+			queue_flag_set_unlocked(QUEUE_FLAG_FUA, q);
+		else
+			queue_flag_clear_unlocked(QUEUE_FLAG_FUA, q);
+	} else
+		queue_flag_clear_unlocked(QUEUE_FLAG_FLUSH, q);
 
 	if (!dm_table_discard_zeroes_data(t))
 		q->limits.discard_zeroes_data = 0;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index a2199ad..36b61e3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5036,7 +5036,8 @@ static int md_alloc(dev_t dev, char *name)
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 	disk->queue = mddev->queue;
-	blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
+	queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, mddev->queue);
+	queue_flag_set_unlocked(QUEUE_FLAG_FUA, mddev->queue);
 	/* Allow extended partitions.  This makes the
 	 * 'mdp' device redundant, but we can't really
 	 * remove it now.
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index c4624b3..a3e586d 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1203,6 +1203,7 @@ ioerr:
 
 int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
+	struct request_queue *q = rdev->bdev->bd_disk->queue;
 	struct r5l_log *log;
 
 	if (PAGE_SIZE != 4096)
@@ -1212,7 +1213,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		return -ENOMEM;
 	log->rdev = rdev;
 
-	log->need_cache_flush = (rdev->bdev->bd_disk->queue->flush_flags != 0);
+	log->need_cache_flush = (blk_queue_flush(q) || blk_queue_fua(q));
 
 	log->uuid_checksum = crc32c_le(~0, rdev->mddev->uuid,
 				       sizeof(rdev->mddev->uuid));
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 7caf236..c1fad5f 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -2277,7 +2277,8 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	    ((card->ext_csd.rel_param & EXT_CSD_WR_REL_PARAM_EN) ||
 	     card->ext_csd.rel_sectors)) {
 		md->flags |= MMC_BLK_REL_WR;
-		blk_queue_flush(md->queue.queue, REQ_FLUSH | REQ_FUA);
+		queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, md->queue.queue);
+		queue_flag_set_unlocked(QUEUE_FLAG_FUA, md->queue.queue);
 	}
 
 	if (mmc_card_mmc(card) &&
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 67da1cd..4462627 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -409,7 +409,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 		goto error3;
 
 	if (tr->flush)
-		blk_queue_flush(new->rq, REQ_FLUSH);
+		queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, new->rq);
 
 	new->rq->queuedata = new;
 	blk_queue_logical_block_size(new->rq, tr->blksize);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1375a83..9f253bc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1078,8 +1078,10 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	}
 	if (ctrl->stripe_size)
 		blk_queue_chunk_sectors(ns->queue, ctrl->stripe_size >> 9);
-	if (ctrl->vwc & NVME_CTRL_VWC_PRESENT)
-		blk_queue_flush(ns->queue, REQ_FLUSH | REQ_FUA);
+	if (ctrl->vwc & NVME_CTRL_VWC_PRESENT) {
+		queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, ns->queue);
+		queue_flag_set_unlocked(QUEUE_FLAG_FUA, ns->queue);
+	}
 	blk_queue_virt_boundary(ns->queue, ctrl->page_size - 1);
 
 	disk->major = nvme_major;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8585b6f..a4e5b6f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -137,15 +137,18 @@ static const char *sd_cache_types[] = {
 
 static void sd_set_flush_flag(struct scsi_disk *sdkp)
 {
-	unsigned flush = 0;
+	struct request_queue *q = sdkp->disk->queue;
 
 	if (sdkp->WCE) {
-		flush |= REQ_FLUSH;
+		queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, q);
 		if (sdkp->DPOFUA)
-			flush |= REQ_FUA;
+			queue_flag_set_unlocked(QUEUE_FLAG_FUA, q);
+		else
+			queue_flag_clear_unlocked(QUEUE_FLAG_FUA, q);
+	} else {
+		queue_flag_clear_unlocked(QUEUE_FLAG_FUA, q);
+		queue_flag_clear_unlocked(QUEUE_FLAG_FLUSH, q);
 	}
-
-	blk_queue_flush(sdkp->disk->queue, flush);
 }
 
 static ssize_t
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 30f4f41..a85a391 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -671,11 +671,11 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		 * Force writethrough using WRITE_FUA if a volatile write cache
 		 * is not enabled, or if initiator set the Force Unit Access bit.
 		 */
-		if (q->flush_flags & REQ_FUA) {
+		if (blk_queue_fua(q)) {
 			if (cmd->se_cmd_flags & SCF_FUA) {
 				op = REQ_OP_WRITE;
 				op_flags = WRITE_FUA;
-			} else if (!(q->flush_flags & REQ_FLUSH)) {
+			} else if (!blk_queue_flush(q)) {
 				op = REQ_OP_WRITE;
 				op_flags = WRITE_FUA;
 			} else {
@@ -842,7 +842,7 @@ static bool iblock_get_write_cache(struct se_device *dev)
 	struct block_device *bd = ib_dev->ibd_bd;
 	struct request_queue *q = bdev_get_queue(bd);
 
-	return q->flush_flags & REQ_FLUSH;
+	return blk_queue_flush(q);
 }
 
 static const struct target_backend_ops iblock_ops = {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ec0d0d0..09724ed 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -434,7 +434,6 @@ struct request_queue {
 	/*
 	 * for flush operations
 	 */
-	unsigned int		flush_flags;
 	unsigned int		flush_not_queueable:1;
 	struct blk_flush_queue	*fq;
 
@@ -492,6 +491,8 @@ struct request_queue {
 #define QUEUE_FLAG_INIT_DONE   20	/* queue is initialized */
 #define QUEUE_FLAG_NO_SG_MERGE 21	/* don't attempt to merge SG segments*/
 #define QUEUE_FLAG_POLL	       22	/* IO polling enabled if set */
+#define QUEUE_FLAG_FLUSH       23	/* supports FLUSH/PREFLUSH */
+#define QUEUE_FLAG_FUA         24	/* supports FUA */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -580,6 +581,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
+#define blk_queue_flush(q)	test_bit(QUEUE_FLAG_FLUSH, &(q)->queue_flags)
+#define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
@@ -1007,7 +1010,6 @@ extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
-extern void blk_queue_flush(struct request_queue *q, unsigned int flush);
 extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
