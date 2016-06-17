Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E908803E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3DCB304062
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:25 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3SoQa2kLRzGVS5e0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:20 -0700 (PDT)
Subject: [PATCH 005/145] libxfs: backport kernel 4.7 changes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:31:16 -0700
Message-ID: <146612707668.16048.8919087793316736149.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Backport the changes from kernel 4.6 -> 4.7.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/kmem.h            |    2 -
 include/xfs_trans.h       |    7 +--
 libxfs/kmem.c             |    2 -
 libxfs/libxfs_api_defs.h  |    1 
 libxfs/trans.c            |   63 ++++++++++++++++------------
 libxfs/util.c             |    5 +-
 libxfs/xfs_attr.c         |   58 ++++++--------------------
 libxfs/xfs_bmap.c         |   22 ++++------
 libxfs/xfs_dir2_sf.c      |    9 +---
 libxfs/xfs_inode_fork.c   |   99 +++++++++++++++++++++++++++++---------------
 libxfs/xfs_inode_fork.h   |    1 
 libxfs/xfs_log_format.h   |    5 ++
 libxfs/xfs_sb.c           |    8 +---
 libxfs/xfs_shared.h       |  102 +--------------------------------------------
 libxlog/xfs_log_recover.c |    2 -
 mkfs/proto.c              |   66 +++++++++++++++--------------
 mkfs/xfs_mkfs.c           |    5 +-
 repair/phase5.c           |   13 ++++--
 repair/phase6.c           |   82 ++++++++++++++----------------------
 repair/phase7.c           |    4 --
 20 files changed, 224 insertions(+), 332 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 5484d32..65f0ade 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -49,6 +49,6 @@ kmem_free(void *ptr) {
 	free(ptr);
 }
 
-extern void	*kmem_realloc(void *, size_t, size_t, int);
+extern void	*kmem_realloc(void *, size_t, int);
 
 #endif
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index d7ee1fd..a5e019d 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -71,7 +71,6 @@ typedef struct xfs_qoff_logitem {
 } xfs_qoff_logitem_t;
 
 typedef struct xfs_trans {
-	unsigned int	t_type;			/* transaction type */
 	unsigned int	t_log_res;		/* amt of log space resvd */
 	unsigned int	t_log_count;		/* count for perm log res */
 	struct xfs_mount *t_mountp;		/* ptr to fs mount struct */
@@ -87,9 +86,9 @@ typedef struct xfs_trans {
 void	xfs_trans_init(struct xfs_mount *);
 int	xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 
-xfs_trans_t	*libxfs_trans_alloc(struct xfs_mount *, int);
-int	libxfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
-				     uint, uint);
+int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
+			uint blocks, uint rtextents, uint flags,
+			struct xfs_trans **tpp);
 int	libxfs_trans_commit(struct xfs_trans *);
 void	libxfs_trans_cancel(struct xfs_trans *);
 struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index 4f3cd7e..c8bcb50 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -70,7 +70,7 @@ kmem_zalloc(size_t size, int flags)
 }
 
 void *
