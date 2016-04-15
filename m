Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9046A7CED
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 14:16:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 631A5304032
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:16:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tPTESVd8HjP2WYty (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:16:52 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 13/42] xfs: set bi_op to REQ_OP
Date: Fri, 15 Apr 2016 14:15:48 -0500
Message-Id: <1460747777-8479-14-git-send-email-mchristi@redhat.com>
In-Reply-To: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
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

This patch has xfs use bio->bi_op for REQ_OPs and rq_flag_bits to bio->bi_rw.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Acked-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_aops.c |  3 +--
 fs/xfs/xfs_buf.c  | 27 +++++++++++++++------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5852c5a..6c20336 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -439,10 +439,9 @@ xfs_submit_ioend(
 
 	ioend->io_bio->bi_private = ioend;
 	ioend->io_bio->bi_end_io = xfs_end_bio;
+	ioend->io_bio->bi_op = REQ_OP_WRITE;
 	if (wbc->sync_mode)
 		ioend->io_bio->bi_rw = WRITE_SYNC;
-	else
-		ioend->io_bio->bi_rw = WRITE;
 	/*
 	 * If we are failing the IO now, just mark the ioend with an
 	 * error and finish it. This will run IO completion immediately
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 079bb77..917774e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1131,7 +1131,8 @@ xfs_buf_ioapply_map(
 	int		map,
 	int		*buf_offset,
 	int		*count,
-	int		rw)
+	int		op,
+	int		op_flags)
 {
 	int		page_index;
 	int		total_nr_pages = bp->b_page_count;
@@ -1170,7 +1171,8 @@ next_chunk:
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
+	bio->bi_rw = op_flags;
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
 		int	rbytes, nbytes = PAGE_SIZE - offset;
@@ -1214,7 +1216,8 @@ _xfs_buf_ioapply(
 	struct xfs_buf	*bp)
 {
 	struct blk_plug	plug;
-	int		rw;
+	int		op;
+	int		op_flags = 0;
 	int		offset;
 	int		size;
 	int		i;
@@ -1233,14 +1236,13 @@ _xfs_buf_ioapply(
 		bp->b_ioend_wq = bp->b_target->bt_mount->m_buf_workqueue;
 
 	if (bp->b_flags & XBF_WRITE) {
+		op = REQ_OP_WRITE;
 		if (bp->b_flags & XBF_SYNCIO)
-			rw = WRITE_SYNC;
-		else
-			rw = WRITE;
+			op_flags = WRITE_SYNC;
 		if (bp->b_flags & XBF_FUA)
-			rw |= REQ_FUA;
+			op_flags |= REQ_FUA;
 		if (bp->b_flags & XBF_FLUSH)
-			rw |= REQ_FLUSH;
+			op_flags |= REQ_FLUSH;
 
 		/*
 		 * Run the write verifier callback function if it exists. If
@@ -1270,13 +1272,14 @@ _xfs_buf_ioapply(
 			}
 		}
 	} else if (bp->b_flags & XBF_READ_AHEAD) {
-		rw = READA;
+		op = REQ_OP_READ;
+		op_flags = REQ_RAHEAD;
 	} else {
-		rw = READ;
+		op = REQ_OP_READ;
 	}
 
 	/* we only use the buffer cache for meta-data */
-	rw |= REQ_META;
+	op_flags |= REQ_META;
 
 	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
@@ -1288,7 +1291,7 @@ _xfs_buf_ioapply(
 	size = BBTOB(bp->b_io_length);
 	blk_start_plug(&plug);
 	for (i = 0; i < bp->b_map_count; i++) {
-		xfs_buf_ioapply_map(bp, i, &offset, &size, rw);
+		xfs_buf_ioapply_map(bp, i, &offset, &size, op, op_flags);
 		if (bp->b_error)
 			break;
 		if (size <= 0)
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
