Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7373EAC76
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871375; cv=none; b=jB0gPO9ijgXz84njUCvCM7F68ZapTDP0C1vQfz/L2NzIRUb4ZnAD2UpG2ht/f0J7WnZfUKE6y0ajPEMOxvRF17HnSXK1+tWrVKsyKdnBph54mQ3fDI0ZbJFNqQcu8EhSGMSWym12sjgad07vlRfnZl8SaZLFcRE8djoWr2kQLf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871375; c=relaxed/simple;
	bh=/3/Pqe9bRdOZwS36gfuYyWsHUHq8WtpXr6K8CXOlDYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfjVy5g6c3tc3PKU2SRev9I/PflMyC35y2jhEIpyFDXC8C+h+cpa2HybpwRXwS0HBK8StnSHUfC54TXmtQU2SORDyr22Z99lQq9khUf2tC3jp+ubpFl0mrLikgEvqhqN+eRqT6YHdH9lcM5bfX+k6JpJykZpfMM4KODNBZkE0RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdzO92/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdzO92/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94D81F00893;
	Tue, 13 Oct 2026 06:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871373;
	bh=gB8xnYwXKpsj8JNlV4ndypnHvSXMpMOjr7MIZAn2+0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdzO92/rURc4isrnYk8zDssA12dlZG6SKR5fL+GNgahyoQEOgHnSbTQdAJK47cfjt
	 mnSTJZqakGhXj01vjHeOJ4BfjoOMOE7W5UANXkbUh+qXbsuf3XxesxZXSLFNf6MLZG
	 3bbsKOpzb1jxvKB7wipB+BhphNcLlsvt5+XIJXe9juX2bLKhhFLIeAlZ8DoGDfe0yi
	 fkPM+uIpcU+Ah4pQUHq5VlADQOG+FSFQq9sJpsgCOSzD0RfpNUhI/sYJ+/R9iTCb8Y
	 6SUy9cxs25oPcUFxB8Re81FqeJLXeSm6xPb9G/Tp8u7T2GL6mtqCuWxYHqSMgKCB+Y
	 C/aNdDH4xL2Rw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 36/48] xfs: validate the logged inode core during recovery
Date: Tue, 13 Oct 2026 17:01:26 +1100
Message-ID: <20261013060204.3138690-37-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The log dinode core carries the inode fields being recovered into the on-disk
inode. Recovery validated only a handful of these fields, scattered through the
commit handler as it set up the replay, so most of the core was trusted and
written back without being checked.

Add xfs_log_dinode_verify() that verifies the fields carried in the log dinode
core. Call it during item validation once the core region length has been
checked, so the whole core is trusted before replay begins.

The fork offset check is common to the on-disk and log dinode, so
xfs_dinode_verify_forkoff() is recast as xfs_inode_verify_forkoff() taking the
offset and format as arguments and shared between them. The extent count helper
already present in recovery is converted to the failaddr idiom so it composes as
a sub-check of the new verifier.

The core checks the commit handler performed are removed, and the core region
length is now checked exactly against the size the running filesystem logs. The
on-disk inode magic check in the commit handler is also removed as the inode
buffer verifier run by the buffer read already performs it.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  19 +-
 fs/xfs/libxfs/xfs_inode_buf.h   |   2 +
 fs/xfs/xfs_inode_item_recover.c | 362 ++++++++++++++++++++++----------
 3 files changed, 259 insertions(+), 124 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 282e78e5e3e8..293d4f27d1cf 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -477,17 +477,18 @@ xfs_dinode_verify_fork(
 	return NULL;
 }
 
