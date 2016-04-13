Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 514B07CCB
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:37:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 165258F8049
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:37:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aa5f9HOZlLc4MVGq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:37:54 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 34/42] drivers: set request op to REQ_OP
Date: Wed, 13 Apr 2016 14:36:20 -0500
Message-Id: <1460576188-5751-35-git-send-email-mchristi@redhat.com>
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

This patch has the block drivers use the request->op for REQ_OP
operations and cmd_flags for rq_flag_bits.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c              |  6 +++---
 drivers/block/mtip32xx/mtip32xx.c |  2 +-
 drivers/block/nbd.c               |  2 +-
 drivers/block/rbd.c               |  2 +-
 drivers/block/skd_main.c          | 11 ++++-------
 drivers/block/xen-blkfront.c      |  8 +++++---
 drivers/md/dm.c                   |  2 +-
 drivers/mmc/card/block.c          |  7 +++----
 drivers/mmc/card/queue.c          |  6 ++----
 drivers/mmc/card/queue.h          |  5 ++++-
 drivers/mtd/mtd_blkdevs.c         |  2 +-
 drivers/nvme/host/core.c          |  2 +-
 drivers/nvme/host/nvme.h          |  2 +-
 drivers/nvme/host/pci.c           |  2 +-
 drivers/scsi/sd.c                 | 25 ++++++++++++++++---------
 15 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 7e5e27a..0e80c9b 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -538,7 +538,7 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	if (rq->cmd_flags & REQ_WRITE) {
 		if (rq->cmd_flags & REQ_FLUSH)
 			ret = lo_req_flush(lo, rq);
-		else if (rq->cmd_flags & REQ_DISCARD)
+		else if (rq->op == REQ_OP_DISCARD)
 			ret = lo_discard(lo, rq, pos);
 		else if (lo->transfer)
 			ret = lo_write_transfer(lo, rq, pos);
@@ -1653,8 +1653,8 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (lo->lo_state != Lo_bound)
 		return -EIO;
 
-	if (lo->use_dio && !(cmd->rq->cmd_flags & (REQ_FLUSH |
-					REQ_DISCARD)))
+	if (lo->use_dio && (!(cmd->rq->cmd_flags & REQ_FLUSH) ||
+	     cmd->rq->op == REQ_OP_DISCARD))
 		cmd->use_aio = true;
 	else
 		cmd->use_aio = false;
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 6053e46..7638273 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3765,7 +3765,7 @@ static int mtip_submit_request(struct blk_mq_hw_ctx *hctx, struct request *rq)
 			return -ENODATA;
 	}
 
