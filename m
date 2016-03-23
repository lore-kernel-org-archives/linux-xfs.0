Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C6F77CD6
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 08:49:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 603E68F8039
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:49:02 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id Cbqq1OSRhGF5ZxNk (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:49:00 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aij9f-000143-1k
	for xfs@oss.sgi.com; Wed, 23 Mar 2016 13:48:59 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] xfs: optimize inline symlinks
Date: Wed, 23 Mar 2016 14:48:55 +0100
Message-Id: <1458740935-31260-5-git-send-email-hch@lst.de>
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

By overallocating the in-core inode fork data buffer and zero
terminating the link target in xfs_init_local_fork we can avoid
the memory allocation in ->follow_link.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 22 ++++++++++++++++++----
 fs/xfs/xfs_inode_item.c        |  4 ++--
 fs/xfs/xfs_iops.c              | 29 ++++++++++++++++++++++++++---
 fs/xfs/xfs_symlink.c           |  9 +++------
 4 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 86a97f8..4fbe226 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -239,19 +239,33 @@ xfs_init_local_fork(
 	int			size)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	int			real_size = 0;
+	int			mem_size = size, real_size = 0;
+	bool			zero_terminate;
+
+	/*
+	 * If we are using the local fork to store a symlink body we need to
+	 * zero-terminate it so that we can pass it back to the VFS directly.
+	 * Overallocate the in-memory fork by one for that and add a zero
+	 * to terminate it below.
+	 */
+	zero_terminate = S_ISLNK(VFS_I(ip)->i_mode);
+	if (zero_terminate)
+		mem_size++;
 
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
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c48b5b1..37e23c7 100644
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
index f08d91c..aee06d9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -446,6 +446,16 @@ xfs_vn_get_link(
 	return ERR_PTR(error);
 }
 
+STATIC const char *
+xfs_vn_get_link_inline(
+	struct dentry		*dentry,
+	struct inode		*inode,
+	struct delayed_call	*done)
+{
+	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
+	return XFS_I(inode)->i_df.if_u1.if_data;
+}
+
 STATIC int
 xfs_vn_getattr(
 	struct vfsmount		*mnt,
@@ -1171,6 +1181,18 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.update_time		= xfs_vn_update_time,
 };
 
+static const struct inode_operations xfs_inline_symlink_inode_operations = {
+	.readlink		= generic_readlink,
+	.get_link		= xfs_vn_get_link_inline,
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
@@ -1282,9 +1304,10 @@ xfs_setup_iops(
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
index b69f4a7..5961c1e 100644
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
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
