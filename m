Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00357391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710615; cv=none; b=NQj4qwrz0mpRlV7OaUlQr4F4fDT6yZAXqL3bhjvx4Iki6XPyyHIAkK19kbbT3NQKss7VaXmCbYuJ+H/Z0UjZIEAJM/hKrlkhiDjDzgh7l3sJzQOHcZg98KV4LBpZn5yf59XhMmcWD56EBhkYBWBJbrS36Fnl4Nn8BS2QkUutRG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710615; c=relaxed/simple;
	bh=W0kmeq3lB8TeOF/UVybWcg4I6AA2q4cJGxlOu5y19LE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yw8Zr9noI7vM6myWKQfLspQk7XUn4QYKeiNNgZ35yW1SUdWVM1HGoqOWNTQbS6pKgg9JUMIpieIHt+dJSiYFfmngtq8ksDqR20jvx5YdH1AEii2D2mU6W3A9S/1AHXafrxSmY1/Pq8sGDNpFbjboRR02WKnZuI++iyTyfFYrHLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJVNYlSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJVNYlSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A445C433C7;
	Wed, 10 Apr 2024 00:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710614;
	bh=W0kmeq3lB8TeOF/UVybWcg4I6AA2q4cJGxlOu5y19LE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PJVNYlSALY9vHS3TogcZ7To7dzXDB/80G6fdigqKM7XnUKOnWjflXePiBfOhUODKg
	 VyA1PtkpsMHsF8EvtbyWbGfFKrw62nkO1ykoS8RItZlns253ABXoIGGr47raXkcJVq
	 xZSFkDms66WW5iUQwYSPjFjqi7Dzn+3OiK4EuaNNcFTXVVN+txzabHRvyCFdGXp0js
	 YIY6HqTjLUI8Ck064wujoGqA42S8e5xq3j0OETfWcSTgl/s4vVLHBOz+7Kgcd0rF6v
	 yJj8xiy9rp8qOw65ydAbQqsYO+7RbhdLonGEqedqxYDTXtszDqvpvkDFumSCHlN6py
	 TBEAVLTz4N/4A==
Date: Tue, 09 Apr 2024 17:56:53 -0700
Subject: [PATCH 13/32] xfs: Expose init_xattrs in xfs_create_tmpfile
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969773.3631889.2961452043600653365.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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
index 2aec7ab59aeb7..c079114b97ecf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1184,6 +1184,7 @@ xfs_create_tmpfile(
 	struct mnt_idmap	*idmap,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1224,7 +1225,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -3036,7 +3037,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index a6da1ab8ab136..04a91e312993b 100644
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
index 7f0c840f0fd2f..273bc30fd2bad 100644
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

