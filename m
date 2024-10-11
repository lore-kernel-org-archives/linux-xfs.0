Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01407464
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607766; cv=none; b=JH5PAMF+6OdAqtE31dr+jOODGB1ZK7jhiEP5ArV8uaHhi+7wlpK9H+0zEQMN6esFi0McjA7nF1Jr+xZSqFVSnDYwBCwmacBiWehZAgb2iZq775VBi0eYrZXfTd4mDvT85dj4fBAeqVn1tDkCZBvjO+7otejMv0HbBsM2fX5OCFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607766; c=relaxed/simple;
	bh=SeI8jYJAWrV2QUVnmcDoq9GjJjBsWSB/5KcIMjI8ecg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BB7f8vRiXd0ecklpbiym/xms/q1Wf1DRK72uU9CVk3ikeZjrxelDeUVLSgRqv/rcOtPgYOrLx48UPpKR/9Z9gOLOqdEmFmTJe+cA1oR7nYOrDjJgF9p3dgaoUWrsFRiH34De9MZPGNnFyquFZ8bXZ4516ugDU1XB6eKXcg1ECD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BoyB1Zyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoyB1Zyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8532C4CEC5;
	Fri, 11 Oct 2024 00:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607765;
	bh=SeI8jYJAWrV2QUVnmcDoq9GjJjBsWSB/5KcIMjI8ecg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BoyB1ZydjeSW7kz6wjJQ+pa6l5VnA5pq8XT+00Ri2RHq+JAgIIOn9S8GfozFO9wTP
	 N/Uu1WlF59ZzKmEjee+R+JpdpHrysGTzyLcfcDsybiRooIcypChMRfu5jsJ+z1ryrG
	 grAJCtOkUgoaczrxHtKiywIreBOzQwYW0du5Xfo8IoHwqcYJvAuyDMV7PEYroxSkgW
	 awl08ZjUGsdOYWAGg2MoavRfkZBL32aB0P0Pyfrj967lzouMEitP8PszsAAjzRzs+T
	 g2W84lB8jz40Ky33f8BhVUT5L3aYsSYwK92fkPLmpFzFoeSqJDad3Ht4d1iGZOlOUH
	 N9HFwNrjgWq1w==
Date: Thu, 10 Oct 2024 17:49:25 -0700
Subject: [PATCH 04/28] xfs: undefine the sb_bad_features2 when metadir is
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642083.4176876.2034736773059229041.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

The metadir feature is a good opportunity to break from the past where
we had to do this strange dance with sb_bad_features2 due to a past bug
where the superblock was not kept aligned to a multiple of 8 bytes.

