Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457EF172BA5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481913; cv=none; b=ElqFOCzbBHFEjlCLktT5Io849sMD8mtUvBRvxMhM7XQAETEAkSQtUDaJ6dM++mrnByOJbj+gt0BPs4m0uIkTErLrOK/8b86CVKBwNZf1ZYqYf34632hP7qa1Tukxj/3SmcTDEeMSP2heAR85nDK282b/lZNrLTgPy4FBUmgpcF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481913; c=relaxed/simple;
	bh=U1ccXr8wEXm29+CtBW3N4nBVNcPw+KyT3ulnmNaoLQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sgnpg15prFeli2Ri+XJp24rt0XfxMCn6e1JmWy/jsXxcOM2h/x8ajb7yc2dKySSUbJAYd0drmsQ5f5ryXgIcEkAtrTITzsRGVP/qjxvDv56+mcAINsOPFrX4vC7oJqa5twxQ2+u0dRprwnbdQ4Tha0d4fuE0jN04V5ChZUYz/W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ekeik80m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ekeik80m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t+vODA5BNfZ1HpARPf7QHkYqkgIW2ZKnY3sdsI/kgu8=; b=ekeik80mRLfpwB3qST6JzoLWMQ
	txTCI9Wdg0gDIdUKhTmwwb8E6RaOZLcmU8i8xAlygiOmqfEuwGwtHZJWIsmSL4pHonItjVsvLdOfg
	gLMIpKftKW0dmFaft6vg8O1QSb1lYu2NZF9z+e2zx1DefmvLe0IxjYFFvKOuobnnyClsKKud59ewL
	RrEx1ZPx6xSDW7nIEcvO4AwBYdPmrSBb74R8B72OgLyZTW4xN+a71jIG2cvO99ZzObpmfhxm22zBj
	NMzwh1QkFhmwIVHiR0T3HxoPufVcSHUZyCjTA1XdgbQMPe/0ykH/RkQAopkdn2Tu+HZOThch3kVkS
	jPyrjiQw==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1n43-00000006Pzm-0cS9;
	Tue, 30 Apr 2024 12:58:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: xfs_quota_unreserve_blkres can't fail
Date: Tue, 30 Apr 2024 14:58:22 +0200
Message-Id: <20240430125822.1776274-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430125822.1776274-1-hch@lst.de>
References: <20240430125822.1776274-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Unreserving quotas can't fail due to quota limits, and we'll notice a
shut down file system a bit later in all the callers anyway.  Return
void and remove the error checking and propagation in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 16 +++++-----------
 fs/xfs/libxfs/xfs_bmap.h |  2 +-
 fs/xfs/xfs_aops.c        |  6 +-----
 fs/xfs/xfs_bmap_util.c   |  9 +++------
 fs/xfs/xfs_bmap_util.h   |  2 +-
 fs/xfs/xfs_iomap.c       |  4 ++--
 fs/xfs/xfs_quota.h       |  7 ++++---
 fs/xfs/xfs_reflink.c     | 11 +++--------
 8 files changed, 20 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6053f5e5c71eec..68e80e8eaaeebe 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4870,7 +4870,7 @@ xfs_bmap_split_indlen(
 	*indlen2 = len2;
 }
 
