Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 386D17DAC
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:38:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B4BF304062
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:38:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4ScdzGGhcLfmrW4u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:38:10 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 41/42] block: use QUEUE flags instead of flush_flags to test
	for flush support
Date: Wed, 13 Apr 2016 14:36:27 -0500
Message-Id: <1460576188-5751-42-git-send-email-mchristi@redhat.com>
In-Reply-To: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
References: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
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
will be used by file systems and make_request_fn drivers so
they can send a write/flush combo.

Jens's cleanup in:

block: add ability to flag write back caching on a device
93e9d8e836cb1a9a58b33eb6643bf061c6119ef2

also added QUEUE flags that can be used to get the same info
as flush_flags.

This patch has drivers check the QUEUE_FLAG bits, so we do not
have to have the extra REQ_FLUSH definition.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-core.c                    |  3 ++-
 block/blk-flush.c                   | 12 +++++-----
 block/blk-settings.c                | 11 ++++-----
 drivers/block/xen-blkback/xenbus.c  |  2 +-
 drivers/block/xen-blkfront.c        | 48 +++++++++++++++++++------------------
 drivers/md/dm-table.c               | 20 +++++++++++-----
 drivers/md/raid5-cache.c            |  3 ++-
 drivers/target/target_core_iblock.c |  6 ++---
 include/linux/blkdev.h              |  3 ++-
 9 files changed, 59 insertions(+), 49 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 71ba3a9..ef69d04 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1969,7 +1969,8 @@ generic_make_request_checks(struct bio *bio)
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
index af0c805..7682680 100644
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
index 80d9327..51bc002 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -837,16 +837,13 @@ EXPORT_SYMBOL_GPL(blk_queue_flush_queueable);
 void blk_queue_write_cache(struct request_queue *q, bool wc, bool fua)
 {
 	spin_lock_irq(q->queue_lock);
-	if (wc) {
+	if (wc)
 		queue_flag_set(QUEUE_FLAG_WC, q);
-		q->flush_flags = REQ_FLUSH;
-	} else
+	else
 		queue_flag_clear(QUEUE_FLAG_WC, q);
-	if (fua) {
-		if (wc)
-			q->flush_flags |= REQ_FUA;
+	if (fua)
 		queue_flag_set(QUEUE_FLAG_FUA, q);
-	} else
+	else
 		queue_flag_clear(QUEUE_FLAG_FUA, q);
 	spin_unlock_irq(q->queue_lock);
 }
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 26aa080..1291c35 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -477,7 +477,7 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 		vbd->type |= VDISK_REMOVABLE;
 
 	q = bdev_get_queue(bdev);
-	if (q && q->flush_flags)
+	if (q && (blk_queue_flush(q) || blk_queue_fua(q)))
 		vbd->flush_support = true;
 
 	if (q && blk_queue_secdiscard(q))
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index f01691a..a0651f3 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -196,6 +196,7 @@ struct blkfront_info
 	unsigned int nr_ring_pages;
 	struct request_queue *rq;
 	unsigned int feature_flush;
+	unsigned int feature_fua;
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
 	unsigned int discard_granularity;
@@ -763,19 +764,15 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
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
 		if (unlikely(require_extra_req)) {
@@ -866,9 +863,9 @@ static inline bool blkif_request_flush_invalid(struct request *req,
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
@@ -985,24 +982,22 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
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
-	blk_queue_write_cache(info->rq, info->feature_flush & REQ_FLUSH,
-				info->feature_flush & REQ_FUA);
+	blk_queue_write_cache(info->rq, info->feature_flush ? true : false,
+			      info->feature_flush ? true : false);
 	pr_info("blkfront: %s: %s %s %s %s %s\n",
-		info->gd->disk_name, flush_info(info->feature_flush),
+		info->gd->disk_name, flush_info(info),
 		"persistent grants:", info->feature_persistent ?
 		"enabled;" : "disabled;", "indirect descriptors:",
 		info->max_indirect_segments ? "enabled;" : "disabled;");
@@ -1621,6 +1616,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 			if (unlikely(error)) {
 				if (error == -EOPNOTSUPP)
 					error = 0;
+				info->feature_fua = 0;
 				info->feature_flush = 0;
 				xlvbd_flush(info);
 			}
@@ -2315,6 +2311,7 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
 	unsigned int indirect_segments;
 
 	info->feature_flush = 0;
+	info->feature_fua = 0;
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			"feature-barrier", "%d", &barrier,
@@ -2327,8 +2324,11 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
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
@@ -2337,8 +2337,10 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
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
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4b1ffc0..a47884b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1348,13 +1348,21 @@ static void dm_table_verify_integrity(struct dm_table *t)
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
@@ -1375,7 +1383,7 @@ static bool dm_table_supports_flush(struct dm_table *t, unsigned flush)
 			return true;
 
 		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, device_flush_capable, &flush))
+		    ti->type->iterate_devices(ti, callout_fn, NULL))
 			return true;
 	}
 
@@ -1518,9 +1526,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 
-	if (dm_table_supports_flush(t, REQ_FLUSH)) {
+	if (dm_table_supports_flush(t, device_flush_capable)) {
 		wc = true;
-		if (dm_table_supports_flush(t, REQ_FUA))
+		if (dm_table_supports_flush(t, device_fua_capable))
 			fua = true;
 	}
 	blk_queue_write_cache(q, wc, fua);
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index da07670..3d88b55 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1196,6 +1196,7 @@ ioerr:
 
 int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
+	struct request_queue *q = rdev->bdev->bd_disk->queue;
 	struct r5l_log *log;
 
 	if (PAGE_SIZE != 4096)
@@ -1205,7 +1206,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		return -ENOMEM;
 	log->rdev = rdev;
 
-	log->need_cache_flush = (rdev->bdev->bd_disk->queue->flush_flags != 0);
+	log->need_cache_flush = (blk_queue_flush(q) || blk_queue_fua(q));
 
 	log->uuid_checksum = crc32c_le(~0, rdev->mddev->uuid,
 				       sizeof(rdev->mddev->uuid));
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index fb1543b..733a61a 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -691,11 +691,11 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
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
@@ -844,7 +844,7 @@ static bool iblock_get_write_cache(struct se_device *dev)
 	struct block_device *bd = ib_dev->ibd_bd;
 	struct request_queue *q = bdev_get_queue(bd);
 
-	return q->flush_flags & REQ_FLUSH;
+	return blk_queue_flush(q);
 }
 
 static const struct target_backend_ops iblock_ops = {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4fdea8e..ed33156 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -434,7 +434,6 @@ struct request_queue {
 	/*
 	 * for flush operations
 	 */
-	unsigned int		flush_flags;
 	unsigned int		flush_not_queueable:1;
 	struct blk_flush_queue	*fq;
 
@@ -583,6 +582,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
+#define blk_queue_flush(q)	test_bit(QUEUE_FLAG_WC, &(q)->queue_flags)
+#define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
