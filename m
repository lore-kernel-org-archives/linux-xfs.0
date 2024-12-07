Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E2E4A1C
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530743; cv=none; b=orQq/4vK+C9eUXwGwivu0p9RiTYPa3XOOxDic8FIaLhrKxhvH81nICmZEd4jmJBrKAlbHgDhAc6EK9Zgrm0f+O+OwW8RxcmBj3ai0EFSBz0qFEVVk7Zp30VR07vrU1ILLi4UGpMRyOvFDHe/QJdsz+Yw40WrmM22bpbByW5OiPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530743; c=relaxed/simple;
	bh=05RybQkomPUSxlOULRYuitna7fvlIX40uS6tMMN899g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lv5i+gC/etvRNsPlwSd7gNCfgHyYuKg/eiW6uSKuQ3PMB1T1rI3yETf2Zj9dtvO3Z5Oqipdrky2BjR/klIGFOVUTIAmF74A1Fjk3CviODC8rmRIVpzCLY0kJ++ZDgN/CwLIGWaz8Ny8zErhejBO/WFyvlNCWd4tOEC/x7QPq2Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQytojDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQytojDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFC7C4CED1;
	Sat,  7 Dec 2024 00:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530742;
	bh=05RybQkomPUSxlOULRYuitna7fvlIX40uS6tMMN899g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PQytojDAM0gZfWDM/7eoCQzgsKaRg7l8+4BsNf2MBfvYEOtOBMo5gULC6zcoiMwGJ
	 K3ILbM9Xnen4tvmd2+eNu2kF7fPIoKh4R3ZR+WohmKQQMD3SBuB0LWcNyb2zgVq9av
	 Hz/jhIb+iEOSct1ZFAK0C0ENFSFAByrpbWuk/52Ha2Nxg1e/MY3uNI+/JpYg+WtnoM
	 6dr08+w24PnkJMXwyY4xRdDgN3QVTCOJyT5YJq21fTkR0hCAn4Ylw0XEpQYP+b43Ug
	 NYqGt/OCRRmHtPVuC76hANW0JZ1VT1pvr5h6umRp+PgakGpyXaf067aH7ZDATPqLcR
	 0oZ2QJlH5k5hg==
Date: Fri, 06 Dec 2024 16:19:02 -0800
Subject: [PATCH 4/7] xfs_repair: hoist the secondary sb qflags handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352753294.129683.12319167915814901490.stgit@frogsfrogsfrogs>
In-Reply-To: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Hoist all the secondary superblock qflags and quota inode modification
code into a separate function so that we can disable it in the next
patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/agheader.c |  157 +++++++++++++++++++++++++++++------------------------
 1 file changed, 85 insertions(+), 72 deletions(-)


diff --git a/repair/agheader.c b/repair/agheader.c
index fd279559aed973..4a530fd6b8fe96 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -319,6 +319,90 @@ check_v5_feature_mismatch(
 	return XR_AG_SB_SEC;
 }
 
