Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6Lwtmh003920 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 15:58:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95C2E1F45C03
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 13:58:54 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GGx3CBaJq2cQ6zy5 for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 13:58:54 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RY32M-0006P4-2Q
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 21:58:54 +0000
Message-Id: <20111206215854.044527580@bombadil.infradead.org>
Date: Tue, 06 Dec 2011 16:58:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 08/19] xfs: cleanup dquot locking helpers
References: <20111206215806.844405397@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-cleanup-locking-helpers
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

Mark the trivial lock wrappers as inline, and make the naming consistent
for all of them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_dquot.c      |   31 ++++---------------------------
 fs/xfs/xfs_dquot.h      |   25 +++++++++++++++++++------
 fs/xfs/xfs_dquot_item.c |    2 +-
 fs/xfs/xfs_qm.c         |    2 +-
 4 files changed, 25 insertions(+), 35 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-11-25 11:45:32.668742260 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2011-11-25 11:45:41.458694642 +0100
@@ -1257,40 +1257,17 @@ xfs_qm_dqflush(
 
 }
 
-int
-xfs_qm_dqlock_nowait(
-	xfs_dquot_t *dqp)
-{
-	return mutex_trylock(&dqp->q_qlock);
-}
-
-void
-xfs_dqlock(
-	xfs_dquot_t *dqp)
-{
-	mutex_lock(&dqp->q_qlock);
-}
-
 void
 xfs_dqunlock(
 	xfs_dquot_t *dqp)
 {
-	mutex_unlock(&(dqp->q_qlock));
+	xfs_dqunlock_nonotify(dqp);
 	if (dqp->q_logitem.qli_dquot == dqp) {
-		/* Once was dqp->q_mount, but might just have been cleared */
 		xfs_trans_unlocked_item(dqp->q_logitem.qli_item.li_ailp,
-					(xfs_log_item_t*)&(dqp->q_logitem));
+					&dqp->q_logitem.qli_item);
 	}
 }
 
-
-void
-xfs_dqunlock_nonotify(
-	xfs_dquot_t *dqp)
-{
-	mutex_unlock(&(dqp->q_qlock));
-}
-
 /*
  * Lock two xfs_dquot structures.
  *
@@ -1370,7 +1347,7 @@ xfs_qm_dqpurge(
 		 * Block on the flush lock after nudging dquot buffer,
 		 * if it is incore.
 		 */
-		xfs_qm_dqflock_pushbuf_wait(dqp);
+		xfs_dqflock_pushbuf_wait(dqp);
 	}
 
 	/*
@@ -1427,7 +1404,7 @@ xfs_qm_dqpurge(
  * wait on the flush lock.
  */
 void
-xfs_qm_dqflock_pushbuf_wait(
+xfs_dqflock_pushbuf_wait(
 	xfs_dquot_t	*dqp)
 {
 	xfs_mount_t	*mp = dqp->q_mount;
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2011-11-05 08:54:00.492993239 +0100
+++ xfs/fs/xfs/xfs_dquot.h	2011-11-25 11:45:41.458694642 +0100
@@ -102,6 +102,21 @@ static inline void xfs_dqfunlock(xfs_dqu
 	complete(&dqp->q_flush);
 }
 
+static inline int xfs_dqlock_nowait(struct xfs_dquot *dqp)
+{
+	return mutex_trylock(&dqp->q_qlock);
+}
+
+static inline void xfs_dqlock(struct xfs_dquot *dqp)
+{
+	mutex_lock(&dqp->q_qlock);
+}
+
+static inline void xfs_dqunlock_nonotify(struct xfs_dquot *dqp)
+{
+	mutex_unlock(&dqp->q_qlock);
+}
+
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
@@ -120,8 +135,6 @@ extern void		xfs_qm_dqdestroy(xfs_dquot_
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
 extern int		xfs_qm_dqpurge(xfs_dquot_t *);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
-extern int		xfs_qm_dqlock_nowait(xfs_dquot_t *);
-extern void		xfs_qm_dqflock_pushbuf_wait(xfs_dquot_t *dqp);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);
 extern void		xfs_qm_adjust_dqlimits(xfs_mount_t *,
@@ -129,9 +142,9 @@ extern void		xfs_qm_adjust_dqlimits(xfs_
 extern int		xfs_qm_dqget(xfs_mount_t *, xfs_inode_t *,
 					xfs_dqid_t, uint, uint, xfs_dquot_t **);
 extern void		xfs_qm_dqput(xfs_dquot_t *);
-extern void		xfs_dqlock(xfs_dquot_t *);
-extern void		xfs_dqlock2(xfs_dquot_t *, xfs_dquot_t *);
-extern void		xfs_dqunlock(xfs_dquot_t *);
-extern void		xfs_dqunlock_nonotify(xfs_dquot_t *);
+
+extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+extern void		xfs_dqunlock(struct xfs_dquot *);
+extern void		xfs_dqflock_pushbuf_wait(struct xfs_dquot *dqp);
 
 #endif /* __XFS_DQUOT_H__ */
Index: xfs/fs/xfs/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-11-25 11:45:32.668742260 +0100
+++ xfs/fs/xfs/xfs_dquot_item.c	2011-11-25 11:45:41.462027957 +0100
@@ -236,7 +236,7 @@ xfs_qm_dquot_logitem_trylock(
 	if (atomic_read(&dqp->q_pincount) > 0)
 		return XFS_ITEM_PINNED;
 
-	if (!xfs_qm_dqlock_nowait(dqp))
+	if (!xfs_dqlock_nowait(dqp))
 		return XFS_ITEM_LOCKED;
 
 	if (!xfs_dqflock_nowait(dqp)) {
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-11-25 11:45:39.375372594 +0100
+++ xfs/fs/xfs/xfs_qm.c	2011-11-25 11:45:41.462027957 +0100
@@ -443,7 +443,7 @@ again:
 			 * out immediately.  We'll be able to acquire
 			 * the flush lock when the I/O completes.
 			 */
-			xfs_qm_dqflock_pushbuf_wait(dqp);
+			xfs_dqflock_pushbuf_wait(dqp);
 		}
 		/*
 		 * Let go of the mplist lock. We don't want to hold it

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
