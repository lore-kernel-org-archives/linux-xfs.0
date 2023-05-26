Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5A4C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjEZCLq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjEZCLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:11:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C05FA3
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0894161834
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D05C433EF;
        Fri, 26 May 2023 02:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067103;
        bh=9TzjFKqLRPZrzHZvR7SoLXJJA0EuO/c5tTMhDRywwOI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=C2QCbBGBewWapZRWYpJb/VxZaS7AagUaRnAKoejiVFD9C/mG93m+5DJPUw6jNzaXP
         8S9QaCioRUKzv81TBNwnglLEhaRcC70u9PKTWXum5EURjiYyL7zK/YxmVNSYzjBshw
         1JQnN8Q5oqetfXDre1YTk5U3vggOhhZLAOCwEEVivAVqiwgsX+WZI+hWKYO7zqvfo8
         qpg8egqq389eIbftpt/41rYZlBz2HlJsE2b45Izc+3VqOYhA9IeVrscJ/GOlRaxag4
         6EbdcunsDjUmTH3sh9To4/CVAY7dcEGQqMz87izd22RkNWiifaYsuobeXZtZOXPwA0
         oSNiJYn5IcSjg==
Date:   Thu, 25 May 2023 19:11:42 -0700
Subject: [PATCH 07/18] xfs: add parent attributes to symlink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072797.3744191.8395559019065080913.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
References: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_trans_space.c |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    4 ++--
 fs/xfs/scrub/symlink_repair.c   |    2 +-
 fs/xfs/xfs_symlink.c            |   29 ++++++++++++++++++++++++-----
 4 files changed, 44 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index cf775750120e..c8adda82debe 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -64,3 +64,20 @@ xfs_link_space_res(
 
 	return ret;
 }
+
+unsigned int
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
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 5539634009fb..354ad1d6e18d 100644
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
 
@@ -106,5 +104,7 @@ unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
 unsigned int xfs_create_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
+unsigned int xfs_symlink_space_res(struct xfs_mount *mp, unsigned int namelen,
+		unsigned int fsblocks);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index a2ec1957a54f..a1e820e1685f 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -382,7 +382,7 @@ xrep_symlink_rebuild(
 	 * unlikely.
 	 */
 	fs_blocks = xfs_symlink_blocks(sc->mp, target_len);
-	resblks = XFS_SYMLINK_SPACE_RES(sc->mp, target_len, fs_blocks);
+	resblks = xfs_symlink_space_res(sc->mp, target_len, fs_blocks);
 	error = xfs_trans_reserve_quota_nblks(sc->tp, sc->tempip, resblks, 0,
 			true);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index cceefd1a5406..e3734e4c3290 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -25,6 +25,8 @@
 #include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_parent.h"
+#include "xfs_defer.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -99,6 +101,7 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	struct xfs_parent_defer	*parent;
 
 	*ipp = NULL;
 
@@ -129,18 +132,24 @@ xfs_symlink(
 
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
@@ -160,7 +169,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -194,6 +203,13 @@ xfs_symlink(
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	if (parent) {
+		error = xfs_parent_add(tp, parent, dp, link_name, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_dir_update_hook(dp, ip, 1, link_name);
 
 	/*
@@ -215,6 +231,7 @@ xfs_symlink(
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
 out_trans_cancel:
@@ -230,6 +247,8 @@ xfs_symlink(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+out_parent:
+	xfs_parent_finish(mp, parent);
 out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);

