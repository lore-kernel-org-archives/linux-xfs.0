Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1MJJR228145 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:22:19 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAB9B1507872
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:18 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id kPAlLtcL2JpOZpcZ for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:18 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G11Ddb014957
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:01:13 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1MHJS130544 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:22:17 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6FLM5VN024133 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:05 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:22:16 -0700
Message-Id: <20110716012216.6629.25185.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 fs/xfs/linux-2.6/xfs_buf.h |    2 --
 fs/xfs/xfs_buf_item.c      |    2 +-
 fs/xfs/xfs_rw.c            |    2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 57b36e2..f0c7258 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1497,7 +1497,7 @@ xfs_setsize_buftarg_flags(
 	if (set_blocksize(btp->bt_bdev, sectorsize)) {
 		xfs_warn(btp->bt_mount,
 			"Cannot set_blocksize to %u on device %s\n",
-			sectorsize, XFS_BUFTARG_NAME(btp));
+			sectorsize, xfs_buf_target_name(btp));
 		return EINVAL;
 	}
 
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 6e4d465..53e0bab 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -305,8 +305,6 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 #define XFS_BUF_PSEMA(bp,x)	xfs_buf_lock(bp)
 #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
-#define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
-
 static inline void xfs_buf_relse(xfs_buf_t *bp)
 {
 	xfs_buf_unlock(bp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 351e781..538558d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -984,7 +984,7 @@ xfs_buf_iodone_callbacks(
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
 		xfs_alert(mp, "Device %s: metadata write error block 0x%llx",
-			XFS_BUFTARG_NAME(bp->b_target),
+			xfs_buf_target_name(bp->b_target),
 		      (__uint64_t)XFS_BUF_ADDR(bp));
 	}
 	lasttarg = bp->b_target;
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index 92c4b74..a1c9fcd 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -104,7 +104,7 @@ xfs_ioerror_alert(
 	xfs_alert(mp,
 		 "I/O error occurred: meta-data dev %s block 0x%llx"
 		 "       (\"%s\") error %d buf count %zd",
-		XFS_BUFTARG_NAME(bp->b_target),
+		xfs_buf_target_name(bp->b_target),
 		(__uint64_t)blkno, func,
 		xfs_buf_geterror(bp), XFS_BUF_COUNT(bp));
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
