Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 22E917F37
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 14:22:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A03DAC005
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:45 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GYYmwDgWuSiQd9G1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:42 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 26/35] block: set op to REQ_OP
Date: Mon, 11 Jan 2016 14:21:24 -0600
Message-Id: <1452543693-4440-27-git-send-email-mchristi@redhat.com>
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

This patch converts the request related block layer code to set
request->op to a REQ_OP and cmd_flags to rq_flag_bits.

There is some tmp compat code when setting up cmd_flags so it
still carries both the op and flags. It will be removed in
in later patches in this set when I have converted all drivers.

I have not been able to test the mq paths with real mq hardware.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-core.c           | 60 ++++++++++++++++++++++++++--------------------
 block/blk-flush.c          |  1 +
 block/blk-merge.c          | 10 ++++----
 block/blk-mq.c             | 38 ++++++++++++++++-------------
 block/cfq-iosched.c        | 53 +++++++++++++++++++++++-----------------
 block/elevator.c           |  8 +++----
 include/linux/blk-cgroup.h | 13 +++++-----
 include/linux/blkdev.h     | 28 +++++++++++-----------
 include/linux/elevator.h   |  4 ++--
 9 files changed, 120 insertions(+), 95 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 954a450..dacbd68 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -959,10 +959,10 @@ static void __freed_request(struct request_list *rl, int sync)
  * A request has just been released.  Account for it, update the full and
  * congestion status, wake up any waiters.   Called under q->queue_lock.
  */
