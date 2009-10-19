Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9J43su7026092 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 23:03:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E411B1BF84D4
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 21:05:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 58x5NtWmSwQEE1Tk for
	<xfs@oss.sgi.com>; Sun, 18 Oct 2009 21:05:27 -0700 (PDT)
Date: Mon, 19 Oct 2009 00:05:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: reset the i_iolock lock class in the reclaim path
Message-ID: <20091019040526.GC21115@infradead.org>
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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

The iolock is used for protecting reads, writes and block truncates against
each other.  We have two classes of callers, the first one is induced by
a file operation and requires a reference to the inode be held and not
dropped after the operation is done:

 - xfs_vm_vmap, xfs_vn_fallocate, xfs_read, xfs_write, xfs_splice_read,
   xfs_splice_write and xfs_setattr are all implementations of VFS methods
   that require a live inode
 - xfs_getbmap and xfs_swap_extents are ioctl subcommand for which the
   same is true
 - xfs_truncate_file is only called on quota inodes just returned from xfs_iget
 - xfs_sync_inode_data does the lock just after an igrab()
 - xfs_filestream_associate and xfs_filestream_new_ag take the iolock on the
   parent inode of an inode which by VFS rules must be referenced

And we have various calls to truncate blocks past EOF or the whole file when
dropping the last reference to an inode.   Unfortunately lockdep complains
when we do memory allocations that can recurse into the filesystem in the
first class because the second class happens to take the same lock.  To avoid
this re-init the iolock in the beginning of xfs_fs_clear_inode to get
a new lock class.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-10-14 17:24:31.356278624 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-10-19 06:03:05.771006625 +0200
@@ -999,7 +999,6 @@ xfs_fs_inode_init_once(
 
 	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
 		     "xfsino", ip->i_ino);
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
 }
 
 /*
@@ -1101,6 +1100,22 @@ xfs_fs_clear_inode(
 	XFS_STATS_INC(vn_remove);
 	XFS_STATS_DEC(vn_active);
 
+	/*
+	 * The iolock is used for protecting reads, writes and block truncates
+	 * against each other.  We have two classes of callers, the first one
+	 * is induced by a file operation and requires a reference to the
+	 * inode be held and not dropped after the operation is done, and
+	 * second we have various calls to truncate blocks past EOF or for the
+	 * whole file when dropping the last reference to an inode.
+	 * Unfortunately lockdep complains when we do memory allocations that
+	 * can recurse into the filesystem in the first class because the
+	 * second class happens to take the same lock.  To avoid this
+	 * reinitialize the iolock in the beginning of xfs_fs_clear_inode to
+	 * get a new lock class.
+	 */
+	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
+	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+
 	xfs_inactive(ip);
 }
 
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2009-10-14 17:25:26.733004131 +0200
+++ xfs/fs/xfs/xfs_iget.c	2009-10-14 17:28:26.272274357 +0200
@@ -73,6 +73,9 @@ xfs_inode_alloc(
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(completion_done(&ip->i_flush));
+	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
+
+	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
 
 	/* initialise the xfs inode */
 	ip->i_ino = ino;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
