Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9505629E2C
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 14:22:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 583E030405F
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5KxVKdixW0o18ofS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:12 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 13/35] xfs: set bi_op to REQ_OP
Date: Mon, 11 Jan 2016 14:21:11 -0600
Message-Id: <1452543693-4440-14-git-send-email-mchristi@redhat.com>
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

This patch has xfs set the bio bi_op to a REQ_OP, and
rq_flag_bits to bi_rw.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/xfs/xfs_aops.c |  3 ++-
 fs/xfs/xfs_buf.c  | 27 +++++++++++++++------------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5525a1b..25673e0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -382,7 +382,8 @@ xfs_submit_ioend_bio(
 	atomic_inc(&ioend->io_remaining);
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
-	bio->bi_rw = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
+	bio->bi_op = REQ_OP_WRITE;
+	bio->bi_rw = WB_SYNC_ALL ? WRITE_SYNC : 0;
 	submit_bio(bio);
 }
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9fd85d5..de35a3c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1124,7 +1124,8 @@ xfs_buf_ioapply_map(
 	int		map,
 	int		*buf_offset,
 	int		*count,
-	int		rw)
+	int		op,
+	int		op_flags)
 {
 	int		page_index;
 	int		total_nr_pages = bp->b_page_count;
@@ -1163,7 +1164,8 @@ next_chunk:
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
+	bio->bi_rw = op_flags;
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
 		int	rbytes, nbytes = PAGE_SIZE - offset;
@@ -1207,7 +1209,8 @@ _xfs_buf_ioapply(
 	struct xfs_buf	*bp)
 {
 	struct blk_plug	plug;
-	int		rw;
+	int		op;
+	int		op_flags = 0;
 	int		offset;
 	int		size;
 	int		i;
@@ -1226,14 +1229,13 @@ _xfs_buf_ioapply(
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
@@ -1263,13 +1265,14 @@ _xfs_buf_ioapply(
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
@@ -1281,7 +1284,7 @@ _xfs_buf_ioapply(
 	size = BBTOB(bp->b_io_length);
 	blk_start_plug(&plug);
 	for (i = 0; i < bp->b_map_count; i++) {
-		xfs_buf_ioapply_map(bp, i, &offset, &size, rw);
+		xfs_buf_ioapply_map(bp, i, &offset, &size, op, op_flags);
 		if (bp->b_error)
 			break;
 		if (size <= 0)
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
