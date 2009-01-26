Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7XjUC203940 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:33:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5495AB75EF
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:33:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sM2yck1ZidEw8hWK for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:33:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwx-000382-LN
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:03 +0000
Message-Id: <20090126073203.550396000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/17] xfs: use mutex_is_locked in XFS_DQ_IS_LOCKED
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-XFS_DQ_IS_LOCKED-use-mutex_is_locked
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

Now that we have a helper to test if a mutex is held use it instead of our
own little hacks.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.h	2008-12-30 09:58:43.271493395 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.h	2008-12-30 09:59:38.831495515 +0100
@@ -109,19 +109,6 @@ enum {
 
 #define XFS_DQHOLD(dqp)		((dqp)->q_nrefs++)
 
-#ifdef DEBUG
-static inline int
-XFS_DQ_IS_LOCKED(xfs_dquot_t *dqp)
-{
-	if (mutex_trylock(&dqp->q_qlock)) {
-		mutex_unlock(&dqp->q_qlock);
-		return 0;
-	}
-	return 1;
-}
-#endif
-
-
 /*
  * Manage the q_flush completion queue embedded in the dquot.  This completion
  * queue synchronizes processes attempting to flush the in-core dquot back to
@@ -142,6 +129,7 @@ static inline void xfs_dqfunlock(xfs_dqu
 	complete(&dqp->q_flush);
 }
 
+#define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_ON_FREELIST(dqp)  ((dqp)->dq_flnext != (dqp))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