-int
+void
 xfs_bmap_del_extent_delay(
 	struct xfs_inode	*ip,
 	int			whichfork,
@@ -4886,7 +4886,6 @@ xfs_bmap_del_extent_delay(
 	xfs_filblks_t		got_indlen, new_indlen, stolen = 0;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	uint64_t		fdblocks;
-	int			error = 0;
 	bool			isrt;
 
 	XFS_STATS_INC(mp, xs_del_exlist);
@@ -4906,9 +4905,7 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
-	if (error)
-		return error;
+	xfs_quota_unreserve_blkres(ip, del->br_blockcount);
 	ip->i_delayed_blks -= del->br_blockcount;
 
 	if (got->br_startoff == del->br_startoff)
@@ -5006,7 +5003,6 @@ xfs_bmap_del_extent_delay(
 
 	xfs_add_fdblocks(mp, fdblocks);
 	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
-	return error;
 }
 
 void
@@ -5564,18 +5560,16 @@ __xfs_bunmapi(
 
 delete:
 		if (wasdel) {
-			error = xfs_bmap_del_extent_delay(ip, whichfork, &icur,
-					&got, &del);
+			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
 		} else {
 			error = xfs_bmap_del_extent_real(ip, tp, &icur, cur,
 					&del, &tmp_logflags, whichfork,
 					flags);
 			logflags |= tmp_logflags;
+			if (error)
+				goto error0;
 		}
 
-		if (error)
-			goto error0;
-
 		end = del.br_startoff - 1;
 nodelete:
 		/*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e98849eb9bbae3..667b0c2b33d1d5 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -202,7 +202,7 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extnum_t nexts, int *done);
-int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
+void	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *del);
 void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3f428620ebf2a3..c51bc17f5cfa03 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -469,7 +469,6 @@ xfs_discard_folio(
 {
 	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error;
 
 	if (xfs_is_shutdown(mp))
 		return;
@@ -483,11 +482,8 @@ xfs_discard_folio(
 	 * byte of the next folio. Hence the end offset is only dependent on the
 	 * folio itself and not the start offset that is passed in.
 	 */
-	error = xfs_bmap_punch_delalloc_range(ip, pos,
+	xfs_bmap_punch_delalloc_range(ip, pos,
 				folio_pos(folio) + folio_size(folio));
-
-	if (error && !xfs_is_shutdown(mp))
-		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 }
 
 static const struct iomap_writeback_ops xfs_writeback_ops = {
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 53aa90a0ee3a85..df370d7112dc54 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -440,7 +440,7 @@ xfs_getbmap(
  * if the ranges only partially overlap them, so it is up to the caller to
  * ensure that partial blocks are not passed in.
  */
-int
+void
 xfs_bmap_punch_delalloc_range(
 	struct xfs_inode	*ip,
 	xfs_off_t		start_byte,
@@ -452,7 +452,6 @@ xfs_bmap_punch_delalloc_range(
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
 	struct xfs_bmbt_irec	got, del;
 	struct xfs_iext_cursor	icur;
-	int			error = 0;
 
 	ASSERT(!xfs_need_iread_extents(ifp));
 
@@ -476,15 +475,13 @@ xfs_bmap_punch_delalloc_range(
 			continue;
 		}
 
-		error = xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur,
-						  &got, &del);
-		if (error || !xfs_iext_get_extent(ifp, &icur, &got))
+		xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur, &got, &del);
+		if (!xfs_iext_get_extent(ifp, &icur, &got))
 			break;
 	}
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 77ecbb753ef207..51f84d8ff372fa 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -30,7 +30,7 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
 }
 #endif /* CONFIG_XFS_RT */
 
-int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
+void	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
 		xfs_off_t start_byte, xfs_off_t end_byte);
 
 struct kgetbmap {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9ce0f6b9df93e6..c06fca2e751c7c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1211,8 +1211,8 @@ xfs_buffered_write_delalloc_punch(
 	loff_t			offset,
 	loff_t			length)
 {
-	return xfs_bmap_punch_delalloc_range(XFS_I(inode), offset,
-			offset + length);
+	xfs_bmap_punch_delalloc_range(XFS_I(inode), offset, offset + length);
+	return 0;
 }
 
 static int
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 621ea9d7cf06d9..23d71a55bbc006 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -215,10 +215,11 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
 	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
 }
 
-static inline int
-xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
+static inline void
+xfs_quota_unreserve_blkres(struct xfs_inode *ip, uint64_t blocks)
 {
-	return xfs_quota_reserve_blkres(ip, -blocks);
+	/* don't return an error as unreserving quotas can't fail */
+	xfs_quota_reserve_blkres(ip, -(int64_t)blocks);
 }
 
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7da0e8f961d351..e03daae6eed637 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -606,10 +606,8 @@ xfs_reflink_cancel_cow_blocks(
 		trace_xfs_reflink_cancel_cow(ip, &del);
 
 		if (isnullstartblock(del.br_startblock)) {
-			error = xfs_bmap_del_extent_delay(ip, XFS_COW_FORK,
-					&icur, &got, &del);
-			if (error)
-				break;
+			xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &icur, &got,
+					&del);
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
 			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
 
@@ -632,10 +630,7 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 			/* Remove the quota reservation */
-			error = xfs_quota_unreserve_blkres(ip,
-					del.br_blockcount);
-			if (error)
-				break;
+			xfs_quota_unreserve_blkres(ip, del.br_blockcount);
 		} else {
 			/* Didn't do anything, push cursor back. */
 			xfs_iext_prev(ifp, &icur);
-- 
2.39.2

