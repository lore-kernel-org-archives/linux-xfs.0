Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF511DED44
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191841; cv=none; b=duJdXti1LeGjM2wfV03XQkzHK8dgybNybk3bLVI2XJ6qpr6wGaXz20GKba7S0wGpiL3Lo2oMxkvpgX/uOcHbbkYYEpiDwaa4yQlSNrZCk0NdBBqny84tWbowdBri8uPqqoShF/gL9CTXUYsCcWnMnF94wc1cYMrfWjmAf+A7M9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191841; c=relaxed/simple;
	bh=8HDDYUvS56kuffQrPOfbZDZutHnDERMp2k/H/sLoMCA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8RCRXKwq2B9TI+K2gIduGgkDnW6YHFC7WDZ+DI7y9nesmwurqZKOJBHn0JQAEKYjCYedgzGrVnjhSgv2VcP10DjyvhbP7+FfYw3ZygEdsgf0/UMlKO71HD2YngUC2f1wbItPR/SR2avkoNRNMfGOMbNtCoaxlW2P5yeAwNmou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1k88/ix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1k88/ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA62C4CEC3;
	Thu, 17 Oct 2024 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191841;
	bh=8HDDYUvS56kuffQrPOfbZDZutHnDERMp2k/H/sLoMCA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f1k88/ixTZWbTcdLnaOB5rscXX599rztRKmfAWulMZ2nQeOz8LYFnKJxxJ2eYDYX8
	 5U0rKHpT2BmHbm9QDQIXv5gkpca9geTO8neKCkUqbXE1E0c9j2250cCwz5FQpY/Pi5
	 zCmHbvWDp7LoxLLr3DT2l0BggEgiq3PHo+09uhXjKbxHztHUBtETUiOM3ecQISGuDt
	 Luu/JzXnzJYdqVRRC28z7do94yEfnGg8Eer6RvPU5j11YysGbMalqPw+PMQLEADHZR
	 ARqNbQ24luFNhOsBO9DrgtN4CmdwtGCVqF9wbFMxQTzP2C2w6ZG/DPpaZpaJ249wIV
	 OV/+R06eotWhQ==
