Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B158BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5WD38zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2777CC433C8;
	Sun, 31 Dec 2023 21:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056993;
	bh=Y7f4sUGnzh3DBixVCRIt4NBW8fYEBCF3ylRATNGGje4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a5WD38zk6zq9xSWryd/AEfbJkZ+IGX187iGukV2aj13zy5zhLKkMOy/Ogv1RndjAL
	 xLIBNahWMhtHqRgoH5B33WiNQKaeQ+Hgu3LhzjgERoJSB6Zbk3lmd0L7JA7NuLU65X
	 TDOP8M6M5GlgJsQzj84EFIZtN5VQLtInFo1MVfsdomIGfJLhVx69U3sX5YwITazp5w
	 iWp6SeOwvqHytDoGnA5jx8SAlUxtdF8miA3/5HGJ0YEwO8n2Vt9U2NJFco+77bq1Xh
	 J+FsrIbME9dJiEi1jsw/3fS+H+AnPxysI5t9wGcjlii8q2h9F9GkjeZOIVdBndG6pp
	 kQj7f9vHXL3sQ==
Date: Sun, 31 Dec 2023 13:09:52 -0800
Subject: [PATCH 14/32] xfs: ensure metadata directory paths exist before
 creating files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845091.1760491.12360895844725193939.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Since xfs_imeta_create can create new metadata files arbitrarily deep in
the metadata directory tree, we must supply a function that can ensure
that all directories in a path exist, and call it before the quota
functions create the quota inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_imeta_utils.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_imeta_utils.h |    3 ++
 fs/xfs/xfs_qm.c          |   17 +++++++++++
 3 files changed, 91 insertions(+)


diff --git a/fs/xfs/xfs_imeta_utils.c b/fs/xfs/xfs_imeta_utils.c
index a8ff46a3d502e..9fbaa4323e3b2 100644
--- a/fs/xfs/xfs_imeta_utils.c
+++ b/fs/xfs/xfs_imeta_utils.c
@@ -265,3 +265,74 @@ xfs_imeta_cancel_update(
 
 	xfs_imeta_teardown(upd, error);
 }
+
+/* Create a metadata for the last component of the path. */
+STATIC int
+xfs_imeta_mkdir(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_update		upd;
+	struct xfs_inode		*ip = NULL;
+	int				error;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	/* Allocate a transaction to create the last directory. */
+	error = xfs_imeta_start_create(mp, path, &upd);
+	if (error)
+		return error;
+
+	/* Create the subdirectory and take our reference. */
+	error = xfs_imeta_create(&upd, S_IFDIR, &ip);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_imeta_commit_update(&upd);
+
+	/*
+	 * We don't pass the directory we just created to the caller, so finish
+	 * setting up the inode, then release the dir and the dquots.
+	 */
+	goto out_irele;
+
+out_cancel:
+	xfs_imeta_cancel_update(&upd, error);
+out_irele:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (ip) {
+		xfs_finish_inode_setup(ip);
+		xfs_irele(ip);
+	}
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
+			return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_imeta_utils.h b/fs/xfs/xfs_imeta_utils.h
index 0235f7048ff1d..f1bd6699997bb 100644
--- a/fs/xfs/xfs_imeta_utils.h
+++ b/fs/xfs/xfs_imeta_utils.h
@@ -18,6 +18,9 @@ int xfs_imeta_start_unlink(struct xfs_mount *mp,
 		const struct xfs_imeta_path *path,
 		struct xfs_inode *ip, struct xfs_imeta_update *upd);
 
+int xfs_imeta_ensure_dirpath(struct xfs_mount *mp,
+		const struct xfs_imeta_path *path);
+
 int xfs_imeta_commit_update(struct xfs_imeta_update *upd);
 void xfs_imeta_cancel_update(struct xfs_imeta_update *upd, int error);
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 2d8e420f3ad34..1d28f0982840c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -836,6 +836,23 @@ xfs_qm_qino_alloc(
 		return error;
 
 	if (need_alloc) {
+		/*
+		 * Ensure the quota directory exists, being careful to disable
+		 * quotas while we do this.  We'll have to quotacheck anyway,
+		 * so the temporary undercount of the directory tree shouldn't
+		 * affect the quota count.
+		 */
+		if (xfs_has_metadir(mp)) {
+			unsigned int	old_qflags;
+
+			old_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+			error = xfs_imeta_ensure_dirpath(mp, path);
+			mp->m_qflags |= old_qflags;
+			if (error)
+				return error;
+		}
+
 		error = xfs_imeta_start_create(mp, path, &upd);
 	} else {
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create, 0, 0, 0,

