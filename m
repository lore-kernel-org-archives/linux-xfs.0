Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00136C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbiLaCCg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCCf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:02:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F63E2AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:02:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F5CF61C5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7602FC433EF;
        Sat, 31 Dec 2022 02:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452153;
        bh=xNhE/0wPZqS0LUNMz3Yo96SQYPSGYrTirrMGNu/FyVk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bW6F38L0OjwUE+MmHEe1GNQCF+d3WOuwRG4o0ePKXhdTOAAmxfQAlilS+uLn85q7s
         AaPMdZklLLmG/j4ZE9NKOdeV/o/4hralZ7XTUQ9gDi0aOs67E9X0js0iHL0e59XlIV
         MZ/gWK+hJ15CbWWQJTvEXcKWRNLJqd35X5bIxF/lx0PLgOpgDVu4fBuFsb1fuvX7b6
         EOuGIUT203+T0cwy5ewQRfn9EpMB55LuBoMCdIt3L/qinY3BKATCPw+tzuK/vKeu+f
         hS5WOfOWjarL6Z/bbkUeIC8dThXKE62a9LV9sGsXGESQkT0T0vadjCq/BR7rgJwg9S
         rubFYIrvrKozQ==
Subject: [PATCH 2/4] xfs_repair: allow sysadmins to add free inode btree
 indexes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:10 -0800
Message-ID: <167243875006.722663.7398630779865539391.stgit@magnolia>
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
to support the free inode btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    7 +++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   26 ++++++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 46 insertions(+)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 4794d6774ed..efe2ce45fc2 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -156,6 +156,13 @@ data fork extent count will be 2^48 - 1, while the maximum attribute fork
 extent count will be 2^32 - 1. The filesystem cannot be downgraded after this
 feature is enabled. Once enabled, the filesystem will not be mountable by
 older kernels.  This feature was added to Linux 5.19.
+.TP 0.4i
+.B finobt
+Track free inodes through a separate free inode btree index to speed up inode
+allocation on old filesystems.
+This upgrade can fail if any AG has less than 1% free space remaining.
+The filesystem cannot be downgraded after this feature is enabled.
+This feature was added to Linux 3.16.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index c40849853b8..9640877b703 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -52,6 +52,7 @@ bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_nrext64;
+bool	add_finobt;		/* add free inode btrees */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index b65e4a2d09c..d7539294b5f 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -93,6 +93,7 @@ extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_nrext64;
+extern bool	add_finobt;		/* add free inode btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index cdfc98bf39f..29bc0e34363 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -203,6 +203,28 @@ set_nrext64(
 	return true;
 }
 
+static bool
+set_finobt(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Free inode btree feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_finobt(mp)) {
+		printf(_("Filesystem already supports free inode btrees.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding free inode btrees to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FINOBT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -370,6 +392,8 @@ need_check_fs_free_space(
 	struct xfs_mount		*mp,
 	const struct check_state	*old)
 {
+	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
+		return true;
 	return false;
 }
 
@@ -445,6 +469,8 @@ upgrade_filesystem(
 		dirty |= set_bigtime(mp, &new_sb);
 	if (add_nrext64)
 		dirty |= set_nrext64(mp, &new_sb);
+	if (add_finobt)
+		dirty |= set_finobt(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 8e62533ac53..45130ab7559 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -69,6 +69,7 @@ enum c_opt_nums {
 	CONVERT_INOBTCOUNT,
 	CONVERT_BIGTIME,
 	CONVERT_NREXT64,
+	CONVERT_FINOBT,
 	C_MAX_OPTS,
 };
 
@@ -77,6 +78,7 @@ static char *c_opts[] = {
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[CONVERT_BIGTIME]	= "bigtime",
 	[CONVERT_NREXT64]	= "nrext64",
+	[CONVERT_FINOBT]	= "finobt",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -336,6 +338,15 @@ process_args(int argc, char **argv)
 		_("-c nrext64 only supports upgrades\n"));
 					add_nrext64 = true;
 					break;
+				case CONVERT_FINOBT:
+					if (!val)
+						do_abort(
+		_("-c finobt requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c finobt only supports upgrades\n"));
+					add_finobt = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

