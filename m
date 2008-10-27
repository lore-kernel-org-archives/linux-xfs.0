Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:41:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDfWn7024652
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:32 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1792ADE734
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id v7tBloy9l1DIoRRs for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:31 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSLa-0000qF-Tm
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:41:30 +0000
Date: Mon, 27 Oct 2008 09:41:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/6] move inode allocation out xfs_iread
Message-ID: <20081027134130.GG3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-move-xfs_inode_alloc-out-of-xfs_iread
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Allocate the inode in xfs_iget_cache_miss and pass it into xfs_iread.  This
simplifies the error handling and allows xfs_iread to be shared with userspace
which already uses these semantics.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-10-25 13:45:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-10-25 13:46:29.000000000 +0200
@@ -40,6 +40,82 @@
 #include "xfs_utils.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
+#include "xfs_bmap.h"
+#include "xfs_btree_trace.h"
+#include "xfs_dir2_trace.h"
+
+
+/*
+ * Allocate and initialise an xfs_inode.
+ */
+STATIC struct xfs_inode *
+xfs_inode_alloc(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct xfs_inode	*ip;
+
+	/*
+	 * if this didn't occur in transactions, we could use
+	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
+	 * code up to do this anyway.
+	 */
+	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
+	if (!ip)
+		return NULL;
+
+	ASSERT(atomic_read(&ip->i_iocount) == 0);
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(completion_done(&ip->i_flush));
+
+	/*
+	 * initialise the VFS inode here to get failures
+	 * out of the way early.
+	 */
+	if (!inode_init_always(mp->m_super, VFS_I(ip))) {
+		kmem_zone_free(xfs_inode_zone, ip);
+		return NULL;
+	}
+
+	/* initialise the xfs inode */
+	ip->i_ino = ino;
+	ip->i_mount = mp;
+	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
+	ip->i_afp = NULL;
+	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
+	ip->i_flags = 0;
+	ip->i_update_core = 0;
+	ip->i_update_size = 0;
+	ip->i_delayed_blks = 0;
+	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
+	ip->i_size = 0;
+	ip->i_new_size = 0;
+
+	/*
+	 * Initialize inode's trace buffers.
+	 */
+#ifdef	XFS_INODE_TRACE
+	ip->i_trace = ktrace_alloc(INODE_TRACE_SIZE, KM_NOFS);
+#endif
+#ifdef XFS_BMAP_TRACE
+	ip->i_xtrace = ktrace_alloc(XFS_BMAP_KTRACE_SIZE, KM_NOFS);
+#endif
+#ifdef XFS_BTREE_TRACE
+	ip->i_btrace = ktrace_alloc(XFS_BMBT_KTRACE_SIZE, KM_NOFS);
+#endif
+#ifdef XFS_RW_TRACE
+	ip->i_rwtrace = ktrace_alloc(XFS_RW_KTRACE_SIZE, KM_NOFS);
+#endif
+#ifdef XFS_ILOCK_TRACE
+	ip->i_lock_trace = ktrace_alloc(XFS_ILOCK_KTRACE_SIZE, KM_NOFS);
+#endif
+#ifdef XFS_DIR2_TRACE
+	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
+#endif
+
+	return ip;
+}
 
 /*
  * Check the validity of the inode we just found it the cache
@@ -143,13 +219,13 @@ xfs_iget_cache_miss(
 	unsigned long		first_index, mask;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
 
-	/*
-	 * Read the disk inode attributes into a new inode structure and get
-	 * a new vnode for it. This should also initialize i_ino and i_mount.
-	 */
-	error = xfs_iread(mp, tp, ino, &ip, bno, flags);
+	ip = xfs_inode_alloc(mp, ino);
+	if (!ip)
+		return ENOMEM;
+
+	error = xfs_iread(mp, tp, ip, bno, flags);
 	if (error)
-		return error;
+		goto out_destroy;
 
 	xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-10-25 13:45:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-10-25 13:47:05.000000000 +0200
