Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D10C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbjEZCX7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjEZCX6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5AF9B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09E864C3C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0FBC433D2;
        Fri, 26 May 2023 02:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067836;
        bh=nnFicAGT37VVFEBL4FSbNqvouXN4gkt/shnnVBsZNtQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=TS7x7fC8LMvybwuwoxYCsJlM4PRcJI/h2AWAme6cSEoYqAptoIGX61nLG1b+7P1x6
         J+m1dcl2n5lQpRiFPFf/cUmhsK1HUUxoL/XP23LWKk4rUoCM0in5NqlFK6g5BWfnqQ
         xEmJxg/bVeFhQO0iOUiMA4tz9Ek6mzW0kWXQZ5mh3KWqOo6oHBQTcAs1E3Ipk3Kkom
         mloZk2NloDBCqnTFzyr5UG/L0QXoBMYLnYM7Ynk9ytUrpINnEakBpf51z/memBgAlE
         h71fvG2CVW5lq0xCDqhlyYmpodhxe5owu8h1HPWw0vuIRtJ0aEwxoTy5zqjtdcEFH/
         61zk1+wt+8uMQ==
Date:   Thu, 25 May 2023 19:23:55 -0700
Subject: [PATCH 08/30] xfs: remove parent pointers in unlink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077997.3749421.11321341527340811231.stgit@frogsfrogsfrogs>
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

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format, minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/xfs_attr.c        |    2 +-
 libxfs/xfs_attr.h        |    1 +
 libxfs/xfs_parent.c      |   33 +++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h      |    4 ++++
 libxfs/xfs_trans_space.c |   13 +++++++++++++
 libxfs/xfs_trans_space.h |    3 +--
 repair/phase6.c          |    6 +++---
 8 files changed, 57 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1e2cfa0ec22..de653b2656a 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -188,6 +188,7 @@
 #define xfs_refcountbt_stage_cursor	libxfs_refcountbt_stage_cursor
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
 #define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
+#define xfs_remove_space_res		libxfs_remove_space_res
 
 #define xfs_rmap_alloc			libxfs_rmap_alloc
 #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index eb32db32b65..4663eaa4c54 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -957,7 +957,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index d77c132ff54..06b6494511d 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -550,6 +550,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 88188d282e6..ed75f5acf24 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -28,6 +28,7 @@
 #include "xfs_da_format.h"
 #include "xfs_format.h"
 #include "xfs_trans_space.h"
+#include "xfs_health.h"
 
 struct kmem_cache		*xfs_parent_intent_cache;
 
@@ -183,6 +184,38 @@ xfs_parent_add(
 	return xfs_attr_defer_add(args);
 }
 
+/* Remove a parent pointer to reflect a dirent removal. */
+int
+xfs_parent_remove(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*parent_name,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
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
+	xfs_init_parent_name_rec(&parent->rec, dp, parent_name, child);
+	args->hashval = xfs_parent_hashname(dp, parent);
+
+	args->trans = tp;
+	args->dp = child;
+
+	xfs_init_parent_davalue(&parent->args, parent_name);
+
+	return xfs_attr_defer_remove(args);
+}
+
 /* Cancel a parent pointer operation. */
 void
 __xfs_parent_cancel(
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 43551956508..19532935f6c 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -41,6 +41,10 @@ xfs_parent_start(
 int xfs_parent_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 		struct xfs_inode *dp, const struct xfs_name *parent_name,
 		struct xfs_inode *child);
+int xfs_parent_remove(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child);
+
 void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
 
 static inline void
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
index 4b49dcaa454..b99ce4c2aa4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1259,7 +1259,7 @@ longform_dir2_rebuild(
 	    libxfs_dir_ino_validate(mp, pip.i_ino))
 		pip.i_ino = mp->m_sb.sb_rootino;
 
-	nres = XFS_REMOVE_SPACE_RES(mp);
+	nres = libxfs_remove_space_res(mp, 0);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
@@ -1365,7 +1365,7 @@ dir2_kill_block(
 	int		nres;
 	xfs_trans_t	*tp;
 
-	nres = XFS_REMOVE_SPACE_RES(mp);
+	nres = libxfs_remove_space_res(mp, 0);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
@@ -2884,7 +2884,7 @@ process_dir_inode(
 			 * inode but it's easier than wedging a
 			 * new define in ourselves.
 			 */
-			nres = no_modify ? 0 : XFS_REMOVE_SPACE_RES(mp);
+			nres = no_modify ? 0 : libxfs_remove_space_res(mp, 0);
 			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
 						    nres, 0, 0, &tp);
 			if (error)

