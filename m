Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7RNF5rC116155 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 18:15:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0C9F1569759
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 16:15:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jBRVcG7qGDRRM713 for
	<xfs@oss.sgi.com>; Thu, 27 Aug 2009 16:15:58 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MgoCE-0000bs-I8
	for xfs@oss.sgi.com; Thu, 27 Aug 2009 23:15:58 +0000
Message-Id: <20090827231558.379824160@bombadil.infradead.org>
Date: Thu, 27 Aug 2009 19:15:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] [PATCH 2/5] xfs: cleanup ->sync_fs
References: <20090827231536.646792672@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-sync_fs
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

Sort out ->sync_fs to not perform a superblock writeback for the wait = 0 case
as that is just an optional first pass and the superblock will be written back
properly in the next call with wait = 1.  Instead perform an opportunistic
quota writeback to have less work later.  Also remove the freeze special case
as we do a proper wait = 1 call in the freeze code anyway.

Also rename the function to xfs_fs_sync_fs to match the normal naming
convention, update comments and avoid calling into the laptop_mode logic on
an error.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2009-08-26 20:13:54.609362865 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2009-08-26 20:18:36.065357266 -0300
@@ -1144,7 +1144,7 @@ xfs_fs_put_super(
 }
 
 STATIC int
-xfs_fs_sync_super(
+xfs_fs_sync_fs(
 	struct super_block	*sb,
 	int			wait)
 {
@@ -1152,23 +1152,23 @@ xfs_fs_sync_super(
 	int			error;
 
 	/*
-	 * Treat a sync operation like a freeze.  This is to work
-	 * around a race in sync_inodes() which works in two phases
-	 * - an asynchronous flush, which can write out an inode
-	 * without waiting for file size updates to complete, and a
-	 * synchronous flush, which wont do anything because the
-	 * async flush removed the inode's dirty flag.  Also
-	 * sync_inodes() will not see any files that just have
-	 * outstanding transactions to be flushed because we don't
-	 * dirty the Linux inode until after the transaction I/O
-	 * completes.
+	 * Not much we can do for the first async pass.  Writing out the
+	 * superblock would be counter-productive as we are going to redirty
+	 * when writing out other data and metadata (and writing out a single
+	 * block is quite fast anyway).
+	 *
+	 * Try to asynchronously kick off quota syncing at least.
 	 */
-	if (wait || unlikely(sb->s_frozen == SB_FREEZE_WRITE))
-		error = xfs_quiesce_data(mp);
-	else
-		error = xfs_sync_fsdata(mp, 0);
+	if (!wait) {
+		xfs_qm_sync(mp, SYNC_TRYLOCK);
+		return 0;
+	}
+
+	error = xfs_quiesce_data(mp);
+	if (error)
+		return -error;
 
-	if (unlikely(laptop_mode)) {
+	if (laptop_mode) {
 		int	prev_sync_seq = mp->m_sync_seq;
 
 		/*
@@ -1187,7 +1187,7 @@ xfs_fs_sync_super(
 				mp->m_sync_seq != prev_sync_seq);
 	}
 
-	return -error;
+	return 0;
 }
 
 STATIC int
@@ -1561,7 +1561,7 @@ static struct super_operations xfs_super
 	.write_inode		= xfs_fs_write_inode,
 	.clear_inode		= xfs_fs_clear_inode,
 	.put_super		= xfs_fs_put_super,
-	.sync_fs		= xfs_fs_sync_super,
+	.sync_fs		= xfs_fs_sync_fs,
 	.freeze_fs		= xfs_fs_freeze,
 	.statfs			= xfs_fs_statfs,
 	.remount_fs		= xfs_fs_remount,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
