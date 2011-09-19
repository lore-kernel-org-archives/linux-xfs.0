Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JF0xnT256231 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 10:00:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 020E613FC13F
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 08:06:08 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EC7mJhZB9nrvw6RW for <xfs@oss.sgi.com>;
	Mon, 19 Sep 2011 08:06:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5fL4-0005ZC-Rx
	for xfs@oss.sgi.com; Mon, 19 Sep 2011 15:00:54 +0000
Date: Mon, 19 Sep 2011 11:00:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: simplify xfs_trans_ijoin* again
Message-ID: <20110919150054.GA21382@infradead.org>
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

There is no reason to keep a reference to the inode even if we unlock
it during transaction commit because we never drop a reference between
the ijoin and commit.  Also use this fact to merge xfs_trans_ijoin_ref
back into xfs_trans_ijoin - the third argument decides if an unlock
is needed now.

I'm actually starting to wonder if allowing inodes to be unlocked
at transaction commit really is worth the effort.  The only real
benefit is that they can be unlocked earlier when commiting a
synchronous transactions, but that could be solved by doing the
log force manually after the unlock, too.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-09-18 11:43:05.000000000 -0400
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-09-18 11:43:38.471779030 -0400
@@ -219,7 +219,7 @@ xfs_free_eofblocks(
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip);
+		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_itruncate_data(&tp, ip, ip->i_size);
 		if (error) {
@@ -288,7 +288,7 @@ xfs_inactive_symlink_rmt(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	size = (int)ip->i_d.di_size;
 	ip->i_d.di_size = 0;
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
 	 * Find the block(s) so we can inval and unmap them.
@@ -332,7 +332,7 @@ xfs_inactive_symlink_rmt(
 	 * Mark it dirty so it will be logged and moved forward in the log as
 	 * part of every commit.
 	 */
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
 	 * Get a new, empty transaction to return to our caller.
@@ -465,7 +465,7 @@ xfs_inactive_attrs(
 		goto error_cancel;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 
 	ASSERT(ip->i_d.di_anextents == 0);
@@ -659,7 +659,7 @@ xfs_inactive(
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip);
+		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_itruncate_data(&tp, ip, 0);
 		if (error) {
@@ -683,7 +683,7 @@ xfs_inactive(
 			return VN_INACTIVE_CACHE;
 		}
 
-		xfs_trans_ijoin(tp, ip);
+		xfs_trans_ijoin(tp, ip, 0);
 	} else {
 		error = xfs_trans_reserve(tp, 0,
 					  XFS_IFREE_LOG_RES(mp),
@@ -696,7 +696,7 @@ xfs_inactive(
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-		xfs_trans_ijoin(tp, ip);
+		xfs_trans_ijoin(tp, ip, 0);
 	}
 
 	/*
@@ -936,7 +936,7 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin_ref(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = B_FALSE;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
@@ -1257,8 +1257,8 @@ xfs_remove(
 
 	xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin_ref(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If we're removing a directory perform some additional validation.
@@ -1403,8 +1403,8 @@ xfs_link(
 
 	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin_ref(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, tdp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
 	/*
 	 * If the source has too many links, we can't make any more to it.
@@ -1598,7 +1598,7 @@ xfs_symlink(
 	 * transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin_ref(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = B_FALSE;
 
 	/*
@@ -1728,7 +1728,7 @@ xfs_set_dmattrs(
 		return error;
 	}
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	ip->i_d.di_dmevmask = evmask;
 	ip->i_d.di_dmstate  = state;
@@ -1871,7 +1871,7 @@ xfs_alloc_file_space(
 		if (error)
 			goto error1;
 
-		xfs_trans_ijoin(tp, ip);
+		xfs_trans_ijoin(tp, ip, 0);
 
 		xfs_bmap_init(&free_list, &firstfsb);
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
@@ -2169,7 +2169,7 @@ xfs_free_file_space(
 		if (error)
 			goto error1;
 
-		xfs_trans_ijoin(tp, ip);
+		xfs_trans_ijoin(tp, ip, 0);
 
 		/*
 		 * issue the bunmapi() call to free the blocks
@@ -2342,7 +2342,7 @@ xfs_change_file_space(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	if ((attr_flags & XFS_ATTR_DMI) == 0) {
 		ip->i_d.di_mode &= ~S_ISUID;
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_trans.h	2011-09-18 11:43:21.273277852 -0400
@@ -470,8 +470,7 @@ void		xfs_trans_stale_inode_buf(xfs_tran
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
-void		xfs_trans_ijoin_ref(struct xfs_trans *, struct xfs_inode *, uint);
-void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *);
+void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 struct xfs_efi_log_item	*xfs_trans_get_efi(xfs_trans_t *, uint);
Index: xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2011-09-18 11:41:41.537277846 -0400
+++ xfs/fs/xfs/xfs_trans_inode.c	2011-09-18 11:43:21.277345847 -0400
@@ -47,11 +47,13 @@ xfs_trans_inode_broot_debug(
  * Add a locked inode to the transaction.
  *
  * The inode must be locked, and it cannot be associated with any transaction.
+ * If lock_flags is non-zero the inode will be unlocked on transaction commit.
  */
 void
 xfs_trans_ijoin(
 	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	uint			lock_flags)
 {
 	xfs_inode_log_item_t	*iip;
 
@@ -59,7 +61,9 @@ xfs_trans_ijoin(
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
 	iip = ip->i_itemp;
+
 	ASSERT(iip->ili_lock_flags == 0);
+	iip->ili_lock_flags = lock_flags;
 
 	/*
 	 * Get a log_item_desc to point at the new item.
@@ -70,25 +74,6 @@ xfs_trans_ijoin(
 }
 
 /*
- * Add a locked inode to the transaction.
- *
- *
- * Grabs a reference to the inode which will be dropped when the transaction
- * is committed.  The inode will also be unlocked at that point.  The inode
- * must be locked, and it cannot be associated with any transaction.
- */
-void
-xfs_trans_ijoin_ref(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	uint			lock_flags)
-{
-	xfs_trans_ijoin(tp, ip);
-	IHOLD(ip);
-	ip->i_itemp->ili_lock_flags = lock_flags;
-}
-
-/*
  * Transactional inode timestamp update. Requires the inode to be locked and
  * joined to the transaction supplied. Relies on the transaction subsystem to
  * track dirty state and update/writeback the inode accordingly.
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_inode_item.c	2011-09-18 11:43:21.281325866 -0400
@@ -658,10 +658,8 @@ xfs_inode_item_unlock(
 
 	lock_flags = iip->ili_lock_flags;
 	iip->ili_lock_flags = 0;
-	if (lock_flags) {
+	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
-		IRELE(ip);
-	}
 }
 
 /*
Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_file.c	2011-09-18 11:43:21.289325875 -0400
@@ -213,7 +213,7 @@ xfs_file_fsync(
 		 * transaction.	 So we play it safe and fire off the
 		 * transaction anyway.
 		 */
-		xfs_trans_ijoin(tp, ip);
+		xfs_trans_ijoin(tp, ip, 0);
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		error = xfs_trans_commit(tp, 0);
 
Index: xfs/fs/xfs/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ioctl.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_ioctl.c	2011-09-18 11:43:21.297325925 -0400
@@ -1069,7 +1069,7 @@ xfs_ioctl_setattr(
 		}
 	}
 
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_attr.c	2011-09-18 11:43:21.305325806 -0400
@@ -319,7 +319,7 @@ xfs_attr_set_int(
 		return (error);
 	}
 
-	xfs_trans_ijoin(args.trans, dp);
+	xfs_trans_ijoin(args.trans, dp, 0);
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -389,7 +389,7 @@ xfs_attr_set_int(
 		 * a new one.  We need the inode to be in all transactions.
 		 */
 		if (committed)
-			xfs_trans_ijoin(args.trans, dp);
+			xfs_trans_ijoin(args.trans, dp, 0);
 
 		/*
 		 * Commit the leaf transformation.  We'll need another (linked)
@@ -537,7 +537,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, str
 	 * No need to make quota reservations here. We expect to release some
 	 * blocks not allocate in the common case.
 	 */
-	xfs_trans_ijoin(args.trans, dp);
+	xfs_trans_ijoin(args.trans, dp, 0);
 
 	/*
 	 * Decide on what work routines to call based on the inode size.
@@ -809,7 +809,7 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	 * No need to make quota reservations here. We expect to release some
 	 * blocks, not allocate, in the common case.
 	 */
-	xfs_trans_ijoin(trans, dp);
+	xfs_trans_ijoin(trans, dp, 0);
 
 	/*
 	 * Decide on what work routines to call based on the inode size.
@@ -961,7 +961,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 		 * a new one.  We need the inode to be in all transactions.
 		 */
 		if (committed)
-			xfs_trans_ijoin(args->trans, dp);
+			xfs_trans_ijoin(args->trans, dp, 0);
 
 		/*
 		 * Commit the current trans (including the inode) and start
@@ -1063,7 +1063,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 			 * in all transactions.
 			 */
 			if (committed)
-				xfs_trans_ijoin(args->trans, dp);
+				xfs_trans_ijoin(args->trans, dp, 0);
 		} else
 			xfs_da_buf_done(bp);
 
@@ -1137,7 +1137,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *
 		 * a new one.  We need the inode to be in all transactions.
 		 */
 		if (committed)
-			xfs_trans_ijoin(args->trans, dp);
+			xfs_trans_ijoin(args->trans, dp, 0);
 	} else
 		xfs_da_buf_done(bp);
 	return(0);
@@ -1291,7 +1291,7 @@ restart:
 			 * in all transactions.
 			 */
 			if (committed)
-				xfs_trans_ijoin(args->trans, dp);
+				xfs_trans_ijoin(args->trans, dp, 0);
 
 			/*
 			 * Commit the node conversion and start the next
@@ -1328,7 +1328,7 @@ restart:
 		 * a new one.  We need the inode to be in all transactions.
 		 */
 		if (committed)
-			xfs_trans_ijoin(args->trans, dp);
+			xfs_trans_ijoin(args->trans, dp, 0);
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1440,7 +1440,7 @@ restart:
 			 * in all transactions.
 			 */
 			if (committed)
-				xfs_trans_ijoin(args->trans, dp);
+				xfs_trans_ijoin(args->trans, dp, 0);
 		}
 
 		/*
@@ -1572,7 +1572,7 @@ xfs_attr_node_removename(xfs_da_args_t *
 		 * a new one.  We need the inode to be in all transactions.
 		 */
 		if (committed)
-			xfs_trans_ijoin(args->trans, dp);
+			xfs_trans_ijoin(args->trans, dp, 0);
 
 		/*
 		 * Commit the Btree join operation and start a new trans.
@@ -1623,7 +1623,7 @@ xfs_attr_node_removename(xfs_da_args_t *
 			 * in all transactions.
 			 */
 			if (committed)
-				xfs_trans_ijoin(args->trans, dp);
+				xfs_trans_ijoin(args->trans, dp, 0);
 		} else
 			xfs_da_brelse(args->trans, bp);
 	}
@@ -2060,7 +2060,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		 * a new one.  We need the inode to be in all transactions.
 		 */
 		if (committed)
-			xfs_trans_ijoin(args->trans, dp);
+			xfs_trans_ijoin(args->trans, dp, 0);
 
 		ASSERT(nmap == 1);
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
@@ -2207,7 +2207,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 		 * a new one.  We need the inode to be in all transactions.
 		 */
 		if (committed)
-			xfs_trans_ijoin(args->trans, args->dp);
+			xfs_trans_ijoin(args->trans, args->dp, 0);
 
 		/*
 		 * Close out trans and start the next one in the chain.
Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_dfrag.c	2011-09-18 11:43:21.311777680 -0400
@@ -425,8 +425,8 @@ xfs_swap_extents(
 	}
 
 
-	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
 	xfs_trans_log_inode(tp, ip,  ilf_fields);
 	xfs_trans_log_inode(tp, tip, tilf_fields);
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_iomap.c	2011-09-18 11:43:21.315936834 -0400
@@ -208,7 +208,7 @@ xfs_iomap_write_direct(
 	if (error)
 		goto error1;
 
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	bmapi_flag = 0;
 	if (offset < ip->i_size || extsz)
@@ -528,7 +528,7 @@ xfs_iomap_write_allocate(
 				return XFS_ERROR(error);
 			}
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin(tp, ip);
+			xfs_trans_ijoin(tp, ip, 0);
 
 			xfs_bmap_init(&free_list, &first_block);
 
@@ -692,7 +692,7 @@ xfs_iomap_write_unwritten(
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip);
+		xfs_trans_ijoin(tp, ip, 0);
 
 		/*
 		 * Modify the unwritten extent state of the buffer.
Index: xfs/fs/xfs/xfs_rename.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rename.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_rename.c	2011-09-18 11:43:21.319786642 -0400
@@ -170,12 +170,12 @@ xfs_rename(
 	 * we can rely on either trans_commit or trans_cancel to unlock
 	 * them.
 	 */
-	xfs_trans_ijoin_ref(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
 	if (new_parent)
-		xfs_trans_ijoin_ref(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
 	if (target_ip)
-		xfs_trans_ijoin_ref(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_trans.c	2011-09-18 11:43:21.319786642 -0400
@@ -2018,6 +2018,6 @@ xfs_trans_roll(
 	if (error)
 		return error;
 
-	xfs_trans_ijoin(trans, dp);
+	xfs_trans_ijoin(trans, dp, 0);
 	return 0;
 }
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_super.c	2011-09-18 11:43:21.323821229 -0400
@@ -884,7 +884,7 @@ xfs_log_inode(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	return xfs_trans_commit(tp, 0);
 }
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-18 11:43:21.331815731 -0400
@@ -2195,7 +2195,7 @@ xfs_bmap_rtalloc(
 	 * Lock out other modifications to the RT bitmap inode.
 	 */
 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If it's an allocation to an empty file at offset 0,
@@ -3460,7 +3460,7 @@ xfs_bmap_add_attrfork(
 	}
 	ASSERT(ip->i_d.di_anextents == 0);
 
-	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	switch (ip->i_d.di_format) {
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_inode.c	2011-09-18 11:43:21.335983066 -0400
@@ -1152,7 +1152,7 @@ xfs_ialloc(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup inode ops and unlock */
@@ -1297,7 +1297,7 @@ xfs_itruncate_extents(
 		 */
 		error = xfs_bmap_finish(&tp, &free_list, &committed);
 		if (committed)
-			xfs_trans_ijoin(tp, ip);
+			xfs_trans_ijoin(tp, ip, 0);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -1313,7 +1313,7 @@ xfs_itruncate_extents(
 		error = xfs_trans_commit(tp, 0);
 		tp = ntp;
 
-		xfs_trans_ijoin(tp, ip);
+		xfs_trans_ijoin(tp, ip, 0);
 
 		if (error)
 			goto out;
Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_rtalloc.c	2011-09-18 11:43:21.344243641 -0400
@@ -112,7 +112,7 @@ xfs_growfs_rt_alloc(
 		 * Lock the inode.
 		 */
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 		xfs_bmap_init(&flist, &firstblock);
 		/*
@@ -155,7 +155,7 @@ xfs_growfs_rt_alloc(
 			 * Lock the bitmap inode.
 			 */
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 			/*
 			 * Get a buffer for the block.
 			 */
@@ -1960,7 +1960,7 @@ xfs_growfs_rt(
 		 * Lock out other callers by grabbing the bitmap inode lock.
 		 */
 		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin_ref(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
 		/*
 		 * Update the bitmap inode's size.
 		 */
@@ -1972,7 +1972,7 @@ xfs_growfs_rt(
 		 * Get the summary inode into the transaction.
 		 */
 		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin_ref(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
 		/*
 		 * Update the summary inode's size.
 		 */
@@ -2143,7 +2143,7 @@ xfs_rtfree_extent(
 	 * Synchronize by locking the bitmap inode.
 	 */
 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
 
 #if defined(__KERNEL__) && defined(DEBUG)
 	/*
Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_iops.c	2011-09-18 11:43:21.348278856 -0400
@@ -611,7 +611,7 @@ xfs_setattr_nonsize(
 		}
 	}
 
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
@@ -863,7 +863,7 @@ xfs_setattr_size(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
 	 * Only change the c/mtime if we are changing the size or we are
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_dquot.c	2011-09-18 11:43:21.356183005 -0400
@@ -377,7 +377,7 @@ xfs_qm_dqalloc(
 		return (ESRCH);
 	}
 
-	xfs_trans_ijoin_ref(tp, quotip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
 	nmaps = 1;
 	error = xfs_bmapi_write(tp, quotip, offset_fsb,
 				XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
Index: xfs/fs/xfs/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_syscalls.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_qm_syscalls.c	2011-09-18 11:43:21.364161632 -0400
@@ -261,7 +261,7 @@ xfs_qm_scall_trunc_qfile(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_itruncate_data(&tp, ip, 0);
 	if (error) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
