Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38458 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbeHTIDJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:09 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006SC-8r
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000QS-80
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/10] xfs: open code sb verifier feature checks
Date: Mon, 20 Aug 2018 14:48:49 +1000
Message-Id: <20180820044851.414-9-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The superblock verifiers are one of the last places that use the sb
version functions to do feature checks. This are all quite simple
uses, and there aren't many of them so open code them all.

Also, move the good version number check into xfs_sb.c instead of it
being an inline function in xfs_format.h

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |  26 ---------
 fs/xfs/libxfs/xfs_sb.c     | 116 +++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_sb.h     |   1 +
 3 files changed, 81 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e21c39b13890..1f1107892dcd 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -280,32 +280,6 @@ typedef struct xfs_dsb {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-/*
- * The first XFS version we support is a v4 superblock with V2 directories.
- */
-static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
-{
-	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
-		return false;
-
-	/* check for unknown features in the fs */
-	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
-	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
-	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
-		return false;
-
-	return true;
-}
-
-static inline bool xfs_sb_good_version(struct xfs_sb *sbp)
-{
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
-		return true;
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
-		return xfs_sb_good_v4_features(sbp);
-	return false;
-}
-
 static inline bool xfs_sb_version_hasrealtime(struct xfs_sb *sbp)
 {
 	return sbp->sb_rblocks > 0;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index bedf6c6bf990..b83cf8adca1a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -96,6 +96,35 @@ xfs_perag_put(
 	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
 }
 
+/*
+ * We support all XFS versions newer than a v4 superblock with V2 directories.
+ */
+bool
+xfs_sb_good_version(
+	struct xfs_sb	*sbp)
+{
+	/* all v5 filesystems are supported */
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
+		return true;
+
+	/* versions prior to v4 are not supported */
+	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
+		return false;
+
+	/* V4 filesystems need v2 directories */
+	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
+		return false;
+
+	/* And must not have any unknown v4 feature bits set */
+	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
+	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
+	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
+		return false;
+
+	/* It's a supported v4 filesystem */
+	return true;
+}
+
 uint64_t
 xfs_sb_version_to_features(
 	struct xfs_sb	*sbp)
@@ -288,6 +317,7 @@ xfs_validate_sb_common(
 {
 	uint32_t		agcount = 0;
 	uint32_t		rem;
+	bool			has_dalign;
 
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
 		xfs_warn(mp, "bad magic number");
@@ -299,12 +329,43 @@ xfs_validate_sb_common(
 		return -EWRONGFS;
 	}
 
-	if (xfs_sb_version_haspquotino(sbp)) {
+	/*
+	 * Validate feature flags and state
+	 */
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
+
+		if (sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
+			xfs_notice(mp,
+"Block size (%u bytes) too small for Version 5 superblock (minimum %d bytes)",
+				sbp->sb_blocksize, XFS_MIN_CRC_BLOCKSIZE);
+			return -EFSCORRUPTED;
+		}
+
+		/* V5 has a separate project quota inode */
 		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
 			xfs_notice(mp,
 			   "Version 5 of Super block has XFS_OQUOTA bits.");
 			return -EFSCORRUPTED;
 		}
+
+		/*
+		 * Full inode chunks must be aligned to inode chunk size when
+		 * sparse inodes are enabled to support the sparse chunk
+		 * allocation algorithm and prevent overlapping inode records.
+		 */
+		if (xfs_sb_has_incompat_feature(sbp,
+				XFS_SB_FEAT_INCOMPAT_SPINODES)) {
+			uint32_t	align;
+
+			align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
+					>> sbp->sb_blocklog;
+			if (sbp->sb_inoalignmt != align) {
+				xfs_warn(mp,
+"Inode block alignment (%u) must match chunk size (%u) for sparse inodes.",
+					 sbp->sb_inoalignmt, align);
+				return -EINVAL;
+			}
+		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
@@ -312,24 +373,6 @@ xfs_validate_sb_common(
 			return -EFSCORRUPTED;
 	}
 
-	/*
-	 * Full inode chunks must be aligned to inode chunk size when
-	 * sparse inodes are enabled to support the sparse chunk
-	 * allocation algorithm and prevent overlapping inode records.
-	 */
-	if (xfs_sb_version_hassparseinodes(sbp)) {
-		uint32_t	align;
-
-		align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
-				>> sbp->sb_blocklog;
-		if (sbp->sb_inoalignmt != align) {
-			xfs_warn(mp,
-"Inode block alignment (%u) must match chunk size (%u) for sparse inodes.",
-				 sbp->sb_inoalignmt, align);
-			return -EINVAL;
-		}
-	}
-
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
 		xfs_warn(mp,
@@ -393,14 +436,15 @@ xfs_validate_sb_common(
 		return -EFSCORRUPTED;
 	}
 
+
+	has_dalign = sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT;
 	if (sbp->sb_unit) {
-		if (!xfs_sb_version_hasdalign(sbp) ||
-		    sbp->sb_unit > sbp->sb_width ||
+		if (!has_dalign || sbp->sb_unit > sbp->sb_width ||
 		    (sbp->sb_width % sbp->sb_unit) != 0) {
 			xfs_notice(mp, "SB stripe unit sanity check failed");
 			return -EFSCORRUPTED;
 		}
-	} else if (xfs_sb_version_hasdalign(sbp)) {
+	} else if (has_dalign) {
 		xfs_notice(mp, "SB stripe alignment sanity check failed");
 		return -EFSCORRUPTED;
 	} else if (sbp->sb_width) {
@@ -409,12 +453,6 @@ xfs_validate_sb_common(
 	}
 
 
-	if (xfs_has_crc(mp) &&
-	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
-		xfs_notice(mp, "v5 SB sanity check failed");
-		return -EFSCORRUPTED;
-	}
-
 	/*
 	 * Until this is fixed only page-sized or smaller data blocks work.
 	 */
@@ -485,7 +523,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	 * We need to do these manipilations only if we are working
 	 * with an older version of on-disk superblock.
 	 */
-	if (xfs_sb_version_haspquotino(sbp))
+	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_5)
 		return;
 
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
@@ -578,7 +616,8 @@ __xfs_sb_from_disk(
 	 * sb_meta_uuid is only on disk if it differs from sb_uuid and the
 	 * feature flag is set; if not set we keep it only in memory.
 	 */
-	if (xfs_sb_version_hasmetauuid(to))
+	if (XFS_SB_VERSION_NUM(to) == XFS_SB_VERSION_5 &&
+	    (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID))
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	else
 		uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);
@@ -603,7 +642,12 @@ xfs_sb_quota_to_disk(
 	uint16_t	qflags = from->sb_qflags;
 
 	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
-	if (xfs_sb_version_haspquotino(from)) {
+
+	/*
+	 * The in-memory superblock quota state matches the v5 on-disk format so
+	 * just write them out and return
+	 */
+	if (XFS_SB_VERSION_NUM(from) == XFS_SB_VERSION_5) {
 		to->sb_qflags = cpu_to_be16(from->sb_qflags);
 		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
 		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
@@ -611,9 +655,9 @@ xfs_sb_quota_to_disk(
 	}
 
 	/*
-	 * The in-core version of sb_qflags do not have XFS_OQUOTA_*
-	 * flags, whereas the on-disk version does.  So, convert incore
-	 * XFS_{PG}QUOTA_* flags to on-disk XFS_OQUOTA_* flags.
+	 * For older superblocks (v4), the in-core version of sb_qflags do not
+	 * have XFS_OQUOTA_* flags, whereas the on-disk version does.  So,
+	 * convert incore XFS_{PG}QUOTA_* flags to on-disk XFS_OQUOTA_* flags.
 	 */
 	qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
 			XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
@@ -713,7 +757,7 @@ xfs_sb_to_disk(
 	to->sb_features2 = cpu_to_be32(from->sb_features2);
 	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
 
-	if (xfs_sb_version_hascrc(from)) {
+	if (XFS_SB_VERSION_NUM(from) == XFS_SB_VERSION_5) {
 		to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
 		to->sb_features_ro_compat =
 				cpu_to_be32(from->sb_features_ro_compat);
@@ -723,7 +767,7 @@ xfs_sb_to_disk(
 				cpu_to_be32(from->sb_features_log_incompat);
 		to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
 		to->sb_lsn = cpu_to_be64(from->sb_lsn);
-		if (xfs_sb_version_hasmetauuid(from))
+		if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
 			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	}
 }
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 8f4cbe2b639c..e136c2517647 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -29,6 +29,7 @@ extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
+extern bool	xfs_sb_good_version(struct xfs_sb *sbp);
 extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
-- 
2.17.0
