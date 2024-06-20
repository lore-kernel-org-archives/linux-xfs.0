Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD20E7C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924617; cv=none; b=CvKCwYg2VG4r+2WZ+fZI2/CiPhubyHdAGc9H79qc14HyirYVDIUpLVyx7tCMargHN/wfm48ElH6deM/lsKQ2DxamK05MX3f092k73IjpJFkER9wDgMiR9cp24FzolAFi/MYV4YvdX2pHh9U5USrzMNHX2jSnk5YmqYuc5pLBF4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924617; c=relaxed/simple;
	bh=LIIc0sZkBQg/7LCrJwJqj0Zefrt9lXasYzZPx4TgBFw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FkKOkGbw3R76ug/ry/EI7BamFfIcgwbCLvZ/mSuIoxjt3fJEsY5878N8/tJ5o/zj1Ga5pTxHsbEAvz9Bd2gZScNZBhtr+dRIR2Xl5kWFfV8+GsiDRQBbkZ/pK/ZNdg+j/x8voBBiYMmAIjn4mlhjwG7XorNcsXuSKdvBJHgmm1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qT1H2TkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qT1H2TkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81024C2BD10;
	Thu, 20 Jun 2024 23:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924617;
	bh=LIIc0sZkBQg/7LCrJwJqj0Zefrt9lXasYzZPx4TgBFw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qT1H2TkH0XTsLC5y8B4f8bv7brkUNzdfSMj9ocWQcOB/7ZphTsJQfvI3wUmM+6Sk9
	 68J/XDKtYAStZD99axGZNMstg/T4P6xk5+6eJg5bKvoSd9Er84w+6xd1Kb+4b+1+US
	 B6xbJYEG0givt4qlnRvv3yDoPg79hL4RhZA8NViV60SRAhQdSu7dP1jUjxvsex20uS
	 2+sBslJuBsdMfCnWw2zz+vUx/c2l4RPFEmQWbTCqQeVFgRB2VidWNC2CTZALprPacl
	 +bJhXToZh8+k0ZLCNozIReDcYo4mo/+U6lrLsN7dEuSsdielAOGUjOKIQSus3tPteN
	 cGwWzsupE1sxA==
Date: Thu, 20 Jun 2024 16:03:37 -0700
Subject: [PATCH 20/24] xfs: create libxfs helper to exchange two directory
 entries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418243.3183075.4229000093376845892.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_dir2.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    3 +
 fs/xfs/xfs_inode.c       |  114 ++++++------------------------------------
 3 files changed, 143 insertions(+), 99 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index f3ac3d55bc385..d650cfa023fdb 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -955,3 +955,128 @@ xfs_dir_remove_child(
 
 	return 0;
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
+	if (du1->ppargs) {
+		error = xfs_parent_replacename(tp, du1->ppargs, dp1, name1,
+				dp2, name2, ip1);
+		if (error)
+			return error;
+	}
+
+	if (du2->ppargs) {
+		error = xfs_parent_replacename(tp, du2->ppargs, dp2, name2,
+				dp1, name1, ip2);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c89916d1c040a..8b1e192bd7a83 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -325,4 +325,7 @@ int xfs_dir_add_child(struct xfs_trans *tp, unsigned int resblks,
 int xfs_dir_remove_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
 
+int xfs_dir_exchange_children(struct xfs_trans *tp, struct xfs_dir_update *du1,
+		struct xfs_dir_update *du2, unsigned int spaceres);
+
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b70236735339e..d65c2dc3af145 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2223,108 +2223,24 @@ xfs_cross_rename(
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
-	if (ip1_ppargs) {
-		error = xfs_parent_replacename(tp, ip1_ppargs, dp1, name1, dp2,
-				name2, ip1);
-		if (error)
-			goto out_trans_abort;
-	}
-
-	if (ip2_ppargs) {
-		error = xfs_parent_replacename(tp, ip2_ppargs, dp2, name2, dp1,
-				name1, ip2);
-		if (error)
-			goto out_trans_abort;
-	}
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