-static xfs_failaddr_t
-xfs_dinode_verify_forkoff(
-	struct xfs_dinode	*dip,
-	struct xfs_mount	*mp)
+xfs_failaddr_t
+xfs_inode_verify_forkoff(
+	struct xfs_mount	*mp,
+	uint8_t			forkoff,
+	uint8_t			format)
 {
-	if (!dip->di_forkoff)
+	if (!forkoff)
 		return NULL;
 
-	switch (dip->di_format)  {
+	switch (format)  {
 	case XFS_DINODE_FMT_DEV:
-		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
+		if (forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_META_BTREE:
@@ -497,7 +498,7 @@ xfs_dinode_verify_forkoff(
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
+		if (forkoff >= (XFS_LITINO(mp) >> 3))
 			return __this_address;
 		break;
 	default:
@@ -683,7 +684,7 @@ xfs_dinode_verify(
 		return __this_address;
 
 	/* check for illegal values of forkoff */
-	fa = xfs_dinode_verify_forkoff(dip, mp);
+	fa = xfs_inode_verify_forkoff(mp, dip->di_forkoff, dip->di_format);
 	if (fa)
 		return fa;
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index f3624532b023..5e8e7f920d55 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -35,6 +35,8 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
+xfs_failaddr_t xfs_inode_verify_forkoff(struct xfs_mount *mp, uint8_t forkoff,
+		uint8_t format);
 
 static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
 {
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 8de41ed0bc2f..6f25b716b5d1 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -23,6 +23,8 @@
 #include "xfs_icache.h"
 #include "xfs_ialloc.h"
 #include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_metafile.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
@@ -213,7 +215,7 @@ xfs_log_dinode_to_disk(
 	xfs_log_dinode_to_disk_iext_counters(from, to);
 }
 
-STATIC int
+static xfs_failaddr_t
 xlog_dinode_verify_extent_counts(
 	struct xfs_mount	*mp,
 	struct xfs_log_dinode	*ldip)
@@ -223,45 +225,220 @@ xlog_dinode_verify_extent_counts(
 
 	if (xfs_log_dinode_has_large_extent_counts(ldip)) {
 		if (!xfs_has_large_extent_counts(mp) ||
-		    (ldip->di_nrext64_pad != 0)) {
-			XFS_CORRUPTION_ERROR(
-				"Bad log dinode large extent count format",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-			xfs_alert(mp,
-				"Bad inode 0x%llx, large extent counts %d, padding 0x%x",
-				ldip->di_ino, xfs_has_large_extent_counts(mp),
-				ldip->di_nrext64_pad);
-			return -EFSCORRUPTED;
-		}
+		    (ldip->di_nrext64_pad != 0))
+			return __this_address;
 
 		nextents = ldip->di_big_nextents;
 		anextents = ldip->di_big_anextents;
 	} else {
-		if (ldip->di_version == 3 && ldip->di_v3_pad != 0) {
-			XFS_CORRUPTION_ERROR(
-				"Bad log dinode di_v3_pad",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-			xfs_alert(mp,
-				"Bad inode 0x%llx, di_v3_pad 0x%llx",
-				ldip->di_ino, ldip->di_v3_pad);
-			return -EFSCORRUPTED;
-		}
+		if (ldip->di_version == 3 && ldip->di_v3_pad != 0)
+			return __this_address;
 
 		nextents = ldip->di_nextents;
 		anextents = ldip->di_anextents;
 	}
 
-	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
-		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-		xfs_alert(mp,
-			"Bad inode 0x%llx, large extent counts %d, nextents 0x%llx, anextents 0x%x, nblocks 0x%llx",
-			ldip->di_ino, xfs_has_large_extent_counts(mp), nextents,
-			anextents, ldip->di_nblocks);
-		return -EFSCORRUPTED;
+	if (nextents + anextents > ldip->di_nblocks)
+		return __this_address;
+
+	return NULL;
+}
+
+/*
+ * Host order counterpart of xfs_dinode_verify_metadir(). The generic v3 field
+ * checks that verifier repeats are already covered before we get here, so this
+ * only validates the metadata inode specific rules.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_metadir(
+	struct xfs_mount	*mp,
+	struct xfs_log_dinode	*ldip)
+{
+	if (!xfs_has_metadir(mp))
+		return __this_address;
+
+	if (ldip->di_metatype >= XFS_METAFILE_MAX)
+		return __this_address;
+
+	/* Metadata files can only be directories or regular files */
+	if (!S_ISDIR(ldip->di_mode) && !S_ISREG(ldip->di_mode))
+		return __this_address;
+
+	/* They must have zero access permissions */
+	if (ldip->di_mode & 0777)
+		return __this_address;
+
+	/* DMAPI event and state masks are zero */
+	if (ldip->di_dmevmask || ldip->di_dmstate)
+		return __this_address;
+
+	/*
+	 * User and group IDs must be zero.  The project ID is used for
+	 * grouping inodes.  Metadata inodes are never accounted to quotas.
+	 */
+	if (ldip->di_uid || ldip->di_gid)
+		return __this_address;
+
+	/* Mandatory inode flags must be set */
+	if (S_ISDIR(ldip->di_mode)) {
+		if ((ldip->di_flags & XFS_METADIR_DIFLAGS) != XFS_METADIR_DIFLAGS)
+			return __this_address;
+	} else {
+		if ((ldip->di_flags & XFS_METAFILE_DIFLAGS) != XFS_METAFILE_DIFLAGS)
+			return __this_address;
 	}
 
-	return 0;
+	/* dax flags2 must not be set */
+	if (ldip->di_flags2 & XFS_DIFLAG2_DAX)
+		return __this_address;
+
+	return NULL;
+}
+
+/*
+ * Verify the logged inode core. This is the host order counterpart of
+ * xfs_dinode_verify(), restricted to the fields carried in the log dinode
+ * core. The checks that read the data or attribute fork contents are done
+ * separately against the logged fork regions, and the checks that only apply
+ * to a written on-disk inode (the CRC, di_next_unlinked, the LSN) do not apply
+ * to the log dinode at all.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_log_dinode	*ldip)
+{
+	xfs_failaddr_t		fa;
+	uint16_t		mode;
+	uint16_t		flags;
+	uint64_t		flags2;
+
+	if (ldip->di_magic != XFS_DINODE_MAGIC)
+		return __this_address;
+
+	/*
+	 * Only inode versions 2 and 3 are valid. Verify the version specific
+	 * integrity information, which for v3 must be checked before the rest
+	 * of the core so it can be trusted.
+	 */
+	switch (ldip->di_version) {
+	case 2:
+		if (ldip->di_metatype)
+			return __this_address;
+		break;
+	case 3:
+		if (!xfs_has_v3inodes(mp))
+			return __this_address;
+		if (ldip->di_ino != ino)
+			return __this_address;
+		if (!uuid_equal(&ldip->di_uuid, &mp->m_sb.sb_meta_uuid))
+			return __this_address;
+		if (!(ldip->di_flags2 & XFS_DIFLAG2_METADATA) &&
+		    ldip->di_metatype)
+			return __this_address;
+		break;
+	default:
+		return __this_address;
+	}
+
+	/* don't allow invalid i_size */
+	if (ldip->di_size & (1ULL << 63))
+		return __this_address;
+
+	mode = ldip->di_mode;
+	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
+		return __this_address;
+
+	/*
+	 * No zero-length symlinks/dirs unless they're unlinked and hence being
+	 * inactivated.
+	 */
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && ldip->di_size == 0) {
+		if (ldip->di_nlink)
+			return __this_address;
+	}
+
+	fa = xlog_dinode_verify_extent_counts(mp, ldip);
+	if (fa)
+		return fa;
+
+	flags = ldip->di_flags;
+
+	if (mode && (flags & XFS_DIFLAG_REALTIME) && !mp->m_rtdev_targp)
+		return __this_address;
+
+	/* check for illegal values of forkoff */
+	fa = xfs_inode_verify_forkoff(mp, ldip->di_forkoff, ldip->di_format);
+	if (fa)
+		return fa;
+
+	/* Do we have appropriate data fork formats for the mode? */
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		if (ldip->di_format != XFS_DINODE_FMT_DEV)
+			return __this_address;
+		break;
+	case S_IFREG:
+	case S_IFLNK:
+	case S_IFDIR:
+	case 0:
+		/* Fork format is verified against the logged fork regions. */
+		break;
+	default:
+		return __this_address;
+	}
+
+	/* extent size hint validation */
+	fa = xfs_inode_validate_extsize(mp, ldip->di_extsize, mode, flags);
+	if (fa)
+		return fa;
+
+	/* only version 3 or greater inodes are extensively verified here */
+	if (ldip->di_version < 3)
+		return NULL;
+
+	flags2 = ldip->di_flags2;
+
+	/* don't allow reflink/cowextsize if we don't have reflink */
+	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
+	     !xfs_has_reflink(mp))
+		return __this_address;
+
+	/* only regular files get reflink */
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (mode & S_IFMT) != S_IFREG)
+		return __this_address;
+
+	/* don't let reflink and realtime mix */
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME) &&
+	    !xfs_has_rtreflink(mp))
+		return __this_address;
+
+	if (xfs_has_zoned(mp) && ldip->di_metatype == XFS_METAFILE_RTRMAP) {
+		if (ldip->di_used_blocks > mp->m_sb.sb_rgextents)
+			return __this_address;
+	} else {
+		/* COW extent size hint validation */
+		fa = xfs_inode_validate_cowextsize(mp, ldip->di_cowextsize,
+				mode, flags, flags2);
+		if (fa)
+			return fa;
+	}
+
+	/* bigtime iflag can only happen on bigtime filesystems */
+	if (xfs_log_dinode_has_bigtime(ldip) && !xfs_has_bigtime(mp))
+		return __this_address;
+
+	if (flags2 & XFS_DIFLAG2_METADATA) {
+		fa = xlog_dinode_verify_metadir(mp, ldip);
+		if (fa)
+			return fa;
+	}
+
+	return NULL;
 }
 
 static inline int
