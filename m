Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 35E677D5A
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:37:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0ACE0304053
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:37:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mEagTKbFZL5F52yW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:37:44 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 30/42] blkg_rwstat: separate op from flags
Date: Wed, 13 Apr 2016 14:36:16 -0500
Message-Id: <1460576188-5751-31-git-send-email-mchristi@redhat.com>
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

The bio and request operation and flags are going to be separate definitions,
so we cannot pass them in as a bitmap. This patch converts the blkg_rwstat
code and its caller, cfq, to pass in the values separately.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/cfq-iosched.c        | 49 +++++++++++++++++++++++++++-------------------
 include/linux/blk-cgroup.h | 13 ++++++------
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3fcc598..0dfa2dd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -667,9 +667,10 @@ static inline void cfqg_put(struct cfq_group *cfqg)
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
@@ -683,26 +684,30 @@ static inline void cfqg_stats_update_timeslice_used(struct cfq_group *cfqg,
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
 
@@ -781,13 +786,16 @@ static inline void cfqg_put(struct cfq_group *cfqg) { }
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
 
@@ -2461,10 +2469,10 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
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
@@ -2517,7 +2525,7 @@ static void cfq_remove_request(struct request *rq)
 	cfq_del_rq_rb(rq);
 
 	cfqq->cfqd->rq_queued--;
-	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->cmd_flags);
+	cfqg_stats_update_io_remove(RQ_CFQG(rq), rq->op, rq->cmd_flags);
 	if (rq->cmd_flags & REQ_PRIO) {
 		WARN_ON(!cfqq->prio_pending);
 		cfqq->prio_pending--;
@@ -2552,7 +2560,7 @@ static void cfq_merged_request(struct request_queue *q, struct request *req,
 static void cfq_bio_merged(struct request_queue *q, struct request *req,
 				struct bio *bio)
 {
-	cfqg_stats_update_io_merged(RQ_CFQG(req), bio->bi_rw);
+	cfqg_stats_update_io_merged(RQ_CFQG(req), bio->bi_op, bio->bi_rw);
 }
 
 static void
@@ -2575,7 +2583,7 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	if (cfqq->next_rq == next)
 		cfqq->next_rq = rq;
 	cfq_remove_request(next);
-	cfqg_stats_update_io_merged(RQ_CFQG(rq), next->cmd_flags);
+	cfqg_stats_update_io_merged(RQ_CFQG(rq), next->op, next->cmd_flags);
 
 	cfqq = RQ_CFQQ(next);
 	/*
@@ -4108,7 +4116,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	rq->fifo_time = jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)];
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
-	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group,
+	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group, rq->op,
 				 rq->cmd_flags);
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
@@ -4206,7 +4214,8 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	cfqq->dispatched--;
 	(RQ_CFQG(rq))->dispatched--;
 	cfqg_stats_update_completion(cfqq->cfqg, rq_start_time_ns(rq),
-				     rq_io_start_time_ns(rq), rq->cmd_flags);
+				     rq_io_start_time_ns(rq), rq->op,
+				     rq->cmd_flags);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
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
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