-static void freed_request(struct request_list *rl, unsigned int flags)
+static void freed_request(struct request_list *rl, int op, unsigned int flags)
 {
 	struct request_queue *q = rl->q;
-	int sync = rw_is_sync(flags);
+	int sync = rw_is_sync(op, flags);
 
 	q->nr_rqs[sync]--;
 	rl->count[sync]--;
@@ -1054,7 +1054,8 @@ static struct io_context *rq_ioc(struct bio *bio)
 /**
  * __get_request - get a free request
  * @rl: request list to allocate from
- * @rw_flags: RW and SYNC flags
+ * @op: REQ_OP_READ/REQ_OP_WRITE
+ * @op_flags: rq_flag_bits
  * @bio: bio to allocate request for (can be %NULL)
  * @gfp_mask: allocation mask
  *
@@ -1065,21 +1066,22 @@ static struct io_context *rq_ioc(struct bio *bio)
  * Returns ERR_PTR on failure, with @q->queue_lock held.
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
-static struct request *__get_request(struct request_list *rl, int rw_flags,
-				     struct bio *bio, gfp_t gfp_mask)
+static struct request *__get_request(struct request_list *rl, int op,
+				     int op_flags, struct bio *bio,
+				     gfp_t gfp_mask)
 {
 	struct request_queue *q = rl->q;
 	struct request *rq;
 	struct elevator_type *et = q->elevator->type;
 	struct io_context *ioc = rq_ioc(bio);
 	struct io_cq *icq = NULL;
-	const bool is_sync = rw_is_sync(rw_flags) != 0;
+	const bool is_sync = rw_is_sync(op, op_flags) != 0;
 	int may_queue;
 
 	if (unlikely(blk_queue_dying(q)))
 		return ERR_PTR(-ENODEV);
 
-	may_queue = elv_may_queue(q, rw_flags);
+	may_queue = elv_may_queue(q, op, op_flags);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
@@ -1123,7 +1125,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 
 	/*
 	 * Decide whether the new request will be managed by elevator.  If
-	 * so, mark @rw_flags and increment elvpriv.  Non-zero elvpriv will
+	 * so, mark @op_flags and increment elvpriv.  Non-zero elvpriv will
 	 * prevent the current elevator from being destroyed until the new
 	 * request is freed.  This guarantees icq's won't be destroyed and
 	 * makes creating new ones safe.
@@ -1132,14 +1134,14 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	 * it will be created after releasing queue_lock.
 	 */
 	if (blk_rq_should_init_elevator(bio) && !blk_queue_bypass(q)) {
-		rw_flags |= REQ_ELVPRIV;
+		op_flags |= REQ_ELVPRIV;
 		q->nr_rqs_elvpriv++;
 		if (et->icq_cache && ioc)
 			icq = ioc_lookup_icq(ioc, q);
 	}
 
 	if (blk_queue_io_stat(q))
-		rw_flags |= REQ_IO_STAT;
+		op_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
 
 	/* allocate and init request */
@@ -1149,10 +1151,12 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 
 	blk_rq_init(q, rq);
 	blk_rq_set_rl(rq, rl);
-	rq->cmd_flags = rw_flags | REQ_ALLOCED;
+	/* tmp compat - allow users to check either one for the op */
+	rq->cmd_flags = op | op_flags | REQ_ALLOCED;
+	rq->op = op;
 
 	/* init elvpriv */
-	if (rw_flags & REQ_ELVPRIV) {
+	if (op_flags & REQ_ELVPRIV) {
 		if (unlikely(et->icq_cache && !icq)) {
 			if (ioc)
 				icq = ioc_create_icq(ioc, q, gfp_mask);
@@ -1178,7 +1182,7 @@ out:
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 
-	trace_block_getrq(q, bio, rw_flags & 1);
+	trace_block_getrq(q, bio, op);
 	return rq;
 
 fail_elvpriv:
@@ -1208,7 +1212,7 @@ fail_alloc:
 	 * queue, but this is pretty rare.
 	 */
 	spin_lock_irq(q->queue_lock);
-	freed_request(rl, rw_flags);
+	freed_request(rl, op, op_flags);
 
 	/*
 	 * in the very unlikely event that allocation failed and no
@@ -1226,7 +1230,8 @@ rq_starved:
 /**
  * get_request - get a free request
  * @q: request_queue to allocate request from
- * @rw_flags: RW and SYNC flags
+ * op: REQ_OP_READ/REQ_OP_WRITE
+ * @op_flags: rq_flag_bits
  * @bio: bio to allocate request for (can be %NULL)
  * @gfp_mask: allocation mask
  *
@@ -1237,17 +1242,18 @@ rq_starved:
  * Returns ERR_PTR on failure, with @q->queue_lock held.
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
-static struct request *get_request(struct request_queue *q, int rw_flags,
-				   struct bio *bio, gfp_t gfp_mask)
+static struct request *get_request(struct request_queue *q, int op,
+				   int op_flags, struct bio *bio,
+				   gfp_t gfp_mask)
 {
-	const bool is_sync = rw_is_sync(rw_flags) != 0;
+	const bool is_sync = rw_is_sync(op, op_flags) != 0;
 	DEFINE_WAIT(wait);
 	struct request_list *rl;
 	struct request *rq;
 
 	rl = blk_get_rl(q, bio);	/* transferred to @rq on success */
 retry:
-	rq = __get_request(rl, rw_flags, bio, gfp_mask);
+	rq = __get_request(rl, op, op_flags, bio, gfp_mask);
 	if (!IS_ERR(rq))
 		return rq;
 
@@ -1260,7 +1266,7 @@ retry:
 	prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
 				  TASK_UNINTERRUPTIBLE);
 
-	trace_block_sleeprq(q, bio, rw_flags & 1);
+	trace_block_sleeprq(q, bio, op);
 
 	spin_unlock_irq(q->queue_lock);
 	io_schedule();
@@ -1289,7 +1295,7 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 	create_io_context(gfp_mask, q->node);
 
 	spin_lock_irq(q->queue_lock);
-	rq = get_request(q, rw, NULL, gfp_mask);
+	rq = get_request(q, rw, 0, NULL, gfp_mask);
 	if (IS_ERR(rq))
 		spin_unlock_irq(q->queue_lock);
 	/* q->queue_lock is unlocked at this point */
@@ -1491,13 +1497,14 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	 */
 	if (req->cmd_flags & REQ_ALLOCED) {
 		unsigned int flags = req->cmd_flags;
+		int op = req->op;
 		struct request_list *rl = blk_rq_rl(req);
 
 		BUG_ON(!list_empty(&req->queuelist));
 		BUG_ON(ELV_ON_HASH(req));
 
 		blk_free_request(rl, req);
-		freed_request(rl, flags);
+		freed_request(rl, op, flags);
 		blk_put_rl(rl);
 	}
 }
@@ -1712,7 +1719,7 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	struct blk_plug *plug;
-	int el_ret, rw_flags, where = ELEVATOR_INSERT_SORT;
+	int el_ret, rw_flags = 0, where = ELEVATOR_INSERT_SORT;
 	struct request *req;
 	unsigned int request_count = 0;
 
@@ -1772,7 +1779,6 @@ get_rq:
 	 * but we need to set it earlier to expose the sync flag to the
 	 * rq allocator and io schedulers.
 	 */
-	rw_flags = bio_data_dir(bio);
 	if (sync)
 		rw_flags |= REQ_SYNC;
 
@@ -1780,7 +1786,7 @@ get_rq:
 	 * Grab a free request. This is might sleep but can not fail.
 	 * Returns with the queue unlocked.
 	 */
-	req = get_request(q, rw_flags, bio, GFP_NOIO);
+	req = get_request(q, bio_data_dir(bio), rw_flags, bio, GFP_NOIO);
 	if (IS_ERR(req)) {
 		bio->bi_error = PTR_ERR(req);
 		bio_endio(bio);
@@ -2168,7 +2174,7 @@ EXPORT_SYMBOL(submit_bio);
 static int blk_cloned_rq_check_limits(struct request_queue *q,
 				      struct request *rq)
 {
-	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->cmd_flags)) {
+	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->op)) {
 		printk(KERN_ERR "%s: over max size limit.\n", __func__);
 		return -EIO;
 	}
@@ -2987,6 +2993,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 {
 	/* tmp compat. Allow users to set bi_op or bi_rw */
 	rq->cmd_flags |= bio_data_dir(bio);
+	rq->op = bio->bi_op;
 
 	if (bio_has_data(bio))
 		rq->nr_phys_segments = bio_phys_segments(q, bio);
@@ -3071,6 +3078,7 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
 static void __blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
+	dst->op = src->op;
 	dst->cmd_flags |= (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index b05acca..e01d3ac 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -330,6 +330,7 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
 
 	flush_rq->cmd_type = REQ_TYPE_FS;
 	flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
+	flush_rq->op = REQ_OP_WRITE;
 	flush_rq->rq_disk = first_rq->rq_disk;
 	flush_rq->end_io = flush_end_io;
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index b66f095..de73ed1 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -628,7 +628,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (!rq_mergeable(req) || !rq_mergeable(next))
 		return 0;
 
-	if (!blk_check_merge_flags(req->cmd_flags, next->cmd_flags))
+	if (!blk_check_merge_flags(req->cmd_flags, req->op, next->cmd_flags,
+				   next->op))
 		return 0;
 
 	/*
@@ -642,7 +643,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	    || req_no_special_merge(next))
 		return 0;
 
-	if (req->cmd_flags & REQ_WRITE_SAME &&
+	if (req->op == REQ_OP_WRITE_SAME &&
 	    !blk_write_same_mergeable(req->bio, next->bio))
 		return 0;
 
@@ -730,7 +731,8 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!rq_mergeable(rq) || !bio_mergeable(bio))
 		return false;
 
-	if (!blk_check_merge_flags(rq->cmd_flags, bio->bi_rw))
+	if (!blk_check_merge_flags(rq->cmd_flags, rq->op, bio->bi_rw,
+				   bio->bi_op))
 		return false;
 
 	/* different data direction or already started, don't merge */
@@ -746,7 +748,7 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 		return false;
 
 	/* must be using the same buffer */
-	if (rq->cmd_flags & REQ_WRITE_SAME &&
+	if (rq->op == REQ_OP_WRITE_SAME &&
 	    !blk_write_same_mergeable(rq->bio, bio))
 		return false;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4c0622f..745dae8 100644
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
+	ctx->rq_dispatched[rw_is_sync(op, op_flags)]++;
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
@@ -1165,28 +1168,29 @@ static struct request *blk_mq_map_request(struct request_queue *q,
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
+	if (rw_is_sync(bio->bi_op, bio->bi_rw))
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
@@ -1240,7 +1244,7 @@ static int blk_mq_direct_issue_request(struct request *rq, blk_qc_t *cookie)
  */
 static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_sync = rw_is_sync(bio->bi_op, bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
 	struct blk_map_ctx data;
 	struct request *rq;
@@ -1337,7 +1341,7 @@ done:
  */
 static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_sync = rw_is_sync(bio->bi_op, bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
 	struct blk_plug *plug;
 	unsigned int request_count = 0;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f9093e..d300aa1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -660,9 +660,10 @@ static inline void cfqg_put(struct cfq_group *cfqg)
 } while (0)
 
 static inline void cfqg_stats_update_io_add(struct cfq_group *cfqg,
-					    struct cfq_group *curr_cfqg, int rw)
+					    struct cfq_group *curr_cfqg, int op,
+					    int op_flags)
 {
-	blkg_rwstat_add(&cfqg->stats.queued, rw, 1);
+	blkg_rwstat_add(&cfqg->stats.queued, op, op_flags, 1);
 	cfqg_stats_end_empty_time(&cfqg->stats);
 	cfqg_stats_set_start_group_wait_time(cfqg, curr_cfqg);
 }
@@ -676,26 +677,30 @@ static inline void cfqg_stats_update_timeslice_used(struct cfq_group *cfqg,
 #endif
 }
 
-static inline void cfqg_stats_update_io_remove(struct cfq_group *cfqg, int rw)
+static inline void cfqg_stats_update_io_remove(struct cfq_group *cfqg, int op,
+					       int op_flags)
 {
-	blkg_rwstat_add(&cfqg->stats.queued, rw, -1);
+	blkg_rwstat_add(&cfqg->stats.queued, op, op_flags, -1);
 }
 
-static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int rw)
+static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int op,
+					       int op_flags)
 {
-	blkg_rwstat_add(&cfqg->stats.merged, rw, 1);
+	blkg_rwstat_add(&cfqg->stats.merged, op, op_flags, 1);
 }
 
 static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
-			uint64_t start_time, uint64_t io_start_time, int rw)
+			uint64_t start_time, uint64_t io_start_time, int op,
+			int op_flags)
 {
 	struct cfqg_stats *stats = &cfqg->stats;
 	unsigned long long now = sched_clock();
 
 	if (time_after64(now, io_start_time))
-		blkg_rwstat_add(&stats->service_time, rw, now - io_start_time);
+		blkg_rwstat_add(&stats->service_time, op, op_flags,
+				now - io_start_time);
 	if (time_after64(io_start_time, start_time))
-		blkg_rwstat_add(&stats->wait_time, rw,
+		blkg_rwstat_add(&stats->wait_time, op, op_flags,
 				io_start_time - start_time);
 }
 
@@ -769,13 +774,16 @@ static inline void cfqg_put(struct cfq_group *cfqg) { }
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0)
 
 static inline void cfqg_stats_update_io_add(struct cfq_group *cfqg,
-			struct cfq_group *curr_cfqg, int rw) { }
+			struct cfq_group *curr_cfqg, int op, int op_flags) { }
 static inline void cfqg_stats_update_timeslice_used(struct cfq_group *cfqg,
 			unsigned long time, unsigned long unaccounted_time) { }
