Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C34C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbjDFTeL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236891AbjDFTeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:34:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D14A255
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEDAF64B94
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B884C433EF;
        Thu,  6 Apr 2023 19:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809635;
        bh=zmkt8BmpGiySKsl6QNYor76882oCPuY6bByTMOFOVKI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=B8VdW4cPymIGhDf4fJ48h9E+tOh2URWp/3emjGeyku5jpD7HTgEGdSYl/xup7dmWc
         aQEmWIhUvAvVXkJJGGFK9u7GTCJxNX8ytHbJc+p2PN0lOSThMS5lXNDxhzXxrPpm7G
         M2twdiymG21x2tqBpGZt9tZQLPKAw5ZcngHSd+2zNp/ViVkNnkCA66PWDKMZLQKM/L
         g1bUBQNiq2OSJXrlTZpl1SYMlU9Uoav9A5BR2Ho9WCM7HilaxYx+liMlYuXyUOjQHC
         39wnUtejjBZHeOd6KWfNldL3u/09MpwW+cp8GJpdInK6Zm0WFeGZjI+/FXmsvx9AH2
         FgNCFXfFEcC5w==
Date:   Thu, 06 Apr 2023 12:33:54 -0700
Subject: [PATCH 09/32] xfs: remove parent pointers in unlink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827676.616793.5681339109484884112.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_attr.c        |    2 +-
 libxfs/xfs_attr.h        |    1 +
 libxfs/xfs_parent.c      |   22 ++++++++++++++++++++++
 libxfs/xfs_parent.h      |    4 ++++
 libxfs/xfs_trans_space.h |    2 --
 repair/phase6.c          |    6 +++---
 6 files changed, 31 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4e1d9551a..30d1a2992 100644
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
index 1002e431b..07c61bd70 100644
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
index ca1c6eeaf..b06033243 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -183,6 +183,28 @@ xfs_parent_add(
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
index 8e7dbe22e..0f8194cd8 100644
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
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 25a55650b..b5ab6701e 100644
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
diff --git a/repair/phase6.c b/repair/phase6.c
index 0be2c9c97..40d7e17b1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1266,7 +1266,7 @@ longform_dir2_rebuild(
 	    libxfs_dir_ino_validate(mp, pip.i_ino))
 		pip.i_ino = mp->m_sb.sb_rootino;
 
-	nres = XFS_REMOVE_SPACE_RES(mp);
+	nres = XFS_DIRREMOVE_SPACE_RES(mp);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
@@ -1371,7 +1371,7 @@ dir2_kill_block(
 	int		nres;
 	xfs_trans_t	*tp;
 
-	nres = XFS_REMOVE_SPACE_RES(mp);
+	nres = XFS_DIRREMOVE_SPACE_RES(mp);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	if (error)
 		res_failed(error);
@@ -2887,7 +2887,7 @@ process_dir_inode(
 			 * inode but it's easier than wedging a
 			 * new define in ourselves.
 			 */
-			nres = no_modify ? 0 : XFS_REMOVE_SPACE_RES(mp);
+			nres = no_modify ? 0 : XFS_DIRREMOVE_SPACE_RES(mp);
 			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
 						    nres, 0, 0, &tp);
 			if (error)

