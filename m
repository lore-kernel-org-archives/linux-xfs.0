Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EB41DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845076; cv=none; b=lp+6UCKC98sLnvv66vkge43a1YyIMPeIqdUW4D92xbogVqupD5jCgoMDVPLHhROfxBqlaumldU1YR+WfPKLxByOtIZp/WYIMocVmx50dNUYHpgRHrCtHB4Y2mLFMq/RVTrqoghRxa/Pk75fLRbVD4ByiXseaW7WkfCBwBAbOyYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845076; c=relaxed/simple;
	bh=t1EzvcaCHvcvbSUtZKk9J3Q+wqiFiEh4onnvI5BrnL8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJzK7gGTi6FgO+gtJEdH9TNL8IHjHKOQqWvz7ON4w1pTUEP32SCq47/sD6WwfVjlZ07KjVAEiPcT/wKcWstJTSw42YrR9uNHuj12xgmApnGyNlM0jBw4j9X1NspE/F+hacFyrFpzgxSEcZXzCUGPg1jPOc2x+UYqyHlrA1OTCBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AhP0AExx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhP0AExx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE48C4CED3;
	Tue,  5 Nov 2024 22:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845076;
	bh=t1EzvcaCHvcvbSUtZKk9J3Q+wqiFiEh4onnvI5BrnL8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AhP0AExx74Xp2iYK7MIeBen2M1nOV0OoWAZ9r9iW4TtS+qbRJnSbjaCuAKIdHKzAz
	 wfRPLjyHtkfh1F25qMrEixPrnFob4+jFho67UbcQn+dJOV1Wh/t3B0NDWfFywZWc9K
	 kyHRxRwAFDzjPU4P5UeSk3D+WzM41ufHDHj26R/DsGRvB1M7LBxXGG4CvxwvRFyqys
	 GCib9ENHOg0GQ9kjGlu3BDOzM7e8uWUjzJUdXguJ1VlbSW2yzSWcepYfH5vX7puqk8
	 h2f5/jm4hISDU4dgFkZfnyT57LLumhvS8fMm1V0F84jfjFTnSx4YhuDYmlZsJxbjCe
	 MwOSk7N/u4DMA==
