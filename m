Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABABC7F62
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 14:09:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E1BE8F806F
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 12:09:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZoAk4h5Dj1PNFB0s (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2015 12:09:01 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] xfs: optimize inline symlinks
Date: Thu, 23 Apr 2015 21:07:44 +0200
Message-Id: <1429816064-10033-7-git-send-email-hch@lst.de>
In-Reply-To: <1429816064-10033-1-git-send-email-hch@lst.de>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
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
 fs/xfs/xfs_iops.c              | 36 +-----------------------------------
 fs/xfs/xfs_symlink.c           |  5 +++--
 6 files changed, 28 insertions(+), 51 deletions(-)

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
index 57c0998..89e0cc9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -413,45 +413,12 @@ xfs_vn_rename(
 			  new_inode ? XFS_I(new_inode) : NULL, flags);
 }
 
-/*
- * careful here - this function can get called recursively, so
- * we need to be very careful about how much stack we use.
- * uio is kmalloced for this reason...
- */
 STATIC void *
 xfs_vn_follow_link_inline(
 	struct dentry		*dentry,
 	struct nameidata	*nd)
 {
-	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
-	xfs_fsize_t		pathlen;
-	char			*link;
-	int			error = -ENOMEM;
-
-	error = -ENOMEM;
-	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
-	if (!link)
-		goto out_err;
-
-	error = -EIO;
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) 
-		goto out_kfree;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	pathlen = ip->i_d.di_size;
-	if (pathlen) {
-		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
-		link[pathlen] = '\0';
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	nd_set_link(nd, link);
-	return NULL;
-
- out_kfree:
-	kfree(link);
- out_err:
-	nd_set_link(nd, ERR_PTR(error));
+	nd_set_link(nd, XFS_I(dentry->d_inode)->i_df.if_u1.if_data);
 	return NULL;
 }
 
@@ -1204,7 +1171,6 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 static const struct inode_operations xfs_inline_symlink_inode_operations = {
 	.readlink		= generic_readlink,
 	.follow_link		= xfs_vn_follow_link_inline,
-	.put_link		= kfree_put_link,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index c1d7775..d6b59f6 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -182,12 +182,13 @@ xfs_symlink(
 
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
