Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E5C126
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AyyCl1mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FA6C433C8;
	Sun, 31 Dec 2023 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060185;
	bh=gXHYBqcrlUs6XYr8FRT+8+vuAktuXjeFXs7pyIn9/hw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AyyCl1mBiLRmGRsiqw6vdnQHOu6izMAqCrm6oJt+utQmMe6MzFA196v9eIdzgsuRg
	 7gx5DdUEcJKXQwmw+hJ7nkQQbwvOFaXEyWGImrAI3QdU9W7zA5PbJM3uvSFJ3zpGNv
	 /IUyaPOiOTBJ2qXQEjlRDiF3kU1cvqZnOszyE/j0NnqDVY+ZliAOC4lJBf9wPv90rX
	 ln1dOGDKbShXLcdIbREGByR9GUhuB5dbDLamV7u0DtqYs2AlmAXljwajBKh0dld5HB
	 N99dYOrQ0j0XdT+6+0yyukTJEefLpbl95NJ1K4T4MZnRZJCoE+eQkaiFEAm1OQUJrs
	 jkhd2gdD9qkow==
Date: Sun, 31 Dec 2023 14:03:05 -0800
Subject: [PATCH 1/4] xfs: create a new inode flag to require extsize alignment
 of file data space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Message-ID: <170404855911.1770028.15509042757140324952.stgit@frogsfrogsfrogs>
In-Reply-To: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
References: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
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

Add a new inode flag to require that all file data extent mappings must
be aligned (both the file offset range and the allocated space itself)
to the extent size hint.  Having a separate COW extent size hint is no
longer allowed.

The goal here is to enable sysadmins and users to mandate that all space
mappings in a file must have a startoff/blockcount that are aligned to
(say) a 2MB alignment and that the startblock/blockcount will follow the
same alignment.

Co-developed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     |   16 ++++++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c  |   36 +++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.h  |    3 +++
 fs/xfs/libxfs/xfs_inode_util.c |   14 ++++++++++++++
 fs/xfs/libxfs/xfs_sb.c         |   30 +++++++++++++++++++++++++++++
 fs/xfs/scrub/inode_repair.c    |   41 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h           |    1 +
 fs/xfs/xfs_inode.h             |    5 +++++
 fs/xfs/xfs_ioctl.c             |   14 ++++++++++++++
 fs/xfs/xfs_mount.h             |    2 ++
 fs/xfs/xfs_rtalloc.c           |    4 ++++
 fs/xfs/xfs_super.c             |    4 ++++
 include/uapi/linux/fs.h        |    2 ++
 13 files changed, 170 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ca964befb51cf..a0f5bae450135 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -103,7 +103,12 @@ typedef struct xfs_sb {
 	xfs_ino_t	sb_rootino;	/* root inode number */
 	xfs_ino_t	sb_rbmino;	/* bitmap inode for realtime extents */
 	xfs_ino_t	sb_rsumino;	/* summary inode for rt bitmap */
-	xfs_agblock_t	sb_rextsize;	/* realtime extent size, blocks */
+	/*
+	 * Realtime extent size, blocks.  If the FORCEALIGN feature is set,
+	 * the allocation group size must be a multiple of this value, and
+	 * file data allocations will be aligned to this value.
+	 */
+	xfs_agblock_t	sb_rextsize;
 	xfs_agblock_t	sb_agblocks;	/* size of an allocation group */
 	xfs_agnumber_t	sb_agcount;	/* number of allocation groups */
 	xfs_extlen_t	sb_rbmblocks;	/* number of rt bitmap blocks */
@@ -387,6 +392,8 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+/* all AGs and data allocations must be aligned to rextsize, even for !rt files */
+#define XFS_SB_FEAT_RO_COMPAT_FORCEALIGN (1 << 30)
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
@@ -1206,6 +1213,8 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
 #define XFS_DIFLAG2_NREXT64_BIT	4	/* large extent counters */
+/* data extent mappings for regular files must be aligned to extent size hint */
+#define XFS_DIFLAG2_FORCEALIGN_BIT 5
 #define XFS_DIFLAG2_METADIR_BIT	63	/* filesystem metadata */
 
 #define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
@@ -1239,9 +1248,12 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DIFLAG2_METADIR	(1ULL << XFS_DIFLAG2_METADIR_BIT)
 
+#define XFS_DIFLAG2_FORCEALIGN	(1ULL << XFS_DIFLAG2_FORCEALIGN_BIT)
+
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADIR)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADIR | \
+	 XFS_DIFLAG2_FORCEALIGN)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index adc457da52ef0..b2ad88f7d63f3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -726,6 +726,14 @@ xfs_dinode_verify(
 	} else if (nextents + naextents == 0 && nblocks != 0)
 		return __this_address;
 
