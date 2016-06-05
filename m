Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A7657CA1
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:32:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F0D8304043
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:32:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 67tLHsEWnioan9yg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:32:45 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 05/45] block, drivers,
	cgroup: use op_is_write helper instead of checking for REQ_WRITE
Date: Sun,  5 Jun 2016 14:31:45 -0500
Message-Id: <1465155145-10812-6-git-send-email-mchristi@redhat.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
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

We currently set REQ_WRITE/WRITE for all non READ IOs
like discard, flush, writesame, etc. In the next patches where we
no longer set up the op as a bitmap, we will not be able to
detect a operation direction like writesame by testing if REQ_WRITE is
set.

This patch converts the drivers and cgroup to use the
op_is_write helper. This should just cover the simple
cases. I did dm, md and bcache in their own patches
because they were more involved.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-core.c                 | 4 ++--
 block/blk-merge.c                | 2 +-
 drivers/ata/libata-scsi.c        | 2 +-
 drivers/block/loop.c             | 6 +++---
 drivers/block/umem.c             | 2 +-
 drivers/scsi/osd/osd_initiator.c | 4 ++--
 include/linux/blk-cgroup.h       | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e953407..e8e5865 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2115,7 +2115,7 @@ blk_qc_t submit_bio(struct bio *bio)
 		else
 			count = bio_sectors(bio);
 
-		if (bio->bi_rw & WRITE) {
+		if (op_is_write(bio_op(bio))) {
 			count_vm_events(PGPGOUT, count);
 		} else {
 			task_io_account_read(bio->bi_iter.bi_size);
@@ -2126,7 +2126,7 @@ blk_qc_t submit_bio(struct bio *bio)
 			char b[BDEVNAME_SIZE];
 			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
 			current->comm, task_pid_nr(current),
-				(bio->bi_rw & WRITE) ? "WRITE" : "READ",
+				op_is_write(bio_op(bio)) ? "WRITE" : "READ",
 				(unsigned long long)bio->bi_iter.bi_sector,
 				bdevname(bio->bi_bdev, b),
 				count);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2613531..b198070 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -439,7 +439,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	}
 
 	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
-		if (rq->cmd_flags & REQ_WRITE)
+		if (op_is_write(req_op(rq)))
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
 
 		sg_unmark_end(sg);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..4c6eb22 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1190,7 +1190,7 @@ static int atapi_drain_needed(struct request *rq)
 	if (likely(rq->cmd_type != REQ_TYPE_BLOCK_PC))
 		return 0;
 
-	if (!blk_rq_bytes(rq) || (rq->cmd_flags & REQ_WRITE))
+	if (!blk_rq_bytes(rq) || op_is_write(req_op(rq)))
 		return 0;
 
 	return atapi_cmd_type(rq->cmd[0]) == ATAPI_MISC;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1fa8cc2..e9f1701 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -447,7 +447,7 @@ static int lo_req_flush(struct loop_device *lo, struct request *rq)
 
 static inline void handle_partial_read(struct loop_cmd *cmd, long bytes)
 {
-	if (bytes < 0 || (cmd->rq->cmd_flags & REQ_WRITE))
+	if (bytes < 0 || op_is_write(req_op(cmd->rq)))
 		return;
 
 	if (unlikely(bytes < blk_rq_bytes(cmd->rq))) {
@@ -541,7 +541,7 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 
 	pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 
-	if (rq->cmd_flags & REQ_WRITE) {
+	if (op_is_write(req_op(rq))) {
 		if (rq->cmd_flags & REQ_FLUSH)
 			ret = lo_req_flush(lo, rq);
 		else if (rq->cmd_flags & REQ_DISCARD)
@@ -1672,7 +1672,7 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static void loop_handle_cmd(struct loop_cmd *cmd)
 {
-	const bool write = cmd->rq->cmd_flags & REQ_WRITE;
+	const bool write = op_is_write(req_op(cmd->rq));
 	struct loop_device *lo = cmd->rq->q->queuedata;
 	int ret = 0;
 
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 7939b9f..4b3ba74 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -462,7 +462,7 @@ static void process_page(unsigned long data)
 				le32_to_cpu(desc->local_addr)>>9,
 				le32_to_cpu(desc->transfer_size));
 			dump_dmastat(card, control);
-		} else if ((bio->bi_rw & REQ_WRITE) &&
+		} else if (op_is_write(bio_op(bio)) &&
 			   le32_to_cpu(desc->local_addr) >> 9 ==
 				card->init_size) {
 			card->init_size += le32_to_cpu(desc->transfer_size) >> 9;
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 3b11aad..14ed39b 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -824,7 +824,7 @@ void osd_req_write(struct osd_request *or,
 {
 	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, len);
 	WARN_ON(or->out.bio || or->out.total_bytes);
-	WARN_ON(0 == (bio->bi_rw & REQ_WRITE));
+	WARN_ON(!op_is_write(bio_op(bio)));
 	or->out.bio = bio;
 	or->out.total_bytes = len;
 }
@@ -875,7 +875,7 @@ void osd_req_read(struct osd_request *or,
 {
 	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, len);
 	WARN_ON(or->in.bio || or->in.total_bytes);
-	WARN_ON(bio->bi_rw & REQ_WRITE);
+	WARN_ON(op_is_write(bio_op(bio)));
 	or->in.bio = bio;
 	or->in.total_bytes = len;
 }
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c02e669..04f9c8d 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -601,7 +601,7 @@ static inline void blkg_rwstat_add(struct blkg_rwstat *rwstat,
 {
 	struct percpu_counter *cnt;
 
-	if (rw & REQ_WRITE)
+	if (op_is_write(rw))
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_WRITE];
 	else
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_READ];
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
