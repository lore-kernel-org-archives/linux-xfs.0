Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76F6BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F00fmvL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E516C433C7;
	Sun, 31 Dec 2023 21:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057368;
	bh=7NthETXwYqJ3xi4zCJ2GKeS+oauegPfCKEDhRhHiLMM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F00fmvL/atVzSsfVefeQ9xzkyo6EIHeNqr03VKCLJxzGuMC9G8v6aL9tqCzWd2viJ
	 SP7vSHSsVWUMZVbbdlqGILBeMSHOxxB7cu8fUMW+ckjOtC+IgJJM7VbmpDIn7gjLfq
	 pFpKWk0JDm9bQESKKSDu0IcZaedC0KW3wVvcDrM0sSE5nZk+V6tWazbai/P6XoaKVW
	 fqRQ3qotwL2Uuz2zwAKA9JTbhSvAocYwZtSlIjpiVM76yaEMGp9qQEkMGG8g7igO/L
	 YfoAxpvtSTXKIwydO4XDJZrKNuU41oksFAnzRkgV2plx3SEJJ9QowtSOoSFFX0CpeF
	 7IN+kwaVFGT8g==
Date: Sun, 31 Dec 2023 13:16:08 -0800
Subject: [PATCH 02/24] xfs: define the format of rt groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846274.1763124.9559567871299782407.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

