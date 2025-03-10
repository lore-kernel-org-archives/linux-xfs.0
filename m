Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4A81A9B3B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612802; cv=none; b=I3r0xxy/DkGRNuiQy0RQLzelp0rUqrRfaufpjqVwT38KzKWVCI+kmUXau/h52kV9zuEE2tNCubbYBJcx0VcGVyx7FHMQTApK6t7CQaiQAzarvWpmYsuR/XDa9Q0ivLl6+QY2AM3EWKaVQ9bK7Z9uBQNEckIzb/wfVaJ3FXiKY9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612802; c=relaxed/simple;
	bh=zqsJCED4EjQ8EcGsCefJ1mVwlYHgHiKiK+uHcjXBsC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5Vi7chieJfojlH0NKpMLoQi6i+MLjayxCDLQcwYcypYYadCbTnG1BXiqV+LZbrh+m7+v1Je8WVKhGEupZmZmOJOtBrAu8j/zlnPL18OxBRCIjKaxkyS5Jc8KWKFFqJDNujvjVY5Se7yL5kmsTT8TXQJhhVkAcFUnL4WtmuseOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qxx0V8+A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qxx0V8+A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GP1hUh1g9MG4qqN2UqR10dgqJkITzaCajHI3aV8ZfIg=; b=Qxx0V8+AHNKgSxL/2tAxyCxDWw
	G8Xfnd8D7zMOZxbtZvwdz7/1Q0nQMMiGiwVzoKr//zM5le4CSuDfvKT2oi8LGuKZRpCjzJVR75Hu1
	8Wqop2m54VequyivdEbo8L5tJh3a2+LDQr+O5gKQDfPljfgBsjfBTHX9x2eoYgybY21TZl395pSIB
	wmGfolhgu4UX6ULfhfC5VPGTu8dysNiEANbuM+IBscXRETqntUNIkzRGyiWNZ0X1g96X0PBE87Vfk
	qXkAIXXnnS3Q0wO7VeDSVaR8qB5ysuEdLhZzEStnpRG7p40jjR0HFyzz+PpmDK1UlGOhH0Qtppo1m
	8B2GxAEQ==;
Received: from [212.185.66.17] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1trd31-00000002lmB-4AA7;
	Mon, 10 Mar 2025 13:20:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/12] xfs: buffer items don't straddle pages anymore
Date: Mon, 10 Mar 2025 14:19:12 +0100
Message-ID: <20250310131917.552600-10-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250310131917.552600-1-hch@lst.de>
References: <20250310131917.552600-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

Unmapped buffers don't exist anymore, so the page straddling
detection and slow path code can go away now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 124 ------------------------------------------
 1 file changed, 124 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 41f0bc9aa5f4..19eb0b7a3e58 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -57,31 +57,6 @@ xfs_buf_log_format_size(
 			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
 }
 
