Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B4C8C04
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371345; cv=none; b=X0sqoyFujy0Hzg6osquhio9kl2/CW1rfNFIqRi5krkA9T+lmHbGNlQsbXnp+1cWbZA9QsA9g0FLjnHXFVJV5RmAe0yiEpFXzefkMPHKVS6EEGqvAMC9TzudPAJu1KgrMSSv4HUMaU2upyWHAS4/S6Q9pyBpNQuHy281S9r3Tv8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371345; c=relaxed/simple;
	bh=M/zF+5nm1t1x7JIU5patLlQIPeh/hxRq7fx0sZBmUxA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Is+KuGgZF3ZbC2HLvsHVehClhcQ/jH/QiMQJt/D6/YnJ5ja2DV47V1zdGPp9S1YV0svGGN9sxvU1rdQkNmJYKkpO65xHctjMRdshwqH60vvMBTvjY/1edonpWBnsef2bzsv2+m2Tvr8yE208ZDWVuMcZKTDRo4Ct+m8JOI1/fso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hOQNoDhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hOQNoDhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A9FC32782;
	Fri, 23 Aug 2024 00:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371345;
	bh=M/zF+5nm1t1x7JIU5patLlQIPeh/hxRq7fx0sZBmUxA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hOQNoDhceJ7uAwvPd0+I5AJ14sttGMPYtdyJcERpjW6/fd+6NII4J/rgDIBrcYxOS
	 zpQiA9YReqFtuhP5HP1hb53evuKrzCX0s6G1p1SJ8QDq7eU3PSsLMjhoiYRXnaaZ2X
	 mVzT7swfVUnxwJunef3xUjZdQ1+CoyIedaxPcTzsINCbWMMn3PVI4nqfKAWL28Mwch
	 0d5Csw4sMiSdATXOjSEN1Py5TaYPH3U5fwfU4m4jQSczIfTgca5Wk0uVxsGEoErHs/
	 mEd8EJ4PIaEqIG5TxPaC83ad1oTtIc5a8vNLI4vhM8odJ2nFxaVhFf9EsUtWQEfR0R
	 O+yPB7giIGa0A==
Date: Thu, 22 Aug 2024 17:02:25 -0700
Subject: [PATCH 01/26] xfs: define the on-disk format for the metadir feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085186.57482.15004588749775866677.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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
directory feature.  Add a xfs_sb_version_hasmetadir for benefit of
xfs_repair, which needs to know where the new end of the superblock
lies.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h      |   81 +++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_inode_buf.c   |   13 +++++-
 fs/xfs/libxfs/xfs_inode_util.c  |    2 +
 fs/xfs/libxfs/xfs_log_format.h  |    2 -
 fs/xfs/libxfs/xfs_ondisk.h      |    2 -
 fs/xfs/libxfs/xfs_sb.c          |   10 +++++
 fs/xfs/scrub/inode.c            |    3 +
 fs/xfs/scrub/inode_repair.c     |    9 +++-
 fs/xfs/xfs_inode.h              |   14 +++++++
 fs/xfs/xfs_inode_item.c         |    7 +++
 fs/xfs/xfs_inode_item_recover.c |    5 ++
 fs/xfs/xfs_mount.h              |    2 +
 fs/xfs/xfs_super.c              |    4 ++
 13 files changed, 136 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e1bfee0c3b1a8..16a7bc02aa5f5 100644
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
@@ -426,6 +431,12 @@ static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
 		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
 }
 
+static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
+}
+
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 {
@@ -790,6 +801,27 @@ static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
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
@@ -812,7 +844,10 @@ struct xfs_dinode {
 	__be16		di_mode;	/* mode and type of file */
 	__u8		di_version;	/* inode version */
 	__u8		di_format;	/* format of di_c data */
-	__be16		di_onlink;	/* old number of links to file */
+	union {
+		__be16	di_onlink;	/* old number of links to file */
+		__be16	di_metatype;	/* XFS_METAFILE_* */
+	} __packed; /* explicit packing because arm gcc bloats this up */
 	__be32		di_uid;		/* owner's user id */
 	__be32		di_gid;		/* owner's group id */
 	__be32		di_nlink;	/* number of links to file */
@@ -1092,17 +1127,47 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
-#define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
+#define XFS_DIFLAG2_NREXT64_BIT	4	/* large extent counters */
+#define XFS_DIFLAG2_METADATA_BIT	63	/* filesystem metadata */
 
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
+#define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 79babeac9d754..cdd6ed4279649 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -215,6 +215,8 @@ xfs_inode_from_disk(
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
 		ip->i_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
 					be16_to_cpu(from->di_projid_lo);
+		if (from->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))
+			ip->i_metatype = be16_to_cpu(from->di_metatype);
 	}
 
 	i_uid_write(inode, be32_to_cpu(from->di_uid));
