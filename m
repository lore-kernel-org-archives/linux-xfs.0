Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B042EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbiLaCDH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:03:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FAA2AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:03:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 349F661C19
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F9AC433D2;
        Sat, 31 Dec 2022 02:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452184;
        bh=DHnerPUVTyjGmT0BwgsEUrhd6LdXnfv56/E/F5novNI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YsMfswCy6kj/X8Idyb1IFLkWtEQhGhhW7qYHxU3u8RVmtyoRq3Jj1A1gjhxJ3ZLW8
         IpGkkCW938gKOXJ+qDaWZPuo6uMMBOMrXTRRDvnjYOUexDg7hnNlXtjH3mUKbFBnlu
         SguYDRGnSoywb2LIrTTdkGl2KqwCTYrmIB44hHtcdvmYWW2e8ipfL4apFvH/qDLQV2
         PGMX2guFVMKIM3p0NRLK0IsOY4ChszjBsppdqAsmfjhqoYsu3GiuRURrC5YSgeBVUg
         cEWg6/yJpnYZ5PzLb0OuEaI2squ01VXcCzw3diZgohDZo2xoBTZuIkxuxarjhpKSW8
         nuipE/y+U74JQ==
Subject: [PATCH 4/4] xfs_repair: allow sysadmins to add reverse mapping
 indexes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:10 -0800
Message-ID: <167243875033.722663.8414500476421147864.stgit@magnolia>
In-Reply-To: <167243874979.722663.18268822003736829003.stgit@magnolia>
References: <167243874979.722663.18268822003736829003.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the reverse mapping btree index.  This is needed for online
fsck.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    8 ++++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   38 ++++++++++++++++++++++++++++++++++++++
 repair/rmap.c        |    4 ++--
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 61 insertions(+), 2 deletions(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 3af201cadc3..467fb2dfd0a 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -169,6 +169,14 @@ Enable sharing of file data blocks.
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
index f5b5269c5d9..ec11bc67139 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -54,6 +54,7 @@ bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_nrext64;
 bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
+bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index d42c4d3c6a5..d5a04a75d41 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -95,6 +95,7 @@ extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_nrext64;
 extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
+extern bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index d968b4fd558..05964b3d23c 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -252,6 +252,40 @@ set_reflink(
 	return true;
 }
 
+static bool
+set_rmapbt(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
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
+	if (xfs_has_reflink(mp)) {
+		printf(
+	_("Reverse mapping btrees cannot be added when reflink is enabled.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_rmapbt(mp)) {
+		printf(_("Filesystem already supports reverse mapping btrees.\n"));
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
@@ -423,6 +457,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
 		return true;
+	if (xfs_has_rmapbt(mp) && !(old->features & XFS_FEAT_RMAPBT))
+		return true;
 	return false;
 }
 
@@ -502,6 +538,8 @@ upgrade_filesystem(
 		dirty |= set_finobt(mp, &new_sb);
 	if (add_reflink)
 		dirty |= set_reflink(mp, &new_sb);
+	if (add_rmapbt)
+		dirty |= set_rmapbt(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/rmap.c b/repair/rmap.c
index e49cd2364ec..00381c6e69d 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -52,7 +52,7 @@ rmap_needs_work(
 	struct xfs_mount	*mp)
 {
 	return xfs_has_reflink(mp) || add_reflink ||
-	       xfs_has_rmapbt(mp);
+	       xfs_has_rmapbt(mp) || add_rmapbt;
 }
 
 /* Destroy an in-memory rmap btree. */
@@ -1159,7 +1159,7 @@ rmaps_verify_btree(
 	int			have;
 	int			error;
 
-	if (!xfs_has_rmapbt(mp))
+	if (!xfs_has_rmapbt(mp) || add_rmapbt)
 		return;
 	if (rmapbt_suspect) {
 		if (no_modify && agno == 0)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 90da0d0e956..c461bc8eb07 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -71,6 +71,7 @@ enum c_opt_nums {
 	CONVERT_NREXT64,
 	CONVERT_FINOBT,
 	CONVERT_REFLINK,
+	CONVERT_RMAPBT,
 	C_MAX_OPTS,
 };
 
@@ -81,6 +82,7 @@ static char *c_opts[] = {
 	[CONVERT_NREXT64]	= "nrext64",
 	[CONVERT_FINOBT]	= "finobt",
 	[CONVERT_REFLINK]	= "reflink",
+	[CONVERT_RMAPBT]	= "rmapbt",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -358,6 +360,15 @@ process_args(int argc, char **argv)
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

