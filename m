Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7XGg2203870 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:33:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D848B75E7
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 73RHiEnVuSh1G3BT for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:34 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwx-00037N-G4
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:03 +0000
Message-Id: <20090126073203.388857000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 15/17] xfs: remove
	XFS_QM_LOCK/XFS_QM_UNLOCK/XFS_QM_HOLD/XFS_QM_RELE
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_QM_LOCK
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

Remove these macros which only obsfucated the code in rather nast ways.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2008-12-30 20:38:36.144493445 +0100
+++ xfs/fs/xfs/quota/xfs_qm.c	2008-12-30 21:55:41.865496758 +0100
@@ -219,7 +219,7 @@ xfs_qm_hold_quotafs_ref(
 	 * the structure could disappear between the entry to this routine and
 	 * a HOLD operation if not locked.
 	 */
-	XFS_QM_LOCK(xfs_Gqm);
+	mutex_lock(&xfs_Gqm_lock);
 
 	if (xfs_Gqm == NULL)
 		xfs_Gqm = xfs_Gqm_init();
@@ -228,8 +228,8 @@ xfs_qm_hold_quotafs_ref(
 	 * debugging and statistical purposes, but ...
 	 * Just take a reference and get out.
 	 */
-	XFS_QM_HOLD(xfs_Gqm);
-	XFS_QM_UNLOCK(xfs_Gqm);
+	xfs_Gqm->qm_nrefs++;
+	mutex_unlock(&xfs_Gqm_lock);
 
 	return 0;
 }
@@ -277,13 +277,12 @@ xfs_qm_rele_quotafs_ref(
 	 * Destroy the entire XQM. If somebody mounts with quotaon, this'll
 	 * be restarted.
 	 */
-	XFS_QM_LOCK(xfs_Gqm);
-	XFS_QM_RELE(xfs_Gqm);
-	if (xfs_Gqm->qm_nrefs == 0) {
+	mutex_lock(&xfs_Gqm_lock);
+	if (--xfs_Gqm->qm_nrefs == 0) {
 		xfs_qm_destroy(xfs_Gqm);
 		xfs_Gqm = NULL;
 	}
-	XFS_QM_UNLOCK(xfs_Gqm);
+	mutex_unlock(&xfs_Gqm_lock);
 }
 
 /*
Index: xfs/fs/xfs/quota/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.h	2008-12-30 20:38:32.989527673 +0100
+++ xfs/fs/xfs/quota/xfs_qm.h	2008-12-30 21:15:23.500493377 +0100
@@ -158,11 +158,6 @@ typedef struct xfs_dquot_acct {
 #define XFS_QM_IWARNLIMIT	5
 #define XFS_QM_RTBWARNLIMIT	5
 
-#define XFS_QM_LOCK(xqm)	(mutex_lock(&xqm##_lock))
-#define XFS_QM_UNLOCK(xqm)	(mutex_unlock(&xqm##_lock))
-#define XFS_QM_HOLD(xqm)	((xqm)->qm_nrefs++)
-#define XFS_QM_RELE(xqm)	((xqm)->qm_nrefs--)
-
 extern void		xfs_qm_destroy_quotainfo(xfs_mount_t *);
 extern void		xfs_qm_mount_quotas(xfs_mount_t *);
 extern int		xfs_qm_quotacheck(xfs_mount_t *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
