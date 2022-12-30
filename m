Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78E2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiLaBMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiLaBMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:12:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0971616588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61779CE1923
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA1AC433EF;
        Sat, 31 Dec 2022 01:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449129;
        bh=QVkN2uWI/9XniCTBTcvTMd43daURda/gwqWIMwpkQC4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o2EzxOtKAM0i6whHJZeERj4iRY5WS+HomWIcxXY6f2dtwrHzdaOgKKhGRbsQvL4Sh
         6NrT7fiTAEUQhAJXP4BdWRFr/CbB9nPPduWYlOq6njLPiEfJo84TMUFm6hoOaraktn
         /xk/N1FrV/xzpLMLDVaNMtFE3qpjtA+cUKGfEAuTiGFlUz4HmGwOoSVt0ilaIhmtE2
         PdVzAKjWAMLlCb91tcuZBCWxx6dMv6mE1kNjyubk56FpttImOZ8GUPSL+SEZ73RqeK
         TIxfvheJBl6g8SyhFgjyWUWcChVh9z/D430jsrIsV3JGVcVO4A+pNNRwH/sDBH/dgz
         y2jIhpwBDT6nw==
Subject: [PATCH 07/23] xfs: define the on-disk format for the metadir feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864556.708110.17274654467058270183.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Define the on-disk layout and feature flags for the metadata inode
directory feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     |   48 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_util.c |    2 ++
 fs/xfs/libxfs/xfs_sb.c         |    2 ++
 fs/xfs/xfs_inode.h             |    7 ++++++
 fs/xfs/xfs_mount.h             |    2 ++
 fs/xfs/xfs_super.c             |    4 +++
 6 files changed, 63 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index abd75b3091ec..0bd915bd4eed 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -174,6 +174,16 @@ typedef struct xfs_sb {
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
+	/* Fields beyond here do not match xfs_dsb.  Be very careful! */
+
+	/*
+	 * Metadata Directory Inode.  On disk this lives in the sb_rbmino slot,
+	 * but we continue to use the in-core superblock to cache the classic
+	 * inodes (rt bitmap; rt summary; user, group, and project quotas) so
+	 * we cache the metadir inode value here too.
+	 */
+	xfs_ino_t	sb_metadirino;
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
@@ -190,7 +200,14 @@ struct xfs_dsb {
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	__be64		sb_logstart;	/* starting block of log if internal */
 	__be64		sb_rootino;	/* root inode number */
-	__be64		sb_rbmino;	/* bitmap inode for realtime extents */
+	/*
+	 * bitmap inode for realtime extents.
+	 *
+	 * The metadata directory feature uses the sb_rbmino field to point to
+	 * the root of the metadata directory tree.  All other sb inode
+	 * pointers are no longer used.
+	 */
+	__be64		sb_rbmino;
 	__be64		sb_rsumino;	/* summary inode for rt bitmap */
 	__be32		sb_rextsize;	/* realtime extent size, blocks */
 	__be32		sb_agblocks;	/* size of an allocation group */
@@ -372,6 +389,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_METADIR	(1U << 31)	/* metadata dir tree */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -1078,6 +1096,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
 #define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
+#define XFS_DIFLAG2_METADATA_BIT 63	/* filesystem metadata */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
@@ -1085,9 +1104,34 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
 #define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
+/*
+ * The inode contains filesystem metadata and can be found through the metadata
+ * directory tree.  Metadata inodes must satisfy the following constraints:
+ *
+ * - V5 filesystem (and ftype) are enabled;
+ * - The only valid modes are regular files and directories;
+ * - The access bits must be zero;
+ * - DMAPI event and state masks are zero;
+ * - The user, group, and project IDs must be zero;
+ * - The immutable, sync, noatime, nodump, nodefrag flags must be set.
+ * - The dax flag must not be set.
+ * - Directories must have nosymlinks set.
+ *
+ * These requirements are chosen defensively to minimize the ability of
+ * userspace to read or modify the contents, should a metadata file ever
+ * escape to userspace.
+ *
+ * There are further constraints on the directory tree itself:
+ *
+ * - Metadata inodes must never be resolvable through the root directory;
+ * - They must never be accessed by userspace;
+ * - Metadata directory entries must have correct ftype.
+ */
+#define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
+
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 1135bec1328b..7b3e0c79c847 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -225,6 +225,8 @@ xfs_inode_inherit_flags2(
 	}
 	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+	if (pip->i_diflags2 & XFS_DIFLAG2_METADATA)
+		ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
 
 	/* Don't let invalid cowextsize hints propagate. */
 	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5b6f5939fda1..345a6fdf8625 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -174,6 +174,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+		features |= XFS_FEAT_METADIR;
 
 	return features;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 571f61930b7b..d45583cd349d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -264,6 +264,13 @@ static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
+	if (xfs_has_metadir(mp))
+		return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
+
+	/*
+	 * Before metadata directories, the only metadata inodes were the
+	 * three quota files, the realtime bitmap, and the realtime summary.
+	 */
 	return ip == mp->m_rbmip || ip == mp->m_rsumip ||
 		xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3b2601ab954d..0fb545e92a26 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -281,6 +281,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
+#define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -344,6 +345,7 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
+__XFS_HAS_FEAT(metadir, METADIR)
 
 /*
  * Mount features
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4cf26611f46f..9eff9ee106c4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1640,6 +1640,10 @@ xfs_fs_fill_super(
 		mp->m_features &= ~XFS_FEAT_DISCARD;
 	}
 
+	if (xfs_has_metadir(mp))
+		xfs_warn(mp,
+"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
+
 	if (xfs_has_reflink(mp)) {
 		if (mp->m_sb.sb_rblocks) {
 			xfs_alert(mp,

