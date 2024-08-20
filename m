Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D141922D3
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724173536; cv=none; b=uIQ0RQp3auFtPwNODgWLlqilVUQdAEP6M9KhqZN5/RXlAi1Gm+Dc2y9E4W8mOX48rppZ6xzaZwLwHw0TkLZ2qH4P2tGjsnVwhVSCoj5EaDU1SNMpOqp8C5HAs2fFdJUnQqus54z+PRoMUNOSmbR7FOYKZD2YzWx/+nXxp868Fkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724173536; c=relaxed/simple;
	bh=fHIQDvBeRbNuduw1ydrirbOK5ZLfuiFCFPbXhiVLIC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FORd/a96l3/2DYaUVcSmXjGbDoGZ12pk4MZ3lMDUn7iPRxkp+3r9NyAppFR9QjINYjGSvsaHbzWYKXVBVbOatoL6sl9TqLN0NwqIr71pfY8JiAiR4b15QU2WEs8xJCvu+4+6nBp2m2s3v0iSAMpUCCRc86cM/1l86/f4Eb3fFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4CTorS5r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4CTorS5r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kjKsugTo0DbWkTTYAsnUWJvqBDWH2hR7R3cGSmqZb2M=; b=4CTorS5rgyK/jYB8SNLhp2Ch9T
	kCeJwHpLDObL9QWexxI+JaoxURRnn+U3GUIKZMlY9O/+kbiSEtR3vht02ORN3e7ijifLBHKzSH3U5
	mYNkoHYmzs9nw5iZP5rpHMsFHmmB0dS31F2fEsCHi1mwfKrycAlqYOMDLmnOgebmK+IgjMEprHj/u
	WLv9EjtfgzSSTtD3lrKz9RJNfB8lA6jqqqPHQkCTXlQD4iG3/w7PkiHZIDRp2MDzJX08cryWD+K0X
	lFWX7QT3r2iguZUxcCFNuZJuxW3UMWhwGtnabbpLELa7ad6sZ8gceWqWvoH2sTbnGYKnm1Unr8pCy
	aftAsdVg==;
Received: from 2a02-8389-2341-5b80-6a7b-305c-cbe0-c9b8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6a7b:305c:cbe0:c9b8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgSIX-000000066bs-3DWA;
	Tue, 20 Aug 2024 17:05:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
Date: Tue, 20 Aug 2024 19:04:55 +0200
Message-ID: <20240820170517.528181-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240820170517.528181-1-hch@lst.de>
References: <20240820170517.528181-1-hch@lst.de>
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
---
 fs/xfs/libxfs/xfs_bmap.c | 73 +++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a63be14a9873e8..1db9d084a44c47 100644
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
2.43.0

