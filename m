Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837645915E
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798136; cv=none; b=o377dNYo54Rgf5kXOOeOny1E7MFwaO4PEE0eWUojKtrAJcsqiC95c3WqpSB56itvtDDmKKwaRucblnkCpSC2H91cJ7yThMA0PbVJ/s/xBS0t99VyZgFCKmYP7wbXaI+Om/EGgMg6NSAG5yGZ1mU6XFhNPkT0SEiSudJ5mLfmYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798136; c=relaxed/simple;
	bh=LZIpVSogOuoOnlFuCnt3bCgyDU26TDMznGLXm3CDAxU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BY/nOHZTHeeBZl3yX3wqMX3IZoUMJ8HxEIZIATZDuH4qSkKG5njtPL+hODcbFLPkRf1G7YbcM9HLlpEh7tpt8jVFHdbyyyOE+IZNyoLRiM33P4kBVFS1LQ/wNUi7ru+y5qtndO1YX0wpw69J5T6VXp2tB6480W8Vs9pW67qwlS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ds29p0U6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ds29p0U6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08934C433F1;
	Mon, 18 Mar 2024 21:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798136;
	bh=LZIpVSogOuoOnlFuCnt3bCgyDU26TDMznGLXm3CDAxU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ds29p0U6EjYh6Oto+ZicUbpeey/OgUDJ8eu6c3kww5zyUAdS1i9B02z6pw806XIzS
	 imW0o7OjC7l21GmGfngnWNoH7BTmF9lZfuz1DmMo4iyZXL++oeFYeTf28CyfWCZlbB
	 n2yaZTdXjf/Q/8B06wH0KlUtb24StX2l7qB5lYmuKaGTgujmOoYnNdlXR4porHCqlM
	 8Kg65Msp4nIudIBOsFeOisf7wWeghb+j5w9/mKQN6qvm440xzFW2iBE+aLPsXpLhTO
	 AByC7O1kBK4Q/r8EYFic5PzSEWXfKh2Y8HY7Hmdflk/V3lmWEEmfT1CeSxfHqx2xLR
	 ELq9ssiCFd9hw==
Date: Mon, 18 Mar 2024 14:42:15 -0700
Subject: [PATCH 01/23] xfs: Expose init_xattrs in xfs_create_tmpfile
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079801888.3806377.5178781335830554740.stgit@frogsfrogsfrogs>
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
index 5d12e3911ec57..ab177f82b4302 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1206,6 +1206,7 @@ xfs_create_tmpfile(
 	struct mnt_idmap	*idmap,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1246,7 +1247,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -3047,7 +3048,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 34ee1dd01d203..8a3bec482e1f2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -522,7 +522,7 @@ int		xfs_create(struct mnt_idmap *idmap,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct mnt_idmap *idmap,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e1b15a002a8ff..e3d6a5d04ae38 100644
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

