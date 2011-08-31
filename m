Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VKcMhq226692 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:38:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90A6613B55A1
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 13:41:48 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ELYrjMQUoCkMQf3i for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 13:41:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyrYC-00072V-7w
	for xfs@oss.sgi.com; Wed, 31 Aug 2011 20:38:20 +0000
Message-Id: <20110831203820.180432395@bombadil.infradead.org>
Date: Wed, 31 Aug 2011 16:36:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/14] xfs: simplify xfs_qm_dqattach_grouphint
References: <20110831203647.455809764@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-quota-cleanup-xfs_qm_dqattach_grouphint
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

No need to play games with the qlock now that the freelist lock nestst
inside it.  Also clean up lots of outdated comments.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-08-31 12:43:11.873397916 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-08-31 12:49:13.156729092 +0200
@@ -651,11 +651,7 @@ xfs_qm_dqattach_one(
 
 /*
  * Given a udquot and gdquot, attach a ptr to the group dquot in the
- * udquot as a hint for future lookups. The idea sounds simple, but the
- * execution isn't, because the udquot might have a group dquot attached
- * already and getting rid of that gets us into lock ordering constraints.
- * The process is complicated more by the fact that the dquots may or may not
- * be locked on entry.
+ * udquot as a hint for future lookups.
  */
 STATIC void
 xfs_qm_dqattach_grouphint(
@@ -666,45 +662,21 @@ xfs_qm_dqattach_grouphint(
 
 	xfs_dqlock(udq);
 
-	if ((tmp = udq->q_gdquot)) {
-		if (tmp == gdq) {
-			xfs_dqunlock(udq);
-			return;
-		}
+	tmp = udq->q_gdquot;
+	if (tmp) {
+		if (tmp == gdq)
+			goto done;
 
 		udq->q_gdquot = NULL;
-		/*
-		 * We can't keep any dqlocks when calling dqrele,
-		 * because the freelist lock comes before dqlocks.
-		 */
-		xfs_dqunlock(udq);
-		/*
-		 * we took a hard reference once upon a time in dqget,
-		 * so give it back when the udquot no longer points at it
-		 * dqput() does the unlocking of the dquot.
-		 */
 		xfs_qm_dqrele(tmp);
-
-		xfs_dqlock(udq);
-		xfs_dqlock(gdq);
-
-	} else {
-		ASSERT(XFS_DQ_IS_LOCKED(udq));
-		xfs_dqlock(gdq);
-	}
-
-	ASSERT(XFS_DQ_IS_LOCKED(udq));
-	ASSERT(XFS_DQ_IS_LOCKED(gdq));
-	/*
-	 * Somebody could have attached a gdquot here,
-	 * when we dropped the uqlock. If so, just do nothing.
-	 */
-	if (udq->q_gdquot == NULL) {
-		XFS_DQHOLD(gdq);
-		udq->q_gdquot = gdq;
 	}
 
+	xfs_dqlock(gdq);
+	XFS_DQHOLD(gdq);
 	xfs_dqunlock(gdq);
+
+	udq->q_gdquot = gdq;
+done:
 	xfs_dqunlock(udq);
 }
 
@@ -771,17 +743,13 @@ xfs_qm_dqattach_locked(
 		ASSERT(ip->i_gdquot);
 
 		/*
-		 * We may or may not have the i_udquot locked at this point,
-		 * but this check is OK since we don't depend on the i_gdquot to
-		 * be accurate 100% all the time. It is just a hint, and this
-		 * will succeed in general.
-		 */
-		if (ip->i_udquot->q_gdquot == ip->i_gdquot)
-			goto done;
-		/*
-		 * Attach i_gdquot to the gdquot hint inside the i_udquot.
+		 * We do not have i_udquot locked at this point, but this check
+		 * is OK since we don't depend on the i_gdquot to be accurate
+		 * 100% all the time. It is just a hint, and this will
+		 * succeed in general.
 		 */
-		xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
+		if (ip->i_udquot->q_gdquot != ip->i_gdquot)
+			xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
 	}
 
  done:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
