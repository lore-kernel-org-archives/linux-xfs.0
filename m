Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACEABA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmOn5JWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC82C433C8;
	Sun, 31 Dec 2023 21:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057071;
	bh=f8Sv7CREC3DbTMCOrNpu9FPgcOemzLHSFQzUWTH4XWw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WmOn5JWXT+qL6IMAFzRZOlTRacn5bERxNK37UBDkYpApSb7GXGok6HyXq7B3w404U
	 ImMNRLp4q3BdGwLKAttVTbZz+KbexJfLWKJj3ItV6iaUPG0OA+B0lhjxGF29Ptw4kq
	 Z0IQjQtIsDwwFmUrXAyNTR+2E6dypwzkj9k8uU3tYUGXR6U2AIPropgAFtn60zWZIR
	 4dtCJmDZ/2dAHPm/1d33YNnh9kCuVCrXOcSpuj4vn4rOaTMr/+bvMGNbPhVGEYjn0W
	 VGzV81Luu7omGo4jc9Q2qMhVm6qt+VTbZl1SWlZy6fQkySG18kUdxGrzn71m7sAy+6
	 toH/KAgO5jl6g==
Date: Sun, 31 Dec 2023 13:11:10 -0800
Subject: [PATCH 19/32] xfs: enable creation of dynamically allocated metadir
 path structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845172.1760491.18425552810567876452.stgit@frogsfrogsfrogs>
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

Add a few helper functions so that it's possible to allocate
xfs_imeta_path objects dynamically, along with dynamically allocated
path components.  Eventually we're going to want to support paths of the
form "/realtime/$rtgroup.rmap", and this is necessary for that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_imeta.c |   46 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h |   15 +++++++++++++++
 2 files changed, 61 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index e3651c7bba2b3..10249a1c36c73 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -1015,3 +1015,49 @@ xfs_imeta_mount(
 
 	return 0;
 }
+
+/* Create a path to a file within the metadata directory tree. */
+int
+xfs_imeta_create_file_path(
+	struct xfs_mount	*mp,
+	unsigned int		nr_components,
+	struct xfs_imeta_path	**pathp)
+{
+	struct xfs_imeta_path	*p;
+	unsigned char		**components;
+
+	p = kzalloc(sizeof(struct xfs_imeta_path), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	components = kvcalloc(nr_components, sizeof(unsigned char *),
+			GFP_KERNEL);
+	if (!components) {
+		kfree(p);
+		return -ENOMEM;
+	}
+
+	p->im_depth = nr_components;
+	p->im_path = (const unsigned char **)components;
+	p->im_ftype = XFS_DIR3_FT_REG_FILE;
+	*pathp = p;
+	return 0;
+}
+
+/* Free a metadata directory tree path. */
+void
+xfs_imeta_free_path(
+	const struct xfs_imeta_path	*path)
+{
+	unsigned int			i;
+
+	if (path->im_flags & XFS_IMETA_PATH_STATIC)
+		return;
+
+	for (i = 0; i < path->im_depth; i++) {
+		if ((path->im_dynamicmask & (1ULL << i)) && path->im_path[i])
+			kfree(path->im_path[i]);
+	}
+	kfree(path->im_path);
+	kfree(path);
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index b8e360bbdfbe1..3b5953efc013c 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -15,6 +15,8 @@ const struct xfs_imeta_path name = { \
 	.im_path = (path), \
 	.im_ftype = XFS_DIR3_FT_REG_FILE, \
 	.im_depth = ARRAY_SIZE(path), \
+	.im_flags = XFS_IMETA_PATH_STATIC, \
+	.im_dynamicmask = 0, \
 }
 
 /* Key for looking up metadata inodes. */
@@ -22,6 +24,12 @@ struct xfs_imeta_path {
 	/* Array of string pointers. */
 	const unsigned char	**im_path;
 
+	/* Each bit corresponds to an element of im_path needing to be freed */
+	unsigned long long	im_dynamicmask;
+
+	/* XFS_IMETA_* path flags */
+	uint16_t		im_flags;
+
 	/* Number of strings in path. */
 	uint8_t			im_depth;
 
@@ -29,6 +37,9 @@ struct xfs_imeta_path {
 	uint8_t			im_ftype;
 };
 
+/* Path is statically allocated. */
+#define XFS_IMETA_PATH_STATIC	(1U << 0)
+
 /* Cleanup widget for metadata inode creation and deletion. */
 struct xfs_imeta_update {
 	struct xfs_mount	*mp;
@@ -72,6 +83,10 @@ int xfs_imeta_lookup(struct xfs_trans *tp, const struct xfs_imeta_path *path,
 int xfs_imeta_dir_parent(struct xfs_trans *tp,
 		const struct xfs_imeta_path *path, struct xfs_inode **dpp);
 
+int xfs_imeta_create_file_path(struct xfs_mount *mp,
+		unsigned int nr_components, struct xfs_imeta_path **pathp);
+void xfs_imeta_free_path(const struct xfs_imeta_path *path);
+
 void xfs_imeta_set_iflag(struct xfs_trans *tp, struct xfs_inode *ip);
 void xfs_imeta_clear_iflag(struct xfs_trans *tp, struct xfs_inode *ip);
 

