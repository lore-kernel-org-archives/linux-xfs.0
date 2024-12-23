Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823831D5CDD
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990250; cv=none; b=QSkcx6kOD45tlyLG8Z1RB+cYTwQAa7Z/z0UMrS/2WHNBT+xxEju4+8jhD4KXnct4PxFwnAnhUJboLo+ILiG2JQTHEriLb6qUtTCO4ZPHh2Ubt4BIqZDnXy1boCJFp3qqWpsuSyu3bAUoL3cuT2SiNg05fd5KLxiMdTiQ4eIoDbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990250; c=relaxed/simple;
	bh=s2fbnKYlB35dyeIdOTV//6Er05E0EhaOSUx2RbTbvLs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RjZVwQiv42j39gfs26tWNSptKtdkbPmJvV93uRbReOqgsNgvRr2YKK9JuAo/Osl+pOXE40M5V+q8euiZ89WuttvhxPN7NYwd+Jb7CqJdJvOIXh8gczm3jtIV/3xNLiCbd7H1RJooQvavBkaCsXzlqy7EPB/zL1GJMOHPWvvCI44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YRAY5g+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YRAY5g+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0389CC4CED3;
	Mon, 23 Dec 2024 21:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990250;
	bh=s2fbnKYlB35dyeIdOTV//6Er05E0EhaOSUx2RbTbvLs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YRAY5g+JfUhkxqjq9mdvjMI1QiNOQE4eEBKKwSzXe3jkm8XoMXdo9uZt5J4bQh3W7
	 vQXyky9Vz7cG9N4SEF3UigLSnzm7vXZWZcW6jEPVrUOeDbLlCTStgfMiw6Pe+y+/FR
	 F6F6q95ih2Pc34tWF8byDBPqvatUOcJkjiSjIvTaZpiL4epIwV/ahKV8Stef8w+fwX
	 jsB14juZscjPv4FOITeFwUvyHkLZZz1CKPJDp13BFDUesjp3Cc3jx206qDjY0Nh85x
	 dZo7xb9TZQDmLgwa1CXUZQmZLWApnSwlJOBR/PFErjpQYEm2j/jYnCgZmV0uMIu461
	 8LdxNZohQIn4w==
Date: Mon, 23 Dec 2024 13:44:09 -0800
Subject: [PATCH 27/36] xfs: define the on-disk format for the metadir feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940355.2293042.14946778770633292353.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4f3d4dd1b04b2ba0bf236fbaa3c3c0c669aa5a47

Define the on-disk layout and feature flags for the metadata inode
directory feature.  Add a xfs_sb_version_hasmetadir for benefit of
xfs_repair, which needs to know where the new end of the superblock
lies.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c              |    2 -
 db/inode.c              |    4 +-
 include/xfs_inode.h     |    6 +++
 include/xfs_mount.h     |    2 +
 libxfs/xfs_format.h     |   97 +++++++++++++++++++++++++++++++++++++++++------
 libxfs/xfs_inode_buf.c  |   20 +++++++---
 libxfs/xfs_inode_util.c |    2 +
 libxfs/xfs_log_format.h |    2 -
 libxfs/xfs_ondisk.h     |    2 -
 libxfs/xfs_sb.c         |   10 +++++
 repair/dino_chunks.c    |    2 -
 repair/dinode.c         |   12 +++---
 12 files changed, 132 insertions(+), 29 deletions(-)