+	if (flags2 & XFS_DIFLAG2_FORCEALIGN) {
+		fa = xfs_inode_validate_forcealign(mp, mode, flags,
+				be32_to_cpu(dip->di_extsize),
+				be32_to_cpu(dip->di_cowextsize));
+		if (fa)
+			return fa;
+	}
+
 	return NULL;
 }
 
@@ -900,3 +908,31 @@ xfs_inode_validate_cowextsize(
 
 	return NULL;
 }
+
+/* Validate the forcealign inode flag */
+xfs_failaddr_t
+xfs_inode_validate_forcealign(
+	struct xfs_mount	*mp,
+	uint16_t		mode,
+	uint16_t		flags,
+	uint32_t		extsize,
+	uint32_t		cowextsize)
+{
+	/* superblock rocompat feature flag required */
+	if (!xfs_has_forcealign(mp))
+		return __this_address;
+
+	/* Only regular files and directories */
+	if (!S_ISDIR(mode) && !S_ISREG(mode))
+		return __this_address;
+
+	/* Requires no extent size hint */
+	if (extsize != 0)
+		return __this_address;
+
+	/* Requires no cow extent size hint */
+	if (cowextsize != 0)
+		return __this_address;
+
+	return NULL;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 8d43d2641c732..68526de991cc6 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -36,6 +36,9 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
+xfs_failaddr_t xfs_inode_validate_forcealign(struct xfs_mount *mp,
+		uint16_t mode, uint16_t flags, uint32_t extsize,
+		uint32_t cowextsize);
 
 static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
 {
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 7833530102d1c..7e92c5fe35c78 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -81,6 +81,8 @@ xfs_flags2diflags2(
 		di_flags2 |= XFS_DIFLAG2_DAX;
 	if (xflags & FS_XFLAG_COWEXTSIZE)
 		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+	if (xflags & FS_XFLAG_FORCEALIGN)
+		di_flags2 |= XFS_DIFLAG2_FORCEALIGN;
 
 	return di_flags2;
 }
@@ -127,6 +129,8 @@ xfs_ip2xflags(
 			flags |= FS_XFLAG_DAX;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
+		if (ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN)
+			flags |= FS_XFLAG_FORCEALIGN;
 	}
 
 	if (xfs_inode_has_attr_fork(ip))
@@ -228,6 +232,8 @@ xfs_inode_inherit_flags2(
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
 	if (pip->i_diflags2 & XFS_DIFLAG2_METADIR)
 		ip->i_diflags2 |= XFS_DIFLAG2_METADIR;
+	if (pip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN)
+		ip->i_diflags2 |= XFS_DIFLAG2_FORCEALIGN;
 
 	/* Don't let invalid cowextsize hints propagate. */
 	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
@@ -236,6 +242,14 @@ xfs_inode_inherit_flags2(
 		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 		ip->i_cowextsize = 0;
 	}
+
+	if (ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN) {
+		failaddr = xfs_inode_validate_forcealign(ip->i_mount,
+				VFS_I(ip)->i_mode, ip->i_diflags, ip->i_extsize,
+				ip->i_cowextsize);
+		if (failaddr)
+			ip->i_diflags2 &= ~XFS_DIFLAG2_FORCEALIGN;
+	}
 }
 
 /* Initialise an inode's attributes. */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b75a5bcbdf19e..8b7f8023d9bf7 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -167,6 +167,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_REFLINK;
 	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
 		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FORCEALIGN)
+		features |= XFS_FEAT_FORCEALIGN;
+
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
 		features |= XFS_FEAT_FTYPE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
@@ -370,6 +373,27 @@ xfs_validate_sb_rtgroups(
 	return 0;
 }
 
+static int
+xfs_validate_sb_forcealign(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	if (sbp->sb_rextsize == 0) {
+		xfs_warn(mp,
+ "Cannot have forced allocation alignment of zero.");
+		return -EINVAL;
+	}
+
+	if (sbp->sb_agblocks % sbp->sb_rextsize != 0) {
+		xfs_warn(mp,
+ "Allocation group size %u not aligned to forcealign %u.",
+				sbp->sb_agblocks, sbp->sb_rextsize);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Check the validity of the SB. */
 STATIC int
 xfs_validate_sb_common(
@@ -437,6 +461,12 @@ xfs_validate_sb_common(
 			if (error)
 				return error;
 		}
+
+		if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FORCEALIGN) {
+			error = xfs_validate_sb_forcealign(mp, sbp);
+			if (error)
+				return error;
+		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a182a9551c08c..5dd46565d82e8 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -666,6 +666,46 @@ xrep_dinode_extsize_hints(
 	}
 }
 
+/* Fix forcealign flag. */
+STATIC void
+xrep_dinode_forcealign(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	uint64_t		flags2;
+	uint16_t		flags;
+	uint16_t		mode;
+
+	trace_xrep_dinode_forcealign(sc, dip);
+
+	if (dip->di_version < 3)
+		return;
+
+	mode = be16_to_cpu(dip->di_mode);
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+
+	if (!(flags2 & XFS_DIFLAG2_FORCEALIGN))
+		return;
+
+	if (!xfs_has_forcealign(sc->mp))
+		flags2 &= ~XFS_DIFLAG2_FORCEALIGN;
+
+	if (!S_ISDIR(mode) && !S_ISREG(mode))
+		flags2 &= ~XFS_DIFLAG2_FORCEALIGN;
+
+	if (flags & XFS_DIFLAG_REALTIME)
+		flags2 &= ~XFS_DIFLAG2_FORCEALIGN;
+
+	if (dip->di_extsize != 0)
+		flags2 &= ~XFS_DIFLAG2_FORCEALIGN;
+
+	if (dip->di_cowextsize != 0)
+		flags2 &= ~XFS_DIFLAG2_FORCEALIGN;
+
+	dip->di_flags2 = cpu_to_be64(flags2);
+}
+
 /* Count extents and blocks for an inode given an rmap. */
 STATIC int
 xrep_dinode_walk_rmap(
@@ -1506,6 +1546,7 @@ xrep_dinode_core(
 	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(ri, dip);
 	xrep_dinode_extsize_hints(sc, dip);
+	xrep_dinode_forcealign(sc, dip);
 	xrep_dinode_zap_forks(ri, dip);
 
 write:
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cfd882edb2937..6e15de56be2b7 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2559,6 +2559,7 @@ DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_forks);
 DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_dfork);
 DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_afork);
 DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_ensure_forkoff);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_forcealign);
 
 DECLARE_EVENT_CLASS(xrep_inode_class,
 	TP_PROTO(struct xfs_scrub *sc),
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2779a353b4618..ea311b1fa616b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -326,6 +326,11 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+static inline bool xfs_inode_force_align(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN;
+}
+
 static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
 {
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ad289d37145e8..71f7503f75a7e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1144,6 +1144,20 @@ xfs_ioctl_setattr_xflags(
 	if (i_flags2 && !xfs_has_v3inodes(mp))
 		return -EINVAL;
 
+	/*
+	 * Force-align requires a zero extent size hint and a zero cow extent
+	 * size hint.
+	 */
+	if (fa->fsx_xflags & FS_XFLAG_FORCEALIGN) {
+		if (!xfs_has_forcealign(mp))
+			return -EINVAL;
+		if (fa->fsx_xflags & FS_XFLAG_COWEXTSIZE)
+			return -EINVAL;
+		if (fa->fsx_xflags & (FS_XFLAG_EXTSIZE |
+				      FS_XFLAG_EXTSZINHERIT))
+			return -EINVAL;
+	}
+
 	ip->i_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
 	ip->i_diflags2 = i_flags2;
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1c99d0630364f..964560a471538 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -310,6 +310,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
 #define XFS_FEAT_RTGROUPS	(1ULL << 28)	/* realtime groups */
+#define XFS_FEAT_FORCEALIGN	(1ULL << 29)	/* aligned file data extents */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -375,6 +376,7 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(rtgroups, RTGROUPS)
+__XFS_HAS_FEAT(forcealign, FORCEALIGN)
 
 static inline bool xfs_has_rtrmapbt(struct xfs_mount *mp)
 {
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e59189e84943c..3e4fcfe2776d3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1238,6 +1238,10 @@ xfs_growfs_rt(
 	if (sbp->sb_rblocks > 0 && in->extsize != sbp->sb_rextsize)
 		return -EINVAL;
 
+	/* Cannot change rt extent size when forcealign is set. */
+	if (xfs_has_forcealign(mp) && in->extsize != sbp->sb_rextsize)
+		return -EINVAL;
+
 	/* Range check the extent size. */
 	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
 	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8f06716dd0169..9b478e81f3d38 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1727,6 +1727,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 "EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!");
 
+	if (xfs_has_forcealign(mp))
+		xfs_warn(mp,
+"EXPERIMENTAL forced data extent alignment feature in use. Use at your own risk!");
+
 	if (xfs_has_reflink(mp)) {
 		/*
 		 * Reflink doesn't support pagecache pages that span multiple
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index da43810b74856..be458e69a140b 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -140,6 +140,8 @@ struct fsxattr {
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+/* data extent mappings for regular files must be aligned to extent size hint */
+#define FS_XFLAG_FORCEALIGN	0x00020000
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is

