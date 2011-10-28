Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3gkB145448 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7495CFCE484
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:41 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CsAuHry7Sraw1FEj for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHo-00034l-I1
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:40 +0000
Message-Id: <20111028100340.512340316@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 27/45] xfs: add a xfs_dqhold helper
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-add-xfs_dqhold
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

Factor the common:

	xfs_dqlock(dqp);
	XFS_DQHOLD(dqp);
	xfs_dqunlock(dqp);

pattern into a new helper, and remove XFS_DQHOLD now that only two callers
are left.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c |    2 +-
 fs/xfs/xfs_dquot.h |   10 ++++++++--
 fs/xfs/xfs_qm.c    |   50 +++++++++++++-------------------------------------
 3 files changed, 22 insertions(+), 40 deletions(-)

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:05.388673160 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:05.868674047 +0200
@@ -606,12 +606,9 @@ xfs_qm_dqattach_one(
 		 */
 		dqp = udqhint->q_gdquot;
 		if (dqp && be32_to_cpu(dqp->q_core.d_id) == id) {
-			xfs_dqlock(dqp);
-			XFS_DQHOLD(dqp);
 			ASSERT(*IO_idqpp == NULL);
-			*IO_idqpp = dqp;
 
-			xfs_dqunlock(dqp);
+			*IO_idqpp = xfs_qm_dqhold(dqp);
 			xfs_dqunlock(udqhint);
 			return 0;
 		}
@@ -670,11 +667,7 @@ xfs_qm_dqattach_grouphint(
 		xfs_qm_dqrele(tmp);
 	}
 
-	xfs_dqlock(gdq);
-	XFS_DQHOLD(gdq);
-	xfs_dqunlock(gdq);
-
-	udq->q_gdquot = gdq;
+	udq->q_gdquot = xfs_qm_dqhold(gdq);
 done:
 	xfs_dqunlock(udq);
 }
@@ -1939,10 +1932,7 @@ xfs_qm_vop_dqalloc(
 			 * this to caller
 			 */
 			ASSERT(ip->i_udquot);
-			uq = ip->i_udquot;
-			xfs_dqlock(uq);
-			XFS_DQHOLD(uq);
-			xfs_dqunlock(uq);
+			uq = xfs_qm_dqhold(ip->i_udquot);
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
@@ -1963,10 +1953,7 @@ xfs_qm_vop_dqalloc(
 			xfs_ilock(ip, lockflags);
 		} else {
 			ASSERT(ip->i_gdquot);
-			gq = ip->i_gdquot;
-			xfs_dqlock(gq);
-			XFS_DQHOLD(gq);
-			xfs_dqunlock(gq);
+			gq = xfs_qm_dqhold(ip->i_gdquot);
 		}
 	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (xfs_get_projid(ip) != prid) {
@@ -1986,10 +1973,7 @@ xfs_qm_vop_dqalloc(
 			xfs_ilock(ip, lockflags);
 		} else {
 			ASSERT(ip->i_gdquot);
-			gq = ip->i_gdquot;
-			xfs_dqlock(gq);
-			XFS_DQHOLD(gq);
-			xfs_dqunlock(gq);
+			gq = xfs_qm_dqhold(ip->i_gdquot);
 		}
 	}
 	if (uq)
@@ -2039,14 +2023,10 @@ xfs_qm_vop_chown(
 	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
 
 	/*
-	 * Take an extra reference, because the inode
-	 * is going to keep this dquot pointer even
-	 * after the trans_commit.
-	 */
-	xfs_dqlock(newdq);
-	XFS_DQHOLD(newdq);
-	xfs_dqunlock(newdq);
-	*IO_olddq = newdq;
+	 * Take an extra reference, because the inode is going to keep
+	 * this dquot pointer even after the trans_commit.
+	 */
+	*IO_olddq = xfs_qm_dqhold(newdq);
 
 	return prevdq;
 }
@@ -2178,25 +2158,21 @@ xfs_qm_vop_create_dqattach(
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	if (udqp) {
-		xfs_dqlock(udqp);
-		XFS_DQHOLD(udqp);
-		xfs_dqunlock(udqp);
 		ASSERT(ip->i_udquot == NULL);
-		ip->i_udquot = udqp;
 		ASSERT(XFS_IS_UQUOTA_ON(mp));
 		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
+
+		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp) {
-		xfs_dqlock(gdqp);
-		XFS_DQHOLD(gdqp);
-		xfs_dqunlock(gdqp);
 		ASSERT(ip->i_gdquot == NULL);
-		ip->i_gdquot = gdqp;
 		ASSERT(XFS_IS_OQUOTA_ON(mp));
 		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
 			ip->i_d.di_gid : xfs_get_projid(ip)) ==
 				be32_to_cpu(gdqp->q_core.d_id));
+
+		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 }
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:04.892672352 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:05.872671537 +0200
@@ -734,7 +734,7 @@ xfs_qm_dqlookup(
 			return -1;
 		}
 
-		XFS_DQHOLD(dqp);
+		dqp->q_nrefs++;
 
 		/*
 		 * move the dquot to the front of the hashchain
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2011-10-27 22:40:04.376671215 +0200
+++ xfs/fs/xfs/xfs_dquot.h	2011-10-27 22:40:05.876670670 +0200
@@ -80,8 +80,6 @@ enum {
 	XFS_QLOCK_NESTED,
 };
 
-#define XFS_DQHOLD(dqp)		((dqp)->q_nrefs++)
-
 /*
  * Manage the q_flush completion queue embedded in the dquot.  This completion
  * queue synchronizes processes attempting to flush the in-core dquot back to
@@ -147,4 +145,12 @@ extern void		xfs_dqlock2(struct xfs_dquo
 extern void		xfs_dqunlock(struct xfs_dquot *);
 extern void		xfs_dqflock_pushbuf_wait(struct xfs_dquot *dqp);
 
+static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
+{
+	xfs_dqlock(dqp);
+	dqp->q_nrefs++;
+	xfs_dqunlock(dqp);
+	return dqp;
+}
+
 #endif /* __XFS_DQUOT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