-kmem_realloc(void *ptr, size_t new_size, size_t old_size, int flags)
+kmem_realloc(void *ptr, size_t new_size, int flags)
 {
 	ptr = realloc(ptr, new_size);
 	if (ptr == NULL) {
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index bb502e0..611a849 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -55,7 +55,6 @@
 #define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
 #define xfs_trans_roll			libxfs_trans_roll
 #define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
-#define xfs_trans_reserve		libxfs_trans_reserve
 #define xfs_trans_resv_calc		libxfs_trans_resv_calc
 
 #define xfs_attr_get			libxfs_attr_get
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 18ea010..97a29b9 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -119,7 +119,6 @@ libxfs_trans_roll(
 	 */
 	tres.tr_logres = trans->t_log_res;
 	tres.tr_logcount = trans->t_log_count;
-	*tpp = libxfs_trans_alloc(trans->t_mountp, trans->t_type);
 
 	/*
 	 * Commit the current transaction.
@@ -132,8 +131,6 @@ libxfs_trans_roll(
 	if (error)
 		return error;
 
-	trans = *tpp;
-
 	/*
 	 * Reserve space in the log for th next transaction.
 	 * This also pushes items in the "AIL", the list of logged items,
@@ -143,7 +140,7 @@ libxfs_trans_roll(
 	 * the prior and the next transactions.
 	 */
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = xfs_trans_reserve(trans, &tres, 0, 0);
+	error = libxfs_trans_alloc(trans->t_mountp, &tres, 0, 0, 0, tpp);
 	/*
 	 *  Ensure that the inode is in the new transaction and locked.
 	 */
@@ -151,32 +148,11 @@ libxfs_trans_roll(
 		return error;
 
 	if (dp)
-		xfs_trans_ijoin(trans, dp, 0);
+		xfs_trans_ijoin(*tpp, dp, 0);
 	return 0;
 }
 
-xfs_trans_t *
-libxfs_trans_alloc(
-	xfs_mount_t	*mp,
-	int		type)
-{
-	xfs_trans_t	*ptr;
-
-	if ((ptr = calloc(sizeof(xfs_trans_t), 1)) == NULL) {
-		fprintf(stderr, _("%s: xact calloc failed (%d bytes): %s\n"),
-			progname, (int)sizeof(xfs_trans_t), strerror(errno));
-		exit(1);
-	}
-	ptr->t_mountp = mp;
-	ptr->t_type = type;
-	INIT_LIST_HEAD(&ptr->t_items);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "allocated new transaction %p\n", ptr);
-#endif
-	return ptr;
-}
-
-int
+static int
 libxfs_trans_reserve(
 	struct xfs_trans	*tp,
 	struct xfs_trans_res	*resp,
@@ -199,6 +175,39 @@ libxfs_trans_reserve(
 	return 0;
 }
 
+int
+libxfs_trans_alloc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_res	*resp,
+	uint			blocks,
+	uint			rtextents,
+	uint			flags,
+	struct xfs_trans	**tpp)
+{
+	struct xfs_trans	*ptr;
+	int			error;
+
+	if ((ptr = calloc(sizeof(xfs_trans_t), 1)) == NULL) {
+		fprintf(stderr, _("%s: xact calloc failed (%d bytes): %s\n"),
+			progname, (int)sizeof(xfs_trans_t), strerror(errno));
+		exit(1);
+	}
+	ptr->t_mountp = mp;
+	INIT_LIST_HEAD(&ptr->t_items);
+#ifdef XACT_DEBUG
+	fprintf(stderr, "allocated new transaction %p\n", ptr);
+#endif
+
+	error = libxfs_trans_reserve(ptr, resp, blocks, rtextents);
+	if (error) {
+		libxfs_trans_cancel(ptr);
+		return error;
+	}
+
+	*tpp = ptr;
+	return 0;
+}
+
 void
 libxfs_trans_cancel(
 	xfs_trans_t	*tp)
diff --git a/libxfs/util.c b/libxfs/util.c
index f3b9895..b992ad0 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -541,10 +541,9 @@ libxfs_alloc_file_space(
 	while (allocatesize_fsb && !error) {
 		datablocks = allocatesize_fsb;
 
-		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 		resblks = (uint)XFS_DIOSTRAT_SPACE_RES(mp, datablocks);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
-					  resblks, 0);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
+					  resblks, 0, 0, &tp);
 		/*
 		 * Check for running out of space
 		 */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 82a7c5e..0b05654 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -237,37 +237,21 @@ xfs_attr_set(
 			return error;
 	}
 
-	/*
-	 * Start our first transaction of the day.
-	 *
-	 * All future transactions during this code must be "chained" off
-	 * this one via the trans_dup() call.  All transactions will contain
-	 * the inode, and the inode will always be marked with trans_ihold().
-	 * Since the inode will be locked in all transactions, we must log
-	 * the inode in every transaction to let it float upward through
-	 * the log.
-	 */
-	args.trans = xfs_trans_alloc(mp, XFS_TRANS_ATTR_SET);
+	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-
-	if (rsvd)
-		args.trans->t_flags |= XFS_TRANS_RESERVE;
-
-	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
-	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
-	if (error) {
-		xfs_trans_cancel(args.trans);
+	error = xfs_trans_alloc(mp, &tres, args.total, 0,
+			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+	if (error)
 		return error;
-	}
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
 
+	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
 				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 				       XFS_QMOPT_RES_REGBLKS);
@@ -424,31 +408,15 @@ xfs_attr_remove(
 		return error;
 
 	/*
-	 * Start our first transaction of the day.
-	 *
-	 * All future transactions during this code must be "chained" off
-	 * this one via the trans_dup() call.  All transactions will contain
-	 * the inode, and the inode will always be marked with trans_ihold().
-	 * Since the inode will be locked in all transactions, we must log
-	 * the inode in every transaction to let it float upward through
-	 * the log.
-	 */
-	args.trans = xfs_trans_alloc(mp, XFS_TRANS_ATTR_RM);
-
-	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-
-	if (flags & ATTR_ROOT)
-		args.trans->t_flags |= XFS_TRANS_RESERVE;
-
-	error = xfs_trans_reserve(args.trans, &M_RES(mp)->tr_attrrm,
-				  XFS_ATTRRM_SPACE_RES(mp), 0);
-	if (error) {
-		xfs_trans_cancel(args.trans);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
+			XFS_ATTRRM_SPACE_RES(mp), 0,
+			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
+			&args.trans);
+	if (error)
 		return error;
-	}
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	/*
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cbcfd72..c2a2c53 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1113,15 +1113,14 @@ xfs_bmap_add_attrfork(
 
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
-	tp = xfs_trans_alloc(mp, XFS_TRANS_ADDAFORK);
+
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
-	if (rsvd)
-		tp->t_flags |= XFS_TRANS_RESERVE;
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_addafork, blks, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_addafork, blks, 0,
+			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
+	if (error)
 		return error;
-	}
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
 			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
@@ -6018,13 +6017,10 @@ xfs_bmap_split_extent(
 	xfs_fsblock_t           firstfsb;
 	int                     error;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
-			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
+	if (error)
 		return error;
-	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index e4b505b..90b07f7 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -255,15 +255,12 @@ xfs_dir2_block_to_sf(
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 2af1dba..799873a 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -227,6 +227,48 @@ xfs_iformat_fork(
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
+
+	if (size == 0)
+		ifp->if_u1.if_data = NULL;
+	else if (mem_size <= sizeof(ifp->if_u2.if_inline_data))
+		ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
+	else {
+		real_size = roundup(mem_size, 4);
+		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP | KM_NOFS);
+	}
+
+	if (size) {
+		memcpy(ifp->if_u1.if_data, data, size);
+		if (zero_terminate)
+			ifp->if_u1.if_data[size] = '\0';
+	}
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
@@ -244,8 +286,6 @@ xfs_iformat_local(
 	int		whichfork,
 	int		size)
 {
-	xfs_ifork_t	*ifp;
-	int		real_size;
 
 	/*
 	 * If the size is unreasonable, then something
@@ -261,22 +301,8 @@ xfs_iformat_local(
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
 
@@ -512,7 +538,6 @@ xfs_iroot_realloc(
 		new_max = cur_max + rec_diff;
 		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
 		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
-				XFS_BMAP_BROOT_SPACE_CALC(mp, cur_max),
 				KM_SLEEP | KM_NOFS);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
@@ -656,7 +681,6 @@ xfs_idata_realloc(
 				ifp->if_u1.if_data =
 					kmem_realloc(ifp->if_u1.if_data,
 							real_size,
-							ifp->if_real_bytes,
 							KM_SLEEP | KM_NOFS);
 			}
 		} else {
@@ -1372,8 +1396,7 @@ xfs_iext_realloc_direct(
 		if (rnew_size != ifp->if_real_bytes) {
 			ifp->if_u1.if_extents =
 				kmem_realloc(ifp->if_u1.if_extents,
-						rnew_size,
-						ifp->if_real_bytes, KM_NOFS);
+						rnew_size, KM_NOFS);
 		}
 		if (rnew_size > ifp->if_real_bytes) {
 			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
@@ -1457,9 +1480,8 @@ xfs_iext_realloc_indirect(
 	if (new_size == 0) {
 		xfs_iext_destroy(ifp);
 	} else {
-		ifp->if_u1.if_ext_irec = (xfs_ext_irec_t *)
-			kmem_realloc(ifp->if_u1.if_ext_irec,
-				new_size, size, KM_NOFS);
+		ifp->if_u1.if_ext_irec =
+			kmem_realloc(ifp->if_u1.if_ext_irec, new_size, KM_NOFS);
 	}
 }
 
@@ -1493,6 +1515,24 @@ xfs_iext_indirect_to_direct(
 }
 
 /*
+ * Remove all records from the indirection array.
+ */
+STATIC void
+xfs_iext_irec_remove_all(
+	struct xfs_ifork *ifp)
+{
+	int		nlists;
+	int		i;
+
+	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
+	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
+	for (i = 0; i < nlists; i++)
+		kmem_free(ifp->if_u1.if_ext_irec[i].er_extbuf);
+	kmem_free(ifp->if_u1.if_ext_irec);
+	ifp->if_flags &= ~XFS_IFEXTIREC;
+}
+
+/*
  * Free incore file extents.
  */
 void
@@ -1500,14 +1540,7 @@ xfs_iext_destroy(
 	xfs_ifork_t	*ifp)		/* inode fork pointer */
 {
 	if (ifp->if_flags & XFS_IFEXTIREC) {
-		int	erp_idx;
-		int	nlists;
-
-		nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-		for (erp_idx = nlists - 1; erp_idx >= 0 ; erp_idx--) {
-			xfs_iext_irec_remove(ifp, erp_idx);
-		}
-		ifp->if_flags &= ~XFS_IFEXTIREC;
+		xfs_iext_irec_remove_all(ifp);
 	} else if (ifp->if_real_bytes) {
 		kmem_free(ifp->if_u1.if_extents);
 	} else if (ifp->if_bytes) {
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 7d3b1ed..f95e072 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -134,6 +134,7 @@ void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);
+void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int);
 
 struct xfs_bmbt_rec_host *
 		xfs_iext_get_ext(struct xfs_ifork *, xfs_extnum_t);
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 40005bf..e5baba3 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -212,6 +212,11 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_HEADER_MAGIC	0x5452414e	/* TRAN */
 
 /*
+ * The only type valid for th_type in CIL-enabled file system logs:
+ */
+#define XFS_TRANS_CHECKPOINT	40
+
+/*
  * Log item types.
  */
 #define	XFS_LI_EFI		0x1236
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 67c7a65..e2cc83e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -839,12 +839,10 @@ xfs_sync_sb(
 	struct xfs_trans	*tp;
 	int			error;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_CHANGE, KM_SLEEP);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0,
+			XFS_TRANS_NO_WRITECOUNT, &tp);
+	if (error)
 		return error;
-	}
 
 	xfs_log_sb(tp);
 	if (wait)
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 81ac870..16002b5 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -56,103 +56,6 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 
 /*
- * Transaction types.  Used to distinguish types of buffers. These never reach
- * the log.
- */
-#define XFS_TRANS_SETATTR_NOT_SIZE	1
-#define XFS_TRANS_SETATTR_SIZE		2
-#define XFS_TRANS_INACTIVE		3
-#define XFS_TRANS_CREATE		4
-#define XFS_TRANS_CREATE_TRUNC		5
-#define XFS_TRANS_TRUNCATE_FILE		6
-#define XFS_TRANS_REMOVE		7
-#define XFS_TRANS_LINK			8
-#define XFS_TRANS_RENAME		9
-#define XFS_TRANS_MKDIR			10
-#define XFS_TRANS_RMDIR			11
-#define XFS_TRANS_SYMLINK		12
-#define XFS_TRANS_SET_DMATTRS		13
-#define XFS_TRANS_GROWFS		14
-#define XFS_TRANS_STRAT_WRITE		15
-#define XFS_TRANS_DIOSTRAT		16
-/* 17 was XFS_TRANS_WRITE_SYNC */
-#define	XFS_TRANS_WRITEID		18
-#define	XFS_TRANS_ADDAFORK		19
-#define	XFS_TRANS_ATTRINVAL		20
-#define	XFS_TRANS_ATRUNCATE		21
-#define	XFS_TRANS_ATTR_SET		22
-#define	XFS_TRANS_ATTR_RM		23
-#define	XFS_TRANS_ATTR_FLAG		24
-#define	XFS_TRANS_CLEAR_AGI_BUCKET	25
-#define XFS_TRANS_SB_CHANGE		26
-/*
- * Dummy entries since we use the transaction type to index into the
- * trans_type[] in xlog_recover_print_trans_head()
- */
-#define XFS_TRANS_DUMMY1		27
-#define XFS_TRANS_DUMMY2		28
-#define XFS_TRANS_QM_QUOTAOFF		29
-#define XFS_TRANS_QM_DQALLOC		30
-#define XFS_TRANS_QM_SETQLIM		31
-#define XFS_TRANS_QM_DQCLUSTER		32
-#define XFS_TRANS_QM_QINOCREATE		33
-#define XFS_TRANS_QM_QUOTAOFF_END	34
-#define XFS_TRANS_FSYNC_TS		35
-#define	XFS_TRANS_GROWFSRT_ALLOC	36
-#define	XFS_TRANS_GROWFSRT_ZERO		37
-#define	XFS_TRANS_GROWFSRT_FREE		38
-#define	XFS_TRANS_SWAPEXT		39
-#define	XFS_TRANS_CHECKPOINT		40
-#define	XFS_TRANS_ICREATE		41
-#define	XFS_TRANS_CREATE_TMPFILE	42
-#define	XFS_TRANS_TYPE_MAX		43
-/* new transaction types need to be reflected in xfs_logprint(8) */
-
-#define XFS_TRANS_TYPES \
-	{ XFS_TRANS_SETATTR_NOT_SIZE,	"SETATTR_NOT_SIZE" }, \
-	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
-	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
-	{ XFS_TRANS_CREATE,		"CREATE" }, \
-	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
-	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
-	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
-	{ XFS_TRANS_LINK,		"LINK" }, \
-	{ XFS_TRANS_RENAME,		"RENAME" }, \
-	{ XFS_TRANS_MKDIR,		"MKDIR" }, \
-	{ XFS_TRANS_RMDIR,		"RMDIR" }, \
-	{ XFS_TRANS_SYMLINK,		"SYMLINK" }, \
-	{ XFS_TRANS_SET_DMATTRS,	"SET_DMATTRS" }, \
-	{ XFS_TRANS_GROWFS,		"GROWFS" }, \
-	{ XFS_TRANS_STRAT_WRITE,	"STRAT_WRITE" }, \
-	{ XFS_TRANS_DIOSTRAT,		"DIOSTRAT" }, \
-	{ XFS_TRANS_WRITEID,		"WRITEID" }, \
-	{ XFS_TRANS_ADDAFORK,		"ADDAFORK" }, \
-	{ XFS_TRANS_ATTRINVAL,		"ATTRINVAL" }, \
-	{ XFS_TRANS_ATRUNCATE,		"ATRUNCATE" }, \
-	{ XFS_TRANS_ATTR_SET,		"ATTR_SET" }, \
-	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
-	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
-	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
-	{ XFS_TRANS_SB_CHANGE,		"SBCHANGE" }, \
-	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
-	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
-	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
-	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
-	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
-	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
-	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
-	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
-	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
-	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
-	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
-	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
-	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
-	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
-	{ XFS_TRANS_ICREATE,		"ICREATE" }, \
-	{ XFS_TRANS_CREATE_TMPFILE,	"CREATE_TMPFILE" }, \
-	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
-
-/*
  * This structure is used to track log items associated with
  * a transaction.  It points to the log item and keeps some
  * flags to track the state of the log item.  It also tracks
@@ -181,8 +84,9 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
-#define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
-					   count in superblock */
+#define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
+#define XFS_TRANS_NOFS		0x80	/* pass KM_NOFS to kmem_alloc */
+
 /*
  * Field values for xfs_trans_mod_sb.
  */
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 6116ecd..6cd77d5 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1062,7 +1062,7 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = kmem_realloc(old_ptr, len+old_len, old_len, KM_SLEEP);
+	ptr = kmem_realloc(old_ptr, len+old_len, KM_SLEEP);
 	memcpy(&ptr[old_len], dp, len); /* d, s, l */
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 09a9439..edbaa33 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -25,7 +25,7 @@
  */
 static char *getstr(char **pp);
 static void fail(char *msg, int i);
