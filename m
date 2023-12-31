Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C38C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnKpI1Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4962C433C8;
	Sun, 31 Dec 2023 23:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065250;
	bh=JdMUO5746v8zMvKo2yNJr8tOOy8l0gdRXYxRHxVhs4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hnKpI1Ze1cqeGo6WQF4SnCr5IUdxUpU8wtfFCEPlkehw7io36o7onT676fwEsOqDJ
	 HedT4ZrHRTiqCx0pBe8+l6mLeZwdd/emOyqvMnqDhYHmhgda+NuCz0U3QG8Ky2pwG2
	 gt+STp24I+5ftHjQa/A6qvTPLZ79rI+96ubnkauNDSXe50EKIBuSLx2ycr0mIXWQ9N
	 1YEm3btKVGX7CG7ZeGOGSk4f1SZoh+F9I3G/7Zit6fzZLTQ2EDpxDjGWjVaPrigoDb
	 Ns1gBolqIVNu6/J4QCQ9gyEoWOgzs8ZIr3cvcenf1xrMVElc8n2UrWp+aKEP9b7ge+
	 wVhfLhq7s8/zQ==
Date: Sun, 31 Dec 2023 15:27:30 -0800
Subject: [PATCH 20/28] xfs: create libxfs helper to link an existing inode
 into a directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009443.1808635.2599530996810662161.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_dir2.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_dir2.h |    4 ++-
 2 files changed, 65 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 3b7c828fec1..b2f978e657c 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
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
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 71a8d8e8a8e..1215d5d1ebe 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
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

