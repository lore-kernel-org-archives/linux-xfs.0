Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE7F37CCF
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 05:41:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F3E9AC001
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 03:41:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d6jDUwFZZ60YWdSi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 03:41:01 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 24/42] xen: set bi_op to REQ_OP
Date: Fri, 15 Apr 2016 05:39:44 -0500
Message-Id: <1460716802-2294-25-git-send-email-mchristi@redhat.com>
In-Reply-To: <1460716802-2294-1-git-send-email-mchristi@redhat.com>
References: <1460716802-2294-1-git-send-email-mchristi@redhat.com>
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

This patch has the xen block driver use bio->bi_op for REQ_OPs and rq_flag_bits
to bio->bi_rw.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/block/xen-blkback/blkback.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 79fe493..854ecca 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -501,7 +501,7 @@ static int xen_vbd_translate(struct phys_req *req, struct xen_blkif *blkif,
 	struct xen_vbd *vbd = &blkif->vbd;
 	int rc = -EACCES;
 
-	if ((operation != READ) && vbd->readonly)
+	if ((operation != REQ_OP_READ) && vbd->readonly)
 		goto out;
 
 	if (likely(req->nr_sects)) {
@@ -1014,7 +1014,7 @@ static int dispatch_discard_io(struct xen_blkif_ring *ring,
 	preq.sector_number = req->u.discard.sector_number;
 	preq.nr_sects      = req->u.discard.nr_sectors;
 
-	err = xen_vbd_translate(&preq, blkif, WRITE);
+	err = xen_vbd_translate(&preq, blkif, REQ_OP_WRITE);
 	if (err) {
 		pr_warn("access denied: DISCARD [%llu->%llu] on dev=%04x\n",
 			preq.sector_number,
@@ -1229,6 +1229,7 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 	struct bio **biolist = pending_req->biolist;
 	int i, nbio = 0;
 	int operation;
+	int operation_flags = 0;
 	struct blk_plug plug;
 	bool drain = false;
 	struct grant_page **pages = pending_req->segments;
@@ -1247,17 +1248,19 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 	switch (req_operation) {
 	case BLKIF_OP_READ:
 		ring->st_rd_req++;
-		operation = READ;
+		operation = REQ_OP_READ;
 		break;
 	case BLKIF_OP_WRITE:
 		ring->st_wr_req++;
-		operation = WRITE_ODIRECT;
+		operation = REQ_OP_WRITE;
+		operation_flags = WRITE_ODIRECT;
 		break;
 	case BLKIF_OP_WRITE_BARRIER:
 		drain = true;
 	case BLKIF_OP_FLUSH_DISKCACHE:
 		ring->st_f_req++;
-		operation = WRITE_FLUSH;
+		operation = REQ_OP_WRITE;
+		operation_flags = WRITE_FLUSH;
 		break;
 	default:
 		operation = 0; /* make gcc happy */
@@ -1269,7 +1272,7 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 	nseg = req->operation == BLKIF_OP_INDIRECT ?
 	       req->u.indirect.nr_segments : req->u.rw.nr_segments;
 
-	if (unlikely(nseg == 0 && operation != WRITE_FLUSH) ||
+	if (unlikely(nseg == 0 && operation_flags != WRITE_FLUSH) ||
 	    unlikely((req->operation != BLKIF_OP_INDIRECT) &&
 		     (nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) ||
 	    unlikely((req->operation == BLKIF_OP_INDIRECT) &&
@@ -1310,7 +1313,7 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 
 	if (xen_vbd_translate(&preq, ring->blkif, operation) != 0) {
 		pr_debug("access denied: %s of [%llu,%llu] on dev=%04x\n",
-			 operation == READ ? "read" : "write",
+			 operation == REQ_OP_READ ? "read" : "write",
 			 preq.sector_number,
 			 preq.sector_number + preq.nr_sects,
 			 ring->blkif->vbd.pdevice);
@@ -1369,7 +1372,8 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 			bio->bi_private = pending_req;
 			bio->bi_end_io  = end_block_io_op;
 			bio->bi_iter.bi_sector  = preq.sector_number;
-			bio->bi_rw	= operation;
+			bio->bi_op	= operation;
+			bio->bi_rw	= operation_flags;
 		}
 
 		preq.sector_number += seg[i].nsec;
@@ -1377,7 +1381,7 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 
 	/* This will be hit if the operation was a flush or discard. */
 	if (!bio) {
-		BUG_ON(operation != WRITE_FLUSH);
+		BUG_ON(operation_flags != WRITE_FLUSH);
 
 		bio = bio_alloc(GFP_KERNEL, 0);
 		if (unlikely(bio == NULL))
@@ -1387,7 +1391,8 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 		bio->bi_bdev    = preq.bdev;
 		bio->bi_private = pending_req;
 		bio->bi_end_io  = end_block_io_op;
-		bio->bi_rw	= operation;
+		bio->bi_op	= operation;
+		bio->bi_rw	= operation_flags;
 	}
 
 	atomic_set(&pending_req->pendcnt, nbio);
@@ -1399,9 +1404,9 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 	/* Let the I/Os go.. */
 	blk_finish_plug(&plug);
 
-	if (operation == READ)
+	if (operation == REQ_OP_READ)
 		ring->st_rd_sect += preq.nr_sects;
-	else if (operation & WRITE)
+	else if (operation == REQ_OP_WRITE)
 		ring->st_wr_sect += preq.nr_sects;
 
 	return 0;
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
