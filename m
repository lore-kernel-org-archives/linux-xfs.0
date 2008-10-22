Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 09:29:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MGTiYl027562
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 09:29:44 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14A8510C97BA
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 09:31:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id aMyFgyB2T1COXOfs for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 09:31:29 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KsgcL-0000Lu-Dm
	for xfs@oss.sgi.com; Wed, 22 Oct 2008 16:31:29 +0000
Date: Wed, 22 Oct 2008 12:31:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] free partially initialized inodes using destroy_inode
Message-ID: <20081022163129.GC25556@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

To make sure we free the security data inodes need to be freed using
the proper VFS helper (which we also need to export for this). We mark
these inodes bad so we can skip the flush path for them.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6/fs/inode.c
===================================================================
--- xfs-2.6.orig/fs/inode.c	2008-10-22 17:57:30.000000000 +0200
+++ xfs-2.6/fs/inode.c	2008-10-22 17:58:22.000000000 +0200
@@ -212,6 +212,7 @@ void destroy_inode(struct inode *inode) 
 	else
 		kmem_cache_free(inode_cachep, (inode));
 }
+EXPORT_SYMBOL(destroy_inode);
 
 
 /*
Index: xfs-2.6/fs/xfs/xfs_iget.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_iget.c	2008-10-22 17:57:30.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_iget.c	2008-10-22 17:58:22.000000000 +0200
@@ -201,7 +201,7 @@ out_unlock:
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
 out_destroy:
-	xfs_idestroy(ip);
+	xfs_destroy_inode(ip);
 	return error;
 }
 
Index: xfs-2.6/fs/xfs/xfs_inode.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.c	2008-10-22 17:57:30.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.c	2008-10-22 17:58:22.000000000 +0200
@@ -898,18 +898,14 @@ xfs_iread(
 	 * know that this is a new incore inode.
 	 */
 	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, imap_flags, XFS_BUF_LOCK);
-	if (error) {
-		xfs_idestroy(ip);
-		return error;
-	}
+	if (error)
+		goto out_destroy_inode;
 
 	/*
 	 * If we got something that isn't an inode it means someone
 	 * (nfs or dmi) has a stale handle.
 	 */
 	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC) {
-		xfs_idestroy(ip);
-		xfs_trans_brelse(tp, bp);
 #ifdef DEBUG
 		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
 				"dip->di_core.di_magic (0x%x) != "
@@ -917,7 +913,8 @@ xfs_iread(
 				be16_to_cpu(dip->di_core.di_magic),
 				XFS_DINODE_MAGIC);
 #endif /* DEBUG */
-		return XFS_ERROR(EINVAL);
+		error = XFS_ERROR(EINVAL);
+		goto out_brelse;
 	}
 
 	/*
@@ -931,14 +928,12 @@ xfs_iread(
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
@@ -1004,6 +999,12 @@ xfs_iread(
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
--- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-22 17:57:30.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-22 18:00:15.000000000 +0200
@@ -310,6 +310,23 @@ static inline struct inode *VFS_I(struct
 }
 
 /*
+ * Get rid of a partially initialized inode.
+ *
+ * We have to go through destroy_inode to make sure allocations
+ * from init_inode_always like the security data are undone.
+ *
+ * We mark the inode dirty so that it takes the short cut in
+ * the reclaim path instead of going through the flush path
+ * which doesn't make sense for an inode that has never seen the
+ * light of day.
+ */
+static inline void xfs_destroy_inode(struct xfs_inode *ip)
+{
+	make_bad_inode(VFS_I(ip));
+	return destroy_inode(VFS_I(ip));
+}
+
+/*
  * i_flags helper functions
  */
 static inline void
