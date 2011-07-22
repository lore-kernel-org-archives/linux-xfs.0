Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0WtJI051398 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:32:55 -0500
Received: from e37.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C68B68C737
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:32:54 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id AVWD8jzcSQTCyZfJ for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:32:54 -0700 (PDT)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6M0TjG1013420
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:29:45 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0WnTf112632 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:32:49 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6LIWm9s006352
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 12:32:48 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:32:48 -0700
Message-Id: <20110722003248.21069.10452.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 02/12] xfs: Remove the macro XFS_BUF_ZEROFLAGS
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
Hence clearing only XBF_SYNCIO, XBF_FUA and XBF_FLUSH would suffice.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |    5 -----
 fs/xfs/xfs_log.c           |    4 ++--
 fs/xfs/xfs_log_recover.c   |    2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

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
index 06ff843..5319a95 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1354,7 +1354,7 @@ xlog_sync(xlog_t		*log,
 	}
 	XFS_BUF_SET_COUNT(bp, count);
 	bp->b_fspriv = iclog;
-	XFS_BUF_ZEROFLAGS(bp);
+	bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_SYNCIO;
@@ -1401,7 +1401,7 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
 					    (__psint_t)count), split);
 		bp->b_fspriv = iclog;
-		XFS_BUF_ZEROFLAGS(bp);
+		bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);
 		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
 		bp->b_flags |= XBF_SYNCIO;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8fe4206..3913b2f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -265,7 +265,7 @@ xlog_bwrite(
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	XFS_BUF_ZEROFLAGS(bp);
+	bp->b_flags &= ~(XBF_SYNCIO|XBF_FUA|XBF_FLUSH);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_HOLD(bp);
 	xfs_buf_lock(bp);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
