Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0E313777F
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925220; cv=none; b=ZGkO/05CsygaJGZPhxLpYCLLALrXeSjSTOq9ROTOFj+8d+2fEcqkpF/UdZvAJgaSFgUztH+CLDbmyu3rHAlJcfklIHEnbPD4opcmkJKcKlcNmfC/KK+3WOYnAD36I52vIeB1Mg204RyY5vift0Jq8rSadkqRlONlS3T0DZnlC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925220; c=relaxed/simple;
	bh=PWSqt5aRXt22+xVPnrevZ5FuqnkmI/rrl5r9cIFLhpY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NmgHWW70d6NSi2C8nK/SkuWzlAQYJAfQooBJXTZY3Z5lywBqcgUYOLYjS6/XyF5wXACbbzkGe8qb+yrCbvnr3XZNARBBwigfoktTuzkeu66y4LGtXefUDBu6Y+Jygf6yJvhGXbEmSbHPeBe/aeZzYClqYyqx5JPkzh8S0o2lkx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJIDsJSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJIDsJSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4F6C2BD10;
	Thu, 20 Jun 2024 23:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925220;
	bh=PWSqt5aRXt22+xVPnrevZ5FuqnkmI/rrl5r9cIFLhpY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TJIDsJShA3I8JBB1Axfc7SLBkw2VD2VnLecqXxP2TBI9qxV46u+dUQZtpgVfNrl/f
	 3f31Y0MWo3pLeLXX0CEv2UzeYRF8XtsPNe7EuLeTSZjBl24jsbz6oVZb8Df0Nr7teG
	 Gj7n2oaq1RrE3J1+lMiaS6N4IOWIJ0dZHxpg54pzkQWQCVcTf4JQxZYNwfY7BBqbTj
	 fFY5uRdXT76Yr0NKkla7hWTxomH5nOXzHWDUmYkGZzlZ/jp2YhfBsEcnRJgx+Mpvxf
	 XwmeKVKUAA57m5yd+ajaXmazpt5kzEn20TyW89yHeEGSDPqlfCBMj1aUOAKkIPPHlr
	 vQI0Vt/6Qvubg==
Date: Thu, 20 Jun 2024 16:13:39 -0700
Subject: [PATCH 1/6] xfs: fix freeing speculative preallocations for
 preallocated files
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171892459249.3192151.18355050838100323730.stgit@frogsfrogsfrogs>
In-Reply-To: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
References: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

xfs_can_free_eofblocks returns false for files that have persistent
preallocations unless the force flag is passed and there are delayed
blocks.  This means it won't free delalloc reservations for files
with persistent preallocations unless the force flag is set, and it
will also free the persistent preallocations if the force flag is
set and the file happens to have delayed allocations.

Both of these are bad, so do away with the force flag and always free
only post-EOF delayed allocations for files with the XFS_DIFLAG_PREALLOC
or APPEND flags set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   30 ++++++++++++++++++++++--------
 fs/xfs/xfs_bmap_util.h |    2 +-
 fs/xfs/xfs_icache.c    |    2 +-
 fs/xfs/xfs_inode.c     |   14 ++++----------
 4 files changed, 28 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ac2e77ebb54c..a4d9fbc21b83 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -486,13 +486,11 @@ xfs_bmap_punch_delalloc_range(
 
 /*
  * Test whether it is appropriate to check an inode for and free post EOF
- * blocks. The 'force' parameter determines whether we should also consider
- * regular files that are marked preallocated or append-only.
+ * blocks.
  */
 bool
 xfs_can_free_eofblocks(
-	struct xfs_inode	*ip,
-	bool			force)
+	struct xfs_inode	*ip)
 {
 	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -526,11 +524,11 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Do not free real preallocated or append-only files unless the file
-	 * has delalloc blocks and we are forced to remove them.
+	 * Only free real extents for inodes with persistent preallocations or
+	 * the append-only flag.
 	 */
 	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
-		if (!force || ip->i_delayed_blks == 0)
+		if (ip->i_delayed_blks == 0)
 			return false;
 
 	/*
@@ -584,6 +582,22 @@ xfs_free_eofblocks(
 	/* Wait on dio to ensure i_size has settled. */
 	inode_dio_wait(VFS_I(ip));
 
+	/*
+	 * For preallocated files only free delayed allocations.
+	 *
+	 * Note that this means we also leave speculative preallocations in
+	 * place for preallocated files.
+	 */
+	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
+		if (ip->i_delayed_blks) {
+			xfs_bmap_punch_delalloc_range(ip,
+				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
+				LLONG_MAX);
+		}
+		xfs_inode_clear_eofblocks_tag(ip);
+		return 0;
+	}
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error) {
 		ASSERT(xfs_is_shutdown(mp));
@@ -891,7 +905,7 @@ xfs_prepare_shift(
 	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
 	 * into the accessible region of the file.
 	 */
-	if (xfs_can_free_eofblocks(ip, true)) {
+	if (xfs_can_free_eofblocks(ip)) {
 		error = xfs_free_eofblocks(ip);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 51f84d8ff372..eb0895bfb9da 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -63,7 +63,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
 
 /* EOF block manipulation functions */
-bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
+bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
 int	xfs_free_eofblocks(struct xfs_inode *ip);
 
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0953163a2d84..9967334ea99f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1155,7 +1155,7 @@ xfs_inode_free_eofblocks(
 	}
 	*lockflags |= XFS_IOLOCK_EXCL;
 
-	if (xfs_can_free_eofblocks(ip, false))
+	if (xfs_can_free_eofblocks(ip))
 		return xfs_free_eofblocks(ip);
 
 	/* inode could be preallocated or append-only */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 58fb7a5062e1..b699fa6ee3b6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1595,7 +1595,7 @@ xfs_release(
 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
 		return 0;
 
-	if (xfs_can_free_eofblocks(ip, false)) {
+	if (xfs_can_free_eofblocks(ip)) {
 		/*
 		 * Check if the inode is being opened, written and closed
 		 * frequently and we have delayed allocation blocks outstanding
@@ -1856,15 +1856,13 @@ xfs_inode_needs_inactive(
 
 	/*
 	 * This file isn't being freed, so check if there are post-eof blocks
-	 * to free.  @force is true because we are evicting an inode from the
-	 * cache.  Post-eof blocks must be freed, lest we end up with broken
-	 * free space accounting.
+	 * to free.
 	 *
 	 * Note: don't bother with iolock here since lockdep complains about
 	 * acquiring it in reclaim context. We have the only reference to the
 	 * inode at this point anyways.
 	 */
-	return xfs_can_free_eofblocks(ip, true);
+	return xfs_can_free_eofblocks(ip);
 }
 
 /*
@@ -1947,15 +1945,11 @@ xfs_inactive(
 
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*
-		 * force is true because we are evicting an inode from the
-		 * cache. Post-eof blocks must be freed, lest we end up with
-		 * broken free space accounting.
-		 *
 		 * Note: don't bother with iolock here since lockdep complains
 		 * about acquiring it in reclaim context. We have the only
 		 * reference to the inode at this point anyways.
 		 */
-		if (xfs_can_free_eofblocks(ip, true))
+		if (xfs_can_free_eofblocks(ip))
 			error = xfs_free_eofblocks(ip);
 
 		goto out;

