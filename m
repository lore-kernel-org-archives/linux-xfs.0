Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A16C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiLaCCv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCCu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:02:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269342AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:02:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 968D061C5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D95C433EF;
        Sat, 31 Dec 2022 02:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452169;
        bh=INwBsCBdEDHfVginERbzo4PmJFTsK3PtfdqDLqOu3R8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=irwSdBev+wpKACV5MeqrjEGTpNT9o4mOXh5sLMn3/OurrNuPvUycCLvrWYK7Fef3r
         DXdl6Dz9klfJkc/xiIquMfjToj7x6KYc+A1JBZArchESp3+BJMI9AhZs+nqRkGh2Jq
         xOf1lcQy7rRhKiVJnsUDKYytpL/NtXbcv1Nux+xXY5QdE7dNIpKODh/ZhDTqkM/anI
         PilwB1UlMFDLiGIapZ0JIeDBqxgTnN5u9V4aThx44rIObl9Vxp/dKxj4R3bcM6ebM6
         RmRDuDW3bggko2wEq0gms6GRqhgAw0BaDR8iEyx4h+1Xz/HCp6kEjQGjtAjeHZuIMF
         js5X3V1rt0NJg==
Subject: [PATCH 3/4] xfs_repair: allow sysadmins to add reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:10 -0800
Message-ID: <167243875019.722663.10085738495791757356.stgit@magnolia>
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
to support the reference count btree, and therefore reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    6 ++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   31 +++++++++++++++++++++++++++++++
 repair/rmap.c        |    4 ++--
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index efe2ce45fc2..3af201cadc3 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -163,6 +163,12 @@ allocation on old filesystems.
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
index 9640877b703..f5b5269c5d9 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -53,6 +53,7 @@ bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_nrext64;
 bool	add_finobt;		/* add free inode btrees */
+bool	add_reflink;		/* add reference count btrees */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index d7539294b5f..d42c4d3c6a5 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -94,6 +94,7 @@ extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_nrext64;
 extern bool	add_finobt;		/* add free inode btrees */
+extern bool	add_reflink;		/* add reference count btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 29bc0e34363..d968b4fd558 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -225,6 +225,33 @@ set_finobt(
 	return true;
 }
 
+static bool
+set_reflink(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Reflink feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_reflink(mp)) {
+		printf(_("Filesystem already supports reflink.\n"));
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
@@ -394,6 +421,8 @@ need_check_fs_free_space(
 {
 	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
 		return true;
+	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
+		return true;
 	return false;
 }
 
@@ -471,6 +500,8 @@ upgrade_filesystem(
 		dirty |= set_nrext64(mp, &new_sb);
 	if (add_finobt)
 		dirty |= set_finobt(mp, &new_sb);
+	if (add_reflink)
+		dirty |= set_reflink(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/rmap.c b/repair/rmap.c
index f8294cc3e13..e49cd2364ec 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -51,7 +51,7 @@ bool
 rmap_needs_work(
 	struct xfs_mount	*mp)
 {
-	return xfs_has_reflink(mp) ||
+	return xfs_has_reflink(mp) || add_reflink ||
 	       xfs_has_rmapbt(mp);
 }
 
@@ -1529,7 +1529,7 @@ check_refcounts(
 	int				i;
 	int				error;
 
-	if (!xfs_has_reflink(mp))
+	if (!xfs_has_reflink(mp) || add_reflink)
 		return;
 	if (refcbt_suspect) {
 		if (no_modify && agno == 0)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 45130ab7559..90da0d0e956 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -70,6 +70,7 @@ enum c_opt_nums {
 	CONVERT_BIGTIME,
 	CONVERT_NREXT64,
 	CONVERT_FINOBT,
+	CONVERT_REFLINK,
 	C_MAX_OPTS,
 };
 
@@ -79,6 +80,7 @@ static char *c_opts[] = {
 	[CONVERT_BIGTIME]	= "bigtime",
 	[CONVERT_NREXT64]	= "nrext64",
 	[CONVERT_FINOBT]	= "finobt",
+	[CONVERT_REFLINK]	= "reflink",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -347,6 +349,15 @@ process_args(int argc, char **argv)
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

