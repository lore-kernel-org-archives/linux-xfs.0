Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B5FBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dw1WlknS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B72C433C7;
	Sun, 31 Dec 2023 20:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055726;
	bh=x0+6qIR3pOHXhLqM/BZm7epT5k+S3eYMlGzwdfhoWnE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dw1WlknSAB310sZlHooqxzTCKrRAA4jjqyceS+M+y6USxcMCZZKqKmP47ZSqx8y3/
	 o7FUWZKHl8TF3Z/sDXncgp5Bo6WxokaSjWvOOmF0+DSnvUz5XMBcDNYxcEEw97S+Hj
	 BB9EPMdOol+XEFElEI4iTS9gPCaB7rFdqehIGaoedPPm0zVjXjy/RsQ2YytWfV9ILu
	 beQZhRPCoeBfsg54eQwqHxIJblTV/RI8J+CrPELoD8lgPP5OzutHg2mStdUWORn3OW
	 jsuGplpKfpQvzXhFfC6ho06RWZHFBbdIZunZWcC76+gx99P+y2ZjxtOj6qT0ja3kLW
	 144+1ZMshHi2w==
Date: Sun, 31 Dec 2023 12:48:45 -0800
Subject: [PATCH 01/18] xfs: Expose init_xattrs in xfs_create_tmpfile
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841053.1756905.7295680892065760737.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
References: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
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

Tmp files are used as part of rename operations and will need attr forks
initialized for parent pointers.  Expose the init_xattrs parameter to
the calling function to initialize the fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |    5 +++--
 fs/xfs/xfs_inode.h |    2 +-
 fs/xfs/xfs_iops.c  |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 88e0e93ded2e4..f1f8f85f941eb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1197,6 +1197,7 @@ xfs_create_tmpfile(
 	struct mnt_idmap	*idmap,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1237,7 +1238,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -3038,7 +3039,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4826155ad9147..14c6d9e7ab975 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -518,7 +518,7 @@ int		xfs_create(struct mnt_idmap *idmap,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct mnt_idmap *idmap,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 037606e5eee40..d9277f7faf534 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -202,7 +202,7 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode, false, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;

