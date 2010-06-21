Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XS1O113454 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 861821454F6C
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LHKnTKKvHnVX4Hip for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUC-0007cV-4m
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:08 +0000
Message-Id: <20100621083608.050065100@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/12] [PATCH] xfs: remove xfs_iput_new
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_iput_new
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

We never get an i_mode of 0 or a locked VFS inode until we pass in the
XFS_IGET_CREATE flag to xfs_iget, which makes xfs_iput_new equivalent to
xfs_iput for the only caller.  In addition to that xfs_nfs_get_inode
does not even need to lock the inode given that the generation never changes
for a life inode, so just pass a 0 lock_flags to xfs_iget and release
the inode using IRELE in the error path.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2010-06-19 23:06:53.086254161 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_export.c	2010-06-19 23:07:10.000000000 +0200
@@ -29,6 +29,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
+#include "xfs_trace.h"
 
 /*
  * Note that we only accept fileids which are long enough rather than allow
@@ -131,8 +132,7 @@ xfs_nfs_get_inode(
 	 * fine and not an indication of a corrupted filesystem as clients can
 	 * send invalid file handles and we have to handle it gracefully..
 	 */
-	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED,
-			 XFS_ILOCK_SHARED, &ip);
+	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
 	if (error) {
 		/*
 		 * EINVAL means the inode cluster doesn't exist anymore.
@@ -147,11 +147,10 @@ xfs_nfs_get_inode(
 	}
 
 	if (ip->i_d.di_gen != generation) {
-		xfs_iput_new(ip, XFS_ILOCK_SHARED);
+		IRELE(ip);
 		return ERR_PTR(-ENOENT);
 	}
 
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return VFS_I(ip);
 }
 
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-06-19 23:06:57.008263659 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-06-21 09:13:49.643254301 +0200
@@ -435,29 +435,6 @@ xfs_iput(xfs_inode_t	*ip,
 }
 
 /*
- * Special iput for brand-new inodes that are still locked
- */
-void
-xfs_iput_new(
-	xfs_inode_t	*ip,
-	uint		lock_flags)
-{
-	struct inode	*inode = VFS_I(ip);
-
-	xfs_itrace_entry(ip);
-
-	if ((ip->i_d.di_mode == 0)) {
-		ASSERT(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-		make_bad_inode(inode);
-	}
-	if (inode->i_state & I_NEW)
-		unlock_new_inode(inode);
-	if (lock_flags)
-		xfs_iunlock(ip, lock_flags);
-	IRELE(ip);
-}
-
-/*
  * This is called free all the memory associated with an inode.
  * It must free the inode itself and any buffers allocated for
  * if_extents/if_data and if_broot.  It must also free the lock
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2010-06-19 23:06:53.112024311 +0200
+++ xfs/fs/xfs/xfs_inode.h	2010-06-21 09:13:49.669254301 +0200
@@ -444,7 +444,6 @@ static inline void xfs_ifunlock(xfs_inod
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 			 uint, uint, xfs_inode_t **);
 void		xfs_iput(xfs_inode_t *, uint);
-void		xfs_iput_new(xfs_inode_t *, uint);
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
