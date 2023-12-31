Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE729C2DA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1AuO0ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECBCC433C7;
	Sun, 31 Dec 2023 21:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056727;
	bh=u6OWfoLLbT2tgvPxVy0I/mUtHR6oUxo05AODGSeaPZY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A1AuO0mlIYvyQH9rWDbXtQDQKmTPa2KvcYTDcpZuZRtLd1IDni5tzbIr/luAWPp9d
	 b5cC5wp2TmAiW5H3cbXIvJwmxXy3HpBokdwnoj9fRIoa2wF0StlAv/BDuU7iTT07Qv
	 Kk+aPfdRocpJ44M7UJ5aOoZVgumkdZoxZ85Vu1WAXL3Dk/jWbnXesanwGZksZhHLit
	 ufPebA/v1lyq9aOSThHUKxeOpqDqqc/VRyJRJHX0df3hzJrplt7RV12+w1fHtfN+oR
	 fnPchTVUTFaIP+j4Vth5BSw1G5/+r0BHtQT3jKcQmbLw4EGi55FgadkgqKMga+muNr
	 RVCSRY6H1siEg==
Date: Sun, 31 Dec 2023 13:05:26 -0800
Subject: [PATCH 18/21] xfs: create libxfs helper to exchange two directory
 entries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844343.1759932.17459688123968920133.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to exchange two directory entries.
The upcoming metadata directory feature will need this to replace a
metadata inode directory entry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    3 +
 fs/xfs/xfs_inode.c       |  108 ++++++------------------------------------
 3 files changed, 135 insertions(+), 93 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index dfc79d75b3dd6..f6b448d5fb0e4 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -963,3 +963,120 @@ xfs_dir_remove_child(
 	/* Remove parent pointer. */
 	return xfs_parent_remove(tp, du->ppargs, dp, name, ip);
 }
