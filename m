Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1MDdI228130 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:22:13 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9FB775A4B
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:12 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id 1QhAYCBjoWnwuVA0 for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:12 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G19m0j026412
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:09:48 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1MBor153450 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:22:12 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6G1MBGd027971 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 22:22:11 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:22:10 -0700
Message-Id: <20110716012210.6629.98115.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 11/12] xfs: Remove the macro XFS_BUF_TARGET
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

Remove the definition and usages of the macro XFS_BUF_TARGET

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_buf_item.c      |    6 +++---
 fs/xfs/xfs_da_btree.c      |    2 +-
 fs/xfs/xfs_mount.c         |    2 +-
 fs/xfs/xfs_rw.c            |    2 +-
 fs/xfs/xfs_trans_buf.c     |    2 +-
 6 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index d6ba841..6e4d465 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -305,7 +305,6 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 #define XFS_BUF_PSEMA(bp,x)	xfs_buf_lock(bp)
 #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
-#define XFS_BUF_TARGET(bp)		((bp)->b_target)
 #define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
 
 static inline void xfs_buf_relse(xfs_buf_t *bp)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2f4169a..351e781 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -980,14 +980,14 @@ xfs_buf_iodone_callbacks(
 		goto do_callbacks;
 	}
 
-	if (XFS_BUF_TARGET(bp) != lasttarg ||
+	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
 		xfs_alert(mp, "Device %s: metadata write error block 0x%llx",
-			XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
+			XFS_BUFTARG_NAME(bp->b_target),
 		      (__uint64_t)XFS_BUF_ADDR(bp));
 	}
-	lasttarg = XFS_BUF_TARGET(bp);
+	lasttarg = bp->b_target;
 
 	/*
 	 * If the write was asynchronous then no one will be looking for the
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index c4b6fbe..7d92207 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2259,7 +2259,7 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bps, inst_t *ra)
 	dabuf->dirty = 0;
 #ifdef XFS_DABUF_DEBUG
 	dabuf->ra = ra;
-	dabuf->target = XFS_BUF_TARGET(bps[0]);
+	dabuf->target = bps[0]->b_target;
 	dabuf->blkno = XFS_BUF_ADDR(bps[0]);
 #endif
 	if (nbuf == 1) {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c8a5a34..cf1588c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1626,7 +1626,7 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 		XFS_BUF_UNDELAYWRITE(sbp);
 		XFS_BUF_WRITE(sbp);
 		XFS_BUF_UNASYNC(sbp);
-		ASSERT(XFS_BUF_TARGET(sbp) == mp->m_ddev_targp);
+		ASSERT(sbp->b_target == mp->m_ddev_targp);
 		xfsbdstrat(mp, sbp);
 		error = xfs_buf_iowait(sbp);
 		if (error)
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index 0e326b4..92c4b74 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -104,7 +104,7 @@ xfs_ioerror_alert(
 	xfs_alert(mp,
 		 "I/O error occurred: meta-data dev %s block 0x%llx"
 		 "       (\"%s\") error %d buf count %zd",
-		XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
+		XFS_BUFTARG_NAME(bp->b_target),
 		(__uint64_t)blkno, func,
 		xfs_buf_geterror(bp), XFS_BUF_COUNT(bp));
 }
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 73f3685..e6f18db 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -54,7 +54,7 @@ xfs_trans_buf_item_match(
 	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
 		blip = (struct xfs_buf_log_item *)lidp->lid_item;
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
-		    XFS_BUF_TARGET(blip->bli_buf) == target &&
+		    blip->bli_buf->b_target == target &&
 		    XFS_BUF_ADDR(blip->bli_buf) == blkno &&
 		    XFS_BUF_COUNT(blip->bli_buf) == len)
 			return blip->bli_buf;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
