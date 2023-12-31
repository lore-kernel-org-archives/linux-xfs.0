Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6D1BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1mliNvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C156EC433C7;
	Sun, 31 Dec 2023 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056617;
	bh=F63RMF430zVwAOEe/5sxFrzw9RfOxc2UYs6itPmeB/c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D1mliNvE9IKuAJHKnKhWojozjcxjhtiOVJqfzB7cFc6SgCcfz7nqrl7Fv0TbUpBYj
	 YIoqG7WySDz2GK8ae1hawMjAYRo2QCPppuUdZJ11xj9hdf8wlOpAoP2+zZSGVzgxRS
	 vPHqCHZ8z45j5nB19EmG5ENhzzSyJsGJPWsqP6BxRbaviC2SzeeI+WnYZplNaIYvcS
	 r8W/R6lvfZ3d80Y7z0inpgit8uwBHjwvNh8YL6RkNy2aub+sERL6AYzJVKsWkcAIHL
	 SJQCmzB3ALhaiLY70PE6XVJVqHwV+0L6m5BmVH3/YxLh58/sYVxXFhAV1IVI8BB4ms
	 MM5Wx5L48llGA==
Date: Sun, 31 Dec 2023 13:03:37 -0800
Subject: [PATCH 11/21] xfs: wrap inode creation dqalloc calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844230.1759932.2140666542558369855.stgit@frogsfrogsfrogs>
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

Create a helper that calls dqalloc to allocate and grab a reference to
dquots for the user, group, and project ids listed in an icreate
structure.  This simplifies the creat-related dqalloc callsites
scattered around the code base.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |    9 ++++-----
 fs/xfs/xfs_inode.c      |   38 ++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h      |    3 +++
 fs/xfs/xfs_symlink.c    |   10 ++++------
 4 files changed, 37 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index c326cf66dea5c..6d207559df989 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -43,9 +43,9 @@ xrep_tempfile_create(
 	struct xfs_icreate_args	args = { .pip = sc->mp->m_rootip, };
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_trans	*tp = NULL;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_dquot	*udqp;
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 	struct xfs_trans_res	*tres;
 	struct xfs_inode	*dp = mp->m_rootip;
 	xfs_ino_t		ino;
@@ -69,8 +69,7 @@ xrep_tempfile_create(
 	 * inode should be completely root owned so that we don't fail due to
 	 * quota limits.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
-			XFS_QMOPT_QUOTALL, &udqp, &gdqp, &pdqp);
+	error = xfs_icreate_dqalloc(&args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a95f05cd06ba6..7d3c50be179dc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -782,6 +782,24 @@ xfs_dir_hook_del(
 }
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+int
+xfs_icreate_dqalloc(
+	const struct xfs_icreate_args	*args,
+	struct xfs_dquot		**udqpp,
+	struct xfs_dquot		**gdqpp,
+	struct xfs_dquot		**pdqpp)
+{
+	unsigned int			flags = XFS_QMOPT_QUOTALL;
+
+	*udqpp = *gdqpp = *pdqpp = NULL;
+
+	if (!(args->flags & XFS_ICREATE_ARGS_FORCE_GID))
+		flags |= XFS_QMOPT_INHERIT;
+
+	return xfs_qm_vop_dqalloc(args->pip, args->uid, args->gid, args->prid,
+			flags, udqpp, gdqpp, pdqpp);
+}
+
 int
 xfs_create(
 	struct xfs_inode	*dp,
@@ -792,9 +810,9 @@ xfs_create(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_dquot	*udqp;
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 	struct xfs_trans_res	*tres;
 	struct xfs_parent_args	*ppargs;
 	xfs_ino_t		ino;
@@ -814,9 +832,7 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-			&udqp, &gdqp, &pdqp);
+	error = xfs_icreate_dqalloc(args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
@@ -966,9 +982,9 @@ xfs_create_tmpfile(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_dquot	*udqp;
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 	struct xfs_trans_res	*tres;
 	xfs_ino_t		ino;
 	uint			resblks;
@@ -983,9 +999,7 @@ xfs_create_tmpfile(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-			&udqp, &gdqp, &pdqp);
+	error = xfs_icreate_dqalloc(args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f9530494dd873..32c92e2a0fa25 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -663,5 +663,8 @@ void xfs_icreate_args_inherit(struct xfs_icreate_args *args,
 		bool init_xattrs);
 void xfs_icreate_args_rootfile(struct xfs_icreate_args *args,
 		struct xfs_mount *mp, umode_t mode, bool init_xattrs);
+int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
+		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
+		struct xfs_dquot **pdqpp);
 
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index f40fa37302829..a4872a6903e69 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -100,9 +100,9 @@ xfs_symlink(
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
 	xfs_filblks_t		fs_blocks;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_dquot	*udqp;
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 	uint			resblks;
 	xfs_ino_t		ino;
 	struct xfs_parent_args	*ppargs;
@@ -128,9 +128,7 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-			&udqp, &gdqp, &pdqp);
+	error = xfs_icreate_dqalloc(&args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 

