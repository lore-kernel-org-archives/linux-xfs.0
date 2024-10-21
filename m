Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAB41E04AB
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548030; cv=none; b=Oz4tDL+Q4EOOe72gQ+KsICTN/g31YU9Ult+S28lWQ3YtaY24E60LnMjSb0iAGsT0YCj0EO7faiVX5LouL9vnrLwscHWwGbBGJXP/ZwBP38ug5e+xTVOAgqslIjUOFdnxvDzN6BBBcz+mf5erGECigaJuLZ0e2GquR674oS0mlE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548030; c=relaxed/simple;
	bh=mtDnYIlDEa0PDjO4XIepg+t8AOQUSBrP/Y9TrPiaYNs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bPmA8yBuii4sDXAbsufXKgfm16EYLjNQ74qE1nrnkwUyTnX0C1NX7/fbPsc8gt1+X4BqAGxvgQm7Tl//n8zz03eFykrzv3+fNti3utUFMgFQNzf1cn6M064fQSnhNM2/C1iAgwxx2YTd4aTrEONXCgPZKlSirEx7HbtquIlucko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VcVpsK3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VcVpsK3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00003C4CEC3;
	Mon, 21 Oct 2024 22:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548030;
	bh=mtDnYIlDEa0PDjO4XIepg+t8AOQUSBrP/Y9TrPiaYNs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VcVpsK3+0T3gHg53N2ikda47Hs9/6m2tGYSOqHCCIyWU+jKKBcBvaejyLGuSIHUAr
	 iHkBZ7ogRnST7Qt8TiRAjzEjBmnPaQs0k4yQL2hAmup1pYjPw6nKD4jv50b4A2ovnX
	 fuQGNjWaB56JEzs7sF/rXCBlftJIuJJMh3LlUICj5wIGpEGdYw0ftGHO5EayFDqGbU
	 vWj5KPZ7Q23xseCB4HAUSFxzHc8KMCSJb2T87IC6Zl8tnk6bwSa5uZ2bG3y+kDa5Rh
	 uAe+JwucJGtFc9L+MGCgIg+ItZI6EpNMc3Tg4grJ/9GNLobEZTwiXJncVl+EURvige
	 EqEledgHhPSsw==
Date: Mon, 21 Oct 2024 15:00:29 -0700
Subject: [PATCH 06/37] xfs: pass the icreate args object to xfs_dialloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783563.34558.10905035940882314521.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 390b4775d6787706b1846f15623a68e576ec900c

Pass the xfs_icreate_args object to xfs_dialloc since we can extract the
relevant mode (really just the file type) and parent inumber from there.
This simplifies the calling convention in preparation for the next
patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/iunlink.c        |    2 +-
 libxfs/xfs_ialloc.c |    5 +++--
 libxfs/xfs_ialloc.h |    4 +++-
 mkfs/proto.c        |    5 ++---
 repair/phase6.c     |    2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)


diff --git a/db/iunlink.c b/db/iunlink.c
index 0dc68b7240c1a3..55ba5af5a3c563 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -223,7 +223,7 @@ create_unlinked(
 		return error;
 	}
 
-	error = -libxfs_dialloc(&tp, 0, args.mode, &ino);
+	error = -libxfs_dialloc(&tp, &args, &ino);
 	if (error) {
 		dbprintf(_("alloc inode: %s\n"), strerror(error));
 		goto out_cancel;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c526f677e072b4..83e3d7d7c5a1b3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1850,11 +1850,12 @@ xfs_dialloc_try_ag(
 int
 xfs_dialloc(
 	struct xfs_trans	**tpp,
-	xfs_ino_t		parent,
-	umode_t			mode,
+	const struct xfs_icreate_args *args,
 	xfs_ino_t		*new_ino)
 {
 	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	xfs_ino_t		parent = args->pip ? args->pip->i_ino : 0;
+	umode_t			mode = args->mode & S_IFMT;
 	xfs_agnumber_t		agno;
 	int			error = 0;
 	xfs_agnumber_t		start_agno;
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index b549627e3a6150..3a1323155a455a 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -33,11 +33,13 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
 }
 
+struct xfs_icreate_args;
+
 /*
  * Allocate an inode on disk.  Mode is used to tell whether the new inode will
  * need space, and whether it is a directory.
  */
-int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
+int xfs_dialloc(struct xfs_trans **tpp, const struct xfs_icreate_args *args,
 		xfs_ino_t *new_ino);
 
 int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 8a51bfb264cedf..42ac3e10929b52 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -428,7 +428,6 @@ creatproto(
 	};
 	struct xfs_inode	*ip;
 	struct inode		*inode;
-	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t		ino;
 	int			error;
 
@@ -440,7 +439,7 @@ creatproto(
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
 	 */
-	error = -libxfs_dialloc(tpp, parent_ino, mode, &ino);
+	error = -libxfs_dialloc(tpp, &args, &ino);
 	if (error)
 		return error;
 
@@ -769,7 +768,7 @@ create_sb_metadata_file(
 	if (error)
 		res_failed(error);
 
-	error = -libxfs_dialloc(&tp, 0, args.mode, &ino);
+	error = -libxfs_dialloc(&tp, &args, &ino);
 	if (error)
 		goto fail;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index ba28edaa41c24c..b48f18b06a5c81 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -873,7 +873,7 @@ mk_orphanage(
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_dialloc(&tp, mp->m_sb.sb_rootino, args.mode, &ino);
+	error = -libxfs_dialloc(&tp, &args, &ino);
 	if (error)
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);

