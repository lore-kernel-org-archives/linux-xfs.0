Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48020 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfFCWvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 18:51:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53MnaJP162867
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:14 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugst9se8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53MomLT032746
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2sv36sfgpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:13 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x53MpDnc022964
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:13 GMT
Subject: [PATCH 2/5] xfs: refactor inode geometry setup routines
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 03 Jun 2019 15:51:12 -0700
Message-ID: <155960227220.1194435.7625646115020669657.stgit@magnolia>
In-Reply-To: <155960225918.1194435.11314723160642989835.stgit@magnolia>
References: <155960225918.1194435.11314723160642989835.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_ialloc.c |   90 +++++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_ialloc.h |    8 ----
 fs/xfs/xfs_mount.c         |   83 -----------------------------------------
 3 files changed, 78 insertions(+), 103 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 49f556cf244b..81d33ba10619 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2413,20 +2413,6 @@ xfs_imap(
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
@@ -2773,3 +2759,79 @@ xfs_ialloc_count_inodes(
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
+	igeo->blocks_per_cluster = xfs_icluster_size_fsb(mp);
+	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp,
+			igeo->blocks_per_cluster);
+	igeo->cluster_align = xfs_ialloc_cluster_alignment(mp);
+	igeo->cluster_align_inodes = XFS_FSB_TO_INO(mp,
+			igeo->cluster_align);
+
+	/* Set whether we're using inode alignment. */
+	if (xfs_sb_version_hasalign(&mp->m_sb) &&
+		mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
+		igeo->inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
+	else
+		igeo->inoalign_mask = 0;
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
index e7d935e69b11..455f65a2f1dd 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -95,13 +95,6 @@ xfs_imap(
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
@@ -168,5 +161,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 		int *stat);
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
+void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
 
 #endif	/* __XFS_IALLOC_H__ */
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
