Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C526BA49
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfNNDNVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF26C433C8;
	Sun, 31 Dec 2023 21:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056711;
	bh=VRIUP5YLQdiuELURdbIy0vK3rZtnhZMJevfMTd6+Z8c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FfNNDNVo07zARJJpm27Rcb0uw6WwYRuHbPRECCCjCNlRFhvjaNIkXr/iePUO+7Olc
	 m2itrn4IFqDd21ufVVgxp+Zy1BpXV/+0tEWI/afH5pDRAPUE/iA6fjxuy3Q8e4f4k5
	 3r/B097S/WXrQXNdB7SG/FfysZe1oScRoZ7TygXMZBEhmkXrjgMSEFW4YAq3orgrvc
	 uCiBQ7SQPyd4MRhZvUH1LAjBTljFMDJfaMcUGkvG4CFyeNYoobkWDUVNwH7+TsKfsE
	 os19AnD66lT6THyn5D7zdNPOayTZsDfRdukOgjCV5+yhqThw3OCvHu6Qy52ZyW3vFe
	 Dya5R38mcppfg==
Date: Sun, 31 Dec 2023 13:05:11 -0800
Subject: [PATCH 17/21] xfs: create libxfs helper to remove an existing
 inode/name from a directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844327.1759932.6054712743896293384.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new libxfs function to remove a (name, inode) entry from a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    2 +
 fs/xfs/xfs_inode.c       |   72 ++++++--------------------------------------
 3 files changed, 86 insertions(+), 63 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 91f5a10176248..dfc79d75b3dd6 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -888,3 +888,78 @@ xfs_dir_add_child(
 	 */
 	return xfs_parent_add(tp, du->ppargs, dp, name, ip);
 }
+
+/*
+ * Given a directory @dp, a child @ip, and a @name, remove the (@name, @ip)
+ * entry from the directory.  Both inodes must have the ILOCK held.
+ */
+int
+xfs_dir_remove_child(
+	struct xfs_trans	*tp,
+	unsigned int		resblks,
+	struct xfs_dir_update	*du)
+{
+	struct xfs_inode	*dp = du->dp;
+	const struct xfs_name	*name = du->name;
+	struct xfs_inode	*ip = du->ip;
+	int			error;
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
+	/* Remove parent pointer. */
+	return xfs_parent_remove(tp, du->ppargs, dp, name, ip);
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 1215d5d1ebe6c..8c8b55b487d67 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -306,5 +306,7 @@ int xfs_dir_create_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
 int xfs_dir_add_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
+int xfs_dir_remove_child(struct xfs_trans *tp, unsigned int resblks,
+		struct xfs_dir_update *du);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 11f7c2e78c8d9..a00579cd6683b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2066,13 +2066,17 @@ xfs_remove(
 	struct xfs_name		*name,
 	struct xfs_inode	*ip)
 {
+	struct xfs_dir_update	du = {
+		.dp		= dp,
+		.name		= name,
+		.ip		= ip,
+	};
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans	*tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
-	struct xfs_parent_args	*ppargs;
 
 	trace_xfs_remove(dp, name);
 
@@ -2089,7 +2093,7 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
-	error = xfs_parent_start(mp, &ppargs);
+	error = xfs_parent_start(mp, &du.ppargs);
 	if (error)
 		goto std_return;
 
@@ -2112,65 +2116,7 @@ xfs_remove(
 		goto out_parent;
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
-	if (error)
-		goto out_trans_cancel;
-
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
-	if (error) {
-		ASSERT(error != -ENOENT);
-		goto out_trans_cancel;
-	}
-
-	/* Remove parent pointer. */
-	error = xfs_parent_remove(tp, ppargs, dp, name, ip);
+	error = xfs_dir_remove_child(tp, resblks, &du);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2197,7 +2143,7 @@ xfs_remove(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -2206,7 +2152,7 @@ xfs_remove(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  out_parent:
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
  std_return:
 	return error;
 }

