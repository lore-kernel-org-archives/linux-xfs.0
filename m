Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 08:01:58 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kATG1oaG005193
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 08:01:52 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id kATFlUWv006874
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 16:47:30 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id kATFlTaU006866
	for xfs@oss.sgi.com; Wed, 29 Nov 2006 16:47:29 +0100
Date: Wed, 29 Nov 2006 16:47:29 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove v_number
Message-ID: <20061129154729.GC6400@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

v_number is unused except for the naming some locks (which is a
functionality totally unused by Linux), so remove it and assorted
crap.  Besides saving two words in struct vnode this also gets rid
of a spinlock per inode allocation.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_vnode.c	2006-11-29 16:37:23.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_vnode.c	2006-11-29 16:38:09.000000000 +0100
@@ -17,8 +17,6 @@
  */
 #include "xfs.h"
 
-uint64_t vn_generation;		/* vnode generation number */
-DEFINE_SPINLOCK(vnumber_lock);
 
 /*
  * Dedicated vnode inactive/reclaim sync semaphores.
@@ -82,12 +80,6 @@
 	vp->v_flag = VMODIFIED;
 	spinlock_init(&vp->v_lock, "v_lock");
 
-	spin_lock(&vnumber_lock);
-	if (!++vn_generation)	/* v_number shouldn't be zero */
-		vn_generation++;
-	vp->v_number = vn_generation;
-	spin_unlock(&vnumber_lock);
-
 	ASSERT(VN_CACHED(vp) == 0);
 
 	/* Initialize the first behavior and the behavior chain head. */
Index: linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_vnode.h	2006-11-29 16:38:13.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h	2006-11-29 16:39:08.000000000 +0100
@@ -41,7 +41,6 @@
 typedef struct bhv_vnode {
 	bhv_vflags_t	v_flag;			/* vnode flags (see above) */
 	bhv_vfs_t	*v_vfsp;		/* ptr to containing VFS */
-	bhv_vnumber_t	v_number;		/* in-core vnode number */
 	bhv_head_t	v_bh;			/* behavior head */
 	spinlock_t	v_lock;			/* VN_LOCK/VN_UNLOCK */
 	atomic_t	v_iocount;		/* outstanding I/O count */
Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2006-11-29 16:36:19.000000000 +0100
+++ linux-2.6/fs/xfs/xfs_iget.c	2006-11-29 16:37:14.000000000 +0100
@@ -570,8 +570,8 @@
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
