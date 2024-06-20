Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64839856
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924571; cv=none; b=OjVwN1ESP26piTFe7p0/0oJlqk23V6KwewGlHHlHw740+KMGypsCzn8Nka+BhszSDtArGEsSKERmk30Kem69x70Ix8awgm028maLW7OJtLsaN5kpN4/WtSeytudRZQ71ixXbg4Er3qUCt4KD67ylIvc5cTujByhk2ucUMoqn4P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924571; c=relaxed/simple;
	bh=Hy27MqXUgcv5iEqlV861Q8ws0hiWNNNan282DrL0Geo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AR6lxnu/56tWMHnI7hDf+bo0u2NbOOMJ7XTY46cAEUbNWyruHlNTeycwGwDnFCjiUDrypd9KU4fw02kZ4nujxKR3k/uQj4guepj0oaXHNg2WiYS5YzXFq4sscv5igXDllHFaehaQGnDMp80gJK7a5VYcwt3fBGRLEgv923NFpLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1zrumi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1zrumi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFAAC2BD10;
	Thu, 20 Jun 2024 23:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924570;
	bh=Hy27MqXUgcv5iEqlV861Q8ws0hiWNNNan282DrL0Geo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y1zrumi80qoBJWTheMC8e+PE32887Pu/QefQT8t6i3sIfVdOpPy4nvUwmZDnmPDvc
	 Keyx1lTFdZ1U81b/BuRcXXi4U3a5aVeOiABwx+FhwruYXIP4Yb2EGK3KCxq9UYWcp/
	 KzrNrU7ki4Gh8xOLNRIzlzplFemLOa3zYCeFc7eBFIOZIpboa7RwcMKjBFTL+LGHQG
	 0jvNR5ZSod6TX3ZMawS6InkUCbrG4e2Ia2WqTmiycw9qJn7kJiT89Wj/ctZXhG6BUo
	 MWTod+/WTFQVYoW3MLi0710wjwarGwhHIhf84Dinv+puFiom9Iud8WAzOWdKQ6vw8J
	 xPqw5AkQqcLwg==
Date: Thu, 20 Jun 2024 16:02:50 -0700
Subject: [PATCH 17/24] xfs: create libxfs helper to link an existing inode
 into a directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418191.3183075.12556823901451535807.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to link an existing inode into a directory.
The upcoming metadata directory feature will need this to create a
metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |   71 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_dir2.h |    4 ++-
 fs/xfs/xfs_inode.c       |   52 ++++++----------------------------
 3 files changed, 81 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index bbed03441f5cc..5a75f60e85186 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_parent.h"
+#include "xfs_ag.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -587,9 +588,9 @@ xfs_dir_replace(
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
@@ -809,3 +810,67 @@ xfs_dir_create_child(
 
 	return 0;
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
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+	xfs_assert_ilocked(dp, XFS_ILOCK_EXCL);
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
+	if (du->ppargs) {
+		error = xfs_parent_addname(tp, du->ppargs, dp, name, ip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index a1ba6fd0a725f..4f9711509571a 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -74,7 +74,7 @@ extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name);
+				const struct xfs_name *name);
 
 int xfs_dir_lookup_args(struct xfs_da_args *args);
 int xfs_dir_createname_args(struct xfs_da_args *args);
@@ -320,5 +320,7 @@ struct xfs_dir_update {
 
 int xfs_dir_create_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
+int xfs_dir_add_child(struct xfs_trans *tp, unsigned int resblks,
+		struct xfs_dir_update *du);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 37f2ac96b7fbe..3ac4ea677ff7d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -952,11 +952,15 @@ xfs_link(
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
 
@@ -975,7 +979,7 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	error = xfs_parent_start(mp, &ppargs);
+	error = xfs_parent_start(mp, &du.ppargs);
 	if (error)
 		goto std_return;
 
@@ -990,7 +994,7 @@ xfs_link(
 	 * pointers are enabled because we can't back out if the xattrs must
 	 * grow.
 	 */
-	if (ppargs && nospace_error) {
+	if (du.ppargs && nospace_error) {
 		error = nospace_error;
 		goto error_return;
 	}
@@ -1017,45 +1021,9 @@ xfs_link(
 		}
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
+	error = xfs_dir_add_child(tp, resblks, &du);
 	if (error)
 		goto error_return;
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
-	if (ppargs) {
-		error = xfs_parent_addname(tp, ppargs, tdp, target_name, sip);
-		if (error)
-			goto error_return;
-	}
 
 	xfs_dir_update_hook(tdp, sip, 1, target_name);
 
@@ -1070,7 +1038,7 @@ xfs_link(
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
 	return error;
 
  error_return:
@@ -1078,7 +1046,7 @@ xfs_link(
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  out_parent:
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;

