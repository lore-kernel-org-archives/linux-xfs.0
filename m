Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BBA1FA4
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831677; cv=none; b=TTzfQiSG31rsDgi2YOWMdj87SJKldlRs8oAn0G2A/XHmnwi2d8ZEtkHY3ydnfsO+8Fpry/YXJf8cWfKb8sGxNDk9t2XgTA7QJaCcKJ6VSWNto3TLKbR1UWtYuy4l9VI1t4iNkYFFU5IYywueQ6ANZiQk/DYQiJPJ6B4y3Gw8QEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831677; c=relaxed/simple;
	bh=kxY2UhaMT3oa3bw1Jixnyw1U84GVJm1a8Zl2L9Y+UO4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fT1AiTV2u5iEBTNFSBP62YlvmB43QFp4SrEz0xusQjWgrWyrHTGbfCNz8RfmAJCvOYW09fqQVdYpWVdw4eTckOd1TtvbwCGULn7mA2EW11EGJt4wntRZ0zT4f9H8rzy30RxzuQgvMnArSTlmzwsmui9BWomiPqYPsCHP07emQx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdEVgi0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdEVgi0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6961C4CECD;
	Wed,  2 Oct 2024 01:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831677;
	bh=kxY2UhaMT3oa3bw1Jixnyw1U84GVJm1a8Zl2L9Y+UO4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sdEVgi0eNLIzmTjA+1XFVpKfYxCqja5DOgvjkdrkpQlbRMDryp3O3im8OWO5LQv6A
	 Gw+HU2M9Z/SHOZvVug38TENE5tOiACptXMUK/9nSoYuktXwxiHDlmWrfaDGYsOFa0Y
	 3ZeDBuima4Ou9FthH02AErxB//vBF/xFjOCzc3ihc3osTBepuqmEJ6BwXK5GOUG12L
	 Gx/JODjWdSmvUAFKOST0oQ1A/R9LFKSu7MDucowLa+97DdVafhpUxDxioZg3di43GJ
	 AE/VS/wfLeO7m6wXevrsLF+RdV+etScGQHkx4M++5fzPmjeSJZ9rCU06oyO++FXh/5
	 B03ZglfFYiitA==
Date: Tue, 01 Oct 2024 18:14:36 -0700
Subject: [PATCH 26/64] xfs: create libxfs helper to link an existing inode
 into a directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102173.4036371.5713397225646237655.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: c1f0bad4232fd309b2fe849153fcf473e775b1f7

Create a new libxfs function to link an existing inode into a directory.
The upcoming metadata directory feature will need this to create a
metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_dir2.h |    4 ++-
 2 files changed, 71 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index e98b28024..802b9a1b3 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -21,6 +21,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_parent.h"
+#include "xfs_ag.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -586,9 +587,9 @@ xfs_dir_replace(
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
@@ -808,3 +809,67 @@ xfs_dir_create_child(
 
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
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index a1ba6fd0a..4f9711509 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
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

