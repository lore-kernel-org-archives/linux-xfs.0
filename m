Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80DC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOz5rLgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A17EC433C8;
	Sun, 31 Dec 2023 23:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065282;
	bh=sf3sYiDfqioZ2+ggRbMRvHESNN5r4uP/Ez1tu0xJsnA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gOz5rLgXZsMomDT1OFzKDAuQft+NmFam/sKKZoRsHHyrWMCwLmIH5GW9rVNzU8hH5
	 T7nG89V8KcUZct/bfGJlpCipvljTCQeEIgvLcUrZIFXVPtAGySntkz5R7fA+rOHbFZ
	 IyskIc2UpJFHI7pDOO5M6DBS7HMh2KEpAorJFZCT4hYjyBMGeBBMnM9Zk8O/zmiKbZ
	 jwyhuz+ITIr6p3f7vpLU0NpPUDq5OZ267n0I8RuIkoHNvr/iEWt9yeuhqkNuqjbRbx
	 2XJ5Q74r2X2sZACFKbjPUWRjeNB9xTVOAn+UlF3z/IK+mubEF5z1b5Vt6hKue/RV7i
	 AhUe2M34p324g==
Date: Sun, 31 Dec 2023 15:28:01 -0800
Subject: [PATCH 22/28] xfs: create libxfs helper to remove an existing
 inode/name from a directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009469.1808635.822075635304221530.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to remove a (name, inode) entry from a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |    2 +
 2 files changed, 77 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index b2f978e657c..43b7bc31166 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -888,3 +888,78 @@ xfs_dir_add_child(
 	 */
 	return xfs_parent_add(tp, du->ppargs, dp, name, ip);
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
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
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
+	return xfs_parent_remove(tp, du->ppargs, dp, name, ip);
+}
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 1215d5d1ebe..8c8b55b487d 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -306,5 +306,7 @@ int xfs_dir_create_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
 int xfs_dir_add_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
+int xfs_dir_remove_child(struct xfs_trans *tp, unsigned int resblks,
+		struct xfs_dir_update *du);
 
 #endif	/* __XFS_DIR2_H__ */

