Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07DAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbiLaBJf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiLaBJf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:09:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E4A1573A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A31BC61D45
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F59CC433D2;
        Sat, 31 Dec 2022 01:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448973;
        bh=UsHDECBx47qGrTaFBCkSZPquEFDKQwecAGi1iJi1Ac4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AyZztw26nIVRTm6GfPs1zWpumFCCMXjWo4SHk+0k54C8NGrYR64YQXaqQ1Lqn5Gyq
         zzybugPuXUqpE/ixuJvDAExkt8tBHxcQYZRaPTZnk9V4Batk4oWdmyiMgTuEI8JSmy
         y2qR/0IGEEjvgXqrkcP8DM1cLU3PSEme6c4lCORM6cFj+JU/MXRsp8GlKEyXqjhcxo
         6F9Pho/pLGYY07usqSAOxzH2ZAvF3pd0bg+qF0fFDwJ9yY4kna5YbBw6fd45CyI6Wx
         AA17e7eENfzvceS/mStVp2J/iltjJJEeSMw/zQ4CwBS2oEPX2jik6H0GtoJStf9Ik8
         oyjvn0N744YaA==
Subject: [PATCH 17/20] xfs: create libxfs helper to remove an existing
 inode/name from a directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:20 -0800
Message-ID: <167243864074.707335.4873300496146568470.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new libxfs function to remove a (name, inode) entry from a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    3 ++
 fs/xfs/xfs_inode.c       |   55 +----------------------------------
 3 files changed, 77 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index e14464712eff..2923cf568e9d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -876,3 +876,76 @@ xfs_dir_link_existing_child(
 	xfs_bumplink(tp, ip);
 	return 0;
 }
+
+/*
+ * Given a directory @dp, a child @ip, and a @name, remove the (@name, @ip)
+ * entry from the directory.  Both inodes must have the ILOCK held.
+ */
+int
+xfs_dir_remove_child(
+	struct xfs_trans		*tp,
+	uint				resblks,
+	struct xfs_inode		*dp,
+	struct xfs_name			*name,
+	struct xfs_inode		*ip)
+{
+	int				error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
+
+	/*
+	 * If we're removing a directory perform some additional validation.
+	 */
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		ASSERT(VFS_I(ip)->i_nlink >= 2);
+		if (VFS_I(ip)->i_nlink != 2)
+			return -ENOTEMPTY;
+		if (!xfs_dir_isempty(ip))
+			return -ENOTEMPTY;
+
+		/* Drop the link from ip's "..".  */
+		error = xfs_droplink(tp, dp);
+		if (error)
+			return error;
+
+		/* Drop the "." link from ip to self.  */
+		error = xfs_droplink(tp, ip);
+		if (error)
+			return error;
+
+		/*
+		 * Point the unlinked child directory's ".." entry to the root
+		 * directory to eliminate back-references to inodes that may
+		 * get freed before the child directory is closed.  If the fs
+		 * gets shrunk, this can lead to dirent inode validation errors.
+		 */
+		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
+			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
+					tp->t_mountp->m_sb.sb_rootino, 0);
+			if (error)
+				return error;
+		}
+	} else {
+		/*
+		 * When removing a non-directory we need to log the parent
+		 * inode here.  For a directory this is done implicitly
+		 * by the xfs_droplink call for the ".." entry.
+		 */
+		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+	}
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+	/* Drop the link from dp to ip. */
+	error = xfs_droplink(tp, ip);
+	if (error)
+		return error;
+
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	if (error) {
+		ASSERT(error != -ENOENT);
+		return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 4afade8b0877..e35deb273d84 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -259,5 +259,8 @@ int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
 int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_remove_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8bd9d47bf6fa..f2a5de0119b3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2020,63 +2020,10 @@ xfs_remove(
 		goto std_return;
 	}
 
-	/*
-	 * If we're removing a directory perform some additional validation.
-	 */
-	if (is_dir) {
-		ASSERT(VFS_I(ip)->i_nlink >= 2);
-		if (VFS_I(ip)->i_nlink != 2) {
-			error = -ENOTEMPTY;
-			goto out_trans_cancel;
-		}
-		if (!xfs_dir_isempty(ip)) {
-			error = -ENOTEMPTY;
-			goto out_trans_cancel;
-		}
-
-		/* Drop the link from ip's "..".  */
-		error = xfs_droplink(tp, dp);
-		if (error)
-			goto out_trans_cancel;
-
-		/* Drop the "." link from ip to self.  */
-		error = xfs_droplink(tp, ip);
-		if (error)
-			goto out_trans_cancel;
-
-		/*
-		 * Point the unlinked child directory's ".." entry to the root
-		 * directory to eliminate back-references to inodes that may
-		 * get freed before the child directory is closed.  If the fs
-		 * gets shrunk, this can lead to dirent inode validation errors.
-		 */
-		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
-			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
-			if (error)
-				goto out_trans_cancel;
-		}
-	} else {
-		/*
-		 * When removing a non-directory we need to log the parent
-		 * inode here.  For a directory this is done implicitly
-		 * by the xfs_droplink call for the ".." entry.
-		 */
-		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
-	}
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-	/* Drop the link from dp to ip. */
-	error = xfs_droplink(tp, ip);
+	error = xfs_dir_remove_child(tp, resblks, dp, name, ip);
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
-	if (error) {
-		ASSERT(error != -ENOENT);
-		goto out_trans_cancel;
-	}
-
 	/*
 	 * Drop the link from dp to ip, and if ip was a directory, remove the
 	 * '.' and '..' references since we freed the directory.

