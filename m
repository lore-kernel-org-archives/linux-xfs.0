Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3QE79hT233113 for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 09:07:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C2B3144D3E4
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:10:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZY127XHz0MJbURat for
	<xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:10:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ly50d-0008IE-Qo
	for xfs@oss.sgi.com; Sun, 26 Apr 2009 14:07:07 +0000
Message-Id: <20090426140707.713299000@bombadil.infradead.org>
Date: Sun, 26 Apr 2009 10:03:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: cleanup ->sync_fs
References: <20090426140305.113371000@bombadil.infradead.org>
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
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2009-04-26 10:39:20.433949442 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2009-04-26 10:43:31.297949640 +0200
@@ -1105,7 +1105,7 @@ xfs_fs_put_super(
 }
 
 STATIC int
-xfs_fs_sync_super(
+xfs_fs_sync_fs(
 	struct super_block	*sb,
 	int			wait)
 {
@@ -1113,23 +1113,23 @@ xfs_fs_sync_super(
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
+	 * Not much we can do fort the first async pass.  Writing out the
+	 * superblock would be contra-productive as we are going to redirty
+	 * when writing out other data and metadata (and writing out a single
+	 * block is quite fast anyway.
+	 *
+	 * Try to asynchronously kick of quota syncing at least.
 	 */
-	if (wait || unlikely(sb->s_frozen == SB_FREEZE_WRITE))
-		error = xfs_quiesce_data(mp);
-	else
-		error = xfs_sync_fsdata(mp, 0);
+	if (!wait) {
+		XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
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
@@ -1148,7 +1148,7 @@ xfs_fs_sync_super(
 				mp->m_sync_seq != prev_sync_seq);
 	}
 
-	return -error;
+	return 0;
 }
 
 STATIC int
@@ -1522,7 +1522,7 @@ static struct super_operations xfs_super
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
