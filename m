Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34733 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755182AbeEAPXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 11:23:17 -0400
Received: by mail-pf0-f180.google.com with SMTP id a14so9336744pfi.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 May 2018 08:23:17 -0700 (PDT)
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430213120.GD13766@dastard>
 <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
 <20180430222852.GF13766@dastard>
 <87589bc6-e5f5-6247-485f-2237e0c493ad@kernel.dk>
 <799de885-34f0-0cae-ae64-bf7bc194965d@kernel.dk>
 <20180430232319.GV23861@dastard>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bacc9dbb-c38b-9258-cd95-7582c27a97f7@kernel.dk>
Date: Tue, 1 May 2018 09:23:13 -0600
MIME-Version: 1.0
In-Reply-To: <20180430232319.GV23861@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On 4/30/18 5:23 PM, Dave Chinner wrote:
> On Mon, Apr 30, 2018 at 05:00:14PM -0600, Jens Axboe wrote:
>> On 4/30/18 4:40 PM, Jens Axboe wrote:
>>> On 4/30/18 4:28 PM, Dave Chinner wrote:
>>>> Yes, it does, but so would having the block layer to throttle device
>>>> discard requests in flight to a queue depth of 1. And then we don't
>>>> have to change XFS at all.
>>>
>>> I'm perfectly fine with making that change by default, and much easier
>>> for me since I don't have to patch file systems.
>>
>> Totally untested, but this should do the trick. It ensures we have
>> a QD of 1 (per caller), which should be sufficient.
>>
>> If people tune down the discard size, then you'll be blocking waiting
>> for discards on issue.
>>
>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>> index a676084d4740..0bf9befcc863 100644
>> --- a/block/blk-lib.c
>> +++ b/block/blk-lib.c
>> @@ -11,16 +11,19 @@
>>  #include "blk.h"
>>  
>>  static struct bio *next_bio(struct bio *bio, unsigned int nr_pages,
>> -		gfp_t gfp)
>> +			    gfp_t gfp)
>>  {
>> -	struct bio *new = bio_alloc(gfp, nr_pages);
>> -
>> +	/*
>> +	 * Devices suck at discard, so if we have to break up the bio
>> +	 * size due to the max discard size setting, wait for the
>> +	 * previous one to finish first.
>> +	 */
>>  	if (bio) {
>> -		bio_chain(bio, new);
>> -		submit_bio(bio);
>> +		submit_bio_wait(bio);
>> +		bio_put(bio);
>>  	}
> 
> This only addresses the case where __blkdev_issue_discard() breaks
> up a single large discard, right? It seems like a brute force
> solution, too, because it will do so even when the underlying device
> is idle and there's no need to throttle.

Right, the above would only break up a single discard, that's the
per-caller part.

> Shouldn't the throttling logic at least look at device congestion?
> i.e. if the device is not backlogged, then we should be able to
> issue the discard without problems. 
> 
> I ask this because this only addresses throttling the "discard large
> extent" case when the discard limit is set low. i.e. your exact
> problem case. We know that XFS can issue large numbers of
> discontiguous async discards in a single batch - this patch does not
> address that case and so it will still cause starvation problems.
> 
> If we look at device congestion in determining how to throttle/back
> off during discard issuing, then it doesn't matter what
> max_discard_sectors is set to - it will throttle in all situations
> that cause device overloads and starvations....

How about the below? It integrates it with the writeback throttling,
treating it like background writes. Totally untested. The benefit
of this is that it ties into that whole framework, and it's
per-device managed.

The blk-lib change is a separate patch, ensuring we break up discards
according to the user size. Will get broken up.


diff --git a/block/blk-lib.c b/block/blk-lib.c
index a676084d4740..7417d617091b 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -62,10 +62,11 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		unsigned int req_sects;
 		sector_t end_sect, tmp;
 
-		/* Make sure bi_size doesn't overflow */
-		req_sects = min_t(sector_t, nr_sects, UINT_MAX >> 9);
+		/* Issue in chunks of the user defined max discard setting */
+		req_sects = min_t(sector_t, nr_sects,
+					q->limits.max_discard_sectors);
 
-		/**
+		/*
 		 * If splitting a request, and the next starting sector would be
 		 * misaligned, stop the discard at the previous aligned sector.
 		 */
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
index f92fc84b5e2c..ba0c2825d382 100644
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
+		return &rwb->rq_wait[WBT_REQ_TRIM];
+	else if (is_kswapd)
+		return &rwb->rq_wait[WBT_REQ_KSWAPD];
+	else
+		return &rwb->rq_wait[WBT_REQ_BG];
 }
 
 static void rwb_wake_all(struct rq_wb *rwb)
@@ -120,13 +126,14 @@ static void rwb_wake_all(struct rq_wb *rwb)
 
 void __wbt_done(struct rq_wb *rwb, enum wbt_flags wb_acct)
 {
+	const bool is_trim = wb_acct & WBT_TRIM;
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
+		ret |= WBT_TRIM;
 
 	return ret | WBT_TRACKED;
 }
diff --git a/block/blk-wbt.h b/block/blk-wbt.h
index a232c98fbf4d..aec5bc82d580 100644
--- a/block/blk-wbt.h
+++ b/block/blk-wbt.h
@@ -14,12 +14,17 @@ enum wbt_flags {
 	WBT_TRACKED		= 1,	/* write, tracked for throttling */
 	WBT_READ		= 2,	/* read */
 	WBT_KSWAPD		= 4,	/* write, from kswapd */
+	WBT_TRIM		= 8,
 
-	WBT_NR_BITS		= 3,	/* number of bits */
+	WBT_NR_BITS		= 4,	/* number of bits */
 };
 
 enum {
-	WBT_NUM_RWQ		= 2,
+	WBT_REQ_BG = 0,
+	WBT_REQ_KSWAPD,
+	WBT_REQ_TRIM,
+
+	WBT_NUM_RWQ,
 };
 
 /*

-- 
Jens Axboe

