Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C548F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928653; cv=none; b=ouicJYcOh1TR8ZUrfi8v34yboWH7127x2CFPNoXV2XnyEZgrAGsNcI0hJAUgIypY+AUOSwCG+OFaScSY0sAIravPMSqgP4t3zWjJryP5BqUmQx1a9ILHAaEUdTFcVukcakyK3BpxCyBnbtm7igf+a1ELYmPoLabSuBOmPAmpYBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928653; c=relaxed/simple;
	bh=pclXWA3xWsucI338/pa/mQpGWlxo+j+M8LSWoPSvLyE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COYsM7B5/cinjpDlMR+yZQ2OIL4I7pgt5P+trbeV0WqXuMYYpADxPmrVk+7SttFRkygH9KCWn5s7yu+D01VLPIhVVXu34PGVZeVxYzENuKC9axAvfG1HuMxOnUF0af+uScBCkErnYs6+6wpCcUDscYBqpJqeEnU0cbhiUF6BsvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qaJTV/bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qaJTV/bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C4DC116B1;
	Wed, 24 Apr 2024 03:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928653;
	bh=pclXWA3xWsucI338/pa/mQpGWlxo+j+M8LSWoPSvLyE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qaJTV/bRY1w7JIqU3y4H+Np0TSe78i5eCPoCseQIn9Vg6+emzESv/VMA15STgcbBH
	 5Nncb0gjoz8r6mJa0PPp3o9h/RpIObDpR5DFYp3p+LEGSqBPlyXC0OlDRGzKAGfrJA
	 ryFysLhKIxOEnT2+6W2rYgGy759qlSpzOs2JyqslBzvy7S5zJLgecoAV2eWNIAX/Dq
	 54IDNPc5CuSN6Q1bFzVxX3v8WFa9X0wdrUFruFSBdNUGkvMRUbkZO3sQlMxIWxGBc7
	 Hoj2UzZXSQ/ZD7TNnYJPeTAYYUt11TCBke7svNluerCH0KLcQOifII5REm5AyMRlMj
	 YxMHyS0pEtRGw==
Date: Tue, 23 Apr 2024 20:17:32 -0700
Subject: [PATCH 19/30] xfs: Add parent pointers to rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783589.1905110.12457568902263247751.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 6142e68f2338..fdf643bfde4d 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -227,3 +227,33 @@ xfs_parent_removename(
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REMOVE);
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
+	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REPLACE);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 4a7fd48c226a..768633b31367 100644
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
index df729e4f1a4c..b9dc3752f702 100644
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
index a4490813c56f..1155ff2d37e2 100644
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
index 5e2c3546f2e9..94bcc2799188 100644
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
index ebb5791bf839..63590e1b3506 100644
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
index c4a1c2dd5261..59488c17e1c1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3148,6 +3148,9 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
+	struct xfs_parent_args	*src_ppargs = NULL;
+	struct xfs_parent_args	*tgt_ppargs = NULL;
+	struct xfs_parent_args	*wip_ppargs = NULL;
 	int			i;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
@@ -3179,9 +3182,26 @@ xfs_rename(
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
@@ -3190,7 +3210,17 @@ xfs_rename(
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
@@ -3198,7 +3228,7 @@ xfs_rename(
 	error = xfs_qm_vop_rename_dqattach(inodes);
 	if (error) {
 		xfs_trans_cancel(tp);
-		goto out_release_wip;
+		goto out_tgt_ppargs;
 	}
 
 	/*
@@ -3267,6 +3297,15 @@ xfs_rename(
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
@@ -3459,6 +3498,28 @@ xfs_rename(
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
@@ -3480,14 +3541,19 @@ xfs_rename(
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

