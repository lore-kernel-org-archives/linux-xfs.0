Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1M7VR228112 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:22:07 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D28DD150786D
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:06 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id 39OHGnoqu2lHCnvn for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:06 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G0uoo8023526
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:56:50 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1M5TF144070 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:22:05 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6FLLr5D023445 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:21:53 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:22:04 -0700
Message-Id: <20110716012204.6629.86975.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
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

Remove the definition and usages of the macro XFS_BUF_SET_TARGET.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_log_recover.c   |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 177c6f1..d6ba841 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -305,7 +305,6 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 #define XFS_BUF_PSEMA(bp,x)	xfs_buf_lock(bp)
 #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
-#define XFS_BUF_SET_TARGET(bp, target)	((bp)->b_target = (target))
 #define XFS_BUF_TARGET(bp)		((bp)->b_target)
 #define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 15e3bc0..97a3536 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -175,7 +175,7 @@ xlog_bread_noalign(
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
-	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
+	bp->b_target = log->l_mp->m_logdev_targp;
 
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
@@ -264,7 +264,7 @@ xlog_bwrite(
 	xfs_buf_hold(bp);
 	XFS_BUF_PSEMA(bp, PRIBIO);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
-	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
+	bp ->b_target = log->l_mp->m_logdev_targp;
 
 	if ((error = xfs_bwrite(log->l_mp, bp)))
 		xfs_ioerror_alert("xlog_bwrite", log->l_mp,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
