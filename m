Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4684FBF3
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 17:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718214424; cv=none; b=bePVT9yu/HeCTpMF5nmJgs+s1rnhnU2aqhKM9FCTR8JgKwNg5bT7Igdv61IlZCqYN+LOaGBpnnMoz+DelGcBpERldsgy/wJlRQAacSmp0avVff/jVxKwZiVZLPD4xrC3cWu+2DHyxVNJwY/CDn1aBHcLEcdj5gjoPVXX/lJ3dqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718214424; c=relaxed/simple;
	bh=FiOFlC0Y5ErL+dkPo06YkXNiqAYgPK3v3NJfU8Q3MRM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R91uLqEAzO6fxAYrYV0oQtSu4PCvxtkwxoHkr+j5WxpQiQVDZQNZXZJGuY6QEeNwwgbWd9VjhIzqmr5h6tL0uds/ql7nxJYui9jWvpWMJLKSpeqy6X5HQcFhmNXKSRTFP8lY7tEl0k348c5ShSz6jrYqOE4uNj+P0BJdIuneSd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rCsP1B3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rCsP1B3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59591C116B1;
	Wed, 12 Jun 2024 17:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718214424;
	bh=FiOFlC0Y5ErL+dkPo06YkXNiqAYgPK3v3NJfU8Q3MRM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rCsP1B3cnkkFZQdenj5pS2fWTFYT/fJdYbMktTZ9h6DwXxovR2uwFNi10cfB0XIMH
	 76v7FXWymAB1dmROYZvm/nL6RY8xzQSSExuQzGrVcBeke074hT6F8HQ8HQqwn/hH85
	 wNGw/QB34mSfqwqnILjMzdefREg5co6WWZzO5q3vg5V9JEXhV4PU9nWkvs7O35X4or
	 5TWjhYuve9FCoPZNTu9Ns1olnwZHf7WsonnU6tcNRbP5H6hvrFyR5Rmz5f7S87cLU6
	 LYob1U5FouWdZfOJCVQ4PTSpxqOdK2NMXom2KKa1uRJNXQr5HaZlN0qyt2hUAbUcLR
	 DPUMfqrBqZ8Ig==
Date: Wed, 12 Jun 2024 10:47:03 -0700
Subject: [PATCH 2/5] xfs: fix freeing speculative preallocations for
 preallocated files
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171821431794.3202459.9415164309806928337.stgit@frogsfrogsfrogs>
In-Reply-To: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
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

Both of these are bad, so do away with the force flag and always
free post-EOF delayed allocations only for files with the
XFS_DIFLAG_PREALLOC flag set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   34 ++++++++++++++++++++++------------
 fs/xfs/xfs_bmap_util.h |    2 +-
 fs/xfs/xfs_icache.c    |    2 +-
 fs/xfs/xfs_inode.c     |   14 ++++----------
 4 files changed, 28 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index eb8056b1c906..3d6896e9e540 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -485,13 +485,11 @@ xfs_bmap_punch_delalloc_range(
 
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
@@ -524,13 +522,9 @@ xfs_can_free_eofblocks(
 	if (xfs_need_iread_extents(&ip->i_df))
 		return false;
 
-	/*
-	 * Do not free real extents in preallocated files unless the file has
-	 * delalloc blocks and we are forced to remove them.
-	 */
-	if (ip->i_diflags & XFS_DIFLAG_PREALLOC)
-		if (!force || ip->i_delayed_blks == 0)
-			return false;
+	/* Only free real extents for inodes with persistent preallocations. */
+	if ((ip->i_diflags & XFS_DIFLAG_PREALLOC) && !ip->i_delayed_blks)
+		return false;
 
 	/*
 	 * Do not try to free post-EOF blocks if EOF is beyond the end of the
@@ -583,6 +577,22 @@ xfs_free_eofblocks(
 	/* Wait on dio to ensure i_size has settled. */
 	inode_dio_wait(VFS_I(ip));
 
+	/*
+	 * For preallocated files only free delayed allocations.
+	 *
+	 * Note that this means we also leave speculative preallocations in
+	 * place for preallocated files.
+	 */
+	if (ip->i_diflags & XFS_DIFLAG_PREALLOC) {
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
@@ -890,7 +900,7 @@ xfs_prepare_shift(
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
index 41b8a5c4dd69..0f07ec842b70 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1155,7 +1155,7 @@ xfs_inode_free_eofblocks(
 	}
 	*lockflags |= XFS_IOLOCK_EXCL;
 
-	if (xfs_can_free_eofblocks(ip, false))
+	if (xfs_can_free_eofblocks(ip))
 		return xfs_free_eofblocks(ip);
 
 	/* inode could be preallocated */
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