Define the ondisk format of realtime group metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h  |   62 +++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_ondisk.h  |    1 
 fs/xfs/libxfs/xfs_rtgroup.c |   96 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |   83 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c      |   86 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_shared.h  |    1 
 6 files changed, 324 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3bd93c01bf4bf..8debe92571692 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -216,7 +216,17 @@ struct xfs_dsb {
 	 * pointers are no longer used.
 	 */
 	__be64		sb_rbmino;
-	__be64		sb_rsumino;	/* summary inode for rt bitmap */
+	/*
+	 * rtgroups requires metadir, so we reuse the rsumino space to hold
+	 * the rg block count and shift values.
+	 */
+	union {
+		__be64	sb_rsumino;	/* summary inode for rt bitmap */
+		struct {
+			__be32	sb_rgcount;	/* # of realtime groups */
+			__be32	sb_rgblocks;	/* rtblocks per group */
+		};
+	};
 	__be32		sb_rextsize;	/* realtime extent size, blocks */
 	__be32		sb_agblocks;	/* size of an allocation group */
 	__be32		sb_agcount;	/* number of allocation groups */
@@ -398,6 +408,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
 #define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
+#define XFS_SB_FEAT_INCOMPAT_RTGROUPS	(1U << 30)	/* realtime groups */
 #define XFS_SB_FEAT_INCOMPAT_METADIR	(1U << 31)	/* metadata dir tree */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
@@ -752,6 +763,55 @@ union xfs_suminfo_raw {
 	__u32		old;
 };
 
+/*
+ * Realtime allocation groups break the rt section into multiple pieces that
+ * could be locked independently.  Realtime block group numbers are 32-bit
+ * quantities.  Block numbers within a group are also 32-bit quantities, but
+ * the upper bit must never be set.
+ */
+#define XFS_MAX_RGBLOCKS	((xfs_rgblock_t)(1U << 31) - 1)
+#define XFS_MAX_RGNUMBER	((xfs_rgnumber_t)(-1U))
+
+#define XFS_RTSB_MAGIC	0x58524750	/* 'XRGP' */
+
+/*
+ * Realtime superblock - on disk version.  Must be padded to 64 bit alignment.
+ * The first block of each realtime group contains this superblock; this is
+ * how we avoid having file data extents cross a group boundary.
+ */
+struct xfs_rtsb {
+	__be32		rsb_magicnum;	/* magic number == XFS_RTSB_MAGIC */
+	__be32		rsb_blocksize;	/* logical block size, bytes */
+	__be64		rsb_rblocks;	/* number of realtime blocks */
+
+	__be64		rsb_rextents;	/* number of realtime extents */
+	__be64		rsb_lsn;	/* last write sequence */
+
+	__be32		rsb_rgcount;	/* # of realtime groups */
+	unsigned char	rsb_fname[XFSLABEL_MAX]; /* rt volume name */
+
+	uuid_t		rsb_uuid;	/* user-visible file system unique id */
+
+	__be32		rsb_rextsize;	/* realtime extent size, blocks */
+	__be32		rsb_rbmblocks;	/* number of rt bitmap blocks */
+
+	__be32		rsb_rgblocks;	/* rt blocks per group */
+	__u8		rsb_blocklog;	/* log2 of sb_blocksize */
+	__u8		rsb_sectlog;	/* log2 of sb_sectsize */
+	__u8		rsb_rextslog;	/* log2 of sb_rextents */
+	__u8		rsb_pad;
+
+	__le32		rsb_crc;	/* superblock crc */
+	__le32		rsb_pad2;
+
+	uuid_t		rsb_meta_uuid;	/* metadata file system unique id */
+
+	/* must be padded to 64 bit alignment */
+};
+
+#define XFS_RTSB_CRC_OFF	offsetof(struct xfs_rtsb, rsb_crc)
+#define XFS_RTSB_DADDR		((xfs_daddr_t)0) /* daddr in rt section */
+
 /*
  * XFS Timestamps
  * ==============
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 832d96f0f3c54..65219d4cf99ca 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -53,6 +53,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtsb,			104);
 
 	/* dir/attr trees */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index caa82c4813038..a82dd23cf0c79 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -28,6 +28,7 @@
 #include "xfs_trace.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
+#include "xfs_buf_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 
@@ -249,3 +250,98 @@ xfs_rtgroup_block_count(
 	return __xfs_rtgroup_block_count(mp, rgno, mp->m_sb.sb_rgcount,
 			mp->m_sb.sb_rblocks);
 }
+
+static xfs_failaddr_t
+xfs_rtsb_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_rtsb		*rsb = bp->b_addr;
+
+	if (!xfs_verify_magic(bp, rsb->rsb_magicnum))
+		return __this_address;
+	if (be32_to_cpu(rsb->rsb_blocksize) != mp->m_sb.sb_blocksize)
+		return __this_address;
+	if (be64_to_cpu(rsb->rsb_rblocks) != mp->m_sb.sb_rblocks)
+		return __this_address;
+
+	if (be64_to_cpu(rsb->rsb_rextents) != mp->m_sb.sb_rextents)
+		return __this_address;
+
+	if (!uuid_equal(&rsb->rsb_uuid, &mp->m_sb.sb_uuid))
+		return __this_address;
+
+	if (be32_to_cpu(rsb->rsb_rgcount) != mp->m_sb.sb_rgcount)
+		return __this_address;
+
+	if (be32_to_cpu(rsb->rsb_rextsize) != mp->m_sb.sb_rextsize)
+		return __this_address;
+	if (be32_to_cpu(rsb->rsb_rbmblocks) != mp->m_sb.sb_rbmblocks)
+		return __this_address;
+
+	if (be32_to_cpu(rsb->rsb_rgblocks) != mp->m_sb.sb_rgblocks)
+		return __this_address;
+	if (rsb->rsb_blocklog != mp->m_sb.sb_blocklog)
+		return __this_address;
+	if (rsb->rsb_sectlog != mp->m_sb.sb_sectlog)
+		return __this_address;
+	if (rsb->rsb_rextslog != mp->m_sb.sb_rextslog)
+		return __this_address;
+	if (rsb->rsb_pad)
+		return __this_address;
+
+	if (rsb->rsb_pad2)
+		return __this_address;
+
+	if (!uuid_equal(&rsb->rsb_meta_uuid, &mp->m_sb.sb_meta_uuid))
+		return __this_address;
+
+	/* Everything to the end of the fs block must be zero */
+	if (memchr_inv(rsb + 1, 0, BBTOB(bp->b_length) - sizeof(*rsb)))
+		return __this_address;
+
+	return NULL;
+}
+
+static void
+xfs_rtsb_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	if (!xfs_buf_verify_cksum(bp, XFS_RTSB_CRC_OFF))
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_rtsb_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
+}
+
+static void
+xfs_rtsb_write_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_rtsb		*rsb = bp->b_addr;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	xfs_failaddr_t		fa;
+
+	fa = xfs_rtsb_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+
+	if (bip)
+		rsb->rsb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_buf_update_cksum(bp, XFS_RTSB_CRC_OFF);
+}
+
+const struct xfs_buf_ops xfs_rtsb_buf_ops = {
+	.name = "xfs_rtsb",
+	.magic = { 0, cpu_to_be32(XFS_RTSB_MAGIC) },
+	.verify_read = xfs_rtsb_read_verify,
+	.verify_write = xfs_rtsb_write_verify,
+	.verify_struct = xfs_rtsb_verify,
+};
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 2f0a670217c48..924c8c95acbc3 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -122,6 +122,89 @@ xfs_verify_rgbext(
 	return xfs_verify_rgbno(rtg, rgbno + len - 1);
 }
 
