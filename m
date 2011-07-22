Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0XwS4051544 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:33:59 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95E9F8C743
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:58 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id OXodgAhzeUfEUSje for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:58 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6M04xP4007172
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:04:59 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0XvdO163636 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:33:57 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6M0Xvst020271 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 21:33:57 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:33:52 -0700
Message-Id: <20110722003352.21069.89866.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 10/12] xfs: Remove the macro XFS_BUF_SET_TARGET
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

Remove the macro XFS_BUF_SET_TARGET.

hch: As all the buffer allocator already set ->b_target it should be safe
to simply remove these calls.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_log_recover.c   |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 71e1d6f..31495cf 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -287,7 +287,6 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 
 #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
-#define XFS_BUF_SET_TARGET(bp, target)	((bp)->b_target = (target))
 #define XFS_BUF_TARGET(bp)		((bp)->b_target)
 #define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3f77077..713ba9c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -179,7 +179,6 @@ xlog_bread_noalign(
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
-	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
@@ -268,7 +267,6 @@ xlog_bwrite(
 	xfs_buf_hold(bp);
 	xfs_buf_lock(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
-	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
 	if ((error = xfs_bwrite(log->l_mp, bp)))
 		xfs_ioerror_alert("xlog_bwrite", log->l_mp,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
