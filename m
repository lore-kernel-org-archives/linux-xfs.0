Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78159433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992767; cv=none; b=X2d6yn8sJb+ZWBhrg/TTkT6s3ZGD4upzKL18CW9VG8reQMXUO0Wpl1/ryqD/EGJAocCDWTuaxZ6dqizaDfFAst80A0n3VgC3u1eVNacu0hsJGpjRXiJRAY51hAQHZ4qSHPf9VAezbzJ8y/utpv13NHrkjzgh8Flp6zLQD8iDWQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992767; c=relaxed/simple;
	bh=UW4bsNqLFHmYt8byI5YLQPulvEg+oPiNlkqUYEY3+is=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EKnyCntkKxYBw9hDbYKj79SFPhNtRtoEpAIA4CKsqjn9eSGMwDFd2xyIpChqKZuOnWnux/C1L+AechPk9T68as0UyQYF/ht+iPKkdLh9A4W9yurv3KwAX8B1xMlMP3LtL4RC+lcBO3n5a/w2TMNQ10KDIo5OJaC/QM5w3OqyW0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4x2uSL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4x2uSL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB372C4CED3;
	Mon, 23 Dec 2024 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992766;
	bh=UW4bsNqLFHmYt8byI5YLQPulvEg+oPiNlkqUYEY3+is=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T4x2uSL4h6M7B+G5+i4z3JDk1BOZAnTGFDa4gxhg+zdfESutsf+aC/i1PFRjdZJ3m
	 Kr7mnBAhmXCs5ryabAerBegfGcj5h+nBFZ66val4eC2uVY2KSo+1dsUlrVfhQ/p7l2
	 taQZj10+A6pu/r0H3vO1Mh9bekO/DOXzOVaoIjDuwGh2oa7MKZTqLI1VfVGPQVojz/
	 4zymvkPba6kdR4xyMkQ2/PLWwIcYxfZnqSImIwB5HddO31JnmOKp2jcdDPEjaYIwDh
	 zGxBiu/VzndAWpx4qN1kx23Zduz83flSbshAqWaw8hd8AYQjlONG3g3KDl7rjhBFg5
	 LQQU2vsuIbXoQ==
Date: Mon, 23 Dec 2024 14:26:06 -0800
Subject: [PATCH 4/7] xfs_repair: hoist the secondary sb qflags handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498945030.2299261.13963685796531975269.stgit@frogsfrogsfrogs>
In-Reply-To: <173498944956.2299261.16768993427453132101.stgit@frogsfrogsfrogs>
References: <173498944956.2299261.16768993427453132101.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

