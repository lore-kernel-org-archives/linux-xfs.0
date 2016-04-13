Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D18EE7D9B
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:38:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A22018F8049
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:38:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y3ojz7DBmXUjocLd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:38:07 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 40/42] block, drivers: add REQ_OP_FLUSH operation
Date: Wed, 13 Apr 2016 14:36:26 -0500
Message-Id: <1460576188-5751-41-git-send-email-mchristi@redhat.com>
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

This adds a REQ_OP_FLUSH operation that is sent to request_fn
based drivers by the block layer's flush code, instead of
sending requests with the request->cmd_flags REQ_FLUSH bit set.

For the following 3 flush related patches, I have not tested
every driver. I have only tested scsi with xfs and btrfs.

v2.

1. Fix kbuild failures. Forgot to update ubd driver.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/block/writeback_cache_control.txt | 6 +++---
 arch/um/drivers/ubd_kern.c                      | 2 +-
 block/blk-flush.c                               | 3 ++-
 drivers/block/loop.c                            | 4 ++--
 drivers/block/nbd.c                             | 2 +-
 drivers/block/osdblk.c                          | 2 +-
 drivers/block/ps3disk.c                         | 4 ++--
 drivers/block/skd_main.c                        | 2 +-
 drivers/block/virtio_blk.c                      | 2 +-
 drivers/block/xen-blkfront.c                    | 8 ++++----
 drivers/ide/ide-disk.c                          | 2 +-
 drivers/md/dm.c                                 | 2 +-
 drivers/mmc/card/block.c                        | 5 ++---
 drivers/mmc/card/queue.h                        | 2 +-
 drivers/mtd/mtd_blkdevs.c                       | 2 +-
 drivers/nvme/host/core.c                        | 2 +-
 drivers/scsi/sd.c                               | 7 +++----
 include/linux/blk_types.h                       | 1 +
 include/linux/blkdev.h                          | 3 +++
 kernel/trace/blktrace.c                         | 5 ++++-
 20 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/Documentation/block/writeback_cache_control.txt b/Documentation/block/writeback_cache_control.txt
index 59e0516..da70bda 100644
--- a/Documentation/block/writeback_cache_control.txt
+++ b/Documentation/block/writeback_cache_control.txt
@@ -73,9 +73,9 @@ doing:
 
 	blk_queue_write_cache(sdkp->disk->queue, true, false);
 
-and handle empty REQ_FLUSH requests in its prep_fn/request_fn.  Note that
+and handle empty REQ_OP_FLUSH requests in its prep_fn/request_fn.  Note that
 REQ_FLUSH requests with a payload are automatically turned into a sequence
-of an empty REQ_FLUSH request followed by the actual write by the block
+of an empty REQ_OP_FLUSH request followed by the actual write by the block
 layer.  For devices that also support the FUA bit the block layer needs
 to be told to pass through the REQ_FUA bit using:
 
@@ -83,4 +83,4 @@ to be told to pass through the REQ_FUA bit using:
 
 and the driver must handle write requests that have the REQ_FUA bit set
 in prep_fn/request_fn.  If the FUA bit is not natively supported the block
-layer turns it into an empty REQ_FLUSH request after the actual write.
+layer turns it into an empty REQ_OP_FLUSH request after the actual write.
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 17e96dc..0cb2dab 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1286,7 +1286,7 @@ static void do_ubd_request(struct request_queue *q)
 
 		req = dev->request;
 
