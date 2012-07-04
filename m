Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64FEj6E223609 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 10:14:45 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	70ZhOBHB7a8djdJS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 08:14:45 -0700 (PDT)
Message-Id: <20120704151444.401872600@bombadil.infradead.org>
Date: Wed, 04 Jul 2012 11:13:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: remove iolock lock classes
References: <20120704151328.928543446@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2178355642020433553=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: sage@newdream.net

--===============2178355642020433553==
Content-Disposition: inline; filename=xfs-remove-iolock-classes

Now that we never take the iolock during inode reclaim we don't need
to play games with lock classes.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_iget.c  |   15 ---------------
 fs/xfs/xfs_inode.h |    2 --
 fs/xfs/xfs_super.c |   18 ++----------------
 3 files changed, 2 insertions(+), 33 deletions(-)

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2012-06-04 13:45:36.000000000 +0200
+++ xfs/fs/xfs/xfs_iget.c	2012-07-04 15:08:58.517051204 +0200
@@ -41,17 +41,6 @@
 
 
 /*
- * Define xfs inode iolock lockdep classes. We need to ensure that all active
- * inodes are considered the same for lockdep purposes, including inodes that
- * are recycled through the XFS_IRECLAIMABLE state. This is the the only way to
- * guarantee the locks are considered the same when there are multiple lock
- * initialisation siteѕ. Also, define a reclaimable inode class so it is
- * obvious in lockdep reports which class the report is against.
- */
-static struct lock_class_key xfs_iolock_active;
-struct lock_class_key xfs_iolock_reclaimable;
-
-/*
  * Allocate and initialise an xfs_inode.
  */
 STATIC struct xfs_inode *
@@ -80,8 +69,6 @@ xfs_inode_alloc(
 	ASSERT(ip->i_ino == 0);
 
 	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-	lockdep_set_class_and_name(&ip->i_iolock.mr_lock,
-			&xfs_iolock_active, "xfs_iolock_active");
 
 	/* initialise the xfs inode */
 	ip->i_ino = ino;
@@ -250,8 +237,6 @@ xfs_iget_cache_hit(
 
 		ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
 		mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-		lockdep_set_class_and_name(&ip->i_iolock.mr_lock,
-				&xfs_iolock_active, "xfs_iolock_active");
 
 		spin_unlock(&ip->i_flags_lock);
 		spin_unlock(&pag->pag_ici_lock);
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2012-07-03 20:31:33.533706239 +0200
+++ xfs/fs/xfs/xfs_inode.h	2012-07-04 15:08:51.413717911 +0200
@@ -487,8 +487,6 @@ static inline int xfs_isiflocked(struct
 #define XFS_IOLOCK_DEP(flags)	(((flags) & XFS_IOLOCK_DEP_MASK) >> XFS_IOLOCK_SHIFT)
 #define XFS_ILOCK_DEP(flags)	(((flags) & XFS_ILOCK_DEP_MASK) >> XFS_ILOCK_SHIFT)
 
-extern struct lock_class_key xfs_iolock_reclaimable;
-
 /*
  * For multiple groups support: if S_ISGID bit is set in the parent
  * directory, group of new file is set to that of the parent, and
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2012-07-02 12:11:56.435779819 +0200
+++ xfs/fs/xfs/xfs_super.c	2012-07-04 15:08:44.667051287 +0200
@@ -929,6 +929,8 @@ xfs_fs_evict_inode(
 {
 	xfs_inode_t		*ip = XFS_I(inode);
 
+	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
+
 	trace_xfs_evict_inode(ip);
 
 	truncate_inode_pages(&inode->i_data, 0);
@@ -937,22 +939,6 @@ xfs_fs_evict_inode(
 	XFS_STATS_INC(vn_remove);
 	XFS_STATS_DEC(vn_active);
 
-	/*
-	 * The iolock is used by the file system to coordinate reads,
-	 * writes, and block truncates.  Up to this point the lock
-	 * protected concurrent accesses by users of the inode.  But
-	 * from here forward we're doing some final processing of the
-	 * inode because we're done with it, and although we reuse the
-	 * iolock for protection it is really a distinct lock class
-	 * (in the lockdep sense) from before.  To keep lockdep happy
-	 * (and basically indicate what we are doing), we explicitly
-	 * re-init the iolock here.
-	 */
-	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-	lockdep_set_class_and_name(&ip->i_iolock.mr_lock,
-			&xfs_iolock_reclaimable, "xfs_iolock_reclaimable");
-
 	xfs_inactive(ip);
 }
 


--===============2178355642020433553==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2178355642020433553==--
