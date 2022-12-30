Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED16CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbiLaCUa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiLaCU2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:20:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FEA13F62
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D55EB61C19
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4664EC433D2;
        Sat, 31 Dec 2022 02:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453227;
        bh=FpfttMk5mkzO809Jzf3NWnHyP10fBtSYL1BRD0pD2Pw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eZOf1nsXkB3VC2ufTEWaaL1tTsXrhGl+6rG9oAzy11JzcBa+4mpCq5rijOlDzy4G/
         AhUTCN1ZucnAh0tLOoZdFy4y8OxeQKQdDXB3EoTaoODTJX8aORAf63Ye7smG5tpYTm
         WKVkcEVRUo6ejNp/oj+ivTJd03l0A2zTL3RwVA96h3eSGOQVFztHhOynOJsU1jJtZR
         5HFWOfMF7Obgmkp/bIblNmVQqAGEbrV0CtLQqZIEBOsZlgE6wRZ0CamtDOwEjqc3FL
         1E2Tp5BNL5PGMszeRFdNLhL2uE3rKyIreTACGmAC68jeMiTPbZhFOyrMidg9ATosGO
         Y+55gekVzwynw==
Subject: [PATCH 41/46] xfs_repair: reattach quota inodes to metadata directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876468.725900.132855500688710108.stgit@magnolia>
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

If the quota inodes came through unscathed, we should attach them to
the new metadata directory so that phase 7 can run quotacheck on them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index b3ad4074ff8..c440c2293d1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3489,6 +3489,117 @@ update_missing_dotdot_entries(
 	}
 }
 
+static int
+reattach_quota_inode(
+	struct xfs_mount		*mp,
+	xfs_ino_t			ino,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_update		upd;
+	struct xfs_inode		*ip;
+	struct xfs_trans		*tp;
+	unsigned int			resblks;
+	int				error;
+
+	error = ensure_imeta_dirpath(mp, path);
+	if (error) {
+		do_warn(
+_("Couldn't create quota metadata directory, error %d\n"), error);
+		return error;
+	}
+
+	error = -libxfs_imeta_start_update(mp, path, &upd);
+	if (error) {
+		do_warn(
+_("Couldn't start metadata directory update -- error - %d\n"),
+			ENOMEM);
+		return error;
+	}
+
+	error = -libxfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+	if (error) {
+		do_warn(
+_("Couldn't grab quota inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+		goto cleanup;
+	}
+
+	resblks = libxfs_imeta_create_space_res(mp);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			resblks, 0, 0, &tp);
+	if (error) {
+		do_warn(
+_("Couldn't allocate transaction to attach quota inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+		goto rele;
+	}
+
+	error = -libxfs_imeta_link(tp, path, ip, &upd);
+	if (error) {
+		do_warn(
+_("Couldn't link quota inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+		libxfs_trans_cancel(tp);
+		goto rele;
+	}
+
+	set_nlink(VFS_I(ip), 1);
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = -libxfs_trans_commit(tp);
+	if (error) {
+		do_warn(
+_("Couldn't commit quota inode 0x%llx reattachment transaction, error %d\n"),
+				(unsigned long long)ino, error);
+	}
+
+rele:
+	libxfs_irele(ip);
+cleanup:
+	libxfs_imeta_end_update(mp, &upd, error);
+	return error;
+}
+
+/*
+ * Reattach quota inodes to the metadata directory if we rebuilt the metadata
+ * directory tree.
+ */
+static inline void
+reattach_metadir_quota_inodes(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	if (!xfs_has_metadir(mp) || no_modify)
+		return;
+
+	if (mp->m_sb.sb_uquotino != NULLFSINO) {
+		error = reattach_quota_inode(mp, mp->m_sb.sb_uquotino,
+				&XFS_IMETA_USRQUOTA);
+		if (error) {
+			mp->m_sb.sb_uquotino = NULLFSINO;
+			lost_uquotino = 1;
+		}
+	}
+
+	if (mp->m_sb.sb_gquotino != NULLFSINO) {
+		error = reattach_quota_inode(mp, mp->m_sb.sb_gquotino,
+				&XFS_IMETA_GRPQUOTA);
+		if (error) {
+			mp->m_sb.sb_gquotino = NULLFSINO;
+			lost_gquotino = 1;
+		}
+	}
+
+	if (mp->m_sb.sb_pquotino != NULLFSINO) {
+		error = reattach_quota_inode(mp, mp->m_sb.sb_pquotino,
+				&XFS_IMETA_PRJQUOTA);
+		if (error) {
+			mp->m_sb.sb_pquotino = NULLFSINO;
+			lost_pquotino = 1;
+		}
+	}
+}
+
 static void
 traverse_ags(
 	struct xfs_mount	*mp)
@@ -3572,6 +3683,8 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 		}
 	}
 
+	reattach_metadir_quota_inodes(mp);
+
 	mark_standalone_inodes(mp);
 
 	do_log(_("        - traversing filesystem ...\n"));

