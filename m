Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132ABC140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uK3OjmgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3827C433C7;
	Sun, 31 Dec 2023 23:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064031;
	bh=38lNuDWKAG2sCld47fUKAsuzqljZk3BpEdVGEbIz0tk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uK3OjmgIs6/d/wG8bJ9d/6MjuhyotIHHbBEc/oJ4cRHH63v89S2u47Gh/lHJW5u8E
	 k7B+HYsv5p8Vi49pBUFtlSK5vGB7nIztcoIxc78ZSnFeiFdz9F22YDa2jRIBfbXOxO
	 Yh0MuCHX6FzfMrRZ4JLx3w8hrKLWVcpXtTTHdoi/F1CSSk+K2fmtfO/7riFn6/ebwX
	 Cg6JZ2Mjh7nCSciZENwPf8aEd8Yxqr32GFY6u0z0KVsi2/BM7Os3+yd6vz1BaJAi/N
	 qrwmJm1mdAt9jzza2l4HXWLzYOyNJCzAGaeheYwVw1ii6XtiCQnhGvKVRNUGhYM718
	 PL29H0iqepimA==
Date: Sun, 31 Dec 2023 15:07:11 -0800
Subject: [PATCH 08/32] xfs: remove parent pointers in unlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Message-ID: <170405006209.1804688.10673477133013884075.stgit@frogsfrogsfrogs>
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

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format, minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/xfs_parent.c      |   39 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h      |   16 ++++++++++++++++
 libxfs/xfs_trans_space.c |   13 +++++++++++++
 libxfs/xfs_trans_space.h |    3 +--
 repair/phase6.c          |    6 +++---
 6 files changed, 73 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 6ab10be3ad6..1b69124767c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -193,6 +193,7 @@
 #define xfs_refcountbt_stage_cursor	libxfs_refcountbt_stage_cursor
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
 #define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
+#define xfs_remove_space_res		libxfs_remove_space_res
 
 #define xfs_rmap_alloc			libxfs_rmap_alloc
 #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 32e1d1f62ec..b3004af9161 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -28,6 +28,7 @@
 #include "xfs_da_format.h"
 #include "xfs_format.h"
 #include "xfs_trans_space.h"
+#include "xfs_health.h"
 
 struct kmem_cache		*xfs_parent_args_cache;
 
@@ -195,6 +196,44 @@ xfs_parent_addname(
 	return 0;
 }
 
+/* Remove a parent pointer to reflect a dirent removal. */
+int
+xfs_parent_removename(
+	struct xfs_trans	*tp,
+	struct xfs_parent_args	*ppargs,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*parent_name,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &ppargs->args;
+
+	if (XFS_IS_CORRUPT(tp->t_mountp,
+			!xfs_parent_valuecheck(tp->t_mountp, parent_name->name,
+					       parent_name->len)))
+		return -EFSCORRUPTED;
+
+	/*
+	 * For regular attrs, removing an attr from a !hasattr inode is a nop.
+	 * For parent pointers, we require that the pointer must exist if the
+	 * caller wants us to remove the pointer.
+	 */
+	if (XFS_IS_CORRUPT(child->i_mount, !xfs_inode_hasattr(child))) {
+		xfs_inode_mark_sick(child, XFS_SICK_INO_PARENT);
+		return -EFSCORRUPTED;
+	}
+
+	xfs_init_parent_name_rec(&ppargs->rec, dp, parent_name, child);
+	args->hashval = xfs_parent_hashname(dp, ppargs);
+
+	args->trans = tp;
+	args->dp = child;
+
+	xfs_init_parent_davalue(&ppargs->args, parent_name);
+
+	xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
+	return 0;
+}
+
 /* Free a parent pointer context object. */
 void
 xfs_parent_args_free(
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index e2115a2b964..31349130a33 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -79,6 +79,22 @@ xfs_parent_add(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 	return 0;
 }
 
+int xfs_parent_removename(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child);
+
+/* Schedule a parent pointer removal. */
+static inline int
+xfs_parent_remove(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child)
+{
+	if (ppargs)
+		return xfs_parent_removename(tp, ppargs, dp, parent_name,
+				child);
+	return 0;
+}
+
 void xfs_parent_args_free(struct xfs_mount *mp, struct xfs_parent_args *ppargs);
 
 /* Finish a parent pointer update by freeing the context object. */
diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index bf4a41492c2..86a91a3a844 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -81,3 +81,16 @@ xfs_symlink_space_res(
 
 	return ret;
 }
+
+unsigned int
+xfs_remove_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret = XFS_DIRREMOVE_SPACE_RES(mp);
+
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 354ad1d6e18..a4490813c56 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_REMOVE_SPACE_RES(mp)	\
-	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
@@ -106,5 +104,6 @@ unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_symlink_space_res(struct xfs_mount *mp, unsigned int namelen,
 		unsigned int fsblocks);
+unsigned int xfs_remove_space_res(struct xfs_mount *mp, unsigned int namelen);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/repair/phase6.c b/repair/phase6.c
index 825f0cf3956..9b43e58b3d3 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1275,7 +1275,7 @@ longform_dir2_rebuild(
 	    libxfs_dir_ino_validate(mp, pip.i_ino))
 		pip.i_ino = mp->m_sb.sb_rootino;
 
-	nres = XFS_REMOVE_SPACE_RES(mp);
+	nres = libxfs_remove_space_res(mp, 0);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
@@ -1381,7 +1381,7 @@ dir2_kill_block(
 	int		nres;
 	xfs_trans_t	*tp;
 
-	nres = XFS_REMOVE_SPACE_RES(mp);
+	nres = libxfs_remove_space_res(mp, 0);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
@@ -2900,7 +2900,7 @@ process_dir_inode(
 			 * inode but it's easier than wedging a
 			 * new define in ourselves.
 			 */
-			nres = no_modify ? 0 : XFS_REMOVE_SPACE_RES(mp);
+			nres = no_modify ? 0 : libxfs_remove_space_res(mp, 0);
 			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
 						    nres, 0, 0, &tp);
 			if (error)

