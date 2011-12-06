Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6LwteB003910 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 15:58:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7F451566FE3
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 13:58:54 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DGsv9pFA5rPnHX1M for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 13:58:54 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RY32L-0006OW-Ro
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 21:58:53 +0000
Message-Id: <20111206215853.809602126@bombadil.infradead.org>
Date: Tue, 06 Dec 2011 16:58:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 07/19] xfs: remove the sync_mode argument to xfs_qm_dqflush_all
References: <20111206215806.844405397@bombadil.infradead.org>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>

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
