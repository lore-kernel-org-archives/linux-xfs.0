Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 15:19:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KMJ4N5010191
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:19:05 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 529A25216E8
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:20:48 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id HEqzwjT2ZAw3XpVi for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:20:48 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9KMKiIF023715
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 00:20:44 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9KMKiAW023713
	for xfs@oss.sgi.com; Tue, 21 Oct 2008 00:20:44 +0200
Date: Tue, 21 Oct 2008 00:20:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] free inodes using destroy_inode
Message-ID: <20081020222044.GC23662@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

To make sure we free the security data inodes need to be freed using
the proper VFS helper (which we also need to export for this).  To make
sure we don't corrupt the radix tree we need to add another special
case to xfs_reclaim for inodes that haven't been fully initialized yet.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6/fs/inode.c
===================================================================
--- xfs-2.6.orig/fs/inode.c	2008-10-20 23:49:27.000000000 +0200
+++ xfs-2.6/fs/inode.c	2008-10-20 23:54:08.000000000 +0200
@@ -212,6 +212,7 @@ void destroy_inode(struct inode *inode) 
 	else
 		kmem_cache_free(inode_cachep, (inode));
 }
+EXPORT_SYMBOL(destroy_inode);
 
 
 /*
Index: xfs-2.6/fs/xfs/xfs_iget.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_iget.c	2008-10-20 23:49:27.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_iget.c	2008-10-20 23:54:08.000000000 +0200
@@ -197,7 +197,7 @@ out_unlock:
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 out_destroy:
-	xfs_idestroy(ip);
+	xfs_destroy_inode(ip);
 	return error;
 }
 
Index: xfs-2.6/fs/xfs/xfs_inode.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.c	2008-10-20 23:54:05.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.c	2008-10-20 23:54:08.000000000 +0200
@@ -872,10 +872,8 @@ xfs_iread(
 	imap.im_blkno = bno;
 	error = xfs_imap(mp, tp, ip->i_ino, &imap,
 				XFS_IMAP_LOOKUP | imap_flags);
-	if (error) {
-		xfs_idestroy(ip);
-		return error;
-	}
+	if (error)
+ 		goto out_destroy_inode;
 
 	/*
 	 * Fill in the fields in the inode that will be used to
@@ -887,10 +885,8 @@ xfs_iread(
 	ASSERT(bno == 0 || bno == imap.im_blkno);
 
 	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
-	if (error) {
-		xfs_idestroy(ip);
-		return error;
-	}
+	if (error)
+ 		goto out_destroy_inode;
 
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
 
@@ -899,8 +895,6 @@ xfs_iread(
 	 * (nfs or dmi) has a stale handle.
 	 */
 	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC) {
-		xfs_idestroy(ip);
-		xfs_trans_brelse(tp, bp);
 #ifdef DEBUG
 		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
 				"dip->di_core.di_magic (0x%x) != "
@@ -908,7 +902,8 @@ xfs_iread(
 				be16_to_cpu(dip->di_core.di_magic),
 				XFS_DINODE_MAGIC);
 #endif /* DEBUG */
-		return XFS_ERROR(EINVAL);
+		error = XFS_ERROR(EINVAL);
+		goto out_brelse;
 	}
 
 	/*
@@ -922,14 +917,12 @@ xfs_iread(
 		xfs_dinode_from_disk(&ip->i_d, &dip->di_core);
 		error = xfs_iformat(ip, dip);
 		if (error)  {
-			xfs_idestroy(ip);
-			xfs_trans_brelse(tp, bp);
 #ifdef DEBUG
 			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
 					"xfs_iformat() returned error %d",
 					error);
 #endif /* DEBUG */
-			return error;
+			goto out_brelse;
 		}
 	} else {
 		ip->i_d.di_magic = be16_to_cpu(dip->di_core.di_magic);
@@ -995,6 +988,12 @@ xfs_iread(
 	xfs_trans_brelse(tp, bp);
 	*ipp = ip;
 	return 0;
+
+ out_brelse:
+	xfs_trans_brelse(tp, bp);
+ out_destroy_inode:
+	xfs_destroy_inode(ip);
+	return error;
 }
 
 /*
Index: xfs-2.6/fs/xfs/xfs_inode.h
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-20 23:54:05.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-20 23:54:08.000000000 +0200
@@ -309,6 +309,12 @@ static inline struct inode *VFS_I(struct
 	return &ip->i_vnode;
 }
 
+static inline void xfs_destroy_inode(struct xfs_inode *ip)
+{
+	make_bad_inode(VFS_I(ip));
+	return destroy_inode(VFS_I(ip));
+}
+
 /*
  * i_flags helper functions
  */
Index: xfs-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_vnodeops.c	2008-10-20 23:49:27.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_vnodeops.c	2008-10-20 23:55:31.000000000 +0200
@@ -2798,13 +2798,19 @@ int
 xfs_reclaim(
 	xfs_inode_t	*ip)
 {
+	struct inode	*inode = VFS_I(ip);
 
 	xfs_itrace_entry(ip);
 
-	ASSERT(!VN_MAPPED(VFS_I(ip)));
+	ASSERT(!VN_MAPPED(inode));
+
+	if (unlikely(inode->i_state & I_NEW)) {
+		xfs_idestroy(ip);
+		return 0;
+	}
 
 	/* bad inode, get out here ASAP */
-	if (VN_BAD(VFS_I(ip))) {
+	if (unlikely(is_bad_inode(inode))) {
 		xfs_ireclaim(ip);
 		return 0;
 	}
