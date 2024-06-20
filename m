Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBC2C8FB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924492; cv=none; b=TE6XUjwTMXDpR0siI4APFdM38Y+sdpXTpYib1q5V+ccnI9K+x4SYA4+rFjx8MKFxgJ9DRkfRlu9viwDUgdOaKoM8y8pl3i+bT+R7294OM5bmkEEoAnxqFg/HSMj/KekQosDqNBBi9AShBbHn2mgjvOK4oDyEUl7stDY2Rf5VK5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924492; c=relaxed/simple;
	bh=T6aaSSnnBFWBsxF82yfPMTtNsqkivfUqPVXFYKZ54Ns=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CUJJj8BJovEHHoX4mI3ynNUF+o9zErzQerW7FJyTmG2u3njeW24C4CbKxRaFor9HrXiYhWRbNJh9nCAcArN9siQRpCABy/etstLdRFzg5KtvmhSLufbsId3Ewp0hic15ajkRm/zlxol49ET58jgoDj4o7UaGh28nYw3VVB1e/Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fabK/nnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fabK/nnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665C8C2BD10;
	Thu, 20 Jun 2024 23:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924492;
	bh=T6aaSSnnBFWBsxF82yfPMTtNsqkivfUqPVXFYKZ54Ns=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fabK/nnvsxzsJlVuxEO93PJTLOIYR3nA2y/uMW9NkteVqUKerkzGl6b56FdukrjVm
	 5HszZEjkSSRTtZ6L5I50eDxk/JXb7DjaBJkp9FPydZnS506IuVNauQwy18FPCR1v0K
	 slij/CCodelmyeO/Jgo4rfctGPi3o5zoxm1jfe7ODxFGtyz1YXZCgHotb9oojXdPvw
	 +3ldcaNgHd2+Uk8a711uEmxLr/LPPnLKB7UqFMGUeGBSJDIjGhcBGdslVRZhw8npn9
	 C+u4Z3Mqjpf20kV19MlalTPPD9pWrBzo82sU1Ws3WDWOb4iaph2F1WvYqNOew98/fh
	 sWz6LQ/+pFGDg==
Date: Thu, 20 Jun 2024 16:01:31 -0700
Subject: [PATCH 12/24] xfs: wrap inode creation dqalloc calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418102.3183075.3384829090907441660.stgit@frogsfrogsfrogs>
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

Create a helper that calls dqalloc to allocate and grab a reference to
dquots for the user, group, and project ids listed in an icreate
structure.  This simplifies the creat-related dqalloc callsites
scattered around the code base.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |    9 +++---
 fs/xfs/xfs_inode.c      |   74 +++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_inode.h      |    4 +++
 fs/xfs/xfs_symlink.c    |   20 +++----------
 4 files changed, 55 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index ee6f93e9f7cba..523971a15a72a 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -47,9 +47,9 @@ xrep_tempfile_create(
 	};
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
@@ -70,8 +70,7 @@ xrep_tempfile_create(
 	 * inode should be completely root owned so that we don't fail due to
 	 * quota limits.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, 0,
-			XFS_QMOPT_QUOTALL, &udqp, &gdqp, &pdqp);
+	error = xfs_icreate_dqalloc(&args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d026e377fcafa..1d7febda38c16 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -728,6 +728,38 @@ xfs_dir_hook_setup(
 }
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+/* Return dquots for the ids that will be assigned to a new file. */
+int
+xfs_icreate_dqalloc(
+	const struct xfs_icreate_args	*args,
+	struct xfs_dquot		**udqpp,
+	struct xfs_dquot		**gdqpp,
+	struct xfs_dquot		**pdqpp)
+{
+	struct inode			*dir = VFS_I(args->pip);
+	kuid_t				uid = GLOBAL_ROOT_UID;
+	kgid_t				gid = GLOBAL_ROOT_GID;
+	prid_t				prid = 0;
+	unsigned int			flags = XFS_QMOPT_QUOTALL;
+
+	if (args->idmap) {
+		/*
+		 * The uid/gid computation code must match what the VFS uses to
+		 * assign i_[ug]id.  INHERIT adjusts the gid computation for
+		 * setgid/grpid systems.
+		 */
+		uid = mapped_fsuid(args->idmap, i_user_ns(dir));
+		gid = mapped_fsgid(args->idmap, i_user_ns(dir));
+		prid = xfs_get_initial_prid(args->pip);
+		flags |= XFS_QMOPT_INHERIT;
+	}
+
+	*udqpp = *gdqpp = *pdqpp = NULL;
+
+	return xfs_qm_vop_dqalloc(args->pip, uid, gid, prid, flags, udqpp,
+			gdqpp, pdqpp);
+}
+
 int
 xfs_create(
 	const struct xfs_icreate_args *args,
@@ -738,13 +770,12 @@ xfs_create(
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
-	prid_t			prid;
 	bool			unlock_dp_on_error = false;
 	bool			is_dir = S_ISDIR(args->mode);
 	uint			resblks;
@@ -757,18 +788,8 @@ xfs_create(
 	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
-
-	/*
-	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
-	 * computation code must match what the VFS uses to assign i_[ug]id.
-	 * INHERIT adjusts the gid computation for setgid/grpid systems.
-	 */
-	error = xfs_qm_vop_dqalloc(dp,
-			mapped_fsuid(args->idmap, i_user_ns(VFS_I(dp))),
-			mapped_fsgid(args->idmap, i_user_ns(VFS_I(dp))), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-			&udqp, &gdqp, &pdqp);
+	/* Make sure that we have allocated dquot(s) on disk. */
+	error = xfs_icreate_dqalloc(args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
@@ -920,12 +941,11 @@ xfs_create_tmpfile(
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
-	prid_t			prid;
 	uint			resblks;
 	int			error;
 
@@ -934,18 +954,8 @@ xfs_create_tmpfile(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
-
-	/*
-	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
-	 * computation code must match what the VFS uses to assign i_[ug]id.
-	 * INHERIT adjusts the gid computation for setgid/grpid systems.
-	 */
-	error = xfs_qm_vop_dqalloc(dp,
-			mapped_fsuid(args->idmap, i_user_ns(VFS_I(dp))),
-			mapped_fsgid(args->idmap, i_user_ns(VFS_I(dp))), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-			&udqp, &gdqp, &pdqp);
+	/* Make sure that we have allocated dquot(s) on disk. */
+	error = xfs_icreate_dqalloc(args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bc48e81829b5a..a905929494bd5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -660,4 +660,8 @@ void xfs_dir_hook_setup(struct xfs_dir_hook *hook, notifier_fn_t mod_fn);
 # define xfs_dir_update_hook(dp, ip, delta, name)	((void)0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
+		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
+		struct xfs_dquot **pdqpp);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 3b797a39950d5..6ff736e5c4e7f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -101,10 +101,9 @@ xfs_symlink(
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
 	xfs_filblks_t		fs_blocks;
-	prid_t			prid;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_dquot	*udqp;
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 	uint			resblks;
 	xfs_ino_t		ino;
 	struct xfs_parent_args	*ppargs;
@@ -127,17 +126,8 @@ xfs_symlink(
 		return -ENAMETOOLONG;
 	ASSERT(pathlen > 0);
 
-	prid = xfs_get_initial_prid(dp);
-
-	/*
-	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
-	 * computation code must match what the VFS uses to assign i_[ug]id.
-	 * INHERIT adjusts the gid computation for setgid/grpid systems.
-	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
-			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-			&udqp, &gdqp, &pdqp);
+	/* Make sure that we have allocated dquot(s) on disk. */
+	error = xfs_icreate_dqalloc(&args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 

