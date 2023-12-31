Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA27C14C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="met0VqJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB1FC433C7;
	Sun, 31 Dec 2023 23:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064047;
	bh=shsT6C0cUp9KcEDqqJvrINMy6s613FXmqu/2QcLNm5E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=met0VqJsF8sUV7iN95R9UyMlDxFAgcXFslMxVkBUsyXSU+lYXT+g5HDMWBknJhDmW
	 GDHKyfiQaiDf9CEo9B2ML/s2cBqcINIMnKiTn2eN9Ius9rV+qKEuX67Zx5ybM+PaVD
	 dwSenmNEVe8gSujJuRKlugkk8/1laVCfcXhfTKYCr+PGTxooQ17/SFT0KtCUaz7NVr
	 IZ55F15ndKYTbD8P5yvAs4nFrpL52m7yKX753pFemg6oRRoQFqEwywt/ZbVq5KViqN
	 +6f3LqTXJTV4aJdANXBL4T7vj+jS1h3TYHFcAiHNa0+29MPxVmH57CslhCyG8puXKe
	 xvR7YQhmKSVyA==
Date: Sun, 31 Dec 2023 15:07:27 -0800
Subject: [PATCH 09/32] xfs: Add parent pointers to rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006222.1804688.15929628504320931898.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_parent.c      |   63 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h      |   20 +++++++++++++++
 libxfs/xfs_trans_space.c |   25 ++++++++++++++++++
 libxfs/xfs_trans_space.h |    6 +++-
 4 files changed, 112 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index b3004af9161..6c98f95f274 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -139,6 +139,19 @@ xfs_init_parent_davalue(
 	args->value = (void *)name->name;
 }
 
+/*
+ * Point the da args new value fields at the non-key parts of a replacement
+ * parent pointer.
+ */
+static inline void
+xfs_init_parent_danewvalue(
+	struct xfs_da_args		*args,
+	const struct xfs_name		*name)
+{
+	args->new_valuelen = name->len;
+	args->new_value = (void *)name->name;
+}
+
 /*
  * Allocate memory to control a logged parent pointer update as part of a
  * dirent operation.
@@ -234,6 +247,56 @@ xfs_parent_removename(
 	return 0;
 }
 
+/* Replace one parent pointer with another to reflect a rename. */
+int
+xfs_parent_replacename(
+	struct xfs_trans	*tp,
+	struct xfs_parent_args	*ppargs,
+	struct xfs_inode	*old_dp,
+	const struct xfs_name	*old_name,
+	struct xfs_inode	*new_dp,
+	const struct xfs_name	*new_name,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &ppargs->args;
+
+	if (XFS_IS_CORRUPT(tp->t_mountp,
+			!xfs_parent_valuecheck(tp->t_mountp, old_name->name,
+					       old_name->len)))
+		return -EFSCORRUPTED;
+
+	if (XFS_IS_CORRUPT(tp->t_mountp,
+			!xfs_parent_valuecheck(tp->t_mountp, new_name->name,
+					       new_name->len)))
+		return -EFSCORRUPTED;
+
+	/*
+	 * For regular attrs, replacing an attr from a !hasattr inode becomes
+	 * an attr-set operation.  For replacing a parent pointer, however, we
+	 * require that the old pointer must exist.
+	 */
+	if (XFS_IS_CORRUPT(child->i_mount, !xfs_inode_hasattr(child))) {
+		xfs_inode_mark_sick(child, XFS_SICK_INO_PARENT);
+		return -EFSCORRUPTED;
+	}
+
+	xfs_init_parent_name_rec(&ppargs->rec, old_dp, old_name, child);
+	args->hashval = xfs_parent_hashname(old_dp, ppargs);
+
+	xfs_init_parent_name_rec(&ppargs->new_rec, new_dp, new_name, child);
+	args->new_name = (const uint8_t *)&ppargs->new_rec;
+	args->new_namelen = sizeof(struct xfs_parent_name_rec);
+
+	args->trans = tp;
+	args->dp = child;
+
+	xfs_init_parent_davalue(&ppargs->args, old_name);
+	xfs_init_parent_danewvalue(&ppargs->args, new_name);
+
+	xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
+	return 0;
+}
+
 /* Free a parent pointer context object. */
 void
 xfs_parent_args_free(
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 31349130a33..c68c501388e 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -24,6 +24,7 @@ extern struct kmem_cache	*xfs_parent_args_cache;
  */
 struct xfs_parent_args {
 	struct xfs_parent_name_rec	rec;
+	struct xfs_parent_name_rec	new_rec;
 	struct xfs_da_args		args;
 };
 
@@ -95,6 +96,25 @@ xfs_parent_remove(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 	return 0;
 }
 
+int xfs_parent_replacename(struct xfs_trans *tp,
+		struct xfs_parent_args *ppargs,
+		struct xfs_inode *old_dp, const struct xfs_name *old_name,
+		struct xfs_inode *new_dp, const struct xfs_name *new_name,
+		struct xfs_inode *child);
+
+/* Schedule a parent pointer replacement. */
+static inline int
+xfs_parent_replace(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *old_dp, const struct xfs_name *old_name,
+		struct xfs_inode *new_dp, const struct xfs_name *new_name,
+		struct xfs_inode *child)
+{
+	if (ppargs)
+		return xfs_parent_replacename(tp, ppargs, old_dp, old_name,
+				new_dp, new_name, child);
+	return 0;
+}
+
 void xfs_parent_args_free(struct xfs_mount *mp, struct xfs_parent_args *ppargs);
 
 /* Finish a parent pointer update by freeing the context object. */
diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index 86a91a3a844..373f5cc2497 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -94,3 +94,28 @@ xfs_remove_space_res(
 
 	return ret;
 }
+
+unsigned int
+xfs_rename_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		src_namelen,
+	bool			target_exists,
+	unsigned int		target_namelen,
+	bool			has_whiteout)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRREMOVE_SPACE_RES(mp) +
+			XFS_DIRENTER_SPACE_RES(mp, target_namelen);
+
+	if (xfs_has_parent(mp)) {
+		if (has_whiteout)
+			ret += xfs_parent_calc_space_res(mp, src_namelen);
+		ret += 2 * xfs_parent_calc_space_res(mp, target_namelen);
+	}
+
+	if (target_exists)
+		ret += xfs_parent_calc_space_res(mp, target_namelen);
+
+	return ret;
+}
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index a4490813c56..1155ff2d37e 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_RENAME_SPACE_RES(mp,nl)	\
-	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
@@ -106,4 +104,8 @@ unsigned int xfs_symlink_space_res(struct xfs_mount *mp, unsigned int namelen,
 		unsigned int fsblocks);
 unsigned int xfs_remove_space_res(struct xfs_mount *mp, unsigned int namelen);
 
+unsigned int xfs_rename_space_res(struct xfs_mount *mp,
+		unsigned int src_namelen, bool target_exists,
+		unsigned int target_namelen, bool has_whiteout);
+
 #endif	/* __XFS_TRANS_SPACE_H__ */

