Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 288877CDC
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 08:49:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F112F30405F
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:49:00 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id HmKAP5L6VAHA8Snt (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:48:58 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aij9d-00013t-Mp
	for xfs@oss.sgi.com; Wed, 23 Mar 2016 13:48:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] xfs: set up inode operation vectors later
Date: Wed, 23 Mar 2016 14:48:53 +0100
Message-Id: <1458740935-31260-3-git-send-email-hch@lst.de>
In-Reply-To: <1458740935-31260-1-git-send-email-hch@lst.de>
References: <1458740935-31260-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In the next patch we'll set up different inode operations for inline vs
out of line symlinks, for that we need to make sure the flags are already
set up properly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.h |  5 ++++-
 fs/xfs/xfs_iops.c  | 59 ++++++++++++++++++++++++++++++++++--------------------
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 43e1d51..e52d7c7 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -440,6 +440,9 @@ loff_t	__xfs_seek_hole_data(struct inode *inode, loff_t start,
 
 
 /* from xfs_iops.c */
+extern void xfs_setup_inode(struct xfs_inode *ip);
+extern void xfs_setup_iops(struct xfs_inode *ip);
+
 /*
  * When setting up a newly allocated inode, we need to call
  * xfs_finish_inode_setup() once the inode is fully instantiated at
@@ -447,7 +450,6 @@ loff_t	__xfs_seek_hole_data(struct inode *inode, loff_t start,
  * before we've completed instantiation. Otherwise we can do it
  * the moment the inode lookup is complete.
  */
-extern void xfs_setup_inode(struct xfs_inode *ip);
 static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
 {
 	xfs_iflags_clear(ip, XFS_INEW);
@@ -458,6 +460,7 @@ static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
 static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
 {
 	xfs_setup_inode(ip);
+	xfs_setup_iops(ip);
 	xfs_finish_inode_setup(ip);
 }
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index fb7dc61..f08d91c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -181,6 +181,8 @@ xfs_generic_create(
 	}
 #endif
 
+	xfs_setup_iops(ip);
+
 	if (tmpfile)
 		d_tmpfile(dentry, inode);
 	else
@@ -368,6 +370,8 @@ xfs_vn_symlink(
 	if (unlikely(error))
 		goto out_cleanup_inode;
 
+	xfs_setup_iops(cip);
+
 	d_instantiate(dentry, inode);
 	xfs_finish_inode_setup(cip);
 	return 0;
@@ -1193,7 +1197,7 @@ xfs_diflags_to_iflags(
 }
 
 /*
- * Initialize the Linux inode and set up the operation vectors.
+ * Initialize the Linux inode.
  *
  * When reading existing inodes from disk this is called directly from xfs_iget,
  * when creating a new inode it is called from xfs_ialloc after setting up the
@@ -1232,8 +1236,38 @@ xfs_setup_inode(
 	i_size_write(inode, ip->i_d.di_size);
 	xfs_diflags_to_iflags(inode, ip);
 
-	ip->d_ops = ip->i_mount->m_nondir_inode_ops;
-	lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
+	if (S_ISDIR(inode->i_mode)) {
+		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
+		ip->d_ops = ip->i_mount->m_dir_inode_ops;
+	} else {
+		ip->d_ops = ip->i_mount->m_nondir_inode_ops;
+		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
+	}
+
+	/*
+	 * Ensure all page cache allocations are done from GFP_NOFS context to
+	 * prevent direct reclaim recursion back into the filesystem and blowing
+	 * stacks or deadlocking.
+	 */
+	gfp_mask = mapping_gfp_mask(inode->i_mapping);
+	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
+
+	/*
+	 * If there is no attribute fork no ACL can exist on this inode,
+	 * and it can't have any file capabilities attached to it either.
+	 */
+	if (!XFS_IFORK_Q(ip)) {
+		inode_has_no_xattr(inode);
+		cache_no_acl(inode);
+	}
+}
+
+void
+xfs_setup_iops(
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = &ip->i_vnode;
+
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &xfs_inode_operations;
@@ -1241,13 +1275,11 @@ xfs_setup_inode(
 		inode->i_mapping->a_ops = &xfs_address_space_operations;
 		break;
 	case S_IFDIR:
-		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
 		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
 			inode->i_op = &xfs_dir_ci_inode_operations;
 		else
 			inode->i_op = &xfs_dir_inode_operations;
 		inode->i_fop = &xfs_dir_file_operations;
-		ip->d_ops = ip->i_mount->m_dir_inode_ops;
 		break;
 	case S_IFLNK:
 		inode->i_op = &xfs_symlink_inode_operations;
@@ -1259,21 +1291,4 @@ xfs_setup_inode(
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 		break;
 	}
-
-	/*
-	 * Ensure all page cache allocations are done from GFP_NOFS context to
-	 * prevent direct reclaim recursion back into the filesystem and blowing
-	 * stacks or deadlocking.
-	 */
-	gfp_mask = mapping_gfp_mask(inode->i_mapping);
-	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
-
-	/*
-	 * If there is no attribute fork no ACL can exist on this inode,
-	 * and it can't have any file capabilities attached to it either.
-	 */
-	if (!XFS_IFORK_Q(ip)) {
-		inode_has_no_xattr(inode);
-		cache_no_acl(inode);
-	}
 }
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
