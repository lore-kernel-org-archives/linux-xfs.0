Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C18C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 153F9610F9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbhINCn5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhINCnz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:43:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B78A5610D1;
        Tue, 14 Sep 2021 02:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587358;
        bh=ysWrmbWcxATbiKvepyvPcwErQtpowjHqCUUrKB+cbps=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y77y0dlH1KWpBUHBOBRIoF3uYRqYQUeou0fpts3Cx9jObfpQILP/bP0ybJ1br1ZEH
         SQk2H5b2WFGuwLdEd3DDW9yG0dqDBJfCJgIR/m8Uyt5zoP6b/82M9OAYA9hlwiAgnn
         mh6M0ZAUpXBLZ/V1DwObG+YBQFXCcChauVgUffqe5NFgBgrQNvevopJZ+TEI113Pj9
         OkOshB07/6fqH8byhDFl63LwqCcQYUfDiIdI/W+35qyvoPhAHktF2N2uALFkUctMyl
         FdqQxv0BMLLKyEGETI06jCUw3ae6W7NmCzyzNeDNwX1tNNmRPxiN4ah90kasB+h415
         MVxPSvw2C8kUQ==
Subject: [PATCH 29/43] xfs: open code sb verifier feature checks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:42:38 -0700
Message-ID: <163158735848.1604118.17869848073585469108.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: fe08cc5044486096bfb5ce9d3db4e915e53281ea

The superblock verifiers are one of the last places that use the sb
version functions to do feature checks. This are all quite simple
uses, and there aren't many of them so open code them all.

Also, move the good version number check into xfs_sb.c instead of it
being an inline function in xfs_format.h

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h |   29 -------------
 libxfs/xfs_sb.c     |  116 +++++++++++++++++++++++++++++++++++----------------
 libxfs/xfs_sb.h     |    1 
 3 files changed, 81 insertions(+), 65 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d4690f28..242bf251 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -265,7 +265,6 @@ typedef struct xfs_dsb {
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
 
-
 /*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
  * a feature bit is set when the flag is used.
@@ -280,34 +279,6 @@ typedef struct xfs_dsb {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-/*
- * The first XFS version we support is a v4 superblock with V2 directories.
- */
-static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
-{
-	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
-		return false;
-	if (!(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT))
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index bc226208..a2ad1516 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -28,6 +28,37 @@
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
  */
 
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
+	/* V4 filesystems need v2 directories and unwritten extents */
+	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
+		return false;
+	if (!(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT))
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
@@ -226,6 +257,7 @@ xfs_validate_sb_common(
 	struct xfs_dsb		*dsb = bp->b_addr;
 	uint32_t		agcount = 0;
 	uint32_t		rem;
+	bool			has_dalign;
 
 	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
 		xfs_warn(mp, "bad magic number");
@@ -237,12 +269,41 @@ xfs_validate_sb_common(
 		return -EWRONGFS;
 	}
 
-	if (xfs_sb_version_haspquotino(sbp)) {
+	/*
+	 * Validate feature flags and state
+	 */
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
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
+		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES) {
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
@@ -250,24 +311,6 @@ xfs_validate_sb_common(
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
@@ -367,7 +410,8 @@ xfs_validate_sb_common(
 	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
 	 * would imply the image is corrupted.
 	 */
-	if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
+	has_dalign = sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT;
+	if (!!sbp->sb_unit ^ has_dalign) {
 		xfs_notice(mp, "SB stripe alignment sanity check failed");
 		return -EFSCORRUPTED;
 	}
@@ -376,12 +420,6 @@ xfs_validate_sb_common(
 			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
 		return -EFSCORRUPTED;
 
-	if (xfs_sb_version_hascrc(sbp) &&
-	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
-		xfs_notice(mp, "v5 SB sanity check failed");
-		return -EFSCORRUPTED;
-	}
-
 	/*
 	 * Currently only very few inode sizes are supported.
 	 */
@@ -425,7 +463,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	 * We need to do these manipilations only if we are working
 	 * with an older version of on-disk superblock.
 	 */
-	if (xfs_sb_version_haspquotino(sbp))
+	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_5)
 		return;
 
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
@@ -518,7 +556,8 @@ __xfs_sb_from_disk(
 	 * sb_meta_uuid is only on disk if it differs from sb_uuid and the
 	 * feature flag is set; if not set we keep it only in memory.
 	 */
-	if (xfs_sb_version_hasmetauuid(to))
+	if (XFS_SB_VERSION_NUM(to) == XFS_SB_VERSION_5 &&
+	    (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID))
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	else
 		uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);
@@ -543,7 +582,12 @@ xfs_sb_quota_to_disk(
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
@@ -551,9 +595,9 @@ xfs_sb_quota_to_disk(
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
@@ -653,7 +697,7 @@ xfs_sb_to_disk(
 	to->sb_features2 = cpu_to_be32(from->sb_features2);
 	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
 
-	if (xfs_sb_version_hascrc(from)) {
+	if (XFS_SB_VERSION_NUM(from) == XFS_SB_VERSION_5) {
 		to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
 		to->sb_features_ro_compat =
 				cpu_to_be32(from->sb_features_ro_compat);
@@ -663,7 +707,7 @@ xfs_sb_to_disk(
 				cpu_to_be32(from->sb_features_log_incompat);
 		to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
 		to->sb_lsn = cpu_to_be64(from->sb_lsn);
-		if (xfs_sb_version_hasmetauuid(from))
+		if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
 			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	}
 }
@@ -701,7 +745,7 @@ xfs_sb_read_verify(
 		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
-			    xfs_sb_version_hascrc(&mp->m_sb)) {
+			    xfs_has_crc(mp)) {
 				error = -EFSBADCRC;
 				goto out_error;
 			}
@@ -768,7 +812,7 @@ xfs_sb_write_verify(
 	if (error)
 		goto out_error;
 
-	if (!xfs_sb_version_hascrc(&sb))
+	if (XFS_SB_VERSION_NUM(&sb) != XFS_SB_VERSION_5)
 		return;
 
 	if (bip)
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 8902f4bf..a5e14740 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -20,6 +20,7 @@ extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
+extern bool	xfs_sb_good_version(struct xfs_sb *sbp);
 extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);

