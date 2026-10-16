Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF183C2B92
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179510; cv=none; b=YNYAIrMmkMfLW0dIvg1rwH71qyVpQsGVQ0igTN+3ZP7J8lMalORQdBw0Lx1An6DhvXUG73RFnDpkMCWfTosQaQvxjXAkMi7MAnwn6nFlLrIJ3EV7aEJEAx8gnJY3M3ArCyUba4GjNQqAhlSKJFXZROV4QU0+htlBB/2yxs+dSeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179510; c=relaxed/simple;
	bh=fT1F1yt0lpGYOCi5FcPaRW68mOrDGfsRYz3A6rmqxDE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QZjTB9dHYIOoFERBKqM9leCJaO6vjDAtu2p/DvdAJaGRqM0ljOlVXfvyLfQjayY33qMjoJzMSOvh7jgMSdvckifMIn3YpfGEvxVnXs/7CBykbwUPx0D1vTuH8EV4B9Wj5AuyzjjoFuSbAwAxR/pevUQcifgYcvc57Xnzca8XtSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZXF5+N3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZXF5+N3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C0BAC1F000C4;
	Fri, 16 Oct 2026 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179502;
	bh=NNW27QNY/DAIhDrg85h+SXQMy0Z9qR9NymYXTAGuogo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=SZXF5+N3La8x0J9uxAb/Qny1fSpDTpWbarZrCX87begu+qK7e4kvIJxATrVDx8EhN
	 74CH1ifI1Rn5fix2saN7xdyhnpDiUsBUPTXpkAfZeHRbrokj0W/kjTJCQSFhu/oBOQ
	 AAKe1aYNCOi3yGV4t1iwhXcsK1NN4abet9DJPN3FA9Y0mJl/kje0qECVD2HGLiVGRM
	 MlD7rftciQIxiq3lX1JzqLvxXXEa8c7L9AirQ3E06gityQ5mhvKUSai3P0bCMjnHg8
	 wPE50otuGqPiFfohIkXWc7Hbr148dFS11sxMazJHFsBgC03jbvMgKhPrVLmXyWAqr9
	 BugrwVhY1Ou7A==
Date: Fri, 16 Oct 2026 12:38:22 -0700
Subject: [PATCH 02/10] xfs_repair: allow sysadmins to add reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942773.717548.4125932751684649785.stgit@frogsfrogsfrogs>
In-Reply-To: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
References: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the reference count btree, and therefore reflink.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/globals.h     |    1 +
 man/man8/xfs_admin.8 |    6 ++++++
 repair/globals.c     |    1 +
 repair/phase2.c      |   38 +++++++++++++++++++++++++++++++++++++-
 repair/rmap.c        |    6 +++---
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 59 insertions(+), 4 deletions(-)


diff --git a/repair/globals.h b/repair/globals.h
index c5b27d9a60cf2e..efbb8db79bc080 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -95,6 +95,7 @@ extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_nrext64;
 extern bool	add_exchrange;		/* add file content exchange support */
 extern bool	add_finobt;		/* add free inode btrees */
+extern bool	add_reflink;		/* add reference count btrees */
 
 /* misc status variables */
 
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 1cf3d3d6aed721..20ca6d2fee9483 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -178,6 +178,12 @@ .SH OPTIONS
 This upgrade can fail if any AG has less than 1% free space remaining.
 The filesystem cannot be downgraded after this feature is enabled.
 This feature was added to Linux 3.16.
+.TP 0.4i
+.B reflink
+Enable sharing of file data blocks.
+This upgrade can fail if any AG has less than 2% free space remaining.
+The filesystem cannot be downgraded after this feature is enabled.
+This feature was added to Linux 4.9.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index f13497c3121d6b..cf4421e34dec84 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -54,6 +54,7 @@ bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_nrext64;
 bool	add_exchrange;		/* add file content exchange support */
 bool	add_finobt;		/* add free inode btrees */
+bool	add_reflink;		/* add reference count btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index caedd51ff28aa7..d308087aab9568 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -202,7 +202,7 @@ set_exchrange(
 		exit(0);
 	}
 
-	if (!xfs_has_reflink(mp)) {
+	if (!xfs_has_reflink(mp) && !add_reflink) {
 		printf(
 	_("File exchange-range feature cannot be added without reflink.\n"));
 		exit(0);
@@ -236,6 +236,38 @@ set_finobt(
 	return true;
 }
 
+static bool
+set_reflink(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (xfs_has_reflink(mp)) {
+		printf(_("Filesystem already supports reflink.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Reflink feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_realtime(mp)) {
+		printf(_("Reflink feature not supported with realtime.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_realtime(mp) && mp->m_sb.sb_rextsize > 1) {
+		printf(_("Reflink not supported for rt extent size > 1.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding reflink support to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -400,6 +432,8 @@ need_check_fs_free_space(
 {
 	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
 		return true;
+	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
+		return true;
 	return false;
 }
 
@@ -479,6 +513,8 @@ upgrade_filesystem(
 		dirty |= set_exchrange(mp, &new_sb);
 	if (add_finobt)
 		dirty |= set_finobt(mp, &new_sb);
+	if (add_reflink)
+		dirty |= set_reflink(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 9f824f848edcc8..803731632f6b5f 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -68,7 +68,7 @@ bool
 rmap_needs_work(
 	struct xfs_mount	*mp)
 {
-	return xfs_has_reflink(mp) ||
+	return xfs_has_reflink(mp) || add_reflink ||
 	       xfs_has_rmapbt(mp);
 }
 
@@ -1798,7 +1798,7 @@ check_refcounts(
 	struct xfs_perag		*pag = NULL;
 	int				error;
 
-	if (!xfs_has_reflink(mp))
+	if (!xfs_has_reflink(mp) || add_reflink)
 		return;
 	if (refcbt_suspect) {
 		if (no_modify && agno == 0)
@@ -1857,7 +1857,7 @@ check_rtrefcounts(
 	struct xfs_inode		*ip = NULL;
 	int				error;
 
-	if (!xfs_has_reflink(mp))
+	if (!xfs_has_reflink(mp) || add_reflink)
 		return;
 	if (refcbt_suspect) {
 		if (no_modify && rgno == 0)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index b87227d388276c..89daaa34867d14 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -73,6 +73,7 @@ enum c_opt_nums {
 	CONVERT_NREXT64,
 	CONVERT_EXCHRANGE,
 	CONVERT_FINOBT,
+	CONVERT_REFLINK,
 	C_MAX_OPTS,
 };
 
@@ -83,6 +84,7 @@ static char *c_opts[] = {
 	[CONVERT_NREXT64]	= "nrext64",
 	[CONVERT_EXCHRANGE]	= "exchange",
 	[CONVERT_FINOBT]	= "finobt",
+	[CONVERT_REFLINK]	= "reflink",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -384,6 +386,15 @@ process_args(int argc, char **argv)
 		_("-c finobt only supports upgrades\n"));
 					add_finobt = true;
 					break;
+				case CONVERT_REFLINK:
+					if (!val)
+						do_abort(
+		_("-c reflink requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c reflink only supports upgrades\n"));
+					add_reflink = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

