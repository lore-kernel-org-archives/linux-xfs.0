Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35F91C36
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831708; cv=none; b=E+CvyvCACmFs9UyIMQwvnTHaukHmQy9DLft6aYmzI2a1tt4Rr052TMkD3/1l0Xs9/ObJyT4HjF12u7As2ZxJUEcWkEzyeQmZVt0UuW/tJ2sswdp9QRQQlnsD4hMsBJD+BmKJPY0lar7F4i10OHZsKEKp1IciajpD7AxIHfFF1RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831708; c=relaxed/simple;
	bh=ZlPsz9obZTwKwriFxOA8ZwF6nS4p17DvKmumw8TWKPE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fB8BartLlNn3D5KWEFr6lPwihx+2zrr6zoYVLE8KU+fAVYFBxNqauPQoB6rWlI/57+UJGObsUbtOtzkdIRROkhrhMf7ocNdAccqAlSr2pO4mHM/pkxIv6FyctCmDJ1tQjs1fhQJn8xZEc2yWrtmULtUT3g9XF3TyE/m8NA8udco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRoZyIkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRoZyIkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B1DC4CEC6;
	Wed,  2 Oct 2024 01:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831708;
	bh=ZlPsz9obZTwKwriFxOA8ZwF6nS4p17DvKmumw8TWKPE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aRoZyIkXKWONv2wX1iX1Cgpfy6Dr9/p6nAiRs51a/NV5n/p5beNlnqI1yFSq/9YTo
	 nRpSD4ZJdbyxgRyQztnPC+UT3gXmYv2+GdiU1xCCVtAkc7iPjA3mnGvEjwEB1L55rd
	 0qkQ/gkwyhm1ltpMHaKAk3CQUZ+Xqtufh7OA3LkJglSkBVIeEO+NbVY/S+rs5htOOu
	 4iE1WcQulVKcICN6iKVO9x9hqJK28tu8G2K5A5XooW/jV4J1XX93eYTWBrSoFXUBVN
	 +WeS21bJUYIv4y73C32GiaEB+RCUMHhmK0OWMkXSwe31myn0y2BOfwRhrdScSMyIzp
	 VwfdDloofpazA==
Date: Tue, 01 Oct 2024 18:15:07 -0700
Subject: [PATCH 28/64] xfs: create libxfs helper to remove an existing
 inode/name from a directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102204.4036371.5982008802553753658.stgit@frogsfrogsfrogs>
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

Source kernel commit: 90636e4531a8bfb5ef37d38a76eb97e5f5793deb

Create a new libxfs function to remove a (name, inode) entry from a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |    2 +
 2 files changed, 83 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 802b9a1b3..e46f7f489 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -873,3 +873,84 @@ xfs_dir_add_child(
 
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
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 4f9711509..c89916d1c 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -322,5 +322,7 @@ int xfs_dir_create_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
 int xfs_dir_add_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
+int xfs_dir_remove_child(struct xfs_trans *tp, unsigned int resblks,
+		struct xfs_dir_update *du);
 
 #endif	/* __XFS_DIR2_H__ */

