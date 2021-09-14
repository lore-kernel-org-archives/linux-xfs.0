Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD662C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C66F0606A5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhINCoY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhINCoX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:44:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE2B610D1;
        Tue, 14 Sep 2021 02:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587386;
        bh=ZnC/pFslMfH5VrW40wh0wjExF7WWyEQj2IXEehFIz7s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mzcx0BKv5D1N5nwhGFO8v1wGcEVzYjK47GWtgxRC8sjr2weIH3iPA3iiRtRPxxn8n
         oGhkTcdJgoGQfpVHedU0MgrCfKbsrp+T0TpRUNfaK+lQtnNQ6Rok4tPByVJexQR3o6
         rsd0msav14795KLLr5yDNwJuiL0b1nsD/NXCHwizoh7BIqo7edkOhocgAzblas515W
         gEfmJ3FJsi81cYNygh8vh/n6S8O57grDgvkhhCzmGWAE6eUgPtM8he92HD45GeNJJ8
         QMMy+4OZKC1Tucts7FqwCzqjSyEjzjUcbBl8eX7bnVourKkdf88X77KqBhgADE0taf
         1+7tNvA8hM9MQ==
Subject: [PATCH 34/43] xfs: remove unused xfs_sb_version_has wrappers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:43:05 -0700
Message-ID: <163158738595.1604118.13311984301163047176.stgit@magnolia>
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

Source kernel commit: 2beb7b50ddd429f47b6cabd186b3102d2a6aa505

The vast majority of these wrappers are now unused. Remove them
leaving just the small subset of wrappers that are used to either
add feature bits or make the mount features field setup code
simpler.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h    |   56 ++++++++++++++++++
 libxfs/xfs_format.h |  155 +--------------------------------------------------
 2 files changed, 59 insertions(+), 152 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 1d874fcb..04cf0e1f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -217,4 +217,60 @@ bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 #include "xfs_attr.h"
 #include "topology.h"
 
+/*
+ * Superblock helpers for programs that act on independent superblock
+ * structures.  These used to be part of xfs_format.h.
+ */
+static inline bool xfs_sb_version_haslazysbcount(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	       (xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
+}
+
+static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
+static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
+}
+
+static inline bool xfs_sb_version_hasalign(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
+}
+
+static inline bool xfs_sb_version_hasdalign(struct xfs_sb *sbp)
+{
+	return (sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
+}
+
+static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
+}
+
+static inline bool xfs_sb_version_hassector(struct xfs_sb *sbp)
+{
+	return (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
+}
+
+static inline bool xfs_sb_version_needsrepair(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
+}
+
+static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
+}
+
 #endif	/* __LIBXFS_H__ */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 242bf251..00d19d18 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -279,11 +279,6 @@ typedef struct xfs_dsb {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-static inline bool xfs_sb_version_hasrealtime(struct xfs_sb *sbp)
-{
-	return sbp->sb_rblocks > 0;
-}
-
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
  * this into the wrong slot, so to be safe we keep them in sync.
@@ -293,9 +288,10 @@ static inline bool xfs_sb_has_mismatched_features2(struct xfs_sb *sbp)
 	return sbp->sb_bad_features2 != sbp->sb_features2;
 }
 
-static inline bool xfs_sb_version_hasattr(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
 {
-	return (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
 }
 
 static inline void xfs_sb_version_addattr(struct xfs_sb *sbp)
@@ -303,79 +299,17 @@ static inline void xfs_sb_version_addattr(struct xfs_sb *sbp)
 	sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 }
 
-static inline bool xfs_sb_version_hasquota(struct xfs_sb *sbp)
-{
-	return (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
-}
-
 static inline void xfs_sb_version_addquota(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
 }
 
-static inline bool xfs_sb_version_hasalign(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
-}
-
-static inline bool xfs_sb_version_hasdalign(struct xfs_sb *sbp)
-{
-	return (sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
-}
-
-static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-	       (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
-}
-
-static inline bool xfs_sb_version_hassector(struct xfs_sb *sbp)
-{
-	return (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
-}
-
-static inline bool xfs_sb_version_hasasciici(struct xfs_sb *sbp)
-{
-	return (sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
-}
-
-static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
-}
-
-/*
- * sb_features2 bit version macros.
- */
-static inline bool xfs_sb_version_haslazysbcount(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
-}
-
-static inline bool xfs_sb_version_hasattr2(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT));
-}
-
 static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
-static inline bool xfs_sb_version_hasprojid32(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
-}
-
 static inline void xfs_sb_version_addprojid32(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
@@ -474,13 +408,6 @@ xfs_sb_add_incompat_log_features(
 	sbp->sb_features_log_incompat |= features;
 }
 
-/*
- * V5 superblock specific feature checks
- */
-static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
-}
 
 /*
  * v5 file systems support V3 inodes only, earlier file systems support
@@ -499,82 +426,6 @@ static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
 	return version == 1 || version == 2;
 }
 
-static inline bool xfs_sb_version_haspquotino(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
-}
-
-static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE)) ||
-	       (xfs_sb_version_hasmorebits(sbp) &&
-		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
-}
-
-static inline bool xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
-		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
-}
-
-static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
-}
-
-/*
- * XFS_SB_FEAT_INCOMPAT_META_UUID indicates that the metadata UUID
- * is stored separately from the user-visible UUID; this allows the
- * user-visible UUID to be changed on V5 filesystems which have a
- * filesystem UUID stamped into every piece of metadata.
- */
-static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
-		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
-}
-
-static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
-		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
-}
-
-static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
-}
-
-static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
-}
-
-/*
- * Inode btree block counter.  We record the number of inobt and finobt blocks
- * in the AGI header so that we can skip the finobt walk at mount time when
- * setting up per-AG reservations.
- */
-static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
-}
-
-static inline bool xfs_sb_version_needsrepair(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
-}
-
-/*
- * end of superblock version macros
- */
-
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 {

