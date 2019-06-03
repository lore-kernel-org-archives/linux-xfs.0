Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54056 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfFCWva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 18:51:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53MnOAf182117
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:28 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2suevda09c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53MnZrI155328
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2svbbvccw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:27 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x53MpRY6011705
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:27 GMT
Subject: [PATCH 4/5] xfs: fix inode_cluster_size rounding mayhem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 03 Jun 2019 15:51:25 -0700
Message-ID: <155960228579.1194435.18215658650812508577.stgit@magnolia>
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

inode_cluster_size is supposed to represent the size (in bytes) of an
inode cluster buffer.  We avoid having to handle multiple clusters per
filesystem block on filesystems with large blocks by openly rounding
this value up to 1 FSB when necessary.  However, we never reset
inode_cluster_size to reflect this new rounded value, which adds to the
potential for mistakes in calculating geometries.

Fix this by setting inode_cluster_size to reflect the rounded-up size if
needed, and special-case the few places in the sparse inodes code where
we actually need the smaller value to validate on-disk metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |    8 ++++++--
 fs/xfs/libxfs/xfs_ialloc.c     |   19 +++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c |    6 ++----
 fs/xfs/xfs_log_recover.c       |    3 +--
 fs/xfs/xfs_mount.c             |    4 ++--
 5 files changed, 30 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0e831f04725c..1d3e1e66baf5 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1698,11 +1698,15 @@ struct xfs_ino_geometry {
 	/* Maximum inode count in this filesystem. */
 	uint64_t	maxicount;
 
+	/* Actual inode cluster buffer size, in bytes. */
+	unsigned int	inode_cluster_size;
+
 	/*
 	 * Desired inode cluster buffer size, in bytes.  This value is not
-	 * rounded up to at least one filesystem block.
+	 * rounded up to at least one filesystem block, which is necessary for
+	 * validating sb_spino_align.
 	 */
-	unsigned int	inode_cluster_size;
+	unsigned int	inode_cluster_size_raw;
 
 	/* Inode cluster sizes, adjusted to be at least 1 fsb. */
 	unsigned int	inodes_per_cluster;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index cff202d0ee4a..976860673b6c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2810,6 +2810,16 @@ xfs_ialloc_setup_geometry(
 		igeo->maxicount = 0;
 	}
 
+	/*
+	 * Compute the desired size of an inode cluster buffer size, which
+	 * starts at 8K and (on v5 filesystems) scales up with larger inode
+	 * sizes.
+	 *
+	 * Preserve the desired inode cluster size because the sparse inodes
+	 * feature uses that desired size (not the actual size) to compute the
+	 * sparse inode alignment.  The mount code validates this value, so we
+	 * cannot change the behavior.
+	 */
 	igeo->inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		int	new_size = igeo->inode_cluster_size;
@@ -2818,12 +2828,21 @@ xfs_ialloc_setup_geometry(
 		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
 			igeo->inode_cluster_size = new_size;
 	}
+	igeo->inode_cluster_size_raw = igeo->inode_cluster_size;
+
+	/*
+	 * Compute the inode cluster buffer size ratios.  We avoid needing to
+	 * handle multiple clusters per filesystem block by rounding up
+	 * blocks_per_cluster to 1 if necessary.  Set the inode cluster size
+	 * to the actual value.
+	 */
 	igeo->blocks_per_cluster = xfs_icluster_size_fsb(mp);
 	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp,
 			igeo->blocks_per_cluster);
 	igeo->cluster_align = xfs_ialloc_cluster_alignment(mp);
 	igeo->cluster_align_inodes = XFS_FSB_TO_INO(mp,
 			igeo->cluster_align);
+	igeo->inode_cluster_size = XFS_FSB_TO_B(mp, igeo->blocks_per_cluster);
 
 	/* Set whether we're using inode alignment. */
 	igeo->inoalign_mask = igeo->cluster_align - 1;
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 2663dd7975a5..9d1326d14af9 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -308,8 +308,7 @@ xfs_calc_iunlink_remove_reservation(
 	struct xfs_mount        *mp)
 {
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-	       2 * max_t(uint, XFS_FSB_TO_B(mp, 1),
-			 M_IGEO(mp)->inode_cluster_size);
+	       2 * M_IGEO(mp)->inode_cluster_size;
 }
 
 /*
@@ -347,8 +346,7 @@ STATIC uint
 xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 {
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-			max_t(uint, XFS_FSB_TO_B(mp, 1),
-			      M_IGEO(mp)->inode_cluster_size);
+			M_IGEO(mp)->inode_cluster_size;
 }
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1557304f3d68..f7c062df29bf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2893,8 +2893,7 @@ xlog_recover_buffer_pass2(
 	 */
 	if (XFS_DINODE_MAGIC ==
 	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
-	    (BBTOB(bp->b_io_length) != max(log->l_mp->m_sb.sb_blocksize,
-			M_IGEO(log->l_mp)->inode_cluster_size))) {
+	    (BBTOB(bp->b_io_length) != M_IGEO(log->l_mp)->inode_cluster_size)) {
 		xfs_buf_stale(bp);
 		error = xfs_bwrite(bp);
 	} else {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 81d6535b24b4..544fa469aca4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -746,11 +746,11 @@ xfs_mountfs(
 	 */
 	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
 	    mp->m_sb.sb_spino_align !=
-			XFS_B_TO_FSBT(mp, igeo->inode_cluster_size)) {
+			XFS_B_TO_FSBT(mp, igeo->inode_cluster_size_raw)) {
 		xfs_warn(mp,
 	"Sparse inode block alignment (%u) must match cluster size (%llu).",
 			 mp->m_sb.sb_spino_align,
-			 XFS_B_TO_FSBT(mp, igeo->inode_cluster_size));
+			 XFS_B_TO_FSBT(mp, igeo->inode_cluster_size_raw));
 		error = -EINVAL;
 		goto out_remove_uuid;
 	}
