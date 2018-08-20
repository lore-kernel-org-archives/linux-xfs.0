Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45517 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbeHTIDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:06 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006SK-Aa
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000QY-9Y
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/10] xfs: remove unused xfs_sb_version_has... wrappers
Date: Mon, 20 Aug 2018 14:48:51 +1000
Message-Id: <20180820044851.414-11-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

These wrappers are now almost entirely unused. Remove them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 135 +------------------------------------
 1 file changed, 3 insertions(+), 132 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1f1107892dcd..c21fd566bf13 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -280,11 +280,6 @@ typedef struct xfs_dsb {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-static inline bool xfs_sb_version_hasrealtime(struct xfs_sb *sbp)
-{
-	return sbp->sb_rblocks > 0;
-}
-
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
  * this into the wrong slot, so to be safe we keep them in sync.
@@ -294,9 +289,10 @@ static inline bool xfs_sb_has_mismatched_features2(struct xfs_sb *sbp)
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
@@ -304,72 +300,11 @@ static inline void xfs_sb_version_addattr(struct xfs_sb *sbp)
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
-static inline bool xfs_sb_version_hasextflg(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-	       (sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
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
@@ -383,13 +318,6 @@ static inline void xfs_sb_version_removeattr2(struct xfs_sb *sbp)
 		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
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
@@ -467,63 +395,6 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
-/*
- * V5 superblock specific feature checks
- */
-static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
-}
-
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
 /*
  * end of superblock version macros
  */
-- 
2.17.0