Date: Tue, 05 Nov 2024 14:17:56 -0800
Subject: [PATCH 05/28] xfs: define the on-disk format for the metadir feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396105.1870066.17060031459821306584.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
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
directory feature.  Add a xfs_sb_version_hasmetadir for benefit of
xfs_repair, which needs to know where the new end of the superblock
lies.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h      |   97 ++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_inode_buf.c   |   20 ++++++--
 fs/xfs/libxfs/xfs_inode_util.c  |    2 +
 fs/xfs/libxfs/xfs_log_format.h  |    2 -
 fs/xfs/libxfs/xfs_ondisk.h      |    2 -
 fs/xfs/libxfs/xfs_sb.c          |   10 ++++
 fs/xfs/scrub/inode.c            |    2 -
 fs/xfs/scrub/inode_repair.c     |    9 ++--
 fs/xfs/xfs_inode.h              |   14 ++++++
 fs/xfs/xfs_inode_item.c         |    7 ++-
 fs/xfs/xfs_inode_item_recover.c |    2 -
 fs/xfs/xfs_message.c            |    4 ++
 fs/xfs/xfs_message.h            |    1 
 fs/xfs/xfs_mount.h              |    4 ++
 fs/xfs/xfs_super.c              |    3 +
 15 files changed, 153 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index a24ab46aaebc7e..616f81045921b7 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 79babeac9d7546..78febaa0d6923b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -209,12 +209,15 @@ xfs_inode_from_disk(
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
@@ -315,7 +318,10 @@ xfs_inode_to_disk(
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
-	to->di_onlink = 0;
+	if (xfs_is_metadir_inode(ip))
+		to->di_metatype = cpu_to_be16(ip->i_metatype);
+	else
+		to->di_metatype = 0;
 
 	to->di_format = xfs_ifork_format(&ip->i_df);
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
@@ -523,8 +529,11 @@ xfs_dinode_verify(
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
 
@@ -546,7 +555,8 @@ xfs_dinode_verify(
 			if (dip->di_nlink)
 				return __this_address;
 		} else {
-			if (dip->di_onlink)
+			/* di_metatype used to be di_onlink */
+			if (dip->di_metatype)
 				return __this_address;
 		}
 	}
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index ec64eda3bbe2e1..deb0b7c00a1ffa 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -224,6 +224,8 @@ xfs_inode_inherit_flags2(
 	}
 	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+	if (xfs_is_metadir_inode(pip))
+		ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
 
 	/* Don't let invalid cowextsize hints propagate. */
 	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 3e6682ed656b30..ace7384a275bfb 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -404,7 +404,7 @@ struct xfs_log_dinode {
 	uint16_t	di_mode;	/* mode and type of file */
 	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
-	uint8_t		di_pad3[2];	/* unused in v2/3 inodes */
+	uint16_t	di_metatype;	/* metadata type, if DIFLAG2_METADATA */
 	uint32_t	di_uid;		/* owner's user id */
 	uint32_t	di_gid;		/* owner's group id */
 	uint32_t	di_nlink;	/* number of links to file */
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 23c133fd36f5bb..8bca86e350fdc1 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -37,7 +37,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			272);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f7a07e61341ded..19fa999b4032c8 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -180,6 +180,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_EXCHANGE_RANGE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
 		features |= XFS_FEAT_PARENT;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+		features |= XFS_FEAT_METADIR;
 
 	return features;
 }
@@ -689,6 +691,11 @@ __xfs_sb_from_disk(
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
@@ -836,6 +843,9 @@ xfs_sb_to_disk(
 	to->sb_lsn = cpu_to_be64(from->sb_lsn);
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
 }
 
 /*
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 4a8637afb0e29b..a7ac7a4125ff12 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -421,7 +421,7 @@ xchk_dinode(
 		break;
 	case 2:
 	case 3:
-		if (dip->di_onlink != 0)
+		if (!xfs_dinode_is_metadir(dip) && dip->di_metatype)
 			xchk_ino_set_corrupt(sc, ino);
 
 		if (dip->di_mode == 0 && sc->ip)
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 9085d6d11aebcd..1eec5c6eb11071 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -521,10 +521,13 @@ STATIC void
 xrep_dinode_nlinks(
 	struct xfs_dinode	*dip)
 {
-	if (dip->di_version > 1)
-		dip->di_onlink = 0;
-	else
+	if (dip->di_version < 2) {
 		dip->di_nlink = 0;
+		return;
+	}
+
+	if (!xfs_dinode_is_metadir(dip))
+		dip->di_metatype = 0;
 }
 
 /* Fix any conflicting flags that the verifiers complain about. */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index df7262f4674f78..b6e959563547fd 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -65,6 +65,7 @@ typedef struct xfs_inode {
 		uint16_t	i_flushiter;	/* incremented on flush */
 	};
 	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
+	enum xfs_metafile_type	i_metatype;	/* XFS_METAFILE_* */
 	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
@@ -276,10 +277,23 @@ static inline bool xfs_is_reflink_inode(const struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
 }
 
+static inline bool xfs_is_metadir_inode(const struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
+}
+
 static inline bool xfs_is_internal_inode(const struct xfs_inode *ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
+	/* Any file in the metadata directory tree is a metadata inode. */
+	if (xfs_has_metadir(mp))
+		return xfs_is_metadir_inode(ip);
+
+	/*
+	 * Before metadata directories, the only metadata inodes were the
+	 * three quota files, the realtime bitmap, and the realtime summary.
+	 */
 	return ip->i_ino == mp->m_sb.sb_rbmino ||
 	       ip->i_ino == mp->m_sb.sb_rsumino ||
 	       xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index b509cbd191f4e6..912f0b1bc3cb70 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -556,7 +556,6 @@ xfs_inode_to_log_dinode(
 	to->di_projid_lo = ip->i_projid & 0xffff;
 	to->di_projid_hi = ip->i_projid >> 16;
 
-	memset(to->di_pad3, 0, sizeof(to->di_pad3));
 	to->di_atime = xfs_inode_to_log_dinode_ts(ip, inode_get_atime(inode));
 	to->di_mtime = xfs_inode_to_log_dinode_ts(ip, inode_get_mtime(inode));
 	to->di_ctime = xfs_inode_to_log_dinode_ts(ip, inode_get_ctime(inode));
@@ -590,10 +589,16 @@ xfs_inode_to_log_dinode(
 
 		/* dummy value for initialisation */
 		to->di_crc = 0;
+
+		if (xfs_is_metadir_inode(ip))
+			to->di_metatype = ip->i_metatype;
+		else
+			to->di_metatype = 0;
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = ip->i_flushiter;
 		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
+		to->di_metatype = 0;
 	}
 
 	xfs_inode_to_log_dinode_iext_counters(ip, to);
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index dbdab4ce7c44c4..e70d2611456bc9 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -175,7 +175,7 @@ xfs_log_dinode_to_disk(
 	to->di_mode = cpu_to_be16(from->di_mode);
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_onlink = 0;
+	to->di_metatype = cpu_to_be16(from->di_metatype);
 	to->di_uid = cpu_to_be32(from->di_uid);
 	to->di_gid = cpu_to_be32(from->di_gid);
 	to->di_nlink = cpu_to_be32(from->di_nlink);
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index c7aa16af6f0996..6ed485ff27568c 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -169,6 +169,10 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_PPTR,
 			.name		= "parent pointer",
 		},
+		[XFS_EXPERIMENTAL_METADIR] = {
+			.opstate	= XFS_OPSTATE_WARNED_METADIR,
+			.name		= "metadata directory tree",
+		},
 	};
 	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
 	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 5be8be72f225a6..7fb36ced9df747 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -98,6 +98,7 @@ enum xfs_experimental_feat {
 	XFS_EXPERIMENTAL_LBS,
 	XFS_EXPERIMENTAL_EXCHRANGE,
 	XFS_EXPERIMENTAL_PPTR,
+	XFS_EXPERIMENTAL_METADIR,
 
 	XFS_EXPERIMENTAL_MAX,
 };
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b82977f654a5e5..6aaacfc0487e90 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -332,6 +332,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
+#define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -387,6 +388,7 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
+__XFS_HAS_FEAT(metadir, METADIR)
 
 /*
  * Some features are always on for v5 file systems, allow the compiler to
@@ -487,6 +489,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_EXCHRANGE	15
 /* Kernel has logged a warning about parent pointers being used on this fs. */
 #define XFS_OPSTATE_WARNED_PPTR		16
+/* Kernel has logged a warning about metadata dirs being used on this fs. */
+#define XFS_OPSTATE_WARNED_METADIR	17
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b7091728791bf5..be493d39296005 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1731,6 +1731,9 @@ xfs_fs_fill_super(
 		mp->m_features &= ~XFS_FEAT_DISCARD;
 	}
 
+	if (xfs_has_metadir(mp))
+		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_METADIR);
+
 	if (xfs_has_reflink(mp)) {
 		if (mp->m_sb.sb_rblocks) {
 			xfs_alert(mp,