-/*
- * We only have to worry about discontiguous buffer range straddling on unmapped
- * buffers. Everything else will have a contiguous data region we can copy from.
- */
-static inline bool
-xfs_buf_item_straddle(
-	struct xfs_buf		*bp,
-	uint			offset,
-	int			first_bit,
-	int			nbits)
-{
-	void			*first, *last;
-
-	if (bp->b_page_count == 1)
-		return false;
-
-	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
-	last = xfs_buf_offset(bp,
-			offset + ((first_bit + nbits) << XFS_BLF_SHIFT));
-
-	if (last - first != nbits * XFS_BLF_CHUNK)
-		return true;
-	return false;
-}
-
 /*
  * Return the number of log iovecs and space needed to log the given buf log
  * item segment.
@@ -98,11 +73,8 @@ xfs_buf_item_size_segment(
 	int				*nvecs,
 	int				*nbytes)
 {
-	struct xfs_buf			*bp = bip->bli_buf;
 	int				first_bit;
 	int				nbits;
-	int				next_bit;
-	int				last_bit;
 
 	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
 	if (first_bit == -1)
@@ -115,15 +87,6 @@ xfs_buf_item_size_segment(
 		nbits = xfs_contig_bits(blfp->blf_data_map,
 					blfp->blf_map_size, first_bit);
 		ASSERT(nbits > 0);
-
-		/*
-		 * Straddling a page is rare because we don't log contiguous
-		 * chunks of unmapped buffers anywhere.
-		 */
-		if (nbits > 1 &&
-		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
-			goto slow_scan;
-
 		(*nvecs)++;
 		*nbytes += nbits * XFS_BLF_CHUNK;
 
@@ -138,43 +101,6 @@ xfs_buf_item_size_segment(
 	} while (first_bit != -1);
 
 	return;
-
-slow_scan:
-	ASSERT(bp->b_addr == NULL);
-	last_bit = first_bit;
-	nbits = 1;
-	while (last_bit != -1) {
-
-		*nbytes += XFS_BLF_CHUNK;
-
-		/*
-		 * This takes the bit number to start looking from and
-		 * returns the next set bit from there.  It returns -1
-		 * if there are no more bits set or the start bit is
-		 * beyond the end of the bitmap.
-		 */
-		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
-					last_bit + 1);
-		/*
-		 * If we run out of bits, leave the loop,
-		 * else if we find a new set of bits bump the number of vecs,
-		 * else keep scanning the current set of bits.
-		 */
-		if (next_bit == -1) {
-			if (first_bit != last_bit)
-				(*nvecs)++;
-			break;
-		} else if (next_bit != last_bit + 1 ||
-		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
-			last_bit = next_bit;
-			first_bit = next_bit;
-			(*nvecs)++;
-			nbits = 1;
-		} else {
-			last_bit++;
-			nbits++;
-		}
-	}
 }
 
 /*
@@ -287,8 +213,6 @@ xfs_buf_item_format_segment(
 	struct xfs_buf		*bp = bip->bli_buf;
 	uint			base_size;
 	int			first_bit;
-	int			last_bit;
-	int			next_bit;
 	uint			nbits;
 
 	/* copy the flags across from the base format item */
@@ -333,15 +257,6 @@ xfs_buf_item_format_segment(
 		nbits = xfs_contig_bits(blfp->blf_data_map,
 					blfp->blf_map_size, first_bit);
 		ASSERT(nbits > 0);
-
-		/*
-		 * Straddling a page is rare because we don't log contiguous
-		 * chunks of unmapped buffers anywhere.
-		 */
-		if (nbits > 1 &&
-		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
-			goto slow_scan;
-
 		xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
 					first_bit, nbits);
 		blfp->blf_size++;
@@ -357,45 +272,6 @@ xfs_buf_item_format_segment(
 	} while (first_bit != -1);
 
 	return;
-
-slow_scan:
-	ASSERT(bp->b_addr == NULL);
-	last_bit = first_bit;
-	nbits = 1;
-	for (;;) {
-		/*
-		 * This takes the bit number to start looking from and
-		 * returns the next set bit from there.  It returns -1
-		 * if there are no more bits set or the start bit is
-		 * beyond the end of the bitmap.
-		 */
-		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
-					(uint)last_bit + 1);
-		/*
-		 * If we run out of bits fill in the last iovec and get out of
-		 * the loop.  Else if we start a new set of bits then fill in
-		 * the iovec for the series we were looking at and start
-		 * counting the bits in the new one.  Else we're still in the
-		 * same set of bits so just keep counting and scanning.
-		 */
-		if (next_bit == -1) {
-			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
-						first_bit, nbits);
-			blfp->blf_size++;
-			break;
-		} else if (next_bit != last_bit + 1 ||
-		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
-			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
-						first_bit, nbits);
-			blfp->blf_size++;
-			first_bit = next_bit;
-			last_bit = next_bit;
-			nbits = 1;
-		} else {
-			last_bit++;
-			nbits++;
-		}
-	}
 }
 
 /*
-- 
2.45.2

