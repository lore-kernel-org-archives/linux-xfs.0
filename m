Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 180EE7F5A
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 04:15:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B0028F804B
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 02:15:18 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 175qO7HqBXfTlWGW (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 May 2015 02:15:15 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] xfs: optimize inline symlinks
Date: Sun,  3 May 2015 11:13:53 +0200
Message-Id: <1430644433-26658-6-git-send-email-hch@lst.de>
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

By overallocating the in-core inode fork data buffer and zero
terminating the link target in xfs_init_local_fork we can avoid
the memory allocation in ->follow_link.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 29 +++++++++++++++++++----------
 fs/xfs/libxfs/xfs_inode_fork.h |  3 ++-
 fs/xfs/xfs_inode_item.c        |  4 ++--
 fs/xfs/xfs_iops.c              | 28 +++++++++++++++++++++++++---
 fs/xfs/xfs_symlink.c           | 14 ++++++--------
 6 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index bf83116..a438058 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -258,7 +258,7 @@ xfs_dir2_block_to_sf(
 	 * Convert the inode to local format and copy the data in.
 	 */
 	ASSERT(dp->i_df.if_bytes == 0);
-	xfs_init_local_fork(dp, XFS_DATA_FORK, dst, size);
+	xfs_init_local_fork(dp, XFS_DATA_FORK, dst, size, false);
 	dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
 	dp->i_d.di_size = size;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 86a3e11..dcadd07 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -235,22 +235,29 @@ xfs_init_local_fork(
 	struct xfs_inode	*ip,
 	int			whichfork,
 	const void		*data,
-	int			size)
+	int			size,
+	bool			zero_terminate)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	int			real_size = 0;
+	int			mem_size = size, real_size = 0;
+
+	if (zero_terminate)
+		mem_size = size + 1;
 
 	if (size == 0)
 		ifp->if_u1.if_data = NULL;
-	else if (size <= sizeof(ifp->if_u2.if_inline_data))
+	else if (mem_size <= sizeof(ifp->if_u2.if_inline_data))
 		ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
 	else {
-		real_size = roundup(size, 4);
+		real_size = roundup(mem_size, 4);
 		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP | KM_NOFS);
 	}
 
-	if (size)
+	if (size) {
 		memcpy(ifp->if_u1.if_data, data, size);
+		if (zero_terminate)
+			ifp->if_u1.if_data[size] = '\0';
+	}
 
 	ifp->if_bytes = size;
 	ifp->if_real_bytes = real_size;
@@ -270,11 +277,12 @@ xfs_init_local_fork(
  */
 STATIC int
 xfs_iformat_local(
-	xfs_inode_t	*ip,
-	xfs_dinode_t	*dip,
-	int		whichfork,
-	int		size)
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip,
+	int			whichfork,
+	int			size)
 {
+	bool			zero_terminate = S_ISDIR(dip->di_mode);
 
 	/*
 	 * If the size is unreasonable, then something
@@ -291,7 +299,8 @@ xfs_iformat_local(
 		return -EFSCORRUPTED;
 	}
 
-	xfs_init_local_fork(ip, whichfork, XFS_DFORK_PTR(dip, whichfork), size);
+	xfs_init_local_fork(ip, whichfork, XFS_DFORK_PTR(dip, whichfork), size,
+			zero_terminate);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index dfb2966..f5f640f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -135,7 +135,8 @@ void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);
-void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int);
+void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int,
+			bool);
 
 struct xfs_bmbt_rec_host *
 		xfs_iext_get_ext(struct xfs_ifork *, xfs_extnum_t);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index bf13a5a..786d91a 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -210,7 +210,7 @@ xfs_inode_item_format_data_fork(
 			 */
 			data_bytes = roundup(ip->i_df.if_bytes, 4);
 			ASSERT(ip->i_df.if_real_bytes == 0 ||
-			       ip->i_df.if_real_bytes == data_bytes);
+			       ip->i_df.if_real_bytes >= data_bytes);
 			ASSERT(ip->i_df.if_u1.if_data != NULL);
 			ASSERT(ip->i_d.di_size > 0);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
@@ -305,7 +305,7 @@ xfs_inode_item_format_attr_fork(
 			 */
 			data_bytes = roundup(ip->i_afp->if_bytes, 4);
 			ASSERT(ip->i_afp->if_real_bytes == 0 ||
-			       ip->i_afp->if_real_bytes == data_bytes);
+			       ip->i_afp->if_real_bytes >= data_bytes);
 			ASSERT(ip->i_afp->if_u1.if_data != NULL);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
 					ip->i_afp->if_u1.if_data,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d3505ff..439cf99 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -444,6 +444,15 @@ xfs_vn_follow_link(
 	return NULL;
 }
 
+STATIC void *
+xfs_vn_follow_link_inline(
+	struct dentry		*dentry,
+	struct nameidata	*nd)
+{
+	nd_set_link(nd, XFS_I(dentry->d_inode)->i_df.if_u1.if_data);
+	return NULL;
+}
+
 STATIC int
 xfs_vn_getattr(
 	struct vfsmount		*mnt,
@@ -1190,6 +1199,18 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.update_time		= xfs_vn_update_time,
 };
 
+static const struct inode_operations xfs_inline_symlink_inode_operations = {
+	.readlink		= generic_readlink,
+	.follow_link		= xfs_vn_follow_link_inline,
+	.getattr		= xfs_vn_getattr,
+	.setattr		= xfs_vn_setattr,
+	.setxattr		= generic_setxattr,
+	.getxattr		= generic_getxattr,
+	.removexattr		= generic_removexattr,
+	.listxattr		= xfs_vn_listxattr,
+	.update_time		= xfs_vn_update_time,
+};
+
 STATIC void
 xfs_diflags_to_iflags(
 	struct inode		*inode,
@@ -1308,9 +1329,10 @@ xfs_setup_iops(
 		inode->i_fop = &xfs_dir_file_operations;
 		break;
 	case S_IFLNK:
-		inode->i_op = &xfs_symlink_inode_operations;
-		if (!(ip->i_df.if_flags & XFS_IFINLINE))
-			inode->i_mapping->a_ops = &xfs_address_space_operations;
+		if (ip->i_df.if_flags & XFS_IFINLINE)
+			inode->i_op = &xfs_inline_symlink_inode_operations;
+		else
+			inode->i_op = &xfs_symlink_inode_operations;
 		break;
 	default:
 		inode->i_op = &xfs_inode_operations;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 7fa94dc..f474792 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -131,6 +131,8 @@ xfs_readlink(
 
 	trace_xfs_readlink(ip);
 
+	ASSERT(!(ip->i_df.if_flags & XFS_IFINLINE));
+
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
@@ -150,12 +152,7 @@ xfs_readlink(
 	}
 
 
-	if (ip->i_df.if_flags & XFS_IFINLINE) {
-		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
-		link[pathlen] = '\0';
-	} else {
-		error = xfs_readlink_bmap(ip, link);
-	}
+	error = xfs_readlink_bmap(ip, link);
 
  out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -302,12 +299,13 @@ xfs_symlink(
 
 	if (resblks)
 		resblks -= XFS_IALLOC_SPACE_RES(mp);
+
 	/*
 	 * If the symlink will fit into the inode, write it inline.
 	 */
 	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
-		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
-
+		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen,
+				true);
 		ip->i_d.di_size = pathlen;
 		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
