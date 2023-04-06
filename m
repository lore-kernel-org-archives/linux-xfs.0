Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBEEC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbjDFTXD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjDFTXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:23:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F403155A6
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8538060F0C
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E852FC433EF;
        Thu,  6 Apr 2023 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808981;
        bh=CS8OxesckXdoZsd9wqIIr95IHKCPaorkcIHWNCAJqpY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dO8RLkseHCkv8pV59EcRnIE4mRVeKZ8bEIePC8SafdTGooE08tk+YWiGLBZBwkRpC
         lOem2pEJilvVcQj41Vxb7tIRsdt3QpOJa0ItwEnU9d5NZ5F1V8HzQwpR+DabsEJu6Q
         Bloqvnh4F5UhO3c94Pf5HOTrKB8P/JycMP8lwlGsTV1RRg9DoJBfTDKP9duUePriiT
         K70/dpYcT19hbLMgkoxmwbv1lPxwAAwdX/jMDWp9GbYeNGl8sbHi/FSt5R5t3AmV4v
         X1RZepWZ/8zq9JeFL/HQaBvmJjZCs65pu1NSGXADq74MfQubx9WQ5KUZCSvYRWVlyT
         zsAEhVq1C43pg==
Date:   Thu, 06 Apr 2023 12:23:00 -0700
Subject: [PATCH 10/23] xfs: add parent attributes to symlink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824800.615225.2653341878568704113.stgit@frogsfrogsfrogs>
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

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixups]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.h |    2 --
 fs/xfs/xfs_symlink.c            |   49 +++++++++++++++++++++++++++++++++------
 2 files changed, 42 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index f72207923ec2..25a55650baf4 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 315a709e53bd..198527c1fb22 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -23,6 +23,8 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_parent.h"
+#include "xfs_defer.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -142,6 +144,23 @@ xfs_readlink(
 	return error;
 }
 
+static unsigned int
+xfs_symlink_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen,
+	unsigned int		fsblocks)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
+			fsblocks;
+
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_symlink(
 	struct mnt_idmap	*idmap,
@@ -172,6 +191,7 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	struct xfs_parent_defer	*parent;
 
 	*ipp = NULL;
 
@@ -202,18 +222,24 @@ xfs_symlink(
 
 	/*
 	 * The symlink will fit into the inode data fork?
-	 * There can't be any attributes so we get the whole variable part.
+	 * If there are no parent pointers, then there wont't be any attributes.
+	 * So we get the whole variable part, and do not need to reserve extra
+	 * blocks.  Otherwise, we need to reserve the blocks.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
+	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
+
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto out_release_dquots;
 
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -233,7 +259,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -244,8 +270,7 @@ xfs_symlink(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
@@ -320,6 +345,12 @@ xfs_symlink(
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
+	if (parent) {
+		error = xfs_parent_add(tp, parent, dp, link_name, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * symlink transaction goes to disk before returning to
@@ -338,6 +369,8 @@ xfs_symlink(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
 out_trans_cancel:
@@ -353,6 +386,8 @@ xfs_symlink(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+out_parent:
+	xfs_parent_finish(mp, parent);
 out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);

