Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3ed7145363 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8947C203857
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BdKtADSuV6J6TvR6 for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:39 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHn-00030d-2o
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:39 +0000
Message-Id: <20111028100339.043824550@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 19/45] xfs: remove the sync_mode argument to xfs_qm_dqflush_all
References: <20111028095423.796574703@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:01.234172361 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:01.742172177 +0200
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
@@ -1566,7 +1565,7 @@ xfs_qm_quotacheck(
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
