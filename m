Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D2AC380D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 908B58F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:48 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 0rWS2rcPFaghT3QY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:46 -0800 (PST)
Subject: [PATCH 75/76] xfs: preallocate blocks for worst-case refcount btree
	expansion
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:42 -0800
Message-ID: <20151219090442.12713.86940.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

To gracefully handle the situation where a CoW operation turns a
single refcount extent into a lot of tiny ones and then run out of
space when a tree split has to happen, use the per-AG reserved block
pool to pre-allocate all the space we'll ever need for a maximal
btree.  For a 4K block size, this only costs an overhead of 0.3% of
available disk space.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount_btree.c |  184 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 +
 fs/xfs/xfs_fsops.c                 |    4 +
 fs/xfs/xfs_mount.c                 |   10 ++
 fs/xfs/xfs_mount.h                 |    1 
 fs/xfs/xfs_super.c                 |   14 +++
 6 files changed, 216 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index c785433..7f8bdc4 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -33,6 +33,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_bit.h"
+#include "xfs_perag_pool.h"
 
 static struct xfs_btree_cur *
 xfs_refcountbt_dup_cursor(
@@ -72,8 +73,32 @@ xfs_refcountbt_alloc_block(
 	int			*stat)
 {
 	struct xfs_alloc_arg	args;		/* block allocation args */
+	struct xfs_perag	*pag;
+	xfs_agblock_t		bno;
 	int			error;		/* error return value */
 
+	/* First try the per-AG reserve pool. */
+	pag = xfs_perag_get(cur->bc_mp, cur->bc_private.a.agno);
+	error = xfs_perag_pool_alloc_block(pag->pagf_refcountbt_pool,
+			cur->bc_tp, &bno);
+	xfs_perag_put(pag);
+
+	switch (error) {
+	case 0:
+		*stat = 1;
+		new->s = cpu_to_be32(bno);
+		return 0;
+	case -EINVAL:
+		break;
+	case -ENOSPC:
+		error = 0;
+		/* fall through */
+	default:
+		*stat = 0;
+		return error;
+	}
+
+	/* No pool; try a regular allocation. */
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
@@ -113,9 +138,27 @@ xfs_refcountbt_free_block(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_trans	*tp = cur->bc_tp;
+	struct xfs_perag	*pag;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	struct xfs_owner_info	oinfo;
+	int			error;
 
+	/* Try to give it back to the pool. */
+	pag = xfs_perag_get(cur->bc_mp, cur->bc_private.a.agno);
+	error = xfs_perag_pool_free_block(pag->pagf_refcountbt_pool, cur->bc_tp,
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno));
+	xfs_perag_put(pag);
+
+	switch (error) {
+	case 0:
+		return 0;
+	case -EINVAL:
+		break;
+	default:
+		return error;
+	}
+
+	/* Return it to the AG. */
 	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_REFC);
 	xfs_bmap_add_free(mp, cur->bc_private.a.flist, fsbno, 1,
 			&oinfo);
@@ -390,3 +433,144 @@ xfs_refcountbt_max_btree_size(
 
 	return xfs_refcountbt_calc_btree_size(mp, mp->m_sb.sb_agblocks);
 }
+
+/* Count the blocks in the reference count tree. */
+static int
+xfs_refcountbt_count_tree_blocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*tree_len)
+{
+	struct xfs_buf		*agfbp;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_agf		*agfp;
+	struct xfs_btree_block	*block = NULL;
+	int			level;
+	xfs_agblock_t		bno;
+	xfs_fsblock_t		fsbno;
+	__be32			*pp;
+	int			error;
+	xfs_extlen_t		nr_blocks = 0;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agfbp);
+	if (error)
+		goto out;
+	agfp = XFS_BUF_TO_AGF(agfbp);
+	level = be32_to_cpu(agfp->agf_refcount_level);
+	bno = be32_to_cpu(agfp->agf_refcount_root);
+
+	/*
+	 * Go down the tree until leaf level is reached, following the first
+	 * pointer (leftmost) at each level.
+	 */
+	while (level-- > 0) {
+		fsbno = XFS_AGB_TO_FSB(mp, agno, bno);
+		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, fsbno),
+				XFS_FSB_TO_BB(mp, 1), 0, &bp,
+				&xfs_refcountbt_buf_ops);
+		if (error)
+			goto err;
+		block = XFS_BUF_TO_BLOCK(bp);
+		if (level == 0)
+			break;
+		pp = XFS_REFCOUNT_PTR_ADDR(block, 1, mp->m_refc_mxr[1]);
+		bno = be32_to_cpu(*pp);
+		xfs_trans_brelse(NULL, bp);
+	}
+
+	/* Jog rightward though level zero. */
+	while (block) {
+		nr_blocks++;
+		bno = be32_to_cpu(block->bb_u.s.bb_rightsib);
+		if (bno == NULLAGBLOCK)
+			break;
+		fsbno = XFS_AGB_TO_FSB(mp, agno, bno);
+		xfs_trans_brelse(NULL, bp);
+		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, fsbno),
+				XFS_FSB_TO_BB(mp, 1), 0, &bp,
+				&xfs_refcountbt_buf_ops);
+		if (error)
+			goto err;
+		block = XFS_BUF_TO_BLOCK(bp);
+	}
+
+	if (bp)
+		xfs_trans_brelse(NULL, bp);
+
+	/* Add in the upper levels of tree. */
+	*tree_len = nr_blocks;
+err:
+	xfs_trans_brelse(NULL, agfbp);
+out:
+	return error;
+}
+
+/**
+ * xfs_refcountbt_alloc_reserve_pool() -- Create reserved block pools for each
+ *					  allocation group.
+ */
+int
+xfs_refcountbt_alloc_reserve_pool(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
+	xfs_extlen_t		pool_len;
+	xfs_extlen_t		tree_len;
+	int			error = 0;
+	int			err;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	pool_len = xfs_refcountbt_max_btree_size(mp);
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		if (pag->pagf_refcountbt_pool) {
+			xfs_perag_put(pag);
+			continue;
+		}
+		tree_len = 0;
+		xfs_refcountbt_count_tree_blocks(mp, agno, &tree_len);
+		err = xfs_perag_pool_init(mp, agno,
+				xfs_refc_block(mp),
+				pool_len, tree_len,
+				XFS_RMAP_OWN_REFC,
+				&pag->pagf_refcountbt_pool);
+		xfs_perag_put(pag);
+		if (err && !error)
+			error = err;
+	}
+
+	return error;
+}
+
+/**
+ * xfs_refcountbt_free_reserve_pool() -- Free the reference count btree pools.
+ */
+int
+xfs_refcountbt_free_reserve_pool(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			err;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		err = xfs_perag_pool_free(pag->pagf_refcountbt_pool);
+		pag->pagf_refcountbt_pool = NULL;
+		xfs_perag_put(pag);
+		if (err && !error)
+			error = err;
+	}
+
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index 0f55544..93eebda 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -65,4 +65,7 @@ extern int xfs_refcountbt_maxrecs(struct xfs_mount *mp, int blocklen,
 DECLARE_BTREE_SIZE_FN(refcountbt);
 extern unsigned int xfs_refcountbt_max_btree_size(struct xfs_mount *mp);
 
+extern int xfs_refcountbt_alloc_reserve_pool(struct xfs_mount *mp);
+extern int xfs_refcountbt_free_reserve_pool(struct xfs_mount *mp);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 920db9d..4158e07 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -41,6 +41,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_filestream.h"
+#include "xfs_refcount_btree.h"
 
 /*
  * File system operations
@@ -679,6 +680,9 @@ xfs_growfs_data_private(
 			continue;
 		}
 	}
+
+	error = xfs_refcountbt_alloc_reserve_pool(mp);
+
 	return saved_error ? saved_error : error;
 
  error0:
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 335bcad..29841d6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -41,6 +41,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_sysfs.h"
+#include "xfs_refcount_btree.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -966,6 +967,10 @@ xfs_mountfs(
 		if (error)
 			xfs_warn(mp,
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
+		error = xfs_refcountbt_alloc_reserve_pool(mp);
+		if (error)
+			xfs_err(mp,
+	"Error %d allocating refcount btree reserve blocks.", error);
 	}
 
 	return 0;
@@ -1007,6 +1012,11 @@ xfs_unmountfs(
 	__uint64_t		resblks;
 	int			error;
 
+	error = xfs_refcountbt_free_reserve_pool(mp);
+	if (error)
+		xfs_warn(mp,
+	"Error %d freeing refcount btree reserve blocks.", error);
+
 	cancel_delayed_work_sync(&mp->m_eofblocks_work);
 
 	xfs_qm_unmount_quotas(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index caed8d3..75ff130 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -321,6 +321,7 @@ typedef struct xfs_perag {
 
 	/* reference count */
 	__uint8_t	pagf_refcount_level;
+	struct xfs_perag_pool	*pagf_refcountbt_pool;
 } xfs_perag_t;
 
 extern void	xfs_uuid_table_free(void);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ede714b..87f44a2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -46,6 +46,7 @@
 #include "xfs_quota.h"
 #include "xfs_sysfs.h"
 #include "xfs_reflink.h"
+#include "xfs_refcount_btree.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1264,6 +1265,12 @@ xfs_fs_remount(
 		 */
 		xfs_restore_resvblks(mp);
 		xfs_log_work_queue(mp);
+
+		/* Save space for the refcount btree! */
+		error = xfs_refcountbt_alloc_reserve_pool(mp);
+		if (error)
+			xfs_err(mp,
+	"Error %d allocating refcount btree reserve blocks.", error);
 	}
 
 	/* rw -> ro */
@@ -1275,6 +1282,13 @@ xfs_fs_remount(
 		 * reserve pool size so that if we get remounted rw, we can
 		 * return it to the same size.
 		 */
+
+		/* Save space for the refcount btree! */
+		error = xfs_refcountbt_free_reserve_pool(mp);
+		if (error)
+			xfs_warn(mp,
+	"Error %d freeing refcount btree reserve blocks.", error);
+
 		xfs_save_resvblks(mp);
 		xfs_quiesce_attr(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
