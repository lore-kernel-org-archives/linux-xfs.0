Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60598C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbjDFTXv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjDFTXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:23:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55FC658B
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46AC362B3F
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A33C433D2;
        Thu,  6 Apr 2023 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809027;
        bh=nWh5LuiPfhbToMK+uYRJZILi2da6tc4VMhq79xXXynA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WC1PrO4+gTBqRfY1SKq9YjaFX/6vYt9jTy5EyRaBJaqId447x7oi3RM3ktlfDBPd2
         f+9RLRJ2DIWvEuhyQXIr9VxoUfVK2hhQCb7dRXI85IFDZ1OJ8utrehQxtjA9m2jx1V
         4My6ci+k110OAOX9yHrmbvIOA3rfit/sOwrmYGIOTu26F8i/FqtvR7OHB9nIeWtbf6
         5GrTKGW2AdLQutzcTjl+5UXPEsSMYyP7sxIo6rUqRqRExAREcz7oD1Us1HeZGeHM5a
         QzRtDuzNh2bJ0CEiFM+98Dr9BRRAPJrlf8naEqoX8IhGDD+aJzk3XapGfP05go82Lo
         kfHEHIOHbnwtQ==
Date:   Thu, 06 Apr 2023 12:23:47 -0700
Subject: [PATCH 13/23] xfs: Add parent pointers to rename
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824843.615225.16178458377517375282.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
References: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        |    2 -
 fs/xfs/libxfs/xfs_attr.h        |    1 
 fs/xfs/libxfs/xfs_parent.c      |   58 ++++++++++++++++++++--
 fs/xfs/libxfs/xfs_parent.h      |   23 ++++++++-
 fs/xfs/libxfs/xfs_trans_space.h |    2 -
 fs/xfs/xfs_inode.c              |  103 +++++++++++++++++++++++++++++++++++++--
 6 files changed, 174 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 37c86274b568..e1e0a5fd3418 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -936,7 +936,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 07c61bd70ef8..3ad1f12a511a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -551,6 +551,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 393409502770..977412b8f9f3 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -116,6 +116,19 @@ xfs_init_parent_davalue(
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
@@ -123,22 +136,27 @@ xfs_init_parent_davalue(
 int
 __xfs_parent_init(
 	struct xfs_mount		*mp,
+	bool				grab_log,
 	struct xfs_parent_defer		**parentp)
 {
 	struct xfs_parent_defer		*parent;
 	int				error;
 
-	error = xfs_attr_grab_log_assist(mp);
-	if (error)
-		return error;
+	if (grab_log) {
+		error = xfs_attr_grab_log_assist(mp);
+		if (error)
+			return error;
+	}
 
 	parent = kmem_cache_zalloc(xfs_parent_intent_cache, GFP_KERNEL);
 	if (!parent) {
-		xfs_attr_rele_log_assist(mp);
+		if (grab_log)
+			xfs_attr_rele_log_assist(mp);
 		return -ENOMEM;
 	}
 
 	/* init parent da_args */
+	parent->have_log = grab_log;
 	parent->args.geo = mp->m_attr_geo;
 	parent->args.whichfork = XFS_ATTR_FORK;
 	parent->args.attr_filter = XFS_ATTR_PARENT;
@@ -204,13 +222,43 @@ xfs_parent_remove(
 	return xfs_attr_defer_remove(args);
 }
 
+/* Replace one parent pointer with another to reflect a rename. */
+int
+xfs_parent_replace(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*old_dp,
+	const struct xfs_name	*old_name,
+	struct xfs_inode	*new_dp,
+	const struct xfs_name	*new_name,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, old_dp, old_name, child);
+	args->hashval = xfs_parent_hashname(old_dp, parent);
+
+	xfs_init_parent_name_rec(&parent->new_rec, new_dp, new_name, child);
+	args->new_name = (const uint8_t *)&parent->new_rec;
+	args->new_namelen = sizeof(struct xfs_parent_name_rec);
+
+	args->trans = tp;
+	args->dp = child;
+
+	xfs_init_parent_davalue(&parent->args, old_name);
+	xfs_init_parent_danewvalue(&parent->args, new_name);
+
+	return xfs_attr_defer_replace(args);
+}
+
 /* Cancel a parent pointer operation. */
 void
 __xfs_parent_cancel(
 	struct xfs_mount	*mp,
 	struct xfs_parent_defer	*parent)
 {
-	xlog_drop_incompat_feat(mp->m_log);
+	if (parent->have_log)
+		xlog_drop_incompat_feat(mp->m_log);
 	kmem_cache_free(xfs_parent_intent_cache, parent);
 }
 
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 0f8194cd8a9f..f4a0793bc4fc 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -21,10 +21,13 @@ extern struct kmem_cache	*xfs_parent_intent_cache;
  */
 struct xfs_parent_defer {
 	struct xfs_parent_name_rec	rec;
+	struct xfs_parent_name_rec	new_rec;
 	struct xfs_da_args		args;
+	bool				have_log;
 };
 
-int __xfs_parent_init(struct xfs_mount *mp, struct xfs_parent_defer **parentp);
+int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
+		struct xfs_parent_defer **parentp);
 
 static inline int
 xfs_parent_start(
@@ -34,7 +37,19 @@ xfs_parent_start(
 	*pp = NULL;
 
 	if (xfs_has_parent(mp))
-		return __xfs_parent_init(mp, pp);
+		return __xfs_parent_init(mp, true, pp);
+	return 0;
+}
+
+static inline int
+xfs_parent_start_locked(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	**pp)
+{
+	*pp = NULL;
+
+	if (xfs_has_parent(mp))
+		return __xfs_parent_init(mp, false, pp);
 	return 0;
 }
 
@@ -44,6 +59,10 @@ int xfs_parent_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 int xfs_parent_remove(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 		struct xfs_inode *dp, const struct xfs_name *parent_name,
 		struct xfs_inode *child);
+int xfs_parent_replace(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+		struct xfs_inode *old_dp, const struct xfs_name *old_name,
+		struct xfs_inode *new_dp, const struct xfs_name *new_name,
+		struct xfs_inode *child);
 
 void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
 
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index b5ab6701e7fb..810610a14c4d 100644
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
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1c09ae7d4ed5..5ad934358791 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2865,7 +2865,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+				   xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
@@ -2891,6 +2891,31 @@ xfs_rename_alloc_whiteout(
 	return 0;
 }
 
+static unsigned int
+xfs_rename_space_res(
+	struct xfs_mount	*mp,
+	struct xfs_name		*src_name,
+	struct xfs_parent_defer	*target_parent_ptr,
+	struct xfs_name		*target_name,
+	struct xfs_parent_defer	*new_parent_ptr,
+	struct xfs_inode	*wip)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRREMOVE_SPACE_RES(mp) +
+			XFS_DIRENTER_SPACE_RES(mp, target_name->len);
+
+	if (new_parent_ptr) {
+		if (wip)
+			ret += xfs_parent_calc_space_res(mp, src_name->len);
+		ret += 2 * xfs_parent_calc_space_res(mp, target_name->len);
+	}
+	if (target_parent_ptr)
+		ret += xfs_parent_calc_space_res(mp, target_name->len);
+
+	return ret;
+}
+
 /*
  * xfs_rename
  */
@@ -2917,6 +2942,9 @@ xfs_rename(
 	int				spaceres;
 	bool				retried = false;
 	int				error, nospace_error = 0;
+	struct xfs_parent_defer		*src_ip_pptr = NULL;
+	struct xfs_parent_defer		*tgt_ip_pptr = NULL;
+	struct xfs_parent_defer		*wip_pptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2941,9 +2969,26 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+	error = xfs_parent_start(mp, &src_ip_pptr);
+	if (error)
+		goto out_release_wip;
+
+	if (wip) {
+		error = xfs_parent_start_locked(mp, &wip_pptr);
+		if (error)
+			goto out_src_ip_pptr;
+	}
+
+	if (target_ip) {
+		error = xfs_parent_start_locked(mp, &tgt_ip_pptr);
+		if (error)
+			goto out_wip_pptr;
+	}
+
 retry:
 	nospace_error = 0;
-	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
+	spaceres = xfs_rename_space_res(mp, src_name, tgt_ip_pptr,
+			target_name, src_ip_pptr, wip);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		nospace_error = error;
@@ -2952,14 +2997,26 @@ xfs_rename(
 				&tp);
 	}
 	if (error)
-		goto out_release_wip;
+		goto out_tgt_ip_pptr;
+
+	/*
+	 * We don't allow reservationless renaming when parent pointers are
+	 * enabled because we can't back out if the xattrs must grow.
+	 */
+	if (src_ip_pptr && nospace_error) {
+		error = nospace_error;
+		xfs_trans_cancel(tp);
+		goto out_tgt_ip_pptr;
+	}
 
 	/*
 	 * Attach the dquots to the inodes
 	 */
 	error = xfs_qm_vop_rename_dqattach(inodes);
-	if (error)
-		goto out_trans_cancel;
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_tgt_ip_pptr;
+	}
 
 	/*
 	 * Lock all the participating inodes. Depending upon whether
@@ -3026,6 +3083,15 @@ xfs_rename(
 			goto out_trans_cancel;
 	}
 
+	/*
+	 * We don't allow quotaless renaming when parent pointers are enabled
+	 * because we can't back out if the xattrs must grow.
+	 */
+	if (src_ip_pptr && nospace_error) {
+		error = nospace_error;
+		goto out_trans_cancel;
+	}
+
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
@@ -3218,6 +3284,26 @@ xfs_rename(
 	if (error)
 		goto out_trans_cancel;
 
+	if (wip_pptr) {
+		error = xfs_parent_add(tp, wip_pptr, src_dp, src_name, wip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (src_ip_pptr) {
+		error = xfs_parent_replace(tp, src_ip_pptr, src_dp, src_name,
+				target_dp, target_name, src_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (tgt_ip_pptr) {
+		error = xfs_parent_remove(tp, tgt_ip_pptr, target_dp,
+				target_name, target_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -3231,6 +3317,13 @@ xfs_rename(
 	xfs_trans_cancel(tp);
 out_unlock:
 	xfs_iunlock_rename(inodes, num_inodes);
+out_tgt_ip_pptr:
+	xfs_parent_finish(mp, tgt_ip_pptr);
+out_wip_pptr:
+	xfs_parent_finish(mp, wip_pptr);
+out_src_ip_pptr:
+	xfs_parent_finish(mp, src_ip_pptr);
+
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);

