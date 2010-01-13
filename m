Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DM57cr194023 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:05:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D22010C70B8
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:06:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PjBorRS7QVMkwb6X for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:06:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NVBLn-0004V2-Ea
	for xfs@oss.sgi.com; Wed, 13 Jan 2010 22:06:03 +0000
Message-Id: <20100113220603.251930871@bombadil.infradead.org>
Date: Wed, 13 Jan 2010 17:05:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: implement quota warnings via netlink
References: <20100113220547.846700560@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quotanl-warn
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

Wire up quota_send_warning to send quota warnings over netlink.  This is
used by various desktops to show user quota warnings.

Tested by running the quota_nld daemon while running the xfstest quota
tests and observing the warnings.  I'll see how I can get a more formal
testcase for it written.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-01-13 13:51:20.925003101 +0100
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-01-13 14:10:46.083254517 +0100
@@ -589,6 +589,20 @@ xfs_trans_unreserve_and_mod_dquots(
 	}
 }
 
+STATIC void
+xfs_quota_send_warning(
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dqp,
+	int			hard)
+{
+	/* no warnings for project quotas - we just return ENOSPC later */
+	if (dqp->dq_flags & XFS_DQ_PROJ)
+		return;
+	quota_send_warning((dqp->dq_flags & XFS_DQ_USER) ? USRQUOTA : GRPQUOTA,
+			   be32_to_cpu(dqp->q_core.d_id), mp->m_super->s_dev,
+			   hard ? QUOTA_NL_BHARDWARN: QUOTA_NL_BSOFTWARN);
+}
+
 /*
  * This reserves disk blocks and inodes against a dquot.
  * Flags indicate if the dquot is to be locked here and also
@@ -612,6 +626,7 @@ xfs_trans_dqresv(
 	xfs_qcnt_t	count;
 	xfs_qcnt_t	*resbcountp;
 	xfs_quotainfo_t	*q = mp->m_quotainfo;
+	int		hardwarn = 0;
 
 
 	xfs_dqlock(dqp);
@@ -657,8 +672,10 @@ xfs_trans_dqresv(
 			 * nblks.
 			 */
 			if (hardlimit > 0ULL &&
-			    hardlimit <= nblks + *resbcountp)
+			    hardlimit <= nblks + *resbcountp) {
+				hardwarn = 1;
 				goto error_return;
+			}
 			if (softlimit > 0ULL &&
 			    softlimit <= nblks + *resbcountp &&
 			    ((timer != 0 && get_seconds() > timer) ||
@@ -677,8 +694,10 @@ xfs_trans_dqresv(
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
 
-			if (hardlimit > 0ULL && count >= hardlimit)
+			if (hardlimit > 0ULL && count >= hardlimit) {
+				hardwarn = 1;
 				goto error_return;
+			}
 			if (softlimit > 0ULL && count >= softlimit &&
 			    ((timer != 0 && get_seconds() > timer) ||
 			     (warns != 0 && warns >= warnlimit)))
@@ -722,6 +741,7 @@ xfs_trans_dqresv(
 
 error_return:
 	xfs_dqunlock(dqp);
+	xfs_quota_send_warning(mp, dqp, hardwarn);
 	if (flags & XFS_QMOPT_ENOSPC)
 		return ENOSPC;
 	return EDQUOT;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
