Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6W85178889 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5B89387867
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:08:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id b8cNd248ubsXuNNw for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:08:59 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xv-0000rd-HU
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:08:59 +0000
Message-Id: <20100531160859.397431345@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/17] xfs: improve xfs_isilocked
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-improve-mrlock-debug
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

Use rwsem_is_locked to make the assertations for shared locks work.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-05-29 18:09:02.083254031 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-05-29 18:11:58.194003577 +0200
@@ -741,30 +741,24 @@ xfs_ilock_demote(
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
