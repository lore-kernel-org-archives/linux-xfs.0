Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9FBD7DDA
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:37:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0110304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9r4qoTCcElJC2pDH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:55 -0700 (PDT)
Subject: [PATCH 54/71] xfs: preallocate blocks for worst-case btree expansion
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:37:49 -0700
Message-ID: <147216826896.867.9556738728686244638.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

To gracefully handle the situation where a CoW operation turns a
single refcount extent into a lot of tiny ones and then run out of
space when a tree split has to happen, use the per-AG reserved block
pool to pre-allocate all the space we'll ever need for a maximal
btree.  For a 4K block size, this only costs an overhead of 0.3% of
available disk space.

When reflink is enabled, we have an unfortunate problem with rmap --
since we can share a block billions of times, this means that the
reverse mapping btree can expand basically infinitely.  When an AG is
so full that there are no free blocks with which to expand the rmapbt,
the filesystem will shut down hard.

This is rather annoying to the user, so use the AG reservation code to
reserve a "reasonable" amount of space for rmap.  We'll prevent
reflinks and CoW operations if we think we're getting close to
exhausting an AG's free space rather than shutting down, but this
permanent reservation should be enough for "most" users.  Hopefully.

v2: Simplify the return value from xfs_perag_pool_free_block to a bool
so that we can easily call xfs_trans_binval for both the per-AG pool
and the real freeing case.  Without this we fail to invalidate the
btree buffer and will trip over the write verifier on a shrinking
refcount btree.

v3: Convert to the new per-AG reservation code.

v4: Combine this patch with the one that adds the rmapbt reservation,
since the rmapbt reservation is only needed for reflink filesystems.

v5: If we detect errors while counting the refcount or rmap btrees,
shut down the filesystem to avoid the scenario where the fs shuts down
mid-transaction due to btree corruption, repair refuses to run until
the log is clean, and the log cannot be cleaned because replay hits
btree corruption and shuts down.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch@lst.de: ensure that we invalidate the freed btree buffer]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag_resv.c        |   11 +++++++
 fs/xfs/libxfs/xfs_refcount_btree.c |   45 +++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++
 fs/xfs/libxfs/xfs_rmap_btree.c     |   60 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h     |    7 ++++
 fs/xfs/xfs_fsops.c                 |   55 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.h                 |    3 ++
 fs/xfs/xfs_mount.c                 |    4 ++
 fs/xfs/xfs_super.c                 |    5 +++
 9 files changed, 190 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 874c437..adddae4 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -38,6 +38,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_btree.h"
+#include "xfs_refcount_btree.h"
 
 /*
  * Per-AG Block Reservations
@@ -230,6 +231,11 @@ xfs_ag_resv_init(
 	/* Create the metadata reservation. */
 	ask = used = 0;
 
+	err2 = xfs_refcountbt_calc_reserves(pag->pag_mount, pag->pag_agno,
+			&ask, &used);
+	if (err2 && !error)
+		error = err2;
+
 	err2 = __xfs_ag_resv_init(pag, XFS_AG_RESV_METADATA, ask, used);
 	if (err2 && !error)
 		error = err2;
@@ -241,6 +247,11 @@ init_agfl:
 	/* Create the AGFL metadata reservation */
 	ask = used = 0;
 
+	err2 = xfs_rmapbt_calc_reserves(pag->pag_mount, pag->pag_agno,
+			&ask, &used);
+	if (err2 && !error)
+		error = err2;
+
 	err2 = __xfs_ag_resv_init(pag, XFS_AG_RESV_AGFL, ask, used);
 	if (err2 && !error)
 		error = err2;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index c9d4823..fa8dfd6 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -79,6 +79,8 @@ xfs_refcountbt_alloc_block(
 	struct xfs_alloc_arg	args;		/* block allocation args */
 	int			error;		/* error return value */
 
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
@@ -88,6 +90,7 @@ xfs_refcountbt_alloc_block(
 	args.firstblock = args.fsbno;
 	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_REFC);
 	args.minlen = args.maxlen = args.prod = 1;
+	args.resv = XFS_AG_RESV_METADATA;
 
 	error = xfs_alloc_vextent(&args);
 	if (error)
@@ -125,16 +128,19 @@ xfs_refcountbt_free_block(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	struct xfs_owner_info	oinfo;
+	int			error;
 
 	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
-	xfs_bmap_add_free(mp, cur->bc_private.a.dfops, fsbno, 1,
-			&oinfo);
+	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &oinfo,
+			XFS_AG_RESV_METADATA);
+	if (error)
+		return error;
 
-	return 0;
+	return error;
 }
 
 STATIC int
@@ -404,3 +410,36 @@ xfs_refcountbt_max_size(
 
 	return xfs_refcountbt_calc_size(mp, mp->m_sb.sb_agblocks);
 }
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ */
+int
+xfs_refcountbt_calc_reserves(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*ask,
+	xfs_extlen_t		*used)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_agf		*agf;
+	xfs_extlen_t		tree_len;
+	int			error;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	*ask += xfs_refcountbt_max_size(mp);
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	agf = XFS_BUF_TO_AGF(agbp);
+	tree_len = be32_to_cpu(agf->agf_refcount_blocks);
+	xfs_buf_relse(agbp);
+
+	*used += tree_len;
+
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index 780b02f..3be7768 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -68,4 +68,7 @@ extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp);
 
+extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
+		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 7834956..385c2ac 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -35,6 +35,7 @@
 #include "xfs_cksum.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
+#include "xfs_ag_resv.h"
 
 /*
  * Reverse map btree.
@@ -518,3 +519,62 @@ xfs_rmapbt_compute_maxlevels(
 		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
 				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
 }
+
+/* Calculate the refcount btree size for some records. */
+xfs_extlen_t
+xfs_rmapbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_rmap_mnr, len);
+}
+
+/*
+ * Calculate the maximum refcount btree size.
+ */
+xfs_extlen_t
+xfs_rmapbt_max_size(
+	struct xfs_mount	*mp)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rmap_mxr[0] == 0)
+		return 0;
+
+	return xfs_rmapbt_calc_size(mp, mp->m_sb.sb_agblocks);
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ */
+int
+xfs_rmapbt_calc_reserves(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*ask,
+	xfs_extlen_t		*used)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_agf		*agf;
+	xfs_extlen_t		pool_len;
+	xfs_extlen_t		tree_len;
+	int			error;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	/* Reserve 1% of the AG or enough for 1 block per record. */
+	pool_len = max(mp->m_sb.sb_agblocks / 100, xfs_rmapbt_max_size(mp));
+	*ask += pool_len;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	agf = XFS_BUF_TO_AGF(agbp);
+	tree_len = be32_to_cpu(agf->agf_rmap_blocks);
+	xfs_buf_relse(agbp);
+
+	*used += tree_len;
+
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index e73a553..2a9ac47 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -58,4 +58,11 @@ struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 int xfs_rmapbt_maxrecs(struct xfs_mount *mp, int blocklen, int leaf);
 extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 
+extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp);
+
+extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp,
+		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3acbf4e0..9880eeb 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -43,6 +43,7 @@
 #include "xfs_log.h"
 #include "xfs_filestream.h"
 #include "xfs_rmap.h"
+#include "xfs_ag_resv.h"
 
 /*
  * File system operations
@@ -680,6 +681,9 @@ xfs_growfs_data_private(
 			continue;
 		}
 	}
+
+	xfs_fs_reserve_ag_blocks(mp);
+
 	return saved_error ? saved_error : error;
 
  error0:
@@ -989,3 +993,54 @@ xfs_do_force_shutdown(
 	"Please umount the filesystem and rectify the problem(s)");
 	}
 }
+
+/*
+ * Reserve free space for per-AG metadata.
+ */
+void
+xfs_fs_reserve_ag_blocks(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			err2;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		err2 = xfs_ag_resv_init(pag);
+		xfs_perag_put(pag);
+		if (err2 && !error)
+			error = err2;
+	}
+
+	if (error) {
+		xfs_warn(mp, "Error %d reserving metadata blocks.", error);
+		xfs_force_shutdown(mp, (error == -EFSCORRUPTED) ?
+			SHUTDOWN_CORRUPT_INCORE : SHUTDOWN_META_IO_ERROR);
+	}
+}
+
+/*
+ * Free space reserved for per-AG metadata.
+ */
+void
+xfs_fs_unreserve_ag_blocks(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			err2;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		err2 = xfs_ag_resv_free(pag);
+		xfs_perag_put(pag);
+		if (err2 && !error)
+			error = err2;
+	}
+
+	if (error)
+		xfs_warn(mp, "Error %d unreserving metadata blocks.", error);
+}
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index f32713f..71e32480 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -26,4 +26,7 @@ extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
 
+extern void xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
+extern void xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
+
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0093616..d64e5b9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -45,6 +45,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_refcount_btree.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -964,6 +965,8 @@ xfs_mountfs(
 			xfs_warn(mp,
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
 
+		xfs_fs_reserve_ag_blocks(mp);
+
 		/* Recover any CoW blocks that never got remapped. */
 		error = xfs_reflink_recover_cow(mp);
 		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
@@ -1017,6 +1020,7 @@ xfs_unmountfs(
 
 	cancel_delayed_work_sync(&mp->m_eofblocks_work);
 
+	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
 	IRELE(mp->m_rootip);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c580926..a980fef 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -50,6 +50,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
+#include "xfs_refcount_btree.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1306,6 +1307,7 @@ xfs_fs_remount(
 		xfs_restore_resvblks(mp);
 		xfs_log_work_queue(mp);
 		xfs_queue_eofblocks(mp);
+		xfs_fs_reserve_ag_blocks(mp);
 
 		/* Recover any CoW blocks that never got remapped. */
 		error = xfs_reflink_recover_cow(mp);
@@ -1325,6 +1327,9 @@ xfs_fs_remount(
 		 * reserve pool size so that if we get remounted rw, we can
 		 * return it to the same size.
 		 */
+
+		xfs_fs_unreserve_ag_blocks(mp);
+
 		xfs_save_resvblks(mp);
 
 		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
