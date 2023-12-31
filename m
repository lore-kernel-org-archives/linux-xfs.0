Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEC6C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pJSgJJhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF02C433C8;
	Sun, 31 Dec 2023 23:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065313;
	bh=Nib3tvJnJBNVTMIR8P4JfwVnQ6e1x1IjYxz8a7FRvXU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pJSgJJhdOcwQdd3IjBQw8z7ODMF7knD+njlq6QqR4cqhZEL4BXM5ob2rm/xiPaABe
	 xAZz5/D9FpaHHP3m4XqgEkH3PKrlhtlUOYc9dreL60GKQRDeKU5DpqnPblTld3LJ6e
	 k4W90gjj2aSQ0ZwN/MteZT9DVWabEVyzH5ZfsqDlZoiscmEYHjvv6quljF2OXx8a0P
	 fKfewZDp7XjPJZ69EQq8s1ko/Tyiv8yqmGPMW3V/sm42b6ian/m1fObC03u0CP4Qeo
	 1J9g2ANTQRLvWg8wX81dwBOXlfDcdEBqeEFWsyZoZNDxgNm/H+n1OTuzkjvaZE9F+q
	 MPtQjNZi7a31w==
Date: Sun, 31 Dec 2023 15:28:32 -0800
Subject: [PATCH 24/28] xfs: create libxfs helper to rename two directory
 entries
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009495.1808635.8322972259702794841.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to rename two directory entries.  The
upcoming metadata directory feature will need this to replace a metadata
inode directory entry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |  217 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |    3 +
 2 files changed, 220 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index d14e81403ad..7a1d55dff69 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_parent.h"
 #include "xfs_ag.h"
+#include "xfs_ialloc.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -1080,3 +1081,219 @@ xfs_dir_exchange_children(
 	return xfs_parent_replace(tp, du2->ppargs, dp2, name2, dp1, name1,
 			ip2);
 }
