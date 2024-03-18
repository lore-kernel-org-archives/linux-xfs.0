Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B980C59B42
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798261; cv=none; b=Ms90Huxe7rIt7LTYWjQ8X5f2O5dKzSTBKiCRCbaz2Idyb3oMwj0it5ncpOsqa9dXakpPFIHvqs9VcfGF/EdsHv6/8aKEWYHO6ePhRN+6Few3bs7SL31hroFwhBoZm81+r7sFeeyoKxe14pMeUqmW0wm3VD9fv6KGSVrS6qArnTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798261; c=relaxed/simple;
	bh=01okuRQDeo+YkhAf5WZax+vKEpEaPQxbpHM0ukXvNCM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IaKtCdGWzdIGxBOdNXe4oOhtyGoTeF1QUPtJ8HdfT9e1t/TWgMwweM83TUCZxz/pOunkrhseItqrULjZSJsV8qMal4HLDiaGzUGnmAqB1sulvAAD/SxJlPphmV4M9wDJfGZwSLmMcbZznQnOitds+QrohXXT3kWVY8aQADvgeCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ayd3JQpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ayd3JQpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9A3C433F1;
	Mon, 18 Mar 2024 21:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798261;
	bh=01okuRQDeo+YkhAf5WZax+vKEpEaPQxbpHM0ukXvNCM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ayd3JQpBIwNwpmgfuF0MAKYrp4cykNTKrT429gJ++a34buVo8hvUW0a6KTxDLPq5u
	 NXkhuqoHPXXLaBnjPfgTYDFq6T/AtmwNmBauAMSN0ByxN4KcnZMwo0bMOjCL6Eyki5
	 vyO377SwdpHUiekZNGAnkwqaHub5DVGQ2YYSExCAeHGB3Ri9RQkUL1OZWsa2RB54aW
	 XHYkgtHJIQEffi9vfIIClnaK4bN8D9f0HsVxNUbj84mjhJi0PtVcDTV9FvG/B+QAWU
	 9ommzk/yscXQKAbFA7XIiiabydm5emb+j5fG740QA+8+xcAzvwXcLz3NBLWqdfr3lj
	 JbLTlQkTRYK6g==
Date: Mon, 18 Mar 2024 14:44:20 -0700
Subject: [PATCH 09/23] xfs: remove parent pointers in unlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802021.3806377.4195656441697859038.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_parent.c      |   39 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.c |   13 +++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    3 +--
 fs/xfs/xfs_inode.c              |   25 +++++++++++++++++++------
 5 files changed, 88 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 05ef155388a12..1c3542d264618 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -27,6 +27,7 @@
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
+#include "xfs_health.h"
 
 struct kmem_cache		*xfs_parent_args_cache;
 
@@ -194,6 +195,44 @@ xfs_parent_addname(
 	return 0;
 }
 
+/* Remove a parent pointer to reflect a dirent removal. */
+int
+xfs_parent_removename(
+	struct xfs_trans	*tp,
+	struct xfs_parent_args	*ppargs,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*parent_name,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &ppargs->args;
+
+	if (XFS_IS_CORRUPT(tp->t_mountp,
+			!xfs_parent_valuecheck(tp->t_mountp, parent_name->name,
+					       parent_name->len)))
+		return -EFSCORRUPTED;
+
+	/*
+	 * For regular attrs, removing an attr from a !hasattr inode is a nop.
+	 * For parent pointers, we require that the pointer must exist if the
+	 * caller wants us to remove the pointer.
+	 */
+	if (XFS_IS_CORRUPT(child->i_mount, !xfs_inode_hasattr(child))) {
+		xfs_inode_mark_sick(child, XFS_SICK_INO_PARENT);
+		return -EFSCORRUPTED;
+	}
+
+	xfs_init_parent_name_rec(&ppargs->rec, dp, parent_name, child);
+	args->hashval = xfs_parent_hashname(dp, ppargs);
+
+	args->trans = tp;
+	args->dp = child;
+
+	xfs_init_parent_davalue(&ppargs->args, parent_name);
+
+	xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
+	return 0;
+}
+
 /* Free a parent pointer context object. */
 void
 xfs_parent_args_free(
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index e2115a2b9648b..31349130a330e 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -79,6 +79,22 @@ xfs_parent_add(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
 	return 0;
 }
 
+int xfs_parent_removename(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child);
+
+/* Schedule a parent pointer removal. */
+static inline int
+xfs_parent_remove(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child)
+{
+	if (ppargs)
+		return xfs_parent_removename(tp, ppargs, dp, parent_name,
+				child);
+	return 0;
+}
+
 void xfs_parent_args_free(struct xfs_mount *mp, struct xfs_parent_args *ppargs);
 
 /* Finish a parent pointer update by freeing the context object. */
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
index d09d6d144c301..41debaad299d6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2727,16 +2727,17 @@ xfs_iunpin_wait(
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
 
@@ -2753,6 +2754,10 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	error = xfs_parent_start(mp, &ppargs);
+	if (error)
+		goto std_return;
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2764,12 +2769,12 @@ xfs_remove(
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
@@ -2829,6 +2834,11 @@ xfs_remove(
 		goto out_trans_cancel;
 	}
 
+	/* Remove parent pointer. */
+	error = xfs_parent_remove(tp, ppargs, dp, name, ip);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * Drop the link from dp to ip, and if ip was a directory, remove the
 	 * '.' and '..' references since we freed the directory.
@@ -2852,6 +2862,7 @@ xfs_remove(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -2859,6 +2870,8 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, ppargs);
  std_return:
 	return error;
 }

