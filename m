Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6CA5F7D53
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:37:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2210E8F8039
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:37:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rwww1UoyLXfeiKBp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:37:39 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 28/42] block: prepare mq request creation to use REQ_OPs
Date: Wed, 13 Apr 2016 14:36:14 -0500
Message-Id: <1460576188-5751-29-git-send-email-mchristi@redhat.com>
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

This patch modifies the blk mq request creation code to use
separate variables for the operation and flags, because in the
the next patches the struct request users will be converted like
was done for bios. request->op will be used for the REQ_OP and
request->cmd_flags for the rq_flag_bits.

Like the non mq patch there is some temporary compat code in
blk_mq_rq_ctx_init to allow users to read the operation from the
cmd_flags. This will be deleted in one of the last patches when all
drivers have been converted.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1699baf..4843c0b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -159,16 +159,19 @@ bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
 EXPORT_SYMBOL(blk_mq_can_queue);
 
 static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
-			       struct request *rq, unsigned int rw_flags)
+			       struct request *rq, int op,
+			       unsigned int op_flags)
 {
 	if (blk_queue_io_stat(q))
-		rw_flags |= REQ_IO_STAT;
+		op_flags |= REQ_IO_STAT;
 
 	INIT_LIST_HEAD(&rq->queuelist);
 	/* csd/requeue_work/fifo_time is initialized before use */
 	rq->q = q;
 	rq->mq_ctx = ctx;
-	rq->cmd_flags |= rw_flags;
+	rq->op = op;
+	/* tmp compat - allow users to check either one for the op */
+	rq->cmd_flags |= op | op_flags;
 	/* do not touch atomic flags, it needs atomic ops against the timer */
 	rq->cpu = -1;
 	INIT_HLIST_NODE(&rq->hash);
@@ -203,11 +206,11 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
 
-	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
+	ctx->rq_dispatched[rw_is_sync(op | op_flags)]++;
 }
 
 static struct request *
-__blk_mq_alloc_request(struct blk_mq_alloc_data *data, int rw)
+__blk_mq_alloc_request(struct blk_mq_alloc_data *data, int op, int op_flags)
 {
 	struct request *rq;
 	unsigned int tag;
@@ -222,7 +225,7 @@ __blk_mq_alloc_request(struct blk_mq_alloc_data *data, int rw)
 		}
 
 		rq->tag = tag;
-		blk_mq_rq_ctx_init(data->q, data->ctx, rq, rw);
+		blk_mq_rq_ctx_init(data->q, data->ctx, rq, op, op_flags);
 		return rq;
 	}
 
@@ -246,7 +249,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 	blk_mq_set_alloc_data(&alloc_data, q, flags, ctx, hctx);
 
-	rq = __blk_mq_alloc_request(&alloc_data, rw);
+	rq = __blk_mq_alloc_request(&alloc_data, rw, 0);
 	if (!rq && !(flags & BLK_MQ_REQ_NOWAIT)) {
 		__blk_mq_run_hw_queue(hctx);
 		blk_mq_put_ctx(ctx);
@@ -254,7 +257,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		ctx = blk_mq_get_ctx(q);
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 		blk_mq_set_alloc_data(&alloc_data, q, flags, ctx, hctx);
-		rq =  __blk_mq_alloc_request(&alloc_data, rw);
+		rq =  __blk_mq_alloc_request(&alloc_data, rw, 0);
 		ctx = alloc_data.ctx;
 	}
 	blk_mq_put_ctx(ctx);
@@ -1170,28 +1173,29 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx;
 	struct request *rq;
-	int rw = bio_data_dir(bio);
+	int op = bio_data_dir(bio);
+	int op_flags = 0;
 	struct blk_mq_alloc_data alloc_data;
 
 	blk_queue_enter_live(q);
 	ctx = blk_mq_get_ctx(q);
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-	if (rw_is_sync(bio->bi_rw))
-		rw |= REQ_SYNC;
+	if (rw_is_sync(bio->bi_op | bio->bi_rw))
+		op_flags |= REQ_SYNC;
 
-	trace_block_getrq(q, bio, rw);
+	trace_block_getrq(q, bio, op);
 	blk_mq_set_alloc_data(&alloc_data, q, BLK_MQ_REQ_NOWAIT, ctx, hctx);
-	rq = __blk_mq_alloc_request(&alloc_data, rw);
+	rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);
 	if (unlikely(!rq)) {
 		__blk_mq_run_hw_queue(hctx);
 		blk_mq_put_ctx(ctx);
-		trace_block_sleeprq(q, bio, rw);
+		trace_block_sleeprq(q, bio, op);
 
 		ctx = blk_mq_get_ctx(q);
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 		blk_mq_set_alloc_data(&alloc_data, q, 0, ctx, hctx);
-		rq = __blk_mq_alloc_request(&alloc_data, rw);
+		rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);
 		ctx = alloc_data.ctx;
 		hctx = alloc_data.hctx;
 	}
@@ -1245,7 +1249,7 @@ static int blk_mq_direct_issue_request(struct request *rq, blk_qc_t *cookie)
  */
 static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_sync = rw_is_sync(bio->bi_op | bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
 	struct blk_map_ctx data;
 	struct request *rq;
@@ -1342,7 +1346,7 @@ done:
  */
 static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_sync = rw_is_sync(bio->bi_op | bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
 	struct blk_plug *plug;
 	unsigned int request_count = 0;
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