-	if (rq->cmd_flags & REQ_DISCARD) {
+	if (rq->op == REQ_OP_DISCARD) {
 		int err;
 
 		err = mtip_send_trim(dd, blk_rq_pos(rq), blk_rq_sectors(rq));
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 31e73a7..68a1476 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -282,7 +282,7 @@ static int nbd_send_req(struct nbd_device *nbd, struct request *req)
 
 	if (req->cmd_type == REQ_TYPE_DRV_PRIV)
 		type = NBD_CMD_DISC;
-	else if (req->cmd_flags & REQ_DISCARD)
+	else if (req->op == REQ_OP_DISCARD)
 		type = NBD_CMD_TRIM;
 	else if (req->cmd_flags & REQ_FLUSH)
 		type = NBD_CMD_FLUSH;
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 94a1843..e8935af 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3371,7 +3371,7 @@ static void rbd_queue_workfn(struct work_struct *work)
 		goto err;
 	}
 
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (rq->op == REQ_OP_DISCARD)
 		op_type = OBJ_OP_DISCARD;
 	else if (rq->cmd_flags & REQ_WRITE)
 		op_type = OBJ_OP_WRITE;
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 41aaae3..5739223 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -576,7 +576,6 @@ static void skd_request_fn(struct request_queue *q)
 	struct request *req = NULL;
 	struct skd_scsi_request *scsi_req;
 	struct page *page;
-	unsigned long io_flags;
 	int error;
 	u32 lba;
 	u32 count;
@@ -624,12 +623,11 @@ static void skd_request_fn(struct request_queue *q)
 		lba = (u32)blk_rq_pos(req);
 		count = blk_rq_sectors(req);
 		data_dir = rq_data_dir(req);
-		io_flags = req->cmd_flags;
 
-		if (io_flags & REQ_FLUSH)
+		if (req->cmd_flags & REQ_FLUSH)
 			flush++;
 
-		if (io_flags & REQ_FUA)
+		if (req->cmd_flags & REQ_FUA)
 			fua++;
 
 		pr_debug("%s:%s:%d new req=%p lba=%u(0x%x) "
@@ -735,7 +733,7 @@ static void skd_request_fn(struct request_queue *q)
 		else
 			skreq->sg_data_dir = SKD_DATA_DIR_HOST_TO_CARD;
 
-		if (io_flags & REQ_DISCARD) {
+		if (req->op == REQ_OP_DISCARD) {
 			page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
 			if (!page) {
 				pr_err("request_fn:Page allocation failed.\n");
@@ -852,9 +850,8 @@ static void skd_end_request(struct skd_device *skdev,
 			    struct skd_request_context *skreq, int error)
 {
 	struct request *req = skreq->req;
-	unsigned int io_flags = req->cmd_flags;
 
-	if ((io_flags & REQ_DISCARD) &&
+	if ((req->op == REQ_OP_DISCARD) &&
 		(skreq->discard_page == 1)) {
 		pr_debug("%s:%s:%d, free the page!",
 			 skdev->name, __func__, __LINE__);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 52963a2..dc08d4d 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -844,7 +844,8 @@ static int blkif_queue_request(struct request *req, struct blkfront_ring_info *r
 	if (unlikely(rinfo->dev_info->connected != BLKIF_STATE_CONNECTED))
 		return 1;
 
-	if (unlikely(req->cmd_flags & (REQ_DISCARD | REQ_SECURE)))
+	if (unlikely(req->op == REQ_OP_DISCARD ||
+		     req->cmd_flags & REQ_SECURE))
 		return blkif_queue_discard_req(req, rinfo);
 	else
 		return blkif_queue_rw_req(req, rinfo);
@@ -2054,8 +2055,9 @@ static int blkif_recover(struct blkfront_info *info)
 			/*
 			 * Get the bios in the request so we can re-queue them.
 			 */
-			if (copy[i].request->cmd_flags &
-			    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
+			if (copy[i].request->cmd_flags & REQ_FLUSH ||
+			    copy[i].request->op == REQ_OP_DISCARD ||
+			    copy[i].request->cmd_flags & (REQ_FUA | REQ_SECURE)) {
 				/*
 				 * Flush operations don't contain bios, so
 				 * we need to requeue the whole request
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 98fea0e..13c869c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1322,7 +1322,7 @@ static void dm_done(struct request *clone, int error, bool mapped)
 			r = rq_end_io(tio->ti, clone, error, &tio->info);
 	}
 
-	if (unlikely(r == -EREMOTEIO && (clone->cmd_flags & REQ_WRITE_SAME) &&
+	if (unlikely(r == -EREMOTEIO && (clone->op == REQ_OP_WRITE_SAME) &&
 		     !clone->q->limits.max_write_same_sectors))
 		disable_write_same(tio->md);
 
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 8db2bf0..8fa3982 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1696,8 +1696,7 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 		    !IS_ALIGNED(blk_rq_sectors(next), 8))
 			break;
 
-		if (next->cmd_flags & REQ_DISCARD ||
-		    next->cmd_flags & REQ_FLUSH)
+		if (next->op == REQ_OP_DISCARD || next->cmd_flags & REQ_FLUSH)
 			break;
 
 		if (rq_data_dir(cur) != rq_data_dir(next))
@@ -2138,7 +2137,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	}
 
 	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
-	if (cmd_flags & REQ_DISCARD) {
+	if (req && req->op == REQ_OP_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
@@ -2162,7 +2161,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 
 out:
 	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
-	     (cmd_flags & MMC_REQ_SPECIAL_MASK))
+	    mmc_req_is_special(req))
 		/*
 		 * Release host when there are no more requests
 		 * and after special request(discard, flush) is done.
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 6f4323c..9fb8d21 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -33,7 +33,7 @@ static int mmc_prep_request(struct request_queue *q, struct request *req)
 	/*
 	 * We only like normal block requests and discards.
 	 */
-	if (req->cmd_type != REQ_TYPE_FS && !(req->cmd_flags & REQ_DISCARD)) {
+	if (req->cmd_type != REQ_TYPE_FS && req->op != REQ_OP_DISCARD) {
 		blk_dump_rq_flags(req, "MMC bad request");
 		return BLKPREP_KILL;
 	}
@@ -56,7 +56,6 @@ static int mmc_queue_thread(void *d)
 	down(&mq->thread_sem);
 	do {
 		struct request *req = NULL;
-		unsigned int cmd_flags = 0;
 
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -66,7 +65,6 @@ static int mmc_queue_thread(void *d)
 
 		if (req || mq->mqrq_prev->req) {
 			set_current_state(TASK_RUNNING);
-			cmd_flags = req ? req->cmd_flags : 0;
 			mq->issue_fn(mq, req);
 			cond_resched();
 			if (mq->flags & MMC_QUEUE_NEW_REQUEST) {
@@ -81,7 +79,7 @@ static int mmc_queue_thread(void *d)
 			 * has been finished. Do not assign it to previous
 			 * request.
 			 */
-			if (cmd_flags & MMC_REQ_SPECIAL_MASK)
+			if (mmc_req_is_special(req))
 				mq->mqrq_cur->req = NULL;
 
 			mq->mqrq_prev->brq.mrq.data = NULL;
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index 36cddab..f166e5b 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -1,7 +1,10 @@
 #ifndef MMC_QUEUE_H
 #define MMC_QUEUE_H
 
-#define MMC_REQ_SPECIAL_MASK	(REQ_DISCARD | REQ_FLUSH)
+static inline bool mmc_req_is_special(struct request *req)
+{
+	return req && (req->cmd_flags & REQ_FLUSH || req->op == REQ_OP_DISCARD);
+}
 
 struct request;
 struct task_struct;
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 74ae243..e8b0263 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -94,7 +94,7 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	    get_capacity(req->rq_disk))
 		return -EIO;
 
-	if (req->cmd_flags & REQ_DISCARD)
+	if (req->op == REQ_OP_DISCARD)
 		return tr->discard(dev, block, nsect);
 
 	if (rq_data_dir(req) == READ) {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4eb5759..b741aed 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -234,7 +234,7 @@ int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 		memcpy(cmd, req->cmd, sizeof(*cmd));
 	else if (req->cmd_flags & REQ_FLUSH)
 		nvme_setup_flush(ns, cmd);
-	else if (req->cmd_flags & REQ_DISCARD)
+	else if (req->op == REQ_OP_DISCARD)
 		ret = nvme_setup_discard(ns, req, cmd);
 	else
 		nvme_setup_rw(ns, req, cmd);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 8e8fae8..0f04523 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -175,7 +175,7 @@ static inline u64 nvme_block_nr(struct nvme_ns *ns, sector_t sector)
 
 static inline unsigned nvme_map_len(struct request *rq)
 {
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (rq->op == REQ_OP_DISCARD)
 		return sizeof(struct nvme_dsm_range);
 	else
 		return blk_rq_bytes(rq);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 36b6cdf..907d127 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -363,7 +363,7 @@ static void nvme_free_iod(struct nvme_dev *dev, struct request *req)
 	__le64 **list = iod_list(req);
 	dma_addr_t prp_dma = iod->first_dma;
 
-	if (req->cmd_flags & REQ_DISCARD)
+	if (req->op == REQ_OP_DISCARD)
 		kfree(req->completion_data);
 
 	if (iod->npages == 0)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 428c03e..2fc7191 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1012,7 +1012,8 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
 	} else {
-		scmd_printk(KERN_ERR, SCpnt, "Unknown command %llx\n", (unsigned long long) rq->cmd_flags);
+		scmd_printk(KERN_ERR, SCpnt, "Unknown command %d,%llx\n",
+			    rq->op, (unsigned long long) rq->cmd_flags);
 		goto out;
 	}
 
@@ -1137,21 +1138,27 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
 
-	if (rq->cmd_flags & REQ_DISCARD)
+	switch (rq->op) {
+	case REQ_OP_DISCARD:
 		return sd_setup_discard_cmnd(cmd);
-	else if (rq->cmd_flags & REQ_WRITE_SAME)
+	case REQ_OP_WRITE_SAME:
 		return sd_setup_write_same_cmnd(cmd);
-	else if (rq->cmd_flags & REQ_FLUSH)
-		return sd_setup_flush_cmnd(cmd);
-	else
-		return sd_setup_read_write_cmnd(cmd);
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+		if (rq->cmd_flags & REQ_FLUSH)
+			return sd_setup_flush_cmnd(cmd);
+		else
+			return sd_setup_read_write_cmnd(cmd);
+	default:
+		BUG();
+	}
 }
 
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (rq->op == REQ_OP_DISCARD)
 		__free_page(rq->completion_data);
 
 	if (SCpnt->cmnd != rq->cmd) {
@@ -1769,7 +1776,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	unsigned char op = SCpnt->cmnd[0];
 	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
-	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME) {
+	if (req->op == REQ_OP_DISCARD || req->op == REQ_OP_WRITE_SAME) {
 		if (!result) {
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
