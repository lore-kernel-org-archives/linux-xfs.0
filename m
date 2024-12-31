Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ED229415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689238; cv=none; b=rJbvoYZwaVVUk7bPMO7fmhY7G43/S54spckQTQglxRlOmkazl4BhXs2kwVSG+uUB0nMlJEBKBNAyaLUYEItQEDdzdtkObFGepMGs/Y+J1G03aZeYydCK7eUORSiKtdXYGXIjqzws7C+Nwl9c18h856LYX6XmI4A9tZI53aiqIP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689238; c=relaxed/simple;
	bh=hwj1M6YNC4bPowm3o9GHTAOpb3z1TWp0D3wj4VWAKj4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EjFnzUbPnCZceVdEUFtxFZ/qKjhhrMArkhI6z7prbJDUUVhghULG/FsmvvhBwAr4oOWCKMnyZN1a4xPY8We8kvisEySuy/zZGj98M3L15Jw/YsVVl1rr9yeAoUIeeLnJcRWMYxJQME3HXknZTeFO+ZShIqs6AX0mvlNCUqJeH94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HN7+mZ9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HN7+mZ9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8C1C4CED2;
	Tue, 31 Dec 2024 23:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689238;
	bh=hwj1M6YNC4bPowm3o9GHTAOpb3z1TWp0D3wj4VWAKj4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HN7+mZ9iJ0W9Ybro/lGGJaXPEFk9MvEE1u+p0yczRU6s3LWYCWjjWL2vneVo8uWhu
	 3X94VVIZn7aAEeUggEAEtWjbpMLVShYN7DWeOocWW843FOSBGVeiK8IRkUQm5yRJtj
	 qVAQnjzE0MuJ5pxJNNdeiA9CjgCbd6Jqy6flMkVmqNf2hUnQZlGsE7/K3jtmapcY3b
	 YQzP51edOirIuSfteQUUpd3d1ls5McOKaO1/RhIqFxWorn4oqf555WSsvmBu2Hjeo0
	 ieRlbI5SPs1TE934qMQZ20TGM6b/tJuWqY6CBjrwYVtZrxSHtbqOyG1XSx1457hLNJ
	 Xv9sb9y/gx1Bg==
Date: Tue, 31 Dec 2024 15:53:57 -0800
Subject: [PATCH 03/10] xfs_repair: allow sysadmins to add reverse mapping
 indexes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779179.2710949.12292387414126353408.stgit@frogsfrogsfrogs>
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
to support the reverse mapping btree index.  This is needed for online
fsck.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    8 ++++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   38 ++++++++++++++++++++++++++++++++++++++
 repair/rmap.c        |    6 +++---
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 62 insertions(+), 3 deletions(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 3a9175c9f018e5..74a400dcfeb557 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -176,6 +176,14 @@ .SH OPTIONS
 This upgrade can fail if any AG has less than 2% free space remaining.
 The filesystem cannot be downgraded after this feature is enabled.
 This feature was added to Linux 4.9.
+.TP 0.4i
+.B rmapbt
+Store an index of the owners of on-disk blocks.
+This enables much stronger cross-referencing of various metadata structures
+and online repairs to space usage metadata.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade can fail if any AG has less than 5% free space remaining.
+This feature was added to Linux 4.8.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index cf4421e34dec84..dd7c422bb922e4 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -55,6 +55,7 @@ bool	add_nrext64;
 bool	add_exchrange;		/* add file content exchange support */
 bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
+bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index efbb8db79bc080..d8c2aae23d8f0a 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -96,6 +96,7 @@ extern bool	add_nrext64;
 extern bool	add_exchrange;		/* add file content exchange support */
 extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
+extern bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 9cd841f8d05fc6..9dd37e7fc5c111 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -261,6 +261,40 @@ set_reflink(
 	return true;
 }
 
+static bool
+set_rmapbt(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (xfs_has_rmapbt(mp)) {
+		printf(_("Filesystem already supports reverse mapping btrees.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Reverse mapping btree feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_realtime(mp)) {
+		printf(
+	_("Reverse mapping btree feature not supported with realtime.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_reflink(mp) && !add_reflink) {
+		printf(
+	_("Reverse mapping btrees cannot be added when reflink is enabled.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding reverse mapping btrees to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -431,6 +465,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
 		return true;
+	if (xfs_has_rmapbt(mp) && !(old->features & XFS_FEAT_RMAPBT))
+		return true;
 	return false;
 }
 
@@ -512,6 +548,8 @@ upgrade_filesystem(
 		dirty |= set_finobt(mp, &new_sb);
 	if (add_reflink)
 		dirty |= set_reflink(mp, &new_sb);
+	if (add_rmapbt)
+		dirty |= set_rmapbt(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 91f864351f6013..f1f837d33ea4f4 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -69,7 +69,7 @@ rmap_needs_work(
 	struct xfs_mount	*mp)
 {
 	return xfs_has_reflink(mp) || add_reflink ||
-	       xfs_has_rmapbt(mp);
+	       xfs_has_rmapbt(mp) || add_rmapbt;
 }
 
 static inline bool rmaps_has_observations(const struct xfs_ag_rmap *ag_rmap)
@@ -1339,7 +1339,7 @@ rmaps_verify_btree(
 	struct xfs_perag	*pag = NULL;
 	int			error;
 
-	if (!xfs_has_rmapbt(mp))
+	if (!xfs_has_rmapbt(mp) || add_rmapbt)
 		return;
 	if (rmapbt_suspect) {
 		if (no_modify && agno == 0)
@@ -1398,7 +1398,7 @@ rtrmaps_verify_btree(
 	struct xfs_inode	*ip = NULL;
 	int			error;
 
-	if (!xfs_has_rmapbt(mp))
+	if (!xfs_has_rmapbt(mp) || add_rmapbt)
 		return;
 	if (rmapbt_suspect) {
 		if (no_modify && rgno == 0)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index e436dc2ef736d6..ca72c65f9d772a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -73,6 +73,7 @@ enum c_opt_nums {
 	CONVERT_EXCHRANGE,
 	CONVERT_FINOBT,
 	CONVERT_REFLINK,
+	CONVERT_RMAPBT,
 	C_MAX_OPTS,
 };
 
@@ -84,6 +85,7 @@ static char *c_opts[] = {
 	[CONVERT_EXCHRANGE]	= "exchange",
 	[CONVERT_FINOBT]	= "finobt",
 	[CONVERT_REFLINK]	= "reflink",
+	[CONVERT_RMAPBT]	= "rmapbt",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -394,6 +396,15 @@ process_args(int argc, char **argv)
 		_("-c reflink only supports upgrades\n"));
 					add_reflink = true;
 					break;
+				case CONVERT_RMAPBT:
+					if (!val)
+						do_abort(
+		_("-c rmapbt requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c rmapbt only supports upgrades\n"));
+					add_rmapbt = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

