Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DM57ac194021 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:05:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C758F10C6DD2
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:06:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fIq94B67RCavGqfi for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:06:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NVBLn-0004UW-4V
	for xfs@oss.sgi.com; Wed, 13 Jan 2010 22:06:03 +0000
Message-Id: <20100113220602.928911019@bombadil.infradead.org>
Date: Wed, 13 Jan 2010 17:05:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: clean up error handling in xfs_trans_dqresv
References: <20100113220547.846700560@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_trans_dqresv
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

Move the error code selection after the goto label and fold the
xfs_quota_error helper into it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-01-13 13:37:38.652253919 +0100
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-01-13 13:50:50.132006544 +0100
@@ -589,14 +589,6 @@ xfs_trans_unreserve_and_mod_dquots(
 	}
 }
 
-STATIC int
-xfs_quota_error(uint flags)
-{
-	if (flags & XFS_QMOPT_ENOSPC)
-		return ENOSPC;
-	return EDQUOT;
-}
-
 /*
  * This reserves disk blocks and inodes against a dquot.
  * Flags indicate if the dquot is to be locked here and also
@@ -612,7 +604,6 @@ xfs_trans_dqresv(
 	long		ninos,
 	uint		flags)
 {
-	int		error;
 	xfs_qcnt_t	hardlimit;
 	xfs_qcnt_t	softlimit;
 	time_t		timer;
@@ -649,7 +640,6 @@ xfs_trans_dqresv(
 		warnlimit = XFS_QI_RTBWARNLIMIT(dqp->q_mount);
 		resbcountp = &dqp->q_res_rtbcount;
 	}
-	error = 0;
 
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
 	    dqp->q_core.d_id &&
@@ -667,19 +657,13 @@ xfs_trans_dqresv(
 			 * nblks.
 			 */
 			if (hardlimit > 0ULL &&
-			     (hardlimit <= nblks + *resbcountp)) {
-				error = xfs_quota_error(flags);
+			    hardlimit <= nblks + *resbcountp)
 				goto error_return;
-			}
-
 			if (softlimit > 0ULL &&
-			     (softlimit <= nblks + *resbcountp)) {
-				if ((timer != 0 && get_seconds() > timer) ||
-				    (warns != 0 && warns >= warnlimit)) {
-					error = xfs_quota_error(flags);
-					goto error_return;
-				}
-			}
+			    softlimit <= nblks + *resbcountp &&
+			    ((timer != 0 && get_seconds() > timer) ||
+			     (warns != 0 && warns >= warnlimit)))
+				goto error_return;
 		}
 		if (ninos > 0) {
 			count = be64_to_cpu(dqp->q_core.d_icount);
@@ -692,16 +676,13 @@ xfs_trans_dqresv(
 			softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
-			if (hardlimit > 0ULL && count >= hardlimit) {
-				error = xfs_quota_error(flags);
+
+			if (hardlimit > 0ULL && count >= hardlimit)
+				goto error_return;
+			if (softlimit > 0ULL && count >= softlimit &&
+			    ((timer != 0 && get_seconds() > timer) ||
+			     (warns != 0 && warns >= warnlimit)))
 				goto error_return;
-			} else if (softlimit > 0ULL && count >= softlimit) {
-				if ((timer != 0 && get_seconds() > timer) ||
-				     (warns != 0 && warns >= warnlimit)) {
-					error = xfs_quota_error(flags);
-					goto error_return;
-				}
-			}
 		}
 	}
 
@@ -736,9 +717,14 @@ xfs_trans_dqresv(
 	ASSERT(dqp->q_res_rtbcount >= be64_to_cpu(dqp->q_core.d_rtbcount));
 	ASSERT(dqp->q_res_icount >= be64_to_cpu(dqp->q_core.d_icount));
 
+	xfs_dqunlock(dqp);
+	return 0;
+
 error_return:
 	xfs_dqunlock(dqp);
-	return error;
+	if (flags & XFS_QMOPT_ENOSPC)
+		return ENOSPC;
+	return EDQUOT;
 }
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