@@ -315,8 +492,9 @@ xlog_recover_inode_nregions(
 }
 
 /*
- * The format header (region 0) is logged in either the host format or the 32
- * bit on-disk format, so it must match one of those two sizes.
+ * Region 0 is the format header, logged in either the host format or the 32 bit
+ * on-disk format, so it must match one of those two sizes. Region 1 is the log
+ * dinode core, always logged at the size the running filesystem uses.
  */
 static int
 xlog_recover_inode_validate_region(
@@ -326,14 +504,25 @@ xlog_recover_inode_validate_region(
 {
 	size_t				len = item->ri_buf[region_index].iov_len;
 
-	if (region_index > 0)
+	if (region_index == 0) {
+		if (len != sizeof(struct xfs_inode_log_format) &&
+		    len != sizeof(struct xfs_inode_log_format_32)) {
+			xfs_warn(log->l_mp,
+				"INODE: bad format region length %zu recovered.",
+				len);
+			return -EFSCORRUPTED;
+		}
 		return 0;
+	}
 
-	if (len != sizeof(struct xfs_inode_log_format) &&
-	    len != sizeof(struct xfs_inode_log_format_32)) {
-		xfs_warn(log->l_mp,
-			"INODE: bad format region length %zu recovered.", len);
-		return -EFSCORRUPTED;
+	if (region_index == 1) {
+		if (len != xfs_log_dinode_size(log->l_mp)) {
+			xfs_warn(log->l_mp,
+				"INODE: bad core region length %zu recovered.",
+				len);
+			return -EFSCORRUPTED;
+		}
+		return 0;
 	}
 
 	return 0;
@@ -420,10 +609,11 @@ xlog_recover_inode_check_location(
 }
 
 /*
- * Validate the format header once it is in host format. The item size records
- * how many regions the item should have, the set of logged fields fixes what
- * that count must be, and the inode number fixes the buffer location, so all of
- * these are checked against the header here.
+ * Validate the format header once it is in host format, then the log dinode
+ * core it describes. The item size records how many regions the item should
+ * have, the set of logged fields fixes what that count must be, and the inode
+ * number fixes the buffer location, so all of these are checked against the
+ * header here.
  */
 static int
 xlog_recover_inode_validate_item(
@@ -431,6 +621,8 @@ xlog_recover_inode_validate_item(
 	struct xlog_recover_item	*item)
 {
 	struct xfs_inode_log_format	*ilfp;
+	struct xfs_log_dinode		*ldip;
+	xfs_failaddr_t			fa;
 	unsigned int			nregions;
 	int				error;
 
@@ -472,7 +664,20 @@ xlog_recover_inode_validate_item(
 		return -EFSCORRUPTED;
 	}
 
-	return xlog_recover_inode_check_location(log, ilfp);
+	error = xlog_recover_inode_check_location(log, ilfp);
+	if (error)
+		return error;
+
+	ldip = item->ri_buf[1].iov_base;
+	fa = xlog_dinode_verify(log->l_mp, ilfp->ilf_ino, ldip);
+	if (fa) {
+		xfs_warn(log->l_mp,
+			"INODE: inode 0x%llx log dinode failed validation at %pS",
+			ilfp->ilf_ino, fa);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
 }
 
 STATIC int
@@ -493,7 +698,6 @@ xlog_recover_inode_commit_pass2(
 	int				attr_index;
 	uint				fields;
 	struct xfs_log_dinode		*ldip;
-	uint				isize;
 	xfs_failaddr_t			fa;
 
 	/*
@@ -510,28 +714,8 @@ xlog_recover_inode_commit_pass2(
 			0, &bp, &xfs_inode_buf_ops);
 	if (error)
 		return error;
-	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
 	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
-
-	/*
-	 * Make sure the place we're flushing out to really looks
-	 * like an inode!
-	 */
-	if (XFS_IS_CORRUPT(mp, !xfs_verify_magic16(bp, dip->di_magic))) {
-		xfs_alert(mp,
-	"%s: Bad inode magic number, dip = "PTR_FMT", dino bp = "PTR_FMT", ino = %lld",
-			__func__, dip, bp, in_f->ilf_ino);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
 	ldip = item->ri_buf[1].iov_base;
-	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC)) {
-		xfs_alert(mp,
-			"%s: Bad inode log record, rec ptr "PTR_FMT", ino %lld",
-			__func__, item, in_f->ilf_ino);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
 
 	/*
 	 * If the inode has an LSN in it, recover the inode only if the on-disk
@@ -588,58 +772,6 @@ xlog_recover_inode_commit_pass2(
 	}
 
 
-	if (unlikely(S_ISREG(ldip->di_mode))) {
-		if (ldip->di_format != XFS_DINODE_FMT_EXTENTS &&
-		    ldip->di_format != XFS_DINODE_FMT_BTREE &&
-		    ldip->di_format != XFS_DINODE_FMT_META_BTREE) {
-			XFS_CORRUPTION_ERROR(
-				"Bad log dinode data fork format for regular file",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-			xfs_alert(mp,
-				"Bad inode 0x%llx, data fork format 0x%x",
-				in_f->ilf_ino, ldip->di_format);
-			error = -EFSCORRUPTED;
-			goto out_release;
-		}
-	} else if (unlikely(S_ISDIR(ldip->di_mode))) {
-		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
-		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
-			XFS_CORRUPTION_ERROR(
-				"Bad log dinode data fork format for directory",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-			xfs_alert(mp,
-				"Bad inode 0x%llx, data fork format 0x%x",
-				in_f->ilf_ino, ldip->di_format);
-			error = -EFSCORRUPTED;
-			goto out_release;
-		}
-	}
-
-	error = xlog_dinode_verify_extent_counts(mp, ldip);
-	if (error)
-		goto out_release;
-
-	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
-		XFS_CORRUPTION_ERROR("Bad log dinode fork offset",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-		xfs_alert(mp,
-			"Bad inode 0x%llx, di_forkoff 0x%x",
-			in_f->ilf_ino, ldip->di_forkoff);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
-	isize = xfs_log_dinode_size(mp);
-	if (unlikely(item->ri_buf[1].iov_len > isize)) {
-		XFS_CORRUPTION_ERROR("Bad log dinode size", XFS_ERRLEVEL_LOW,
-				     mp, ldip, sizeof(*ldip));
-		xfs_alert(mp,
-			"Bad inode 0x%llx log dinode size 0x%zx",
-			in_f->ilf_ino, item->ri_buf[1].iov_len);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
-
 	/*
 	 * Recover the log dinode inode into the on disk inode.
 	 *
-- 
2.55.0

