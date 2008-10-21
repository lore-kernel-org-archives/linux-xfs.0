Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 02:05:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L95O1M031538
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 02:05:24 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D22D525414
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 02:07:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id fWYU1WFmVmVht74C for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 02:07:08 -0700 (PDT)
Date: Tue, 21 Oct 2008 05:07:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] free inodes using destroy_inode
Message-ID: <20081021090708.GA30463@infradead.org>
References: <20081020222044.GC23662@lst.de> <20081021030726.GD18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021030726.GD18495@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Oct 21, 2008 at 02:07:26PM +1100, Dave Chinner wrote:
>    ^
> Extra whitespace.
> 
>    ^
> Ditto.

Fixed.

> Yes, makes sense to mark it bad first to avoid most of the
> reclaim code.

> Can that happen? I thought xfs_iput_new() took care of clearing the
> I_NEW flag via unlock_new_inode() and so there is no way that flag
> can leak through to here. perhaps a comment explaining what the
> error path is that leads to needing this check is in order....

The make_inode_bad isn't actually nessecary anymore - this was my first
attempt at skipping the flushing in xfs_reclaim, but it was still too
much as the radix tree removal for and inode that's not in the tree
tripped up quite badly.  So I use I_NEW here to detect these half setup
inodes.  Real I_NEW indoes still go through xfs_iput_new.

Updated version that has a comment explaining all this below:


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
+++ xfs-2.6/fs/xfs/xfs_inode.c	2008-10-21 09:24:30.000000000 +0200
@@ -872,10 +872,8 @@ xfs_iread(
 	imap.im_blkno = bno;
 	error = xfs_imap(mp, tp, ip->i_ino, &imap,
 				XFS_IMAP_LOOKUP | imap_flags);
-	if (error) {
-		xfs_idestroy(ip);
-		return error;
-	}
+	if (error)
+		goto out_destroy_inode;
 
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
+		goto out_destroy_inode;
 
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
+++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-21 09:24:42.000000000 +0200
@@ -309,6 +309,11 @@ static inline struct inode *VFS_I(struct
 	return &ip->i_vnode;
 }
 
+static inline void xfs_destroy_inode(struct xfs_inode *ip)
+{
+	return destroy_inode(VFS_I(ip));
+}
+
 /*
  * i_flags helper functions
  */
Index: xfs-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_vnodeops.c	2008-10-20 23:49:27.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_vnodeops.c	2008-10-21 09:26:38.000000000 +0200
@@ -2798,13 +2798,29 @@ int
 xfs_reclaim(
 	xfs_inode_t	*ip)
 {
+	struct inode	*inode = VFS_I(ip);
 
 	xfs_itrace_entry(ip);
 
-	ASSERT(!VN_MAPPED(VFS_I(ip)));
+	ASSERT(!VN_MAPPED(inode));
+
+	/*
+	 * If we get an uninitialized inode, immediate destroy it here and
+	 * don't go through writeback or removing it from the radix-tree to
+	 * which is has never been added.
+	 *
+	 * Note that I_NEW is a rather fragile way to detect this as I_NEW
+	 * is still set by partially set-up inode that has been added to the
+	 * radix-tree.  But all those failure cases go through xfs_iput_new
+	 * and thus never end up with I_NEW set here.
+	 */
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
