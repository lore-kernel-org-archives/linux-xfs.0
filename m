Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A40F1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiLaCLn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:11:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754DD1C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2F65CE1926
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D87AC433D2;
        Sat, 31 Dec 2022 02:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452698;
        bh=VPs97udBes+VcAPw73vmJ7Xxg/xweAlUvhxzFCD3cm4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gKa0z2Yj8cpGtnZ8+ugaf8X5Ybdv0ZmyVADmT8xeQ58eOFwmsH3PfxEoZ8l+e0i1D
         YFLyMBsvJMnAter/g3ZD3Yt00TGUxmmY4oKHx1gYt1Sp5/+Du/B0U5ePd6bqG1bqma
         hSg9GtK7AwyF/UASFIbtC0mMWdPFhtlY0oAencbyEFIObiY7Rr0/xhDIa3azvRmMVa
         JIL5S+FD8Q/tVj8T7nIUwES+SNPpJfwmW1P6RAbimr/h7IZvOLZKPzqO2jrpioZ2sE
         Aqzp4jz0bjCe3VmwP67Asp+tN5cIF4jrjPEEOwjoyXi/tz3EglVuAEPPfK1dCPX379
         HY7yP32Ln82Xg==
Subject: [PATCH 07/46] xfs: define the on-disk format for the metadir feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876031.725900.4189491535626226806.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
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
 include/xfs_inode.h     |    5 +++++
 include/xfs_mount.h     |    2 ++
 libxfs/xfs_format.h     |   48 +++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_inode_util.c |    2 ++
 libxfs/xfs_sb.c         |    2 ++
 5 files changed, 57 insertions(+), 2 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index ccd19e5ee5b..b099c036ef2 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -287,6 +287,11 @@ static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
 	return false;
 }
 
+static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
+}
+
 extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
 				struct xfs_buf *);
 
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 1690660ed5b..5a8f45e7796 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -161,6 +161,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
+#define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -205,6 +206,7 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
+__XFS_HAS_FEAT(metadir, METADIR)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index abd75b3091e..0bd915bd4ee 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 65c025f3573..cc203321dad 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -222,6 +222,8 @@ xfs_inode_inherit_flags2(
 	}
 	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+	if (pip->i_diflags2 & XFS_DIFLAG2_METADATA)
+		ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
 
 	/* Don't let invalid cowextsize hints propagate. */
 	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 10f699b4e99..c421099e4f9 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -172,6 +172,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+		features |= XFS_FEAT_METADIR;
 
 	return features;
 }

