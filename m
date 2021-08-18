Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26029C43216
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3C46104F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbhHSAAY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 20:00:24 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:56700 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235435AbhHSAAX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 20:00:23 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id BB62185685
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 09:59:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-002JQ5-RU
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-000cwi-JV
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/16] xfs: introduce xfs_sb_is_v5 helper
Date:   Thu, 19 Aug 2021 09:59:34 +1000
Message-Id: <20210818235935.149431-16-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818235935.149431-1-david@fromorbit.com>
References: <20210818235935.149431-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=njKZKf6otGJW6kSs9yYA:9 a=i8kd-j3wIw2eCQ3F:21 a=ixUmjp0-4QAcfMYr:21
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

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
---
 fs/xfs/libxfs/xfs_format.h | 16 +++++++-------
 fs/xfs/libxfs/xfs_sb.c     | 45 +++++++++++++++++++-------------------
 fs/xfs/scrub/agheader.c    |  2 +-
 fs/xfs/xfs_log_recover.c   |  2 +-
 fs/xfs/xfs_super.c         | 11 +++++-----
 5 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 00d19d18a2d1..ee479feb32b5 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e2b50f5e9f35..197093acb828 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -38,7 +38,7 @@ xfs_sb_good_version(
 	struct xfs_sb	*sbp)
 {
 	/* all v5 filesystems are supported */
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
+	if (xfs_sb_is_v5(sbp))
 		return true;
 
 	/* versions prior to v4 are not supported */
@@ -97,7 +97,7 @@ xfs_sb_version_to_features(
 			features |= XFS_FEAT_FTYPE;
 	}
 
-	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
+	if (!xfs_sb_is_v5(sbp))
 		return features;
 
 	/* Always on V5 features */
@@ -133,7 +133,7 @@ xfs_validate_sb_read(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
-	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
+	if (!xfs_sb_is_v5(sbp))
 		return 0;
 
 	/*
@@ -200,7 +200,7 @@ xfs_validate_sb_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
+	if (!xfs_sb_is_v5(sbp))
 		return 0;
 
 	/*
@@ -274,7 +274,7 @@ xfs_validate_sb_common(
 	/*
 	 * Validate feature flags and state
 	 */
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
+	if (xfs_sb_is_v5(sbp)) {
 		if (sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
 			xfs_notice(mp,
 "Block size (%u bytes) too small for Version 5 superblock (minimum %d bytes)",
@@ -465,7 +465,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	 * We need to do these manipilations only if we are working
 	 * with an older version of on-disk superblock.
 	 */
-	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_5)
+	if (xfs_sb_is_v5(sbp))
 		return;
 
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
@@ -558,7 +558,7 @@ __xfs_sb_from_disk(
 	 * sb_meta_uuid is only on disk if it differs from sb_uuid and the
 	 * feature flag is set; if not set we keep it only in memory.
 	 */
-	if (XFS_SB_VERSION_NUM(to) == XFS_SB_VERSION_5 &&
+	if (xfs_sb_is_v5(to) &&
 	    (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID))
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	else
@@ -589,7 +589,7 @@ xfs_sb_quota_to_disk(
 	 * The in-memory superblock quota state matches the v5 on-disk format so
 	 * just write them out and return
 	 */
-	if (XFS_SB_VERSION_NUM(from) == XFS_SB_VERSION_5) {
+	if (xfs_sb_is_v5(from)) {
 		to->sb_qflags = cpu_to_be16(from->sb_qflags);
 		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
 		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
@@ -699,19 +699,20 @@ xfs_sb_to_disk(
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
@@ -814,7 +815,7 @@ xfs_sb_write_verify(
 	if (error)
 		goto out_error;
 
-	if (XFS_SB_VERSION_NUM(&sb) != XFS_SB_VERSION_5)
+	if (!xfs_sb_is_v5(&sb))
 		return;
 
 	if (bip)
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 0f6051d1854a..8c403eca5c2d 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -258,7 +258,7 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 	} else {
 		v2_ok = XFS_SB_VERSION2_OKBITS;
-		if (XFS_SB_VERSION_NUM(&mp->m_sb) >= XFS_SB_VERSION_5)
+		if (xfs_sb_is_v5(&mp->m_sb))
 			v2_ok |= XFS_SB_VERSION2_CRCBIT;
 
 		if (!!(sb->sb_features2 & cpu_to_be32(~v2_ok)))
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a985aa1a721c..10562ecbd9ea 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3413,7 +3413,7 @@ xlog_recover(
 		 * (e.g. unsupported transactions, then simply reject the
 		 * attempt at recovery before touching anything.
 		 */
-		if (XFS_SB_VERSION_NUM(&log->l_mp->m_sb) == XFS_SB_VERSION_5 &&
+		if (xfs_sb_is_v5(&log->l_mp->m_sb) &&
 		    xfs_sb_has_incompat_log_feature(&log->l_mp->m_sb,
 					XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN)) {
 			xfs_warn(log->l_mp,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8f8029e6048f..6f2562a2ea62 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1590,7 +1590,7 @@ xfs_fs_fill_super(
 	set_posix_acl_flag(sb);
 
 	/* version 5 superblocks support inode version counters. */
-	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+	if (xfs_has_crc(mp))
 		sb->s_flags |= SB_I_VERSION;
 
 	if (xfs_has_dax_always(mp)) {
@@ -1711,7 +1711,7 @@ xfs_remount_rw(
 		return -EINVAL;
 	}
 
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+	if (xfs_sb_is_v5(sbp) &&
 	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_warn(mp,
 	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
@@ -1831,12 +1831,11 @@ xfs_fs_reconfigure(
 {
 	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
 	struct xfs_mount        *new_mp = fc->s_fs_info;
-	xfs_sb_t		*sbp = &mp->m_sb;
 	int			flags = fc->sb_flags;
 	int			error;
 
 	/* version 5 superblocks always support version counters. */
-	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+	if (xfs_has_crc(mp))
 		fc->sb_flags |= SB_I_VERSION;
 
 	error = xfs_fs_validate_params(new_mp);
@@ -1848,13 +1847,13 @@ xfs_fs_reconfigure(
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
 		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
-		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
+		mp->m_maxagi = xfs_set_inode_alloc(mp, mp->m_sb.sb_agcount);
 	}
 
 	/* inode64 -> inode32 */
 	if (!xfs_has_small_inums(mp) && xfs_has_small_inums(new_mp)) {
 		mp->m_features |= XFS_FEAT_SMALL_INUMS;
-		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
+		mp->m_maxagi = xfs_set_inode_alloc(mp, mp->m_sb.sb_agcount);
 	}
 
 	/* ro -> rw */
-- 
2.31.1