+static inline xfs_rtblock_t
+xfs_rgbno_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno)
+{
+	ASSERT(xfs_has_rtgroups(mp));
+
+	if (mp->m_rgblklog >= 0)
+		return ((xfs_rtblock_t)rgno << mp->m_rgblklog) | rgbno;
+
+	return ((xfs_rtblock_t)rgno * mp->m_sb.sb_rgblocks) + rgbno;
+}
+
+static inline xfs_rgnumber_t
+xfs_rtb_to_rgno(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	ASSERT(xfs_has_rtgroups(mp));
+
+	if (mp->m_rgblklog >= 0)
+		return rtbno >> mp->m_rgblklog;
+
+	return div_u64(rtbno, mp->m_sb.sb_rgblocks);
+}
+
+static inline xfs_rgblock_t
+xfs_rtb_to_rgbno(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno,
+	xfs_rgnumber_t		*rgno)
+{
+	uint32_t		rem;
+
+	ASSERT(xfs_has_rtgroups(mp));
+
+	if (mp->m_rgblklog >= 0) {
+		*rgno = rtbno >> mp->m_rgblklog;
+		return rtbno & mp->m_rgblkmask;
+	}
+
+	*rgno = div_u64_rem(rtbno, mp->m_sb.sb_rgblocks, &rem);
+	return rem;
+}
+
+static inline xfs_daddr_t
+xfs_rtb_to_daddr(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return rtbno << mp->m_blkbb_log;
+}
+
+static inline xfs_rtblock_t
+xfs_daddr_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	return daddr >> mp->m_blkbb_log;
+}
+
+static inline xfs_rgnumber_t
+xfs_daddr_to_rgno(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	xfs_rtblock_t		rtb = daddr >> mp->m_blkbb_log;
+
+	return xfs_rtb_to_rgno(mp, rtb);
+}
+
+static inline xfs_rgblock_t
+xfs_daddr_to_rgbno(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	xfs_rtblock_t		rtb = daddr >> mp->m_blkbb_log;
+	xfs_rgnumber_t		rgno;
+
+	return xfs_rtb_to_rgbno(mp, rtb, &rgno);
+}
+
 #ifdef CONFIG_XFS_RT
 xfs_rgblock_t xfs_rtgroup_block_count(struct xfs_mount *mp,
 		xfs_rgnumber_t rgno);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 88402cb4a6879..638de2f7c8dc1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -180,6 +180,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_PARENT;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
 		features |= XFS_FEAT_METADIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTGROUPS)
+		features |= XFS_FEAT_RTGROUPS;
 
 	return features;
 }
@@ -307,6 +309,64 @@ xfs_validate_sb_write(
 	return 0;
 }
 
+static int
+xfs_validate_sb_rtgroups(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	uint64_t		groups;
+
+	if (!(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
+		xfs_warn(mp,
+"Realtime groups require metadata directory tree.");
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rgblocks > XFS_MAX_RGBLOCKS) {
+		xfs_warn(mp,
+"Realtime group size (%u) must be less than %u.",
+			 sbp->sb_rgblocks, XFS_MAX_RGBLOCKS);
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rextsize == 0) {
+		xfs_warn(mp,
+"Realtime extent size must not be zero.");
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rgblocks % sbp->sb_rextsize != 0) {
+		xfs_warn(mp,
+"Realtime group size (%u) must be an even multiple of extent size (%u).",
+			 sbp->sb_rgblocks, sbp->sb_rextsize);
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rgblocks < (sbp->sb_rextsize << 1)) {
+		xfs_warn(mp,
+"Realtime group size (%u) must be greater than 1 rt extent.",
+			 sbp->sb_rgblocks);
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rgcount > XFS_MAX_RGNUMBER) {
+		xfs_warn(mp,
+"Realtime groups (%u) must be less than %u.",
+			 sbp->sb_rgcount, XFS_MAX_RGNUMBER);
+		return -EINVAL;
+	}
+
+	groups = howmany_64(sbp->sb_rblocks, sbp->sb_rgblocks);
+	if (groups != sbp->sb_rgcount) {
+		xfs_warn(mp,
+"Realtime groups (%u) do not cover the entire rt section; need (%llu) groups.",
+			sbp->sb_rgcount, groups);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Check the validity of the SB. */
 STATIC int
 xfs_validate_sb_common(
@@ -318,6 +378,7 @@ xfs_validate_sb_common(
 	uint32_t		agcount = 0;
 	uint32_t		rem;
 	bool			has_dalign;
+	int			error;
 
 	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
 		xfs_warn(mp,
@@ -367,6 +428,12 @@ xfs_validate_sb_common(
 				return -EINVAL;
 			}
 		}
+
+		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTGROUPS) {
+			error = xfs_validate_sb_rtgroups(mp, sbp);
+			if (error)
+				return error;
+		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
@@ -702,8 +769,13 @@ __xfs_sb_from_disk(
 		to->sb_pquotino = NULLFSINO;
 	}
 
-	to->sb_rgcount = 0;
-	to->sb_rgblocks = 0;
+	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTGROUPS) {
+		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
+		to->sb_rgblocks = be32_to_cpu(from->sb_rgblocks);
+	} else {
+		to->sb_rgcount = 0;
+		to->sb_rgblocks = 0;
+	}
 }
 
 void
@@ -863,6 +935,12 @@ xfs_sb_to_disk(
 		to->sb_gquotino = cpu_to_be64(NULLFSINO);
 		to->sb_pquotino = cpu_to_be64(NULLFSINO);
 	}
+
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTGROUPS) {
+		/* must come after setting to_rsumino */
+		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
+		to->sb_rgblocks = cpu_to_be32(from->sb_rgblocks);
+	}
 }
 
 /*
@@ -1018,8 +1096,8 @@ xfs_sb_mount_common(
 	mp->m_blockwmask = mp->m_blockwsize - 1;
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
-	mp->m_rgblklog = 0;
-	mp->m_rgblkmask = 0;
+	mp->m_rgblklog = log2_if_power2(sbp->sb_rgblocks);
+	mp->m_rgblkmask = mask64_if_power2(sbp->sb_rgblocks);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 2cecebe018814..f76d2789e1c2d 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -39,6 +39,7 @@ extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
+extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;