diff --git a/db/check.c b/db/check.c
index 0a6e5c3280e1cf..fb7b6cb41a3fbf 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2823,7 +2823,7 @@ process_inode(
 		return;
 	}
 	if (dip->di_version == 1) {
-		nlink = be16_to_cpu(dip->di_onlink);
+		nlink = be16_to_cpu(dip->di_metatype);
 		prid = 0;
 	} else {
 		nlink = be32_to_cpu(dip->di_nlink);
diff --git a/db/inode.c b/db/inode.c
index 7a5f5a0cb987aa..246febb5929aa1 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -90,9 +90,9 @@ const field_t	inode_core_flds[] = {
 	{ "mode", FLDT_UINT16O, OI(COFF(mode)), C1, 0, TYP_NONE },
 	{ "version", FLDT_INT8D, OI(COFF(version)), C1, 0, TYP_NONE },
 	{ "format", FLDT_DINODE_FMT, OI(COFF(format)), C1, 0, TYP_NONE },
-	{ "nlinkv1", FLDT_UINT16D, OI(COFF(onlink)), inode_core_nlinkv1_count,
+	{ "nlinkv1", FLDT_UINT16D, OI(COFF(metatype)), inode_core_nlinkv1_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "onlink", FLDT_UINT16D, OI(COFF(onlink)), inode_core_onlink_count,
+	{ "onlink", FLDT_UINT16D, OI(COFF(metatype)), inode_core_onlink_count,
 	  FLD_COUNT, TYP_NONE },
 	{ "uid", FLDT_UINT32D, OI(COFF(uid)), C1, 0, TYP_NONE },
 	{ "gid", FLDT_UINT32D, OI(COFF(gid)), C1, 0, TYP_NONE },
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index f250102ff19d65..e03521bc9aaaa2 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -230,6 +230,7 @@ typedef struct xfs_inode {
 		uint16_t	i_flushiter;	/* incremented on flush */
 	};
 	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
+	enum xfs_metafile_type	i_metatype;	/* XFS_METAFILE_* */
 	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
@@ -396,6 +397,11 @@ static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
 	return false;
 }
 
+static inline bool xfs_is_metadir_inode(const struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
+}
+
 extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
 				struct xfs_buf *);
 
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 1179a80d9df94e..c7fada9e2a6d70 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -201,6 +201,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
+#define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -246,6 +247,7 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
+__XFS_HAS_FEAT(metadir, METADIR)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index a24ab46aaebc7e..616f81045921b7 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -174,6 +174,8 @@ typedef struct xfs_sb {
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
+	xfs_ino_t	sb_metadirino;	/* metadata directory tree root */
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
@@ -259,6 +261,8 @@ struct xfs_dsb {
 	__be64		sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
+	__be64		sb_metadirino;	/* metadata directory tree root */
+
 	/* must be padded to 64 bit alignment */
 };
 
@@ -374,6 +378,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)  /* large extent counters */
 #define XFS_SB_FEAT_INCOMPAT_EXCHRANGE	(1 << 6)  /* exchangerange supported */
 #define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 7)  /* parent pointers */
+#define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 8)  /* metadata dir tree */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
 		 XFS_SB_FEAT_INCOMPAT_SPINODES | \
@@ -790,6 +795,27 @@ static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
 	return (time64_t)ondisk_seconds - XFS_BIGTIME_EPOCH_OFFSET;
 }
 
+enum xfs_metafile_type {
+	XFS_METAFILE_UNKNOWN,		/* unknown */
+	XFS_METAFILE_DIR,		/* metadir directory */
+	XFS_METAFILE_USRQUOTA,		/* user quota */
+	XFS_METAFILE_GRPQUOTA,		/* group quota */
+	XFS_METAFILE_PRJQUOTA,		/* project quota */
+	XFS_METAFILE_RTBITMAP,		/* rt bitmap */
+	XFS_METAFILE_RTSUMMARY,		/* rt summary */
+
+	XFS_METAFILE_MAX
+} __packed;
+
+#define XFS_METAFILE_TYPE_STR \
+	{ XFS_METAFILE_UNKNOWN,		"unknown" }, \
+	{ XFS_METAFILE_DIR,		"dir" }, \
+	{ XFS_METAFILE_USRQUOTA,	"usrquota" }, \
+	{ XFS_METAFILE_GRPQUOTA,	"grpquota" }, \
+	{ XFS_METAFILE_PRJQUOTA,	"prjquota" }, \
+	{ XFS_METAFILE_RTBITMAP,	"rtbitmap" }, \
+	{ XFS_METAFILE_RTSUMMARY,	"rtsummary" }
+
 /*
  * On-disk inode structure.
  *
@@ -812,7 +838,7 @@ struct xfs_dinode {
 	__be16		di_mode;	/* mode and type of file */
 	__u8		di_version;	/* inode version */
 	__u8		di_format;	/* format of di_c data */
-	__be16		di_onlink;	/* old number of links to file */
+	__be16		di_metatype;	/* XFS_METAFILE_*; was di_onlink */
 	__be32		di_uid;		/* owner's user id */
 	__be32		di_gid;		/* owner's group id */
 	__be32		di_nlink;	/* number of links to file */
@@ -1088,21 +1114,60 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * Values for di_flags2 These start by being exposed to userspace in the upper
  * 16 bits of the XFS_XFLAG_s range.
  */
-#define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
-#define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
-#define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
-#define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
-#define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
-
-#define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
-#define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
-#define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
-#define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
-#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
+/* use DAX for this inode */
+#define XFS_DIFLAG2_DAX_BIT		0
+
+/* file's blocks may be shared */
+#define XFS_DIFLAG2_REFLINK_BIT		1
+
+/* copy on write extent size hint */
+#define XFS_DIFLAG2_COWEXTSIZE_BIT	2
+
+/* big timestamps */
+#define XFS_DIFLAG2_BIGTIME_BIT		3
+
+/* large extent counters */
+#define XFS_DIFLAG2_NREXT64_BIT		4
+
+/*
+ * The inode contains filesystem metadata and can be found through the metadata
+ * directory tree.  Metadata inodes must satisfy the following constraints:
+ *
+ * - V5 filesystem (and ftype) are enabled;
+ * - The only valid modes are regular files and directories;
+ * - The access bits must be zero;
+ * - DMAPI event and state masks are zero;
+ * - The user and group IDs must be zero;
+ * - The project ID can be used as a u32 annotation;
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
+ *
+ * Superblock-rooted metadata files must have the METADATA iflag set even
+ * though they do not have a parent directory.
+ */
+#define XFS_DIFLAG2_METADATA_BIT	5
+
+#define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
+#define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
+#define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
+#define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
+#define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1117,6 +1182,12 @@ static inline bool xfs_dinode_has_large_extent_counts(
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
 }
 
