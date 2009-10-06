Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96KZIXq091118 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 15:35:18 -0500
Message-Id: <20091006203643.145590876@bombadil.infradead.org>
Date: Tue, 06 Oct 2009 16:29:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] [PATCH 2/5] xfs: cleanup ->sync_fs
References: <20091006202925.459164320@bombadil.infradead.org>
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
To: aelder@sgi.com, xfs@oss.sgi.com, akpm@linux-foundation.org, sfr@canb.auug.org.au
Cc: linux-fsdevel@vger.kernel.org

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
