Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6659155322
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804012; cv=none; b=scRhYZWrrNBunBvfU77BmqYvU61Yabsjx5l+PGCliC7OYyLx6FEVp2/fp7lqZhl5lD4YhHbrzxW3p+dZZ4tTSPeNXm9LjAyKiyu5bsopVg4wnTLtG0xryAwi97iZSMKPT1k9Q+W/zqMksyNHZiHoL9ST2XHvJd/x7U+aWjghGQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804012; c=relaxed/simple;
	bh=UeTN0MAJcj8UPCvUewdl4rrSNGpewHceTbh9WFAnfOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+Zhf0w0xenF+jB9GFRVExaCi57zgp2LXUdBJgFrAAA+OpdvqC82muXh7haWK067v2F454lB11RXDrJPqUnyMZUATeOrXzTg8IGRmaLTnMuTmF8rLiuCSp54m+WS86IILeYRPPnDETL6pLHFF9Nc/5kTQBKkBsUDSG+IIbd2Mmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyy/YASF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyy/YASF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1E5C113CC;
	Mon, 22 Apr 2024 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804011;
	bh=UeTN0MAJcj8UPCvUewdl4rrSNGpewHceTbh9WFAnfOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyy/YASFsP21Y1F6vwKCv+6NLR/fvDnCaD7LwQ4c3qw5Tie02d4v4DZb0941MiggX
	 PcQlpsv0s85OuLO2EeZuL27dHNNLcHFx0NxABc4ZQcRC8Km6Ihj3ayOGZ3xvcygxQD
	 EdKiCoisRS4KE9KTMzxOrP7vkMWuzevg1iAqj1CbvzM5wmiqg4ImX0KXB5b4kn9FUK
	 +UppMYfsFQCDr8Wz1LuuXU1FgPjZK7tFReYmZxcr1SHHBbEwuzFiynEku3wQKh3x+O
	 BhEScUCeaqmcmAocIqT8pINKlKIPhu9NA/+I7aP+zSMtD2CDjjnTDaIqzVqglGBjKB
	 hw2pHdgRXbzFg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 42/67] xfs: create a new inode fork block unmap helper
Date: Mon, 22 Apr 2024 18:26:04 +0200
Message-ID: <20240422163832.858420-44-cem@kernel.org>
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

Source kernel commit: a59eb5fc21b2a6dc160ee6cdf77f20bc186a88fd

Create a new helper to unmap blocks from an inode's fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_bmap.h |  5 ++---
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 534a516b5..3520235b5 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5233,7 +5233,7 @@ xfs_bmap_del_extent_real(
  * that value.  If not all extents in the block range can be removed then
  * *done is set.
  */
-int						/* error */
+static int
 __xfs_bunmapi(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* incore inode */
@@ -6214,3 +6214,42 @@ xfs_bmap_validate_extent(
 	return xfs_bmap_validate_extent_raw(ip->i_mount,
 			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
 }
+
+/*
+ * Used in xfs_itruncate_extents().  This is the maximum number of extents
+ * freed from a file in a single transaction.
+ */
+#define	XFS_ITRUNC_MAX_EXTENTS	2
+
+/*
+ * Unmap every extent in part of an inode's fork.  We don't do any higher level
+ * invalidation work at all.
+ */
+int
+xfs_bunmapi_range(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	uint32_t		flags,
+	xfs_fileoff_t		startoff,
+	xfs_fileoff_t		endoff)
+{
+	xfs_filblks_t		unmap_len = endoff - startoff + 1;
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	while (unmap_len > 0) {
+		ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
+		error = __xfs_bunmapi(*tpp, ip, startoff, &unmap_len, flags,
+				XFS_ITRUNC_MAX_EXTENTS);
+		if (error)
+			goto out;
+
+		/* free the just unmapped extents */
+		error = xfs_defer_finish(tpp);
+		if (error)
+			goto out;
+	}
+out:
+	return error;
+}
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 8518324db..4b83f6148 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -190,9 +190,6 @@ int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extlen_t total, struct xfs_bmbt_irec *mval, int *nmap);
-int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
-		xfs_fileoff_t bno, xfs_filblks_t *rlen, uint32_t flags,
-		xfs_extnum_t nexts);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extnum_t nexts, int *done);
@@ -273,6 +270,8 @@ int xfs_bmap_complain_bad_rec(struct xfs_inode *ip, int whichfork,
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
 		uint32_t flags);
+int	xfs_bunmapi_range(struct xfs_trans **tpp, struct xfs_inode *ip,
+		uint32_t flags, xfs_fileoff_t startoff, xfs_fileoff_t endoff);
 
 extern struct kmem_cache	*xfs_bmap_intent_cache;
 
-- 
2.44.0

