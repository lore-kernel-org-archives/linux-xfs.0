Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5C77E6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299418; cv=none; b=Vt423PoQj8tp0/d8kBHp2X3PAwTrrq5OKzoxn+TK73lqDV1ot2LC0QaN2gNM8WHl6WYE1EBQhmlaj10p35hQujS3jGG/po/j45mrGZViEDqzW6IirrHZrYMzvSfir6ThYTJP8jpd65fAU67MVIaW6O5C+af5mGfOJs1CQExDDW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299418; c=relaxed/simple;
	bh=lERqdodjM0owbvnQKFMZ6ftQ9V/eyK2dv++2P9+I8dw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y7ErWYQlRz9rrd2dowVdwhGr4T0q9qO1wrrtmVJrkiDAX9QDYPAuCHvF4sVMOvFgbdttkI4B/kZvSftMMQgU96jK6ddBYljc7CU/mDy3yShciRlN8Q2KotfeRdQfkRKHUty9pxVm7t2+Ockhy6P8AappxmWEkOzPxZH9btRJ0RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qzkagoJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qzkagoJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250E3C32786;
	Tue, 30 Jul 2024 00:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299418;
	bh=lERqdodjM0owbvnQKFMZ6ftQ9V/eyK2dv++2P9+I8dw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qzkagoJ7EgSKB8iAZ9+bKFNIEUtBPHm4hvRgJvnDrfhrAbGU3sxWv/a79Qx2y3Wpq
	 h0VAhfNPq+Ed7Pxvms5OCEQWOq16V2E5Qc6GScgUi9u+wp71K2YX8saEiu3+L+GyI1
	 M0mBGYGpRaxBKnDCohug11z04Dg77i5f8inVVnxeEghNLUWN44D8WehSX9NbmRk0KY
	 lxohtpqY2demIvE7LEXzHrp7ZmnZLhG2Ij3rZDEa5JrDyU5Ev1XLqMG5Ub3i5lCjL9
	 xDLCETrF+MoxEDvMq3TwHXocZNjaoveghxHD3BX/9jKPh2q8sokhsh8Xz8dN+Mvnk8
	 4Q4SOt6AVaA2w==
Date: Mon, 29 Jul 2024 17:30:17 -0700
Subject: [PATCH 025/115] xfs: expose xfs_bmap_local_to_extents for online
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842795.1338752.8294926697673625653.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: ef744be416b5c649d287604730400dfa728779fe

Allow online repair to call xfs_bmap_local_to_extents and add a void *
argument at the end so that online repair can pass its own context.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c           |   11 ++++++-----
 libxfs/xfs_bmap.h           |    6 ++++++
 libxfs/xfs_symlink_remote.c |    3 ++-
 libxfs/xfs_symlink_remote.h |    3 ++-
 4 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 868334229..63feb20e2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -773,7 +773,7 @@ xfs_bmap_local_to_extents_empty(
 }
 
 
-STATIC int				/* error */
+int					/* error */
 xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*ip,		/* incore inode pointer */
@@ -783,7 +783,8 @@ xfs_bmap_local_to_extents(
 	void		(*init_fn)(struct xfs_trans *tp,
 				   struct xfs_buf *bp,
 				   struct xfs_inode *ip,
-				   struct xfs_ifork *ifp))
+				   struct xfs_ifork *ifp, void *priv),
+	void		*priv)
 {
 	int		error = 0;
 	int		flags;		/* logging flags returned */
@@ -844,7 +845,7 @@ xfs_bmap_local_to_extents(
 	 * log here. Note that init_fn must also set the buffer log item type
 	 * correctly.
 	 */
-	init_fn(tp, bp, ip, ifp);
+	init_fn(tp, bp, ip, ifp, priv);
 
 	/* account for the change in fork size */
 	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
@@ -976,8 +977,8 @@ xfs_bmap_add_attrfork_local(
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		return xfs_bmap_local_to_extents(tp, ip, 1, flags,
-						 XFS_DATA_FORK,
-						 xfs_symlink_local_to_remote);
+				XFS_DATA_FORK, xfs_symlink_local_to_remote,
+				NULL);
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index b8bdbf156..32fb2a455 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -179,6 +179,12 @@ unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
+int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_extlen_t total, int *logflagsp, int whichfork,
+		void (*init_fn)(struct xfs_trans *tp, struct xfs_buf *bp,
+				struct xfs_inode *ip, struct xfs_ifork *ifp,
+				void *priv),
+		void *priv);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 72f175990..fbcd1aebb 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -166,7 +166,8 @@ xfs_symlink_local_to_remote(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*ip,
-	struct xfs_ifork	*ifp)
+	struct xfs_ifork	*ifp,
+	void			*priv)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	char			*buf;
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
index ac3dac8f6..83b89a1de 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
@@ -16,7 +16,8 @@ int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
 bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+				 struct xfs_inode *ip, struct xfs_ifork *ifp,
+				 void *priv);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,

