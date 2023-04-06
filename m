Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFB8C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239470AbjDFTXT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjDFTXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:23:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4E759EA
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2783760F0C
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E8AC433EF;
        Thu,  6 Apr 2023 19:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808996;
        bh=xnZkkIqlt+NGANxApBAwycips6W6RdbNXdub9UXWi1U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GlkY9tne5sXBlGEdZxolw4j+h0IV9J/5bNCLWN1R3RTjSTwqA2nich2w4Okvt4nHR
         Ae1KbEZ7r+BKygdzjyc1Ri6uL0x1S4Xft+ZmxlQqvmNy6YAxUYSjorVtvvsPIN1zk/
         ou3NAIy3VJn3lZ6/G4S3zHZ/vJIp5EuJAHwt+hwhu/JpsioUw7W0MdCU8Sz8OoaYTH
         xi2UJoae5ps10B4Mkl8z5oIFLD5hwLFTWirbQoFwMsL9V4BKkSbmygmwTpJbP5eN4D
         uDL1VrGrlP3aEWZFOvb8+77pALtK4EW/8VEuiIaPrxJkLXpeIXEpK6f97/U27KEcgl
         OSLAE3c7yGJIQ==
Date:   Thu, 06 Apr 2023 12:23:16 -0700
Subject: [PATCH 11/23] xfs: remove parent pointers in unlink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824814.615225.2733448260833709480.stgit@frogsfrogsfrogs>
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

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format, minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        |    2 +-
 fs/xfs/libxfs/xfs_attr.h        |    1 +
 fs/xfs/libxfs/xfs_parent.c      |   22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |    4 ++++
 fs/xfs/libxfs/xfs_trans_space.h |    2 --
 fs/xfs/xfs_inode.c              |   39 +++++++++++++++++++++++++++++++++------
 6 files changed, 61 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e2acd7ecdfcc..37c86274b568 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -959,7 +959,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 1002e431b728..07c61bd70ef8 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -550,6 +550,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index f57e1a201f17..393409502770 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -182,6 +182,28 @@ xfs_parent_add(
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 8e7dbe22e1f7..0f8194cd8a9f 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
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
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 25a55650baf4..b5ab6701e7fb 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_REMOVE_SPACE_RES(mp)	\
-	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c07b9b5b8d34..aea1f781c84c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2472,6 +2472,19 @@ xfs_iunpin_wait(
 		__xfs_iunpin_wait(ip);
 }
 
+static unsigned int
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
+
 /*
  * Removing an inode from the namespace involves removing the directory entry
  * and dropping the link count on the inode. Removing the directory entry can
@@ -2501,16 +2514,17 @@ xfs_iunpin_wait(
  */
 int
 xfs_remove(
-	xfs_inode_t             *dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
-	xfs_inode_t		*ip)
+	struct xfs_inode	*ip)
 {
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t             *tp = NULL;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans	*tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_remove(dp, name);
 
@@ -2525,6 +2539,10 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto std_return;
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2536,12 +2554,12 @@ xfs_remove(
 	 * the directory code can handle a reservationless update and we don't
 	 * want to prevent a user from trying to free space by deleting things.
 	 */
-	resblks = XFS_REMOVE_SPACE_RES(mp);
+	resblks = xfs_remove_space_res(mp, name->len);
 	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
 			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto out_parent;
 	}
 
 	/*
@@ -2601,6 +2619,12 @@ xfs_remove(
 		goto out_trans_cancel;
 	}
 
+	if (parent) {
+		error = xfs_parent_remove(tp, parent, dp, name, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2618,6 +2642,7 @@ xfs_remove(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
  out_trans_cancel:
@@ -2625,6 +2650,8 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, parent);
  std_return:
 	return error;
 }

