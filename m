Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99899C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbjEZCYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjEZCYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:24:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC286BC
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57ED064B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9281C433D2;
        Fri, 26 May 2023 02:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067851;
        bh=zEbWeecy1XgBP0RHw5H3LmUoWR4HJ3qhA2nO5nESjuA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EpM8N/7b7agLpLXvsJOBl7psyMt4eEqVTOwr3pw3UNSiD9vnGLJFwcorpVBR9Pcj0
         M7utWG76XfhBMKalWbkIakGkQos4mk/4Y6tUJ2+eCwyj8YcNWINkbnemcwimd1Iqxa
         tflJwabmeZLcO8t25akNiBkAuJV/EgL9jiUvsewuY79P+3ovme5NWG2trk1FsCccrA
         Yfg/MUDK6zQ4HKVV8CgY15xEDg0Pf3s9X0Dn8rqemzs53LKzq9c5l3RdEyK049Q9/l
         TIIZAz6qSIBQLjJZ/HsyehEYBdwGyxX9+ixIKKhaOCrPrOwBgCxbeO43ZIJgp67k6g
         bozWKNQ2urIew==
Date:   Thu, 25 May 2023 19:24:11 -0700
Subject: [PATCH 09/30] xfs: Add parent pointers to rename
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078010.3749421.13702370511328365450.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_attr.c        |    2 +
 libxfs/xfs_attr.h        |    1 +
 libxfs/xfs_parent.c      |   68 +++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_parent.h      |   23 ++++++++++++++--
 libxfs/xfs_trans_space.c |   25 +++++++++++++++++
 libxfs/xfs_trans_space.h |    6 +++-
 6 files changed, 115 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4663eaa4c54..3aabca58b14 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -934,7 +934,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 06b6494511d..24616bb07e9 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -551,6 +551,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index ed75f5acf24..fe27dabc50d 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -118,6 +118,19 @@ xfs_init_parent_davalue(
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
@@ -125,22 +138,27 @@ xfs_init_parent_davalue(
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
@@ -216,12 +234,52 @@ xfs_parent_remove(
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
-	xlog_drop_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_XATTRS);
+	if (parent->have_log)
+		xlog_drop_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_XATTRS);
 	kmem_cache_free(xfs_parent_intent_cache, parent);
 }
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 19532935f6c..637f99fba9d 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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

