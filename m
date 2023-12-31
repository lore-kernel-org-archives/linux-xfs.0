Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8BFC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfnjkpws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD9DC433C7;
	Sun, 31 Dec 2023 23:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066251;
	bh=naFiO2vNv4eV9q40+NcPsxOXkvHeZjEkR8Wd4jwYU7Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gfnjkpwsaiv+seJiDnf3oivYH4gVZASPm6vVDKrZE14ZuhhtMK55VdvmiFDTnBFCq
	 id5u8MdE4gvziqhhMVd1RIOfKTE5FRyWFu3qpIQ3mYDWRr+72GimlI2IBM0HYMflmz
	 lugnXia3kC6glV2fQzG/FTaKIhZIEGXvx/G/KZXVxN+3bVNb5kUq04a7EKYa3+Doic
	 4TSf57VqajOPWcKHXCKjJWVUC912DtkbQdAAyiUuc/0BBrQNKz7GDfNN49cyFW+FnL
	 K6RbVjl1SE0pw2qSoMD7QVEmRoxl6snpzGo4TItBOe5qBVbZFo61X9rEYU6j4lggOs
	 S/kSKUBt2xOSQ==
Date: Sun, 31 Dec 2023 15:44:11 -0800
Subject: [PATCH 56/58] xfs_repair: allow sysadmins to add metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010694.1809361.8213815600295286861.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support metadata directories.  This will be needed to upgrade
filesystems to support realtime rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
index 28f28b6dd8f..68b4bf62427 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -184,6 +184,14 @@ This enables much stronger cross-referencing and online repairs of the
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
index a7f9ea70ca7..d132556d9dc 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -960,7 +960,11 @@ process_inode_chunk(
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
index 5c9101fa0b0..5a57069c29e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2422,6 +2422,9 @@ process_dinode_int(
 	ASSERT(uncertain == 0 || verify_mode != 0);
 	ASSERT(ino_bpp != NULL || verify_mode != 0);
 
+	if (wipe_pre_metadir_file(lino))
+		goto clear_bad_out;
+
 	/*
 	 * This is the only valid point to check the CRC; after this we may have
 	 * made changes which invalidate it, and the CRC is only updated again
@@ -2631,7 +2634,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		if (flags & XFS_DIFLAG_NEWRTBM) {
 			/* must be a rt bitmap inode */
 			if (lino != mp->m_sb.sb_rbmino) {
-				if (!uncertain) {
+				if (!uncertain && !add_metadir) {
 					do_warn(
 	_("inode %" PRIu64 " not rt bitmap\n"),
 						lino);
diff --git a/repair/globals.c b/repair/globals.c
index 22cb096c6a4..e3b2697127f 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -56,6 +56,7 @@ bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
 bool	add_rmapbt;		/* add reverse mapping btrees */
 bool	add_parent;		/* add parent pointers */
+bool	add_metadir;		/* add metadata directory tree */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index c3709f11874..1c24e313b89 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -97,6 +97,7 @@ extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
 extern bool	add_rmapbt;		/* add reverse mapping btrees */
 extern bool	add_parent;		/* add parent pointers */
+extern bool	add_metadir;		/* add metadata directory tree */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 5a08cbc31c6..cc7ddad8240 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -14,6 +14,7 @@
 #include "incore.h"
 #include "progress.h"
 #include "scan.h"
+#include "quotacheck.h"
 
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
@@ -287,6 +288,70 @@ set_parent(
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
+	new_sb->sb_rbmino = NULLFSINO;
+	new_sb->sb_rsumino = NULLFSINO;
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
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -475,6 +540,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_parent(mp) && !(old->features & XFS_FEAT_PARENT))
 		return true;
+	if (xfs_has_metadir(mp) && !(old->features & XFS_FEAT_METADIR))
+		return true;
 	return false;
 }
 
@@ -558,6 +625,8 @@ upgrade_filesystem(
 		dirty |= set_rmapbt(mp, &new_sb);
 	if (add_parent)
 		dirty |= set_parent(mp, &new_sb);
+	if (add_metadir)
+		dirty |= set_metadir(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/phase4.c b/repair/phase4.c
index e8bd5982147..cfdea1460e5 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -272,7 +272,10 @@ phase4(xfs_mount_t *mp)
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
index e2f39f1d6e8..ce171f3dd87 100644
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
index fe24f66ab98..bab8aa70f7a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -73,6 +73,7 @@ enum c_opt_nums {
 	CONVERT_REFLINK,
 	CONVERT_RMAPBT,
 	CONVERT_PARENT,
+	CONVERT_METADIR,
 	C_MAX_OPTS,
 };
 
@@ -85,6 +86,7 @@ static char *c_opts[] = {
 	[CONVERT_REFLINK]	= "reflink",
 	[CONVERT_RMAPBT]	= "rmapbt",
 	[CONVERT_PARENT]	= "parent",
+	[CONVERT_METADIR]	= "metadir",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -380,6 +382,15 @@ process_args(int argc, char **argv)
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

