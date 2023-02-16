Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A10C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjBPUh5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPUhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:37:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222E6C64B
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:37:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A469760C0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10260C433EF;
        Thu, 16 Feb 2023 20:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579873;
        bh=jp1tVkkQz6ODQam1C0xiEDF8g4JQIc0QATo2F9x4BFo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=LmUb1raHCGe9OMVIVFYJbZrc5u7D7tc6E49umWZtOSNC9qDIqCDD1dHE91Os0G6/9
         px09yaCsBnvLj7UzTLfmG56Z17/ZKpP0GAB69rf16TxucsAFgF08w7X3yodLVjYm89
         YnFXIqk2Gh+9SQOKqaPghIS1Yjtn2nNSXq7bOad0EzhoR5gjO7ZdO+2SJJNjFl/MZq
         hboysrFgPnBdUtUA893TVmyQ6VHJaRMPweEBcsn0mFxe1lXRy7CV0HoSWShfX1+UTe
         lmCc5wCfsLAG441Gy/raHgAnsaa13EiUGX9FtsAQ9lQCmAtqAU1AUbhShWwRamRuto
         3capdrA9mvh7g==
Date:   Thu, 16 Feb 2023 12:37:52 -0800
Subject: [PATCH 20/28] xfs: Add parent pointers to rename
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657872670.3473407.14365632577962680788.stgit@magnolia>
In-Reply-To: <167657872335.3473407.14628732092515467392.stgit@magnolia>
References: <167657872335.3473407.14628732092515467392.stgit@magnolia>
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
---
 fs/xfs/libxfs/xfs_attr.c        |    2 -
 fs/xfs/libxfs/xfs_attr.h        |    1 
 fs/xfs/libxfs/xfs_parent.c      |   47 ++++++++++++++--
 fs/xfs/libxfs/xfs_parent.h      |   24 +++++++-
 fs/xfs/libxfs/xfs_trans_space.h |    2 -
 fs/xfs/xfs_inode.c              |  117 ++++++++++++++++++++++++++++++++++++---
 6 files changed, 174 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a8db44728b11..57080ea4c869 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -923,7 +923,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 033005542b9e..985761264d1f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 245855a5f969..629762701952 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -64,22 +64,27 @@ xfs_init_parent_name_rec(
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
@@ -132,12 +137,44 @@ xfs_parent_defer_remove(
 	return xfs_attr_defer_remove(args);
 }
 
+
+int
+xfs_parent_defer_replace(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*new_parent,
+	struct xfs_inode	*old_dp,
+	xfs_dir2_dataptr_t	old_diroffset,
+	struct xfs_name		*parent_name,
+	struct xfs_inode	*new_dp,
+	xfs_dir2_dataptr_t	new_diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &new_parent->args;
+
+	xfs_init_parent_name_rec(&new_parent->old_rec, old_dp, old_diroffset);
+	xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_diroffset);
+	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
+	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
+	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	args->trans = tp;
+	args->dp = child;
+
+	ASSERT(parent_name != NULL);
+	new_parent->args.value = (void *)parent_name->name;
+	new_parent->args.valuelen = parent_name->len;
+
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_replace(args);
+}
+
 void
 __xfs_parent_cancel(
 	xfs_mount_t		*mp,
 	struct xfs_parent_defer *parent)
 {
-	xlog_drop_incompat_feat(mp->m_log);
+	if (parent->have_log)
+		xlog_drop_incompat_feat(mp->m_log);
 	kmem_cache_free(xfs_parent_intent_cache, parent);
 }
 
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 0f39d033d84e..039005883bb6 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -14,7 +14,9 @@ extern struct kmem_cache	*xfs_parent_intent_cache;
  */
 struct xfs_parent_defer {
 	struct xfs_parent_name_rec	rec;
+	struct xfs_parent_name_rec	old_rec;
 	struct xfs_da_args		args;
+	bool				have_log;
 };
 
 /*
@@ -23,7 +25,8 @@ struct xfs_parent_defer {
 void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      struct xfs_inode *ip,
 			      uint32_t p_diroffset);
-int __xfs_parent_init(struct xfs_mount *mp, struct xfs_parent_defer **parentp);
+int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
+		struct xfs_parent_defer **parentp);
 
 static inline int
 xfs_parent_start(
@@ -33,13 +36,30 @@ xfs_parent_start(
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
 
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_replace(struct xfs_trans *tp,
+		struct xfs_parent_defer *new_parent, struct xfs_inode *old_dp,
+		xfs_dir2_dataptr_t old_diroffset, struct xfs_name *parent_name,
+		struct xfs_inode *new_ip, xfs_dir2_dataptr_t new_diroffset,
+		struct xfs_inode *child);
 int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
 			    struct xfs_parent_defer *parent,
 			    xfs_dir2_dataptr_t diroffset,
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
index 2d8f225cb57d..cdbd7df64ff0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2871,7 +2871,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+				   xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
@@ -2897,6 +2897,31 @@ xfs_rename_alloc_whiteout(
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
+			ret += xfs_pptr_calc_space_res(mp, src_name->len);
+		ret += 2 * xfs_pptr_calc_space_res(mp, target_name->len);
+	}
+	if (target_parent_ptr)
+		ret += xfs_pptr_calc_space_res(mp, target_name->len);
+
+	return ret;
+}
+
 /*
  * xfs_rename
  */
@@ -2923,6 +2948,11 @@ xfs_rename(
 	int				spaceres;
 	bool				retried = false;
 	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*src_ip_pptr = NULL;
+	struct xfs_parent_defer		*tgt_ip_pptr = NULL;
+	struct xfs_parent_defer		*wip_pptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2947,9 +2977,26 @@ xfs_rename(
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
@@ -2958,14 +3005,26 @@ xfs_rename(
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
@@ -3032,6 +3091,15 @@ xfs_rename(
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
@@ -3122,7 +3190,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3143,7 +3211,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3216,14 +3284,38 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres, NULL);
+					spaceres, &old_diroffset);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres, NULL);
+					   spaceres, &old_diroffset);
 
 	if (error)
 		goto out_trans_cancel;
 
+	if (wip_pptr) {
+		error = xfs_parent_defer_add(tp, wip_pptr,
+					     src_dp, src_name,
+					     old_diroffset, wip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (src_ip_pptr) {
+		error = xfs_parent_defer_replace(tp, src_ip_pptr, src_dp,
+				old_diroffset, target_name, target_dp,
+				new_diroffset, src_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (tgt_ip_pptr) {
+		error = xfs_parent_defer_remove(tp, target_dp,
+						tgt_ip_pptr,
+						new_diroffset, target_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -3237,6 +3329,13 @@ xfs_rename(
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

