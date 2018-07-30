Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47386 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbeG3HDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 03:03:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6U5T4fE018124
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:30:17 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2kge0ctyjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:30:17 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6U5UGWd010341
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:30:16 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6U5UG9h021822
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:30:16 GMT
Subject: [PATCH 1/3] xfs: refactor superblock verifiers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Jul 2018 22:30:15 -0700
Message-ID: <153292861500.19274.6476856835031792043.stgit@magnolia>
In-Reply-To: <153292860880.19274.14533449137039985963.stgit@magnolia>
References: <153292860880.19274.14533449137039985963.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Split the superblock verifier into the common checks, the read-time
checks, and the write-time check functions.  No functional changes, but
we're setting up to add more write-only checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |  205 ++++++++++++++++++++++++++----------------------
 1 file changed, 112 insertions(+), 93 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b3ad15956366..516bef7b0f50 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -96,80 +96,96 @@ xfs_perag_put(
 	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
 }
 
-/*
- * Check the validity of the SB found.
- */
+/* Check all the superblock fields we care about when reading one in. */
 STATIC int
-xfs_mount_validate_sb(
-	xfs_mount_t	*mp,
-	xfs_sb_t	*sbp,
-	bool		check_inprogress,
-	bool		check_version)
+xfs_validate_sb_read(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
 {
-	uint32_t	agcount = 0;
-	uint32_t	rem;
-
-	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
-		xfs_warn(mp, "bad magic number");
-		return -EWRONGFS;
-	}
-
-
-	if (!xfs_sb_good_version(sbp)) {
-		xfs_warn(mp, "bad version");
-		return -EWRONGFS;
-	}
+	if (!xfs_sb_version_hascrc(sbp))
+		return 0;
 
 	/*
-	 * Version 5 superblock feature mask validation. Reject combinations the
-	 * kernel cannot support up front before checking anything else. For
-	 * write validation, we don't need to check feature masks.
+	 * Version 5 superblock feature mask validation. Reject combinations
+	 * the kernel cannot support up front before checking anything else.
+	 * For write validation, we don't need to check feature masks.
 	 */
-	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
-		if (xfs_sb_has_compat_feature(sbp,
-					XFS_SB_FEAT_COMPAT_UNKNOWN)) {
-			xfs_warn(mp,
+	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
+		xfs_warn(mp,
 "Superblock has unknown compatible features (0x%x) enabled.",
-				(sbp->sb_features_compat &
-						XFS_SB_FEAT_COMPAT_UNKNOWN));
-			xfs_warn(mp,
+			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
+		xfs_warn(mp,
 "Using a more recent kernel is recommended.");
-		}
+	}
 
-		if (xfs_sb_has_ro_compat_feature(sbp,
-					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
-			xfs_alert(mp,
+	if (xfs_sb_has_ro_compat_feature(sbp,
+				XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+		xfs_alert(mp,
 "Superblock has unknown read-only compatible features (0x%x) enabled.",
-				(sbp->sb_features_ro_compat &
-						XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
-			if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
-				xfs_warn(mp,
+			(sbp->sb_features_ro_compat &
+					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
+		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+			xfs_warn(mp,
 "Attempted to mount read-only compatible filesystem read-write.");
-				xfs_warn(mp,
+			xfs_warn(mp,
 "Filesystem can only be safely mounted read only.");
 
-				return -EINVAL;
-			}
+			return -EINVAL;
 		}
-		if (xfs_sb_has_incompat_feature(sbp,
-					XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
-			xfs_warn(mp,
+	}
+	if (xfs_sb_has_incompat_feature(sbp,
+				XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
+		xfs_warn(mp,
 "Superblock has unknown incompatible features (0x%x) enabled.",
-				(sbp->sb_features_incompat &
-						XFS_SB_FEAT_INCOMPAT_UNKNOWN));
-			xfs_warn(mp,
+			(sbp->sb_features_incompat &
+					XFS_SB_FEAT_INCOMPAT_UNKNOWN));
+		xfs_warn(mp,
 "Filesystem can not be safely mounted by this kernel.");
-			return -EINVAL;
-		}
-	} else if (xfs_sb_version_hascrc(sbp)) {
-		/*
-		 * We can't read verify the sb LSN because the read verifier is
-		 * called before the log is allocated and processed. We know the
-		 * log is set up before write verifier (!check_version) calls,
-		 * so just check it here.
-		 */
-		if (!xfs_log_check_lsn(mp, sbp->sb_lsn))
-			return -EFSCORRUPTED;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Check all the superblock fields we care about when writing one out. */
+STATIC int
+xfs_validate_sb_write(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	if (!xfs_sb_version_hascrc(sbp))
+		return 0;
+
+	/*
+	 * We can't read verify the sb LSN because the read verifier is called
+	 * before the log is allocated and processed. We know the log is set up
+	 * before write verifier (!check_version) calls, so just check it here.
+	 */
+	if (!xfs_log_check_lsn(mp, sbp->sb_lsn))
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Check the validity of the SB. */
+STATIC int
+xfs_validate_sb_common(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct xfs_sb		*sbp)
+{
+	uint32_t		agcount = 0;
+	uint32_t		rem;
+
+	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
+		xfs_warn(mp, "bad magic number");
+		return -EWRONGFS;
+	}
+
+
+	if (!xfs_sb_good_version(sbp)) {
+		xfs_warn(mp, "bad version");
+		return -EWRONGFS;
 	}
 
 	if (xfs_sb_version_has_pquotino(sbp)) {
@@ -321,7 +337,12 @@ xfs_mount_validate_sb(
 		return -EFBIG;
 	}
 
-	if (check_inprogress && sbp->sb_inprogress) {
+	/*
+	 * Don't touch the filesystem if a user tool thinks it owns the primary
+	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
+	 * we don't check them at all.
+	 */
+	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && sbp->sb_inprogress) {
 		xfs_warn(mp, "Offline file system operation in progress!");
 		return -EFSCORRUPTED;
 	}
@@ -596,29 +617,6 @@ xfs_sb_to_disk(
 	}
 }
 
-static int
-xfs_sb_verify(
-	struct xfs_buf	*bp,
-	bool		check_version)
-{
-	struct xfs_mount *mp = bp->b_target->bt_mount;
-	struct xfs_sb	sb;
-
-	/*
-	 * Use call variant which doesn't convert quota flags from disk 
-	 * format, because xfs_mount_validate_sb checks the on-disk flags.
-	 */
-	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
-
-	/*
-	 * Only check the in progress field for the primary superblock as
-	 * mkfs.xfs doesn't clear it from secondary superblocks.
-	 */
-	return xfs_mount_validate_sb(mp, &sb,
-				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
-				     check_version);
-}
-
 /*
  * If the superblock has the CRC feature bit set or the CRC field is non-null,
  * check that the CRC is valid.  We check the CRC field is non-null because a
@@ -633,11 +631,12 @@ xfs_sb_verify(
  */
 static void
 xfs_sb_read_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
-	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
-	int		error;
+	struct xfs_sb		sb;
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
+	int			error;
 
 	/*
 	 * open code the version check to avoid needing to convert the entire
@@ -657,7 +656,16 @@ xfs_sb_read_verify(
 			}
 		}
 	}
-	error = xfs_sb_verify(bp, true);
+
+	/*
+	 * Check all the superblock fields.  Don't byteswap the xquota flags
+	 * because _verify_common checks the on-disk values.
+	 */
+	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
+	error = xfs_validate_sb_common(mp, bp, &sb);
+	if (error)
+		goto out_error;
+	error = xfs_validate_sb_read(mp, &sb);
 
 out_error:
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
@@ -691,15 +699,22 @@ static void
 xfs_sb_write_verify(
 	struct xfs_buf		*bp)
 {
+	struct xfs_sb		sb;
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			error;
 
-	error = xfs_sb_verify(bp, false);
-	if (error) {
-		xfs_verifier_error(bp, error, __this_address);
-		return;
-	}
+	/*
+	 * Check all the superblock fields.  Don't byteswap the xquota flags
+	 * because _verify_common checks the on-disk values.
+	 */
+	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
+	error = xfs_validate_sb_common(mp, bp, &sb);
+	if (error)
+		goto out_error;
+	error = xfs_validate_sb_write(mp, &sb);
+	if (error)
+		goto out_error;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
@@ -708,6 +723,10 @@ xfs_sb_write_verify(
 		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
 	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
+	return;
+
+out_error:
+	xfs_verifier_error(bp, error, __this_address);
 }
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {

