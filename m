Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDE8D53F
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610609; cv=none; b=NbcnfojHW5c8CG68s+RhPev/Bfpjl1u1tCu9cU3MDwIb2fyYl0gQEPAvI75y1ZWeSl9a3m3AWSqNltpah++Kh8xEPWRSrC7nG/G1B+3Gxi+uFzotutkbU8eu+xjhBqoSrTRZiXVMWsf3/ObHSq1EQWFVpMzBI9dfvv6jpBtTQL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610609; c=relaxed/simple;
	bh=LKUsiU+DX29krwUfQWUMyVSRZzoJKUd1Qa5ftsKVXjg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OWK+oFLIlbJ7YSL2YqI5ImUmb7wSt0IfNfmbe6h3b1aV856SmYmdq3JKzrFbdj/3EAr7vv82B2UuR6oBpvREslsrID68JJAKl1Lfq5Umd7oBCIsLC4l/o08XSnV0XbSNGZExZih8gsfvaV7mzSJ4zw78/XoQvgN9e4hCHnP7BYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNqQtBgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNqQtBgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19685C4CEC5;
	Fri, 11 Oct 2024 01:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610609;
	bh=LKUsiU+DX29krwUfQWUMyVSRZzoJKUd1Qa5ftsKVXjg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oNqQtBgSFd+postyvCLS+Kp5lWV4qUvdVjntpDO1pHqSqdWG2UyH7X9W9Jrka6PQD
	 cMMUAi17aVwvmxMRGyvdCKvYkG9vKURmkCkqgLoA/clKFJORJJaZj60BIzo/43Lj8D
	 d25GQq+uBFPiNt9d0q5tHxpnFbP6cx3uxKoZvNGgW62lg/yw/+UxB0X+c//NxCb7pk
	 NDDxgowFYiyu/QthTYHz0YMaXJxgEB0ZWnxW9xDJbbD9UsKRWcPw3rDIwW1DjeuTi5
	 HW/oLalfbL3W7wlNZP8caRD4jQ1dM2PtiF9ciiNx2HYC1J+zFCAJToeNHJIgx5btRJ
	 9BZFZZmta1eOQ==
Date: Thu, 10 Oct 2024 18:36:48 -0700
Subject: [PATCH 4/7] xfs_repair: hoist the secondary sb qflags handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656434.4186076.312514024499676518.stgit@frogsfrogsfrogs>
In-Reply-To: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
References: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
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

Hoist all the secondary superblock qflags and quota inode modification
code into a separate function so that we can disable it in the next
patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |  157 +++++++++++++++++++++++++++++------------------------
 1 file changed, 85 insertions(+), 72 deletions(-)


diff --git a/repair/agheader.c b/repair/agheader.c
index da712eb6fef4d9..bc6c4579661bdd 100644
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

