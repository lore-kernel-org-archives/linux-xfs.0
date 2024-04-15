Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7300159908
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225230; cv=none; b=az8cyBLiR45epXXnVhuOxQJxUtJuUiIRD/tEoP32uEZPOouzUCsYEveJ6mn4S43n+UhW5iK73vFcwx66hWwfhV+A3JkaTZNUy03ZaQg9/1K/3Igzge+iqry6nf8KfiuINozfWKpplFnE4Ed6Za57ZNfAjZA6xxQz1dGzaQjXLWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225230; c=relaxed/simple;
	bh=YyZMQrRwdvA0dHk8L0CQ4iA29ocSPu05GUdFJ1QPl78=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nx6GGNhFdZPvXO1gA0B7/DgweL7WVfiz8+YA7y87Yve6V+b0to/xi5kY3PT60ny17LffeLJd3hWHjZmu83owO5dsbi+ftINSD2M/ofkkAjMgXpmVflWFvH2OS6zljEHjmygyJ4dk3HrrtqzXQfVpitokdvjp7yTjHdB428sBU0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPJdTuAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPJdTuAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59809C32783;
	Mon, 15 Apr 2024 23:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225230;
	bh=YyZMQrRwdvA0dHk8L0CQ4iA29ocSPu05GUdFJ1QPl78=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HPJdTuAs6al9imlJltY2yfukG9UOTNIT8CYVYC9TVUCg5lfvBO9R56lvfp4FDInvv
	 Z3qi1OG8Ex0jVcz60FVst5fhxQnWNDR0IEDh2fBh/9ELh8W0mxy7qmMqYlIolbjX3t
	 ewudyDRohBAg7hYvmiSjtP8uQ+ITIvTz6SXC685tPeA4mw6kb3HqV3TkpTU3W9C5Yn
	 zw6JFrXSr0EtsEmryy6kE0mx6+NnhLtF9TkUDYvPCega4BvLsSQ6Iu6GgZ37N5EX+y
	 GCR2evzXP/obRryC7VPCsawdMrchXTYTIkS7CzPYScZ9lYzOUmY5jXxsn/AHX6aGDh
	 WmCBUreip5ZpA==
Date: Mon, 15 Apr 2024 16:53:49 -0700
Subject: [PATCH 1/3] xfs: expose xfs_bmap_local_to_extents for online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322384667.89634.13336119763782440239.stgit@frogsfrogsfrogs>
In-Reply-To: <171322384642.89634.337913867524185398.stgit@frogsfrogsfrogs>
References: <171322384642.89634.337913867524185398.stgit@frogsfrogsfrogs>
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

Allow online repair to call xfs_bmap_local_to_extents and add a void *
argument at the end so that online repair can pass its own context.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c           |   11 ++++++-----
 fs/xfs/libxfs/xfs_bmap.h           |    6 ++++++
 fs/xfs/libxfs/xfs_symlink_remote.c |    3 ++-
 fs/xfs/libxfs/xfs_symlink_remote.h |    3 ++-
 4 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 46bbc9f0a117..59b8b9dc29cc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -779,7 +779,7 @@ xfs_bmap_local_to_extents_empty(
 }
 
 
-STATIC int				/* error */
+int					/* error */
 xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*ip,		/* incore inode pointer */
@@ -789,7 +789,8 @@ xfs_bmap_local_to_extents(
 	void		(*init_fn)(struct xfs_trans *tp,
 				   struct xfs_buf *bp,
 				   struct xfs_inode *ip,
-				   struct xfs_ifork *ifp))
+				   struct xfs_ifork *ifp, void *priv),
+	void		*priv)
 {
 	int		error = 0;
 	int		flags;		/* logging flags returned */
@@ -850,7 +851,7 @@ xfs_bmap_local_to_extents(
 	 * log here. Note that init_fn must also set the buffer log item type
 	 * correctly.
 	 */
-	init_fn(tp, bp, ip, ifp);
+	init_fn(tp, bp, ip, ifp, priv);
 
 	/* account for the change in fork size */
 	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
@@ -982,8 +983,8 @@ xfs_bmap_add_attrfork_local(
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		return xfs_bmap_local_to_extents(tp, ip, 1, flags,
-						 XFS_DATA_FORK,
-						 xfs_symlink_local_to_remote);
+				XFS_DATA_FORK, xfs_symlink_local_to_remote,
+				NULL);
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b8bdbf1560e6..32fb2a455c29 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
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
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 8f0d5c584f46..d150576ddd0a 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -169,7 +169,8 @@ xfs_symlink_local_to_remote(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*ip,
-	struct xfs_ifork	*ifp)
+	struct xfs_ifork	*ifp,
+	void			*priv)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	char			*buf;
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
index ac3dac8f617e..83b89a1deb9f 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
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

