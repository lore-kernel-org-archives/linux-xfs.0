Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTMJECw009589 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 16:19:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B0F2A59429
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:19:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tVYMHqWXHhNhnHGm for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:19:14 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LHQRf-0002ei-Ii
	for xfs@oss.sgi.com; Mon, 29 Dec 2008 22:18:43 +0000
Message-Id: <20081229221843.492712000@bombadil.infradead.org>
References: <20081229221802.268877000@bombadil.infradead.org>
Date: Mon, 29 Dec 2008 17:18:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 2/3] lockdep annotations for xfs_dqlock2
Content-Disposition: inline; filename=xfs-fix-xfs_dqlock2-lockdep-warning
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

xfs_dqlock2 locks two xfs_dquots, which is fine as it always locks the
dquot with the lower id first.  Use mutex_lock_nested to tell lockdep
about this fact.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2008-12-29 11:28:54.459613573 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.c	2008-12-29 11:29:31.037738842 +0100
@@ -1383,6 +1383,12 @@ xfs_dqunlock_nonotify(
 	mutex_unlock(&(dqp->q_qlock));
 }
 
+/*
+ * Lock two xfs_dquot structures.
+ *
+ * To avoid deadlocks we always lock the quota structure with
+ * the lowerd id first.
+ */
 void
 xfs_dqlock2(
 	xfs_dquot_t	*d1,
@@ -1393,10 +1399,10 @@ xfs_dqlock2(
 		if (be32_to_cpu(d1->q_core.d_id) >
 		    be32_to_cpu(d2->q_core.d_id)) {
 			xfs_dqlock(d2);
-			xfs_dqlock(d1);
+			mutex_lock_nested(&d1->q_qlock, XFS_QLOCK_2ND);
 		} else {
 			xfs_dqlock(d1);
-			xfs_dqlock(d2);
+			mutex_lock_nested(&d2->q_qlock, XFS_QLOCK_2ND);
 		}
 	} else {
 		if (d1) {
Index: xfs/fs/xfs/quota/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.h	2008-12-27 17:55:09.920686659 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.h	2008-12-29 11:29:31.043768451 +0100
@@ -97,6 +97,16 @@ typedef struct xfs_dquot {
 #define dq_hashlist	q_lists.dqm_hashlist
 #define dq_flags	q_lists.dqm_flags
 
+/*
+ * Lock hierachy for q_qlock:
+ *	XFS_QLOCK_NORMAL is the implicit default,
+ * 	XFS_QLOCK_DOUBLE is the dquot with the higher id in xfs_dqlock2
+ */
+enum {
+	XFS_QLOCK_NORMAL = 0,
+	XFS_QLOCK_2ND,
+};
+
 #define XFS_DQHOLD(dqp)		((dqp)->q_nrefs++)
 
 #ifdef DEBUG

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