-static inline void cfqg_stats_update_io_remove(struct cfq_group *cfqg, int rw) { }
-static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int rw) { }
+static inline void cfqg_stats_update_io_remove(struct cfq_group *cfqg, int op,
+			int op_flags) { }
+static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int op,
+			int op_flags) { }
 static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
-			uint64_t start_time, uint64_t io_start_time, int rw) { }
+			uint64_t start_time, uint64_t io_start_time, int op,
+			int op_flags) { }
 
 #endif	/* CONFIG_CFQ_GROUP_IOSCHED */
 
@@ -2449,10 +2457,10 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 {
 	elv_rb_del(&cfqq->sort_list, rq);
 	cfqq->queued[rq_is_sync(rq)]--;
-	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->cmd_flags);
+	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->op, rq->cmd_flags);
 	cfq_add_rq_rb(rq);
 	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqq->cfqd->serving_group,
-				 rq->cmd_flags);
+				 rq->op, rq->cmd_flags);
 }
 
 static struct request *
@@ -2505,7 +2513,7 @@ static void cfq_remove_request(struct request *rq)
 	cfq_del_rq_rb(rq);
 
 	cfqq->cfqd->rq_queued--;
-	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->cmd_flags);
+	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->op, rq->cmd_flags);
 	if (rq->cmd_flags & REQ_PRIO) {
 		WARN_ON(!cfqq->prio_pending);
 		cfqq->prio_pending--;
@@ -2540,7 +2548,7 @@ static void cfq_merged_request(struct request_queue *q, struct request *req,
 static void cfq_bio_merged(struct request_queue *q, struct request *req,
 				struct bio *bio)
 {
-	cfqg_stats_update_io_merged(RQ_CFQG(req), bio->bi_rw);
+	cfqg_stats_update_io_merged(RQ_CFQG(req), bio->bi_op, bio->bi_rw);
 }
 
 static void
@@ -2563,7 +2571,7 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	if (cfqq->next_rq == next)
 		cfqq->next_rq = rq;
 	cfq_remove_request(next);
-	cfqg_stats_update_io_merged(RQ_CFQG(rq), next->cmd_flags);
+	cfqg_stats_update_io_merged(RQ_CFQG(rq), next->op, next->cmd_flags);
 
 	cfqq = RQ_CFQQ(next);
 	/*
@@ -4085,7 +4093,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	rq->fifo_time = jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)];
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
-	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group,
+	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group, rq->op,
 				 rq->cmd_flags);
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
@@ -4183,7 +4191,8 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	cfqq->dispatched--;
 	(RQ_CFQG(rq))->dispatched--;
 	cfqg_stats_update_completion(cfqq->cfqg, rq_start_time_ns(rq),
-				     rq_io_start_time_ns(rq), rq->cmd_flags);
+				     rq_io_start_time_ns(rq), rq->op,
+				     rq->cmd_flags);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
@@ -4262,7 +4271,7 @@ static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 	return ELV_MQUEUE_MAY;
 }
 
-static int cfq_may_queue(struct request_queue *q, int rw)
+static int cfq_may_queue(struct request_queue *q, int op, int op_flags)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct task_struct *tsk = current;
@@ -4279,7 +4288,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 	if (!cic)
 		return ELV_MQUEUE_MAY;
 
-	cfqq = cic_to_cfqq(cic, rw_is_sync(rw));
+	cfqq = cic_to_cfqq(cic, rw_is_sync(op, op_flags));
 	if (cfqq) {
 		cfq_init_prio_data(cfqq, cic);
 
diff --git a/block/elevator.c b/block/elevator.c
index c3555c9..f6279ca 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -366,8 +366,8 @@ void elv_dispatch_sort(struct request_queue *q, struct request *rq)
 	list_for_each_prev(entry, &q->queue_head) {
 		struct request *pos = list_entry_rq(entry);
 
-		if ((rq->cmd_flags & REQ_DISCARD) !=
-		    (pos->cmd_flags & REQ_DISCARD))
+		if ((rq->op == REQ_OP_DISCARD) !=
+		    (pos->op == REQ_OP_DISCARD))
 			break;
 		if (rq_data_dir(rq) != rq_data_dir(pos))
 			break;
@@ -717,12 +717,12 @@ void elv_put_request(struct request_queue *q, struct request *rq)
 		e->type->ops.elevator_put_req_fn(rq);
 }
 
-int elv_may_queue(struct request_queue *q, int rw)
+int elv_may_queue(struct request_queue *q, int op, int op_flags)
 {
 	struct elevator_queue *e = q->elevator;
 
 	if (e->type->ops.elevator_may_queue_fn)
-		return e->type->ops.elevator_may_queue_fn(q, rw);
+		return e->type->ops.elevator_may_queue_fn(q, op, op_flags);
 
 	return ELV_MQUEUE_MAY;
 }
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c02e669..9071feb 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -590,25 +590,26 @@ static inline void blkg_rwstat_exit(struct blkg_rwstat *rwstat)
 /**
  * blkg_rwstat_add - add a value to a blkg_rwstat
  * @rwstat: target blkg_rwstat
- * @rw: mask of REQ_{WRITE|SYNC}
+ * @op: REQ_OP
+ * @op_flags: rq_flag_bits
  * @val: value to add
  *
  * Add @val to @rwstat.  The counters are chosen according to @rw.  The
  * caller is responsible for synchronizing calls to this function.
  */
 static inline void blkg_rwstat_add(struct blkg_rwstat *rwstat,
-				   int rw, uint64_t val)
+				   int op, int op_flags, uint64_t val)
 {
 	struct percpu_counter *cnt;
 
-	if (rw & REQ_WRITE)
+	if (op_is_write(op))
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_WRITE];
 	else
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_READ];
 
 	__percpu_counter_add(cnt, val, BLKG_STAT_CPU_BATCH);
 
