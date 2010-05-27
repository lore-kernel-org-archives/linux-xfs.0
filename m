Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RJ3BUr157214 for <xfs@oss.sgi.com>; Thu, 27 May 2010 14:03:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70618A6B114
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 12:07:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BFggdPHOpLPalhxm for
	<xfs@oss.sgi.com>; Thu, 27 May 2010 12:07:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OHiOb-0004nS-P0
	for xfs@oss.sgi.com; Thu, 27 May 2010 19:05:33 +0000
Date: Thu, 27 May 2010 15:05:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: improve xfs_isilocked
Message-ID: <20100527190533.GB16102@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: xfs@oss.sgi.com

Use rwsem_is_locked to make the assertations for shared locks work.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-05-25 11:40:59.216005587 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-05-27 20:59:09.244004330 +0200
@@ -740,30 +738,24 @@ xfs_ilock_demote(
 }
 
 #ifdef DEBUG
-/*
- * Debug-only routine, without additional rw_semaphore APIs, we can
- * now only answer requests regarding whether we hold the lock for write
- * (reader state is outside our visibility, we only track writer state).
- *
- * Note: this means !xfs_isilocked would give false positives, so don't do that.
- */
 int
 xfs_isilocked(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
-	if ((lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) ==
-			XFS_ILOCK_EXCL) {
-		if (!ip->i_lock.mr_writer)
-			return 0;
+	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
+		if (!(lock_flags & XFS_ILOCK_SHARED))
+			return !!ip->i_lock.mr_writer;
+		return rwsem_is_locked(&ip->i_lock.mr_lock);
 	}
 
-	if ((lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) ==
-			XFS_IOLOCK_EXCL) {
-		if (!ip->i_iolock.mr_writer)
-			return 0;
+	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
+		if (!(lock_flags & XFS_IOLOCK_SHARED))
+			return !!ip->i_iolock.mr_writer;
+		return rwsem_is_locked(&ip->i_iolock.mr_lock);
 	}
 
-	return 1;
+	ASSERT(0);
+	return 0;
 }
 #endif

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
