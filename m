Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3de2145350 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DEE3203849
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DS4WLcthSSN8BHXa for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHm-0002yy-IJ
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:38 +0000
Message-Id: <20111028100338.514116680@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/45] xfs: untange SYNC_WAIT and SYNC_TRYLOCK meanings for
	xfs_qm_dqflush
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dquota-cleanup-SYNC_-flags
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

Only skip pinned dquots if SYNC_TRYLOCK is specified, and adjust the callers
to keep the behaviour unchanged.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c      |    2 +-
 fs/xfs/xfs_dquot_item.c |    2 +-
 fs/xfs/xfs_qm.c         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:39:34.952673735 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:00.076675206 +0200
@@ -1169,7 +1169,7 @@ xfs_qm_dqflush(
 	 * If not dirty, or it's pinned and we are not supposed to block, nada.
 	 */
 	if (!XFS_DQ_IS_DIRTY(dqp) ||
-	    (!(flags & SYNC_WAIT) && atomic_read(&dqp->q_pincount) > 0)) {
+	    ((flags & SYNC_TRYLOCK) && atomic_read(&dqp->q_pincount) > 0)) {
 		xfs_dqfunlock(dqp);
 		return 0;
 	}
Index: xfs/fs/xfs/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-10-27 22:39:42.528674212 +0200
+++ xfs/fs/xfs/xfs_dquot_item.c	2011-10-27 22:40:00.080676002 +0200
@@ -134,7 +134,7 @@ xfs_qm_dquot_logitem_push(
 	 * lock without sleeping, then there must not have been
 	 * anyone in the process of flushing the dquot.
 	 */
-	error = xfs_qm_dqflush(dqp, 0);
+	error = xfs_qm_dqflush(dqp, SYNC_TRYLOCK);
 	if (error)
 		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
 			__func__, error, dqp);
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:39:34.980673855 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:00.080676002 +0200
@@ -1660,7 +1660,7 @@ xfs_qm_quotacheck(
 	 * successfully.
 	 */
 	if (!error)
-		error = xfs_qm_dqflush_all(mp, 0);
+		error = xfs_qm_dqflush_all(mp, SYNC_TRYLOCK);
 
 	/*
 	 * We can get this error if we couldn't do a dquot allocation inside

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
