Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E51D7F66
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 04:15:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 466508F804B
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 02:15:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eIXuRNNAoqZGLyMP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 May 2015 02:15:09 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: set up inode operation vectors later
Date: Sun,  3 May 2015 11:13:51 +0200
Message-Id: <1430644433-26658-4-git-send-email-hch@lst.de>
In-Reply-To: <1430644433-26658-1-git-send-email-hch@lst.de>
References: <1430644433-26658-1-git-send-email-hch@lst.de>
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
Cc: viro@zeniv.linux.org.uk

In the next patch we'll set up different inode operations for inline vs
out of line symlinks, for that we need to make sure the flags are already
set up properly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.h |  5 ++++-
 fs/xfs/xfs_iops.c  | 59 ++++++++++++++++++++++++++++++++++--------------------
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8f22d20..d49e293 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -407,6 +407,9 @@ int	xfs_iozero(struct xfs_inode *ip, loff_t pos, size_t count);
 
 
 /* from xfs_iops.c */
+extern void xfs_setup_inode(struct xfs_inode *ip);
+extern void xfs_setup_iops(struct xfs_inode *ip);
+
 /*
  * When setting up a newly allocated inode, we need to call
  * xfs_finish_inode_setup() once the inode is fully instantiated at
@@ -414,7 +417,6 @@ int	xfs_iozero(struct xfs_inode *ip, loff_t pos, size_t count);
  * before we've completed instantiation. Otherwise we can do it
  * the moment the inode lookup is complete.
  */
-extern void xfs_setup_inode(struct xfs_inode *ip);
 static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
 {
 	xfs_iflags_clear(ip, XFS_INEW);
@@ -425,6 +427,7 @@ static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
 static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
 {
 	xfs_setup_inode(ip);
+	xfs_setup_iops(ip);
 	xfs_finish_inode_setup(ip);
 }
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2f1839e..d3505ff 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -182,6 +182,8 @@ xfs_generic_create(
 	}
 #endif
 
+	xfs_setup_iops(ip);
+
 	if (tmpfile)
 		d_tmpfile(dentry, inode);
 	else
@@ -369,6 +371,8 @@ xfs_vn_symlink(
 	if (unlikely(error))
 		goto out_cleanup_inode;
 
+	xfs_setup_iops(cip);
+
 	d_instantiate(dentry, inode);
 	xfs_finish_inode_setup(cip);
 	return 0;
@@ -1210,7 +1214,7 @@ xfs_diflags_to_iflags(
 }
 
 /*
- * Initialize the Linux inode and set up the operation vectors.
+ * Initialize the Linux inode.
  *
  * When reading existing inodes from disk this is called directly from xfs_iget,
  * when creating a new inode it is called from xfs_ialloc after setting up the
@@ -1258,8 +1262,38 @@ xfs_setup_inode(
 	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
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
@@ -1267,13 +1301,11 @@ xfs_setup_inode(
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
@@ -1285,21 +1317,4 @@ xfs_setup_inode(
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
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
