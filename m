Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA7C1B0425
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689223; cv=none; b=YV9iMvEfeHypk3JLu3hguXc3sYEoHElPgZ/eKuNS50tZsJRKlcGhxsj6cyECjOk0rGyyefjailU18xhFYv3sIKVMPDNTx56vifQBniJj6XGBcuJFnp0RGh4Y3mt0lwaW+HgxTlb2oeZgIWsAQ9tIpGDFDWiT3nQlXULcDiCS3KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689223; c=relaxed/simple;
	bh=tWCZS2jtY1yIgQCNdLu6jQtUt61/w2hguawMdZ3QOtU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OttkEm1+mRIqg0liLOBH+9f0iUsq4roV3miXHScDfUUZUhCzt+kDlTWLiiG1/zFlLLnXe3YUZGYYmR4hTD8qFH4tT/W/dNTp7POK0F90P3npwBcnhX7GxflFNREnWuzsNRLNon8FvSrlKh5lucKkl2+01KLh6ZHABWqHAKoa0mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ca9E2A/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ca9E2A/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75A4C4CED2;
	Tue, 31 Dec 2024 23:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689222;
	bh=tWCZS2jtY1yIgQCNdLu6jQtUt61/w2hguawMdZ3QOtU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ca9E2A/23cPXBHZvJR+Y9y4R9ehmXoPUwcc3eZ5kwX6QDOAhoEyQ4AM/d0saTCMrU
	 brSeiGxMLJTKWYIPTKXYRWC0Q931uiRxf+AxHUZUAX0aD8s8g8HlJAsOx5fRluU596
	 v0tIgnYnCXycW57QX2PDdxEE9D6jNurHsxehxg+T1gf7nCT8Jvnlla9cW90YGyZo54
	 X5+77kApiUsUM9/4f1fmyvEAUpjp4i4Sv9ao+RoMSLr2bNJEcDWIU/6351r0/dzUXo
	 Qal2CZ5eu+OTi5KxlqR27uBcVljG2r10ugCMnAyEmNanz7lEMUuHAjfRlh1NDWoHuZ
	 1iQjybdILv+Jg==
Date: Tue, 31 Dec 2024 15:53:42 -0800
Subject: [PATCH 02/10] xfs_repair: allow sysadmins to add reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779164.2710949.2907165533692467121.stgit@frogsfrogsfrogs>
In-Reply-To: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
References: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
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
 man/man8/xfs_admin.8 |    6 ++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   33 ++++++++++++++++++++++++++++++++-
 repair/rmap.c        |    6 +++---
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 54 insertions(+), 4 deletions(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index e07fc3ddb3fb82..3a9175c9f018e5 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -170,6 +170,12 @@ .SH OPTIONS
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
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 1bb7cd19025be7..9cd841f8d05fc6 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -200,7 +200,7 @@ set_exchrange(
 		exit(0);
 	}
 
-	if (!xfs_has_reflink(mp)) {
+	if (!xfs_has_reflink(mp) && !add_reflink) {
 		printf(
 	_("File exchange-range feature cannot be added without reflink.\n"));
 		exit(0);
@@ -234,6 +234,33 @@ set_finobt(
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
+	printf(_("Adding reflink support to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -402,6 +429,8 @@ need_check_fs_free_space(
 {
 	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
 		return true;
+	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
+		return true;
 	return false;
 }
 
@@ -481,6 +510,8 @@ upgrade_filesystem(
 		dirty |= set_exchrange(mp, &new_sb);
 	if (add_finobt)
 		dirty |= set_finobt(mp, &new_sb);
+	if (add_reflink)
+		dirty |= set_reflink(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 97510dd875911a..91f864351f6013 100644
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
 
@@ -1800,7 +1800,7 @@ check_refcounts(
 	struct xfs_perag		*pag = NULL;
 	int				error;
 
-	if (!xfs_has_reflink(mp))
+	if (!xfs_has_reflink(mp) || add_reflink)
 		return;
 	if (refcbt_suspect) {
 		if (no_modify && agno == 0)
@@ -1859,7 +1859,7 @@ check_rtrefcounts(
 	struct xfs_inode		*ip = NULL;
 	int				error;
 
-	if (!xfs_has_reflink(mp))
+	if (!xfs_has_reflink(mp) || add_reflink)
 		return;
 	if (refcbt_suspect) {
 		if (no_modify && rgno == 0)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d8f92b52b66f3a..e436dc2ef736d6 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -72,6 +72,7 @@ enum c_opt_nums {
 	CONVERT_NREXT64,
 	CONVERT_EXCHRANGE,
 	CONVERT_FINOBT,
+	CONVERT_REFLINK,
 	C_MAX_OPTS,
 };
 
@@ -82,6 +83,7 @@ static char *c_opts[] = {
 	[CONVERT_NREXT64]	= "nrext64",
 	[CONVERT_EXCHRANGE]	= "exchange",
 	[CONVERT_FINOBT]	= "finobt",
+	[CONVERT_REFLINK]	= "reflink",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -383,6 +385,15 @@ process_args(int argc, char **argv)
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

