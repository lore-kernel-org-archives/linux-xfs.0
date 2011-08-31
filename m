Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VKcLjg226687 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:38:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D60CF12A5D6
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 13:38:18 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	84LW1pHRoCUdTLw9 for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 13:38:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyrYA-0006xo-7U
	for xfs@oss.sgi.com; Wed, 31 Aug 2011 20:38:18 +0000
Message-Id: <20110831203818.174153927@bombadil.infradead.org>
Date: Wed, 31 Aug 2011 16:36:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/14] xfs: untange SYNC_WAIT and SYNC_TRYLOCK meanings for
	xfs_qm_dqflush
References: <20110831203647.455809764@bombadil.infradead.org>
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

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-08-29 14:27:43.171545891 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-08-29 14:28:00.308211691 +0200
@@ -1166,7 +1166,7 @@ xfs_qm_dqflush(
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
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-08-29 14:28:26.114877052 +0200
+++ xfs/fs/xfs/xfs_dquot_item.c	2011-08-29 14:29:06.194875023 +0200
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
--- xfs.orig/fs/xfs/xfs_qm.c	2011-08-29 14:28:26.131543717 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-08-29 14:30:29.704870793 +0200
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
