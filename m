Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BGFoRq146060 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 11:15:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19B3C14C08BE
	for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:18:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uCrGlMcbGsolRgfi for
	<xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:18:24 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1ON6w4-0002AM-Qs
	for xfs@oss.sgi.com; Fri, 11 Jun 2010 16:18:24 +0000
Date: Fri, 11 Jun 2010 12:18:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove xfs_iput_new
Message-ID: <20100611161824.GA7556@infradead.org>
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

We never get an i_mode of 0 or a locked VFS inode until we pass in the
XFS_IGET_CREATE flag to xfs_iget, which makes xfs_iput_new equivalent to
xfs_iput for the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2010-06-09 15:24:59.480253950 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_export.c	2010-06-09 15:25:16.668003845 +0200
@@ -148,7 +148,7 @@ xfs_nfs_get_inode(
 	}
 
 	if (ip->i_d.di_gen != generation) {
-		xfs_iput_new(ip, XFS_ILOCK_SHARED);
+		xfs_iput(ip, XFS_ILOCK_SHARED);
 		return ERR_PTR(-ENOENT);
 	}
 
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-06-09 15:24:59.492254229 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-06-09 15:25:11.454004125 +0200
@@ -439,29 +439,6 @@ xfs_iput(xfs_inode_t	*ip,
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
--- xfs.orig/fs/xfs/xfs_inode.h	2010-06-09 15:24:59.506253740 +0200
+++ xfs/fs/xfs/xfs_inode.h	2010-06-09 15:25:14.794005243 +0200
@@ -444,7 +444,6 @@ static inline void xfs_ifunlock(xfs_inod
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 			 uint, uint, xfs_inode_t **, xfs_daddr_t);
 void		xfs_iput(xfs_inode_t *, uint);
-void		xfs_iput_new(xfs_inode_t *, uint);
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
