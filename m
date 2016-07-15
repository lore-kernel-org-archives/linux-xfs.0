Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B21FA7CA7
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 13:35:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8624130405F
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 11:35:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Qu5HM0E1Lheo1dhB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2016 11:35:36 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 1BE417F41A
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 18:35:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-121.bos.redhat.com [10.18.41.121])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u6FIZZ39008270
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 14:35:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/2] xfs: exclude never-released buffers from buftarg I/O
	accounting
Date: Fri, 15 Jul 2016 14:35:33 -0400
Message-Id: <1468607734-3174-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1468607734-3174-1-git-send-email-bfoster@redhat.com>
References: <1468607734-3174-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/xfs_buf.c   |  3 ++-
 fs/xfs/xfs_buf.h   |  1 +
 fs/xfs/xfs_log.c   |  5 +++--
 fs/xfs/xfs_mount.c | 10 ++++++----
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4665ff6..12f7bec 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -815,7 +815,8 @@ xfs_buf_get_uncached(
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
-	bp = _xfs_buf_alloc(target, &map, 1, 0);
+	/* flags might contain irrelevant bits, pass only what we care about */
+	bp = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT);
 	if (unlikely(bp == NULL))
 		goto fail;
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8bfb974..e2108da 100644
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
index 63dad9e..3b74fa0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1415,7 +1415,7 @@ xlog_alloc_log(
 	 */
 	error = -ENOMEM;
 	bp = xfs_buf_alloc(mp->m_logdev_targp, XFS_BUF_DADDR_NULL,
-			   BTOBB(log->l_iclog_size), 0);
+			   BTOBB(log->l_iclog_size), XBF_NO_IOACCT);
 	if (!bp)
 		goto out_free_log;
 
@@ -1454,7 +1454,8 @@ xlog_alloc_log(
 		prev_iclog = iclog;
 
 		bp = xfs_buf_get_uncached(mp->m_logdev_targp,
-						BTOBB(log->l_iclog_size), 0);
+					  BTOBB(log->l_iclog_size),
+					  XBF_NO_IOACCT);
 		if (!bp)
 			goto out_free_iclog;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e39b023..970c19b 100644
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
 	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-				   BTOBB(sector_size), 0, &bp, buf_ops);
+				      BTOBB(sector_size), XBF_NO_IOACCT, &bp,
+				      buf_ops);
 	if (error) {
 		if (loud)
 			xfs_warn(mp, "SB validate failed with error %d.", error);
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