-	if (rw & REQ_SYNC)
+	if (op_flags & REQ_SYNC)
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_SYNC];
 	else
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_ASYNC];
@@ -713,9 +714,9 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 
 	if (!throtl) {
 		blkg = blkg ?: q->root_blkg;
-		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_rw,
+		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_op, bio->bi_rw,
 				bio->bi_iter.bi_size);
-		blkg_rwstat_add(&blkg->stat_ios, bio->bi_rw, 1);
+		blkg_rwstat_add(&blkg->stat_ios, bio->bi_op, bio->bi_rw, 1);
 	}
 
 	rcu_read_unlock();
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 35b9eb3..bc024c7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -596,7 +596,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-#define rq_data_dir(rq)		((int)((rq)->cmd_flags & 1))
+#define rq_data_dir(rq)		(op_is_write(rq->op) ? WRITE : READ)
 
 /*
  * Driver can handle struct request, if it either has an old style
@@ -615,14 +615,14 @@ static inline unsigned int blk_queue_cluster(struct request_queue *q)
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
+	return rw_is_sync(rq->op, rq->cmd_flags);
 }
 
 static inline bool blk_rl_full(struct request_list *rl, bool sync)
@@ -657,16 +657,16 @@ static inline bool rq_mergeable(struct request *rq)
 	return true;
 }
 
-static inline bool blk_check_merge_flags(unsigned int flags1,
-					 unsigned int flags2)
+static inline bool blk_check_merge_flags(unsigned int flags1, unsigned int op1,
+					 unsigned int flags2, unsigned int op2)
 {
-	if ((flags1 & REQ_DISCARD) != (flags2 & REQ_DISCARD))
+	if ((op1 == REQ_OP_DISCARD) != (op2 == REQ_OP_DISCARD))
 		return false;
 
 	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
 		return false;
 
-	if ((flags1 & REQ_WRITE_SAME) != (flags2 & REQ_WRITE_SAME))
+	if ((op1 == REQ_OP_WRITE_SAME) != (op2 == REQ_OP_WRITE_SAME))
 		return false;
 
 	return true;
@@ -864,12 +864,12 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 }
 
 static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
-						     unsigned int cmd_flags)
+						     int op)
 {
-	if (unlikely(cmd_flags & REQ_DISCARD))
+	if (unlikely(op == REQ_OP_DISCARD))
 		return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 
-	if (unlikely(cmd_flags & REQ_WRITE_SAME))
+	if (unlikely(op == REQ_OP_WRITE_SAME))
 		return q->limits.max_write_same_sectors;
 
 	return q->limits.max_sectors;
@@ -896,11 +896,11 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq)
 	if (unlikely(rq->cmd_type == REQ_TYPE_BLOCK_PC))
 		return q->limits.max_hw_sectors;
 
-	if (!q->limits.chunk_sectors || (rq->cmd_flags & REQ_DISCARD))
-		return blk_queue_get_max_sectors(q, rq->cmd_flags);
+	if (!q->limits.chunk_sectors || (rq->op == REQ_OP_DISCARD))
+		return blk_queue_get_max_sectors(q, rq->op);
 
 	return min(blk_max_size_offset(q, blk_rq_pos(rq)),
-			blk_queue_get_max_sectors(q, rq->cmd_flags));
+			blk_queue_get_max_sectors(q, rq->op));
 }
 
 static inline unsigned int blk_rq_count_bios(struct request *rq)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 638b324..953d286 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -26,7 +26,7 @@ typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
-typedef int (elevator_may_queue_fn) (struct request_queue *, int);
+typedef int (elevator_may_queue_fn) (struct request_queue *, int, int);
 
 typedef void (elevator_init_icq_fn) (struct io_cq *);
 typedef void (elevator_exit_icq_fn) (struct io_cq *);
@@ -134,7 +134,7 @@ extern struct request *elv_former_request(struct request_queue *, struct request
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
 extern void elv_unregister_queue(struct request_queue *q);
-extern int elv_may_queue(struct request_queue *, int);
+extern int elv_may_queue(struct request_queue *, int, int);
 extern void elv_completed_request(struct request_queue *, struct request *);
 extern int elv_set_request(struct request_queue *q, struct request *rq,
 			   struct bio *bio, gfp_t gfp_mask);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
