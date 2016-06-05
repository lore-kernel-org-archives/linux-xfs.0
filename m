Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7EDD17CD2
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:32:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 445468F8040
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:32:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l4bWHubsPAB5ZsEz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:32:54 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 09/45] block discard: use bio set op accessor
Date: Sun,  5 Jun 2016 14:31:49 -0500
Message-Id: <1465155145-10812-10-git-send-email-mchristi@redhat.com>
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

This converts the block issue discard helper and users to use
the bio_set_op_attrs accessor and only pass in the operation flags
like REQ_SEQURE.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-lib.c        | 13 +++++++------
 drivers/md/dm-thin.c   |  2 +-
 include/linux/blkdev.h |  3 ++-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index c614eaa..ff2a7f0 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -23,7 +23,8 @@ static struct bio *next_bio(struct bio *bio, unsigned int nr_pages,
 }
 
 int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, int type, struct bio **biop)
+		sector_t nr_sects, gfp_t gfp_mask, int op_flags,
+		struct bio **biop)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct bio *bio = *biop;
@@ -34,7 +35,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		return -ENXIO;
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
-	if ((type & REQ_SECURE) && !blk_queue_secdiscard(q))
+	if ((op_flags & REQ_SECURE) && !blk_queue_secdiscard(q))
 		return -EOPNOTSUPP;
 
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
@@ -65,7 +66,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		bio = next_bio(bio, 1, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_bdev = bdev;
-		bio->bi_rw = type;
+		bio_set_op_attrs(bio, REQ_OP_DISCARD, op_flags);
 
 		bio->bi_iter.bi_size = req_sects << 9;
 		nr_sects -= req_sects;
@@ -99,16 +100,16 @@ EXPORT_SYMBOL(__blkdev_issue_discard);
 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
 {
-	int type = REQ_WRITE | REQ_DISCARD;
+	int op_flags = 0;
 	struct bio *bio = NULL;
 	struct blk_plug plug;
 	int ret;
 
 	if (flags & BLKDEV_DISCARD_SECURE)
-		type |= REQ_SECURE;
+		op_flags |= REQ_SECURE;
 
 	blk_start_plug(&plug);
-	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, type,
+	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, op_flags,
 			&bio);
 	if (!ret && bio) {
 		ret = submit_bio_wait(bio);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 8c070ee..e8661c2 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -360,7 +360,7 @@ static int issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t da
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
 
 	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len,
-				      GFP_NOWAIT, REQ_WRITE | REQ_DISCARD, &op->bio);
+				      GFP_NOWAIT, 0, &op->bio);
 }
 
 static void end_discard(struct discard_op *op, int r)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 49c2dbc..8c78aca 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1149,7 +1149,8 @@ extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, int type, struct bio **biop);
+		sector_t nr_sects, gfp_t gfp_mask, int op_flags,
+		struct bio **biop);
 extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
