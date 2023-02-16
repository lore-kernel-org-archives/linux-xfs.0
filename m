Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEC3C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjBPU5S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBPU5R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:57:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175B2521FD
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:57:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3BDB60A55
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB3AC433D2;
        Thu, 16 Feb 2023 20:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581030;
        bh=TDYCZVurn5Mzd4DlgIE9Nf4jwyCApIFlsyh17exO6zU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=o83zc6r2ewWZ95MAHXnq5eb44HyXN0HQ/WX57mVdievC3MD4nzVjGHxgUKY3KRBB1
         iV0gw7Qe49as7VK7bf3rCiqIUxcW0yx9QYbG2CoY0+G10CGtmsUC5vME3Uqw+TjN9a
         Y+uCutq6t7MBxxebrArctbcci8wwxoZqTkziSrA9IBo6UE2XH2RrB/3EqXOEnUNSeT
         pBNbjdTYouIwekviybDmkIie+qN1XPzeNT2fQn+Ax4Nj97e4y5oUeP54cilmR+2pLH
         2idsf4Aq8GC7fmNTZ1ixYcW5CW6VdIv/A3fqHWqJgWteZvJrEWn2TmQL6kBzVKVtgW
         A8GgS0HQ9uKVQ==
Date:   Thu, 16 Feb 2023 12:57:09 -0800
Subject: [PATCH 14/25] xfsprogs: remove parent pointers in unlink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879093.3476112.7527681927685399317.stgit@magnolia>
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

Source kernel commit: b9ffc3d05531820aea30b2caf3368c312d8b2508

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c        |    2 +-
 libxfs/xfs_attr.h        |    1 +
 libxfs/xfs_parent.c      |   17 +++++++++++++++++
 libxfs/xfs_parent.h      |    5 +++++
 libxfs/xfs_trans_space.h |    2 --
 repair/phase6.c          |    6 +++---
 6 files changed, 27 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index edf7e1ee..04cafc5f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -944,7 +944,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 0cf23f51..03300554 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index e0a59998..b137cfda 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -116,6 +116,23 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+int
+xfs_parent_defer_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->trans = tp;
+	args->dp = child;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_remove(args);
+}
+
 void
 __xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index d5a8c8e5..0f39d033 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -40,6 +40,11 @@ xfs_parent_start(
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset,
+			    struct xfs_inode *child);
+
 void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
 
 static inline void
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 25a55650..b5ab6701 100644
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
index a347c390..e202398e 100644
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

