Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B088F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928528; cv=none; b=G7WKH/S3MAyzjrxd78bjgAdIdCFfwHlFdOLVZMXB4owFZdyJU5aSfRLjFDNHsFXUcnKiuql+IL9rRDa1dQhh07DxLjW+2Tqk9mguEmuQ9Mkfwt6FvVCpxb9PcUaEUz8LkcmBVDbzanRIVDBUIOTOMyKkP366j/EE1mxCY7VchZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928528; c=relaxed/simple;
	bh=6AtAKCeis/S60P6MOy+upD7TU5AnKDE10edS9j0mcPA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyiMNDaP3tAmV2WNbxUyrOuYn0kf5jTGAL6kwpn8ilpBUmwIAWvQY5zKVT8tPIznfH02/LkYaFMFzzSIM+9iPfgDNyj4mwZs+6+srtXfaxfEL9MpZ3MSt+cII7p4iAnwCW7wd3Ws+NcYSlNn9577ZCsCdTOGUN9CeXLdgT51/NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gmD5TEg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gmD5TEg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0994C116B1;
	Wed, 24 Apr 2024 03:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928527;
	bh=6AtAKCeis/S60P6MOy+upD7TU5AnKDE10edS9j0mcPA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gmD5TEg7YhqB2zyvnmbCat3Q6LQYVI83IPtkqJUL2IwXwvRPmAHoUJlFDFDI99BN0
	 ZI5/UqHoCuIq5ZU5oNwj5p8uXKc5kTb+poiErvOIdYFkjW487ttiuowcbnPIF3yIjW
	 Uwpi0iVXnpJ6SDx2n4MOxtPdzjn5+CkN8kbrFb8LT9yQtCZb+iWRT3GX3+FsgwMFa3
	 iWg5VwSNLaZ9xVSLl/ytYLX27U05FA2M1PI66O/W9KJfobE8jYuSwiG2g2QIOvNoNn
	 hfph/ukUccN3+Fmhl4mPa0Xnx/SmOmTe4FDFhm7p5XYN8szjQvAOH2JCRi8n0p0+ur
	 PIsDkDMrQXi6w==
Date: Tue, 23 Apr 2024 20:15:27 -0700
Subject: [PATCH 11/30] xfs: Expose init_xattrs in xfs_create_tmpfile
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783452.1905110.5389883568332798757.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c |    5 +++--
 fs/xfs/xfs_inode.h |    2 +-
 fs/xfs/xfs_iops.c  |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3c843223b4ed..060e4e767b51 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1185,6 +1185,7 @@ xfs_create_tmpfile(
 	struct mnt_idmap	*idmap,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1225,7 +1226,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -3037,7 +3038,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index a6da1ab8ab13..04a91e312993 100644
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
index 659fd10c0cda..d32322f9ecde 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -201,7 +201,7 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode, false, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;

