Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MNebQN117710 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 18:40:37 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1230AEF70DB
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:40:36 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id dMar7KMydJWZaWW0 for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:40:36 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MNJNTa015579
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 19:19:23 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MNeZI01744944
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 19:40:35 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6MJeNpB008843 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:40:23 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 22 Jul 2011 16:40:33 -0700
Message-Id: <20110722234033.14612.80261.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 10/12 v3] xfs: Remove the macro XFS_BUF_SET_TARGET
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
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_log_recover.c   |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index a1a7846..d655883 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -287,7 +287,6 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 
 #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
-#define XFS_BUF_SET_TARGET(bp, target)	((bp)->b_target = (target))
 #define XFS_BUF_TARGET(bp)		((bp)->b_target)
 #define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d1fdef9..3bafd93 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -179,7 +179,6 @@ xlog_bread_noalign(
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
-	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
@@ -267,7 +266,6 @@ xlog_bwrite(
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
