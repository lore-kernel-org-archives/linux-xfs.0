Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E72C101CF
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 06:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371346; cv=none; b=B/sakvejMRsZoSgr/l5aZS9yl37oe8ezMhsaQliNfaOs1zIuvfFxwDW8P3zpnbjTwi0UZnaaPsUD6xYKOWahxh/aULJn7rtZnDVoVR/yHFaOqKfVHCGSLaj6XITsbTgryemxGv78A+28fpECCfG+znOtpGzGu7iuiboewlx1Vas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371346; c=relaxed/simple;
	bh=qnXzoggrA5CPM3U2HU6IFmk4RGO1BrrTHjezom89XLg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sDyHPL5+uQzD1ZychMkim2X1M2GG2o8krXvxLiHSsqEGmnGlQvP0rgCPlOgy5EGgRyRVzgHapKW2elo0rgsToA15O7VzUh/J9bnVepyPNq8x4iYKDYu15JUlwpb51qmsYhIwwrmb5/dyQmYRkBemfZe5hTP9U0uLgpjakt60r3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d1H/100b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d1H/100b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Pve09adpjPd1rnc3XwsIcY6dISM+qwYvGnvqBoNKaM4=; b=d1H/100bwpu0fkOuMvZqkg7ZUz
	9RQKbDCiW3mjXqam/DA0Ee01maFXcres0rz5FduORjx0InZFacqUuC9ifJ210jRUJu0fkxBQTP8jp
	K3UGUH4oipMMeQ882KcHpNSutSGQqr7xzcy8iZAy1kmX9Pmp2mNnjG9UvANvKWGouwQXixOfdK2C9
	YuKrpQ81BASSeZ4TQr8EKsimFLiafYkDISQRFKzBOk8er6RWmPE522Ql0blsepep3qftr3GzF+FgE
	+aR+5ZGO/+xODZ1NghVp5sazNEKJhJfY1UF4mLkqBLbxJ5b4cK05cvbEDpuUE3y65OCEbZmY5Zcwd
	1+01Q74Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1KIi-00000001ckv-257U;
	Mon, 29 Apr 2024 06:15:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: pass the actual offset and len to allocate to xfs_bmapi_allocate
Date: Mon, 29 Apr 2024 08:15:25 +0200
Message-Id: <20240429061529.1550204-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429061529.1550204-1-hch@lst.de>
References: <20240429061529.1550204-1-hch@lst.de>
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
index f7b263d0b0cf1c..fe1ccc083eb3c4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4185,21 +4185,11 @@ xfs_bmapi_allocate(
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
@@ -4533,6 +4523,15 @@ xfs_bmapi_write(
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
@@ -4685,11 +4684,16 @@ xfs_bmapi_convert_delalloc(
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

