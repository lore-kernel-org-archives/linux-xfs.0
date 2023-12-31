Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E560DDF42
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P60wUqet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04B5C433C8;
	Sun, 31 Dec 2023 23:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064469;
	bh=X1OcUVriTlM8RA2Yohg0rgAUchmxChIWHEdmk7DNQrI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P60wUqet6ue1/wnW7thWkk7akMrZiI4d/2z/f5a97NkquQlzho6Ue8vbOST/4xcIh
	 mbGFVcRds6R1sdQibE0K8lCbIwTZuXD3ujvrbHC9LX7n0ox1YXcSeZqsW16WGWiIwJ
	 s5hbqKWnXRjjIsh00hFfbmxxexAeGAYAspT5fg+VpycJZR0o5Gr+XWsmBY1FkxqNuF
	 tBuhwog6wwNGuyHhzF3AamyPImrpUbR9CRufIg3GS7L172zaQYviyEntdf9O+kI4oR
	 6MKETL5aVXxaJJI41XtWpqypCdkjtUGbVXvYJfzbezCzHt2sn3nyEiSvBr3PQegJvA
	 ioc688ZQsftig==
Date: Sun, 31 Dec 2023 15:14:29 -0800
Subject: [PATCH 04/18] xfs: add raw parent pointer apis to support repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006916.1805510.16418319009796406101.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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

Add a couple of utility functions to set or remove parent pointers from
a file.  These functions will be used by repair code, hence they skip
the xattr logging that regular parent pointer updates use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c   |    2 +-
 libxfs/xfs_dir2.h   |    2 +-
 libxfs/xfs_parent.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |    8 ++++++++
 4 files changed, 56 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 79b6ec893fd..b906f39e0fe 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -439,7 +439,7 @@ int
 xfs_dir_removename(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		ino,
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index f99788a1f3e..ca1949ed4f5 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -55,7 +55,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t ino,
+				const struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 024e89756e6..f7cef51e1ec 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -421,3 +421,49 @@ xfs_parent_lookup(
 
 	return xfs_attr_get_ilocked(&scr->args);
 }
+
+/*
+ * Attach the parent pointer (@pptr -> @name) to @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  This is for specialized repair
+ * functions only.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_set(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	if (XFS_IS_CORRUPT(ip->i_mount,
+			!xfs_parent_verify_irec(ip->i_mount, pptr))) {
+		return -EFSCORRUPTED;
+	}
+
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_LOGGED;
+
+	return xfs_attr_set(&scr->args);
+}
+
+/*
+ * Remove the parent pointer (@rec -> @name) from @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  This is for specialized repair
+ * functions only.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_unset(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	if (XFS_IS_CORRUPT(ip->i_mount,
+			!xfs_parent_verify_irec(ip->i_mount, pptr))) {
+		return -EFSCORRUPTED;
+	}
+
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_LOGGED | XFS_DA_OP_REMOVE;
+
+	return xfs_attr_set(&scr->args);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index e4443da1d86..58e59af818b 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -162,4 +162,12 @@ int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
+int xfs_parent_set(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
+
+int xfs_parent_unset(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *rec,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */

