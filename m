Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B4510E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300060; cv=none; b=ZX3CZjY0ytWk0o8cLx2GGK2h62MDBIR/44Mnlhb6IoQ9HQsqytizHGcW1Iq/pYLQfTylToOBeoLQjhDYz+nU7sp7Ny/jBZXeM4sJu1AoJAJ6iw2uZ4vEmkbVghwC7Ir86GoOawNZESr5mUwTShLlkupovrWBLzVYKq4DNBmUuag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300060; c=relaxed/simple;
	bh=2NKluxWn6uqj8UQUXGHj2mOthCOJ+BogMYbjo8Kk0Og=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LcAoM9h7KpoYMS5z8Daa5FKjcaxmfxcehQGZwHkOhH8PVVT5Okt4dql6ys7WUA/J9juHXsDJggvcjrAldx6g7FlJZzOEki+4jTf1vZv0UuixfUZeQAHSyhZD8rJKs2sU3Z7x4fjq/3yoWKTHkSLuaMOzESsPKkX8yRYCmlNRFks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZL8gCwlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZL8gCwlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F166EC32786;
	Tue, 30 Jul 2024 00:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300060;
	bh=2NKluxWn6uqj8UQUXGHj2mOthCOJ+BogMYbjo8Kk0Og=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZL8gCwlXxok4Ue8WTLGpm8hDVCj0R/D+N4oPeozc9BS4dpiUpa52QrMtqo5NaPC70
	 jKgl33/CpiUv0x2aZeTRAFxBdDtsxuzSgDmgegvdMVcuI2oJHJeG2mbtkSEGjjIcee
	 FwVf0TJo4BnSDzmrLtIQg7Q28y4+bTuJUpzmU9rMjdkAtx7LU5uzNGB6/JZgu14PMz
	 K7yaW+zFyOQtEIobcWaZMcIVouz0uqgC6zlKZmDtqd2syGFRzDFqGnzWyOhoDMvWJ7
	 8gobwTYVpMTWXrXezXdyETxp0lbRDfoa6x8dZxRlhpbYtghOJefi7N2VtkWfjBWoIB
	 tMch4v/1XwJ4Q==
Date: Mon, 29 Jul 2024 17:40:59 -0700
Subject: [PATCH 066/115] xfs: remove parent pointers in unlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843372.1338752.18248640869646401251.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: d2d18330f63cd70b50eddac76de7c59a36f2faa7

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format, minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/xfs_parent.c      |   22 ++++++++++++++++++++++
 libxfs/xfs_parent.h      |    3 +++
 libxfs/xfs_trans_space.c |   13 +++++++++++++
 libxfs/xfs_trans_space.h |    3 +--
 repair/phase6.c          |    6 +++---
 6 files changed, 43 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 9b44b7709..896b6c953 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -204,6 +204,7 @@
 #define xfs_refcountbt_stage_cursor	libxfs_refcountbt_stage_cursor
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
 #define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
+#define xfs_remove_space_res		libxfs_remove_space_res
 
 #define xfs_rmap_alloc			libxfs_rmap_alloc
 #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index b0516c3f6..0657728e6 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -202,3 +202,25 @@ xfs_parent_addname(
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
 	return 0;
 }
+
+/* Remove a parent pointer to reflect a dirent removal. */
+int
+xfs_parent_removename(
+	struct xfs_trans	*tp,
+	struct xfs_parent_args	*ppargs,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*parent_name,
+	struct xfs_inode	*child)
+{
+	int			error;
+
+	error = xfs_parent_iread_extents(tp, child);
+	if (error)
+		return error;
+
+	xfs_inode_to_parent_rec(&ppargs->rec, dp);
+	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
+			child->i_ino, parent_name);
+	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REMOVE);
+	return 0;
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 6de24e3ef..4a7fd48c2 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -81,5 +81,8 @@ xfs_parent_finish(
 int xfs_parent_addname(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 		struct xfs_inode *dp, const struct xfs_name *parent_name,
 		struct xfs_inode *child);
+int xfs_parent_removename(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child);
 
 #endif /* __XFS_PARENT_H__ */
diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index bf4a41492..86a91a3a8 100644
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
index 354ad1d6e..a4490813c 100644
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
index c4260fb91..2eba9772d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1283,7 +1283,7 @@ longform_dir2_rebuild(
 	    libxfs_dir_ino_validate(mp, pip.i_ino))
 		pip.i_ino = mp->m_sb.sb_rootino;
 
-	nres = XFS_REMOVE_SPACE_RES(mp);
+	nres = libxfs_remove_space_res(mp, 0);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
@@ -1389,7 +1389,7 @@ dir2_kill_block(
 	int		nres;
 	xfs_trans_t	*tp;
 
-	nres = XFS_REMOVE_SPACE_RES(mp);
+	nres = libxfs_remove_space_res(mp, 0);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
@@ -2908,7 +2908,7 @@ process_dir_inode(
 			 * inode but it's easier than wedging a
 			 * new define in ourselves.
 			 */
-			nres = no_modify ? 0 : XFS_REMOVE_SPACE_RES(mp);
+			nres = no_modify ? 0 : libxfs_remove_space_res(mp, 0);
 			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
 						    nres, 0, 0, &tp);
 			if (error)

