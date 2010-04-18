Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3I090Ek096525 for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 19:09:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCF29102B7BB
	for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:10:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SFBrJm8WsiCKCx6e for
	<xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:10:58 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O3I6E-0006qU-7M
	for xfs@oss.sgi.com; Sun, 18 Apr 2010 00:10:58 +0000
Message-Id: <20100418001058.028384332@bombadil.infradead.org>
Date: Sat, 17 Apr 2010 20:10:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: remove a few macro indirections in the quota code
References: <20100418001041.865247520@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_DQ_IS_ADDEDTO_TRX
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_quota_priv.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_quota_priv.h	2010-04-17 17:02:51.392013208 -0700
+++ xfs/fs/xfs/quota/xfs_quota_priv.h	2010-04-17 17:03:15.368255916 -0700
@@ -24,8 +24,6 @@
  */
 #define XFS_DQITER_MAP_SIZE	10
 
-#define XFS_DQ_IS_ADDEDTO_TRX(t, d)	((d)->q_transp == (t))
-
 /*
  * Hash into a bucket in the dquot hash table, based on <mp, id>.
  */
@@ -37,9 +35,6 @@
 				      XFS_DQ_HASHVAL(mp, id)) : \
 				     (xfs_Gqm->qm_grp_dqhtable + \
 				      XFS_DQ_HASHVAL(mp, id)))
-#define XFS_IS_DQTYPE_ON(mp, type)   (type == XFS_DQ_USER ? \
-					XFS_IS_UQUOTA_ON(mp) : \
-					XFS_IS_OQUOTA_ON(mp))
 #define XFS_IS_DQUOT_UNINITIALIZED(dqp) ( \
 	!dqp->q_core.d_blk_hardlimit && \
 	!dqp->q_core.d_blk_softlimit && \
@@ -51,14 +46,6 @@
 	!dqp->q_core.d_rtbcount && \
 	!dqp->q_core.d_icount)
 
-#define XFS_DQ_IS_LOGITEM_INITD(dqp)	((dqp)->q_logitem.qli_dquot == (dqp))
-
-#define XFS_QM_DQP_TO_DQACCT(tp, dqp)	(XFS_QM_ISUDQ(dqp) ? \
-					 (tp)->t_dqinfo->dqa_usrdquots : \
-					 (tp)->t_dqinfo->dqa_grpdquots)
-#define XFS_IS_SUSER_DQUOT(dqp)		\
-	(!((dqp)->q_core.d_id))
-
 #define DQFLAGTO_TYPESTR(d)	(((d)->dq_flags & XFS_DQ_USER) ? "USR" : \
 				 (((d)->dq_flags & XFS_DQ_GROUP) ? "GRP" : \
 				 (((d)->dq_flags & XFS_DQ_PROJ) ? "PRJ":"???")))
Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-04-17 17:02:25.000000000 -0700
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-04-17 17:02:43.453004198 -0700
@@ -59,12 +59,11 @@ xfs_trans_dqjoin(
 	xfs_trans_t	*tp,
 	xfs_dquot_t	*dqp)
 {
-	xfs_dq_logitem_t    *lp;
+	xfs_dq_logitem_t    *lp = &dqp->q_logitem;
 
-	ASSERT(! XFS_DQ_IS_ADDEDTO_TRX(tp, dqp));
+	ASSERT(dqp->q_transp != tp);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	ASSERT(XFS_DQ_IS_LOGITEM_INITD(dqp));
-	lp = &dqp->q_logitem;
+	ASSERT(lp->qli_dquot == dqp);
 
 	/*
 	 * Get a log_item_desc to point at the new item.
@@ -96,7 +95,7 @@ xfs_trans_log_dquot(
 {
 	xfs_log_item_desc_t	*lidp;
 
-	ASSERT(XFS_DQ_IS_ADDEDTO_TRX(tp, dqp));
+	ASSERT(dqp->q_transp == tp);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
 	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)(&dqp->q_logitem));
@@ -198,16 +197,16 @@ xfs_trans_get_dqtrx(
 	int		i;
 	xfs_dqtrx_t	*qa;
 
-	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
-		qa = XFS_QM_DQP_TO_DQACCT(tp, dqp);
+	qa = XFS_QM_ISUDQ(dqp) ?
+		tp->t_dqinfo->dqa_usrdquots : tp->t_dqinfo->dqa_grpdquots;
 
+	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 		if (qa[i].qt_dquot == NULL ||
-		    qa[i].qt_dquot == dqp) {
-			return (&qa[i]);
-		}
+		    qa[i].qt_dquot == dqp)
+			return &qa[i];
 	}
 
-	return (NULL);
+	return NULL;
 }
 
 /*
@@ -381,7 +380,7 @@ xfs_trans_apply_dquot_deltas(
 				break;
 
 			ASSERT(XFS_DQ_IS_LOCKED(dqp));
-			ASSERT(XFS_DQ_IS_ADDEDTO_TRX(tp, dqp));
+			ASSERT(dqp->q_transp == tp);
 
 			/*
 			 * adjust the actual number of blocks used
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-04-17 17:02:25.000000000 -0700
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-04-17 17:02:43.448024173 -0700
@@ -956,16 +956,17 @@ xfs_qm_dqget(
 	 */
 	if (ip) {
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		if (! XFS_IS_DQTYPE_ON(mp, type)) {
-			/* inode stays locked on return */
-			xfs_qm_dqdestroy(dqp);
-			return XFS_ERROR(ESRCH);
-		}
+
 		/*
 		 * A dquot could be attached to this inode by now, since
 		 * we had dropped the ilock.
 		 */
 		if (type == XFS_DQ_USER) {
+			if (!XFS_IS_UQUOTA_ON(mp)) {
+				/* inode stays locked on return */
+				xfs_qm_dqdestroy(dqp);
+				return XFS_ERROR(ESRCH);
+			}
 			if (ip->i_udquot) {
 				xfs_qm_dqdestroy(dqp);
 				dqp = ip->i_udquot;
@@ -973,6 +974,11 @@ xfs_qm_dqget(
 				goto dqret;
 			}
 		} else {
+			if (!XFS_IS_OQUOTA_ON(mp)) {
+				/* inode stays locked on return */
+				xfs_qm_dqdestroy(dqp);
+				return XFS_ERROR(ESRCH);
+			}
 			if (ip->i_gdquot) {
 				xfs_qm_dqdestroy(dqp);
 				dqp = ip->i_gdquot;
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-04-17 17:02:25.000000000 -0700
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-04-17 17:02:43.449003919 -0700
@@ -1591,8 +1591,10 @@ xfs_qm_quotacheck_dqadjust(
 
 	/*
 	 * Set default limits, adjust timers (since we changed usages)
+	 *
+	 * There are no timers for the default values set in the root dquot.
 	 */
-	if (! XFS_IS_SUSER_DQUOT(dqp)) {
+	if (dqp->q_core.d_id) {
 		xfs_qm_adjust_dqlimits(dqp->q_mount, &dqp->q_core);
 		xfs_qm_adjust_dqtimers(dqp->q_mount, &dqp->q_core);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
