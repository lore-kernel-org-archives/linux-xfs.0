Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6lXB160012 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8518015ECE3A
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	S3CbDUOQB4WuZUVv for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:46 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPt-00042d-Nx
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:45 +0000
Message-Id: <20110707110645.707700878@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:06:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 26/28] xfs: return the buffer locked from xfs_buf_get_uncached
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-buf_get_uncached-locked-buffer
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
To: xfs@oss.sgi.com

All other xfs_buf_get/read-like helpers return the buffer locked, make sure
xfs_buf_get_uncached isn't different for no reason.  Half of the callers
already lock it directly after, and the others probably should also keep
it locked if only for consistency and beeing able to use xfs_buf_rele,
but I'll leave that for later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-06-29 13:57:15.596795734 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-06-29 13:57:32.243372220 +0200
@@ -679,7 +679,6 @@ xfs_buf_read_uncached(
 		return NULL;
 
 	/* set up the buffer for a read IO */
-	xfs_buf_lock(bp);
 	XFS_BUF_SET_ADDR(bp, daddr);
 	XFS_BUF_READ(bp);
 	XFS_BUF_BUSY(bp);
@@ -814,8 +813,6 @@ xfs_buf_get_uncached(
 		goto fail_free_mem;
 	}
 
-	xfs_buf_unlock(bp);
-
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
 	return bp;
 
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-06-29 13:53:33.954663139 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-06-29 13:57:32.243372220 +0200
@@ -1090,8 +1090,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 						log->l_iclog_size, 0);
 		if (!bp)
 			goto out_free_iclog;
-		if (!xfs_buf_trylock(bp))
-			ASSERT(0);
+
 		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
 		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
 		iclog->ic_bp = bp;
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-06-29 13:51:20.425386530 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2011-06-29 13:57:32.246705535 +0200
@@ -91,6 +91,8 @@ xlog_get_bp(
 	xlog_t		*log,
 	int		nbblks)
 {
+	struct xfs_buf	*bp;
+
 	if (!xlog_buf_bbcount_valid(log, nbblks)) {
 		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
 			nbblks);
@@ -118,8 +120,10 @@ xlog_get_bp(
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
-	return xfs_buf_get_uncached(log->l_mp->m_logdev_targp,
-					BBTOB(nbblks), 0);
+	bp = xfs_buf_get_uncached(log->l_mp->m_logdev_targp, BBTOB(nbblks), 0);
+	if (bp)
+		xfs_buf_unlock(bp);
+	return bp;
 }
 
 STATIC void
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-06-29 11:35:45.789455635 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-06-29 13:57:32.250038850 +0200
@@ -1969,6 +1969,8 @@ xfs_zero_remaining_bytes(
 	if (!bp)
 		return XFS_ERROR(ENOMEM);
 
+	xfs_buf_unlock(bp);
+
 	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
 		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 		nimap = 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
