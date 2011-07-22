Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MNfM4m117769 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 18:41:22 -0500
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E96911EED273
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:41:21 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id ivv0jcArtjvnsb97 for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:41:21 -0700 (PDT)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MMVTUD005671
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:31:29 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MNe4pp142922 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 17:40:04 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6MHe3Mk004786
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 11:40:03 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 22 Jul 2011 16:40:04 -0700
Message-Id: <20110722234003.14612.29595.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 05/12 v3] xfs: Remove macro XFS_BUF_HOLD
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
Reviewed-by: Alex Elder <aelder@sgi.com>
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
index b07482c..59f4237 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -264,7 +264,7 @@ xlog_bwrite(
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
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