+
+/*
+ * Given an entry (@src_name, @src_ip) in directory @src_dp, make the entry
+ * @target_name in directory @target_dp point to @src_ip and remove the
+ * original entry, cleaning up everything left behind.
+ *
+ * Cleanup involves dropping a link count on @target_ip, and either removing
+ * the (@src_name, @src_ip) entry from @src_dp or simply replacing the entry
+ * with (@src_name, @wip) if a whiteout inode @wip is supplied.
+ *
+ * All inodes must have the ILOCK held.  We assume that if @src_ip is a
+ * directory then its '..' doesn't already point to @target_dp, and that @wip
+ * is a freshly allocated whiteout.
+ */
+int
+xfs_dir_rename_children(
+	struct xfs_trans	*tp,
+	struct xfs_dir_update	*du_src,
+	struct xfs_dir_update	*du_tgt,
+	unsigned int		spaceres,
+	struct xfs_dir_update	*du_wip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*src_dp = du_src->dp;
+	const struct xfs_name	*src_name = du_src->name;
+	struct xfs_inode	*src_ip = du_src->ip;
+	struct xfs_inode	*target_dp = du_tgt->dp;
+	const struct xfs_name	*target_name = du_tgt->name;
+	struct xfs_inode	*target_ip = du_tgt->ip;
+	bool			new_parent = (src_dp != target_dp);
+	bool			src_is_directory;
+	int			error;
+
+	src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
+
+	/*
+	 * Check for expected errors before we dirty the transaction
+	 * so we can return an error without a transaction abort.
+	 */
+	if (target_ip == NULL) {
+		/*
+		 * If there's no space reservation, check the entry will
+		 * fit before actually inserting it.
+		 */
+		if (!spaceres) {
+			error = xfs_dir_canenter(tp, target_dp, target_name);
+			if (error)
+				return error;
+		}
+	} else {
+		/*
+		 * If target exists and it's a directory, check that whether
+		 * it can be destroyed.
+		 */
+		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
+		    (!xfs_dir_isempty(target_ip) ||
+		     (VFS_I(target_ip)->i_nlink > 2)))
+			return -EEXIST;
+	}
+
+	/*
+	 * Directory entry creation below may acquire the AGF. Remove
+	 * the whiteout from the unlinked list first to preserve correct
+	 * AGI/AGF locking order. This dirties the transaction so failures
+	 * after this point will abort and log recovery will clean up the
+	 * mess.
+	 *
+	 * For whiteouts, we need to bump the link count on the whiteout
+	 * inode. After this point, we have a real link, clear the tmpfile
+	 * state flag from the inode so it doesn't accidentally get misused
+	 * in future.
+	 */
+	if (du_wip->ip) {
+		struct xfs_perag	*pag;
+
+		ASSERT(VFS_I(du_wip->ip)->i_nlink == 0);
+
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, du_wip->ip->i_ino));
+		error = xfs_iunlink_remove(tp, pag, du_wip->ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+
+		xfs_bumplink(tp, du_wip->ip);
+	}
+
+	/*
+	 * Set up the target.
+	 */
+	if (target_ip == NULL) {
+		/*
+		 * If target does not exist and the rename crosses
+		 * directories, adjust the target directory link count
+		 * to account for the ".." reference from the new entry.
+		 */
+		error = xfs_dir_createname(tp, target_dp, target_name,
+					   src_ip->i_ino, spaceres);
+		if (error)
+			return error;
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		if (new_parent && src_is_directory) {
+			xfs_bumplink(tp, target_dp);
+		}
+	} else { /* target_ip != NULL */
+		/*
+		 * Link the source inode under the target name.
+		 * If the source inode is a directory and we are moving
+		 * it across directories, its ".." entry will be
+		 * inconsistent until we replace that down below.
+		 *
+		 * In case there is already an entry with the same
+		 * name at the destination directory, remove it first.
+		 */
+		error = xfs_dir_replace(tp, target_dp, target_name,
+					src_ip->i_ino, spaceres);
+		if (error)
+			return error;
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		/*
+		 * Decrement the link count on the target since the target
+		 * dir no longer points to it.
+		 */
+		error = xfs_droplink(tp, target_ip);
+		if (error)
+			return error;
+
+		if (src_is_directory) {
+			/*
+			 * Drop the link from the old "." entry.
+			 */
+			error = xfs_droplink(tp, target_ip);
+			if (error)
+				return error;
+		}
+	} /* target_ip != NULL */
+
+	/*
+	 * Remove the source.
+	 */
+	if (new_parent && src_is_directory) {
+		/*
+		 * Rewrite the ".." entry to point to the new
+		 * directory.
+		 */
+		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
+					target_dp->i_ino, spaceres);
+		ASSERT(error != -EEXIST);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * We always want to hit the ctime on the source inode.
+	 *
+	 * This isn't strictly required by the standards since the source
+	 * inode isn't really being changed, but old unix file systems did
+	 * it and some incremental backup programs won't work without it.
+	 */
+	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
+
+	/*
+	 * Adjust the link count on src_dp.  This is necessary when
+	 * renaming a directory, either within one parent when
+	 * the target existed, or across two parent directories.
+	 */
+	if (src_is_directory && (new_parent || target_ip != NULL)) {
+
+		/*
+		 * Decrement link count on src_directory since the
+		 * entry that's moved no longer points to it.
+		 */
+		error = xfs_droplink(tp, src_dp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * For whiteouts, we only need to update the source dirent with the
+	 * inode number of the whiteout inode rather than removing it
+	 * altogether.
+	 */
+	if (du_wip->ip)
+		error = xfs_dir_replace(tp, src_dp, src_name, du_wip->ip->i_ino,
+					spaceres);
+	else
+		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
+					   spaceres);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
+	if (new_parent)
+		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
+
+	/* Schedule parent pointer updates. */
+	error = xfs_parent_add(tp, du_wip->ppargs, src_dp, src_name,
+			du_wip->ip);
+	if (error)
+		return error;
+
+	error = xfs_parent_replace(tp, du_src->ppargs, src_dp, src_name,
+			target_dp, target_name, src_ip);
+	if (error)
+		return error;
+
+	return xfs_parent_remove(tp, du_tgt->ppargs, target_dp, target_name,
+			target_ip);
+}
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index dbca60ec934..5e8b18f3f00 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -311,5 +311,8 @@ int xfs_dir_remove_child(struct xfs_trans *tp, unsigned int resblks,
 
 int xfs_dir_exchange_children(struct xfs_trans *tp, struct xfs_dir_update *du1,
 		struct xfs_dir_update *du2, unsigned int spaceres);
+int xfs_dir_rename_children(struct xfs_trans *tp, struct xfs_dir_update *du_src,
+		struct xfs_dir_update *du_tgt, unsigned int spaceres,
+		struct xfs_dir_update *du_wip);
 
 #endif	/* __XFS_DIR2_H__ */

