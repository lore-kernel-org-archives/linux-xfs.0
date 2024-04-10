Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4357F391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710740; cv=none; b=ipEJvCb+wt7lbK0O2tXtg4NOPItIRQFqzu1MS+VEGBB5XN8Le+v3+Tmz5LAElR9xkw206RAiY37EyD166hrxQwev14WyuosaHBLrLF+5lmcsBKPRalJsdpy5lHLiYS4AXRcRxKEfQ37cEoDqVDFvLU/BTJBkC5QUPv8EhSYx5DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710740; c=relaxed/simple;
	bh=h0Fugom/5Sr1RqYd5VvAvSK1SwjDhny6lMYpagUFPRU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADwNdBbU3osQ9bTyLfVVGM5AMVuy3Nyj21qN6m7776e+pwKtW0aawFedErQw9Jclo+IBL7JMgW62LCCpCGTSepXr/7g5BS7cQKgaGLCNZGK4rgsVXlyYPv48Dx2jhCue5dEps22i1m33Twd0JnPUTY63m5hAjlndbuzBNLVnVLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JlWtPS9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JlWtPS9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D2CC433C7;
	Wed, 10 Apr 2024 00:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710739;
	bh=h0Fugom/5Sr1RqYd5VvAvSK1SwjDhny6lMYpagUFPRU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JlWtPS9GOsX053vZipl6wzqtUnMlOJSbVLjFQJYaSEhXnG1ZVFu+nP+zROwq5L2un
	 suM4igpU1qVT6EIhx6UK70Ei40349o9A3GEBekxazDmGhMYlaBMqEGt9l24gDbC+OG
	 PS8YwpRDPR2bbRMGtDhDoqV41cTzjLJDyCETmbVxVTuhv/IYYHi43JAeGKk75FueYA
	 z0s1FyML++cm/JI8d+/4u1kyCkW+LuGaAUAxnKLo4qlnZCJKMmfLGZqvvE0mB3UIez
	 negPcLaoSzfn+/Y8hdbRkenhf+AhySkI/y3njkcS23c+SNEl4kvF1n7UWoyu4pCDTJ
	 oApPAaJ7jZSXA==
Date: Tue, 09 Apr 2024 17:58:59 -0700
Subject: [PATCH 21/32] xfs: Add parent pointers to rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969908.3631889.12708632891559407279.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_parent.c      |   30 +++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |    6 +++
 fs/xfs/libxfs/xfs_trans_space.c |   25 ++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    6 ++-
 fs/xfs/scrub/orphanage.c        |    3 +
 fs/xfs/scrub/parent_repair.c    |    3 +
 fs/xfs/xfs_inode.c              |   80 ++++++++++++++++++++++++++++++++++++---
 7 files changed, 142 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 0ddaab08d722d..86c808157294e 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -229,3 +229,33 @@ xfs_parent_removename(
 	xfs_attr_defer_parent(&ppargs->args, XFS_ATTR_DEFER_REMOVE);
 	return 0;
 }
+
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
+	int			error;
+
+	error = xfs_parent_iread_extents(tp, child);
+	if (error)
+		return error;
+
+	xfs_inode_to_parent_rec(&ppargs->rec, old_dp);
+	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
+			child->i_ino, old_name);
+
+	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
+	ppargs->args.new_name = new_name->name;
+	ppargs->args.new_namelen = new_name->len;
+	ppargs->args.new_value = &ppargs->new_rec;
+	ppargs->args.new_valuelen = sizeof(struct xfs_parent_rec);
+	xfs_attr_defer_parent(&ppargs->args, XFS_ATTR_DEFER_REPLACE);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 4a7fd48c226a4..768633b313671 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -45,6 +45,7 @@ extern struct kmem_cache	*xfs_parent_args_cache;
  */
 struct xfs_parent_args {
 	struct xfs_parent_rec	rec;
+	struct xfs_parent_rec	new_rec;
 	struct xfs_da_args	args;
 };
 
