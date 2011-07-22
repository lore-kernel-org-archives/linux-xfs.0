Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MNemmI117743 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 18:40:48 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60B648F9EB
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:40:47 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id HVot1yjHn28Vq84I for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:40:47 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MNJYc2015665
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 19:19:34 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MNellF139080 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 19:40:47 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6MNelbi003823 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 19:40:47 -0400
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 22 Jul 2011 16:40:46 -0700
Message-Id: <20110722234046.14612.14373.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 12/12 v3] xfs: Remove the macro XFS_BUFTARG_NAME
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
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 fs/xfs/linux-2.6/xfs_buf.h |   11 +++++++----
 fs/xfs/xfs_buf_item.c      |    2 +-
 fs/xfs/xfs_rw.c            |    2 +-
 4 files changed, 10 insertions(+), 7 deletions(-)

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
index c3a9e68..31a221d 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -228,8 +228,13 @@ extern void xfs_buf_delwri_promote(xfs_buf_t *);
 extern int xfs_buf_init(void);
 extern void xfs_buf_terminate(void);
 
-#define xfs_buf_target_name(target)	\
-	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
+static inline const char *
+xfs_buf_target_name(struct xfs_buftarg *target)
+{
+	static char __b[BDEVNAME_SIZE];
+
+	return bdevname(target->bt_bdev, __b);
+}
 
 void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_STALE(bp)	xfs_buf_stale(bp);
@@ -287,8 +292,6 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 
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
