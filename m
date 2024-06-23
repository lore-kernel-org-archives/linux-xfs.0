Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D832717C77
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120941; cv=none; b=oLXkXUe3fixooL0gMBG5mFupZJJHnCfTGfjBH+xAZVOhUnozo4ZP/xDBb7BvrOY/tKVidUgmBUvgvC/EfvDZ558AdnYx2jqn4rgnPuPPfHJqgCdKjP0S6pN+PBr5G7ra//e+LCbEyupgmRPn0Cw8y7irLG/iq3PCw9UBUph5raE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120941; c=relaxed/simple;
	bh=DXxsVXIbVosYCl6BpQdDlVwNks8lt5EkSN1fg9rrGog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwCKeHflJAjzBtOxT5BYn9ZpTOraQ1DEfo18wbvhfofE6le1+U18PSCMCdtMhsmKaGmPOchTh2FGKB8PrGdnmIjGgT8U+kL8yneTFI2i2zpw0APKBD1BF6MPlLSkaNSLt9GWtSL1ggwEoPCKCMnPyf7+WnStFau0vSuF6mN7nVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g0XcGyRO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g0XcGyRO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FZh9xx0esYtfCcXPZ4cwTXmTytLJ80FpYkK0BOtlmbM=; b=g0XcGyROQHYn781XonSGbPxvVw
	vGdWvbUtYIENdUFdU93kLPuI/xavLO0dGroLzxf725HaSP8bq2LxMQdM9NLUInsGGV5Oov3pySDrh
	1KEQriu+BHmJ4E+QGeGE7Nnk4CwyQRzZMxytk0FCNLGv2+aFOjkyqqBbvxSvgq69MFyIEE2lbcahI
	E5wi9vK+S48f+BCASMPEQ9Jwg7dQb+v3ZgnS59/+u+8aI39dSzVKuJymlGVqWdt0uzMMPhy6LRXFb
	odMP7fC/7W7Z7X+S2Dd0HARCWWMnjbuMNijeQbPNrwxn+SwZp0kRVsvgd/MVH1yosuYqUM+SOWl73
	wHchc+Aw==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFt4-0000000DOE7-0mTd;
	Sun, 23 Jun 2024 05:35:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/10] xfs: fix freeing speculative preallocations for preallocated files
Date: Sun, 23 Jun 2024 07:34:46 +0200
Message-ID: <20240623053532.857496-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623053532.857496-1-hch@lst.de>
References: <20240623053532.857496-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

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
---
 fs/xfs/xfs_bmap_util.c | 30 ++++++++++++++++++++++--------
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_icache.c    |  2 +-
 fs/xfs/xfs_inode.c     | 14 ++++----------
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ac2e77ebb54c73..a4d9fbc21b8343 100644
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
index 51f84d8ff372fa..eb0895bfb9dae4 100644
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
index 0953163a2d8492..9967334ea99f1a 100644
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
index f36091e1e7f50b..38f946e3be2da3 100644
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
-- 
2.43.0

