Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0ZX4b051616 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:35:33 -0500
Received: from e39.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C597E1D8A869
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:35:31 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id v2U1WBPH3dFrrcyE for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:35:31 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6M0KdDC001250
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:20:41 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0YAtm169684 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:34:10 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6LIXhFs000523
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 12:33:43 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:34:09 -0700
Message-Id: <20110722003408.21069.44409.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 12/12] xfs: Remove the macro XFS_BUFTARG_NAME
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

Remove the definition and usages of the macro XFS_BUFTARG_NAME.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 fs/xfs/linux-2.6/xfs_buf.h |    2 --
 fs/xfs/xfs_buf_item.c      |    2 +-
 fs/xfs/xfs_rw.c            |    2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5e929f0..6bddce4 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1480,7 +1480,7 @@ xfs_setsize_buftarg_flags(
 	if (set_blocksize(btp->bt_bdev, sectorsize)) {
 		xfs_warn(btp->bt_mount,
 			"Cannot set_blocksize to %u on device %s\n",
-			sectorsize, XFS_BUFTARG_NAME(btp));
+			sectorsize, xfs_buf_target_name(btp));
 		return EINVAL;
 	}
 
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 075f567..3a421da 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -287,8 +287,6 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 
 #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
-#define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
-
 static inline void xfs_buf_relse(xfs_buf_t *bp)
 {
 	xfs_buf_unlock(bp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5c2b554..0402173 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -975,7 +975,7 @@ xfs_buf_iodone_callbacks(
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
 		xfs_alert(mp, "Device %s: metadata write error block 0x%llx",
-			XFS_BUFTARG_NAME(bp->b_target),
+			xfs_buf_target_name(bp->b_target),
 		      (__uint64_t)XFS_BUF_ADDR(bp));
 	}
 	lasttarg = bp->b_target;
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index 7382bfe..c96a8a0 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -104,7 +104,7 @@ xfs_ioerror_alert(
 	xfs_alert(mp,
 		 "I/O error occurred: meta-data dev %s block 0x%llx"
 		 "       (\"%s\") error %d buf count %zd",
-		XFS_BUFTARG_NAME(bp->b_target),
+		xfs_buf_target_name(bp->b_target),
 		(__uint64_t)blkno, func,
 		bp->b_error, XFS_BUF_COUNT(bp));
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
