Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:38:28 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJcK4p003159
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:38:23 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJcJA5008538
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:38:19 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJcJsk008536
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:38:19 +0200
Date: Thu, 23 Aug 2007 21:38:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/17] move v_iocount from bhv_vnode to xfs_inode
Message-ID: <20070823193818.GF8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

struct bhv_vnode is on it's way out, so move the I/O count to the XFS inode.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:46:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:51:38.000000000 +0200
@@ -140,9 +140,11 @@ xfs_destroy_ioend(
 		next = bh->b_private;
 		bh->b_end_io(bh, !ioend->io_error);
 	}
-	if (unlikely(ioend->io_error))
-		vn_ioerror(ioend->io_vnode, ioend->io_error, __FILE__,__LINE__);
-	vn_iowake(ioend->io_vnode);
+	if (unlikely(ioend->io_error)) {
+		vn_ioerror(XFS_I(ioend->io_inode), ioend->io_error,
+				__FILE__,__LINE__);
+	}
+	vn_iowake(XFS_I(ioend->io_inode));
 	mempool_free(ioend, xfs_ioend_pool);
 }
 
@@ -157,14 +159,10 @@ STATIC void
 xfs_setfilesize(
 	xfs_ioend_t		*ioend)
 {
-	xfs_inode_t		*ip;
+	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
 	xfs_fsize_t		bsize;
 
-	ip = xfs_vtoi(ioend->io_vnode);
-	if (!ip)
-		return;
-
 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
 	ASSERT(ioend->io_type != IOMAP_READ);
 
@@ -227,12 +225,11 @@ xfs_end_bio_unwritten(
 {
 	xfs_ioend_t		*ioend =
 		container_of(work, xfs_ioend_t, io_work);
-	bhv_vnode_t		*vp = ioend->io_vnode;
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 
 	if (likely(!ioend->io_error)) {
-		xfs_bmap(xfs_vtoi(vp), offset, size,
+		xfs_bmap(XFS_I(ioend->io_inode), offset, size,
 				BMAPI_UNWRITTEN, NULL, NULL);
 		xfs_setfilesize(ioend);
 	}
@@ -276,10 +273,10 @@ xfs_alloc_ioend(
 	ioend->io_error = 0;
 	ioend->io_list = NULL;
 	ioend->io_type = type;
-	ioend->io_vnode = vn_from_inode(inode);
+	ioend->io_inode = inode;
 	ioend->io_buffer_head = NULL;
 	ioend->io_buffer_tail = NULL;
-	atomic_inc(&ioend->io_vnode->v_iocount);
+	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
 	ioend->io_offset = 0;
 	ioend->io_size = 0;
 
@@ -505,7 +502,7 @@ xfs_cancel_ioend(
 			unlock_buffer(bh);
 		} while ((bh = next_bh) != NULL);
 
-		vn_iowake(ioend->io_vnode);
+		vn_iowake(XFS_I(ioend->io_inode));
 		mempool_free(ioend, xfs_ioend_pool);
 	} while ((ioend = next) != NULL);
 }
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.h	2007-08-23 14:46:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.h	2007-08-23 14:50:38.000000000 +0200
@@ -32,7 +32,7 @@ typedef struct xfs_ioend {
 	unsigned int		io_type;	/* delalloc / unwritten */
 	int			io_error;	/* I/O error code */
 	atomic_t		io_remaining;	/* hold count */
-	struct bhv_vnode	*io_vnode;	/* file being written to */
+	struct inode		*io_inode;	/* file being written to */
 	struct buffer_head	*io_buffer_head;/* buffer linked list head */
 	struct buffer_head	*io_buffer_tail;/* buffer linked list tail */
 	size_t			io_size;	/* size of the extent */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 14:46:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 14:53:07.000000000 +0200
@@ -20,6 +20,17 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 
+/*
+ * And this gunk is needed for xfs_mount.h"
+ */
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_dmapi.h"
+#include "xfs_inum.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+
 uint64_t vn_generation;		/* vnode generation number */
 DEFINE_SPINLOCK(vnumber_lock);
 
@@ -42,19 +53,19 @@ vn_init(void)
 
 void
 vn_iowait(
-	bhv_vnode_t	*vp)
+	xfs_inode_t	*ip)
 {
-	wait_queue_head_t *wq = vptosync(vp);
+	wait_queue_head_t *wq = vptosync(ip);
 
-	wait_event(*wq, (atomic_read(&vp->v_iocount) == 0));
+	wait_event(*wq, (atomic_read(&ip->i_iocount) == 0));
 }
 
 void
 vn_iowake(
-	bhv_vnode_t	*vp)
+	xfs_inode_t	*ip)
 {
-	if (atomic_dec_and_test(&vp->v_iocount))
-		wake_up(vptosync(vp));
+	if (atomic_dec_and_test(&ip->i_iocount))
+		wake_up(vptosync(ip));
 }
 
 /*
@@ -64,12 +75,12 @@ vn_iowake(
  */
 void
 vn_ioerror(
-	bhv_vnode_t	*vp,
+	xfs_inode_t	*ip,
 	int		error,
 	char		*f,
 	int		l)
 {
-	bhv_vfs_t	*vfsp = vfs_from_sb(vp->v_inode.i_sb);
+	bhv_vfs_t	*vfsp = XFS_MTOVFS(ip->i_mount);
 
 	if (unlikely(error == -ENODEV))
 		bhv_vfs_force_shutdown(vfsp, SHUTDOWN_DEVICE_REQ, f, l);
@@ -92,8 +103,6 @@ vn_initialize(
 
 	ASSERT(VN_CACHED(vp) == 0);
 
-	atomic_set(&vp->v_iocount, 0);
-
 #ifdef	XFS_VNODE_TRACE
 	vp->v_trace = ktrace_alloc(VNODE_TRACE_SIZE, KM_SLEEP);
 #endif	/* XFS_VNODE_TRACE */
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-08-23 14:46:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-08-23 14:51:38.000000000 +0200
@@ -864,6 +864,7 @@ xfs_iread(
 	ip = kmem_zone_zalloc(xfs_inode_zone, KM_SLEEP);
 	ip->i_ino = ino;
 	ip->i_mount = mp;
+	atomic_set(&ip->i_iocount, 0);
 	spin_lock_init(&ip->i_flags_lock);
 
 	/*
@@ -1455,7 +1456,7 @@ xfs_itruncate_start(
 	mp = ip->i_mount;
 	vp = XFS_ITOV(ip);
 
-	vn_iowait(vp);  /* wait for the completion of any pending DIOs */
+	vn_iowait(ip);  /* wait for the completion of any pending DIOs */
 	
 	/*
 	 * Call toss_pages or flushinval_pages to get rid of pages
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-23 14:46:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-23 14:50:38.000000000 +0200
@@ -1209,7 +1209,7 @@ xfs_sync_inodes(
 			 * place after this point
 			 */
 			if (flags & SYNC_IOWAIT)
-				vn_iowait(vp);
+				vn_iowait(ip);
 
 			xfs_ilock(ip, XFS_ILOCK_SHARED);
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-23 14:46:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-23 14:51:38.000000000 +0200
@@ -598,7 +598,7 @@ xfs_setattr(
 		}
 
 		/* wait for all I/O to complete */
-		vn_iowait(vp);
+		vn_iowait(ip);
 
 		if (!code)
 			code = xfs_itruncate_data(ip, vap->va_size);
@@ -3684,7 +3684,7 @@ xfs_reclaim(
 		return 0;
 	}
 
-	vn_iowait(vp);
+	vn_iowait(ip);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
@@ -4190,7 +4190,7 @@ xfs_free_file_space(
 		need_iolock = 0;
 	if (need_iolock) {
 		xfs_ilock(ip, XFS_IOLOCK_EXCL);
-		vn_iowait(vp);	/* wait for the completion of any pending DIOs */
+		vn_iowait(ip);	/* wait for the completion of any pending DIOs */
 	}
 
 	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, NBPP);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 14:46:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 14:51:37.000000000 +0200
@@ -29,7 +29,6 @@ typedef __u64		bhv_vnumber_t;
 
 typedef struct bhv_vnode {
 	bhv_vnumber_t	v_number;		/* in-core vnode number */
-	atomic_t	v_iocount;		/* outstanding I/O count */
 #ifdef XFS_VNODE_TRACE
 	struct ktrace	*v_trace;		/* trace header structure    */
 #endif
@@ -202,10 +201,13 @@ extern int	vn_revalidate(struct bhv_vnod
 extern int	__vn_revalidate(struct bhv_vnode *, bhv_vattr_t *);
 extern void	vn_revalidate_core(struct bhv_vnode *, bhv_vattr_t *);
 
-extern void	vn_iowait(struct bhv_vnode *vp);
-extern void	vn_iowake(struct bhv_vnode *vp);
-
-extern void	vn_ioerror(struct bhv_vnode *vp, int error, char *f, int l);
+/*
+ * Yeah, these don't take vnode anymore at all, all this should be
+ * cleaned up at some point.
+ */
+extern void	vn_iowait(struct xfs_inode *ip);
+extern void	vn_iowake(struct xfs_inode *ip);
+extern void	vn_ioerror(struct xfs_inode *ip, int error, char *f, int l);
 
 static inline int vn_count(struct bhv_vnode *vp)
 {
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-08-23 14:46:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-08-23 14:51:38.000000000 +0200
@@ -300,6 +300,7 @@ typedef struct xfs_inode {
 	struct xfs_inode	*i_cprev;	/* cluster link backward */
 
 	xfs_fsize_t		i_size;		/* in-memory size */
+	atomic_t		i_iocount;	/* outstanding I/O count */
 	/* Trace buffers per inode. */
 #ifdef XFS_BMAP_TRACE
 	struct ktrace		*i_xtrace;	/* inode extent list trace */
