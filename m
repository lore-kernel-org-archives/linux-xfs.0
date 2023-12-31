Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA115C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZJ7Jc08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40183C433C8;
	Sun, 31 Dec 2023 23:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065485;
	bh=63A98CUfW5pyOJB5fJTGLvQUOAwEa9LASLOFFX55fbw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SZJ7Jc08tCcfkRJATYejbavLy98yAS9xEcqdTCHztun9cNYgqruup3bK58FlKqSMU
	 Rz5bGwg5bt+9Jg6yjZIV2jxhlb9989zb8qV5d8fMxKlJ1203n5LkZ2eS59MTTDFvBY
	 z/CB7+hFrTzgSdpXVBJ8kyPgkIHSKt8fGMMIc1E7LGqnkJN4cUA9KcZOvjhVKDDqJo
	 YlJ8KJT4MCqGBpCx+RwF/dWhUwd4H1U7sSNE0ZM/ahwm0XaK8DtAXuReNF9pWIny1d
	 ezYNo9iXNU1VkY+cucFb7yBe/MT+dcWJQYrVzGRY1LOYo8142+1pRfcT83lpLlFZWZ
	 wd4bDZDwVA3Mg==
Date: Sun, 31 Dec 2023 15:31:24 -0800
Subject: [PATCH 07/58] xfs: iget for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010040.1809361.4434787677428532445.stgit@frogsfrogsfrogs>
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

Create a xfs_iget_meta function for metadata inodes to ensure that we
always check that the inobt thinks a metadata inode is in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c            |    4 ++--
 libxfs/inode.c           |   36 ++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_imeta.h       |    5 +++++
 4 files changed, 45 insertions(+), 2 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index c199aeea45e..c0f148e75a2 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -883,9 +883,9 @@ void
 libxfs_rtmount_destroy(xfs_mount_t *mp)
 {
 	if (mp->m_rsumip)
-		libxfs_irele(mp->m_rsumip);
+		libxfs_imeta_irele(mp->m_rsumip);
 	if (mp->m_rbmip)
-		libxfs_irele(mp->m_rbmip);
+		libxfs_imeta_irele(mp->m_rbmip);
 	mp->m_rsumip = mp->m_rbmip = NULL;
 }
 
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 47c9b9d6bd7..560b127ee9d 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -225,6 +225,35 @@ libxfs_iget(
 	return error;
 }
 
+/*
+ * Get a metadata inode.  The ftype must match exactly.  Caller must supply
+ * a transaction (even if empty) to avoid livelocking if the inobt has a cycle.
+ */
+int
+libxfs_imeta_iget(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	unsigned char		ftype,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip;
+	int			error;
+
+	error = libxfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, &ip);
+	if (error)
+		return error;
+
+	if (ftype == XFS_DIR3_FT_UNKNOWN ||
+	    xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype) {
+		libxfs_irele(ip);
+		return -EFSCORRUPTED;
+	}
+
+	*ipp = ip;
+	return 0;
+}
+
 static void
 libxfs_idestroy(
 	struct xfs_inode	*ip)
@@ -258,6 +287,13 @@ libxfs_irele(
 	}
 }
 
+void
+libxfs_imeta_irele(
+	struct xfs_inode	*ip)
+{
+	libxfs_irele(ip);
+}
+
 static inline void inode_fsgid_set(struct inode *inode,
 				   struct mnt_idmap *idmap)
 {
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 167617771d8..873995f265c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -177,6 +177,8 @@
 #define xfs_imeta_commit_update		libxfs_imeta_commit_update
 #define xfs_imeta_create		libxfs_imeta_create
 #define xfs_imeta_create_space_res	libxfs_imeta_create_space_res
+#define xfs_imeta_iget			libxfs_imeta_iget
+#define xfs_imeta_irele			libxfs_imeta_irele
 #define xfs_imeta_link			libxfs_imeta_link
 #define xfs_imeta_link_space_res	libxfs_imeta_link_space_res
 #define xfs_imeta_lookup		libxfs_imeta_lookup
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index 7b3da865c09..0a4361bda1c 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
@@ -47,4 +47,9 @@ unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_link_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 
+/* Must be implemented by the libxfs client */
+int xfs_imeta_iget(struct xfs_trans *tp, xfs_ino_t ino, unsigned char ftype,
+		struct xfs_inode **ipp);
+void xfs_imeta_irele(struct xfs_inode *ip);
+
 #endif /* __XFS_IMETA_H__ */

