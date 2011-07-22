Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0XGV2051454 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:33:16 -0500
Received: from e38.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66EED8C739
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:14 -0700 (PDT)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id owoTaTZATQVjgxjz for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:14 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6LGuBQh026123
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 10:56:11 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0XAB3203152 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:33:10 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6M0XAJm016800
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:33:10 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:33:06 -0700
Message-Id: <20110722003306.21069.97917.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_buf_item.c      |    2 +-
 fs/xfs/xfs_log_recover.c   |    2 +-
 fs/xfs/xfs_mount.c         |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index ce5c7e2..1828b29 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -253,7 +253,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNASYNC(bp)	((bp)->b_flags &= ~XBF_ASYNC)
 #define XFS_BUF_ISASYNC(bp)	((bp)->b_flags & XBF_ASYNC)
 
-#define XFS_BUF_HOLD(bp)	xfs_buf_hold(bp)
 #define XFS_BUF_READ(bp)	((bp)->b_flags |= XBF_READ)
 #define XFS_BUF_UNREAD(bp)	((bp)->b_flags &= ~XBF_READ)
 #define XFS_BUF_ISREAD(bp)	((bp)->b_flags & XBF_READ)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9e9b4a7..a6dd497 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -484,7 +484,7 @@ xfs_buf_item_trylock(
 		return XFS_ITEM_LOCKED;
 
 	/* take a reference to the buffer.  */
-	XFS_BUF_HOLD(bp);
+	xfs_buf_hold(bp);
 
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	trace_xfs_buf_item_trylock(bip);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f774713..8b02dca 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -265,7 +265,7 @@ xlog_bwrite(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	bp->b_flags &= ~(XBF_SYNCIO|XBF_FUA|XBF_FLUSH);
-	XFS_BUF_HOLD(bp);
+	xfs_buf_hold(bp);
 	xfs_buf_lock(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7f25245..b00c808 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1938,7 +1938,7 @@ xfs_getsb(
 		xfs_buf_lock(bp);
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
