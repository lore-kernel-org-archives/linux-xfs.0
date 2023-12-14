Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="freWigg8"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF54A6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=A6W5S92pR7Vj2ZGbwMxAtaxt2n7Z0ZtI1fGE2IaJjZU=; b=freWigg88wXI2LVI3SHBYR12lk
	wXA8oLqLPX9ihbztwEeJzBc3Uj+vmeFR7Xw3W3VUelh3aAyS2hfJfglTLO7o+lBZGrF5c2m/1RwUj
	8d1xsOl+n7y5S/TYyTdzl3loryXaYIwFKGrMrQYt1fzQ9yKrf3pvPT4sNE3oDNqLglZCMJ21s//wQ
	8eb1Kgi0EFN93oJgN9pYdaPzE6GO6tDGk/fOlttQgPPJwWihRi5OZrzwEC9qSroDp3YhW/lvw1jCq
	iXXkvcLWss0bi7T0YqmxpU7FyK7+HWUlRmkFVc6pLHqQGRM9Qf9SL51Zq7h8PlLOOJoQ87I75wHge
	cuOLFNYw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJJ-00GzNo-1R;
	Thu, 14 Dec 2023 06:35:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/19] xfs: cleanup picking the start extent hint in xfs_bmap_rtalloc
Date: Thu, 14 Dec 2023 07:34:28 +0100
Message-Id: <20231214063438.290538-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214063438.290538-1-hch@lst.de>
References: <20231214063438.290538-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Clean up the logical in xfs_bmap_rtalloc that tries to find a rtextent
to start the search from by using a separate variable for the hint, not
calling xfs_bmap_adjacent when we want to ignore the locality and avoid
an extra roundtrip converting between block numbers and RT extent
numbers.

As a side-effect this doesn't pointlessly call xfs_rtpick_extent and
increment the start rtextent hint if we are going to ignore the result
anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 158a631379378e..2ce3bcf4b84b76 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1393,7 +1393,8 @@ xfs_bmap_rtalloc(
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
-	xfs_rtxnum_t		rtx;
+	xfs_rtxnum_t		start;	   /* allocation hint rtextent no */
+	xfs_rtxnum_t		rtx;	   /* actually allocated rtextent no */
 	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
 	xfs_extlen_t		mod = 0;   /* product factor for allocators */
 	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
@@ -1454,30 +1455,24 @@ xfs_bmap_rtalloc(
 		rtlocked = true;
 	}
 
-	/*
-	 * If it's an allocation to an empty file at offset 0,
-	 * pick an extent that will space things out in the rt area.
-	 */
-	if (ap->eof && ap->offset == 0) {
-		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
+	if (ignore_locality) {
+		start = 0;
+	} else if (xfs_bmap_adjacent(ap)) {
+		start = xfs_rtb_to_rtx(mp, ap->blkno);
+	} else if (ap->eof && ap->offset == 0) {
+		/*
+		 * If it's an allocation to an empty file at offset 0, pick an
+		 * extent that will space things out in the rt area.
+		 */
+		error = xfs_rtpick_extent(mp, ap->tp, ralen, &start);
 		if (error)
 			return error;
-		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
 	} else {
-		ap->blkno = 0;
+		start = 0;
 	}
 
-	xfs_bmap_adjacent(ap);
-
-	/*
-	 * Realtime allocation, done through xfs_rtallocate_extent.
-	 */
-	if (ignore_locality)
-		rtx = 0;
-	else
-		rtx = xfs_rtb_to_rtx(mp, ap->blkno);
 	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
-	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
+	error = xfs_rtallocate_extent(ap->tp, start, raminlen, ralen, &ralen,
 			ap->wasdel, prod, &rtx);
 	if (error == -ENOSPC) {
 		if (align > mp->m_sb.sb_rextsize) {
@@ -1494,7 +1489,7 @@ xfs_bmap_rtalloc(
 			goto retry;
 		}
 
-		if (!ignore_locality && ap->blkno != 0) {
+		if (!ignore_locality && start != 0) {
 			/*
 			 * If we can't allocate near a specific rt extent, try
 			 * again without locality criteria.
-- 
2.39.2

