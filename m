Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B3DA7D2F
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4F96AC003
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D342CXBqD5J0BjyM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:33:44 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 31/45] block: prepare request creation/destruction code to use
	REQ_OPs
Date: Sun,  5 Jun 2016 14:32:11 -0500
Message-Id: <1465155145-10812-32-git-send-email-mchristi@redhat.com>
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

This patch prepares *_get_request/*_put_request and freed_request,
to use separate variables for the operation and flags. In the
next patches the struct request users will be converted like
was done for bios where the op and flags are set separately.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-core.c | 54 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3c45254..a68dc07 100644
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
+	int sync = rw_is_sync(op | flags);
 
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
+	const bool is_sync = rw_is_sync(op | op_flags) != 0;
 	int may_queue;
 
 	if (unlikely(blk_queue_dying(q)))
 		return ERR_PTR(-ENODEV);
 
-	may_queue = elv_may_queue(q, rw_flags);
+	may_queue = elv_may_queue(q, op | op_flags);
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
@@ -1149,10 +1151,10 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 
 	blk_rq_init(q, rq);
 	blk_rq_set_rl(rq, rl);
-	rq->cmd_flags = rw_flags | REQ_ALLOCED;
+	req_set_op_attrs(rq, op, op_flags | REQ_ALLOCED);
 
 	/* init elvpriv */
-	if (rw_flags & REQ_ELVPRIV) {
+	if (op_flags & REQ_ELVPRIV) {
 		if (unlikely(et->icq_cache && !icq)) {
 			if (ioc)
 				icq = ioc_create_icq(ioc, q, gfp_mask);
@@ -1178,7 +1180,7 @@ out:
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 
-	trace_block_getrq(q, bio, rw_flags & 1);
+	trace_block_getrq(q, bio, op);
 	return rq;
 
 fail_elvpriv:
@@ -1208,7 +1210,7 @@ fail_alloc:
 	 * queue, but this is pretty rare.
 	 */
 	spin_lock_irq(q->queue_lock);
-	freed_request(rl, rw_flags);
+	freed_request(rl, op, op_flags);
 
 	/*
 	 * in the very unlikely event that allocation failed and no
@@ -1226,7 +1228,8 @@ rq_starved:
 /**
  * get_request - get a free request
  * @q: request_queue to allocate request from
- * @rw_flags: RW and SYNC flags
+ * @op: REQ_OP_READ/REQ_OP_WRITE
+ * @op_flags: rq_flag_bits
  * @bio: bio to allocate request for (can be %NULL)
  * @gfp_mask: allocation mask
  *
@@ -1237,17 +1240,18 @@ rq_starved:
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
+	const bool is_sync = rw_is_sync(op | op_flags) != 0;
 	DEFINE_WAIT(wait);
 	struct request_list *rl;
 	struct request *rq;
 
 	rl = blk_get_rl(q, bio);	/* transferred to @rq on success */
 retry:
-	rq = __get_request(rl, rw_flags, bio, gfp_mask);
+	rq = __get_request(rl, op, op_flags, bio, gfp_mask);
 	if (!IS_ERR(rq))
 		return rq;
 
@@ -1260,7 +1264,7 @@ retry:
 	prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
 				  TASK_UNINTERRUPTIBLE);
 
-	trace_block_sleeprq(q, bio, rw_flags & 1);
+	trace_block_sleeprq(q, bio, op);
 
 	spin_unlock_irq(q->queue_lock);
 	io_schedule();
@@ -1289,7 +1293,7 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 	create_io_context(gfp_mask, q->node);
 
 	spin_lock_irq(q->queue_lock);
-	rq = get_request(q, rw, NULL, gfp_mask);
+	rq = get_request(q, rw, 0, NULL, gfp_mask);
 	if (IS_ERR(rq))
 		spin_unlock_irq(q->queue_lock);
 	/* q->queue_lock is unlocked at this point */
@@ -1491,13 +1495,14 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	 */
 	if (req->cmd_flags & REQ_ALLOCED) {
 		unsigned int flags = req->cmd_flags;
+		int op = req_op(req);
 		struct request_list *rl = blk_rq_rl(req);
 
 		BUG_ON(!list_empty(&req->queuelist));
 		BUG_ON(ELV_ON_HASH(req));
 
 		blk_free_request(rl, req);
-		freed_request(rl, flags);
+		freed_request(rl, op, flags);
 		blk_put_rl(rl);
 	}
 }
@@ -1712,7 +1717,7 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	struct blk_plug *plug;
-	int el_ret, rw_flags, where = ELEVATOR_INSERT_SORT;
+	int el_ret, rw_flags = 0, where = ELEVATOR_INSERT_SORT;
 	struct request *req;
 	unsigned int request_count = 0;
 
@@ -1772,7 +1777,6 @@ get_rq:
 	 * but we need to set it earlier to expose the sync flag to the
 	 * rq allocator and io schedulers.
 	 */
-	rw_flags = bio_data_dir(bio);
 	if (sync)
 		rw_flags |= REQ_SYNC;
 
@@ -1780,7 +1784,7 @@ get_rq:
 	 * Grab a free request. This is might sleep but can not fail.
 	 * Returns with the queue unlocked.
 	 */
-	req = get_request(q, rw_flags, bio, GFP_NOIO);
+	req = get_request(q, bio_data_dir(bio), rw_flags, bio, GFP_NOIO);
 	if (IS_ERR(req)) {
 		bio->bi_error = PTR_ERR(req);
 		bio_endio(bio);
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