-static void getres(xfs_trans_t *tp, uint blocks);
+static void getres(struct xfs_mount *mp, uint blocks, struct xfs_trans **tpp);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, xfs_bmap_free_t *flist,
 	xfs_fsblock_t *first, int dolocal, int logit, char *buf, int len);
@@ -127,22 +127,23 @@ res_failed(
 
 static void
 getres(
-	xfs_trans_t	*tp,
-	uint		blocks)
+	struct xfs_mount	*mp,
+	uint			blocks,
+	struct xfs_trans	**tpp)
 {
-	int		i;
-	xfs_mount_t	*mp;
-	uint		r;
-
-	mp = tp->t_mountp;
-	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
-		struct xfs_trans_res    tres = {0};
-
-		i = -libxfs_trans_reserve(tp, &tres, r, 0);
-		if (i == 0)
+	struct xfs_trans	*tp;
+	uint			r;
+	int			error = -ENOSPC;
+
+	for (r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
+		error = libxfs_trans_alloc(mp, NULL, r, 0, 0, &tp);
+		if (!error) {
+			*tpp = tp;
 			return;
+		}
 	}
-	res_failed(i);
+
+	res_failed(error);
 	/* NOTREACHED */
 }
 
@@ -203,7 +204,11 @@ rsvfile(
 	/*
 	 * update the inode timestamp, mode, and prealloc flag bits
 	 */
-	tp = libxfs_trans_alloc(mp, 0);
+	error = -libxfs_trans_alloc(mp, NULL, 0, 0, 0, &tp);
+	if (error) {
+		fail(_("error reserving space for a file"), error);
+		exit(1);
+	}
 
 	libxfs_trans_ijoin(tp, ip, 0);
 
@@ -454,13 +459,12 @@ parseproto(
 	xname.name = (unsigned char *)name;
 	xname.len = name ? strlen(name) : 0;
 	xname.type = 0;
-	tp = libxfs_trans_alloc(mp, 0);
 	flags = XFS_ILOG_CORE;
 	xfs_bmap_init(&flist, &first);
 	switch (fmt) {
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
-		getres(tp, XFS_B_TO_FSB(mp, len));
+		getres(mp, XFS_B_TO_FSB(mp, len), &tp);
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
 					   &creds, fsxp, &ip);
 		if (error)
@@ -483,7 +487,7 @@ parseproto(
 				progname, value, name);
 			exit(1);
 		}
-		getres(tp, XFS_B_TO_FSB(mp, llen));
+		getres(mp, XFS_B_TO_FSB(mp, llen), &tp);
 
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
 					  &creds, fsxp, &ip);
