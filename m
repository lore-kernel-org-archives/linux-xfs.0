Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1796C59B42
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798277; cv=none; b=sJTCk0j/B9ayrVLlXfAaVRRNPnxxFTzr1IglFBt8pn618OuB/6iU9aOtZeD6zVimqmpfvPvIPOIy5gC0ADHvgNzkFXUt87WdI5K5YStER554Js1YmA+Yx51DCpS15Zkp8lIycTu/DeyJ1BorAJybqWVylXHPOlUvmLX8ahfQfFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798277; c=relaxed/simple;
	bh=dmRkyVFobZ6puTl0V+O3+nW6BaDPlaTKlIl18eUkLCE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sTl97BH3S2Y1inf33HseHbAF6fXBy1V3s0P5YIAOhAxUxQDpr9ha8K4w7lESnyxOwy5VeOqui8CMX/DsTYhGSbG6PHMEOGIZm65UK43+bjnFN4qqq/Pj98Ju/2G9uniIpOoiydr63zT5RqMfBnrR2MouyFQ298Amgd/Mi0MpCBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWR0Hn8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWR0Hn8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2E8C433C7;
	Mon, 18 Mar 2024 21:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798276;
	bh=dmRkyVFobZ6puTl0V+O3+nW6BaDPlaTKlIl18eUkLCE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fWR0Hn8wBYvP+UbyG9VMYQqfCuPJT8gsMePwMt56LKvfAZbZZzH8P1wsrMBqjrc5u
	 zzAAJ9DfHKn+UjQtZ4mn2o1r4fmEG0Sxbpzg5JNdL4XmsLjQweoZcYzcexYxFkGKg5
	 wthnqSFSmJQe5lVCHl3GrWH+0//93BqqOMhyCSJCsgD9cWLszN02p4ZsvuKv3pBqyQ
	 m/cf7mYRcB4dLUosY/jej9MpHTHPxmIEWzzA2lMvlwZ/vy5PA9ZbLf+tzNWd0kM4rH
	 hzzPrRaxITvmHsZrcm9NsntKochKiQDWIOdGV9rRD8KLoCFKGR1xYvGgkrtd1gbrZz
	 tT4ZkYXnzz+AQ==
Date: Mon, 18 Mar 2024 14:44:36 -0700
Subject: [PATCH 10/23] xfs: Add parent pointers to rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802037.3806377.2725782674043339202.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_parent.c      |   63 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |   20 +++++++++++
 fs/xfs/libxfs/xfs_trans_space.c |   25 +++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    6 ++-
 fs/xfs/scrub/orphanage.c        |    3 +-
 fs/xfs/scrub/parent_repair.c    |    3 +-
 fs/xfs/xfs_inode.c              |   73 +++++++++++++++++++++++++++++++++++----
 7 files changed, 182 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 1c3542d264618..1bff67f8f1176 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -138,6 +138,19 @@ xfs_init_parent_davalue(
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
@@ -233,6 +246,56 @@ xfs_parent_removename(
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 31349130a330e..c68c501388e82 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
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
index 84e6dcef067c1..ace7a0f23e474 100644
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
index 2bb4cfbeffe82..1e68bd9e2872f 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -169,7 +169,8 @@ xrep_parent_reset_dotdot(
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
index 41debaad299d6..534569bf89619 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3152,6 +3152,9 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
+	struct xfs_parent_args	*src_ppargs = NULL;
+	struct xfs_parent_args	*tgt_ppargs = NULL;
+	struct xfs_parent_args	*wip_ppargs = NULL;
 	int			i;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
@@ -3183,9 +3186,26 @@ xfs_rename(
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
@@ -3194,7 +3214,17 @@ xfs_rename(
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
@@ -3202,7 +3232,7 @@ xfs_rename(
 	error = xfs_qm_vop_rename_dqattach(inodes);
 	if (error) {
 		xfs_trans_cancel(tp);
-		goto out_release_wip;
+		goto out_tgt_ppargs;
 	}
 
 	/*
@@ -3271,6 +3301,15 @@ xfs_rename(
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
@@ -3463,6 +3502,21 @@ xfs_rename(
 	if (error)
 		goto out_trans_cancel;
 
+	/* Schedule parent pointer updates. */
+	error = xfs_parent_add(tp, wip_ppargs, src_dp, src_name, wip);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_parent_replace(tp, src_ppargs, src_dp, src_name, target_dp,
+			target_name, src_ip);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_parent_remove(tp, tgt_ppargs, target_dp, target_name,
+			target_ip);
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -3484,14 +3538,19 @@ xfs_rename(
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

