Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438C02EAE4
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585169; cv=none; b=PokM0FZlPQCHokgYxCMR1CyAVmtmj6UgITUHdK02zbIae2bHWOMEfItHS5xBYGuMVuAthOsssm7HTRnnsGg8AbZCMs/LFmLcGlszXD0PNEXR1MCJqR+xcMQ5JCC+Sog8tz0oYFRKeBuqWUmOk8G5TV0ealPx4tK3CkIKC44NH10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585169; c=relaxed/simple;
	bh=qcxYEQe1E0oUPbtbR0x0NKlmEucOx+8fv1Ln3WuySks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VD5otR0rri2w4PMh2667ebfPeIDN9ltiS82mmZWRxWWIzDXkbOuNcSo8OncMZ0PnlF2onAKmvhXrCAMuUkgcKQfHtXdKXo7+ivzDrF0nmcbxLrBMPAFVAJhrFwVTUdC6Jj2Hrev551cNwlH4vLQeO8KYvDhYQfnVxrZK4YkGS9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tg9EXFY9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tg9EXFY9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OTV+fWF5ADfmdOOCB87tAKKxwRz3E6m5IfZZm13POfc=; b=tg9EXFY9nz8bYnOzCWdxgRbfyj
	mmdmahKAdndqDN/+42/ZjNQj0nXtGhA0dyNhMPjziZHmTFoRP91scHUDAt+rE0hgDmlxcNVVr/gnK
	w+Ey9LUg07diG3njW3oJpjjSzZv982p0a0/E5cog8sjzmy/zI5Ru7qLE5aMwNiy8+Bk3MLaH148BD
	PulN1Rj4hSGhGK1YtlWl30kIsta6Zy4aWhZgLaDjBjjNUnc1z3iAslIHDe822nmHb1mIJKgsmdQnb
	0B8h4jFBBUW6n5O6xwo0MnWqtutZJWXOBQ6Ffj78OV7G2hF76+Eb0Ld7OEMC9y3PJm9YrmY0tAH3H
	mxuHBiZw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiH-00000004PLc-3wNu;
	Wed, 26 Feb 2025 15:52:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/12] xfs: unmapped buffer item size straddling mismatch
Date: Wed, 26 Feb 2025 07:51:29 -0800
Message-ID: <20250226155245.513494-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226155245.513494-1-hch@lst.de>
References: <20250226155245.513494-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

We never log large contiguous regions of unmapped buffers, so this
bug is never triggered by the current code. However, the slowpath
for formatting buffer straddling regions is broken.

That is, the size and shape of the log vector calculated across a
straddle does not match how the formatting code formats a straddle.
This results in a log vector with an uninitialised iovec and this
causes a crash when xlog_write_full() goes to copy the iovec into
the journal.

Whilst touching this code, don't bother checking mapped or single
folio buffers for discontiguous regions because they don't have
them. This significantly reduces the overhead of this check when
logging large buffers as calling xfs_buf_offset() is not free and
it occurs a *lot* in those cases.

Fixes: 929f8b0deb83 ("xfs: optimise xfs_buf_item_size/format for contiguous regions")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 47549cfa61cd..0ee6fa9efd18 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -57,6 +57,10 @@ xfs_buf_log_format_size(
 			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
 }
 
+/*
+ * We only have to worry about discontiguous buffer range straddling on unmapped
+ * buffers. Everything else will have a contiguous data region we can copy from.
+ */
 static inline bool
 xfs_buf_item_straddle(
 	struct xfs_buf		*bp,
@@ -66,6 +70,9 @@ xfs_buf_item_straddle(
 {
 	void			*first, *last;
 
+	if (bp->b_page_count == 1 || !(bp->b_flags & XBF_UNMAPPED))
+		return false;
+
 	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
 	last = xfs_buf_offset(bp,
 			offset + ((first_bit + nbits) << XFS_BLF_SHIFT));
@@ -133,11 +140,13 @@ xfs_buf_item_size_segment(
 	return;
 
 slow_scan:
-	/* Count the first bit we jumped out of the above loop from */
-	(*nvecs)++;
-	*nbytes += XFS_BLF_CHUNK;
+	ASSERT(bp->b_addr == NULL);
 	last_bit = first_bit;
+	nbits = 1;
 	while (last_bit != -1) {
+
+		*nbytes += XFS_BLF_CHUNK;
+
 		/*
 		 * This takes the bit number to start looking from and
 		 * returns the next set bit from there.  It returns -1
@@ -152,6 +161,8 @@ xfs_buf_item_size_segment(
 		 * else keep scanning the current set of bits.
 		 */
 		if (next_bit == -1) {
+			if (first_bit != last_bit)
+				(*nvecs)++;
 			break;
 		} else if (next_bit != last_bit + 1 ||
 		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
@@ -163,7 +174,6 @@ xfs_buf_item_size_segment(
 			last_bit++;
 			nbits++;
 		}
-		*nbytes += XFS_BLF_CHUNK;
 	}
 }
 
-- 
2.45.2