+/*
+ * quota inodes and flags in secondary superblocks are never set by mkfs.
+ * However, they could be set in a secondary if a fs with quotas was growfs'ed
+ * since growfs copies the new primary into the secondaries.
+ *
+ * Also, the in-core inode flags now have different meaning to the on-disk
+ * flags, and so libxfs_sb_to_disk cannot directly write the
+ * sb_gquotino/sb_pquotino fields without specific sb_qflags being set.  Hence
+ * we need to zero those fields directly in the sb buffer here.
+ */
+static int
+secondary_sb_quota(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*sbuf,
+	struct xfs_sb		*sb,
+	xfs_agnumber_t		i,
+	int			do_bzero)
+{
+	struct xfs_dsb		*dsb = sbuf->b_addr;
+	int			rval = 0;
+
+	if (sb->sb_inprogress == 1 && sb->sb_uquotino != NULLFSINO)  {
+		if (!no_modify)
+			sb->sb_uquotino = 0;
+		if (!do_bzero)  {
+			rval |= XR_AG_SB;
+			do_warn(
+		_("non-null user quota inode field in superblock %d\n"),
+				i);
+
+		} else
+			rval |= XR_AG_SB_SEC;
+	}
+
+	if (sb->sb_inprogress == 1 && sb->sb_gquotino != NULLFSINO)  {
+		if (!no_modify) {
+			sb->sb_gquotino = 0;
+			dsb->sb_gquotino = 0;
+		}
+		if (!do_bzero)  {
+			rval |= XR_AG_SB;
+			do_warn(
+		_("non-null group quota inode field in superblock %d\n"),
+				i);
+
+		} else
+			rval |= XR_AG_SB_SEC;
+	}
+
+	/*
+	 * Note that sb_pquotino is not considered a valid sb field for pre-v5
+	 * superblocks. If it is anything other than 0 it is considered garbage
+	 * data beyond the valid sb and explicitly zeroed above.
+	 */
+	if (xfs_has_pquotino(mp) &&
+	    sb->sb_inprogress == 1 && sb->sb_pquotino != NULLFSINO)  {
+		if (!no_modify) {
+			sb->sb_pquotino = 0;
+			dsb->sb_pquotino = 0;
+		}
+		if (!do_bzero)  {
+			rval |= XR_AG_SB;
+			do_warn(
+		_("non-null project quota inode field in superblock %d\n"),
+				i);
+
+		} else
+			rval |= XR_AG_SB_SEC;
+	}
+
+	if (sb->sb_inprogress == 1 && sb->sb_qflags)  {
+		if (!no_modify)
+			sb->sb_qflags = 0;
+		if (!do_bzero)  {
+			rval |= XR_AG_SB;
+			do_warn(_("non-null quota flags in superblock %d\n"),
+				i);
+		} else
+			rval |= XR_AG_SB_SEC;
+	}
+
+	return rval;
+}
+
 /*
  * Possible fields that may have been set at mkfs time,
  * sb_inoalignmt, sb_unit, sb_width and sb_dirblklog.
@@ -340,7 +424,6 @@ secondary_sb_whack(
 	struct xfs_sb	*sb,
 	xfs_agnumber_t	i)
 {
-	struct xfs_dsb	*dsb = sbuf->b_addr;
 	int		do_bzero = 0;
 	int		size;
 	char		*ip;
@@ -426,77 +509,7 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
-	/*
-	 * quota inodes and flags in secondary superblocks are never set by
-	 * mkfs.  However, they could be set in a secondary if a fs with quotas
-	 * was growfs'ed since growfs copies the new primary into the
-	 * secondaries.
-	 *
-	 * Also, the in-core inode flags now have different meaning to the
-	 * on-disk flags, and so libxfs_sb_to_disk cannot directly write the
-	 * sb_gquotino/sb_pquotino fields without specific sb_qflags being set.
-	 * Hence we need to zero those fields directly in the sb buffer here.
-	 */
-
-	if (sb->sb_inprogress == 1 && sb->sb_uquotino != NULLFSINO)  {
-		if (!no_modify)
-			sb->sb_uquotino = 0;
-		if (!do_bzero)  {
-			rval |= XR_AG_SB;
-			do_warn(
-		_("non-null user quota inode field in superblock %d\n"),
-				i);
-
-		} else
-			rval |= XR_AG_SB_SEC;
-	}
-
-	if (sb->sb_inprogress == 1 && sb->sb_gquotino != NULLFSINO)  {
-		if (!no_modify) {
-			sb->sb_gquotino = 0;
-			dsb->sb_gquotino = 0;
-		}
-		if (!do_bzero)  {
-			rval |= XR_AG_SB;
-			do_warn(
-		_("non-null group quota inode field in superblock %d\n"),
-				i);
-
-		} else
-			rval |= XR_AG_SB_SEC;
-	}
-
-	/*
-	 * Note that sb_pquotino is not considered a valid sb field for pre-v5
-	 * superblocks. If it is anything other than 0 it is considered garbage
-	 * data beyond the valid sb and explicitly zeroed above.
-	 */
-	if (xfs_has_pquotino(mp) &&
-	    sb->sb_inprogress == 1 && sb->sb_pquotino != NULLFSINO)  {
-		if (!no_modify) {
-			sb->sb_pquotino = 0;
-			dsb->sb_pquotino = 0;
-		}
-		if (!do_bzero)  {
-			rval |= XR_AG_SB;
-			do_warn(
-		_("non-null project quota inode field in superblock %d\n"),
-				i);
-
-		} else
-			rval |= XR_AG_SB_SEC;
-	}
-
-	if (sb->sb_inprogress == 1 && sb->sb_qflags)  {
-		if (!no_modify)
-			sb->sb_qflags = 0;
-		if (!do_bzero)  {
-			rval |= XR_AG_SB;
-			do_warn(_("non-null quota flags in superblock %d\n"),
-				i);
-		} else
-			rval |= XR_AG_SB_SEC;
-	}
+	rval |= secondary_sb_quota(mp, sbuf, sb, i, do_bzero);
 
 	/*
 	 * if the secondaries agree on a stripe unit/width or inode

