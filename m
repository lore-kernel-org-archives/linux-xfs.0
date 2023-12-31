Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C94C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIKh9wE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DDBC433C7;
	Sun, 31 Dec 2023 23:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065610;
	bh=IJK4kDvCJ3MaaVevr4yOhr2MnTikIq/FugGuwaAlsCA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NIKh9wE0OaWnY1tShTi8HAltNceqByIL7JfeECtVSRnlWwN/v9ku6xtrfHUd4xbdQ
	 ZQXouYfW1CgXMJMYq/avtFhhkVhSCm008X0WO5M0GlNo8u6eWodTXJxOWLLDnRyzU4
	 YBkkfHrMg/MoyXWukLdkE+7zm8gLqe/SvkOSuRQyPt0sYLV8+bBKuaJ9w7+13fQmwy
	 oySLsXDfjHZp2NwqjGX4Db3m5XcpYYz6MPrAkOyUhRpKPUwDv/t4KxhI+qr4Sio0xM
	 15FkGJKsmghYtpDnluZekE4Bh9Sk9engtNFdjXqLi42+iiQ7WDr044F9rk46sW6f3C
	 bDEvpDYrMYiyg==
Date: Sun, 31 Dec 2023 15:33:29 -0800
Subject: [PATCH 15/58] xfs: ensure metadata directory paths exist before
 creating files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010148.1809361.16643842176885546069.stgit@frogsfrogsfrogs>
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

Since xfs_imeta_create can create new metadata files arbitrarily deep in
the metadata directory tree, we must supply a function that can ensure
that all directories in a path exist, and call it before the quota
functions create the quota inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/imeta_utils.c     |   69 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/imeta_utils.h     |    3 ++
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/proto.c             |    8 +++++
 4 files changed, 81 insertions(+)


diff --git a/libxfs/imeta_utils.c b/libxfs/imeta_utils.c
index ce6000530d3..0186968ed3e 100644
--- a/libxfs/imeta_utils.c
+++ b/libxfs/imeta_utils.c
@@ -246,3 +246,72 @@ xfs_imeta_cancel_update(
 
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
+	if (ip)
+		xfs_irele(ip);
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
diff --git a/libxfs/imeta_utils.h b/libxfs/imeta_utils.h
index a2afc0f37ac..8ab81149b05 100644
--- a/libxfs/imeta_utils.h
+++ b/libxfs/imeta_utils.h
@@ -18,6 +18,9 @@ int xfs_imeta_start_unlink(struct xfs_mount *mp,
 		const struct xfs_imeta_path *path,
 		struct xfs_inode *ip, struct xfs_imeta_update *upd);
 
+int xfs_imeta_ensure_dirpath(struct xfs_mount *mp,
+		const struct xfs_imeta_path *path);
+
 int xfs_imeta_commit_update(struct xfs_imeta_update *upd);
 void xfs_imeta_cancel_update(struct xfs_imeta_update *upd, int error);
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 90304da8983..e08be764a49 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -178,6 +178,7 @@
 #define xfs_imeta_commit_update		libxfs_imeta_commit_update
 #define xfs_imeta_create		libxfs_imeta_create
 #define xfs_imeta_create_space_res	libxfs_imeta_create_space_res
+#define xfs_imeta_ensure_dirpath	libxfs_imeta_ensure_dirpath
 #define xfs_imeta_iget			libxfs_imeta_iget
 #define xfs_imeta_irele			libxfs_imeta_irele
 #define xfs_imeta_link			libxfs_imeta_link
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 2eff1f32173..5e17ea420f4 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -754,6 +754,10 @@ rtbitmap_create(
 	struct xfs_inode	*rbmip;
 	int			error;
 
+	error = -libxfs_imeta_ensure_dirpath(mp, &XFS_IMETA_RTBITMAP);
+	if (error)
+		fail(_("Realtime bitmap directory allocation failed"), error);
+
 	error = -libxfs_imeta_start_create(mp, &XFS_IMETA_RTBITMAP, &upd);
 	if (error)
 		res_failed(error);
@@ -783,6 +787,10 @@ rtsummary_create(
 	struct xfs_inode	*rsumip;
 	int			error;
 
+	error = -libxfs_imeta_ensure_dirpath(mp, &XFS_IMETA_RTSUMMARY);
+	if (error)
+		fail(_("Realtime summary directory allocation failed"), error);
+
 	error = -libxfs_imeta_start_create(mp, &XFS_IMETA_RTSUMMARY, &upd);
 	if (error)
 		res_failed(error);

