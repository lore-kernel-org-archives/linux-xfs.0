Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562F8BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCa9xsZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A47C433C7;
	Sun, 31 Dec 2023 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056680;
	bh=IoBANf+pPMsz2RidVPxO1OEohSv3iE5ZyT5sHPWt3tU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oCa9xsZoNILyG8Hw2hsTD4XHMo9Hgo52uqHrf/azwFTsc6XOU1J7V/Z9Oiri8OcNa
	 ckAinlAMmqu4/sjdx3Iuky7CfK3Wk3W/9x0zhseIUKHvCfFhLCZk5psM2YBJShRXUt
	 ixH+rfe3EMFnJyASbjVkuAyyiDhZlcc1dzoEmzczFGt/TUldS4I7JGkk4+oO+orhBO
	 vvfwBCtUlI2Rj+Vpb+DJx+30xBsZ4yy6d5zLUcJhWv79GZ93a/RoI94xi6gnxeKHi2
	 +MvjyB9Tt7IumtmlmaGtU8jg+bzCzC6toxgLEWHMUBxOxLapg/2wegJS1dP7xcJXtm
	 wEHJOY+Dfovtw==
Date: Sun, 31 Dec 2023 13:04:39 -0800
Subject: [PATCH 15/21] xfs: create libxfs helper to link an existing inode
 into a directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844294.1759932.3813801300173779503.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to link an existing inode into a directory.
The upcoming metadata directory feature will need this to create a
metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |   65 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_dir2.h |    4 ++-
 fs/xfs/xfs_inode.c       |   50 +++++++----------------------------
 3 files changed, 75 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 16dfe869ef2de..91f5a10176248 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_parent.h"
+#include "xfs_ag.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -562,9 +563,9 @@ xfs_dir_replace(
  */
 int
 xfs_dir_canenter(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*dp,
-	struct xfs_name	*name)		/* name of entry to add */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name)		/* name of entry to add */
 {
 	return xfs_dir_createname(tp, dp, name, 0, 0);
 }
@@ -829,3 +830,61 @@ xfs_dir_create_child(
 	 */
 	return xfs_parent_add(tp, du->ppargs, dp, name, ip);
 }
+
+/*
+ * Given a directory @dp, an existing non-directory inode @ip, and a @name,
+ * link @ip into @dp under the given @name.  Both inodes must have the ILOCK
+ * held.
+ */
+int
+xfs_dir_add_child(
+	struct xfs_trans	*tp,
+	unsigned int		resblks,
+	struct xfs_dir_update	*du)
+{
+	struct xfs_inode	*dp = du->dp;
+	const struct xfs_name	*name = du->name;
+	struct xfs_inode	*ip = du->ip;
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
+	ASSERT(!S_ISDIR(VFS_I(ip)->i_mode));
+
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, dp, name);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Handle initial link state of O_TMPFILE inode
+	 */
+	if (VFS_I(ip)->i_nlink == 0) {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+		error = xfs_iunlink_remove(tp, pag, ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+	}
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	xfs_bumplink(tp, ip);
+
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	return xfs_parent_add(tp, du->ppargs, dp, name, ip);
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 71a8d8e8a8e7b..1215d5d1ebe6c 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -61,7 +61,7 @@ extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name);
+				const struct xfs_name *name);
 
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.
@@ -304,5 +304,7 @@ struct xfs_dir_update {
 
 int xfs_dir_create_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
+int xfs_dir_add_child(struct xfs_trans *tp, unsigned int resblks,
+		struct xfs_dir_update *du);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 401bd2a455196..70d13629071f5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -998,11 +998,15 @@ xfs_link(
 	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
+	struct xfs_dir_update	du = {
+		.dp		= tdp,
+		.name		= target_name,
+		.ip		= sip,
+	};
 	struct xfs_mount	*mp = tdp->i_mount;
 	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
-	struct xfs_parent_args	*ppargs;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1021,7 +1025,7 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	error = xfs_parent_start(mp, &ppargs);
+	error = xfs_parent_start(mp, &du.ppargs);
 	if (error)
 		goto std_return;
 
@@ -1036,7 +1040,7 @@ xfs_link(
 	 * pointers are enabled because we can't back out if the xattrs must
 	 * grow.
 	 */
-	if (ppargs && nospace_error) {
+	if (du.ppargs && nospace_error) {
 		error = nospace_error;
 		goto error_return;
 	}
@@ -1052,41 +1056,7 @@ xfs_link(
 		goto error_return;
 	}
 
-	if (!resblks) {
-		error = xfs_dir_canenter(tp, tdp, target_name);
-		if (error)
-			goto error_return;
-	}
-
-	/*
-	 * Handle initial link state of O_TMPFILE inode
-	 */
-	if (VFS_I(sip)->i_nlink == 0) {
-		struct xfs_perag	*pag;
-
-		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, sip->i_ino));
-		error = xfs_iunlink_remove(tp, pag, sip);
-		xfs_perag_put(pag);
-		if (error)
-			goto error_return;
-	}
-
-	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
-	if (error)
-		goto error_return;
-	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
-
-	xfs_bumplink(tp, sip);
-
-	/*
-	 * If we have parent pointers, we now need to add the parent record to
-	 * the attribute fork of the inode. If this is the initial parent
-	 * attribute, we need to create it correctly, otherwise we can just add
-	 * the parent to the inode.
-	 */
-	error = xfs_parent_add(tp, ppargs, tdp, target_name, sip);
+	error = xfs_dir_add_child(tp, resblks, &du);
 	if (error)
 		goto error_return;
 
@@ -1103,7 +1073,7 @@ xfs_link(
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
 	return error;
 
  error_return:
@@ -1111,7 +1081,7 @@ xfs_link(
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  out_parent:
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;

