Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:39:03 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJct4p003784
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:39:00 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJcsA5008601
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:38:54 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJcs37008599
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:38:54 +0200
Date: Thu, 23 Aug 2007 21:38:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/17] kill the v_number member in struct bhv_vnode
Message-ID: <20070823193854.GH8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

It's entirely unused except for ignored arguments in the mrlock
initialization, so remove it.

Note that Dave wanted to keep it last time I posted this, but there is no
chance for that as struct bhv_vnode is going away.  If you really need it
I offer to write a patch that adds a debug-only i_sequence to
struct xfs_inode when needed.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 14:54:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 14:54:02.000000000 +0200
@@ -31,8 +31,6 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 
-uint64_t vn_generation;		/* vnode generation number */
-DEFINE_SPINLOCK(vnumber_lock);
 
 /*
  * Dedicated vnode inactive/reclaim sync semaphores.
@@ -95,12 +93,6 @@ vn_initialize(
 	XFS_STATS_INC(vn_active);
 	XFS_STATS_INC(vn_alloc);
 
-	spin_lock(&vnumber_lock);
-	if (!++vn_generation)	/* v_number shouldn't be zero */
-		vn_generation++;
-	vp->v_number = vn_generation;
-	spin_unlock(&vnumber_lock);
-
 	ASSERT(VN_CACHED(vp) == 0);
 
 	return vp;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 14:54:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 14:54:02.000000000 +0200
@@ -28,7 +28,6 @@ typedef struct dentry	bhv_vname_t;
 typedef __u64		bhv_vnumber_t;
 
 typedef struct bhv_vnode {
-	bhv_vnumber_t	v_number;		/* in-core vnode number */
 	struct inode	v_inode;		/* Linux inode */
 	/* inode MUST be last */
 } bhv_vnode_t;
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2007-08-23 14:54:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2007-08-23 14:54:02.000000000 +0200
@@ -431,8 +431,8 @@ xfs_inode_lock_init(
 	bhv_vnode_t	*vp)
 {
 	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
-		     "xfsino", (long)vp->v_number);
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", vp->v_number);
+		     "xfsino", ip->i_ino);
+	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
 	init_waitqueue_head(&ip->i_ipin_wait);
 	atomic_set(&ip->i_pincount, 0);
 	initnsema(&ip->i_flock, 1, "xfsfino");
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-08-23 14:54:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-08-23 14:54:02.000000000 +0200
@@ -1780,10 +1780,7 @@ static void printbhv(bhv_desc_t *bdp)
 static void	printvnode(bhv_vnode_t *vp, unsigned long addr)
 {
 	kdb_printf("vnode: 0x%lx\n", addr);
-
 	kdb_printf("\n");
-
-	kdb_printf("   v_number 0x%llx\n", (unsigned long long)vp->v_number);
 }
 
 static int	kdbm_vnode(
