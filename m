Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q65G2JA1078023 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 11:02:19 -0500
Received: from mail-gg0-f181.google.com (mail-gg0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	k5wHH49tNChr2Diq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Jul 2012 09:02:18 -0700 (PDT)
Received: by ggnv5 with SMTP id v5so9868791ggn.26
	for <xfs@oss.sgi.com>; Thu, 05 Jul 2012 09:02:17 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 2/2] block: split discard into aligned requests
Date: Thu,  5 Jul 2012 18:01:44 +0200
Message-Id: <1341504104-1674-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1341504104-1674-1-git-send-email-pbonzini@redhat.com>
References: <1341504104-1674-1-git-send-email-pbonzini@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, snitzer@redhat.com, martin.petersen@oracle.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de, vgoyal@redhat.com

When a disk has large discard_granularity and small max_discard_sectors,
discards are not split with optimal alignment.  In the limit case of
discard_granularity == max_discard_sectors, no request could be aligned
correctly, so in fact you might end up with no discarded logical blocks
at all.

Another example that helps showing the condition in the patch is with
discard_granularity == 64, max_discard_sectors == 128.  A request that is
submitted for 256 sectors 2..257 will be split in two: 2..129, 130..257.
However, only 2 aligned blocks out of 3 are included in the request;
128..191 may be left intact and not discarded.  With this patch, the
first request will be truncated to ensure good alignment of what's left,
and the split will be 2..127, 128..255, 256..257.  The patch will also
take into account the discard_alignment.

At most one extra request will be introduced, because the first request
will be reduced by at most granularity-1 sectors, and granularity
must be less than max_discard_sectors.  Subsequent requests will run
on round_down(max_discard_sectors, granularity) sectors, as in the
current code.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
        v2->v3: take into account partition alignment (Vivek)

 block/blk-lib.c        |   34 ++++++++++++++++++++++++----------
 include/linux/blkdev.h |   10 ++++++++++
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 16b06f6..19cc761 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -44,7 +44,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
 	unsigned int max_discard_sectors;
-	unsigned int granularity;
+	unsigned int granularity, alignment, mask;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
@@ -57,10 +57,12 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
+	mask = granularity - 1;
+	alignment = (bdev_discard_alignment(bdev) >> 9) & mask;
 
 	/*
 	 * Ensure that max_discard_sectors is of the proper
-	 * granularity
+	 * granularity, so that requests stay aligned after a split.
 	 */
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 	max_discard_sectors = round_down(max_discard_sectors, granularity);
@@ -80,25 +82,37 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	bb.wait = &wait;
 
 	while (nr_sects) {
+		unsigned int req_sects;
+		sector_t end_sect;
+
 		bio = bio_alloc(gfp_mask, 1);
 		if (!bio) {
 			ret = -ENOMEM;
 			break;
 		}
 
+		req_sects = min_t(sector_t, nr_sects, max_discard_sectors);
+
+		/*
+		 * If splitting a request, and the next starting sector would be
+		 * misaligned, stop the discard at the previous aligned sector.
+		 */
+		end_sect = sector + req_sects;
+		if (req_sects < nr_sects && (end_sect & mask) != alignment) {
+			end_sect =
+				round_down(end_sect - alignment, granularity)
+				+ alignment;
+			req_sects = end_sect - sector;
+		}
+
 		bio->bi_sector = sector;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
 		bio->bi_private = &bb;
 
-		if (nr_sects > max_discard_sectors) {
-			bio->bi_size = max_discard_sectors << 9;
-			nr_sects -= max_discard_sectors;
-			sector += max_discard_sectors;
-		} else {
-			bio->bi_size = nr_sects << 9;
-			nr_sects = 0;
-		}
+		bio->bi_size = req_sects << 9;
+		nr_sects -= req_sects;
+		sector = end_sect;
 
 		atomic_inc(&bb.done);
 		submit_bio(type, bio);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba43f40..218de98 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1125,6 +1125,16 @@ static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector
 		& (lim->discard_granularity - 1);
 }
 
+static inline int bdev_discard_alignment(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (bdev != bdev->bd_contains)
+		return bdev->bd_part->discard_alignment;
+
+	return q->limits.discard_alignment;
+}
+
 static inline unsigned int queue_discard_zeroes_data(struct request_queue *q)
 {
 	if (q->limits.max_discard_sectors && q->limits.discard_zeroes_data == 1)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
