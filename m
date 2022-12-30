Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A98C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbiLaDEc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbiLaDEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:04:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D256515816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8501BB81EA2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E24C433D2;
        Sat, 31 Dec 2022 03:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455857;
        bh=ba9xC7GprnhoQZxS+IP1MdYIlLSt3LvmNU417aThjr0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PkeLHRW2vaBn/zExwwS3B/MKj88pOpqtzs6KHM4V2I+e+B1B5TmtFnO613f6cZKw8
         c6fgENN+PJ1YFTnQDh0JMuvm9kSxXFqe39JcgAfQ5g6XAFFpn+oNrHJzmns+bzFlZs
         naP6eJPziiUDK4f5iWG/JvVZ4SgCugf8EWoeL3Hkh5mq8uF6+GCd0ayAxSm6hWpAHN
         tALWHjmfRaycy1kM/0YNEPN2doOZ1AQQ9nLzRi/8rqIXX1m9AFCv6rzFmx3dTTO/9G
         CZ1cSoedhFSrSZQJQ3k69mn2MceZ1yG6MANMWAAbFOptmmSy72RPMTC9ifhkh6RzUH
         ueOGKojKuKlxg==
Subject: [PATCH 39/41] xfs_repair: allow sysadmins to add realtime reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:12 -0800
Message-ID: <167243881286.734096.10789662941013004371.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the realtime reference count btree, and therefore reflink on
realtime volumes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase2.c          |   75 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 5c7396a53a6..63607cf2b94 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -251,6 +251,7 @@
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
 
 #define xfs_rtrefcountbt_absolute_maxlevels	libxfs_rtrefcountbt_absolute_maxlevels
+#define xfs_rtrefcountbt_calc_reserves	libxfs_rtrefcountbt_calc_reserves
 #define xfs_rtrefcountbt_commit_staged_btree	libxfs_rtrefcountbt_commit_staged_btree
 #define xfs_rtrefcountbt_create		libxfs_rtrefcountbt_create
 #define xfs_rtrefcountbt_create_path	libxfs_rtrefcountbt_create_path
diff --git a/repair/phase2.c b/repair/phase2.c
index 35c1214be9a..ded281e4b88 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -242,14 +242,19 @@ set_reflink(
 		exit(0);
 	}
 
-	if (xfs_has_realtime(mp)) {
-		printf(_("Reflink feature not supported with realtime.\n"));
+	if (xfs_has_realtime(mp) && !xfs_has_rtgroups(mp)) {
+		printf(_("Reference count btree requires realtime groups.\n"));
 		exit(0);
 	}
 
 	printf(_("Adding reflink support to filesystem.\n"));
 	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+
+	/* Quota counts will be wrong once we add the refcount inodes. */
+	if (xfs_has_realtime(mp))
+		quotacheck_skip();
+
 	return true;
 }
 
@@ -462,6 +467,55 @@ reserve_rtrmap_inode(
 	return -libxfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
 }
 
+/*
+ * Reserve space to handle rt refcount btree expansion.
+ *
+ * If the refcount inode for this group already exists, we assume that we're
+ * adding some other feature.  Note that we have not validated the metadata
+ * directory tree, so we must perform the lookup by hand and abort the upgrade
+ * if there are errors.  If the inode does not exist, the amount of space
+ * needed to handle a new maximally sized refcount btree is added to @new_resv.
+ */
+static int
+reserve_rtrefcount_inode(
+	struct xfs_rtgroup	*rtg,
+	xfs_rfsblock_t		*new_resv)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
+	xfs_ino_t		ino;
+	xfs_filblks_t		ask;
+	int			error;
+
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	error = -libxfs_rtrefcountbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		return error;
+
+	ask = libxfs_rtrefcountbt_calc_reserves(mp);
+
+	error = -libxfs_imeta_lookup(mp, path, &ino);
+	libxfs_imeta_free_path(path);
+	if (error == EFSCORRUPTED) {
+		if (ask > mp->m_sb.sb_fdblocks)
+			return ENOSPC;
+
+		*new_resv += ask;
+		return 0;
+	}
+	if (error)
+		return error;
+
+	error = -libxfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE,
+			&rtg->rtg_refcountip);
+	if (error)
+		return error;
+
+	return -libxfs_imeta_resv_init_inode(rtg->rtg_refcountip, ask);
+}
+
 static void
 check_fs_free_space(
 	struct xfs_mount		*mp,
@@ -561,6 +615,18 @@ _("Not enough free space would remain for rtgroup %u rmap inode.\n"),
 			do_error(
 _("Error %d while checking rtgroup %u rmap inode space reservation.\n"),
 					rtg->rtg_rgno, error);
+
+		error = reserve_rtrefcount_inode(rtg, &new_resv);
+		if (error == ENOSPC) {
+			printf(
+_("Not enough free space would remain for rtgroup %u refcount inode.\n"),
+					rtg->rtg_rgno);
+			exit(0);
+		}
+		if (error)
+			do_error(
+_("Error %d while checking rtgroup %u refcount inode space reservation.\n"),
+					rtg->rtg_rgno, error);
 	}
 
 	/*
@@ -581,6 +647,11 @@ _("Error %d while checking rtgroup %u rmap inode space reservation.\n"),
 			libxfs_imeta_irele(rtg->rtg_rmapip);
 			rtg->rtg_rmapip = NULL;
 		}
+		if (rtg->rtg_refcountip) {
+			libxfs_imeta_resv_free_inode(rtg->rtg_refcountip);
+			libxfs_imeta_irele(rtg->rtg_refcountip);
+			rtg->rtg_refcountip = NULL;
+		}
 	}
 
 	/*

