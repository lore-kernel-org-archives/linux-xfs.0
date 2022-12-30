Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE23C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiLaBNs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiLaBNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:13:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C366016588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:13:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 742E1B81A16
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124C0C433D2;
        Sat, 31 Dec 2022 01:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449223;
        bh=qTNfy8/YeMoSSKWe5FNNgZ0+O3wUzQzpQaUtZqpp6KU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=de6NRU/TYZm0AxaMR9JsBU3tr70XQBPspqY1XImLmnAu/dXt4fP+2fg1PzPQWkfso
         9W5Cpngnrq/eCDX+r98SJgc1H34yQ1obFGGCE9KL+819e8mDRtekRve3XHahueKm5B
         Nm918RNcAkHgCS93rZJl8gSBJaUxclXvGZykpOTkaWoaKl6/qXok7PAw6mi4im/REK
         c+BgAmclvbTwm+Fcx+jZ2fI4y0b5zYN4QB+FEPUusG/R1gqZPGjoE/Msy27S7HbuhR
         gykV9v80TUr+B96hvDfZgP46TsuHncukgzrQHGGO6WM6bvzDvWUopbxV59qhqZtnEj
         uSfKizPHTsrSg==
Subject: [PATCH 13/23] xfs: ensure metadata directory paths exist before
 creating files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:26 -0800
Message-ID: <167243864640.708110.10841816937652886747.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_imeta.h |    2 +
 fs/xfs/xfs_inode.c        |  103 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_qm.c           |   16 +++++++
 3 files changed, 121 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 9b139f6809f0..741f426c6a4a 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -80,5 +80,7 @@ unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 int xfs_imeta_iget(struct xfs_mount *mp, xfs_ino_t ino, unsigned char ftype,
 		struct xfs_inode **ipp);
 void xfs_imeta_irele(struct xfs_inode *ip);
+int xfs_imeta_ensure_dirpath(struct xfs_mount *mp,
+			     const struct xfs_imeta_path *path);
 
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3830e03ceb0a..1eb53ed0097d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1031,6 +1031,109 @@ xfs_create_tmpfile(
 	return error;
 }
 
+/* Create a metadata for the last component of the path. */
+STATIC int
+xfs_imeta_mkdir(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_update		upd;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_trans		*tp = NULL;
+	struct xfs_dquot		*udqp = NULL;
+	struct xfs_dquot		*gdqp = NULL;
+	struct xfs_dquot		*pdqp = NULL;
+	unsigned int			resblks;
+	int				error;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	error = xfs_imeta_start_update(mp, path, &upd);
+	if (error)
+		return error;
+
+	/* Grab all the root dquots. */
+	error = xfs_qm_vop_dqalloc(mp->m_metadirip, GLOBAL_ROOT_UID,
+			GLOBAL_ROOT_GID, 0, XFS_QMOPT_QUOTALL, &udqp, &gdqp,
+			&pdqp);
+	if (error)
+		goto out_end;
+
+	/* Allocate a transaction to create the last directory. */
+	resblks = xfs_imeta_create_space_res(mp);
+	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_imeta_create, udqp,
+			gdqp, pdqp, resblks, &tp);
+	if (error)
+		goto out_dqrele;
+
+	/* Create the subdirectory. */
+	error = xfs_imeta_create(&tp, path, S_IFDIR, 0, &ip, &upd);
+	if (error)
+		goto out_trans_cancel;
+
+	/*
+	 * Attach the dquot(s) to the inodes and modify them incore.
+	 * These ids of the inode couldn't have changed since the new
+	 * inode has been locked ever since it was created.
+	 */
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
+
+	error = xfs_trans_commit(tp);
+
+	/*
+	 * We don't pass the directory we just created to the caller, so finish
+	 * setting up the inode, then release the dir and the dquots.
+	 */
+	goto out_irele;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+out_irele:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (ip) {
+		xfs_finish_inode_setup(ip);
+		xfs_irele(ip);
+	}
+
+out_dqrele:
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+out_end:
+	xfs_imeta_end_update(mp, &upd, error);
+	return error;
+}
+
+/*
+ * Make sure that every metadata directory path component exists and is a
+ * directory.
+ */
+int
+xfs_imeta_ensure_dirpath(
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
+		error = xfs_imeta_mkdir(mp, &temp_path);
+		if (error && error != -EEXIST)
+			break;
+	}
+
+	return error == -EEXIST ? 0 : error;
+}
+
 int
 xfs_link(
 	xfs_inode_t		*tdp,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 8828e8cafca5..905765eedcb0 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -829,6 +829,22 @@ xfs_qm_qino_alloc(
 	if (error)
 		return error;
 
+	/*
+	 * Ensure the quota directory exists, being careful to disable quotas
+	 * while we do this.  We'll have to quotacheck anyway, so the temporary
+	 * undercount of the directory tree shouldn't affect the quota count.
+	 */
+	if (xfs_has_metadir(mp)) {
+		unsigned int	old_qflags;
+
+		old_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+		error = xfs_imeta_ensure_dirpath(mp, path);
+		mp->m_qflags |= old_qflags;
+		if (error)
+			return error;
+	}
+
 	error = xfs_imeta_start_update(mp, path, &upd);
 	if (error)
 		return error;

