Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190D7C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghIAzJAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D52C433C8;
	Sun, 31 Dec 2023 22:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062108;
	bh=9XoZJ6PVpbuAz+AAoX6+uvax110zS2ZB6uUqGKFEI9k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ghIAzJALl1X+GcMY7itUFPHJnWb/mrTCNEQVtZhQvZ56t/V47H00jkfzBWXKSe1XZ
	 OHvYcuAHAPerG6LBffKJq2goIQObcvC85c41ptfU7MZxtnRjTAgYDhss+JAZWSpDr5
	 7upzJWjVYIgEHB6bF0C0UnWf5xBdc6Ce7ICBugvnbALGh78DobY4Hg63TavMAkhlF+
	 +eIembWqjKu8hBbpRmkn9Cm1+wdKhy7ZEhMn0lbVx8cBJpNM8FQr/ZfSZ4FznLzFeT
	 +BWzzu9KLwzA/VYqSg0HIKe2kGlCiz6pEmzkeBI+UTspHXU2W0fhIzzTkZnIHhsSum
	 EHFkb/aDOaqxw==
Date: Sun, 31 Dec 2023 14:35:08 -0800
Subject: [PATCH 1/1] xfs: online repair of symbolic links
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404997644.1797016.10598029542181116253.stgit@frogsfrogsfrogs>
In-Reply-To: <170404997630.1797016.5364223101109022436.stgit@frogsfrogsfrogs>
References: <170404997630.1797016.5364223101109022436.stgit@frogsfrogsfrogs>
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

If a symbolic link target looks bad, try to sift through the rubble to
find as much of the target buffer that we can, and stage a new target
(short or remote format as needed) in a temporary file and use the
atomic extent swapping mechanism to commit the results.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c           |   11 ++++++-----
 libxfs/xfs_bmap.h           |    6 ++++++
 libxfs/xfs_symlink_remote.c |    9 +++++----
 libxfs/xfs_symlink_remote.h |   22 ++++++++++++++++++----
 4 files changed, 35 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 296e7d85f63..c6f2f4ace53 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -755,7 +755,7 @@ xfs_bmap_local_to_extents_empty(
 }
 
 
-STATIC int				/* error */
+int					/* error */
 xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*ip,		/* incore inode pointer */
@@ -765,7 +765,8 @@ xfs_bmap_local_to_extents(
 	void		(*init_fn)(struct xfs_trans *tp,
 				   struct xfs_buf *bp,
 				   struct xfs_inode *ip,
-				   struct xfs_ifork *ifp))
+				   struct xfs_ifork *ifp, void *priv),
+	void		*priv)
 {
 	int		error = 0;
 	int		flags;		/* logging flags returned */
@@ -826,7 +827,7 @@ xfs_bmap_local_to_extents(
 	 * log here. Note that init_fn must also set the buffer log item type
 	 * correctly.
 	 */
-	init_fn(tp, bp, ip, ifp);
+	init_fn(tp, bp, ip, ifp, priv);
 
 	/* account for the change in fork size */
 	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
@@ -958,8 +959,8 @@ xfs_bmap_add_attrfork_local(
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		return xfs_bmap_local_to_extents(tp, ip, 1, flags,
-						 XFS_DATA_FORK,
-						 xfs_symlink_local_to_remote);
+				XFS_DATA_FORK, xfs_symlink_local_to_remote,
+				NULL);
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index ccd1ddcd785..87633449c37 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -177,6 +177,12 @@ unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
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
index a4a242bc3d4..276e3069190 100644
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
@@ -304,9 +305,10 @@ xfs_symlink_remote_read(
 
 /* Write the symlink target into the inode. */
 int
-xfs_symlink_write_target(
+__xfs_symlink_write_target(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	xfs_ino_t		owner,
 	const char		*target_path,
 	int			pathlen,
 	xfs_fsblock_t		fs_blocks,
@@ -361,8 +363,7 @@ xfs_symlink_write_target(
 		byte_cnt = min(byte_cnt, pathlen);
 
 		buf = bp->b_addr;
-		buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset, byte_cnt,
-				bp);
+		buf += xfs_symlink_hdr_set(mp, owner, offset, byte_cnt, bp);
 
 		memcpy(buf, cur_chunk, byte_cnt);
 
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
index ac3dac8f617..e409d680133 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
@@ -16,12 +16,26 @@ int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
 bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+				 struct xfs_inode *ip, struct xfs_ifork *ifp,
+				 void *priv);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
-int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
-		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
-		uint resblks);
+int __xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_ino_t owner, const char *target_path, int pathlen,
+		xfs_fsblock_t fs_blocks, uint resblks);
+
+static inline int
+xfs_symlink_write_target(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const char		*target_path,
+	int			pathlen,
+	xfs_fsblock_t		fs_blocks,
+	uint			resblks)
+{
+	return __xfs_symlink_write_target(tp, ip, ip->i_ino, target_path,
+			pathlen, fs_blocks, resblks);
+}
 int xfs_symlink_remote_truncate(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */

