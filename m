Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MNdmfW117546 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 18:39:48 -0500
Received: from e37.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 294CD1D8BF63
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:39:47 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id C0QUmLze1kRfKK17 for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:39:47 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MNah3x016655
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 17:36:43 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p6MNdlPH196314 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 17:39:47 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6MHdkNh023660
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 11:39:46 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 22 Jul 2011 16:39:45 -0700
Message-Id: <20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 02/12 v3] xfs: Remove the macro XFS_BUF_ZEROFLAGS
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Remove the definition and usage of the macro XFS_BUF_ZEROFLAGS.

In the specific contexts, not all flags need to be cleared. Hence the
simplification.

Rationale for xfs_log.c:
from hch: XBF_READ and XBF_DELWRI will never be set here, XBF_WRITE
XBF_ASYNC, and XBF_SYNCIO are set just below.
Hence clearing only XBF_FUA and XBF_FLUSH would suffice.

Rationale for xfs_log_recover.c
from hch: XBF_READ, XBF_WRITE, XBF_ASYNC and XBF_DELWRI already get dealt with
in xfs_bwrite a few lines down.
from hch: XBF_SYNCIO, XBF_FUA and XBF_FLUSH are used only in log buffers. No
need to clear them here.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |    5 -----
 fs/xfs/xfs_log.c           |    3 +--
 fs/xfs/xfs_log_recover.c   |    1 -
 3 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 6b6c25f..d7df7b6 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -231,11 +231,6 @@ extern void xfs_buf_terminate(void);
 #define xfs_buf_target_name(target)	\
 	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
 
-
-#define XFS_BUF_ZEROFLAGS(bp) \
-	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI| \
-			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))
-
 void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_STALE(bp)	xfs_buf_stale(bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 06ff843..3ee0fa9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1247,6 +1247,7 @@ xlog_bdstrat(
 {
 	struct xlog_in_core	*iclog = bp->b_fspriv;
 
+	bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		XFS_BUF_ERROR(bp, EIO);
 		XFS_BUF_STALE(bp);
@@ -1354,7 +1355,6 @@ xlog_sync(xlog_t		*log,
 	}
 	XFS_BUF_SET_COUNT(bp, count);
 	bp->b_fspriv = iclog;
-	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_SYNCIO;
@@ -1401,7 +1401,6 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
 					    (__psint_t)count), split);
 		bp->b_fspriv = iclog;
-		XFS_BUF_ZEROFLAGS(bp);
 		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
 		bp->b_flags |= XBF_SYNCIO;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8fe4206..301508b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -265,7 +265,6 @@ xlog_bwrite(
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_HOLD(bp);
 	xfs_buf_lock(bp);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
