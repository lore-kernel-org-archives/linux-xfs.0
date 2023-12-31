Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64181C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ek0DwadF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E814CC433C7;
	Sun, 31 Dec 2023 23:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065501;
	bh=8KQtq39YR2qxhC32eAg8QO8jYpaQkf7I69GzF/FlmL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ek0DwadFfa0fhYYxJh3ueWRzsqxfiaNGUjCb2/x4ixlRbBYBIE4zPYn/r23fHWDYd
	 FW0zVg13XlbV6twCyjIZajnIPmr7PPSi48u/RFQm5UqU9DdzcEzNFBv0WkUGJ6t5pV
	 qxdj6GYd1IKjWQJSkCuU7fjKICJoFuA/u8HX2COvlxkpAaZZ6cNtkde8b8+8caa9fU
	 bgNg2x3MqI47UNMgtB2CW+biJM/OtF4Gl78eASS2xp/QzW3Uap3VyZDzo9z0VxV/6b
	 26amQVwdH4acxztcdSv4FwcEm/QcxmCiwaWo44BCxMUit2VPI+agM4D7Z5XUVJGqvF
	 K9JK1tNuJEsXw==
Date: Sun, 31 Dec 2023 15:31:40 -0800
Subject: [PATCH 08/58] xfs: define the on-disk format for the metadir feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010053.1809361.17434100075820339651.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Define the on-disk layout and feature flags for the metadata inode
directory feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h     |    5 ++++
 include/xfs_mount.h     |    2 ++
 libxfs/xfs_format.h     |   60 +++++++++++++++++++++++++++++++++++++++++------
 libxfs/xfs_inode_util.c |    2 ++
 libxfs/xfs_sb.c         |    2 ++
 5 files changed, 63 insertions(+), 8 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 5d7bc69e3ff..1fdae6c1d3a 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -386,6 +386,11 @@ static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
 	return false;
 }
 
+static inline bool xfs_is_metadir_inode(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_METADIR;
+}
+
 extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
 				struct xfs_buf *);
 
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index da621f3b992..7dfa94dfd9f 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -175,6 +175,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
+#define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -219,6 +220,7 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
+__XFS_HAS_FEAT(metadir, METADIR)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index c60af436963..7596b928698 100644
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
@@ -373,6 +390,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
 #define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
+#define XFS_SB_FEAT_INCOMPAT_METADIR	(1U << 31)	/* metadata dir tree */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -1109,17 +1127,43 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
-#define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
+#define XFS_DIFLAG2_NREXT64_BIT	4	/* large extent counters */
+#define XFS_DIFLAG2_METADIR_BIT	63	/* filesystem metadata */
 
-#define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
-#define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
-#define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
-#define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
-#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
+#define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
+#define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
+#define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
+#define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
+
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
+#define XFS_DIFLAG2_METADIR	(1ULL << XFS_DIFLAG2_METADIR_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADIR)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 19d26950db9..b63aacb6971 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -222,6 +222,8 @@ xfs_inode_inherit_flags2(
 	}
 	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+	if (pip->i_diflags2 & XFS_DIFLAG2_METADIR)
+		ip->i_diflags2 |= XFS_DIFLAG2_METADIR;
 
 	/* Don't let invalid cowextsize hints propagate. */
 	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d150170d87b..49d62281995 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -176,6 +176,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NREXT64;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
 		features |= XFS_FEAT_PARENT;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+		features |= XFS_FEAT_METADIR;
 
 	return features;
 }

