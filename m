Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS8Scsu225872 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 02:28:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 872954FAB1A
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 00:28:37 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	eN3HEb62AAP2YeJv for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 00:28:37 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RUwZo-0000v2-TF
	for xfs@oss.sgi.com; Mon, 28 Nov 2011 08:28:36 +0000
Message-Id: <20111128082836.852396783@bombadil.infradead.org>
Date: Mon, 28 Nov 2011 03:27:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/16] xfs: remove the sync_mode argument to xfs_qm_dqflush_all
References: <20111128082722.604873274@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-xfs_qm_dqflush_all-sync-mode
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

It always is zero, and removing it will make future changes easier.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_qm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-11-25 11:45:37.468716258 +0100
+++ xfs/fs/xfs/xfs_qm.c	2011-11-25 11:45:39.375372594 +0100
@@ -415,8 +415,7 @@ xfs_qm_unmount_quotas(
  */
 STATIC int
 xfs_qm_dqflush_all(
-	struct xfs_mount	*mp,
-	int			sync_mode)
+	struct xfs_mount	*mp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	int			recl;
@@ -451,7 +450,7 @@ again:
 		 * across a disk write.
 		 */
 		mutex_unlock(&q->qi_dqlist_lock);
-		error = xfs_qm_dqflush(dqp, sync_mode);
+		error = xfs_qm_dqflush(dqp, 0);
 		xfs_dqunlock(dqp);
 		if (error)
 			return error;
@@ -1567,7 +1566,7 @@ xfs_qm_quotacheck(
 	 * successfully.
 	 */
 	if (!error)
-		error = xfs_qm_dqflush_all(mp, 0);
+		error = xfs_qm_dqflush_all(mp);
 
 	/*
 	 * We can get this error if we couldn't do a dquot allocation inside

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
