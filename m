Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA58C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbiATAUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240414AbiATAUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:20:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8000C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78E1E6150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40D9C004E1;
        Thu, 20 Jan 2022 00:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638041;
        bh=BPw+joGeRWhVGQbiB4/8ZsSLHMiYHqI5IOVKLY1nnVc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vLZixSzEZZ+9DmRvQU+ygSHUvufR1Q41CBMDT6SQUJbQqqMip876dWQ/7P2nAiJed
         dLUI5D11dRY4RAsrhEj1FsnAoyFFuuHZ5s6K+/dL5oOupm7+OmVG9G96K24ltKvOoh
         r3Q0Ngd1fIss4iw50F8Xlq23QoBS7EY4jf2b4rH8GfrWwhz2vmilB5GEkLZ5UuKySn
         rnclGW71Mke9nYJtaj6IoDmN0pMnCxjTML/qf2cv0c5ImIIJQXNJrz+7I8M+wKMmjM
         cFtDUnzamAG2aytjvMYL7o5mU2wkgRXKPPe2th46fv9Du7HLKtKtE9Ej9A7wIHD7g/
         fxgmx68XevRGA==
Subject: [PATCH 36/45] xfs: introduce xfs_sb_is_v5 helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:20:41 -0800
Message-ID: <164263804149.860211.15776191919700935492.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: d6837c1aab42e70141fd3875ba05eb69ffb220f0

Rather than open coding XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5
checks everywhere, add a simple wrapper to encapsulate this and make
the code easier to read.

This allows us to remove the xfs_sb_version_has_v3inode() wrapper
which is only used in xfs_format.h now and is just a version number
check.

There are a couple of places where we should be checking the mount
feature bits rather than the superblock version (e.g. remount), so
those are converted to use xfs_has_crc(mp) instead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h |   16 ++++++++--------
 libxfs/xfs_sb.c     |   45 +++++++++++++++++++++++----------------------
 2 files changed, 31 insertions(+), 30 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 00d19d18..ee479feb 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -279,6 +279,11 @@ typedef struct xfs_dsb {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
+static inline bool xfs_sb_is_v5(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
  * this into the wrong slot, so to be safe we keep them in sync.
@@ -290,7 +295,7 @@ static inline bool xfs_sb_has_mismatched_features2(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	return xfs_sb_is_v5(sbp) ||
 	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
 }
 
@@ -413,15 +418,10 @@ xfs_sb_add_incompat_log_features(
  * v5 file systems support V3 inodes only, earlier file systems support
  * v2 and v1 inodes.
  */
-static inline bool xfs_sb_version_has_v3inode(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
-}
-
 static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
 		uint8_t version)
 {
-	if (xfs_sb_version_has_v3inode(sbp))
+	if (xfs_sb_is_v5(sbp))
 		return version == 3;
 	return version == 1 || version == 2;
 }
@@ -893,7 +893,7 @@ enum xfs_dinode_fmt {
  * Inode size for given fs.
  */
 #define XFS_DINODE_SIZE(sbp) \
-	(xfs_sb_version_has_v3inode(sbp) ? \
+	(xfs_sb_is_v5(sbp) ? \
 		sizeof(struct xfs_dinode) : \
 		offsetof(struct xfs_dinode, di_crc))
 #define XFS_LITINO(mp) \
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 18be9164..198d211e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -36,7 +36,7 @@ xfs_sb_good_version(
 	struct xfs_sb	*sbp)
 {
 	/* all v5 filesystems are supported */
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
+	if (xfs_sb_is_v5(sbp))
 		return true;
 
 	/* versions prior to v4 are not supported */
@@ -95,7 +95,7 @@ xfs_sb_version_to_features(
 			features |= XFS_FEAT_FTYPE;
 	}
 
-	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
+	if (!xfs_sb_is_v5(sbp))
 		return features;
 
 	/* Always on V5 features */
@@ -131,7 +131,7 @@ xfs_validate_sb_read(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
-	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
+	if (!xfs_sb_is_v5(sbp))
 		return 0;
 
 	/*
@@ -198,7 +198,7 @@ xfs_validate_sb_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
+	if (!xfs_sb_is_v5(sbp))
 		return 0;
 
 	/*
@@ -272,7 +272,7 @@ xfs_validate_sb_common(
 	/*
 	 * Validate feature flags and state
 	 */
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
+	if (xfs_sb_is_v5(sbp)) {
 		if (sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
 			xfs_notice(mp,
 "Block size (%u bytes) too small for Version 5 superblock (minimum %d bytes)",
@@ -463,7 +463,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	 * We need to do these manipilations only if we are working
 	 * with an older version of on-disk superblock.
 	 */
-	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_5)
+	if (xfs_sb_is_v5(sbp))
 		return;
 
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
@@ -556,7 +556,7 @@ __xfs_sb_from_disk(
 	 * sb_meta_uuid is only on disk if it differs from sb_uuid and the
 	 * feature flag is set; if not set we keep it only in memory.
 	 */
-	if (XFS_SB_VERSION_NUM(to) == XFS_SB_VERSION_5 &&
+	if (xfs_sb_is_v5(to) &&
 	    (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID))
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	else
@@ -587,7 +587,7 @@ xfs_sb_quota_to_disk(
 	 * The in-memory superblock quota state matches the v5 on-disk format so
 	 * just write them out and return
 	 */
-	if (XFS_SB_VERSION_NUM(from) == XFS_SB_VERSION_5) {
+	if (xfs_sb_is_v5(from)) {
 		to->sb_qflags = cpu_to_be16(from->sb_qflags);
 		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
 		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
@@ -697,19 +697,20 @@ xfs_sb_to_disk(
 	to->sb_features2 = cpu_to_be32(from->sb_features2);
 	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
 
-	if (XFS_SB_VERSION_NUM(from) == XFS_SB_VERSION_5) {
-		to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
-		to->sb_features_ro_compat =
-				cpu_to_be32(from->sb_features_ro_compat);
-		to->sb_features_incompat =
-				cpu_to_be32(from->sb_features_incompat);
-		to->sb_features_log_incompat =
-				cpu_to_be32(from->sb_features_log_incompat);
-		to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
-		to->sb_lsn = cpu_to_be64(from->sb_lsn);
-		if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
-			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
-	}
+	if (!xfs_sb_is_v5(from))
+		return;
+
+	to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
+	to->sb_features_ro_compat =
+			cpu_to_be32(from->sb_features_ro_compat);
+	to->sb_features_incompat =
+			cpu_to_be32(from->sb_features_incompat);
+	to->sb_features_log_incompat =
+			cpu_to_be32(from->sb_features_log_incompat);
+	to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
+	to->sb_lsn = cpu_to_be64(from->sb_lsn);
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
+		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 }
 
 /*
@@ -812,7 +813,7 @@ xfs_sb_write_verify(
 	if (error)
 		goto out_error;
 
-	if (XFS_SB_VERSION_NUM(&sb) != XFS_SB_VERSION_5)
+	if (!xfs_sb_is_v5(&sb))
 		return;
 
 	if (bip)

