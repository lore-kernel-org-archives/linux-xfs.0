Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3189A23ED45
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777584; cv=none; b=ogM0aJ6gwoRfDY8LEbOGHM5RQC3qnUgYoIFNOtJDk5oP1I5z/xHcx/RXv4fq/lc8Y9C55rObO5rbwcCwMSXOfmL2SHvX8DqtWrAezuz+7bTTrS4EPA7ceL66vv0K9Eujv8RHjME2Rcd+T9bufcCOSaoEMYFx9cC8wy072BlNAqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777584; c=relaxed/simple;
	bh=Wqc0vMnXtT/bRg6DONRY9J2sSukEVCeR6YLS4Pqh4aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAypbOe47DYT0CUgGAHJFcMZN3vBLfWTokixUwK4K6XhlvcruxOxvVI1OIDClcOw14Sztvz+3uDMRfT7tg8MJXRD5pooqVTPoj0P75vJGPMbSwAbcoJAi6bIE6kgBid3XwI5oVda/gytGejEQWrxreVLNMJPxxfv5d/hBZpIyG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A1n6+EWJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A1n6+EWJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rhlM+yRZ8S+UTg6OpxwzCpyGAq3ZbM+vI3mXCWOiD/g=; b=A1n6+EWJAxExR1953TE7n00hVb
	bJ8oJ7zRvHOUe1Ec6Z7GaHemvI6avwqzdFcp/trGrbKYcRaX8GiFn290fJzZQZ8ehaJ5+JNDtftIb
	QkEPp7Gyh5jkYFfaIFv+VCOMEVA5yfaGx/cZokN+5nan2HEOoFjMAU2f2DoYSV8rLr6K202D/wuUy
	Sug1leojOw/Z+3RvAVghUcQxzFscH87RtYfDLN5WgEgrjaNpFU20/1kFIFd39hZjthfvjoqGyW/tF
	wapHNHW0NVt5nDtnFYIpRxMnuhNVXhTuuEYjdFHEIdrJiSUmYSdBw8KaAZ4Wpao94Z6KMDQcvWc+b
	TAwtR00g==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBe-00000005Mre-2Clf;
	Mon, 13 Jan 2025 14:13:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/15] xfs: move invalidate_kernel_vmap_range to xfs_buf_ioend
Date: Mon, 13 Jan 2025 15:12:14 +0100
Message-ID: <20250113141228.113714-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Invalidating cache lines can be fairly expensive, so don't do it
in interrupt context.  Note that in practice very few setup will
actually do anything here as virtually indexed caches are rather
uncommon, but we might as well move the call to the proper place
while touching this area.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 541e56b13869..e0a34c2aaaaf 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1363,6 +1363,9 @@ xfs_buf_ioend(
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
 	if (bp->b_flags & XBF_READ) {
+		if (!bp->b_error && xfs_buf_is_vmapped(bp))
+			invalidate_kernel_vmap_range(bp->b_addr,
+					xfs_buf_vmap_len(bp));
 		if (!bp->b_error && bp->b_ops)
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
@@ -1492,9 +1495,6 @@ xfs_buf_bio_end_io(
 		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
 		xfs_buf_ioerror(bp, -EIO);
 
-	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
-		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
-
 	xfs_buf_ioend_async(bp);
 	bio_put(bio);
 }
-- 
2.45.2