+static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 5970ee705bc5a2..981113f6acd37a 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -206,12 +206,15 @@ xfs_inode_from_disk(
 	 * They will also be unconditionally written back to disk as v2 inodes.
 	 */
 	if (unlikely(from->di_version == 1)) {
-		set_nlink(inode, be16_to_cpu(from->di_onlink));
+		/* di_metatype used to be di_onlink */
+		set_nlink(inode, be16_to_cpu(from->di_metatype));
 		ip->i_projid = 0;
 	} else {
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
 		ip->i_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
 					be16_to_cpu(from->di_projid_lo);
+		if (xfs_dinode_is_metadir(from))
+			ip->i_metatype = be16_to_cpu(from->di_metatype);
 	}
 
 	i_uid_write(inode, be32_to_cpu(from->di_uid));
@@ -312,7 +315,10 @@ xfs_inode_to_disk(
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
-	to->di_onlink = 0;
+	if (xfs_is_metadir_inode(ip))
+		to->di_metatype = cpu_to_be16(ip->i_metatype);
+	else
+		to->di_metatype = 0;
 
 	to->di_format = xfs_ifork_format(&ip->i_df);
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
@@ -520,8 +526,11 @@ xfs_dinode_verify(
 	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
 	 * di_onlink==0, so we can check that.
 	 */
-	if (dip->di_version >= 2) {
-		if (dip->di_onlink)
+	if (dip->di_version == 2) {
+		if (dip->di_metatype)
+			return __this_address;
+	} else if (dip->di_version >= 3) {
+		if (!xfs_dinode_is_metadir(dip) && dip->di_metatype)
 			return __this_address;
 	}
 
@@ -543,7 +552,8 @@ xfs_dinode_verify(
 			if (dip->di_nlink)
 				return __this_address;
 		} else {
-			if (dip->di_onlink)
+			/* di_metatype used to be di_onlink */
+			if (dip->di_metatype)
 				return __this_address;
 		}
 	}
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index f9f16c7e2d0788..edc985eb9a4e45 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -221,6 +221,8 @@ xfs_inode_inherit_flags2(
 	}
 	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+	if (xfs_is_metadir_inode(pip))
+		ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
 
 	/* Don't let invalid cowextsize hints propagate. */
 	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 3e6682ed656b30..ace7384a275bfb 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -404,7 +404,7 @@ struct xfs_log_dinode {
 	uint16_t	di_mode;	/* mode and type of file */
 	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
-	uint8_t		di_pad3[2];	/* unused in v2/3 inodes */
+	uint16_t	di_metatype;	/* metadata type, if DIFLAG2_METADATA */
 	uint32_t	di_uid;		/* owner's user id */
 	uint32_t	di_gid;		/* owner's group id */
 	uint32_t	di_nlink;	/* number of links to file */
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 23c133fd36f5bb..8bca86e350fdc1 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -37,7 +37,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			272);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 9120a3377735b0..de12edd8192e1c 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -177,6 +177,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_EXCHANGE_RANGE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
 		features |= XFS_FEAT_PARENT;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+		features |= XFS_FEAT_METADIR;
 
 	return features;
 }
@@ -700,6 +702,11 @@ __xfs_sb_from_disk(
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
+
+	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
+	else
+		to->sb_metadirino = NULLFSINO;
 }
 
 void
@@ -847,6 +854,9 @@ xfs_sb_to_disk(
 	to->sb_lsn = cpu_to_be64(from->sb_lsn);
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
 }
 
 /*
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 86e29dd9ae05eb..49d57948c7eca8 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -896,7 +896,7 @@ process_inode_chunk(
 			set_inode_disk_nlinks(ino_rec, irec_offset,
 				dino->di_version > 1
 					? be32_to_cpu(dino->di_nlink)
-					: be16_to_cpu(dino->di_onlink));
+					: be16_to_cpu(dino->di_metatype));
 
 		} else  {
 			set_inode_free(ino_rec, irec_offset);
diff --git a/repair/dinode.c b/repair/dinode.c
index 2c9d9acfa10be5..e217e037f8862d 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2231,20 +2231,22 @@ process_check_inode_nlink_version(
 	int			dirty = 0;
 
 	/*
-	 * if it's a version 2 inode, it should have a zero
+	 * if it's a version 2 non-metadir inode, it should have a zero
 	 * onlink field, so clear it.
 	 */
-	if (dino->di_version > 1 && dino->di_onlink != 0) {
+	if (dino->di_version > 1 &&
+	    !(dino->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
+	    dino->di_metatype != 0) {
 		if (!no_modify) {
 			do_warn(
 _("clearing obsolete nlink field in version 2 inode %" PRIu64 ", was %d, now 0\n"),
-				lino, be16_to_cpu(dino->di_onlink));
-			dino->di_onlink = 0;
+				lino, be16_to_cpu(dino->di_metatype));
+			dino->di_metatype = 0;
 			dirty = 1;
 		} else  {
 			do_warn(
 _("would clear obsolete nlink field in version 2 inode %" PRIu64 ", currently %d\n"),
-				lino, be16_to_cpu(dino->di_onlink));
+				lino, be16_to_cpu(dino->di_metatype));
 		}
 	}
 	return dirty;

