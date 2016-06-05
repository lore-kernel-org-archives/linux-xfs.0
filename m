Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C2B77CEE
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87740AC003
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Dfmp2iG72a3YSflN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:33:56 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 36/45] block: convert is_sync helpers to use REQ_OPs.
Date: Sun,  5 Jun 2016 14:32:16 -0500
Message-Id: <1465155145-10812-37-git-send-email-mchristi@redhat.com>
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

This patch converts the is_sync helpers to use separate variables
for the operation and flags.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-core.c       | 6 +++---
 block/blk-mq.c         | 8 ++++----
 block/cfq-iosched.c    | 2 +-
 include/linux/blkdev.h | 6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1333bb7..f9f4228 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -962,7 +962,7 @@ static void __freed_request(struct request_list *rl, int sync)
 static void freed_request(struct request_list *rl, int op, unsigned int flags)
 {
 	struct request_queue *q = rl->q;
-	int sync = rw_is_sync(op | flags);
+	int sync = rw_is_sync(op, flags);
 
 	q->nr_rqs[sync]--;
 	rl->count[sync]--;
@@ -1075,7 +1075,7 @@ static struct request *__get_request(struct request_list *rl, int op,
 	struct elevator_type *et = q->elevator->type;
 	struct io_context *ioc = rq_ioc(bio);
 	struct io_cq *icq = NULL;
-	const bool is_sync = rw_is_sync(op | op_flags) != 0;
+	const bool is_sync = rw_is_sync(op, op_flags) != 0;
 	int may_queue;
 
 	if (unlikely(blk_queue_dying(q)))
@@ -1244,7 +1244,7 @@ static struct request *get_request(struct request_queue *q, int op,
 				   int op_flags, struct bio *bio,
 				   gfp_t gfp_mask)
 {
-	const bool is_sync = rw_is_sync(op | op_flags) != 0;
+	const bool is_sync = rw_is_sync(op, op_flags) != 0;
 	DEFINE_WAIT(wait);
 	struct request_list *rl;
 	struct request *rq;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3393f29..29bcd9c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -204,7 +204,7 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
 
-	ctx->rq_dispatched[rw_is_sync(op | op_flags)]++;
+	ctx->rq_dispatched[rw_is_sync(op, op_flags)]++;
 }
 
 static struct request *
@@ -1178,7 +1178,7 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	ctx = blk_mq_get_ctx(q);
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-	if (rw_is_sync(bio->bi_rw))
+	if (rw_is_sync(bio_op(bio), bio->bi_rw))
 		op_flags |= REQ_SYNC;
 
 	trace_block_getrq(q, bio, op);
@@ -1246,7 +1246,7 @@ static int blk_mq_direct_issue_request(struct request *rq, blk_qc_t *cookie)
  */
 static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_sync = rw_is_sync(bio_op(bio), bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
 	struct blk_map_ctx data;
 	struct request *rq;
@@ -1343,7 +1343,7 @@ done:
  */
 static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_sync = rw_is_sync(bio_op(bio), bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
 	struct blk_plug *plug;
 	unsigned int request_count = 0;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3dafdba..b115486 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4311,7 +4311,7 @@ static int cfq_may_queue(struct request_queue *q, int op, int op_flags)
 	if (!cic)
 		return ELV_MQUEUE_MAY;
 
-	cfqq = cic_to_cfqq(cic, rw_is_sync(op | op_flags));
+	cfqq = cic_to_cfqq(cic, rw_is_sync(op, op_flags));
 	if (cfqq) {
 		cfq_init_prio_data(cfqq, cic);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 25f01ff..4937c05 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -624,14 +624,14 @@ static inline unsigned int blk_queue_cluster(struct request_queue *q)
 /*
  * We regard a request as sync, if either a read or a sync write
  */
-static inline bool rw_is_sync(unsigned int rw_flags)
+static inline bool rw_is_sync(int op, unsigned int rw_flags)
 {
-	return !(rw_flags & REQ_WRITE) || (rw_flags & REQ_SYNC);
+	return op == REQ_OP_READ || (rw_flags & REQ_SYNC);
 }
 
 static inline bool rq_is_sync(struct request *rq)
 {
-	return rw_is_sync(rq->cmd_flags);
+	return rw_is_sync(req_op(rq), rq->cmd_flags);
 }
 
 static inline bool blk_rl_full(struct request_list *rl, bool sync)
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
