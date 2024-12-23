Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE4F1C3BF0
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991281; cv=none; b=rT6cl1pFcn+edV3yXyOFooGCbGiQVe4TKtwPl35BREGnhEJ7xbmiuU4aK4su3jvRQ7m4pJNr2IpKqa6tVUVycH0DzTgQq+z9/ihoQPtl4YLHXteVgSZdMhoGCkzi9vhYuflfkrq5jVSv7Cnq4InPEYwNvJSwwukve/7EJgJE2sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991281; c=relaxed/simple;
	bh=OUPuS+AqSXS/1I8hMwJUllFztSOA54OHghTvIBU3aCw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AvYPYXXuyUf7UcD2tPyKxoGqc9/P+2bI9Uwl+DHsin34ExFe/kMzuyN4JNEgO46bvCvDLTIoZFCCkHrUCL5X18TOswcCVrVeVs2D/b35wN2AzgSNBzf3fu262a2nFYNzDmUL0IcUQwCkoJIdyrIcO0L0SsJYrwlMN8I/l3Lbsp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ww1XwXwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ww1XwXwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4881BC4CEDD;
	Mon, 23 Dec 2024 22:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991281;
	bh=OUPuS+AqSXS/1I8hMwJUllFztSOA54OHghTvIBU3aCw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ww1XwXwd0DYdaLPVSmSlY43m9ICozY893ny9eh2DDeXtHcr5nFDEGvCnBH/yjGGEb
	 rB2IH1RdKadqM2Bhr+BRFwzNa/bsDAv6tFEyprBzn13iNBTreMzzLKgz5qbZD7hSP8
	 4N/x0la8w3VMr0Bps0jLprPODhi6HlKGryMf2Tn8Ex/fbixxzNwXghwv3MLQ26ef2F
	 ER0NJRJkvCcfzuPprXRI1pHWK9xqQKS9V3HiG3bhXCq4tAhsfGFT99nwkyst88m6Uj
	 mwLuxqMNnPEzVCiyYdjHsl9+JL3acmaUmL7RVS8/hk/qm1DEwhQmNmctMdNCN94YEW
	 JKdBcIvkauEYw==
Date: Mon, 23 Dec 2024 14:01:20 -0800
Subject: [PATCH 12/52] xfs: define the format of rt groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942677.2295836.7924241153553017959.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 96768e91511bfced6e9e537f4891157d909b13ee

Define the ondisk format of realtime group metadata, and a superblock
for realtime volumes.  rt supers are conditionally enabled by a
predicate function so that they can be disabled if we ever implement
zoned storage support for the realtime volume.

For rt group enabled file systems there is a separate bitmap and summary
file for each group and thus the number of bitmap and summary blocks
needs to be calculated differently.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h      |    1 
 include/xfs_mount.h   |    6 ++-
 libxfs/libxfs_priv.h  |    1 
 libxfs/xfs_format.h   |   42 ++++++++++++++++++++-
 libxfs/xfs_ondisk.h   |    3 +
 libxfs/xfs_rtbitmap.c |   20 ++++++++--
 libxfs/xfs_rtgroup.c  |   81 ++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_sb.c       |  100 +++++++++++++++++++++++++++++++++++++++++++------
 libxfs/xfs_shared.h   |    1 
 9 files changed, 236 insertions(+), 19 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index df38d875143ed9..5689f58c640168 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -98,6 +98,7 @@ struct iomap;
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 7406825cf7f57a..31ac60d93c61cc 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -248,12 +248,14 @@ __XFS_HAS_FEAT(metadir, METADIR)
 
 static inline bool xfs_has_rtgroups(struct xfs_mount *mp)
 {
-	return false;
+	/* all metadir file systems also allow rtgroups */
+	return xfs_has_metadir(mp);
 }
 
 static inline bool xfs_has_rtsb(struct xfs_mount *mp)
 {
-	return false;
+	/* all rtgroups filesystems with an rt section have an rtsb */
+	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp);
 }
 
 /* Kernel mount features that we don't support */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 620cd13b8ef796..1fc9c784b05054 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -53,6 +53,7 @@
 #include "libfrog/radix-tree.h"
 #include "libfrog/bitmask.h"
 #include "libfrog/div64.h"
