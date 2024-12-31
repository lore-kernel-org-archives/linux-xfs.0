Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D645329415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689269; cv=none; b=hQW6b7WZvXFRBPZ+oGymy5XogQHUYjdWLZTGof5v0NSg6fZJKS2WUevZ2YFAZ640A0t1O48alAOVPKD1W3YgqAIM6wcC/TCCdS5tyWfNK6K1aaSN18oYXo2FgeIatfGa2m/A/r+JS+U0UppsUJkAlFLvgVOfxniRcHPI2P+se6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689269; c=relaxed/simple;
	bh=Z2k1uFxxqCk0yRK44uvnyAC0PsAJ+INECkDn8iiYlKI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sipgAFtZHIrDO2eMYI4GEuw5pbZdI95DpxozRYNVanPUoSyjwaR3S9bSRSW3woakG1TJGRuabSsOdy16qmoGAHNYXnY3Y18Kp4L9SSyxqpfPKQxk+IKJOd9hFMAd+KOsEn2V+HRj7mj3Qvoa45ydx2QxTEljSmbwCAmMivaMdL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVk5HNvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVk5HNvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD06BC4CED2;
	Tue, 31 Dec 2024 23:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689269;
	bh=Z2k1uFxxqCk0yRK44uvnyAC0PsAJ+INECkDn8iiYlKI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MVk5HNvH7f2Shi44XN2AcFJ2X+GEFcA1Lh5ModnE445RbRyddJwoOxm+WDIOqwtVS
	 Xmg0NJ/ypTB76pQTWp0no9/NBGXlkdpAlL8rfSTaQIDOOCj1tewEMCuM6Shnk/g8tD
	 8kGFpKF1TWco+oyXxztcGT/GxSsCxIJzTWeWF6pE6ephNJ8fuXSer8fTrjcRuAYXqr
	 ceE5o++rf7rNjAIEFGJ5v/n1TEBLrRor6Ciiv+MXKhFO7swmqOubcn78uFfNcg+Pui
	 tzNy+qW9UJLzAJy/sGf+xrARDfItbV0fp5NTJTHh2mkz18SRc6KOnl9L4wFuJnsci5
	 MLQ7wdKU6v3Lg==
