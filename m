Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DEF126F07
	for <linux-xfs@vger.kernel.org>; Mon,  8 Apr 2024 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588111; cv=none; b=S42mgVFuxtb/GLD+hL9NZrOf5EHD194OCrZWun3FDjPVr6SFIknnnz46IDUwAHnlX3uqMIwPifYU5cJrGMQrKMrd0uP51OQQf7jWmKuzhZJRwDqF/FvOtFOGcD+CHQBET19kFJDxigJdUtLC6Le5gQJe53AmBZneHdLzabFwsEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588111; c=relaxed/simple;
	bh=IV9ugqB85e5tyl7yXwoEpM4SItAJoJjqrJMfWaY+R3U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aAfwsBq8HhAo1O2t6rYQTCQn6mLUjcF1iUuvkAB416YSQe1AfcvZnAET5JgCg96B2sI/gawhiOqSbG4oTdev8UPOxO4XgPf+r9I5vqQPIEI+uD6Xe9+pvAsvf/averGOl2U9h6/5tMtVtclmTGscC9ZfTBW4ba4AulPL4gVUFkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cHBUAeJX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cHBUAeJX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vnU4FvBRnGMDYTgQbXox23SOal8b1OwcNyKSFxi/+Eg=; b=cHBUAeJXEqUCK6cD94v+hR+HCp
	evfKvved8ZjdxXYNqr1nDpgR0gq/TkUd5YXg2gxOs3CfqVPKmpX+9hB8VdqSVGk/Vd5J6kAXk53fL
	rO9AtbC+Je/cnxf79W/kGItZ1n40s8+Z5uFYUF8RDFIeyO7acAZZ2QdzkM+5Zn/6D5RZBEoDBtJ7z
	bMKXeloWdQCPUcrfVTQTL9K/SUWu2FcqAYY+IQoYqQFsujiIWnrYVfDDRwW+1Bwix27tx6wg1Ze5U
	5QKKxdkn9y56b6MD3+lYwcFKHm6DRv1thQ6eUE/7xO+WNjkDFEQ2vrCTh+ksS5oCFZDDfVxcL0eBQ
	k65G5nEw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtqOr-0000000FwYi-1FS6;
	Mon, 08 Apr 2024 14:55:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH 5/8] xfs: pass the actual offset and len to allocate to xfs_bmapi_allocate
Date: Mon,  8 Apr 2024 16:54:51 +0200
Message-Id: <20240408145454.718047-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240408145454.718047-1-hch@lst.de>
References: <20240408145454.718047-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_bmapi_allocate currently overwrites offset and len when converting
delayed allocations, and duplicates the length cap done for non-delalloc
allocations.  Move all that logic into the callers to avoid duplication
and to make the calling conventions more obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f2e934c2fb423c..aa182937de4641 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4194,21 +4194,11 @@ xfs_bmapi_allocate(
 	int			error;
 
 	ASSERT(bma->length > 0);
+	ASSERT(bma->length <= XFS_MAX_BMBT_EXTLEN);
 
-	/*
-	 * For the wasdelay case, we could also just allocate the stuff asked
-	 * for in this bmap call but that wouldn't be as good.
-	 */
 	if (bma->wasdel) {
-		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
-		bma->offset = bma->got.br_startoff;
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
-	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
-		if (!bma->eof)
-			bma->length = XFS_FILBLKS_MIN(bma->length,
-					bma->got.br_startoff - bma->offset);
 	}
 
 	if (bma->flags & XFS_BMAPI_CONTIG)
@@ -4542,6 +4532,15 @@ xfs_bmapi_write(
 			 */
 			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
 
+			if (wasdelay) {
+				bma.offset = bma.got.br_startoff;
+				bma.length = bma.got.br_blockcount;
+			} else {
+				if (!eof)
+					bma.length = XFS_FILBLKS_MIN(bma.length,
+						bma.got.br_startoff - bno);
+			}
+
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
 			if (error) {
@@ -4694,11 +4693,16 @@ xfs_bmapi_convert_delalloc(
 	bma.tp = tp;
 	bma.ip = ip;
 	bma.wasdel = true;
-	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
-			XFS_MAX_BMBT_EXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
+	/*
+	 * Always allocate convert from the start of the delalloc extent even if
+	 * that is outside the passed in range to create large contiguous
+	 * extents on disk.
+	 */
+	bma.offset = bma.got.br_startoff;
+	bma.length = bma.got.br_blockcount;
+
 	/*
 	 * When we're converting the delalloc reservations backing dirty pages
 	 * in the page cache, we must be careful about how we create the new
-- 
2.39.2

