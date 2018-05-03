Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36267 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbeECPUw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 11:20:52 -0400
Received: by mail-io0-f194.google.com with SMTP id d73-v6so22090097iog.3
        for <linux-xfs@vger.kernel.org>; Thu, 03 May 2018 08:20:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] blk-wbt: throttle discards like background writes
Date: Thu,  3 May 2018 09:20:43 -0600
Message-Id: <1525360843-6504-4-git-send-email-axboe@kernel.dk>
In-Reply-To: <1525360843-6504-1-git-send-email-axboe@kernel.dk>
References: <1525360843-6504-1-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: dchinner@redhat.com, hch@lst.de, Jens Axboe <axboe@kernel.dk>

Throttle discards like we would any background write. Discards should
be background activity, so if they are impacting foreground IO, then
we will throttle them down.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-stat.h |  6 +++---
 block/blk-wbt.c  | 52 ++++++++++++++++++++++++++++++++++------------------
 block/blk-wbt.h  |  9 +++++++--
 3 files changed, 44 insertions(+), 23 deletions(-)

diff --git a/block/blk-stat.h b/block/blk-stat.h
index 2dd36347252a..c22049a8125e 100644
--- a/block/blk-stat.h
+++ b/block/blk-stat.h
@@ -10,11 +10,11 @@
 
 /*
  * from upper:
- * 3 bits: reserved for other usage
+ * 4 bits: reserved for other usage
  * 12 bits: size
- * 49 bits: time
+ * 48 bits: time
  */
-#define BLK_STAT_RES_BITS	3
+#define BLK_STAT_RES_BITS	4
 #define BLK_STAT_SIZE_BITS	12
 #define BLK_STAT_RES_SHIFT	(64 - BLK_STAT_RES_BITS)
 #define BLK_STAT_SIZE_SHIFT	(BLK_STAT_RES_SHIFT - BLK_STAT_SIZE_BITS)
diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 3e34b41bcefc..4d222100746c 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -101,9 +101,15 @@ static bool wb_recent_wait(struct rq_wb *rwb)
 	return time_before(jiffies, wb->dirty_sleep + HZ);
 }
 
-static inline struct rq_wait *get_rq_wait(struct rq_wb *rwb, bool is_kswapd)
+static inline struct rq_wait *get_rq_wait(struct rq_wb *rwb, bool is_trim,
+					  bool is_kswapd)
 {
-	return &rwb->rq_wait[is_kswapd];
+	if (is_trim)
+		return &rwb->rq_wait[WBT_REQ_DISCARD];
+	else if (is_kswapd)
+		return &rwb->rq_wait[WBT_REQ_KSWAPD];
+	else
+		return &rwb->rq_wait[WBT_REQ_BG];
 }
 
 static void rwb_wake_all(struct rq_wb *rwb)
@@ -120,13 +126,14 @@ static void rwb_wake_all(struct rq_wb *rwb)
 
 void __wbt_done(struct rq_wb *rwb, enum wbt_flags wb_acct)
 {
+	const bool is_trim = wb_acct & WBT_DISCARD;
 	struct rq_wait *rqw;
 	int inflight, limit;
 
 	if (!(wb_acct & WBT_TRACKED))
 		return;
 
-	rqw = get_rq_wait(rwb, wb_acct & WBT_KSWAPD);
+	rqw = get_rq_wait(rwb, is_trim, wb_acct & WBT_KSWAPD);
 	inflight = atomic_dec_return(&rqw->inflight);
 
 	/*
@@ -139,10 +146,13 @@ void __wbt_done(struct rq_wb *rwb, enum wbt_flags wb_acct)
 	}
 
 	/*
-	 * If the device does write back caching, drop further down
-	 * before we wake people up.
+	 * For discards, our limit is always the background. For writes, if
+	 * the device does write back caching, drop further down before we
+	 * wake people up.
 	 */
-	if (rwb->wc && !wb_recent_wait(rwb))
+	if (is_trim)
+		limit = rwb->wb_background;
+	else if (rwb->wc && !wb_recent_wait(rwb))
 		limit = 0;
 	else
 		limit = rwb->wb_normal;
@@ -479,6 +489,9 @@ static inline unsigned int get_limit(struct rq_wb *rwb, unsigned long rw)
 {
 	unsigned int limit;
 
+	if ((rw & REQ_OP_MASK) == REQ_OP_DISCARD)
+		return rwb->wb_background;
+
 	/*
 	 * At this point we know it's a buffered write. If this is
 	 * kswapd trying to free memory, or REQ_SYNC is set, then
@@ -533,7 +546,8 @@ static void __wbt_wait(struct rq_wb *rwb, unsigned long rw, spinlock_t *lock)
 	__releases(lock)
 	__acquires(lock)
 {
-	struct rq_wait *rqw = get_rq_wait(rwb, current_is_kswapd());
+	const bool is_trim = (rw & REQ_OP_MASK) == REQ_OP_DISCARD;
+	struct rq_wait *rqw = get_rq_wait(rwb, is_trim, current_is_kswapd());
 	DEFINE_WAIT(wait);
 
 	if (may_queue(rwb, rqw, &wait, rw))
@@ -561,19 +575,19 @@ static inline bool wbt_should_throttle(struct rq_wb *rwb, struct bio *bio)
 {
 	const int op = bio_op(bio);
 
-	/*
-	 * If not a WRITE, do nothing
-	 */
-	if (op != REQ_OP_WRITE)
-		return false;
+	if (op == REQ_OP_WRITE) {
+		/*
+		 * Don't throttle WRITE_ODIRECT
+		 */
+		if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) ==
+		    (REQ_SYNC | REQ_IDLE))
+			return false;
 
-	/*
-	 * Don't throttle WRITE_ODIRECT
-	 */
-	if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) == (REQ_SYNC | REQ_IDLE))
-		return false;
+		return true;
+	} else if (op == REQ_OP_DISCARD)
+		return true;
 
-	return true;
+	return false;
 }
 
 /*
@@ -605,6 +619,8 @@ enum wbt_flags wbt_wait(struct rq_wb *rwb, struct bio *bio, spinlock_t *lock)
 
 	if (current_is_kswapd())
 		ret |= WBT_KSWAPD;
+	if (bio_op(bio) == REQ_OP_DISCARD)
+		ret |= WBT_DISCARD;
 
 	return ret | WBT_TRACKED;
 }
diff --git a/block/blk-wbt.h b/block/blk-wbt.h
index a232c98fbf4d..af451876ea31 100644
--- a/block/blk-wbt.h
+++ b/block/blk-wbt.h
@@ -14,12 +14,17 @@ enum wbt_flags {
 	WBT_TRACKED		= 1,	/* write, tracked for throttling */
 	WBT_READ		= 2,	/* read */
 	WBT_KSWAPD		= 4,	/* write, from kswapd */
+	WBT_DISCARD		= 8,
 
-	WBT_NR_BITS		= 3,	/* number of bits */
+	WBT_NR_BITS		= 4,	/* number of bits */
 };
 
 enum {
-	WBT_NUM_RWQ		= 2,
+	WBT_REQ_BG = 0,
+	WBT_REQ_KSWAPD,
+	WBT_REQ_DISCARD,
+
+	WBT_NUM_RWQ,
 };
 
 /*
-- 
2.7.4

