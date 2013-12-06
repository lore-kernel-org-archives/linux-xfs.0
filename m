Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1863E29E2A
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 14:31:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01DE1304064
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 12:31:29 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yhbpMNMcZoj68IsC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 12:31:28 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Vp23c-0004uV-Eu
	for xfs@oss.sgi.com; Fri, 06 Dec 2013 20:31:28 +0000
Message-Id: <20131206203128.352433582@bombadil.infradead.org>
Date: Fri, 06 Dec 2013 12:30:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/11] xfs: remove xfs_iunlock_map_shared
References: <20131206203006.914776999@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-xfs_iunlock_map_shared
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We can just use xfs_iunlock without any loss of clarity.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap_util.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-12-06 19:53:52.175142705 +0100
+++ xfs/fs/xfs/xfs_bmap_util.c	2013-12-06 19:57:22.371138392 +0100
@@ -737,7 +737,7 @@ xfs_getbmap(
  out_free_map:
 	kmem_free(map);
  out_unlock_ilock:
-	xfs_iunlock_map_shared(ip, lock);
+	xfs_iunlock(ip, lock);
  out_unlock_iolock:
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2013-12-06 19:53:52.175142705 +0100
+++ xfs/fs/xfs/xfs_file.c	2013-12-06 19:57:22.371138392 +0100
@@ -1294,7 +1294,7 @@ out:
 	offset = vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
 
 out_unlock:
-	xfs_iunlock_map_shared(ip, lock);
+	xfs_iunlock(ip, lock);
 
 	if (error)
 		return -error;
@@ -1402,7 +1402,7 @@ out:
 	offset = vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
 
 out_unlock:
-	xfs_iunlock_map_shared(ip, lock);
+	xfs_iunlock(ip, lock);
 
 	if (error)
 		return -error;
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2013-12-06 19:53:52.175142705 +0100
+++ xfs/fs/xfs/xfs_inode.c	2013-12-06 19:57:33.199138169 +0100
@@ -88,8 +88,7 @@ xfs_get_extsz_hint(
  * have been read in yet, and only lock the inode exclusively if they have not.
  *
  * The function returns a value which should be given to the corresponding
- * xfs_iunlock_map_shared().  This value is the mode in which the lock was
- * actually taken.
+ * xfs_iunlock() call.
  */
 uint
 xfs_ilock_map_shared(
@@ -110,18 +109,6 @@ xfs_ilock_map_shared(
 }
 
 /*
- * This is simply the unlock routine to go with xfs_ilock_map_shared().
- * All it does is call xfs_iunlock() with the given lock_mode.
- */
-void
-xfs_iunlock_map_shared(
-	xfs_inode_t	*ip,
-	unsigned int	lock_mode)
-{
-	xfs_iunlock(ip, lock_mode);
-}
-
-/*
  * The xfs inode contains 2 locks: a multi-reader lock called the
  * i_iolock and a multi-reader lock called the i_lock.  This routine
  * allows either or both of the locks to be obtained.
@@ -590,7 +577,7 @@ xfs_lookup(
 
 	lock_mode = xfs_ilock_map_shared(dp);
 	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
-	xfs_iunlock_map_shared(dp, lock_mode);
+	xfs_iunlock(dp, lock_mode);
 
 	if (error)
 		goto out;
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2013-12-06 19:53:52.175142705 +0100
+++ xfs/fs/xfs/xfs_inode.h	2013-12-06 19:57:22.371138392 +0100
@@ -338,7 +338,6 @@ void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
 int		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_map_shared(xfs_inode_t *);
-void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
 			   xfs_nlink_t, xfs_dev_t, prid_t, int,
 			   struct xfs_buf **, xfs_inode_t **);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
