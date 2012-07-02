Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q62DKcAX223983 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 08:20:38 -0500
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
	[209.85.212.169]) by cuda.sgi.com with ESMTP id
	610vLj2gBcEq44iB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jul 2012 06:20:37 -0700 (PDT)
Received: by wibhm2 with SMTP id hm2so2854154wib.2
	for <xfs@oss.sgi.com>; Mon, 02 Jul 2012 06:20:36 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 3/3] block: split discard into aligned requests
Date: Mon,  2 Jul 2012 15:20:25 +0200
Message-Id: <1341235225-27551-4-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
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
Cc: axboe@kernel.dk, snitzer@redhat.com, martin.petersen@oracle.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de

When a disk has large discard_granularity and small max_discard_sectors,
discards are not split with optimal alignment.  In the limit case of
discard_granularity == max_discard_sectors, all requests might end up
with incorrect alignment, so that logical blocks are discarded at all.

Here is an example that shows the condition handled in the patch.
Suppose discard_granularity == 64, max_discard_sectors == 128,
discard_alignment == 0 (in sectors).  A request that is submitted for
256 sectors 2..257 will be split in two: 2..129, 130..257.  However,
only 2 aligned blocks out of 3 are included in the request; 128..191 may
be left intact and not discarded.  With this patch, the first request
will be truncated to ensure good alignment of what's left, and the split
will be 2..127, 128..255, 256..257.

At most one extra request will be introduced, because the first request
will be reduced by at most granularity-1 sectors, and granularity
must be less than max_discard_sectors.  Subsequent requests will run
on round_down(max_discard_sectors, granularity) sectors, as in the
current code.

The patch will also take into account the discard_alignment.

Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
        v1->v2: fixed line length

 block/blk-lib.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 16b06f6..b2bde5c 100644
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
+	alignment = (q->limits.discard_alignment >> 9) & mask;
 
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
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
