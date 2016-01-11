Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F6C029E59
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 14:22:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64A018F804B
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JelTrIsx9PLdhSg2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:37 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 24/35] xen: set bi_op to REQ_OP
Date: Mon, 11 Jan 2016 14:21:22 -0600
Message-Id: <1452543693-4440-25-git-send-email-mchristi@redhat.com>
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

This patch has xen set the bio bi_op to a REQ_OP, and rq_flag_bits
to bi_rw.

This patch is compile tested only.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/xen-blkback/blkback.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 733d397..f977d29 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -488,7 +488,7 @@ static int xen_vbd_translate(struct phys_req *req, struct xen_blkif *blkif,
 	struct xen_vbd *vbd = &blkif->vbd;
 	int rc = -EACCES;
 
-	if ((operation != READ) && vbd->readonly)
+	if ((operation != REQ_OP_READ) && vbd->readonly)
 		goto out;
 
 	if (likely(req->nr_sects)) {
@@ -995,7 +995,7 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	preq.sector_number = req->u.discard.sector_number;
 	preq.nr_sects      = req->u.discard.nr_sectors;
 
-	err = xen_vbd_translate(&preq, blkif, WRITE);
+	err = xen_vbd_translate(&preq, blkif, REQ_OP_WRITE);
 	if (err) {
 		pr_warn("access denied: DISCARD [%llu->%llu] on dev=%04x\n",
 			preq.sector_number,
@@ -1208,6 +1208,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	struct bio **biolist = pending_req->biolist;
 	int i, nbio = 0;
 	int operation;
+	int operation_flags = 0;
 	struct blk_plug plug;
 	bool drain = false;
 	struct grant_page **pages = pending_req->segments;
@@ -1226,17 +1227,19 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	switch (req_operation) {
 	case BLKIF_OP_READ:
 		blkif->st_rd_req++;
-		operation = READ;
+		operation = REQ_OP_READ;
 		break;
 	case BLKIF_OP_WRITE:
 		blkif->st_wr_req++;
-		operation = WRITE_ODIRECT;
+		operation = REQ_OP_WRITE;
+		operation_flags = WRITE_ODIRECT;
 		break;
 	case BLKIF_OP_WRITE_BARRIER:
 		drain = true;
 	case BLKIF_OP_FLUSH_DISKCACHE:
 		blkif->st_f_req++;
-		operation = WRITE_FLUSH;
+		operation = REQ_OP_WRITE;
+		operation_flags = WRITE_FLUSH;
 		break;
 	default:
 		operation = 0; /* make gcc happy */
@@ -1248,7 +1251,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	nseg = req->operation == BLKIF_OP_INDIRECT ?
 	       req->u.indirect.nr_segments : req->u.rw.nr_segments;
 
-	if (unlikely(nseg == 0 && operation != WRITE_FLUSH) ||
+	if (unlikely(nseg == 0 && operation_flags != WRITE_FLUSH) ||
 	    unlikely((req->operation != BLKIF_OP_INDIRECT) &&
 		     (nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) ||
 	    unlikely((req->operation == BLKIF_OP_INDIRECT) &&
@@ -1289,7 +1292,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
 	if (xen_vbd_translate(&preq, blkif, operation) != 0) {
 		pr_debug("access denied: %s of [%llu,%llu] on dev=%04x\n",
-			 operation == READ ? "read" : "write",
+			 operation == REQ_OP_READ ? "read" : "write",
 			 preq.sector_number,
 			 preq.sector_number + preq.nr_sects,
 			 blkif->vbd.pdevice);
@@ -1348,7 +1351,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 			bio->bi_private = pending_req;
 			bio->bi_end_io  = end_block_io_op;
 			bio->bi_iter.bi_sector  = preq.sector_number;
-			bio->bi_rw	= operation;
+			bio->bi_op	= operation;
+			bio->bi_rw	= operation_flags;
 		}
 
 		preq.sector_number += seg[i].nsec;
@@ -1356,7 +1360,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
 	/* This will be hit if the operation was a flush or discard. */
 	if (!bio) {
-		BUG_ON(operation != WRITE_FLUSH);
+		BUG_ON(operation_flags != WRITE_FLUSH);
 
 		bio = bio_alloc(GFP_KERNEL, 0);
 		if (unlikely(bio == NULL))
@@ -1366,7 +1370,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		bio->bi_bdev    = preq.bdev;
 		bio->bi_private = pending_req;
 		bio->bi_end_io  = end_block_io_op;
-		bio->bi_rw	= operation;
+		bio->bi_op	= operation;
+		bio->bi_rw	= operation_flags;
 	}
 
 	atomic_set(&pending_req->pendcnt, nbio);
@@ -1378,9 +1383,9 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	/* Let the I/Os go.. */
 	blk_finish_plug(&plug);
 
-	if (operation == READ)
+	if (operation == REQ_OP_READ)
 		blkif->st_rd_sect += preq.nr_sects;
-	else if (operation & WRITE)
+	else if (operation == REQ_OP_WRITE)
 		blkif->st_wr_sect += preq.nr_sects;
 
 	return 0;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
