Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04E2C7CB0
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 11:16:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BAE99304043
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 09:16:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IRlvRDnMSlzJdIiw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2016 09:16:37 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id F0A593E50E4
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 16:16:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-134.bos.redhat.com [10.18.41.134])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u6DGGaRn028695
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 12:16:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/3] xfs: exclude never-released buffers from buftarg I/O
	accounting
Date: Wed, 13 Jul 2016 12:16:34 -0400
Message-Id: <1468426595-35032-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1468426595-35032-1-git-send-email-bfoster@redhat.com>
References: <1468426595-35032-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

The upcoming buftarg I/O accounting mechanism maintains a count of all
buffers that have undergone I/O in the current hold-release cycle.
Certain buffers associated with core infrastructure (e.g., the xfs_mount
superblock buffer, log buffers) are never released, however. This means
that accounting I/O submission on such buffers elevates the buftarg
count indefinitely and could lead to lockup on unmount.

Define a new buffer flag to explicitly exclude buffers from buftarg I/O
accounting. Set the flag on the superblock and associated log buffers.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.h   |  1 +
 fs/xfs/xfs_log.c   |  4 +++-
 fs/xfs/xfs_mount.c | 12 +++++++-----
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index a3c7ba4..9e1cca7 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -43,6 +43,7 @@ typedef enum {
 #define XBF_READ	 (1 << 0) /* buffer intended for reading from device */
 #define XBF_WRITE	 (1 << 1) /* buffer intended for writing to device */
 #define XBF_READ_AHEAD	 (1 << 2) /* asynchronous read-ahead */
+#define XBF_NO_IOACCT	 (1 << 3) /* bypass I/O accounting (non-LRU bufs) */
 #define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
 #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 63dad9e..4af0fb0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1427,7 +1427,8 @@ xlog_alloc_log(
 	ASSERT(xfs_buf_islocked(bp));
 	xfs_buf_unlock(bp);
 
-	/* use high priority wq for log I/O completion */
+	/* disable accounting and use high priority wq for log I/O completion */
+	bp->b_flags |= XBF_NO_IOACCT;
 	bp->b_ioend_wq = mp->m_log_workqueue;
 	bp->b_iodone = xlog_iodone;
 	log->l_xbuf = bp;
@@ -1457,6 +1458,7 @@ xlog_alloc_log(
 						BTOBB(log->l_iclog_size), 0);
 		if (!bp)
 			goto out_free_iclog;
+		bp->b_flags |= XBF_NO_IOACCT;
 
 		ASSERT(xfs_buf_islocked(bp));
 		xfs_buf_unlock(bp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e39b023..a9234a2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -272,13 +272,15 @@ xfs_readsb(
 	buf_ops = NULL;
 
 	/*
-	 * Allocate a (locked) buffer to hold the superblock.
-	 * This will be kept around at all times to optimize
-	 * access to the superblock.
+	 * Allocate a (locked) buffer to hold the superblock. This will be kept
+	 * around at all times to optimize access to the superblock. Therefore,
+	 * set XBF_NO_IOACCT to make sure it doesn't hold the buftarg count
+	 * elevated.
 	 */
 reread:
-	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-				   BTOBB(sector_size), 0, &bp, buf_ops);
+	error = xfs_buf_read_uncached_flags(mp->m_ddev_targp, XFS_SB_DADDR,
+					    BTOBB(sector_size), 0, &bp, buf_ops,
+					    XBF_NO_IOACCT);
 	if (error) {
 		if (loud)
 			xfs_warn(mp, "SB validate failed with error %d.", error);
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
