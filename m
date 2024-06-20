Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF2C7C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924602; cv=none; b=TcewCVJISziEvhMsekyblcx2JQ5vuwevcKR466YKBtx6zZk5zzliP/XMukreEywzwjBXz5hxjEtUZ5/VmFILBgmnVioMjYTu2Zlhq3GhhZgCbfOSMRGgy90GZ2bOKq1x/qzNgzXLQVMJNR6uE+NLvxc3QrW/rXEMaa/YuQAtQJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924602; c=relaxed/simple;
	bh=+yk9JsDn+DK2VmLSUXwGYrIjyaq/odFQmc1Vs2aqcg0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pyribcjSM5f9/66CX37XEp7yr//E7/nMCgIpBpyin3b07i6tucTgr9LgBq1sRWu4dunk6pP3qASgHFFQXcaopsjGA9aRzxQk1To423VVBZDbucl7qn5RadlfiBGANdVbvvORs8lOVatTsSDjalQJU6K1XAyxosZ79nQhnzxigzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFHMc9Bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFHMc9Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C58C2BD10;
	Thu, 20 Jun 2024 23:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924601;
	bh=+yk9JsDn+DK2VmLSUXwGYrIjyaq/odFQmc1Vs2aqcg0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZFHMc9BdG3ZN2sLxpIAHguBNYDA0l4P0hmvMD+0zFbesa3Z+Iyaz5Y0wUTAssy+sv
	 IK02PMKdtrCeGXTwjO4jI+Bi1X59tP2I6bwaPkBNksq0Oxf9fk9X4XtcxmvNYifSkH
	 2ZKq4Z/PTHcmGMtzzo5F3DLrRtHSUGhPYsW8AZd76+YwDPy5IFVsbLYIb9euPRMr1H
	 BuqUe26ZONJ1josoznnLT93oEyLoJC+lCMnAdXzjv1weUblDy9UUU49uAH85IMGQ6V
	 KC6U3d+fTjbN5LRPu/nu67Zlrj7U7DbUB271knFEowhsM/UW8jqd3Iw1ZwTE7kCTPO
	 plGLBMybhlnfQ==
Date: Thu, 20 Jun 2024 16:03:21 -0700
Subject: [PATCH 19/24] xfs: create libxfs helper to remove an existing
 inode/name from a directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418225.3183075.15347307047089870669.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to remove a (name, inode) entry from a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    2 +
 fs/xfs/xfs_inode.c       |   74 +++++-------------------------------------
 3 files changed, 92 insertions(+), 65 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 5a75f60e85186..f3ac3d55bc385 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -874,3 +874,84 @@ xfs_dir_add_child(
 
 	return 0;
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
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+	xfs_assert_ilocked(dp, XFS_ILOCK_EXCL);
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
+	if (du->ppargs) {
+		error = xfs_parent_removename(tp, du->ppargs, dp, name, ip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 4f9711509571a..c89916d1c040a 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -322,5 +322,7 @@ int xfs_dir_create_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
 int xfs_dir_add_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
+int xfs_dir_remove_child(struct xfs_trans *tp, unsigned int resblks,
+		struct xfs_dir_update *du);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 47d630851398a..b70236735339e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2025,13 +2025,17 @@ xfs_remove(
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
 
@@ -2048,7 +2052,7 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
-	error = xfs_parent_start(mp, &ppargs);
+	error = xfs_parent_start(mp, &du.ppargs);
 	if (error)
 		goto std_return;
 
@@ -2071,70 +2075,10 @@ xfs_remove(
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
+	error = xfs_dir_remove_child(tp, resblks, &du);
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
-	if (error) {
-		ASSERT(error != -ENOENT);
-		goto out_trans_cancel;
-	}
-
-	/* Remove parent pointer. */
-	if (ppargs) {
-		error = xfs_parent_removename(tp, ppargs, dp, name, ip);
-		if (error)
-			goto out_trans_cancel;
-	}
-
 	/*
 	 * Drop the link from dp to ip, and if ip was a directory, remove the
 	 * '.' and '..' references since we freed the directory.
@@ -2158,7 +2102,7 @@ xfs_remove(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -2167,7 +2111,7 @@ xfs_remove(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  out_parent:
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
  std_return:
 	return error;
 }

