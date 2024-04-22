Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C30C1552EC
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804007; cv=none; b=tvtSNguN8udcCU3LQD1olgEtgX1prSKnaS2sZW3Yddb6DkNfl0/LrB9yF8M+sMhQVsTxFKSa5Xg33Y+EctvTiZTKUxgbEBcfOj0CqEXZEhDZsStayLgEI39C0k7j+iUrRBlfBl6+ByT5/Upqt8mxlxV12vhWNhHrzVwU+SGVzOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804007; c=relaxed/simple;
	bh=qR3q8T0eEN5MVdCCIMTCiW/rk0cjZDOL/44wTEwWPVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZGgkqX6uh62UI2RytexDj+ysYMON/pLEgQbzaQ07UHD5X+EDwZLaOaOlXKgq+Mgi3fMdSg9vP6jGeee1+WHAr4hAfaln8eI0bpTTyLsvsRrYL470qNXcT+3IcJ41zFPaznTm+JjgoL+77UEPo2wWnyfHI7vz/0HuQsNRlRHWfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JedKcz25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JedKcz25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D23C116B1;
	Mon, 22 Apr 2024 16:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804007;
	bh=qR3q8T0eEN5MVdCCIMTCiW/rk0cjZDOL/44wTEwWPVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JedKcz2567VG5FQlZ6y2ZyVDLNMiKUOWdVjoZVMHo6Zf3mVoqyUyQpScv0EsV9Wzu
	 KVygEm4rRt0uJnHUgpSftxw4tq7Z8KYQ4BmEq5/VOPnzOqe3CDY2KC6lTOmf2++Tzv
	 jUeaawtD5bmyw7jyd7YMVSM0RLeKn7rUeQEajNA7qmOG47EjfpLFkjs+kBVykwaX3q
	 1D+YfPRuQFJPHs3HleWnnMHosdZekEy12Kp6FSH/1WVGJeJHWgQvL3hAa+G2/TQwAT
	 wGIfwHstae+1o9Hx+/3oeZxlbY/ppXcZRaxNKjG0DfyAsAcMkPemfZH7zr7vpi/iR3
	 L8IymrhaDhcHQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 39/67] xfs: zap broken inode forks
Date: Mon, 22 Apr 2024 18:26:01 +0200
Message-ID: <20240422163832.858420-41-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: e744cef206055954517648070d2b3aaa3d2515ba

Determine if inode fork damage is responsible for the inode being unable
to pass the ifork verifiers in xfs_iget and zap the fork contents if
this is true.  Once this is done the fork will be empty but we'll be
able to construct an in-core inode, and a subsequent call to the inode
fork repair ioctl will search the rmapbt to rebuild the records that
were in the fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr_leaf.c      | 13 +++----------
 libxfs/xfs_attr_leaf.h      |  3 ++-
 libxfs/xfs_bmap.c           | 22 ++++++++++++++++------
 libxfs/xfs_bmap.h           |  2 ++
 libxfs/xfs_dir2_priv.h      |  3 ++-
 libxfs/xfs_dir2_sf.c        | 13 +++----------
 libxfs/xfs_inode_fork.c     | 33 ++++++++++++++++++++++++++-------
 libxfs/xfs_shared.h         |  2 +-
 libxfs/xfs_symlink_remote.c |  8 ++------
 9 files changed, 57 insertions(+), 42 deletions(-)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index baa168318..8329348eb 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1037,23 +1037,16 @@ xfs_attr_shortform_allfit(
 	return xfs_attr_shortform_bytesfit(dp, bytes);
 }
 