@@ -315,7 +317,10 @@ xfs_inode_to_disk(
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
-	to->di_onlink = 0;
+	if (xfs_is_metadir_inode(ip))
+		to->di_metatype = cpu_to_be16(ip->i_metatype);
+	else
+		to->di_onlink = 0;
 
 	to->di_format = xfs_ifork_format(&ip->i_df);
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
@@ -523,9 +528,13 @@ xfs_dinode_verify(
 	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
 	 * di_onlink==0, so we can check that.
 	 */
-	if (dip->di_version >= 2) {
+	if (dip->di_version == 2) {
 		if (dip->di_onlink)
 			return __this_address;
+	} else if (dip->di_version >= 3) {
+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
+		    dip->di_onlink)
+			return __this_address;
 	}
 
 	/* don't allow invalid i_size */
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 032333289113b..34c1b998b6c9a 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -224,6 +224,8 @@ xfs_inode_inherit_flags2(
 	}
 	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+	if (pip->i_diflags2 & XFS_DIFLAG2_METADATA)
+		ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
 
 	/* Don't let invalid cowextsize hints propagate. */
 	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 3e6682ed656b3..ace7384a275bf 100644
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
index 23c133fd36f5b..8bca86e350fdc 100644
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
index 6b56f0f6d4c1a..7afde477c0a79 100644
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
@@ -683,6 +685,11 @@ __xfs_sb_from_disk(
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
@@ -830,6 +837,9 @@ xfs_sb_to_disk(
 	to->sb_lsn = cpu_to_be64(from->sb_lsn);
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
 }
 
 /*
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index d32716fb2fecf..ec2c694c4083f 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -421,7 +421,8 @@ xchk_dinode(
 		break;
 	case 2:
 	case 3:
-		if (dip->di_onlink != 0)
+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
+		    dip->di_onlink != 0)
 			xchk_ino_set_corrupt(sc, ino);
 
 		if (dip->di_mode == 0 && sc->ip)
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index daf9f1ee7c2cb..344fdffb19aba 100644
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
+	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+		dip->di_onlink = 0;
 }
 
 /* Fix any conflicting flags that the verifiers complain about. */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1908409968dba..54d995740b328 100644
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
@@ -276,10 +277,23 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
 }
 
+static inline bool xfs_is_metadir_inode(const struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
+}
+
 static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)
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
index b509cbd191f4e..912f0b1bc3cb7 100644
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
index dbdab4ce7c44c..4034933386807 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -175,7 +175,10 @@ xfs_log_dinode_to_disk(
 	to->di_mode = cpu_to_be16(from->di_mode);
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_onlink = 0;
+	if (from->di_flags2 & XFS_DIFLAG2_METADATA)
+		to->di_metatype = cpu_to_be16(from->di_metatype);
+	else
+		to->di_onlink = 0;
 	to->di_uid = cpu_to_be32(from->di_uid);
 	to->di_gid = cpu_to_be32(from->di_gid);
 	to->di_nlink = cpu_to_be32(from->di_nlink);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d0567dfbc0368..d404ce122f238 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -299,6 +299,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
+#define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -354,6 +355,7 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
+__XFS_HAS_FEAT(metadir, METADIR)
 
 /*
  * Some features are always on for v5 file systems, allow the compiler to
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 27e9f749c4c7f..34066b50585e8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1721,6 +1721,10 @@ xfs_fs_fill_super(
 		mp->m_features &= ~XFS_FEAT_DISCARD;
 	}
 
+	if (xfs_has_metadir(mp))
+		xfs_warn(mp,
+"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
+
 	if (xfs_has_reflink(mp)) {
 		if (mp->m_sb.sb_rblocks) {
 			xfs_alert(mp,

