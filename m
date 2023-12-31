Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4CBC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9aHTMlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA3BC433C7;
	Sun, 31 Dec 2023 23:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065672;
	bh=TGxSjdfx7zOFwG9Z650fXg96RooMi8rWVUjngu10MMw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I9aHTMlAn/1MX4Hk3sjLpBmC2btgW6THPL46iowwaTXJKhi1ETj/YWHRz2mauUsIl
	 TMsoMGFLrDzKmc05T5hrSST23g8jfFPifOa8qfi/h3swHR9Wz9ntsWOOuI0Qq8t+RB
	 XYB/SsOSAaORtbgMQqw0jYII+JwDIenrFJ8iRNW1YpLjRppP57qbKPbl3TGb4OTvzb
	 PQOWhqeiZDMGcU30SGNCuDX2uFe9AlxHFObqoM39GUblNU5GbCGP/iz22ogxboUP5i
	 TMVO5P3ANUAIz6xWj9uuU0xFE+AiHWybpm9VfEdiGFGm9ImU7cYCJOboGNUSdRx0Ki
	 uIue+RtqaQ0vQ==
Date: Sun, 31 Dec 2023 15:34:32 -0800
Subject: [PATCH 19/58] xfs: enable creation of dynamically allocated metadir
 path structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010201.1809361.5265276208797149157.stgit@frogsfrogsfrogs>
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

Add a few helper functions so that it's possible to allocate
xfs_imeta_path objects dynamically, along with dynamically allocated
path components.  Eventually we're going to want to support paths of the
form "/realtime/$rtgroup.rmap", and this is necessary for that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h           |    5 ++++-
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_imeta.c       |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h       |   15 +++++++++++++++
 4 files changed, 67 insertions(+), 1 deletion(-)


diff --git a/include/kmem.h b/include/kmem.h
index 8ae919c7066..c71e311cabc 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -26,7 +26,7 @@ typedef unsigned int __bitwise gfp_t;
 #define __GFP_NOFAIL	((__force gfp_t)0)
 #define __GFP_NOLOCKDEP	((__force gfp_t)0)
 
-#define __GFP_ZERO	(__force gfp_t)1
+#define __GFP_ZERO	((__force gfp_t)1)
 
 struct kmem_cache * kmem_cache_create(const char *name, unsigned int size,
 		unsigned int align, unsigned int slab_flags,
@@ -65,6 +65,9 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 	return kvmalloc(size, flags);
 }
 
+#define kvcalloc(nr, size, gfp)	kvmalloc((nr) * (size), (gfp) | __GFP_ZERO)
+#define kzalloc(size, gfp)	kvmalloc((size), (gfp) | __GFP_ZERO)
+
 static inline void kfree(const void *ptr)
 {
 	return kmem_free(ptr);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e08be764a49..ca8e231c0fd 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -177,8 +177,10 @@
 #define xfs_imeta_cancel_update		libxfs_imeta_cancel_update
 #define xfs_imeta_commit_update		libxfs_imeta_commit_update
 #define xfs_imeta_create		libxfs_imeta_create
+#define xfs_imeta_create_file_path	libxfs_imeta_create_file_path
 #define xfs_imeta_create_space_res	libxfs_imeta_create_space_res
 #define xfs_imeta_ensure_dirpath	libxfs_imeta_ensure_dirpath
+#define xfs_imeta_free_path		libxfs_imeta_free_path
 #define xfs_imeta_iget			libxfs_imeta_iget
 #define xfs_imeta_irele			libxfs_imeta_irele
 #define xfs_imeta_link			libxfs_imeta_link
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index 2defee9562b..ad429c82b47 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -1014,3 +1014,49 @@ xfs_imeta_mount(
 
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
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index b8e360bbdfb..3b5953efc01 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
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
 

