Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1Ld33228063 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:21:40 -0500
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5795B1507865
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:21:38 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id 4I0QxjGpILUBEWg0 for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:21:38 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G0naQc010006
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:49:36 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1LamJ1683704
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:21:38 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6G1La3o024725 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:21:36 -0400
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:21:35 -0700
Message-Id: <20110716012135.6629.35363.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 05/12] xfs: Remove macro XFS_BUF_HOLD
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

Remove the definition and usage of the macro XFS_BUF_HOLD

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_buf_item.c      |    2 +-
 fs/xfs/xfs_log_recover.c   |    2 +-
 fs/xfs/xfs_mount.c         |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index ce554d9..536ede5 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -258,7 +258,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNORDERED(bp)	((bp)->b_flags &= ~XBF_ORDERED)
 #define XFS_BUF_ISORDERED(bp)	((bp)->b_flags & XBF_ORDERED)
 
-#define XFS_BUF_HOLD(bp)	xfs_buf_hold(bp)
 #define XFS_BUF_READ(bp)	((bp)->b_flags |= XBF_READ)
 #define XFS_BUF_UNREAD(bp)	((bp)->b_flags &= ~XBF_READ)
 #define XFS_BUF_ISREAD(bp)	((bp)->b_flags & XBF_READ)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d04046f..299f614 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -486,7 +486,7 @@ xfs_buf_item_trylock(
 		return XFS_ITEM_LOCKED;
 
 	/* take a reference to the buffer.  */
-	XFS_BUF_HOLD(bp);
+	xfs_buf_hold(bp);
 
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	trace_xfs_buf_item_trylock(bip);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fa0c0d6..87d7d95 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -261,7 +261,7 @@ xlog_bwrite(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
-	XFS_BUF_HOLD(bp);
+	xfs_buf_hold(bp);
 	XFS_BUF_PSEMA(bp, PRIBIO);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e569b77..c8a5a34 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1952,7 +1952,7 @@ xfs_getsb(
 	} else {
 		XFS_BUF_PSEMA(bp, PRIBIO);
 	}
-	XFS_BUF_HOLD(bp);
+	xfs_buf_hold(bp);
 	ASSERT(XFS_BUF_ISDONE(bp));
 	return bp;
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