Date: Thu, 17 Oct 2024 12:04:00 -0700
Subject: [PATCH 01/34] xfs: define the format of rt groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071681.3453179.2361469423447590163.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

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
 fs/xfs/libxfs/xfs_format.h   |   42 +++++++++++++++++-
 fs/xfs/libxfs/xfs_ondisk.h   |    3 +
 fs/xfs/libxfs/xfs_rtbitmap.c |   20 +++++++-
 fs/xfs/libxfs/xfs_rtgroup.c  |   82 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c       |  100 +++++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_shared.h   |    1 
 fs/xfs/xfs_mount.h           |    6 ++-
 fs/xfs/xfs_rtalloc.c         |   30 +++++++++++--
 8 files changed, 262 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 867060d60e8583..3cf044a2d5f2a9 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 8bca86e350fdc1..38b314113d8f24 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 54079edfe10feb..416bbcd92af2ad 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1157,6 +1157,21 @@ xfs_rtbitmap_blockcount_len(
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
@@ -1164,7 +1179,7 @@ xfs_filblks_t
 xfs_rtbitmap_blockcount(
 	struct xfs_mount	*mp)
 {
-	return xfs_rtbitmap_blockcount_len(mp, mp->m_sb.sb_rextents);
+	return xfs_rtbitmap_blockcount_len(mp, xfs_rtbitmap_bitcount(mp));
 }
 
 /*
@@ -1178,8 +1193,7 @@ xfs_rtsummary_blockcount(
 {
 	unsigned long long	rsumwords;
 
-	*rsumlevels = xfs_compute_rextslog(mp->m_sb.sb_rextents) + 1;
-
+	*rsumlevels = xfs_compute_rextslog(xfs_rtbitmap_bitcount(mp)) + 1;
 	rsumwords = xfs_rtbitmap_blockcount(mp) * (*rsumlevels);
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index da29f41e51f1e1..9e2ca61559f45e 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -28,6 +28,7 @@
 #include "xfs_trace.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
+#include "xfs_buf_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
@@ -482,3 +483,84 @@ xfs_rtginode_load_parent(
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 21891aa10ada02..b5f798d01dba05 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -234,11 +234,22 @@ xfs_validate_sb_read(
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
@@ -260,7 +271,7 @@ xfs_validate_rt_geometry(
 	if (sbp->sb_rextents == 0 ||
 	    sbp->sb_rextents != div_u64(sbp->sb_rblocks, sbp->sb_rextsize) ||
 	    sbp->sb_rextslog != xfs_compute_rextslog(sbp->sb_rextents) ||
-	    sbp->sb_rbmblocks != xfs_sb_calc_rbmblocks(sbp))
+	    sbp->sb_rbmblocks != xfs_expected_rbmblocks(sbp))
 		return false;
 
 	return true;
@@ -341,6 +352,59 @@ xfs_validate_sb_write(
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
@@ -352,6 +416,7 @@ xfs_validate_sb_common(
 	uint32_t		agcount = 0;
 	uint32_t		rem;
 	bool			has_dalign;
+	int			error;
 
 	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
 		xfs_warn(mp,
@@ -401,6 +466,12 @@ xfs_validate_sb_common(
 				return -EINVAL;
 			}
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
@@ -692,13 +763,15 @@ __xfs_sb_from_disk(
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
@@ -847,8 +920,11 @@ xfs_sb_to_disk(
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
@@ -988,9 +1064,9 @@ xfs_mount_sb_set_rextsize(
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
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 33b84a3a83ff63..552365d212ea26 100644
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2795dd83c23b3f..eca206140d4b0c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -387,12 +387,14 @@ __XFS_HAS_FEAT(metadir, METADIR)
 
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
 
 /*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a5e3f7be81ffa8..866274a66d4d28 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -751,6 +751,11 @@ xfs_growfs_rt_alloc_fake_mount(
 	nmp->m_sb.sb_rextents = xfs_blen_to_rtbxlen(nmp, nmp->m_sb.sb_rblocks);
 	nmp->m_sb.sb_rbmblocks = xfs_rtbitmap_blockcount(nmp);
 	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
+	if (xfs_has_rtgroups(nmp))
+		nmp->m_sb.sb_rgcount = howmany_64(nmp->m_sb.sb_rextents,
+						  nmp->m_sb.sb_rgextents);
+	else
+		nmp->m_sb.sb_rgcount = 1;
 	nmp->m_rsumblocks = xfs_rtsummary_blockcount(nmp, &nmp->m_rsumlevels);
 
 	if (rblocks > 0)
@@ -761,6 +766,26 @@ xfs_growfs_rt_alloc_fake_mount(
 	return nmp;
 }
 
+static xfs_rfsblock_t
+xfs_growfs_rt_nrblocks(
+	struct xfs_rtgroup	*rtg,
+	xfs_rfsblock_t		nrblocks,
+	xfs_agblock_t		rextsize,
+	xfs_fileoff_t		bmbno)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_rfsblock_t		step;
+
+	step = (bmbno + 1) * NBBY * mp->m_sb.sb_blocksize * rextsize;
+	if (xfs_has_rtgroups(mp)) {
+		xfs_rfsblock_t	rgblocks = mp->m_sb.sb_rgextents * rextsize;
+
+		step = min(rgblocks, step) + rgblocks * rtg_rgno(rtg);
+	}
+
+	return min(nrblocks, step);
+}
+
 static int
 xfs_growfs_rt_bmblock(
 	struct xfs_rtgroup	*rtg,
@@ -779,16 +804,15 @@ xfs_growfs_rt_bmblock(
 		.rtg		= rtg,
 	};
 	struct xfs_mount	*nmp;
-	xfs_rfsblock_t		nrblocks_step;
 	xfs_rtbxlen_t		freed_rtx;
 	int			error;
 
 	/*
 	 * Calculate new sb and mount fields for this round.
 	 */
-	nrblocks_step = (bmbno + 1) * NBBY * mp->m_sb.sb_blocksize * rextsize;
 	nmp = nargs.mp = xfs_growfs_rt_alloc_fake_mount(mp,
-			min(nrblocks, nrblocks_step), rextsize);
+			xfs_growfs_rt_nrblocks(rtg, nrblocks, rextsize, bmbno),
+			rextsize);
 	if (!nmp)
 		return -ENOMEM;
 