@@ -84,5 +85,10 @@ int xfs_parent_addname(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 int xfs_parent_removename(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 		struct xfs_inode *dp, const struct xfs_name *parent_name,
 		struct xfs_inode *child);
+int xfs_parent_replacename(struct xfs_trans *tp,
+		struct xfs_parent_args *ppargs,
+		struct xfs_inode *old_dp, const struct xfs_name *old_name,
+		struct xfs_inode *new_dp, const struct xfs_name *new_name,
+		struct xfs_inode *child);
 
 #endif /* __XFS_PARENT_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index df729e4f1a4c9..b9dc3752f702c 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
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
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index a4490813c56f1..1155ff2d37e29 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
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
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 5e2c3546f2e95..94bcc2799188f 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -328,7 +328,8 @@ xrep_adoption_trans_alloc(
 	adopt->sc = sc;
 	adopt->orphanage_blkres = xfs_link_space_res(mp, MAXNAMELEN);
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
-		child_blkres = XFS_RENAME_SPACE_RES(mp, xfs_name_dotdot.len);
+		child_blkres = xfs_rename_space_res(mp, 0, false,
+						    xfs_name_dotdot.len, false);
 	adopt->child_blkres = child_blkres;
 
 	/*
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index ebb5791bf839e..63590e1b35060 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -171,7 +171,8 @@ xrep_parent_reset_dotdot(
 	 * Reserve more space just in case we have to expand the dir.  We're
 	 * allowed to exceed quota to repair inconsistent metadata.
 	 */
-	spaceres = XFS_RENAME_SPACE_RES(sc->mp, xfs_name_dotdot.len);
+	spaceres = xfs_rename_space_res(sc->mp, 0, false, xfs_name_dotdot.len,
+			false);
 	error = xfs_trans_reserve_more_inode(sc->tp, sc->ip, spaceres, 0,
 			true);
 	if (error)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 492d8d1055e9e..ea619f5140739 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3147,6 +3147,9 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
+	struct xfs_parent_args	*src_ppargs = NULL;
+	struct xfs_parent_args	*tgt_ppargs = NULL;
+	struct xfs_parent_args	*wip_ppargs = NULL;
 	int			i;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
@@ -3178,9 +3181,26 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+	error = xfs_parent_start(mp, &src_ppargs);
+	if (error)
+		goto out_release_wip;
+
+	if (wip) {
+		error = xfs_parent_start(mp, &wip_ppargs);
+		if (error)
+			goto out_src_ppargs;
+	}
+
+	if (target_ip) {
+		error = xfs_parent_start(mp, &tgt_ppargs);
+		if (error)
+			goto out_wip_ppargs;
+	}
+
 retry:
 	nospace_error = 0;
-	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
+	spaceres = xfs_rename_space_res(mp, src_name->len, target_ip != NULL,
+			target_name->len, wip != NULL);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		nospace_error = error;
@@ -3189,7 +3209,17 @@ xfs_rename(
 				&tp);
 	}
 	if (error)
-		goto out_release_wip;
+		goto out_tgt_ppargs;
+
+	/*
+	 * We don't allow reservationless renaming when parent pointers are
+	 * enabled because we can't back out if the xattrs must grow.
+	 */
+	if (src_ppargs && nospace_error) {
+		error = nospace_error;
+		xfs_trans_cancel(tp);
+		goto out_tgt_ppargs;
+	}
 
 	/*
 	 * Attach the dquots to the inodes
@@ -3197,7 +3227,7 @@ xfs_rename(
 	error = xfs_qm_vop_rename_dqattach(inodes);
 	if (error) {
 		xfs_trans_cancel(tp);
-		goto out_release_wip;
+		goto out_tgt_ppargs;
 	}
 
 	/*
@@ -3266,6 +3296,15 @@ xfs_rename(
 			goto out_trans_cancel;
 	}
 
+	/*
+	 * We don't allow quotaless renaming when parent pointers are enabled
+	 * because we can't back out if the xattrs must grow.
+	 */
+	if (src_ppargs && nospace_error) {
+		error = nospace_error;
+		goto out_trans_cancel;
+	}
+
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
@@ -3458,6 +3497,28 @@ xfs_rename(
 	if (error)
 		goto out_trans_cancel;
 
+	/* Schedule parent pointer updates. */
+	if (wip_ppargs) {
+		error = xfs_parent_addname(tp, wip_ppargs, src_dp, src_name,
+				wip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (src_ppargs) {
+		error = xfs_parent_replacename(tp, src_ppargs, src_dp,
+				src_name, target_dp, target_name, src_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (tgt_ppargs) {
+		error = xfs_parent_removename(tp, tgt_ppargs, target_dp,
+				target_name, target_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -3479,14 +3540,19 @@ xfs_rename(
 		xfs_dir_update_hook(src_dp, wip, 1, src_name);
 
 	error = xfs_finish_rename(tp);
-	xfs_iunlock_rename(inodes, num_inodes);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+	nospace_error = 0;
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
 	xfs_iunlock_rename(inodes, num_inodes);
+out_tgt_ppargs:
+	xfs_parent_finish(mp, tgt_ppargs);
+out_wip_ppargs:
+	xfs_parent_finish(mp, wip_ppargs);
+out_src_ppargs:
+	xfs_parent_finish(mp, src_ppargs);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);