@@ -505,7 +509,7 @@ parseproto(
 		return;
 
 	case IF_BLOCK:
-		getres(tp, 0);
+		getres(mp, 0, &tp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFBLK, 1,
@@ -520,7 +524,7 @@ parseproto(
 		break;
 
 	case IF_CHAR:
-		getres(tp, 0);
+		getres(mp, 0, &tp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFCHR, 1,
@@ -534,7 +538,7 @@ parseproto(
 		break;
 
 	case IF_FIFO:
-		getres(tp, 0);
+		getres(mp, 0, &tp);
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFIFO, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
@@ -546,7 +550,7 @@ parseproto(
 	case IF_SYMLINK:
 		buf = getstr(pp);
 		len = (int)strlen(buf);
-		getres(tp, XFS_B_TO_FSB(mp, len));
+		getres(mp, XFS_B_TO_FSB(mp, len), &tp);
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFLNK, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
@@ -557,7 +561,7 @@ parseproto(
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		break;
 	case IF_DIRECTORY:
-		getres(tp, 0);
+		getres(mp, 0, &tp);
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
@@ -649,8 +653,7 @@ rtinit(
 	/*
 	 * First, allocate the inodes.
 	 */
-	tp = libxfs_trans_alloc(mp, 0);
-	i = -libxfs_trans_reserve(tp, &tres, MKFS_BLOCKRES_INODE, 0);
+	i = -libxfs_trans_alloc(mp, &tres, MKFS_BLOCKRES_INODE, 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
@@ -687,9 +690,8 @@ rtinit(
 	/*
 	 * Next, give the bitmap file some zero-filled blocks.
 	 */
-	tp = libxfs_trans_alloc(mp, 0);
-	i = -libxfs_trans_reserve(tp, &tres, mp->m_sb.sb_rbmblocks +
-				 (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	i = -libxfs_trans_alloc(mp, &tres, mp->m_sb.sb_rbmblocks +
+			 (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
@@ -723,10 +725,9 @@ rtinit(
 	/*
 	 * Give the summary file some zero-filled blocks.
 	 */
-	tp = libxfs_trans_alloc(mp, 0);
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	i = -libxfs_trans_reserve(tp, &tres, nsumblocks +
-				 (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	i = -libxfs_trans_alloc(mp, &tres, nsumblocks +
+			(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0, 0, &tp);
 	if (i)
 		res_failed(i);
 	libxfs_trans_ijoin(tp, rsumip, 0);
@@ -760,8 +761,7 @@ rtinit(
 	 * Do one transaction per bitmap block.
 	 */
 	for (bno = 0; bno < mp->m_sb.sb_rextents; bno = ebno) {
-		tp = libxfs_trans_alloc(mp, 0);
-		i = -libxfs_trans_reserve(tp, &tres, 0, 0);
+		i = -libxfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
 		if (i)
 			res_failed(i);
 		libxfs_trans_ijoin(tp, rbmip, 0);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 955dcfd..de00c8e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3451,14 +3451,15 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		struct xfs_trans_res tres = {0};
 
 		memset(&args, 0, sizeof(args));
-		args.tp = tp = libxfs_trans_alloc(mp, 0);
+		
 		args.mp = mp;
 		args.agno = agno;
 		args.alignment = 1;
 		args.pag = xfs_perag_get(mp,agno);
-		c = -libxfs_trans_reserve(tp, &tres, worst_freelist, 0);
+		c = -libxfs_trans_alloc(mp, &tres, worst_freelist, 0, 0, &tp);
 		if (c)
 			res_failed(c);
+		args.tp = tp;
 
 		libxfs_alloc_fix_freelist(&args, 0);
 		xfs_perag_put(args.pag);
diff --git a/repair/phase5.c b/repair/phase5.c
index 5d48848..b58111b 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1505,14 +1505,19 @@ build_agf_agfl(xfs_mount_t	*mp,
 		int		error;
 
 		memset(&args, 0, sizeof(args));
-		args.tp = tp = libxfs_trans_alloc(mp, 0);
 		args.mp = mp;
 		args.agno = agno;
 		args.alignment = 1;
 		args.pag = xfs_perag_get(mp,agno);
-		libxfs_trans_reserve(tp, &tres,
-				     xfs_alloc_min_freelist(mp, args.pag), 0);
-		error = libxfs_alloc_fix_freelist(&args, 0);
+		error = -libxfs_trans_alloc(mp, &tres,
+				xfs_alloc_min_freelist(mp, args.pag),
+				0, 0, &tp);
+		if (error) {
+			do_error(_("failed to fix AGFL on AG %d, error %d\n"),
+					agno, error);
+		}
+		args.tp = tp;
+		error = -libxfs_alloc_fix_freelist(&args, 0);
 		xfs_perag_put(args.pag);
 		if (error) {
 			do_error(_("failed to fix AGFL on AG %d, error %d\n"),
diff --git a/repair/phase6.c b/repair/phase6.c
index 7353c3a..d1acb68 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -494,9 +494,7 @@ mk_rbmino(xfs_mount_t *mp)
 	/*
 	 * first set up inode
 	 */
-	tp = libxfs_trans_alloc(mp, 0);
-
-	i = -libxfs_trans_reserve(tp, &tres, 10, 0);
+	i = -libxfs_trans_alloc(mp, &tres, 10, 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
@@ -544,9 +542,9 @@ mk_rbmino(xfs_mount_t *mp)
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	tp = libxfs_trans_alloc(mp, 0);
-	error = -libxfs_trans_reserve(tp, &tres, mp->m_sb.sb_rbmblocks +
-				(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	error = -libxfs_trans_alloc(mp, &tres, mp->m_sb.sb_rbmblocks +
+				(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
+				0, 0, &tp);
 	if (error)
 		res_failed(error);
 
@@ -598,9 +596,7 @@ fill_rbmino(xfs_mount_t *mp)
 	bmp = btmcompute;
 	bno = 0;
 
-	tp = libxfs_trans_alloc(mp, 0);
-
-	error = -libxfs_trans_reserve(tp, &tres, 10, 0);
+	error = -libxfs_trans_alloc(mp, &tres, 10, 0, 0, &tp);
 	if (error)
 		res_failed(error);
 
@@ -671,9 +667,7 @@ fill_rsumino(xfs_mount_t *mp)
 	bno = 0;
 	end_bno = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 
-	tp = libxfs_trans_alloc(mp, 0);
-
-	error = -libxfs_trans_reserve(tp, &tres, 10, 0);
+	error = -libxfs_trans_alloc(mp, &tres, 10, 0, 0, &tp);
 	if (error)
 		res_failed(error);
 
@@ -747,9 +741,7 @@ mk_rsumino(xfs_mount_t *mp)
 	/*
 	 * first set up inode
 	 */
-	tp = libxfs_trans_alloc(mp, 0);
-
-	i = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 10, 0);
+	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
@@ -797,15 +789,15 @@ mk_rsumino(xfs_mount_t *mp)
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	tp = libxfs_trans_alloc(mp, 0);
 	xfs_bmap_init(&flist, &first);
 
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 	tres.tr_logres = BBTOB(128);
 	tres.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = -libxfs_trans_reserve(tp, &tres, mp->m_sb.sb_rbmblocks +
-			      (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1), 0);
+	error = -libxfs_trans_alloc(mp, &tres, mp->m_sb.sb_rbmblocks +
+			      (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
+			      0, 0, &tp);
 	if (error)
 		res_failed(error);
 
@@ -854,10 +846,9 @@ mk_root_dir(xfs_mount_t *mp)
 	int		vers;
 	int		times;
 
-	tp = libxfs_trans_alloc(mp, 0);
 	ip = NULL;
 
-	i = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 10, 0);
+	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
@@ -954,11 +945,10 @@ mk_orphanage(xfs_mount_t *mp)
 	 * could not be found, create it
 	 */
 
-	tp = libxfs_trans_alloc(mp, 0);
 	xfs_bmap_init(&flist, &first);
 
 	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
-	i = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_mkdir, nres, 0);
+	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
@@ -1092,8 +1082,6 @@ mv_orphanage(
 		xname.len = snprintf((char *)fname, sizeof(fname), "%llu.%d",
 					(unsigned long long)ino, ++incr);
 
-	tp = libxfs_trans_alloc(mp, 0);
-
 	if ((err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, 0)))
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
@@ -1112,8 +1100,8 @@ mv_orphanage(
 		if (err) {
 			ASSERT(err == ENOENT);
 
-			err = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_rename,
-						   nres, 0);
+			err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
+						   nres, 0, 0, &tp);
 			if (err)
 				do_error(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
@@ -1154,8 +1142,8 @@ mv_orphanage(
 
 			libxfs_trans_commit(tp);
 		} else  {
-			err = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_rename,
-						   nres, 0);
+			err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
+						   nres, 0, 0, &tp);
 			if (err)
 				do_error(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
@@ -1210,8 +1198,8 @@ mv_orphanage(
 		 * also accounted for in the create
 		 */
 		nres = XFS_DIRENTER_SPACE_RES(mp, xname.len);
-		err = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove,
-					   nres, 0);
+		err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
+					   nres, 0, 0, &tp);
 		if (err)
 			do_error(
 	_("space reservation failed (%d), filesystem may be out of space\n"),
@@ -1306,9 +1294,8 @@ longform_dir2_rebuild(
 
 	xfs_bmap_init(&flist, &firstblock);
 
-	tp = libxfs_trans_alloc(mp, 0);
 	nres = XFS_REMOVE_SPACE_RES(mp);
-	error = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove, nres, 0);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -1349,10 +1336,9 @@ longform_dir2_rebuild(
 						p->name.name[1] == '.'))))
 			continue;
 
-		tp = libxfs_trans_alloc(mp, 0);
 		nres = XFS_CREATE_SPACE_RES(mp, p->name.len);
-		error = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_create,
-					     nres, 0);
+		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_create,
+					     nres, 0, 0, &tp);
 		if (error)
 			res_failed(error);
 
@@ -1406,9 +1392,8 @@ dir2_kill_block(
 	int		nres;
 	xfs_trans_t	*tp;
 
-	tp = libxfs_trans_alloc(mp, 0);
 	nres = XFS_REMOVE_SPACE_RES(mp);
-	error = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove, nres, 0);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
@@ -1598,8 +1583,7 @@ longform_dir2_entry_check_data(
 	if (freetab->nents < db + 1)
 		freetab->nents = db + 1;
 
-	tp = libxfs_trans_alloc(mp, 0);
-	error = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove, 0, 0);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0, &tp);
 	if (error)
 		res_failed(error);
 	da.trans = tp;
@@ -2902,7 +2886,6 @@ process_dir_inode(
 			break;
 
 		case XFS_DINODE_FMT_LOCAL:
-			tp = libxfs_trans_alloc(mp, 0);
 			/*
 			 * using the remove reservation is overkill
 			 * since at most we'll only need to log the
@@ -2910,8 +2893,8 @@ process_dir_inode(
 			 * new define in ourselves.
 			 */
 			nres = no_modify ? 0 : XFS_REMOVE_SPACE_RES(mp);
-			error = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove,
-						     nres, 0);
+			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
+						     nres, 0, 0, &tp);
 			if (error)
 				res_failed(error);
 
@@ -2951,13 +2934,12 @@ process_dir_inode(
 
 		do_warn(_("recreating root directory .. entry\n"));
 
-		tp = libxfs_trans_alloc(mp, 0);
-		ASSERT(tp != NULL);
-
 		nres = XFS_MKDIR_SPACE_RES(mp, 2);
-		error = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_mkdir, nres, 0);
+		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
+				nres, 0, 0, &tp);
 		if (error)
 			res_failed(error);
+		ASSERT(tp != NULL);
 
 		libxfs_trans_ijoin(tp, ip, 0);
 
@@ -3010,14 +2992,12 @@ process_dir_inode(
 			do_warn(
 	_("creating missing \".\" entry in dir ino %" PRIu64 "\n"), ino);
 
-			tp = libxfs_trans_alloc(mp, 0);
-			ASSERT(tp != NULL);
-
 			nres = XFS_MKDIR_SPACE_RES(mp, 1);
-			error = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_mkdir,
-						     nres, 0);
+			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
+						     nres, 0, 0, &tp);
 			if (error)
 				res_failed(error);
+			ASSERT(tp != NULL);
 
 			libxfs_trans_ijoin(tp, ip, 0);
 
diff --git a/repair/phase7.c b/repair/phase7.c
index 3e234b9..8bce117 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -40,10 +40,8 @@ update_inode_nlinks(
 	int			dirty;
 	int			nres;
 
-	tp = libxfs_trans_alloc(mp, XFS_TRANS_REMOVE);
-
 	nres = no_modify ? 0 : 10;
-	error = -libxfs_trans_reserve(tp, &M_RES(mp)->tr_remove, nres, 0);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	ASSERT(error == 0);
 
 	error = -libxfs_trans_iget(mp, tp, ino, 0, 0, &ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
