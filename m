Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36302 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVtS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:49:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Ldh9A053608
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:16 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2suj0qfjsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:49:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lm6Mf041901
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2swnghkjc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:49:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54LnELL030449
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:15 GMT
Subject: [PATCH 2/4] xfs: refactor inode geometry setup routines
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:49:05 -0700
Message-ID: <155968494542.1657505.5981492051798860627.stgit@magnolia>
In-Reply-To: <155968493259.1657505.18397791996876650910.stgit@magnolia>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Migrate all of the inode geometry setup code from xfs_mount.c into a
single libxfs function that we can share with xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |  124 ++++++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_ialloc.h |   18 ------
 fs/xfs/libxfs/xfs_sb.c     |   20 +------
 fs/xfs/xfs_mount.c         |   83 -----------------------------
 4 files changed, 101 insertions(+), 144 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 49f556cf244b..fdfcc03a35b9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -31,20 +31,6 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 
-
-/*
- * Allocation group level functions.
- */
-int
-xfs_ialloc_cluster_alignment(
-	struct xfs_mount	*mp)
-{
-	if (xfs_sb_version_hasalign(&mp->m_sb) &&
-	    mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
-		return mp->m_sb.sb_inoalignmt;
-	return 1;
-}
-
 /*
  * Lookup a record by ino in the btree given by cur.
  */
@@ -2413,20 +2399,6 @@ xfs_imap(
 	return 0;
 }
 
-/*
- * Compute and fill in value of m_ino_geo.inobt_maxlevels.
- */
-void
-xfs_ialloc_compute_maxlevels(
-	xfs_mount_t	*mp)		/* file system mount structure */
-{
-	uint		inodes;
-
-	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
-	M_IGEO(mp)->inobt_maxlevels = xfs_btree_compute_maxlevels(
-			M_IGEO(mp)->inobt_mnr, inodes);
-}
-
 /*
  * Log specified fields for the ag hdr (inode section). The growth of the agi
  * structure over time requires that we interpret the buffer as two logical
@@ -2773,3 +2745,99 @@ xfs_ialloc_count_inodes(
 	*freecount = ci.freecount;
 	return 0;
 }
+
+/*
+ * Initialize inode-related geometry information.
+ *
+ * Compute the inode btree min and max levels and set maxicount.
+ *
+ * Set the inode cluster size.  This may still be overridden by the file
+ * system block size if it is larger than the chosen cluster size.
+ *
+ * For v5 filesystems, scale the cluster size with the inode size to keep a
+ * constant ratio of inode per cluster buffer, but only if mkfs has set the
+ * inode alignment value appropriately for larger cluster sizes.
+ *
+ * Then compute the inode cluster alignment information.
+ */
+void
+xfs_ialloc_setup_geometry(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	uint64_t		icount;
+	uint			inodes;
+
+	/* Compute inode btree geometry. */
+	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
+	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
+	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
+	igeo->inobt_mnr[0] = igeo->inobt_mxr[0] / 2;
+	igeo->inobt_mnr[1] = igeo->inobt_mxr[1] / 2;
+
+	igeo->ialloc_inos = max_t(uint16_t, XFS_INODES_PER_CHUNK,
+			sbp->sb_inopblock);
+	igeo->ialloc_blks = igeo->ialloc_inos >> sbp->sb_inopblog;
+
+	if (sbp->sb_spino_align)
+		igeo->ialloc_min_blks = sbp->sb_spino_align;
+	else
+		igeo->ialloc_min_blks = igeo->ialloc_blks;
+
+	/* Compute and fill in value of m_ino_geo.inobt_maxlevels. */
+	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
+	igeo->inobt_maxlevels = xfs_btree_compute_maxlevels(igeo->inobt_mnr,
+			inodes);
+
+	/* Set the maximum inode count for this filesystem. */
+	if (sbp->sb_imax_pct) {
+		/*
+		 * Make sure the maximum inode count is a multiple
+		 * of the units we allocate inodes in.
+		 */
+		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
+		do_div(icount, 100);
+		do_div(icount, igeo->ialloc_blks);
+		igeo->maxicount = XFS_FSB_TO_INO(mp,
+				icount * igeo->ialloc_blks);
+	} else {
+		igeo->maxicount = 0;
+	}
+
+	igeo->inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		int	new_size = igeo->inode_cluster_size;
+
+		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
+		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
+			igeo->inode_cluster_size = new_size;
+	}
+
+	/* Calculate inode cluster ratios. */
+	if (igeo->inode_cluster_size > mp->m_sb.sb_blocksize)
+		igeo->blocks_per_cluster = XFS_B_TO_FSBT(mp,
+				igeo->inode_cluster_size);
+	else
+		igeo->blocks_per_cluster = 1;
+	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp, igeo->blocks_per_cluster);
+
+	/* Calculate inode cluster alignment. */
+	if (xfs_sb_version_hasalign(&mp->m_sb) &&
+	    mp->m_sb.sb_inoalignmt >= igeo->blocks_per_cluster)
+		igeo->cluster_align = mp->m_sb.sb_inoalignmt;
+	else
+		igeo->cluster_align = 1;
+	igeo->inoalign_mask = igeo->cluster_align - 1;
+	igeo->cluster_align_inodes = XFS_FSB_TO_INO(mp, igeo->cluster_align);
+
+	/*
+	 * If we are using stripe alignment, check whether
+	 * the stripe unit is a multiple of the inode alignment
+	 */
+	if (mp->m_dalign && igeo->inoalign_mask &&
+	    !(mp->m_dalign & igeo->inoalign_mask))
+		igeo->ialloc_align = mp->m_dalign;
+	else
+		igeo->ialloc_align = 0;
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index e7d935e69b11..323592d563d5 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -23,16 +23,6 @@ struct xfs_icluster {
 					 * sparse chunks */
 };
 