+
+/*
+ * Exchange the entry (@name1, @ip1) in directory @dp1 with the entry (@name2,
+ * @ip2) in directory @dp2, and update '..' @ip1 and @ip2's entries as needed.
+ * @ip1 and @ip2 need not be of the same type.
+ *
+ * All inodes must have the ILOCK held, and both entries must already exist.
+ */
+int
+xfs_dir_exchange_children(
+	struct xfs_trans	*tp,
+	struct xfs_dir_update	*du1,
+	struct xfs_dir_update	*du2,
+	unsigned int		spaceres)
+{
+	struct xfs_inode	*dp1 = du1->dp;
+	const struct xfs_name	*name1 = du1->name;
+	struct xfs_inode	*ip1 = du1->ip;
+	struct xfs_inode	*dp2 = du2->dp;
+	const struct xfs_name	*name2 = du2->name;
+	struct xfs_inode	*ip2 = du2->ip;
+	int			ip1_flags = 0;
+	int			ip2_flags = 0;
+	int			dp2_flags = 0;
+	int			error;
+
+	/* Swap inode number for dirent in first parent */
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/* Swap inode number for dirent in second parent */
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/*
+	 * If we're renaming one or more directories across different parents,
+	 * update the respective ".." entries (and link counts) to match the new
+	 * parents.
+	 */
+	if (dp1 != dp2) {
+		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+
+		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
+			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
+						dp1->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip2 ".." reference to dp1 */
+			if (!S_ISDIR(VFS_I(ip1)->i_mode)) {
+				error = xfs_droplink(tp, dp2);
+				if (error)
+					return error;
+				xfs_bumplink(tp, dp1);
+			}
+
+			/*
+			 * Although ip1 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+		}
+
+		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
+			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
+						dp2->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip1 ".." reference to dp2 */
+			if (!S_ISDIR(VFS_I(ip2)->i_mode)) {
+				error = xfs_droplink(tp, dp1);
+				if (error)
+					return error;
+				xfs_bumplink(tp, dp2);
+			}
+
+			/*
+			 * Although ip2 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_CHG;
+		}
+	}
+
+	if (ip1_flags) {
+		xfs_trans_ichgtime(tp, ip1, ip1_flags);
+		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
+	}
+	if (ip2_flags) {
+		xfs_trans_ichgtime(tp, ip2, ip2_flags);
+		xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);
+	}
+	if (dp2_flags) {
+		xfs_trans_ichgtime(tp, dp2, dp2_flags);
+		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
+	}
+	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
+	/* Schedule parent pointer replacements */
+	error = xfs_parent_replace(tp, du1->ppargs, dp1, name1, dp2, name2,
+			ip1);
+	if (error)
+		return error;
+
+	return xfs_parent_replace(tp, du2->ppargs, dp2, name2, dp1, name1,
+			ip2);
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 8c8b55b487d67..dbca60ec93462 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -309,4 +309,7 @@ int xfs_dir_add_child(struct xfs_trans *tp, unsigned int resblks,
 int xfs_dir_remove_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
 
+int xfs_dir_exchange_children(struct xfs_trans *tp, struct xfs_dir_update *du1,
+		struct xfs_dir_update *du2, unsigned int spaceres);
+
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a00579cd6683b..1eb92c05d8b78 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2264,102 +2264,24 @@ xfs_cross_rename(
 	struct xfs_parent_args	*ip2_ppargs,
 	int			spaceres)
 {
-	int			error = 0;
-	int			ip1_flags = 0;
-	int			ip2_flags = 0;
-	int			dp2_flags = 0;
-
-	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
-	if (error)
-		goto out_trans_abort;
-
-	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
-	if (error)
-		goto out_trans_abort;
-
-	/*
-	 * If we're renaming one or more directories across different parents,
-	 * update the respective ".." entries (and link counts) to match the new
-	 * parents.
-	 */
-	if (dp1 != dp2) {
-		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
-
-		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
-			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
-			if (error)
-				goto out_trans_abort;
-
-			/* transfer ip2 ".." reference to dp1 */
-			if (!S_ISDIR(VFS_I(ip1)->i_mode)) {
-				error = xfs_droplink(tp, dp2);
-				if (error)
-					goto out_trans_abort;
-				xfs_bumplink(tp, dp1);
-			}
-
-			/*
-			 * Although ip1 isn't changed here, userspace needs
-			 * to be warned about the change, so that applications
-			 * relying on it (like backup ones), will properly
-			 * notify the change
-			 */
-			ip1_flags |= XFS_ICHGTIME_CHG;
-			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
-		}
-
-		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
-			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
-			if (error)
-				goto out_trans_abort;
-
-			/* transfer ip1 ".." reference to dp2 */
-			if (!S_ISDIR(VFS_I(ip2)->i_mode)) {
-				error = xfs_droplink(tp, dp1);
-				if (error)
-					goto out_trans_abort;
-				xfs_bumplink(tp, dp2);
-			}
-
-			/*
-			 * Although ip2 isn't changed here, userspace needs
-			 * to be warned about the change, so that applications
-			 * relying on it (like backup ones), will properly
-			 * notify the change
-			 */
-			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
-			ip2_flags |= XFS_ICHGTIME_CHG;
-		}
-	}
-
-	/* Schedule parent pointer replacements */
-	error = xfs_parent_replace(tp, ip1_ppargs, dp1, name1, dp2, name2, ip1);
+	struct xfs_dir_update	du1 = {
+		.dp		= dp1,
+		.name		= name1,
+		.ip		= ip1,
+		.ppargs		= ip1_ppargs,
+	};
+	struct xfs_dir_update	du2 = {
+		.dp		= dp2,
+		.name		= name2,
+		.ip		= ip2,
+		.ppargs		= ip2_ppargs,
+	};
+	int			error;
+
+	error = xfs_dir_exchange_children(tp, &du1, &du2, spaceres);
 	if (error)
 		goto out_trans_abort;
 
-	error = xfs_parent_replace(tp, ip2_ppargs, dp2, name2, dp1, name1, ip2);
-	if (error)
-		goto out_trans_abort;
-
-	if (ip1_flags) {
-		xfs_trans_ichgtime(tp, ip1, ip1_flags);
-		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
-	}
-	if (ip2_flags) {
-		xfs_trans_ichgtime(tp, ip2, ip2_flags);
-		xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);
-	}
-	if (dp2_flags) {
-		xfs_trans_ichgtime(tp, dp2, dp2_flags);
-		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
-	}
-	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-
 	/*
 	 * Inform our hook clients that we've finished an exchange operation as
 	 * follows: removed the source and target files from their directories;

