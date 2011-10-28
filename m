Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3g93145439 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26A4BFCE485
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UpIroVrBz1Soa1hI for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHo-00034F-C7
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:40 +0000
Message-Id: <20111028100340.324675133@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 26/45] xfs: simplify xfs_qm_dqattach_grouphint
References: <20111028095423.796574703@bombadil.infradead.org>
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

---
 fs/xfs/xfs_qm.c |   64 ++++++++++++++------------------------------------------
 1 file changed, 16 insertions(+), 48 deletions(-)

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:04.892672352 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:05.388673160 +0200
@@ -650,11 +650,7 @@ xfs_qm_dqattach_one(
 
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
@@ -665,45 +661,21 @@ xfs_qm_dqattach_grouphint(
 
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
 
@@ -770,17 +742,13 @@ xfs_qm_dqattach_locked(
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
