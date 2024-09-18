Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB478248D
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 05:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726637500; cv=none; b=AxcF/4VUVbDg0BV+rWza58gbx0fu3YTXRuhikLHNRFN/FvzkeBY7jo83WzrDRnQ2tePUy798oyF8iw3YsqxV3+F2E0uX7dE2QOUD3+QshyHMBXwyQw1TnfPaxNwKLiHeXA3iZq2KjtxhnzIACwKc6Hp4LtMNPO+5UMKh7rqeAF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726637500; c=relaxed/simple;
	bh=WEckFnDbLKtmjd/4V8igzRdwgR3fZfN60Xexwuh8T0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgS74LBxMoikx+5DoniX/6r/PQUJp5tyKrlFiFbCYKYqcRP9kYulzLmMuqvB7Yzk16OtrBypLg5x5viLJmHtiQSfv8EFlgF1+T4xpwSrFaw/QLgkJRk3Z3L+MyC7z3816IPz3WtDmBBlXUUwqnVpN2+QylAocXPPjCkHD/XyMEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zimrUtYQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zimrUtYQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=y9HAGapvmqUryf+n54m/OhcP+H9vNeEPzd0J7+D/3KE=; b=zimrUtYQ/314saaeoz8A6j4tRX
	c6LeMp0l2bMLgKqtA46KnjSjg3ckpIwJjSDXD36H5nI9nKDrUD7BYj375YIoh8p93cB+/Q4lNnVsB
	Ntp35mfyyISr7wsIWOt5Lv/JUqbR4oxf6A91JpI9SbFcFvat8LKaTqyWovo4lF4627PTNG1C1Nq/0
	MnYTc+Yz25hVFeZTAsS2wpunBTm2WXxTn+LvUL/+Tkiq4iD1eyV3gYPijXiEK98BobFckSIys8EAg
	ompTcvIqzguCzISqXnwjSArYd2lxDgfOkptCPpShdQMsBbTv1vgG1H6GAtbhByEWbGR+ghSo07LUB
	0fOWuh0A==;
Received: from [62.218.44.93] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sqnHu-00000007Tm8-0H15;
	Wed, 18 Sep 2024 05:31:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
Date: Wed, 18 Sep 2024 07:30:07 +0200
Message-ID: <20240918053117.774001-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240918053117.774001-1-hch@lst.de>
References: <20240918053117.774001-1-hch@lst.de>
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
index 8090e8249116d0..d5a8403b469b9d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4176,43 +4176,6 @@ xfs_bmapi_reserve_delalloc(
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
@@ -4230,15 +4193,35 @@ xfs_bmapi_allocate(
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