@@ -758,119 +758,36 @@ xfs_dic2xflags(
 }
 
 /*
- * Allocate and initialise an xfs_inode.
- */
-STATIC struct xfs_inode *
-xfs_inode_alloc(
-	struct xfs_mount	*mp,
-	xfs_ino_t		ino)
-{
-	struct xfs_inode	*ip;
-
-	/*
-	 * if this didn't occur in transactions, we could use
-	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
-	 * code up to do this anyway.
-	 */
-	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
-	if (!ip)
-		return NULL;
-
-	ASSERT(atomic_read(&ip->i_iocount) == 0);
-	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(completion_done(&ip->i_flush));
-
-	/*
-	 * initialise the VFS inode here to get failures
-	 * out of the way early.
-	 */
-	if (!inode_init_always(mp->m_super, VFS_I(ip))) {
-		kmem_zone_free(xfs_inode_zone, ip);
-		return NULL;
-	}
-
-	/* initialise the xfs inode */
-	ip->i_ino = ino;
-	ip->i_mount = mp;
-	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
-	ip->i_afp = NULL;
-	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
-	ip->i_flags = 0;
-	ip->i_update_core = 0;
-	ip->i_update_size = 0;
-	ip->i_delayed_blks = 0;
-	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
-	ip->i_size = 0;
-	ip->i_new_size = 0;
-
-	/*
-	 * Initialize inode's trace buffers.
-	 */
-#ifdef	XFS_INODE_TRACE
-	ip->i_trace = ktrace_alloc(INODE_TRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_BMAP_TRACE
-	ip->i_xtrace = ktrace_alloc(XFS_BMAP_KTRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_BTREE_TRACE
-	ip->i_btrace = ktrace_alloc(XFS_BMBT_KTRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_RW_TRACE
-	ip->i_rwtrace = ktrace_alloc(XFS_RW_KTRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_ILOCK_TRACE
-	ip->i_lock_trace = ktrace_alloc(XFS_ILOCK_KTRACE_SIZE, KM_NOFS);
-#endif
-#ifdef XFS_DIR2_TRACE
-	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
-#endif
-
-	return ip;
-}
-
-/*
- * Given a mount structure and an inode number, return a pointer
- * to a newly allocated in-core inode corresponding to the given
- * inode number.
- *
- * Initialize the inode's attributes and extent pointers if it
- * already has them (it will not if the inode has no links).
+ * Read the disk inode attributes into the in-core inode structure.
  */
 int
 xfs_iread(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	xfs_inode_t	**ipp,
+	xfs_inode_t	*ip,
 	xfs_daddr_t	bno,
-	uint		imap_flags)
+	uint		iget_flags)
 {
 	xfs_buf_t	*bp;
 	xfs_dinode_t	*dip;
-	xfs_inode_t	*ip;
 	int		error;
 
-	ip = xfs_inode_alloc(mp, ino);
-	if (!ip)
-		return ENOMEM;
-
 	/*
 	 * Fill in the location information in the in-core inode.
 	 */
 	ip->i_imap.im_blkno = bno;
-	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, imap_flags);
+	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, iget_flags);
 	if (error)
-		goto out_destroy_inode;
+		return error;
 	ASSERT(bno == 0 || bno == ip->i_imap.im_blkno);
 
 	/*
 	 * Get pointers to the on-disk inode and the buffer containing it.
 	 */
 	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp,
-			       XFS_BUF_LOCK, imap_flags);
+			       XFS_BUF_LOCK, iget_flags);
 	if (error)
-		goto out_destroy_inode;
+		return error;
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	/*
@@ -968,14 +885,8 @@ xfs_iread(
 	 * to worry about the inode being changed just because we released
 	 * the buffer.
 	 */
-	xfs_trans_brelse(tp, bp);
-	*ipp = ip;
-	return 0;
-
  out_brelse:
 	xfs_trans_brelse(tp, bp);
- out_destroy_inode:
-	xfs_destroy_inode(ip);
 	return error;
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-10-25 13:45:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-10-25 13:46:29.000000000 +0200
@@ -512,8 +512,8 @@ void		xfs_ireclaim(xfs_inode_t *);
 /*
  * xfs_inode.c prototypes.
  */
-int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-			  xfs_inode_t **, xfs_daddr_t, uint);
+int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
+			  struct xfs_inode *, xfs_daddr_t, uint);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
 			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
 			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);

-- 
