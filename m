Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6ZuJ178939 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8CF8387869
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id K1GwiAwNJDwVNc7q for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:01 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xx-00013c-GI
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:01 +0000
Message-Id: <20100531160901.401855518@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/17] xfs: simplify inode to transaction joining
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-xfs_trans_ijoin
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

Currently we need to either call IHOLD or xfs_trans_ihold on an inode when
joining it to a transaction via xfs_trans_ijoin.

This patches instead makes xfs_trans_ijoin usable on it's own by doing
an implicity xfs_trans_ihold, which also allows us to drop the third
argument.  For the case where we want to hold a reference on the inode
a xfs_trans_ijoin_ref wrapper is added which does the IHOLD and marks
the inode for needing an xfs_iput.  In addition to the cleaner interface
to the caller this also simplifies the implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-05-29 18:44:47.554255638 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-05-29 18:49:10.749003438 +0200
@@ -378,14 +378,7 @@ xfs_qm_dqalloc(
 		return (ESRCH);
 	}
 
-	/*
-	 * xfs_trans_commit normally decrements the vnode ref count
-	 * when it unlocks the inode. Since we want to keep the quota
-	 * inode around, we bump the vnode ref count now.
-	 */
-	IHOLD(quotip);
-
-	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, quotip, XFS_ILOCK_EXCL);
 	nmaps = 1;
 	if ((error = xfs_bmapi(tp, quotip,
 			      offset_fsb, XFS_DQUOT_CLUSTER_SIZE_FSB,
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-05-29 18:44:44.719005883 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2010-05-29 18:49:11.611005462 +0200
@@ -3739,9 +3739,10 @@ xfs_bmap_add_attrfork(
 		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 	ASSERT(ip->i_d.di_anextents == 0);
-	IHOLD(ip);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_DEV:
 		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
Index: xfs/fs/xfs/xfs_rename.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rename.c	2010-05-29 18:44:44.198005742 +0200
+++ xfs/fs/xfs/xfs_rename.c	2010-05-29 18:44:47.678039336 +0200
@@ -169,26 +169,14 @@ xfs_rename(
 	/*
 	 * Join all the inodes to the transaction. From this point on,
 	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.  Note that we need to add a vnode reference to the
-	 * directories since trans_commit & trans_cancel will decrement
-	 * them when they unlock the inodes.  Also, we need to be careful
-	 * not to add an inode to the transaction more than once.
+	 * them.
 	 */
-	IHOLD(src_dp);
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
-
-	if (new_parent) {
-		IHOLD(target_dp);
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	}
-
-	IHOLD(src_ip);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
-
-	if (target_ip) {
-		IHOLD(target_ip);
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
-	}
+	xfs_trans_ijoin_ref(tp, src_dp, XFS_ILOCK_EXCL);
+	if (new_parent)
+		xfs_trans_ijoin_ref(tp, target_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, src_ip, XFS_ILOCK_EXCL);
+	if (target_ip)
+		xfs_trans_ijoin_ref(tp, target_ip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2010-05-29 18:44:44.783005813 +0200
+++ xfs/fs/xfs/xfs_trans.h	2010-05-29 18:49:12.008004765 +0200
@@ -475,8 +475,8 @@ void		xfs_trans_dquot_buf(xfs_trans_t *,
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 int		xfs_trans_iget(struct xfs_mount *, xfs_trans_t *,
 			       xfs_ino_t , uint, uint, struct xfs_inode **);
-void		xfs_trans_ijoin(xfs_trans_t *, struct xfs_inode *, uint);
-void		xfs_trans_ihold(xfs_trans_t *, struct xfs_inode *);
+void		xfs_trans_ijoin_ref(struct xfs_trans *, struct xfs_inode *, uint);
+void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 struct xfs_efi_log_item	*xfs_trans_get_efi(xfs_trans_t *, uint);
Index: xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2010-05-29 18:44:44.695207098 +0200
+++ xfs/fs/xfs/xfs_trans_inode.c	2010-05-29 18:44:47.682003507 +0200
@@ -33,6 +33,7 @@
 #include "xfs_btree.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
+#include "xfs_trace.h"
 
 #ifdef XFS_TRANS_DEBUG
 STATIC void
@@ -42,7 +43,6 @@ xfs_trans_inode_broot_debug(
 #define	xfs_trans_inode_broot_debug(ip)
 #endif
 
-
 /*
  * Get an inode and join it to the transaction.
  */
@@ -58,32 +58,31 @@ xfs_trans_iget(
 	int			error;
 
 	error = xfs_iget(mp, tp, ino, flags, lock_flags, ipp, 0);
-	if (!error && tp)
-		xfs_trans_ijoin(tp, *ipp, lock_flags);
+	if (!error && tp) {
+		xfs_trans_ijoin(tp, *ipp);
+		(*ipp)->i_itemp->ili_lock_flags = lock_flags;
+	}
 	return error;
 }
 
 /*
- * Add the locked inode to the transaction.
- * The inode must be locked, and it cannot be associated with any
- * transaction.  The caller must specify the locks already held
- * on the inode.
+ * Add a locked inode to the transaction.
+ *
+ * The inode must be locked, and it cannot be associated with any transaction.
  */
 void
 xfs_trans_ijoin(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	uint		lock_flags)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
 {
 	xfs_inode_log_item_t	*iip;
 
 	ASSERT(ip->i_transp == NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(lock_flags & XFS_ILOCK_EXCL);
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
 	iip = ip->i_itemp;
-	ASSERT(iip->ili_flags == 0);
+	ASSERT(iip->ili_lock_flags == 0);
 
 	/*
 	 * Get a log_item_desc to point at the new item.
@@ -93,42 +92,31 @@ xfs_trans_ijoin(
 	xfs_trans_inode_broot_debug(ip);
 
 	/*
-	 * If the IO lock is already held, mark that in the inode log item.
-	 */
-	if (lock_flags & XFS_IOLOCK_EXCL) {
-		iip->ili_flags |= XFS_ILI_IOLOCKED_EXCL;
-	} else if (lock_flags & XFS_IOLOCK_SHARED) {
-		iip->ili_flags |= XFS_ILI_IOLOCKED_SHARED;
-	}
-
-	/*
 	 * Initialize i_transp so we can find it with xfs_inode_incore()
 	 * in xfs_trans_iget() above.
 	 */
 	ip->i_transp = tp;
 }
 
-
-
 /*
- * Mark the inode as not needing to be unlocked when the inode item's
- * IOP_UNLOCK() routine is called.  The inode must already be locked
- * and associated with the given transaction.
+ * Add a locked inode to the transaction.
+ *
+ *
+ * Grabs a reference to the inode which will be dropped when the transaction
+ * is commited.  The inode will also be unlocked at that point.  The inode
+ * must be locked, and it cannot be associated with any transaction.
  */
-/*ARGSUSED*/
 void
-xfs_trans_ihold(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip)
+xfs_trans_ijoin_ref(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	uint			lock_flags)
 {
-	ASSERT(ip->i_transp == tp);
-	ASSERT(ip->i_itemp != NULL);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	ip->i_itemp->ili_flags |= XFS_ILI_HOLD;
+	xfs_trans_ijoin(tp, ip);
+	IHOLD(ip);
+	ip->i_itemp->ili_lock_flags = lock_flags;
 }
 
-
 /*
  * This is called to mark the fields indicated in fieldmask as needing
  * to be logged when the transaction is committed.  The inode must
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-05-29 18:44:44.233005323 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-05-29 18:49:10.853004415 +0200
@@ -268,8 +268,7 @@ xfs_setattr(
 		commit_flags = XFS_TRANS_RELEASE_LOG_RES;
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-		xfs_trans_ijoin(tp, ip, lock_flags);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 
 		/*
 		 * Only change the c/mtime if we are changing the size
@@ -319,8 +318,7 @@ xfs_setattr(
 			xfs_iflags_set(ip, XFS_ITRUNCATED);
 		}
 	} else if (tp) {
-		xfs_trans_ijoin(tp, ip, lock_flags);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 	}
 
 	/*
@@ -653,10 +651,7 @@ xfs_free_eofblocks(
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip,
-				XFS_IOLOCK_EXCL |
-				XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 
 		error = xfs_itruncate_finish(&tp, ip,
 					     ip->i_size,
@@ -728,8 +723,7 @@ xfs_inactive_symlink_rmt(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	size = (int)ip->i_d.di_size;
 	ip->i_d.di_size = 0;
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
 	 * Find the block(s) so we can inval and unmap them.
@@ -773,8 +767,7 @@ xfs_inactive_symlink_rmt(
 	 * Mark it dirty so it will be logged and moved forward in the log as
 	 * part of every commit.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
 	 * Get a new, empty transaction to return to our caller.
@@ -907,8 +900,7 @@ xfs_inactive_attrs(
 		goto error_cancel;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
 	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 
 	ASSERT(ip->i_d.di_anextents == 0);
@@ -1095,8 +1087,7 @@ xfs_inactive(
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 
 		/*
 		 * normally, we have to run xfs_itruncate_finish sync.
@@ -1129,8 +1120,7 @@ xfs_inactive(
 			return VN_INACTIVE_CACHE;
 		}
 
-		xfs_trans_ijoin(tp, ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 	} else {
 		error = xfs_trans_reserve(tp, 0,
 					  XFS_IFREE_LOG_RES(mp),
@@ -1143,8 +1133,7 @@ xfs_inactive(
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 	}
 
 	/*
@@ -1392,8 +1381,7 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	IHOLD(dp);
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = B_FALSE;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
@@ -1730,15 +1718,8 @@ xfs_remove(
 
 	xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
 
-	/*
-	 * At this point, we've gotten both the directory and the entry
-	 * inodes locked.
-	 */
-	IHOLD(ip);
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-
-	IHOLD(dp);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If we're removing a directory perform some additional validation.
@@ -1884,15 +1865,8 @@ xfs_link(
 
 	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
 
-	/*
-	 * Increment vnode ref counts since xfs_trans_commit &
-	 * xfs_trans_cancel will both unlock the inodes and
-	 * decrement the associated ref counts.
-	 */
-	IHOLD(sip);
-	IHOLD(tdp);
-	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, sip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, tdp, XFS_ILOCK_EXCL);
 
 	/*
 	 * If the source has too many links, we can't make any more to it.
@@ -2087,8 +2061,7 @@ xfs_symlink(
 	 * transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	IHOLD(dp);
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = B_FALSE;
 
 	/*
@@ -2227,13 +2200,12 @@ xfs_set_dmattrs(
 		return error;
 	}
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 
 	ip->i_d.di_dmevmask = evmask;
 	ip->i_d.di_dmstate  = state;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	IHOLD(ip);
 	error = xfs_trans_commit(tp, 0);
 
 	return error;
@@ -2366,8 +2338,7 @@ xfs_alloc_file_space(
 		if (error)
 			goto error1;
 
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 
 		/*
 		 * Issue the xfs_bmapi() call to allocate the blocks
@@ -2668,8 +2639,7 @@ xfs_free_file_space(
 		if (error)
 			goto error1;
 
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 
 		/*
 		 * issue the bunmapi() call to free the blocks
@@ -2839,8 +2809,7 @@ xfs_change_file_space(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
 
 	if ((attr_flags & XFS_ATTR_DMI) == 0) {
 		ip->i_d.di_mode &= ~S_ISUID;
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2010-05-29 18:44:44.024034028 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2010-05-29 18:44:47.689026206 +0200
@@ -1035,8 +1035,7 @@ xfs_ioctl_setattr(
 		}
 	}
 
-	xfs_trans_ijoin(tp, ip, lock_flags);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
 
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-05-29 18:44:44.048005742 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-05-29 18:44:47.695005533 +0200
@@ -328,8 +328,7 @@ xfs_commit_dummy_trans(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = xfs_trans_commit(tp, 0);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2010-05-29 18:44:44.103255638 +0200
+++ xfs/fs/xfs/xfs_attr.c	2010-05-29 18:49:10.764003787 +0200
@@ -319,8 +319,7 @@ xfs_attr_set_int(
 		return (error);
 	}
 
-	xfs_trans_ijoin(args.trans, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(args.trans, dp);
+	xfs_trans_ijoin(args.trans, dp);
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -390,10 +389,8 @@ xfs_attr_set_int(
 		 * bmap_finish() may have committed the last trans and started
 		 * a new one.  We need the inode to be in all transactions.
 		 */
-		if (committed) {
-			xfs_trans_ijoin(args.trans, dp, XFS_ILOCK_EXCL);
-			xfs_trans_ihold(args.trans, dp);
-		}
+		if (committed)
+			xfs_trans_ijoin(args.trans, dp);
 
 		/*
 		 * Commit the leaf transformation.  We'll need another (linked)
@@ -538,8 +535,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, str
 	 * No need to make quota reservations here. We expect to release some
 	 * blocks not allocate in the common case.
 	 */
-	xfs_trans_ijoin(args.trans, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(args.trans, dp);
+	xfs_trans_ijoin(args.trans, dp);
 
 	/*
 	 * Decide on what work routines to call based on the inode size.
@@ -815,8 +811,7 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	 * No need to make quota reservations here. We expect to release some
 	 * blocks, not allocate, in the common case.
 	 */
-	xfs_trans_ijoin(trans, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(trans, dp);
+	xfs_trans_ijoin(trans, dp);
 
 	/*
 	 * Decide on what work routines to call based on the inode size.
@@ -975,10 +970,8 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 		 * bmap_finish() may have committed the last trans and started
 		 * a new one.  We need the inode to be in all transactions.
 		 */
-		if (committed) {
-			xfs_trans_ijoin(args->trans, dp, XFS_ILOCK_EXCL);
-			xfs_trans_ihold(args->trans, dp);
-		}
+		if (committed)
+			xfs_trans_ijoin(args->trans, dp);
 
 		/*
 		 * Commit the current trans (including the inode) and start
@@ -1079,10 +1072,8 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 			 * and started a new one.  We need the inode to be
 			 * in all transactions.
 			 */
-			if (committed) {
-				xfs_trans_ijoin(args->trans, dp, XFS_ILOCK_EXCL);
-				xfs_trans_ihold(args->trans, dp);
-			}
+			if (committed)
+				xfs_trans_ijoin(args->trans, dp);
 		} else
 			xfs_da_buf_done(bp);
 
@@ -1155,10 +1146,8 @@ xfs_attr_leaf_removename(xfs_da_args_t *
 		 * bmap_finish() may have committed the last trans and started
 		 * a new one.  We need the inode to be in all transactions.
 		 */
-		if (committed) {
-			xfs_trans_ijoin(args->trans, dp, XFS_ILOCK_EXCL);
-			xfs_trans_ihold(args->trans, dp);
-		}
+		if (committed)
+			xfs_trans_ijoin(args->trans, dp);
 	} else
 		xfs_da_buf_done(bp);
 	return(0);
@@ -1311,10 +1300,8 @@ restart:
 			 * and started a new one.  We need the inode to be
 			 * in all transactions.
 			 */
-			if (committed) {
-				xfs_trans_ijoin(args->trans, dp, XFS_ILOCK_EXCL);
-				xfs_trans_ihold(args->trans, dp);
-			}
+			if (committed)
+				xfs_trans_ijoin(args->trans, dp);
 
 			/*
 			 * Commit the node conversion and start the next
@@ -1350,10 +1337,8 @@ restart:
 		 * bmap_finish() may have committed the last trans and started
 		 * a new one.  We need the inode to be in all transactions.
 		 */
-		if (committed) {
-			xfs_trans_ijoin(args->trans, dp, XFS_ILOCK_EXCL);
-			xfs_trans_ihold(args->trans, dp);
-		}
+		if (committed)
+			xfs_trans_ijoin(args->trans, dp);
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1464,10 +1449,8 @@ restart:
 			 * and started a new one.  We need the inode to be
 			 * in all transactions.
 			 */
-			if (committed) {
-				xfs_trans_ijoin(args->trans, dp, XFS_ILOCK_EXCL);
-				xfs_trans_ihold(args->trans, dp);
-			}
+			if (committed)
+				xfs_trans_ijoin(args->trans, dp);
 		}
 
 		/*
@@ -1598,10 +1581,8 @@ xfs_attr_node_removename(xfs_da_args_t *
 		 * bmap_finish() may have committed the last trans and started
 		 * a new one.  We need the inode to be in all transactions.
 		 */
-		if (committed) {
-			xfs_trans_ijoin(args->trans, dp, XFS_ILOCK_EXCL);
-			xfs_trans_ihold(args->trans, dp);
-		}
+		if (committed)
+			xfs_trans_ijoin(args->trans, dp);
 
 		/*
 		 * Commit the Btree join operation and start a new trans.
@@ -1652,10 +1633,8 @@ xfs_attr_node_removename(xfs_da_args_t *
 			 * and started a new one.  We need the inode to be
 			 * in all transactions.
 			 */
-			if (committed) {
-				xfs_trans_ijoin(args->trans, dp, XFS_ILOCK_EXCL);
-				xfs_trans_ihold(args->trans, dp);
-			}
+			if (committed)
+				xfs_trans_ijoin(args->trans, dp);
 		} else
 			xfs_da_brelse(args->trans, bp);
 	}
@@ -2093,10 +2072,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		 * bmap_finish() may have committed the last trans and started
 		 * a new one.  We need the inode to be in all transactions.
 		 */
-		if (committed) {
-			xfs_trans_ijoin(args->trans, dp, XFS_ILOCK_EXCL);
-			xfs_trans_ihold(args->trans, dp);
-		}
+		if (committed)
+			xfs_trans_ijoin(args->trans, dp);
 
 		ASSERT(nmap == 1);
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
@@ -2249,10 +2226,8 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 		 * bmap_finish() may have committed the last trans and started
 		 * a new one.  We need the inode to be in all transactions.
 		 */
-		if (committed) {
-			xfs_trans_ijoin(args->trans, args->dp, XFS_ILOCK_EXCL);
-			xfs_trans_ihold(args->trans, args->dp);
-		}
+		if (committed)
+			xfs_trans_ijoin(args->trans, args->dp);
 
 		/*
 		 * Close out trans and start the next one in the chain.
Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2010-05-29 18:44:44.127260247 +0200
+++ xfs/fs/xfs/xfs_dfrag.c	2010-05-29 18:44:47.708005952 +0200
@@ -413,11 +413,8 @@ xfs_swap_extents(
 	}
 
 
-	IHOLD(ip);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-
-	IHOLD(tip);
-	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
 	xfs_trans_log_inode(tp, ip,  ilf_fields);
 	xfs_trans_log_inode(tp, tip, tilf_fields);
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2010-05-29 18:44:44.139031165 +0200
+++ xfs/fs/xfs/xfs_fsops.c	2010-05-29 18:44:47.713005812 +0200
@@ -633,8 +633,7 @@ xfs_fs_log_dummy(
 	ip = mp->m_rootip;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp, 0);
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-05-29 18:44:47.572011120 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-05-29 18:49:11.627003926 +0200
@@ -1459,7 +1459,7 @@ xfs_itruncate_finish(
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(ip->i_transp == *tp);
 	ASSERT(ip->i_itemp != NULL);
-	ASSERT(ip->i_itemp->ili_flags & XFS_ILI_HOLD);
+	ASSERT(ip->i_itemp->ili_lock_flags == 0);
 
 
 	ntp = *tp;
@@ -1611,12 +1611,8 @@ xfs_itruncate_finish(
 		 */
 		error = xfs_bmap_finish(tp, &free_list, &committed);
 		ntp = *tp;
-		if (committed) {
-			/* link the inode into the next xact in the chain */
-			xfs_trans_ijoin(ntp, ip,
-					XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-			xfs_trans_ihold(ntp, ip);
-		}
+		if (committed)
+			xfs_trans_ijoin(ntp, ip);
 
 		if (error) {
 			/*
@@ -1645,9 +1641,7 @@ xfs_itruncate_finish(
 		error = xfs_trans_commit(*tp, 0);
 		*tp = ntp;
 
-		/* link the inode into the next transaction in the chain */
-		xfs_trans_ijoin(ntp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-		xfs_trans_ihold(ntp, ip);
+		xfs_trans_ijoin(ntp, ip);
 
 		if (error)
 			return error;
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-05-29 18:44:44.173005812 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-05-29 18:49:10.832274285 +0200
@@ -329,8 +329,7 @@ xfs_iomap_write_direct(
 	if (error)
 		goto error1;
 
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
 
 	bmapi_flag = XFS_BMAPI_WRITE;
 	if ((flags & BMAPI_DIRECT) && (offset < ip->i_size || extsz))
@@ -597,8 +596,7 @@ xfs_iomap_write_allocate(
 				return XFS_ERROR(error);
 			}
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-			xfs_trans_ihold(tp, ip);
+			xfs_trans_ijoin(tp, ip);
 
 			xfs_bmap_init(&free_list, &first_block);
 
@@ -761,8 +759,7 @@ xfs_iomap_write_unwritten(
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 
 		/*
 		 * Modify the unwritten extent state of the buffer.
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-05-29 18:44:44.776255080 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-05-29 18:44:47.726070626 +0200
@@ -1892,7 +1892,6 @@ xfs_trans_roll(
 	if (error)
 		return error;
 
-	xfs_trans_ijoin(trans, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(trans, dp);
+	xfs_trans_ijoin(trans, dp);
 	return 0;
 }
Index: xfs/fs/xfs/xfs_utils.c
===================================================================
--- xfs.orig/fs/xfs/xfs_utils.c	2010-05-29 18:44:44.226005812 +0200
+++ xfs/fs/xfs/xfs_utils.c	2010-05-29 18:44:47.732005603 +0200
@@ -374,8 +374,8 @@ xfs_truncate_file(
 	 * of references will stay constant.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
+
 	/*
 	 * Signal a sync xaction.  The only case where that isn't
 	 * the case is if we're truncating an already unlinked file
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-05-29 18:44:47.580032003 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-05-29 18:49:14.203004136 +0200
@@ -628,19 +628,10 @@ xfs_inode_item_unlock(
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
-	uint			hold;
-	uint			iolocked;
-	uint			lock_flags;
+	unsigned short		lock_flags;
 
-	ASSERT(iip != NULL);
 	ASSERT(iip->ili_inode->i_itemp != NULL);
 	ASSERT(xfs_isilocked(iip->ili_inode, XFS_ILOCK_EXCL));
-	ASSERT((!(iip->ili_inode->i_itemp->ili_flags &
-		  XFS_ILI_IOLOCKED_EXCL)) ||
-	       xfs_isilocked(iip->ili_inode, XFS_IOLOCK_EXCL));
-	ASSERT((!(iip->ili_inode->i_itemp->ili_flags &
-		  XFS_ILI_IOLOCKED_SHARED)) ||
-	       xfs_isilocked(iip->ili_inode, XFS_IOLOCK_SHARED));
 
 	/*
 	 * Clear the transaction pointer in the inode.
@@ -668,35 +659,10 @@ xfs_inode_item_unlock(
 		iip->ili_aextents_buf = NULL;
 	}
 
-	/*
-	 * Figure out if we should unlock the inode or not.
-	 */
-	hold = iip->ili_flags & XFS_ILI_HOLD;
-
-	/*
-	 * Before clearing out the flags, remember whether we
-	 * are holding the inode's IO lock.
-	 */
-	iolocked = iip->ili_flags & XFS_ILI_IOLOCKED_ANY;
-
-	/*
-	 * Clear out the fields of the inode log item particular
-	 * to the current transaction.
-	 */
-	iip->ili_flags = 0;
-
-	/*
-	 * Unlock the inode if XFS_ILI_HOLD was not set.
-	 */
-	if (!hold) {
-		lock_flags = XFS_ILOCK_EXCL;
-		if (iolocked & XFS_ILI_IOLOCKED_EXCL) {
-			lock_flags |= XFS_IOLOCK_EXCL;
-		} else if (iolocked & XFS_ILI_IOLOCKED_SHARED) {
-			lock_flags |= XFS_IOLOCK_SHARED;
-		}
+	lock_flags = iip->ili_lock_flags;
+	iip->ili_lock_flags = 0;
+	if (lock_flags)
 		xfs_iput(iip->ili_inode, lock_flags);
-	}
 }
 
 /*
Index: xfs/fs/xfs/xfs_inode_item.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.h	2010-05-29 18:44:47.582032213 +0200
+++ xfs/fs/xfs/xfs_inode_item.h	2010-05-29 18:49:35.192005952 +0200
@@ -103,12 +103,6 @@ typedef struct xfs_inode_log_format_64 {
 				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
 				 XFS_ILOG_ABROOT)
 
-#define	XFS_ILI_HOLD		0x1
-#define	XFS_ILI_IOLOCKED_EXCL	0x2
-#define	XFS_ILI_IOLOCKED_SHARED	0x4
-
-#define	XFS_ILI_IOLOCKED_ANY   (XFS_ILI_IOLOCKED_EXCL | XFS_ILI_IOLOCKED_SHARED)
-
 static inline int xfs_ilog_fbroot(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DBROOT : XFS_ILOG_ABROOT);
@@ -137,7 +131,7 @@ typedef struct xfs_inode_log_item {
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
-	unsigned short		ili_flags;	   /* misc flags */
+	unsigned short		ili_lock_flags;	   /* lock flags */
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	struct xfs_bmbt_rec	*ili_extents_buf;  /* array of logged
Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-05-29 18:44:44.020005812 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-05-29 18:49:10.742004625 +0200
@@ -158,8 +158,7 @@ xfs_file_fsync(
 		 * transaction.	 So we play it safe and fire off the
 		 * transaction anyway.
 		 */
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
+		xfs_trans_ijoin(tp, ip);
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		xfs_trans_set_sync(tp);
 		error = _xfs_trans_commit(tp, 0, &log_flushed);
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-05-29 18:44:44.709255988 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-05-29 18:44:47.751005673 +0200
@@ -1023,8 +1023,7 @@ xfs_log_inode(
 	 * an inode in another recent transaction.  So we play it safe and
 	 * fire off the transaction anyway.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
+	xfs_trans_ijoin(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp, 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
