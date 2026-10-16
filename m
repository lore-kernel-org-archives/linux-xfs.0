Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C62A3B6346
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179559; cv=none; b=C0GfGbkuAakU8BLLk2hHbrhJegzUMIA/Ibxk/GBkktfrf4vepiBsfoTm4ZHnGWgZmzhIQoysn2IDIaXhH1/Ex2T2ss7nI2KvLewdbCeM3GYynPhEpAQUwcYiPkqEnS1wrGm3aSKS7BOTsmaID59mExBqMMenB+f3ABSUXRZBQIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179559; c=relaxed/simple;
	bh=niDVan77EvJBO7WgF4F38+OoV2aHgIaFuTxe+8BHDaE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tb+NVXZ5fJ36vTv2VzM7LU+ZI8mtVb1++Munhl3D6V8Ru5kPDFkN/GRmAhP9Bd5vPjf5Ur0pNh4H++sIZhfmDl5PYuuPS4V7lPwBeCz+LpkEKl6lbHqxS58lpDNm9pxr1b1tKbWOQKjQPjQggxaeJNShzVg+JFJG8PdYmgJjX+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvOvzeEj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvOvzeEj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BB7B81F000C4;
	Fri, 16 Oct 2026 19:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179549;
	bh=+QDfemSvkncPGF9Y0bzeLO4Qm/gj48j4Gcv9cCnnlJo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hvOvzeEj6ZZgJ6SQblfUXTdvWEeksTUWvDGYa1NqXB6do5o79SJpv7AEMV9ib5bbV
	 yTL5k4F3u5k+cxLY9Vee4O+C+6jksD2cnRcN8fkvRnEMHPNWbHgsyXwftzjqRd/cA6
	 PtJf+ydwlbPG5vXvy6Iynp+Tq/nvoAuujYKip3FTnp3ubRKgNVLJMB+46gsQykamhA
	 bLZW5fW8izyYgtWgN5ZUOghgyDF0FLmVEX+LyqmtKwAtUlwhSBk9a4yulN+HvX2Zdx
	 fdE4RqgSmpZE4yqBJiaI3uZqJPQB+5H2RVQNzSPNiTJf+GehPvC39wM77JpPl8jflp
	 g+88MQaKfMCbQ==
Date: Fri, 16 Oct 2026 12:39:09 -0700
Subject: [PATCH 05/10] xfs_repair: allow sysadmins to add metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942829.717548.8471085869352510431.stgit@frogsfrogsfrogs>
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
to support metadata directories.  This will be needed to upgrade
filesystems to support realtime rmap and reflink.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/globals.h     |    1 +
 repair/protos.h      |    6 ++++
 man/man8/xfs_admin.8 |    8 ++++++
 repair/dino_chunks.c |    6 ++++
 repair/dinode.c      |    5 +++-
 repair/globals.c     |    1 +
 repair/phase2.c      |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/phase4.c      |    5 +++-
 repair/xfs_repair.c  |   11 ++++++++
 9 files changed, 109 insertions(+), 3 deletions(-)


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
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index edb22544d4276a..8973df722ad6e0 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -199,6 +199,14 @@ .SH OPTIONS
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
index 6b261a1e99bf0f..23bbbc6c6d63c3 100644
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
index 05292f16d6ae22..e5b248c03e1bd1 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -3071,6 +3071,9 @@ process_dinode_int(
 	ASSERT(uncertain == 0 || verify_mode != 0);
 	ASSERT(ino_bpp != NULL || verify_mode != 0);
 
+	if (wipe_pre_metadir_file(lino))
+		goto clear_bad_out;
+
 	/*
 	 * This is the only valid point to check the CRC; after this we may have
 	 * made changes which invalidate it, and the CRC is only updated again
@@ -3280,7 +3283,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
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
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 600901e5b5f106..7d245c100b494f 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -324,6 +324,71 @@ set_parent(
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
+	clear_quota_inode(XFS_DQTYPE_USER);
+	clear_quota_inode(XFS_DQTYPE_GROUP);
+	clear_quota_inode(XFS_DQTYPE_PROJ);
+	quotacheck_skip();
+
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -507,6 +572,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_parent(mp) && !(old->features & XFS_FEAT_PARENT))
 		return true;
+	if (xfs_has_metadir(mp) && !(old->features & XFS_FEAT_METADIR))
+		return true;
 	return false;
 }
 
@@ -592,6 +659,8 @@ upgrade_filesystem(
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
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 2337f707cc24dc..dd27672f874f26 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -76,6 +76,7 @@ enum c_opt_nums {
 	CONVERT_REFLINK,
 	CONVERT_RMAPBT,
 	CONVERT_PARENT,
+	CONVERT_METADIR,
 	C_MAX_OPTS,
 };
 
@@ -89,6 +90,7 @@ static char *c_opts[] = {
 	[CONVERT_REFLINK]	= "reflink",
 	[CONVERT_RMAPBT]	= "rmapbt",
 	[CONVERT_PARENT]	= "parent",
+	[CONVERT_METADIR]	= "metadir",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -417,6 +419,15 @@ process_args(int argc, char **argv)
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