Date: Tue, 31 Dec 2024 15:54:29 -0800
Subject: [PATCH 05/10] xfs_repair: allow sysadmins to add metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779210.2710949.14166489432103862989.stgit@frogsfrogsfrogs>
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
to support metadata directories.  This will be needed to upgrade
filesystems to support realtime rmap and reflink.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    8 ++++++
 repair/dino_chunks.c |    6 ++++
 repair/dinode.c      |    5 +++-
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/phase4.c      |    5 +++-
 repair/protos.h      |    6 ++++
 repair/xfs_repair.c  |   11 ++++++++
 9 files changed, 109 insertions(+), 3 deletions(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index a25e599e5f8e2c..e55dee6070e460 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -191,6 +191,14 @@ .SH OPTIONS
 directory tree.
 The filesystem cannot be downgraded after this feature is enabled.
 This upgrade can fail if the filesystem has less than 25% free space remaining.
+.TP 0.4i
+.B metadir
+Create a directory tree of metadata inodes instead of storing them all in the
+superblock.
+This is required for reverse mapping btrees and reflink support on the realtime
+device.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade can fail if any AG has less than 5% free space remaining.
 This feature is not upstream yet.
 .RE
 .TP
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 250985ec264ead..120c490b1d8324 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -955,7 +955,11 @@ process_inode_chunk(
 		}
 
 		if (status)  {
-			if (mp->m_sb.sb_rootino == ino) {
+			if (wipe_pre_metadir_file(ino)) {
+				if (!ino_discovery)
+					do_warn(
+	_("wiping pre-metadir metadata inode %"PRIu64".\n"), ino);
+			} else if (mp->m_sb.sb_rootino == ino) {
 				need_root_inode = 1;
 
 				if (!no_modify)  {
diff --git a/repair/dinode.c b/repair/dinode.c
index 0c559c40808588..42c7e9fa5cc5e7 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -3068,6 +3068,9 @@ process_dinode_int(
 	ASSERT(uncertain == 0 || verify_mode != 0);
 	ASSERT(ino_bpp != NULL || verify_mode != 0);
 
+	if (wipe_pre_metadir_file(lino))
+		goto clear_bad_out;
+
 	/*
 	 * This is the only valid point to check the CRC; after this we may have
 	 * made changes which invalidate it, and the CRC is only updated again
@@ -3278,7 +3281,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		if (flags & XFS_DIFLAG_NEWRTBM) {
 			/* must be a rt bitmap inode */
 			if (lino != mp->m_sb.sb_rbmino) {
-				if (!uncertain) {
+				if (!uncertain && !add_metadir) {
 					do_warn(
 	_("inode %" PRIu64 " not rt bitmap\n"),
 						lino);
diff --git a/repair/globals.c b/repair/globals.c
index 320fcf6cfd701e..603fea73da1654 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -57,6 +57,7 @@ bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
 bool	add_rmapbt;		/* add reverse mapping btrees */
 bool	add_parent;		/* add parent pointers */
+bool	add_metadir;		/* add metadata directory tree */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 77d5d110048713..9211e5e2432c9a 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -98,6 +98,7 @@ extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
 extern bool	add_rmapbt;		/* add reverse mapping btrees */
 extern bool	add_parent;		/* add parent pointers */
+extern bool	add_metadir;		/* add metadata directory tree */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 763cffdfe9d8d2..35f4c19de0555c 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -317,6 +317,71 @@ set_parent(
 	return true;
 }
 
+static xfs_ino_t doomed_rbmino = NULLFSINO;
+static xfs_ino_t doomed_rsumino = NULLFSINO;
+static xfs_ino_t doomed_uquotino = NULLFSINO;
+static xfs_ino_t doomed_gquotino = NULLFSINO;
+static xfs_ino_t doomed_pquotino = NULLFSINO;
+
+bool
+wipe_pre_metadir_file(
+	xfs_ino_t	ino)
+{
+	if (ino == doomed_rbmino ||
+	    ino == doomed_rsumino ||
+	    ino == doomed_uquotino ||
+	    ino == doomed_gquotino ||
+	    ino == doomed_pquotino)
+		return true;
+	return false;
+}
+
+static bool
+set_metadir(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (xfs_has_metadir(mp)) {
+		printf(_("Filesystem already supports metadata directory trees.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Metadata directory trees only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding metadata directory trees to filesystem.\n"));
+	new_sb->sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_METADIR |
+					 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
+
+	/* Blow out all the old metadata inodes; we'll rebuild in phase6. */
+	new_sb->sb_metadirino = new_sb->sb_rootino + 1;
+	doomed_rbmino = mp->m_sb.sb_rbmino;
+	doomed_rsumino = mp->m_sb.sb_rsumino;
+	doomed_uquotino = mp->m_sb.sb_uquotino;
+	doomed_gquotino = mp->m_sb.sb_gquotino;
+	doomed_pquotino = mp->m_sb.sb_pquotino;
+
+	new_sb->sb_rbmino = new_sb->sb_metadirino + 1;
+	new_sb->sb_rsumino = new_sb->sb_rbmino + 1;
+	new_sb->sb_uquotino = NULLFSINO;
+	new_sb->sb_gquotino = NULLFSINO;
+	new_sb->sb_pquotino = NULLFSINO;
+
+	/* Indicate that we need a rebuild. */
+	need_metadir_inode = 1;
+	need_rbmino = 1;
+	need_rsumino = 1;
+	have_uquotino = 0;
+	have_gquotino = 0;
+	have_pquotino = 0;
+	quotacheck_skip();
+
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -504,6 +569,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_parent(mp) && !(old->features & XFS_FEAT_PARENT))
 		return true;
+	if (xfs_has_metadir(mp) && !(old->features & XFS_FEAT_METADIR))
+		return true;
 	return false;
 }
 
@@ -589,6 +656,8 @@ upgrade_filesystem(
 		dirty |= set_rmapbt(mp, &new_sb);
 	if (add_parent)
 		dirty |= set_parent(mp, &new_sb);
+	if (add_metadir)
+		dirty |= set_metadir(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/phase4.c b/repair/phase4.c
index b752b4c871ea83..6d3c7857c6c343 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -431,7 +431,10 @@ phase4(xfs_mount_t *mp)
 	if (xfs_has_metadir(mp) &&
 	    (is_inode_free(irec, 1) || !inode_isadir(irec, 1))) {
 		need_metadir_inode = true;
-		if (no_modify)
+		if (add_metadir)
+			do_warn(
+	_("metadata directory root inode needs to be initialized\n"));
+		else if (no_modify)
 			do_warn(
 	_("metadata directory root inode would be lost\n"));
 		else
diff --git a/repair/protos.h b/repair/protos.h
index e2f39f1d6e8aa3..ce171f3dd87cb6 100644
--- a/repair/protos.h
+++ b/repair/protos.h
@@ -3,6 +3,8 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#ifndef __XFS_REPAIR_PROTOS_H__
+#define __XFS_REPAIR_PROTOS_H__
 
 void	xfs_init(struct libxfs_init *args);
 
@@ -45,3 +47,7 @@ void	phase7(struct xfs_mount *, int);
 int	verify_set_agheader(struct xfs_mount *, struct xfs_buf *,
 		struct xfs_sb *, struct xfs_agf *, struct xfs_agi *,
 		xfs_agnumber_t);
+
+bool wipe_pre_metadir_file(xfs_ino_t ino);
+
+#endif  /* __XFS_REPAIR_PROTOS_H__ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 189665a07d6892..d4101f7d2297d7 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -75,6 +75,7 @@ enum c_opt_nums {
 	CONVERT_REFLINK,
 	CONVERT_RMAPBT,
 	CONVERT_PARENT,
+	CONVERT_METADIR,
 	C_MAX_OPTS,
 };
 
@@ -88,6 +89,7 @@ static char *c_opts[] = {
 	[CONVERT_REFLINK]	= "reflink",
 	[CONVERT_RMAPBT]	= "rmapbt",
 	[CONVERT_PARENT]	= "parent",
+	[CONVERT_METADIR]	= "metadir",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -416,6 +418,15 @@ process_args(int argc, char **argv)
 		_("-c parent only supports upgrades\n"));
 					add_parent = true;
 					break;
+				case CONVERT_METADIR:
+					if (!val)
+						do_abort(
+		_("-c metadir requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c metadir only supports upgrades\n"));
+					add_metadir = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

