Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC7CB7CCC
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 08:49:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1FB75AC007
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:49:00 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id AzNNy0AMFIFR3QTg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:48:58 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aij9d-00013p-18
	for xfs@oss.sgi.com; Wed, 23 Mar 2016 13:48:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] xfs: factor out a helper to initialize a local format
	inode fork
Date: Wed, 23 Mar 2016 14:48:52 +0100
Message-Id: <1458740935-31260-2-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c    |  9 +++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 48 ++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_inode_fork.h |  1 +
 fs/xfs/xfs_symlink.c           | 12 ++---------
 4 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 974d62e..e5bb9cc 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -257,15 +257,12 @@ xfs_dir2_block_to_sf(
 	 *
 	 * Convert the inode to local format and copy the data in.
 	 */
-	dp->i_df.if_flags &= ~XFS_IFEXTENTS;
-	dp->i_df.if_flags |= XFS_IFINLINE;
-	dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
 	ASSERT(dp->i_df.if_bytes == 0);
-	xfs_idata_realloc(dp, size, XFS_DATA_FORK);
+	xfs_init_local_fork(dp, XFS_DATA_FORK, dst, size);
+	dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+	dp->i_d.di_size = size;
 
 	logflags |= XFS_ILOG_DDATA;
-	memcpy(dp->i_df.if_u1.if_data, dst, size);
-	dp->i_d.di_size = size;
 	xfs_dir2_sf_check(args);
 out:
 	xfs_trans_log_inode(args->trans, dp, logflags);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 11faf7d..86a97f8 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -231,6 +231,34 @@ xfs_iformat_fork(
 	return error;
 }
 
+void
+xfs_init_local_fork(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	const void		*data,
+	int			size)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	int			real_size = 0;
+
+	if (size == 0)
+		ifp->if_u1.if_data = NULL;
+	else if (size <= sizeof(ifp->if_u2.if_inline_data))
+		ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
+	else {
+		real_size = roundup(size, 4);
+		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP | KM_NOFS);
+	}
+
+	if (size)
+		memcpy(ifp->if_u1.if_data, data, size);
+
+	ifp->if_bytes = size;
+	ifp->if_real_bytes = real_size;
+	ifp->if_flags &= ~(XFS_IFEXTENTS | XFS_IFBROOT);
+	ifp->if_flags |= XFS_IFINLINE;
+}
+
 /*
  * The file is in-lined in the on-disk inode.
  * If it fits into if_inline_data, then copy
@@ -248,8 +276,6 @@ xfs_iformat_local(
 	int		whichfork,
 	int		size)
 {
-	xfs_ifork_t	*ifp;
-	int		real_size;
 
 	/*
 	 * If the size is unreasonable, then something
@@ -265,22 +291,8 @@ xfs_iformat_local(
 				     ip->i_mount, dip);
 		return -EFSCORRUPTED;
 	}
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	real_size = 0;
-	if (size == 0)
-		ifp->if_u1.if_data = NULL;
-	else if (size <= sizeof(ifp->if_u2.if_inline_data))
-		ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
-	else {
-		real_size = roundup(size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP | KM_NOFS);
-	}
-	ifp->if_bytes = size;
-	ifp->if_real_bytes = real_size;
-	if (size)
-		memcpy(ifp->if_u1.if_data, XFS_DFORK_PTR(dip, whichfork), size);
-	ifp->if_flags &= ~XFS_IFEXTENTS;
-	ifp->if_flags |= XFS_IFINLINE;
+
+	xfs_init_local_fork(ip, whichfork, XFS_DFORK_PTR(dip, whichfork), size);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7d3b1ed..f95e072 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -134,6 +134,7 @@ void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);
+void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int);
 
 struct xfs_bmbt_rec_host *
 		xfs_iext_get_ext(struct xfs_ifork *, xfs_extnum_t);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b44284c..b69f4a7 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -302,19 +302,11 @@ xfs_symlink(
 	 * If the symlink will fit into the inode, write it inline.
 	 */
 	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
-		xfs_idata_realloc(ip, pathlen, XFS_DATA_FORK);
-		memcpy(ip->i_df.if_u1.if_data, target_path, pathlen);
-		ip->i_d.di_size = pathlen;
-
-		/*
-		 * The inode was initially created in extent format.
-		 */
-		ip->i_df.if_flags &= ~(XFS_IFEXTENTS | XFS_IFBROOT);
-		ip->i_df.if_flags |= XFS_IFINLINE;
+		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
 
+		ip->i_d.di_size = pathlen;
 		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
-
 	} else {
 		int	offset;
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
