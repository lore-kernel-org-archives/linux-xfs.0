Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HMZKV1051112 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 16:35:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9F721C582B1
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 14:36:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PrDiXMj7iYlyxLey for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 14:36:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NWdjH-0004L4-Kt
	for xfs@oss.sgi.com; Sun, 17 Jan 2010 22:36:19 +0000
Date: Sun, 17 Jan 2010 17:36:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3 v2] xfs: implement quota warnings via netlink
Message-ID: <20100117223619.GA16102@infradead.org>
References: <20100113220547.846700560@bombadil.infradead.org>
	<20100113220603.251930871@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100113220603.251930871@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
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
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-01-17 11:02:29.340004208 +0100
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-01-17 13:41:34.142005475 +0100
@@ -589,6 +589,20 @@ xfs_trans_unreserve_and_mod_dquots(
 	}
 }
 
+STATIC void
+xfs_quota_warn(
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dqp,
+	int			type)
+{
+	/* no warnings for project quotas - we just return ENOSPC later */
+	if (dqp->dq_flags & XFS_DQ_PROJ)
+		return;
+	quota_send_warning((dqp->dq_flags & XFS_DQ_USER) ? USRQUOTA : GRPQUOTA,
+			   be32_to_cpu(dqp->q_core.d_id), mp->m_super->s_dev,
+			   type);
+}
+
 /*
  * This reserves disk blocks and inodes against a dquot.
  * Flags indicate if the dquot is to be locked here and also
@@ -657,13 +671,21 @@ xfs_trans_dqresv(
 			 * nblks.
 			 */
 			if (hardlimit > 0ULL &&
-			    hardlimit <= nblks + *resbcountp)
+			    hardlimit <= nblks + *resbcountp) {
+				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
 				goto error_return;
+			}
 			if (softlimit > 0ULL &&
-			    softlimit <= nblks + *resbcountp &&
-			    ((timer != 0 && get_seconds() > timer) ||
-			     (warns != 0 && warns >= warnlimit)))
-				goto error_return;
+			    softlimit <= nblks + *resbcountp) {
+				if ((timer != 0 && get_seconds() > timer) ||
+				    (warns != 0 && warns >= warnlimit)) {
+					xfs_quota_warn(mp, dqp,
+						       QUOTA_NL_BSOFTLONGWARN);
+					goto error_return;
+				}
+
+				xfs_quota_warn(mp, dqp, QUOTA_NL_BSOFTWARN);
+			}
 		}
 		if (ninos > 0) {
 			count = be64_to_cpu(dqp->q_core.d_icount);
@@ -677,12 +699,19 @@ xfs_trans_dqresv(
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
 
-			if (hardlimit > 0ULL && count >= hardlimit)
-				goto error_return;
-			if (softlimit > 0ULL && count >= softlimit &&
-			    ((timer != 0 && get_seconds() > timer) ||
-			     (warns != 0 && warns >= warnlimit)))
+			if (hardlimit > 0ULL && count >= hardlimit) {
+				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
 				goto error_return;
+			}
+			if (softlimit > 0ULL && count >= softlimit) {
+				if  ((timer != 0 && get_seconds() > timer) ||
+				     (warns != 0 && warns >= warnlimit)) {
+					xfs_quota_warn(mp, dqp,
+						       QUOTA_NL_ISOFTLONGWARN);
+					goto error_return;
+				}
+				xfs_quota_warn(mp, dqp, QUOTA_NL_ISOFTWARN);
+			}
 		}
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
