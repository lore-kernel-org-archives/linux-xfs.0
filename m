Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F57621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710724; cv=none; b=HG/Of4+kdnukAPg7Z/0LFchjsCFEiD0oiTWkPu+Lfr2cDT6/eE2xlq9JpCr7A1qPxvcHaK1vGyrElGFMbzpQoU9kyBvE6NCWg5jzNLw7CGoIKP3s382bNITCPD848kQ4UaenrmS+WPAG5BeqTy/cd/f65wbhqKPqgI/32fZQkLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710724; c=relaxed/simple;
	bh=+WK8nOi3k3SvRJn42cVqCXQx9xBBMTqcFoGv8sV1Fpk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D9Rb/Rn6ypjdJjiUq+0ElULkYX1pqP46KCLAuHtNWLHuUlv1X2W3xzuCI0itmfvXVnHUCUQR8TcSR6GFdQ2Gg+kYyDB+srQWLEzC/YJ8Ghr24etafVzlN2wMUktFMBLWKEgy19ocKWnKXIDD8A9kXi6r87nNvpKqp1IFB8CyGYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFbhUx8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFbhUx8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21938C433F1;
	Wed, 10 Apr 2024 00:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710724;
	bh=+WK8nOi3k3SvRJn42cVqCXQx9xBBMTqcFoGv8sV1Fpk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MFbhUx8MV5G6TqYelmi470Fu0nk+qNye80oWWKowyU08IRuo4X+Qkqxk32N58AjGW
	 YswxiJOA+BBjbY25YrVNsskXzFLKZVbtZlubDUiiylVP4TLfSwgmGUSRA4ox37d/yl
	 2SkdtTkvNtFLS7h2Yw59Cn2UaP0yIdH0gcw2npaBZepOVM82YrZM6ns82TKWp7M/rX
	 hfFJKRNqlArJViusanSYgHXxp5Y8F5JInUIEPJPqYWM4lrqHLUIip/VHyYGfRAS5j0
	 vO64BM7/ixliqoAUO970t+kpQhuKsVyJWa/zIm9MjQAK3t7jTMVlghIgZxJQZ4A/dT
	 mguRuBgNgdxEQ==
Date: Tue, 09 Apr 2024 17:58:43 -0700
Subject: [PATCH 20/32] xfs: remove parent pointers in unlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171270969891.3631889.16415446774447161383.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adjust to new ondisk format, minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_parent.c      |   22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |    3 +++
 fs/xfs/libxfs/xfs_trans_space.c |   13 +++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    3 +--
 fs/xfs/xfs_inode.c              |   27 +++++++++++++++++++++------
 5 files changed, 60 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 8875b4790112e..0ddaab08d722d 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -207,3 +207,25 @@ xfs_parent_addname(
 	xfs_attr_defer_parent(&ppargs->args, XFS_ATTR_DEFER_SET);
 	return 0;
 }
+
+/* Remove a parent pointer to reflect a dirent removal. */
+int
+xfs_parent_removename(
+	struct xfs_trans	*tp,
+	struct xfs_parent_args	*ppargs,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*parent_name,
+	struct xfs_inode	*child)
+{
+	int			error;
+
+	error = xfs_parent_iread_extents(tp, child);
+	if (error)
+		return error;
+
+	xfs_inode_to_parent_rec(&ppargs->rec, dp);
+	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
+			child->i_ino, parent_name);
+	xfs_attr_defer_parent(&ppargs->args, XFS_ATTR_DEFER_REMOVE);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 6de24e3ef318c..4a7fd48c226a4 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -81,5 +81,8 @@ xfs_parent_finish(
 int xfs_parent_addname(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 		struct xfs_inode *dp, const struct xfs_name *parent_name,
 		struct xfs_inode *child);
+int xfs_parent_removename(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child);
 
 #endif /* __XFS_PARENT_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index c8adda82debe0..df729e4f1a4c9 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -81,3 +81,16 @@ xfs_symlink_space_res(
 
 	return ret;
 }
+
+unsigned int
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
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 354ad1d6e18d6..a4490813c56f1 100644
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
@@ -106,5 +104,6 @@ unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_symlink_space_res(struct xfs_mount *mp, unsigned int namelen,
 		unsigned int fsblocks);
+unsigned int xfs_remove_space_res(struct xfs_mount *mp, unsigned int namelen);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4a3fbd8d33099..492d8d1055e9e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2720,16 +2720,17 @@ xfs_iunpin_wait(
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
+	struct xfs_parent_args	*ppargs;
 
 	trace_xfs_remove(dp, name);
 
@@ -2746,6 +2747,10 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	error = xfs_parent_start(mp, &ppargs);
+	if (error)
+		goto std_return;
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2757,12 +2762,12 @@ xfs_remove(
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
@@ -2822,6 +2827,13 @@ xfs_remove(
 		goto out_trans_cancel;
 	}
 
+	/* Remove parent pointer. */
+	if (ppargs) {
+		error = xfs_parent_removename(tp, ppargs, dp, name, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * Drop the link from dp to ip, and if ip was a directory, remove the
 	 * '.' and '..' references since we freed the directory.
@@ -2845,6 +2857,7 @@ xfs_remove(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -2852,6 +2865,8 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, ppargs);
  std_return:
 	return error;
 }