-/* Calculate and return the number of filesystem blocks per inode cluster */
-static inline int
-xfs_icluster_size_fsb(
-	struct xfs_mount	*mp)
-{
-	if (mp->m_sb.sb_blocksize >= M_IGEO(mp)->inode_cluster_size)
-		return 1;
-	return M_IGEO(mp)->inode_cluster_size >> mp->m_sb.sb_blocklog;
-}
-
 /*
  * Make an inode pointer out of the buffer/offset.
  */
@@ -95,13 +85,6 @@ xfs_imap(
 	struct xfs_imap	*imap,		/* location map structure */
 	uint		flags);		/* flags for inode btree lookup */
 
-/*
- * Compute and fill in value of m_ino_geo.inobt_maxlevels.
- */
-void
-xfs_ialloc_compute_maxlevels(
-	struct xfs_mount *mp);		/* file system mount structure */
-
 /*
  * Log specified fields for the ag hdr (inode section)
  */
@@ -168,5 +151,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 		int *stat);
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
+void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a44eb52b861d..2490b2c9733d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -800,22 +800,21 @@ const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
  *
  * Mount initialization code establishing various mount
  * fields from the superblock associated with the given
- * mount structure
+ * mount structure.
+ *
+ * Inode geometry are calculated in xfs_ialloc_setup_geometry.
  */
 void
 xfs_sb_mount_common(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-
 	mp->m_agfrotor = mp->m_agirotor = 0;
 	mp->m_maxagi = mp->m_sb.sb_agcount;
 	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
-	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
@@ -825,11 +824,6 @@ xfs_sb_mount_common(
 	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
 	mp->m_alloc_mnr[1] = mp->m_alloc_mxr[1] / 2;
 
-	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
-	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
-	igeo->inobt_mnr[0] = igeo->inobt_mxr[0] / 2;
-	igeo->inobt_mnr[1] = igeo->inobt_mxr[1] / 2;
-
 	mp->m_bmap_dmxr[0] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_bmap_dmxr[1] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 0);
 	mp->m_bmap_dmnr[0] = mp->m_bmap_dmxr[0] / 2;
@@ -846,14 +840,6 @@ xfs_sb_mount_common(
 	mp->m_refc_mnr[1] = mp->m_refc_mxr[1] / 2;
 
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
-	igeo->ialloc_inos = max_t(uint16_t, XFS_INODES_PER_CHUNK,
-					sbp->sb_inopblock);
-	igeo->ialloc_blks = igeo->ialloc_inos >> sbp->sb_inopblog;
-
-	if (sbp->sb_spino_align)
-		igeo->ialloc_min_blks = sbp->sb_spino_align;
-	else
-		igeo->ialloc_min_blks = igeo->ialloc_blks;
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 73e5cfc4d0ec..81d6535b24b4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -429,32 +429,6 @@ xfs_update_alignment(xfs_mount_t *mp)
 	return 0;
 }
 
-/*
- * Set the maximum inode count for this filesystem
- */
-STATIC void
-xfs_set_maxicount(
-	struct xfs_mount	*mp)
-{
-	struct xfs_sb		*sbp = &(mp->m_sb);
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	uint64_t		icount;
-
-	if (sbp->sb_imax_pct) {
-		/*
-		 * Make sure the maximum inode count is a multiple
-		 * of the units we allocate inodes in.
-		 */
-		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
-		do_div(icount, 100);
-		do_div(icount, igeo->ialloc_blks);
-		igeo->maxicount = XFS_FSB_TO_INO(mp,
-				icount * igeo->ialloc_blks);
-	} else {
-		igeo->maxicount = 0;
-	}
-}
-
 /*
  * Set the default minimum read and write sizes unless
  * already specified in a mount option.
@@ -511,29 +485,6 @@ xfs_set_low_space_thresholds(
 	}
 }
 
-
-/*
- * Set whether we're using inode alignment.
- */
-STATIC void
-xfs_set_inoalignment(xfs_mount_t *mp)
-{
-	if (xfs_sb_version_hasalign(&mp->m_sb) &&
-		mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
-		M_IGEO(mp)->inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
-	else
-		M_IGEO(mp)->inoalign_mask = 0;
-	/*
-	 * If we are using stripe alignment, check whether
-	 * the stripe unit is a multiple of the inode alignment
-	 */
-	if (mp->m_dalign && M_IGEO(mp)->inoalign_mask &&
-	    !(mp->m_dalign & M_IGEO(mp)->inoalign_mask))
-		M_IGEO(mp)->ialloc_align = mp->m_dalign;
-	else
-		M_IGEO(mp)->ialloc_align = 0;
-}
-
 /*
  * Check that the data (and log if separate) is an ok size.
  */
@@ -752,12 +703,10 @@ xfs_mountfs(
 	xfs_alloc_compute_maxlevels(mp);
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
-	xfs_ialloc_compute_maxlevels(mp);
+	xfs_ialloc_setup_geometry(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
-	xfs_set_maxicount(mp);
-
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
@@ -790,31 +739,6 @@ xfs_mountfs(
 	/* set the low space thresholds for dynamic preallocation */
 	xfs_set_low_space_thresholds(mp);
 
-	/*
-	 * Set the inode cluster size.
-	 * This may still be overridden by the file system
-	 * block size if it is larger than the chosen cluster size.
-	 *
-	 * For v5 filesystems, scale the cluster size with the inode size to
-	 * keep a constant ratio of inode per cluster buffer, but only if mkfs
-	 * has set the inode alignment value appropriately for larger cluster
-	 * sizes.
-	 */
-	igeo->inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		int	new_size = igeo->inode_cluster_size;
-
-		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
-		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
-			igeo->inode_cluster_size = new_size;
-	}
-	igeo->blocks_per_cluster = xfs_icluster_size_fsb(mp);
-	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp,
-			igeo->blocks_per_cluster);
-	igeo->cluster_align = xfs_ialloc_cluster_alignment(mp);
-	igeo->cluster_align_inodes = XFS_FSB_TO_INO(mp,
-			igeo->cluster_align);
-
 	/*
 	 * If enabled, sparse inode chunk alignment is expected to match the
 	 * cluster size. Full inode chunk alignment must match the chunk size,
@@ -831,11 +755,6 @@ xfs_mountfs(
 		goto out_remove_uuid;
 	}
 
-	/*
-	 * Set inode alignment fields
-	 */
-	xfs_set_inoalignment(mp);
-
 	/*
 	 * Check that the data (and log if separate) is an ok size.
 	 */
