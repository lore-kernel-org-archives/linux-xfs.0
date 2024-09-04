Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A9881742
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 05:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725428327; cv=none; b=JyNPWKODQ36VbQ1IHUiasfkDRp1clMgrAGv8+i1y0Qj9lbuLWgHCOY8pC08Uj85NYM90cXiXgT+14nhIRTqg2O42ReD2KV24g0iFiuB4FT6RKHgic83U6BfKizW3Z+6rX8MoOeTtDeQtw9xeWJPhbR36biJ2d6VrKtGN780CLI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725428327; c=relaxed/simple;
	bh=lnKoj+JjGpsRAVwYj2JkT9Pq8vTDbIj17I/U8Pj/6vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1PLATj8Oe3lUnaU7DGK+smEb1rKMK/WOpb0EuuY8t2nEWzgASG0UVcc3Fz05q392c/sge0ijgz/WkWeD7r0xoxpNbVrXEGUNkObcCmGecV1vtKN3+nXqF6WrzzN6+3x+/AkT4UNmBmqtp/MD+mfgBVYrr3KSGSfITcytCtnln0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zwpYpv8b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zwpYpv8b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AejYz2DobgRHtjkHhf8ubn2TiW7LMju3+TtHOcLBneE=; b=zwpYpv8bsBKIRtbhK1lBYgQs5f
	buJP+kwuGZr5j9Gf1wCbzBv8QW9J1uyshaIYVc51qRDS59aSKaAVLTpF1j0A41xGvcMKLSka2l2t1
	mPkiSK8GdjLg5eoFmHX6Y30IFwgo/r+5o7VhBLVF1adRmqFyEuWYvzs9LZEUofM7hy6yOOAPDmUIp
	EaZ4BvAegLWxJaBZ4jb2Ni706jNqBUxtdfaPu/xCIQx/GPzPtdF3AwBs8+xlK4SSyezOHvTHWZZMi
	U1bZjs2FGOP35jiefkNT0DKt4HwJWGl7+IwCrTcuR3pw9HFlfNRVMHVSTY5Iqfur+ZV3Twn8oR07w
	EUX7Cxpw==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slij6-00000002v8U-3Kfc;
	Wed, 04 Sep 2024 05:38:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
Date: Wed,  4 Sep 2024 08:37:56 +0300
Message-ID: <20240904053820.2836285-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240904053820.2836285-1-hch@lst.de>
References: <20240904053820.2836285-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Userdata and metadata allocations end up in the same allocation helpers.
Remove the separate xfs_bmap_alloc_userdata function to make this more
clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 73 +++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7df74c35d9f900..36ff4c553ba5f7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4167,43 +4167,6 @@ xfs_bmapi_reserve_delalloc(
 	return error;
 }
 
-static int
-xfs_bmap_alloc_userdata(
-	struct xfs_bmalloca	*bma)
-{
-	struct xfs_mount	*mp = bma->ip->i_mount;
-	int			whichfork = xfs_bmapi_whichfork(bma->flags);
-	int			error;
-
-	/*
-	 * Set the data type being allocated. For the data fork, the first data
-	 * in the file is treated differently to all other allocations. For the
-	 * attribute fork, we only need to ensure the allocated range is not on
-	 * the busy list.
-	 */
-	bma->datatype = XFS_ALLOC_NOBUSY;
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
-		bma->datatype |= XFS_ALLOC_USERDATA;
-		if (bma->offset == 0)
-			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
-
-		if (mp->m_dalign && bma->length >= mp->m_dalign) {
-			error = xfs_bmap_isaeof(bma, whichfork);
-			if (error)
-				return error;
-		}
-
-		if (XFS_IS_REALTIME_INODE(bma->ip))
-			return xfs_bmap_rtalloc(bma);
-	}
-
-	if (unlikely(XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-		return xfs_bmap_exact_minlen_extent_alloc(bma);
-
-	return xfs_bmap_btalloc(bma);
-}
-
 static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
@@ -4221,15 +4184,35 @@ xfs_bmapi_allocate(
 	else
 		bma->minlen = 1;
 
-	if (bma->flags & XFS_BMAPI_METADATA) {
-		if (unlikely(XFS_TEST_ERROR(false, mp,
-				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-			error = xfs_bmap_exact_minlen_extent_alloc(bma);
-		else
-			error = xfs_bmap_btalloc(bma);
-	} else {
-		error = xfs_bmap_alloc_userdata(bma);
+	if (!(bma->flags & XFS_BMAPI_METADATA)) {
+		/*
+		 * For the data and COW fork, the first data in the file is
+		 * treated differently to all other allocations. For the
+		 * attribute fork, we only need to ensure the allocated range
+		 * is not on the busy list.
+		 */
+		bma->datatype = XFS_ALLOC_NOBUSY;
+		if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
+			bma->datatype |= XFS_ALLOC_USERDATA;
+			if (bma->offset == 0)
+				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
+
+			if (mp->m_dalign && bma->length >= mp->m_dalign) {
+				error = xfs_bmap_isaeof(bma, whichfork);
+				if (error)
+					return error;
+			}
+		}
 	}
+
+	if ((bma->datatype & XFS_ALLOC_USERDATA) &&
+	    XFS_IS_REALTIME_INODE(bma->ip))
+		error = xfs_bmap_rtalloc(bma);
+	else if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		error = xfs_bmap_exact_minlen_extent_alloc(bma);
+	else
+		error = xfs_bmap_btalloc(bma);
 	if (error)
 		return error;
 	if (bma->blkno == NULLFSBLOCK)
-- 
2.45.2