-		if (req->cmd_flags & REQ_FLUSH) {
+		if (req->op == REQ_OP_FLUSH) {
 			io_req = kmalloc(sizeof(struct io_thread_req),
 					 GFP_ATOMIC);
 			if (io_req == NULL) {
diff --git a/block/blk-flush.c b/block/blk-flush.c
index b05acca..af0c805 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -29,7 +29,7 @@
  * The actual execution of flush is double buffered.  Whenever a request
  * needs to execute PRE or POSTFLUSH, it queues at
  * fq->flush_queue[fq->flush_pending_idx].  Once certain criteria are met, a
- * flush is issued and the pending_idx is toggled.  When the flush
+ * REQ_OP_FLUSH is issued and the pending_idx is toggled.  When the flush
  * completes, all the requests which were pending are proceeded to the next
  * step.  This allows arbitrary merging of different types of FLUSH/FUA
  * requests.
@@ -330,6 +330,7 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
 
 	flush_rq->cmd_type = REQ_TYPE_FS;
 	flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
+	flush_rq->op = REQ_OP_FLUSH;
 	flush_rq->rq_disk = first_rq->rq_disk;
 	flush_rq->end_io = flush_end_io;
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f1f7a25..7d7d7a4f 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -536,7 +536,7 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 
 	if (op_is_write(rq->op)) {
-		if (rq->cmd_flags & REQ_FLUSH)
+		if (rq->op == REQ_OP_FLUSH)
 			ret = lo_req_flush(lo, rq);
 		else if (rq->op == REQ_OP_DISCARD)
 			ret = lo_discard(lo, rq, pos);
@@ -1653,7 +1653,7 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (lo->lo_state != Lo_bound)
 		return -EIO;
 
-	if (lo->use_dio && (!(cmd->rq->cmd_flags & REQ_FLUSH) ||
+	if (lo->use_dio && (cmd->rq->op != REQ_OP_FLUSH ||
 	     cmd->rq->op == REQ_OP_DISCARD))
 		cmd->use_aio = true;
 	else
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 68a1476..4e9fd5b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -284,7 +284,7 @@ static int nbd_send_req(struct nbd_device *nbd, struct request *req)
 		type = NBD_CMD_DISC;
 	else if (req->op == REQ_OP_DISCARD)
 		type = NBD_CMD_TRIM;
-	else if (req->cmd_flags & REQ_FLUSH)
+	else if (req->op == REQ_OP_FLUSH)
 		type = NBD_CMD_FLUSH;
 	else if (rq_data_dir(req) == WRITE)
 		type = NBD_CMD_WRITE;
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index c2854a2..806e3a3 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -321,7 +321,7 @@ static void osdblk_rq_fn(struct request_queue *q)
 		 * driver-specific, etc.
 		 */
 
-		do_flush = rq->cmd_flags & REQ_FLUSH;
+		do_flush = (rq->op == REQ_OP_FLUSH);
 		do_write = (rq_data_dir(rq) == WRITE);
 
 		if (!do_flush) { /* osd_flush does not use a bio */
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 4b7e405..2e652db 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -196,7 +196,7 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
 
 	while ((req = blk_fetch_request(q))) {
-		if (req->cmd_flags & REQ_FLUSH) {
+		if (req->op == REQ_OP_FLUSH) {
 			if (ps3disk_submit_flush_request(dev, req))
 				break;
 		} else if (req->cmd_type == REQ_TYPE_FS) {
@@ -256,7 +256,7 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
-	if (req->cmd_flags & REQ_FLUSH) {
+	if (req->op == REQ_OP_FLUSH) {
 		read = 0;
 		op = "flush";
 	} else {
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 5739223..01c3cd3 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -624,7 +624,7 @@ static void skd_request_fn(struct request_queue *q)
 		count = blk_rq_sectors(req);
 		data_dir = rq_data_dir(req);
 
-		if (req->cmd_flags & REQ_FLUSH)
+		if (req->op == REQ_OP_FLUSH)
 			flush++;
 
 		if (req->cmd_flags & REQ_FUA)
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 42758b5..7e1d041 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -172,7 +172,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
 	vbr->req = req;
-	if (req->cmd_flags & REQ_FLUSH) {
+	if (req->op == REQ_OP_FLUSH) {
 		vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_FLUSH);
 		vbr->out_hdr.sector = 0;
 		vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(vbr->req));
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index dc08d4d..f01691a 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -743,7 +743,7 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 		 * The indirect operation can only be a BLKIF_OP_READ or
 		 * BLKIF_OP_WRITE
 		 */
-		BUG_ON(req->cmd_flags & (REQ_FLUSH | REQ_FUA));
+		BUG_ON(req->op == REQ_OP_FLUSH || req->cmd_flags & REQ_FUA);
 		ring_req->operation = BLKIF_OP_INDIRECT;
 		ring_req->u.indirect.indirect_op = rq_data_dir(req) ?
 			BLKIF_OP_WRITE : BLKIF_OP_READ;
@@ -755,7 +755,7 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 		ring_req->u.rw.handle = info->handle;
 		ring_req->operation = rq_data_dir(req) ?
 			BLKIF_OP_WRITE : BLKIF_OP_READ;
-		if (req->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
+		if (req->op == REQ_OP_FLUSH || req->cmd_flags & REQ_FUA) {
 			/*
 			 * Ideally we can do an unordered flush-to-disk.
 			 * In case the backend onlysupports barriers, use that.
@@ -865,7 +865,7 @@ static inline bool blkif_request_flush_invalid(struct request *req,
 					       struct blkfront_info *info)
 {
 	return ((req->cmd_type != REQ_TYPE_FS) ||
-		((req->cmd_flags & REQ_FLUSH) &&
+		((req->op == REQ_OP_FLUSH) &&
 		 !(info->feature_flush & REQ_FLUSH)) ||
 		((req->cmd_flags & REQ_FUA) &&
 		 !(info->feature_flush & REQ_FUA)));
@@ -2055,7 +2055,7 @@ static int blkif_recover(struct blkfront_info *info)
 			/*
 			 * Get the bios in the request so we can re-queue them.
 			 */
-			if (copy[i].request->cmd_flags & REQ_FLUSH ||
+			if (copy[i].request->op == REQ_OP_FLUSH ||
 			    copy[i].request->op == REQ_OP_DISCARD ||
 			    copy[i].request->cmd_flags & (REQ_FUA | REQ_SECURE)) {
 				/*
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 05dbcce..538c343 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -431,7 +431,7 @@ static int idedisk_prep_fn(struct request_queue *q, struct request *rq)
 	ide_drive_t *drive = q->queuedata;
 	struct ide_cmd *cmd;
 
-	if (!(rq->cmd_flags & REQ_FLUSH))
+	if (rq->op != REQ_OP_FLUSH)
 		return BLKPREP_OK;
 
 	if (rq->special) {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4ee7d5c..bd852bc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2171,7 +2171,7 @@ static void dm_request_fn(struct request_queue *q)
 
 		/* always use block 0 to find the target for flushes for now */
 		pos = 0;
-		if (!(rq->cmd_flags & REQ_FLUSH))
+		if (rq->op != REQ_OP_FLUSH)
 			pos = blk_rq_pos(rq);
 
 		if ((dm_request_peeked_before_merge_deadline(md) &&
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 8fa3982..25dd331 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1696,7 +1696,7 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 		    !IS_ALIGNED(blk_rq_sectors(next), 8))
 			break;
 
-		if (next->op == REQ_OP_DISCARD || next->cmd_flags & REQ_FLUSH)
+		if (next->op == REQ_OP_DISCARD || next->op == REQ_OP_FLUSH)
 			break;
 
 		if (rq_data_dir(cur) != rq_data_dir(next))
@@ -2121,7 +2121,6 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	struct mmc_card *card = md->queue.card;
 	struct mmc_host *host = card->host;
 	unsigned long flags;
-	unsigned int cmd_flags = req ? req->cmd_flags : 0;
 
 	if (req && !mq->mqrq_prev->req)
 		/* claim host only for the first request */
@@ -2145,7 +2144,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 			ret = mmc_blk_issue_secdiscard_rq(mq, req);
 		else
 			ret = mmc_blk_issue_discard_rq(mq, req);
-	} else if (cmd_flags & REQ_FLUSH) {
+	} else if (req && req->op == REQ_OP_FLUSH) {
 		/* complete ongoing async transfer before issuing flush */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index f166e5b..6c67e4e 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -3,7 +3,7 @@
 
 static inline bool mmc_req_is_special(struct request *req)
 {
-	return req && (req->cmd_flags & REQ_FLUSH || req->op == REQ_OP_DISCARD);
+	return req && (req->op == REQ_OP_FLUSH || req->op == REQ_OP_DISCARD);
 }
 
 struct request;
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index e8b0263..688e689 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -87,7 +87,7 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	if (req->cmd_type != REQ_TYPE_FS)
 		return -EIO;
 
-	if (req->cmd_flags & REQ_FLUSH)
+	if (req->op == REQ_OP_FLUSH)
 		return tr->flush(dev);
 
 	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b741aed..7055675 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -232,7 +232,7 @@ int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 
 	if (req->cmd_type == REQ_TYPE_DRV_PRIV)
 		memcpy(cmd, req->cmd, sizeof(*cmd));
-	else if (req->cmd_flags & REQ_FLUSH)
+	else if (req->op == REQ_OP_FLUSH)
 		nvme_setup_flush(ns, cmd);
 	else if (req->op == REQ_OP_DISCARD)
 		ret = nvme_setup_discard(ns, req, cmd);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2fc7191..5fe24e6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1143,12 +1143,11 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 		return sd_setup_discard_cmnd(cmd);
 	case REQ_OP_WRITE_SAME:
 		return sd_setup_write_same_cmnd(cmd);
+	case REQ_OP_FLUSH:
+		return sd_setup_flush_cmnd(cmd);
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
-		if (rq->cmd_flags & REQ_FLUSH)
-			return sd_setup_flush_cmnd(cmd);
-		else
-			return sd_setup_read_write_cmnd(cmd);
+		return sd_setup_read_write_cmnd(cmd);
 	default:
 		BUG();
 	}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 498f395..f9e53ca 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -239,6 +239,7 @@ enum req_op {
 	REQ_OP_WRITE,
 	REQ_OP_DISCARD,		/* request to discard sectors */
 	REQ_OP_WRITE_SAME,	/* write same block many times */
+	REQ_OP_FLUSH,		/* request for cache flush */
 };
 
 typedef unsigned int blk_qc_t;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6c300cf..4fdea8e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -654,6 +654,9 @@ static inline bool rq_mergeable(struct request *rq)
 	if (rq->cmd_type != REQ_TYPE_FS)
 		return false;
 
+	if (rq->op == REQ_OP_FLUSH)
+		return false;
+
 	if (rq->cmd_flags & REQ_NOMERGE_FLAGS)
 		return false;
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 6a381ea..192d714 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -223,6 +223,8 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	what |= MASK_TC_BIT(op_flags, FUA);
 	if (op == REQ_OP_DISCARD)
 		what |= BLK_TC_ACT(BLK_TC_DISCARD);
+	if (op == REQ_OP_FLUSH)
+		what |= BLK_TC_ACT(BLK_TC_FLUSH);
 
 	pid = tsk->pid;
 	if (act_log_check(bt, what, sector, pid))
@@ -1775,7 +1777,8 @@ void blk_fill_rwbs(char *rwbs, int op, u32 rw, int bytes)
 {
 	int i = 0;
 
-	if (rw & REQ_FLUSH)
+	if (rw & REQ_FLUSH ||
+	    op == REQ_OP_FLUSH)
 		rwbs[i++] = 'F';
 
 	if (op == REQ_OP_WRITE)
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