+#include "libfrog/util.h"
 #include "atomic.h"
 #include "spinlock.h"
 #include "linux-err.h"
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 867060d60e8583..3cf044a2d5f2a9 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -265,8 +265,15 @@ struct xfs_dsb {
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
 	__be64		sb_metadirino;	/* metadata directory tree root */
+	__be32		sb_rgcount;	/* # of realtime groups */
+	__be32		sb_rgextents;	/* size of rtgroup in rtx */
 
-	/* must be padded to 64 bit alignment */
+	/*
+	 * The size of this structure must be padded to 64 bit alignment.
+	 *
+	 * NOTE: Don't forget to update secondary_sb_whack in xfs_repair when
+	 * adding new fields here.
+	 */
 };
 
 #define XFS_SB_CRC_OFF		offsetof(struct xfs_dsb, sb_crc)
@@ -716,6 +723,39 @@ union xfs_suminfo_raw {
 	__u32		old;
 };
 
+/*
+ * Realtime allocation groups break the rt section into multiple pieces that
+ * could be locked independently.  Realtime block group numbers are 32-bit
+ * quantities.  Block numbers within a group are also 32-bit quantities, but
+ * the upper bit must never be set.  rtgroup 0 might have a superblock in it,
+ * so the minimum size of an rtgroup is 2 rtx.
+ */
+#define XFS_MAX_RGBLOCKS	((xfs_rgblock_t)(1U << 31) - 1)
+#define XFS_MIN_RGEXTENTS	((xfs_rtxlen_t)2)
+#define XFS_MAX_RGNUMBER	((xfs_rgnumber_t)(-1U))
+
+#define XFS_RTSB_MAGIC	0x46726F67	/* 'Frog' */
+
+/*
+ * Realtime superblock - on disk version.  Must be padded to 64 bit alignment.
+ * The first block of the realtime volume contains this superblock.
+ */
+struct xfs_rtsb {
+	__be32		rsb_magicnum;	/* magic number == XFS_RTSB_MAGIC */
+	__le32		rsb_crc;	/* superblock crc */
+
+	__be32		rsb_pad;	/* zero */
+	unsigned char	rsb_fname[XFSLABEL_MAX]; /* file system name */
+
+	uuid_t		rsb_uuid;	/* user-visible file system unique id */
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
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 8bca86e350fdc1..38b314113d8f24 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -37,7 +37,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			272);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			280);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
@@ -53,6 +53,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtsb,			56);
 
 	/* dir/attr trees */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index edcfb09e29fa18..84ca5447ca770f 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1155,6 +1155,21 @@ xfs_rtbitmap_blockcount_len(
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
+/* How many rt extents does each rtbitmap file track? */
+static inline xfs_rtbxlen_t
+xfs_rtbitmap_bitcount(
+	struct xfs_mount	*mp)
+{
+	if (!mp->m_sb.sb_rextents)
+		return 0;
+
+	/* rtgroup size can be nonzero even if rextents is zero */
+	if (xfs_has_rtgroups(mp))
+		return mp->m_sb.sb_rgextents;
+
+	return mp->m_sb.sb_rextents;
+}
+
 /*
  * Compute the number of rtbitmap blocks used for a given file system.
  */
@@ -1162,7 +1177,7 @@ xfs_filblks_t
 xfs_rtbitmap_blockcount(
 	struct xfs_mount	*mp)
 {
-	return xfs_rtbitmap_blockcount_len(mp, mp->m_sb.sb_rextents);
+	return xfs_rtbitmap_blockcount_len(mp, xfs_rtbitmap_bitcount(mp));
 }
 
 /*
@@ -1176,8 +1191,7 @@ xfs_rtsummary_blockcount(
 {
 	unsigned long long	rsumwords;
 
-	*rsumlevels = xfs_compute_rextslog(mp->m_sb.sb_rextents) + 1;
-
+	*rsumlevels = xfs_compute_rextslog(xfs_rtbitmap_bitcount(mp)) + 1;
 	rsumwords = xfs_rtbitmap_blockcount(mp) * (*rsumlevels);
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 4f2e6be2ae48cc..e294a295b3d0d8 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -480,3 +480,84 @@ xfs_rtginode_load_parent(
 	return xfs_metadir_load(tp, mp->m_metadirip, "rtgroups",
 			XFS_METAFILE_DIR, &mp->m_rtdirip);
 }
+
+/* Check superblock fields for a read or a write. */
+static xfs_failaddr_t
+xfs_rtsb_verify_common(
+	struct xfs_buf		*bp)
+{
+	struct xfs_rtsb		*rsb = bp->b_addr;
+
+	if (!xfs_verify_magic(bp, rsb->rsb_magicnum))
+		return __this_address;
+	if (rsb->rsb_pad)
+		return __this_address;
+
+	/* Everything to the end of the fs block must be zero */
+	if (memchr_inv(rsb + 1, 0, BBTOB(bp->b_length) - sizeof(*rsb)))
+		return __this_address;
+
+	return NULL;
+}
+
+/* Check superblock fields for a read or revalidation. */
+static inline xfs_failaddr_t
+xfs_rtsb_verify_all(
+	struct xfs_buf		*bp)
+{
+	struct xfs_rtsb		*rsb = bp->b_addr;
+	struct xfs_mount	*mp = bp->b_mount;
+	xfs_failaddr_t		fa;
+
+	fa = xfs_rtsb_verify_common(bp);
+	if (fa)
+		return fa;
+
+	if (memcmp(&rsb->rsb_fname, &mp->m_sb.sb_fname, XFSLABEL_MAX))
+		return __this_address;
+	if (!uuid_equal(&rsb->rsb_uuid, &mp->m_sb.sb_uuid))
+		return __this_address;
+	if (!uuid_equal(&rsb->rsb_meta_uuid, &mp->m_sb.sb_meta_uuid))
+		return  __this_address;
+
+	return NULL;
+}
+
+static void
+xfs_rtsb_read_verify(
+	struct xfs_buf		*bp)
+{
+	xfs_failaddr_t		fa;
+
+	if (!xfs_buf_verify_cksum(bp, XFS_RTSB_CRC_OFF)) {
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		return;
+	}
+
+	fa = xfs_rtsb_verify_all(bp);
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+static void
+xfs_rtsb_write_verify(
+	struct xfs_buf		*bp)
+{
+	xfs_failaddr_t		fa;
+
+	fa = xfs_rtsb_verify_common(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+
+	xfs_buf_update_cksum(bp, XFS_RTSB_CRC_OFF);
+}
+
+const struct xfs_buf_ops xfs_rtsb_buf_ops = {
+	.name		= "xfs_rtsb",
+	.magic		= { 0, cpu_to_be32(XFS_RTSB_MAGIC) },
+	.verify_read	= xfs_rtsb_read_verify,
+	.verify_write	= xfs_rtsb_write_verify,
+	.verify_struct	= xfs_rtsb_verify_all,
+};
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 2a5368c266ee91..3c80413b67f6ec 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -231,11 +231,22 @@ xfs_validate_sb_read(
 	return 0;
 }
 
+/* Return the number of extents covered by a single rt bitmap file */
+static xfs_rtbxlen_t
+xfs_extents_per_rbm(
+	struct xfs_sb		*sbp)
+{
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR))
+		return sbp->sb_rgextents;
+	return sbp->sb_rextents;
+}
+
 static uint64_t
-xfs_sb_calc_rbmblocks(
+xfs_expected_rbmblocks(
 	struct xfs_sb		*sbp)
 {
-	return howmany_64(sbp->sb_rextents, NBBY * sbp->sb_blocksize);
+	return howmany_64(xfs_extents_per_rbm(sbp), NBBY * sbp->sb_blocksize);
 }
 
 /* Validate the realtime geometry */
@@ -257,7 +268,7 @@ xfs_validate_rt_geometry(
 	if (sbp->sb_rextents == 0 ||
 	    sbp->sb_rextents != div_u64(sbp->sb_rblocks, sbp->sb_rextsize) ||
 	    sbp->sb_rextslog != xfs_compute_rextslog(sbp->sb_rextents) ||
-	    sbp->sb_rbmblocks != xfs_sb_calc_rbmblocks(sbp))
+	    sbp->sb_rbmblocks != xfs_expected_rbmblocks(sbp))
 		return false;
 
 	return true;
@@ -338,6 +349,59 @@ xfs_validate_sb_write(
 	return 0;
 }
 
+static int
+xfs_validate_sb_rtgroups(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	uint64_t		groups;
+
+	if (sbp->sb_rextsize == 0) {
+		xfs_warn(mp,
+"Realtime extent size must not be zero.");
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rgextents > XFS_MAX_RGBLOCKS / sbp->sb_rextsize) {
+		xfs_warn(mp,
+"Realtime group size (%u) must be less than %u rt extents.",
+				sbp->sb_rgextents,
+				XFS_MAX_RGBLOCKS / sbp->sb_rextsize);
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rgextents < XFS_MIN_RGEXTENTS) {
+		xfs_warn(mp,
+"Realtime group size (%u) must be at least %u rt extents.",
+				sbp->sb_rgextents, XFS_MIN_RGEXTENTS);
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rgcount > XFS_MAX_RGNUMBER) {
+		xfs_warn(mp,
+"Realtime groups (%u) must be less than %u.",
+				sbp->sb_rgcount, XFS_MAX_RGNUMBER);
+		return -EINVAL;
+	}
+
+	groups = howmany_64(sbp->sb_rextents, sbp->sb_rgextents);
+	if (groups != sbp->sb_rgcount) {
+		xfs_warn(mp,
+"Realtime groups (%u) do not cover the entire rt section; need (%llu) groups.",
+				sbp->sb_rgcount, groups);
+		return -EINVAL;
+	}
+
+	/* Exchange-range is required for fsr to work on realtime files */
+	if (!(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_EXCHRANGE)) {
+		xfs_warn(mp,
+"Realtime groups feature requires exchange-range support.");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Check the validity of the SB. */
 STATIC int
 xfs_validate_sb_common(
@@ -349,6 +413,7 @@ xfs_validate_sb_common(
 	uint32_t		agcount = 0;
 	uint32_t		rem;
 	bool			has_dalign;
+	int			error;
 
 	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
 		xfs_warn(mp,
@@ -412,6 +477,12 @@ xfs_validate_sb_common(
 				sbp->sb_spino_align);
 			return -EINVAL;
 		}
+
+		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
+			error = xfs_validate_sb_rtgroups(mp, sbp);
+			if (error)
+				return error;
+		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
@@ -703,13 +774,15 @@ __xfs_sb_from_disk(
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
 
-	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
 		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
-	else
+		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
+		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
+	} else {
 		to->sb_metadirino = NULLFSINO;
-
-	to->sb_rgcount = 1;
-	to->sb_rgextents = 0;
+		to->sb_rgcount = 1;
+		to->sb_rgextents = 0;
+	}
 }
 
 void
@@ -858,8 +931,11 @@ xfs_sb_to_disk(
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 
-	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
 		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
+		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
+		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
+	}
 }
 
 /*
@@ -999,9 +1075,9 @@ xfs_mount_sb_set_rextsize(
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 
-	mp->m_rgblocks = 0;
-	mp->m_rgblklog = 0;
-	mp->m_rgblkmask = (uint64_t)-1;
+	mp->m_rgblocks = sbp->sb_rgextents * sbp->sb_rextsize;
+	mp->m_rgblklog = log2_if_power2(mp->m_rgblocks);
+	mp->m_rgblkmask = mask64_if_power2(mp->m_rgblocks);
 
 	rgs->blocks = 0;
 	rgs->blklog = 0;
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 33b84a3a83ff63..552365d212ea26 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -39,6 +39,7 @@ extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
+extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;

