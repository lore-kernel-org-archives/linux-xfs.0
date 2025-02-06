Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97489224B03
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824350; cv=none; b=VVJsGpSy24qCJVxN2mXBwEE/GI04GyefxBafLy+rD2Ppu6M1RRn1oEaSzfPYGiRAVLhO1mb8ImrP/xgvJGRFiHyZXhED3G2pXU7sfWz+DA2KOCxAm3l/ZJ/2OqAFycqVm6gRJfgU7ethXZjIFYWJdQXvq+zcYA1GLMf9srQgRQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824350; c=relaxed/simple;
	bh=PFmsb3P8ufvkCnUjWUftZFaVHFMvy1mlnIunw+zgLnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCQ76fva95C/6Oayd95A8WZEm5JYpHu8yBoqmRaIVcwjerc3G/JzQovZLjKXOSgIEPUJphHIFxfoq/UMsMt9Ks6aspUj+GP1tEytVV9AvI1HGZCfkUP/BXVeCXES4Neg1KpDxQvhiErJZ2EEG08VPCLVuH5f6cnZf3T3X7qAx8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A2Q9SvKI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A2Q9SvKI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8jenVRhY8d2nKGzBsUB8dXW9Odqw/XLBE6JhmH/77ls=; b=A2Q9SvKIfqk3Vj+nqoHxWzJH+d
	8HyNgO/YhfHTL9dGYYzGo/i5ZUOorvJOgKBpx1E1rcLtlc83FPa34LvwksfMcrsgh+uNICm1P2mrv
	xZcYV1KgcOO207s67vEvYsWzH20ZHsF9W6NUjVdWEePIxF874eNd8AtkzYG7l16akGxvlY7O4+l7W
	sTycoD0N85Sx3wBVenZJDxmd0xytYhdhTERTPhf7fd7rBbcr3rySN9n2OCS1n1UL7p7rsIRpusgJ4
	vRq0NwP0mKFtWg1sQnbAiUmz+04eweQN3tV9bGlhAdvoWceY8AmsAiPUkS5H1x+EvTeRFYDEGu8Eh
	pfhJ/yOQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvdz-00000005QGr-2XGY;
	Thu, 06 Feb 2025 06:45:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/43] xfs: support XFS_BMAPI_REMAP in xfs_bmap_del_extent_delay
Date: Thu,  6 Feb 2025 07:44:28 +0100
Message-ID: <20250206064511.2323878-13-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The zone allocator wants to be able to remove a delalloc mapping in the
COW fork while keeping the block reservation.  To support that pass the
blags argument down to xfs_bmap_del_extent_delay and support the
XFS_BMAPI_REMAP flag to keep the reservation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 10 +++++++---
 fs/xfs/libxfs/xfs_bmap.h |  2 +-
 fs/xfs/xfs_bmap_util.c   |  2 +-
 fs/xfs/xfs_reflink.c     |  2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5b17e59ed5b8..522c126e52fb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4667,7 +4667,8 @@ xfs_bmap_del_extent_delay(
 	int			whichfork,
 	struct xfs_iext_cursor	*icur,
 	struct xfs_bmbt_irec	*got,
-	struct xfs_bmbt_irec	*del)
+	struct xfs_bmbt_irec	*del,
+	uint32_t		bflags)	/* bmapi flags */
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
@@ -4787,7 +4788,9 @@ xfs_bmap_del_extent_delay(
 	da_diff = da_old - da_new;
 	fdblocks = da_diff;
 
-	if (isrt)
+	if (bflags & XFS_BMAPI_REMAP)
+		;
+	else if (isrt)
 		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
 	else
 		fdblocks += del->br_blockcount;
@@ -5389,7 +5392,8 @@ __xfs_bunmapi(
 
 delete:
 		if (wasdel) {
-			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
+			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got,
+					&del, flags);
 		} else {
 			error = xfs_bmap_del_extent_real(ip, tp, &icur, cur,
 					&del, &tmp_logflags, whichfork,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 4d48087fd3a8..b4d9c6e0f3f9 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -204,7 +204,7 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extnum_t nexts, int *done);
 void	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
-		struct xfs_bmbt_irec *del);
+		struct xfs_bmbt_irec *del, uint32_t bflags);
 void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *del);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0836fea2d6d8..c623688e457c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -467,7 +467,7 @@ xfs_bmap_punch_delalloc_range(
 			continue;
 		}
 
-		xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
+		xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del, 0);
 		if (!xfs_iext_get_extent(ifp, &icur, &got))
 			break;
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index fd65e5d7994a..b977930c4ebc 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -651,7 +651,7 @@ xfs_reflink_cancel_cow_blocks(
 
 		if (isnullstartblock(del.br_startblock)) {
 			xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &icur, &got,
-					&del);
+					&del, 0);
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
 			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
 
-- 
2.45.2

