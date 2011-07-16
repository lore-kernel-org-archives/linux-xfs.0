Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1MZJO228173 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:22:35 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15EC075A4D
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:34 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id xZKdATitfzfcNtPo for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:34 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G11TZj015333
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:01:29 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1LHeL1577088
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:21:17 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6FLL5Z3021953 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:21:05 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:21:16 -0700
Message-Id: <20110716012116.6629.48217.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
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

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |    4 ----
 fs/xfs/xfs_log.c           |    5 +++--
 fs/xfs/xfs_log_recover.c   |    2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 2c78bfe..e8304f1 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -232,10 +232,6 @@ extern void xfs_buf_terminate(void);
 #define xfs_buf_target_name(target)	\
 	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
 
-
-#define XFS_BUF_ZEROFLAGS(bp)	((bp)->b_flags &= \
-		~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED))
-
 void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_STALE(bp)	xfs_buf_stale(bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 41d5b8f..b17e651 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1367,7 +1367,7 @@ xlog_sync(xlog_t		*log,
 	}
 	XFS_BUF_SET_COUNT(bp, count);
 	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
-	XFS_BUF_ZEROFLAGS(bp);
+	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_LOG_BUFFER;
@@ -1411,7 +1411,8 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
 					    (__psint_t)count), split);
 		XFS_BUF_SET_FSPRIVATE(bp, iclog);
-		XFS_BUF_ZEROFLAGS(bp);
+		bp->b_flags &=
+			~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
 		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
 		bp->b_flags |= XBF_LOG_BUFFER;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 04142ca..75ba081 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -261,7 +261,7 @@ xlog_bwrite(
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	XFS_BUF_ZEROFLAGS(bp);
+	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_HOLD(bp);
 	XFS_BUF_PSEMA(bp, PRIBIO);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
