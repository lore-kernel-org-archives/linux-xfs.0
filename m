Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D509C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiLaCVR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbiLaCVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:21:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9C119C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:21:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CF1B61C61
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92FBC433D2;
        Sat, 31 Dec 2022 02:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453274;
        bh=2IqOGQ/I9rLR9UOHbEVA+McF0l2FeuE4CcmbYX7rUwY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OijyDcuSsDXres9DXZZmU+ATxwnCot2YS8b25LYEIfdJYP6lhIK1QbJacPx969Rsy
         neIL+tszwuiDhNl5Q6MUGTccXvErjkb9R2qZcLftN4u76xmXCYvMaB3yJmsGEDFBPg
         XCltL/Vx9u5/8iK3+as9L44XIHKc5OmgSLOxlBTpIj0zLuzRrv9Sftgy+YRF5XnPkx
         6kJ4TAio7HaJgSIEiUZZfKYpOV3YIOzCKSXC3XvDCTPLEORA8UxpFymDmpNelR/1oZ
         UVcTyWfSZvkcbHlWGj1npjQsihnvK86l0UDecYd7/lZzo5x8i/vv8bjv3B4TVCT1pb
         ga7FO3Yy0mLwA==
Subject: [PATCH 44/46] xfs_repair: allow sysadmins to add metadata directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:25 -0800
Message-ID: <167243876507.725900.3964018435064440628.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support metadata directories.  This will be needed to upgrade
filesystems to support realtime rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    9 +++++++
 repair/dino_chunks.c |    6 ++++
 repair/dinode.c      |    5 +++-
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/phase4.c      |    5 +++-
 repair/protos.h      |    6 ++++
 repair/xfs_repair.c  |   11 ++++++++
 9 files changed, 110 insertions(+), 3 deletions(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 467fb2dfd0a..f9c53235e7b 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -177,6 +177,15 @@ and online repairs to space usage metadata.
 The filesystem cannot be downgraded after this feature is enabled.
 This upgrade can fail if any AG has less than 5% free space remaining.
 This feature was added to Linux 4.8.
+.TP 0.4i
+.B metadir
+Create a directory tree of metadata inodes instead of storing them all in the
+superblock.
+This is required for reverse mapping btrees and reflink support on the realtime
+device.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade can fail if any AG has less than 5% free space remaining.
+This feature is not upstream yet.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 382196cc170..c68d92a4d88 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -962,7 +962,11 @@ process_inode_chunk(
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
index 5c1f07d5bc1..cc2c3474634 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2415,6 +2415,9 @@ process_dinode_int(
 	ASSERT(uncertain == 0 || verify_mode != 0);
 	ASSERT(ino_bpp != NULL || verify_mode != 0);
 
+	if (wipe_pre_metadir_file(lino))
+		goto clear_bad_out;
+
 	/*
 	 * This is the only valid point to check the CRC; after this we may have
 	 * made changes which invalidate it, and the CRC is only updated again
@@ -2624,7 +2627,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		if (flags & XFS_DIFLAG_NEWRTBM) {
 			/* must be a rt bitmap inode */
 			if (lino != mp->m_sb.sb_rbmino) {
-				if (!uncertain) {
+				if (!uncertain && !add_metadir) {
 					do_warn(
 	_("inode %" PRIu64 " not rt bitmap\n"),
 						lino);
diff --git a/repair/globals.c b/repair/globals.c
index c731d6bdff1..3200342e9f1 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -55,6 +55,7 @@ bool	add_nrext64;
 bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
 bool	add_rmapbt;		/* add reverse mapping btrees */
+bool	add_metadir;		/* add metadata directory tree */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 6bd4be20cb1..e51f4e7ece4 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -96,6 +96,7 @@ extern bool	add_nrext64;
 extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
 extern bool	add_rmapbt;		/* add reverse mapping btrees */
+extern bool	add_metadir;		/* add metadata directory tree */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 77324a976a1..707fe5ca519 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -14,6 +14,7 @@
 #include "incore.h"
 #include "progress.h"
 #include "scan.h"
+#include "quotacheck.h"
 
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
@@ -286,6 +287,70 @@ set_rmapbt(
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
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Metadata directory trees only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_metadir(mp)) {
+		printf(_("Filesystem already supports metadata directory trees.\n"));
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
@@ -459,6 +524,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_rmapbt(mp) && !(old->features & XFS_FEAT_RMAPBT))
 		return true;
+	if (xfs_has_metadir(mp) && !(old->features & XFS_FEAT_METADIR))
+		return true;
 	return false;
 }
 
@@ -540,6 +607,8 @@ upgrade_filesystem(
 		dirty |= set_reflink(mp, &new_sb);
 	if (add_rmapbt)
 		dirty |= set_rmapbt(mp, &new_sb);
+	if (add_metadir)
+		dirty |= set_metadir(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/phase4.c b/repair/phase4.c
index 5721647863a..28ecf56f45b 100644
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
index 83e471ff2ad..20618bb2bc2 100644
--- a/repair/protos.h
+++ b/repair/protos.h
@@ -3,6 +3,8 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#ifndef __XFS_REPAIR_PROTOS_H__
+#define __XFS_REPAIR_PROTOS_H__
 
 void	xfs_init(libxfs_init_t *args);
 
@@ -45,3 +47,7 @@ void	phase7(struct xfs_mount *, int);
 int	verify_set_agheader(struct xfs_mount *, struct xfs_buf *,
 		struct xfs_sb *, struct xfs_agf *, struct xfs_agi *,
 		xfs_agnumber_t);
+
+bool wipe_pre_metadir_file(xfs_ino_t ino);
+
+#endif  /* __XFS_REPAIR_PROTOS_H__ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index fe3fe341530..92dc0fb2d9f 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -72,6 +72,7 @@ enum c_opt_nums {
 	CONVERT_FINOBT,
 	CONVERT_REFLINK,
 	CONVERT_RMAPBT,
+	CONVERT_METADIR,
 	C_MAX_OPTS,
 };
 
@@ -83,6 +84,7 @@ static char *c_opts[] = {
 	[CONVERT_FINOBT]	= "finobt",
 	[CONVERT_REFLINK]	= "reflink",
 	[CONVERT_RMAPBT]	= "rmapbt",
+	[CONVERT_METADIR]	= "metadir",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -369,6 +371,15 @@ process_args(int argc, char **argv)
 		_("-c rmapbt only supports upgrades\n"));
 					add_rmapbt = true;
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

