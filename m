Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21C4C636D7
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjBPU5a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjBPU53 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:57:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDF850348
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:57:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E633CB82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A827EC433EF;
        Thu, 16 Feb 2023 20:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581045;
        bh=+m0D2ZL7wlIhJ6e7oP7v1yDjOx/fw4Tavc8rO8O//Y0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tKyy5/0tjZNcGOY7nw29xhjy/AWj4s+ErwMPu2KjNymufd9JsMdyT7ZnZ7678cHB+
         MiKAo9ov86PGCQUG1uJEGIh2ApfRWBchi/me+m1r0fsFyli2oPbtqZ1AkQPQimml9j
         EowxrnyMAXD2dNNTa5BDegMMonKtwLsQzmblVdbCPFzaF2/FUAynSqOUbmrXm5bIIf
         s6iNlZjQrOH9/ZBQtQ7OdRlxQWzZL94acYmbdrIuYZef5RZm5wj+c1nyTklJgIOilH
         u6e5wzUmlfKbIVEkL8nKT0Fq6nweASsimiZaeZDYO9kIPOixxm0D7B+EKwh8R7L44f
         0ang4LWSh72iQ==
Date:   Thu, 16 Feb 2023 12:57:25 -0800
Subject: [PATCH 15/25] xfsprogs: Add parent pointers to rename
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879108.3476112.8331830884740886775.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.  In the case of
xfs_cross_rename, we modify the routine not to roll the transaction just
yet.  We will do this after the parent pointer is added in the calling
xfs_rename function.

Source kernel commit: d00721b30fd1923f6e9e9c1ca6f2a74cfc4ed5d3

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
[djwong: fix indent with kernel]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c        |    2 +-
 libxfs/xfs_attr.h        |    1 +
 libxfs/xfs_parent.c      |   47 +++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_parent.h      |   24 ++++++++++++++++++++++-
 libxfs/xfs_trans_space.h |    2 --
 5 files changed, 66 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 04cafc5f..0cb76f8f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -921,7 +921,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 03300554..98576126 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index b137cfda..3f02271f 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -65,22 +65,27 @@ xfs_init_parent_name_rec(
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
@@ -133,12 +138,44 @@ xfs_parent_defer_remove(
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
 
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 0f39d033..03900588 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index b5ab6701..810610a1 100644
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
 

