Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0XIeO051471 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:33:18 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7529E8C73B
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:18 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id jbEVljA0wpvqe0Nc for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:18 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6M0As22012511
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:10:54 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0XH7d058718 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:33:17 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6LKX5lJ016590 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:05 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:33:15 -0700
Message-Id: <20110722003315.21069.75196.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 06/12] xfs: Remove macro XFS_BUF_SET_START
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

Remove the definition and usage of the macro XFS_BUF_SET_START.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_buf.h |    2 --
 fs/xfs/xfs_buf_item.c      |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 1828b29..6758697 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -261,8 +261,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
 #define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
 
-#define XFS_BUF_SET_START(bp)			do { } while (0)
-
 #define XFS_BUF_PTR(bp)			(xfs_caddr_t)((bp)->b_addr)
 #define XFS_BUF_SET_PTR(bp, val, cnt)	xfs_buf_associate_memory(bp, val, cnt)
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a6dd497..bd4c62b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -994,7 +994,6 @@ xfs_buf_iodone_callbacks(
 		if (!XFS_BUF_ISSTALE(bp)) {
 			XFS_BUF_DELAYWRITE(bp);
 			XFS_BUF_DONE(bp);
-			XFS_BUF_SET_START(bp);
 		}
 		ASSERT(bp->b_iodone != NULL);
 		trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
