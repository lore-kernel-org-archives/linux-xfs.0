Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9B8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiLaCNR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiLaCNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:13:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE2E1C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:13:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56EB4CE19FF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90418C433D2;
        Sat, 31 Dec 2022 02:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452791;
        bh=SgTcHWqwqa+JGItgG1qpqbRoslJWXTSmB/ZHtkWrIxE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bXWKr2uQ0GDTxxqDGDyJeypJ2xD4pUsiujEV1e8i7WOhSBED9sK0gLHavxzItckhC
         XmuX/Qm/ZLX3IYprJuois9SevbfBmPGNQk8FEE6eGhsiqGvze7Ce43zCJBVuy2r3CU
         foFP4BouHUN4Akt2HC6lD0bTJCDTxjwCLAUuHb2mG+4A39Bzgh37fWmKmPs+iI3sl/
         n6MYbvnn6u3hjsZ4Xts8QTDei8sxhYLYfuX9WovQWmOSwwnicXZ7dzyXYk3JuFKyEl
         OlAZMgasez6el4SqOqOnI9DnTPmUiNZFVmADwSmkXxDKlX/LPTBvI7nmC7Et20gVmH
         hP0J/Chw1uWDw==
Subject: [PATCH 13/46] xfs: ensure metadata directory paths exist before
 creating files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:21 -0800
Message-ID: <167243876107.725900.6945520572505882528.stgit@magnolia>
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

Since xfs_imeta_create can create new metadata files arbitrarily deep in
the metadata directory tree, we must supply a function that can ensure
that all directories in a path exist, and call it before the quota
functions create the quota inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/util.c            |   78 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h       |    2 +
 mkfs/proto.c             |    8 +++++
 4 files changed, 89 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d4cc059abfb..785354d3ec8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -160,6 +160,7 @@
 #define xfs_imeta_create		libxfs_imeta_create
 #define xfs_imeta_create_space_res	libxfs_imeta_create_space_res
 #define xfs_imeta_end_update		libxfs_imeta_end_update
+#define xfs_imeta_ensure_dirpath	libxfs_imeta_ensure_dirpath
 #define xfs_imeta_iget			libxfs_imeta_iget
 #define xfs_imeta_irele			libxfs_imeta_irele
 #define xfs_imeta_link			libxfs_imeta_link
diff --git a/libxfs/util.c b/libxfs/util.c
index 51a0f513e7a..fec26e6d30f 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -454,3 +454,81 @@ void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
 void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
+
+/* Create a metadata for the last component of the path. */
+STATIC int
+libxfs_imeta_mkdir(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_update		upd;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_trans		*tp = NULL;
+	uint				resblks;
+	int				error;
+
+	/* Try to place metadata directories in AG 0. */
+	mp->m_agirotor = 0;
+
+	error = xfs_imeta_start_update(mp, path, &upd);
+	if (error)
+		return error;
+
+	/* Allocate a transaction to create the last directory. */
+	resblks = libxfs_imeta_create_space_res(mp);
+	error = libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create, resblks,
+			0, 0, &tp);
+	if (error)
+		goto out_end;
+
+	/* Create the subdirectory. */
+	error = libxfs_imeta_create(&tp, path, S_IFDIR, 0, &ip, &upd);
+	if (error)
+		goto out_trans_cancel;
+
+	error = libxfs_trans_commit(tp);
+
+	/*
+	 * We don't pass the directory we just created to the caller, so finish
+	 * setting up the inode, then release the dir.
+	 */
+	goto out_irele;
+
+out_trans_cancel:
+	libxfs_trans_cancel(tp);
+out_irele:
+	if (ip)
+		libxfs_irele(ip);
+out_end:
+	libxfs_imeta_end_update(mp, &upd, error);
+	return error;
+}
+
+/*
+ * Make sure that every metadata directory path component exists and is a
+ * directory.
+ */
+int
+libxfs_imeta_ensure_dirpath(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_path		temp_path = {
+		.im_path		= path->im_path,
+		.im_depth		= 1,
+		.im_ftype		= XFS_DIR3_FT_DIR,
+	};
+	unsigned int			i;
+	int				error = 0;
+
+	if (!xfs_has_metadir(mp))
+		return 0;
+
+	for (i = 0; i < path->im_depth - 1; i++, temp_path.im_depth++) {
+		error = libxfs_imeta_mkdir(mp, &temp_path);
+		if (error && error != -EEXIST)
+			break;
+	}
+
+	return error == -EEXIST ? 0 : error;
+}
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index 9b139f6809f..741f426c6a4 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
@@ -80,5 +80,7 @@ unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 int xfs_imeta_iget(struct xfs_mount *mp, xfs_ino_t ino, unsigned char ftype,
 		struct xfs_inode **ipp);
 void xfs_imeta_irele(struct xfs_inode *ip);
+int xfs_imeta_ensure_dirpath(struct xfs_mount *mp,
+			     const struct xfs_imeta_path *path);
 
 #endif /* __XFS_IMETA_H__ */
diff --git a/mkfs/proto.c b/mkfs/proto.c
index f145a7ba753..f15cbea84c7 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -683,6 +683,10 @@ rtbitmap_create(
 	struct xfs_inode	*rbmip;
 	int			error;
 
+	error = -libxfs_imeta_ensure_dirpath(mp, &XFS_IMETA_RTBITMAP);
+	if (error)
+		fail(_("Realtime bitmap directory allocation failed"), error);
+
 	error = -libxfs_imeta_start_update(mp, &XFS_IMETA_RTBITMAP, &upd);
 	if (error)
 		res_failed(error);
@@ -719,6 +723,10 @@ rtsummary_create(
 	struct xfs_inode	*rsumip;
 	int			error;
 
+	error = -libxfs_imeta_ensure_dirpath(mp, &XFS_IMETA_RTSUMMARY);
+	if (error)
+		fail(_("Realtime summary directory allocation failed"), error);
+
 	error = -libxfs_imeta_start_update(mp, &XFS_IMETA_RTSUMMARY, &upd);
 	if (error)
 		res_failed(error);

