Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 705A97CA0
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 618D5304043
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DrHGMTgJEKumBkmt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:33:12 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 17/45] xfs: use bio op accessors
Date: Sun,  5 Jun 2016 14:31:57 -0500
Message-Id: <1465155145-10812-18-git-send-email-mchristi@redhat.com>
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

Separate the op from the rq_flag_bits and have xfs
set/get the bio using bio_set_op_attrs/bio_op.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---

v8:
1. Handled changes due to rebase and dropped signed offs due to
upstream changes since last review.

 fs/xfs/xfs_aops.c | 12 ++++--------
 fs/xfs/xfs_buf.c  | 26 ++++++++++++++------------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0cd1603..87d2b21 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -438,10 +438,8 @@ xfs_submit_ioend(
 
 	ioend->io_bio->bi_private = ioend;
 	ioend->io_bio->bi_end_io = xfs_end_bio;
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		ioend->io_bio->bi_rw = WRITE_SYNC;
-	else
-		ioend->io_bio->bi_rw = WRITE;
+	bio_set_op_attrs(ioend->io_bio, REQ_OP_WRITE,
+			 (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : 0);
 	/*
 	 * If we are failing the IO now, just mark the ioend with an
 	 * error and finish it. This will run IO completion immediately
@@ -512,10 +510,8 @@ xfs_chain_bio(
 
 	bio_chain(ioend->io_bio, new);
 	bio_get(ioend->io_bio);		/* for xfs_destroy_ioend */
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		ioend->io_bio->bi_rw = WRITE_SYNC;
-	else
-		ioend->io_bio->bi_rw = WRITE;
+	bio_set_op_attrs(ioend->io_bio, REQ_OP_WRITE,
+			  (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : 0);
 	submit_bio(ioend->io_bio);
 	ioend->io_bio = new;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0777c67..d8acd37 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1127,7 +1127,8 @@ xfs_buf_ioapply_map(
 	int		map,
 	int		*buf_offset,
 	int		*count,
-	int		rw)
+	int		op,
+	int		op_flags)
 {
 	int		page_index;
 	int		total_nr_pages = bp->b_page_count;
@@ -1166,7 +1167,7 @@ next_chunk:
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
-	bio->bi_rw = rw;
+	bio_set_op_attrs(bio, op, op_flags);
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
 		int	rbytes, nbytes = PAGE_SIZE - offset;
@@ -1210,7 +1211,8 @@ _xfs_buf_ioapply(
 	struct xfs_buf	*bp)
 {
 	struct blk_plug	plug;
-	int		rw;
+	int		op;
+	int		op_flags = 0;
 	int		offset;
 	int		size;
 	int		i;
@@ -1229,14 +1231,13 @@ _xfs_buf_ioapply(
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
@@ -1266,13 +1267,14 @@ _xfs_buf_ioapply(
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
@@ -1284,7 +1286,7 @@ _xfs_buf_ioapply(
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