Therefore, stop this pretense when metadir is enabled.  We'll just set
the incore and ondisk fields to zero, thereby freeing up 4 bytes of
space in the superblock.  We'll reuse those 4 bytes later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |   73 ++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_sb.c     |   27 +++++++++++++---
 fs/xfs/scrub/agheader.c    |    9 ++++-
 3 files changed, 75 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2ff2c3c71d3780..c035d8a45d6ffc 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -148,16 +148,25 @@ typedef struct xfs_sb {
 	uint32_t	sb_logsunit;	/* stripe unit size for the log */
 	uint32_t	sb_features2;	/* additional feature bits */
 
-	/*
-	 * bad features2 field as a result of failing to pad the sb structure to
-	 * 64 bits. Some machines will be using this field for features2 bits.
-	 * Easiest just to mark it bad and not use it for anything else.
-	 *
-	 * This is not kept up to date in memory; it is always overwritten by
-	 * the value in sb_features2 when formatting the incore superblock to
-	 * the disk buffer.
-	 */
-	uint32_t	sb_bad_features2;
+	union {
+		/*
+		 * bad features2 field as a result of failing to pad the sb
+		 * structure to 64 bits. Some machines will be using this field
+		 * for features2 bits.  Easiest just to mark it bad and not use
+		 * it for anything else.
+		 *
+		 * This is not kept up to date in memory; it is always
+		 * overwritten by the value in sb_features2 when formatting the
+		 * incore superblock to the disk buffer.
+		 */
+		uint32_t	sb_bad_features2;
+
+		/*
+		 * Metadir filesystems define this field to be zero since they
+		 * have never had this 64-bit alignment problem.
+		 */
+		uint32_t	sb_metadirpad;
+	} __packed;
 
 	/* version 5 superblock fields start here */
 
@@ -238,13 +247,22 @@ struct xfs_dsb {
 	__be16		sb_logsectsize;	/* sector size for the log, bytes */
 	__be32		sb_logsunit;	/* stripe unit size for the log */
 	__be32		sb_features2;	/* additional feature bits */
-	/*
-	 * bad features2 field as a result of failing to pad the sb
-	 * structure to 64 bits. Some machines will be using this field
-	 * for features2 bits. Easiest just to mark it bad and not use
-	 * it for anything else.
-	 */
-	__be32		sb_bad_features2;
+
+	union {
+		/*
+		 * bad features2 field as a result of failing to pad the sb
+		 * structure to 64 bits. Some machines will be using this field
+		 * for features2 bits. Easiest just to mark it bad and not use
+		 * it for anything else.
+		 */
+		__be32		sb_bad_features2;
+
+		/*
+		 * Metadir filesystems define this field to be zero since they
+		 * have never had this 64-bit alignment problem.
+		 */
+		__be32		sb_metadirpad;
+	} __packed;
 
 	/* version 5 superblock fields start here */
 
@@ -287,15 +305,6 @@ static inline bool xfs_sb_is_v5(const struct xfs_sb *sbp)
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
-/*
- * Detect a mismatched features2 field.  Older kernels read/wrote
- * this into the wrong slot, so to be safe we keep them in sync.
- */
-static inline bool xfs_sb_has_mismatched_features2(const struct xfs_sb *sbp)
-{
-	return sbp->sb_bad_features2 != sbp->sb_features2;
-}
-
 static inline bool xfs_sb_version_hasmorebits(const struct xfs_sb *sbp)
 {
 	return xfs_sb_is_v5(sbp) ||
@@ -437,6 +446,18 @@ static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
 	       (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
 }
 
+/*
+ * Detect a mismatched features2 field.  Older kernels read/wrote
+ * this into the wrong slot, so to be safe we keep them in sync.
+ * Newer metadir filesystems have never had this bug, so the field is always
+ * zero.
+ */
+static inline bool xfs_sb_has_mismatched_features2(const struct xfs_sb *sbp)
+{
+	return !xfs_sb_version_hasmetadir(sbp) &&
+		sbp->sb_bad_features2 != sbp->sb_features2;
+}
+
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 {
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 0be67f77bec0d1..81b3a6e02e19b4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -401,6 +401,15 @@ xfs_validate_sb_common(
 				return -EINVAL;
 			}
 		}
+
+		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
+			if (sbp->sb_metadirpad) {
+				xfs_warn(mp,
+"Metadir superblock padding field (%d) must be zero.",
+						sbp->sb_metadirpad);
+				return -EINVAL;
+			}
+		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
@@ -668,7 +677,6 @@ __xfs_sb_from_disk(
 	to->sb_logsectsize = be16_to_cpu(from->sb_logsectsize);
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
-	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
 	to->sb_features_compat = be32_to_cpu(from->sb_features_compat);
 	to->sb_features_ro_compat = be32_to_cpu(from->sb_features_ro_compat);
 	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
@@ -692,10 +700,13 @@ __xfs_sb_from_disk(
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
 
-	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
 		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
-	else
+		to->sb_metadirpad = be32_to_cpu(from->sb_metadirpad);
+	} else {
 		to->sb_metadirino = NULLFSINO;
+		to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+	}
 }
 
 void
@@ -825,9 +836,11 @@ xfs_sb_to_disk(
 	 * Hence we enforce that here rather than having to remember to do it
 	 * everywhere else that updates features2.
 	 */
-	from->sb_bad_features2 = from->sb_features2;
 	to->sb_features2 = cpu_to_be32(from->sb_features2);
-	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
+	if (!xfs_sb_version_hasmetadir(from)) {
+		from->sb_bad_features2 = from->sb_features2;
+		to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
+	}
 
 	if (!xfs_sb_is_v5(from))
 		return;
@@ -844,8 +857,10 @@ xfs_sb_to_disk(
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 
-	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
 		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
+		to->sb_metadirpad = 0;
+	}
 }
 
 /*
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index f8e5b67128d25a..0d50bb0289654a 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -274,8 +274,13 @@ xchk_superblock(
 		if (!!(sb->sb_features2 & cpu_to_be32(~v2_ok)))
 			xchk_block_set_corrupt(sc, bp);
 
-		if (sb->sb_features2 != sb->sb_bad_features2)
-			xchk_block_set_preen(sc, bp);
+		if (xfs_has_metadir(mp)) {
+			if (sb->sb_metadirpad)
+				xchk_block_set_preen(sc, bp);
+		} else {
+			if (sb->sb_features2 != sb->sb_bad_features2)
+				xchk_block_set_preen(sc, bp);
+		}
 	}
 
 	/* Check sb_features2 flags that are set at mkfs time. */

