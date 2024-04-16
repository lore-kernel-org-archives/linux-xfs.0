Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13346FC7
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230935; cv=none; b=ayXe5uhgBoCZiQ5F9dFp/VMq8i3m0aVvAMwwRNu11UNhqQ1oGGRsc/4RXIqWLWe+xzgOqGr5+Cql4FvvNJf/TbDxjSa7RNcHULNikh77bjUOI8AObLD6LazkAg60qQ8FTJxQsiHLxgPJ30R/ts4YxwbeapxAAVTRcvXVjXADVjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230935; c=relaxed/simple;
	bh=qbGzngSqcnFQq38yfbjrgcLcnzGdOmT+QZnUe9Ty87s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rsd91iqooAmT7aGlaAQAxbZmW9U3GBjtcyzS0D3QPMLLGnKekZpOsKpmamd9O1xkGxia+aNTkbGcM+/Sl89JGx3yNcE/nPE/zD9CWDsLgc/swrDFauklcrAbriQDeZOAJv6dWMjMzPgebV6TLP+YL5Kd6Z6MfEUmpXtPd8GhHzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZ0q6qkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZ0q6qkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321EEC113CC;
	Tue, 16 Apr 2024 01:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230935;
	bh=qbGzngSqcnFQq38yfbjrgcLcnzGdOmT+QZnUe9Ty87s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RZ0q6qkwSfM49UY5DLtZXUfhPO10D8cMhjjRsB50KGbnIRRIa4VxcvjqJmUCKkbVr
	 woJDeMWjB+7EsT3bZiSjJ7nLZhOIp31HVmnCjCmz2hU2b+ic7h+VZE68abAEk7BRz/
	 jmYHXAFKwILYGaTan90VKp3R0ClwIXjZUX9+/r7+VId0N4L23+F4E+LQCuPEHWcnvW
	 0PHmhXoVC9ZNfob0ovqejq910bQ/7/BbBG71x5AyVDlYHtEj1/8pIkrKWXR1pMphVw
	 M1m9Ktof1/KPXNmvXpIfceJxlWbTSUJqQfPLkDfSPVlJIdO14o+qGQ0ptD5EVLb2PE
	 e7xTQznM8qmhg==
Date: Mon, 15 Apr 2024 18:28:54 -0700
Subject: [PATCH 11/31] xfs: Expose init_xattrs in xfs_create_tmpfile
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323027964.251715.16105792435381545624.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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
index 76c0d482ae481..149f854bf12dc 100644
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

