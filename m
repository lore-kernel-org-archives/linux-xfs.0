Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0CFGGiS024270 for <xfs@oss.sgi.com>; Mon, 12 Jan 2009 09:16:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CE0B7E9E1
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2009 07:16:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id URPrOnP4KtygG4iE for
	<xfs@oss.sgi.com>; Mon, 12 Jan 2009 07:16:15 -0800 (PST)
Date: Mon, 12 Jan 2009 10:15:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] xfs: lockdep annotations for xfs_dqlock2
Message-ID: <20090112151544.GA25507@infradead.org>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221300.520949000@bombadil.infradead.org>
	<20090111230637.GE8071@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090111230637.GE8071@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 12, 2009 at 10:06:37AM +1100, Dave Chinner wrote:
> This looks a bit wierd.
> 
> Yes, xfs_dqlock() is just a wrapper around mutex_lock, but we should
> be consistent here. Can you add a xfs_dqlock_nested() wrapper to do
> this?

I don't think we should add more of the silly wrappers.  What about
the version below that always uses plain mutex_lock* in xfs_dqlock2?

---

Subject: xfs: lockdep annotations for xfs_dqlock2
From: Christoph Hellwig <hch@lst.de>

xfs_dqlock2 locks two xfs_dquots, which is fine as it always locks the
dquot with the lower id first.  Use mutex_lock_nested to tell lockdep 
about this fact.  Also clean up xfs_dqlock2 a bit by rationalizing
the conditionals and always using the mutex_lock family of functions
directly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2009-01-12 14:37:49.445796033 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.c	2009-01-12 14:46:59.913795998 +0100
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
@@ -1392,18 +1398,16 @@ xfs_dqlock2(
 		ASSERT(d1 != d2);
 		if (be32_to_cpu(d1->q_core.d_id) >
 		    be32_to_cpu(d2->q_core.d_id)) {
-			xfs_dqlock(d2);
-			xfs_dqlock(d1);
+			mutex_lock(&d2->q_qlock);
+			mutex_lock_nested(&d1->q_qlock, XFS_QLOCK_NESTED);
 		} else {
-			xfs_dqlock(d1);
-			xfs_dqlock(d2);
-		}
-	} else {
-		if (d1) {
-			xfs_dqlock(d1);
-		} else if (d2) {
-			xfs_dqlock(d2);
+			mutex_lock(&d1->q_qlock);
+			mutex_lock_nested(&d2->q_qlock, XFS_QLOCK_NESTED);
 		}
+	} else if (d1) {
+		mutex_lock(&d1->q_qlock);
+	} else if (d2) {
+		mutex_lock(&d2->q_qlock);
 	}
 }
 
Index: xfs/fs/xfs/quota/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.h	2009-01-12 14:37:49.459795861 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.h	2009-01-12 14:45:30.902817471 +0100
@@ -97,6 +97,16 @@ typedef struct xfs_dquot {
 #define dq_hashlist	q_lists.dqm_hashlist
 #define dq_flags	q_lists.dqm_flags
 
+/*
+ * Lock hierachy for q_qlock:
+ *	XFS_QLOCK_NORMAL is the implicit default,
+ * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
+ */
+enum {
+	XFS_QLOCK_NORMAL = 0,
+	XFS_QLOCK_NESTED,
+};
+
 #define XFS_DQHOLD(dqp)		((dqp)->q_nrefs++)
 
 #ifdef DEBUG

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