-/* Verify the consistency of an inline attribute fork. */
+/* Verify the consistency of a raw inline attribute fork. */
 xfs_failaddr_t
 xfs_attr_shortform_verify(
-	struct xfs_inode		*ip)
+	struct xfs_attr_shortform	*sfp,
+	size_t				size)
 {
-	struct xfs_attr_shortform	*sfp;
 	struct xfs_attr_sf_entry	*sfep;
 	struct xfs_attr_sf_entry	*next_sfep;
 	char				*endp;
-	struct xfs_ifork		*ifp;
 	int				i;
-	int64_t				size;
-
-	ASSERT(ip->i_af.if_format == XFS_DINODE_FMT_LOCAL);
-	ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
-	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
-	size = ifp->if_bytes;
 
 	/*
 	 * Give up if the attribute is way too short.
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 368f4d9fa..ce6743463 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -56,7 +56,8 @@ int	xfs_attr_sf_findname(struct xfs_da_args *args,
 			     unsigned int *basep);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
-xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
+xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_attr_shortform *sfp,
+		size_t size);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
 /*
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 6d23c5e3e..534a516b5 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6162,19 +6162,18 @@ xfs_bmap_finish_one(
 	return error;
 }
 
-/* Check that an inode's extent does not have invalid flags or bad ranges. */
+/* Check that an extent does not have invalid flags or bad ranges. */
 xfs_failaddr_t
-xfs_bmap_validate_extent(
-	struct xfs_inode	*ip,
+xfs_bmap_validate_extent_raw(
+	struct xfs_mount	*mp,
+	bool			rtfile,
 	int			whichfork,
 	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-
 	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
 		return __this_address;
 
-	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK) {
+	if (rtfile && whichfork == XFS_DATA_FORK) {
 		if (!xfs_verify_rtbext(mp, irec->br_startblock,
 					   irec->br_blockcount))
 			return __this_address;
@@ -6204,3 +6203,14 @@ xfs_bmap_intent_destroy_cache(void)
 	kmem_cache_destroy(xfs_bmap_intent_cache);
 	xfs_bmap_intent_cache = NULL;
 }
+
+/* Check that an inode's extent does not have invalid flags or bad ranges. */
+xfs_failaddr_t
+xfs_bmap_validate_extent(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*irec)
+{
+	return xfs_bmap_validate_extent_raw(ip->i_mount,
+			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
+}
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index e33470e39..8518324db 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -263,6 +263,8 @@ static inline uint32_t xfs_bmap_fork_to_state(int whichfork)
 	}
 }
 
+xfs_failaddr_t xfs_bmap_validate_extent_raw(struct xfs_mount *mp, bool rtfile,
+		int whichfork, struct xfs_bmbt_irec *irec);
 xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *irec);
 int xfs_bmap_complain_bad_rec(struct xfs_inode *ip, int whichfork,
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 7404a9ff1..1db2e60ba 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -175,7 +175,8 @@ extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
-extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
+xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_mount *mp,
+		struct xfs_dir2_sf_hdr *sfp, int64_t size);
 int xfs_dir2_sf_entsize(struct xfs_mount *mp,
 		struct xfs_dir2_sf_hdr *hdr, int len);
 void xfs_dir2_sf_put_ino(struct xfs_mount *mp, struct xfs_dir2_sf_hdr *hdr,
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 08b36c95c..260eccacf 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -707,11 +707,10 @@ xfs_dir2_sf_check(
 /* Verify the consistency of an inline directory. */
 xfs_failaddr_t
 xfs_dir2_sf_verify(
-	struct xfs_inode		*ip)
+	struct xfs_mount		*mp,
+	struct xfs_dir2_sf_hdr		*sfp,
+	int64_t				size)
 {
-	struct xfs_mount		*mp = ip->i_mount;
-	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-	struct xfs_dir2_sf_hdr		*sfp;
 	struct xfs_dir2_sf_entry	*sfep;
 	struct xfs_dir2_sf_entry	*next_sfep;
 	char				*endp;
@@ -719,15 +718,9 @@ xfs_dir2_sf_verify(
 	int				i;
 	int				i8count;
 	int				offset;
-	int64_t				size;
 	int				error;
 	uint8_t				filetype;
 
-	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-
-	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
-	size = ifp->if_bytes;
-
 	/*
 	 * Give up if the directory is way too short.
 	 */
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 5cc056ff7..3e2d7882a 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -700,12 +700,22 @@ xfs_ifork_verify_local_data(
 	xfs_failaddr_t		fa = NULL;
 
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
-	case S_IFDIR:
-		fa = xfs_dir2_sf_verify(ip);
+	case S_IFDIR: {
+		struct xfs_mount	*mp = ip->i_mount;
+		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+		struct xfs_dir2_sf_hdr	*sfp;
+
+		sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
+		fa = xfs_dir2_sf_verify(mp, sfp, ifp->if_bytes);
 		break;
-	case S_IFLNK:
-		fa = xfs_symlink_shortform_verify(ip);
+	}
+	case S_IFLNK: {
+		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+
+		fa = xfs_symlink_shortform_verify(ifp->if_u1.if_data,
+				ifp->if_bytes);
 		break;
+	}
 	default:
 		break;
 	}
@@ -727,11 +737,20 @@ xfs_ifork_verify_local_attr(
 	struct xfs_ifork	*ifp = &ip->i_af;
 	xfs_failaddr_t		fa;
 
-	if (!xfs_inode_has_attr_fork(ip))
+	if (!xfs_inode_has_attr_fork(ip)) {
 		fa = __this_address;
-	else
-		fa = xfs_attr_shortform_verify(ip);
+	} else {
+		struct xfs_attr_shortform	*sfp;
+		struct xfs_ifork		*ifp;
+		int64_t				size;
 
+		ASSERT(ip->i_af.if_format == XFS_DINODE_FMT_LOCAL);
+		ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
+		sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+		size = ifp->if_bytes;
+
+		fa = xfs_attr_shortform_verify(sfp, size);
+	}
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
 				ifp->if_u1.if_data, ifp->if_bytes, fa);
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index c4381388c..4220d3584 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -139,7 +139,7 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
-xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
+xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
 
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 29c9f1cc1..cf894b527 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -199,15 +199,11 @@ xfs_symlink_local_to_remote(
  */
 xfs_failaddr_t
 xfs_symlink_shortform_verify(
-	struct xfs_inode	*ip)
+	void			*sfp,
+	int64_t			size)
 {
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-	char			*sfp = (char *)ifp->if_u1.if_data;
-	int			size = ifp->if_bytes;
 	char			*endp = sfp + size;
 
-	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-
 	/*
 	 * Zero length symlinks should never occur in memory as they are
 	 * never allowed to exist on disk.
-- 
2.44.0

