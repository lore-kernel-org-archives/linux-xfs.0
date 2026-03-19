Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EDA3EDAB1;
	Thu, 19 Mar 2026 17:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939786; cv=none; b=HP92qarog6SCGzt/u4S6MN2hTcMF69Fd9ww6C/4B2KDn//jGz43ZBMJ6OedYYp+KyLNDceAxUuzFGVORn2+d74FtpFPrEZT/lL8K8Mcqr2Y0cda45LOXEprmT6uQYl9g8BFk8ML1sLheVXUjHcAPt/M2Xn6fmabPbzFMTKALrng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939786; c=relaxed/simple;
	bh=wb9TCQfS9dYD8aO/1WIxU3NagUd8em7TfZ/Z9g/HUGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoMw2Tfr51Nx8JNzt1bhczyXMiE8fYQtawsyLjt+sgOnPUn71xK5rcyTV8qjQA2e2echBQJlY1iN/Ubk2roJxKGuT1rvaMWsKGbP92vgwtRb3Rwd4cQVISMLzzhPG/IoMIjO1yd77vKg6yozpYepct1PGVdjj/1WJ+fi4y4dMJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/kyijL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/kyijL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589BEC2BCB4;
	Thu, 19 Mar 2026 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939786;
	bh=wb9TCQfS9dYD8aO/1WIxU3NagUd8em7TfZ/Z9g/HUGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/kyijL01+bT7P78/nKKO81dWGtTBW5OQQAt/Za0V5MQ9TKeNlbXKMq3xamqhimSX
	 q13IJcwJWRh1j8hv6bbOgIw6uEtq3KtdfmkSDLDUonYw8JzBNjNs/m6+5ki9GV4ATo
	 GWYIYY5m7sQHhiF5OLYv/M2MsPkbVPpGpHAWEaUd3gvH9c4xuyh0gnCm79SvZP82mR
	 mDh0i5EhkRES0mGIyIU7xFfewcl/fN6eM6tnTVeTCM0cRYLA6bjtbKhSfCzcaM1EBK
	 ZAN5VDW2z39tFtqlta/UOkzQx4XaAbOy49DPQSZI31eAvOYCXNKR3LVoiHfdT2Qnr/
	 drN9FLFdrrBrA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v5 10/25] iomap: teach iomap to handle fsverity holes and verify data holes
Date: Thu, 19 Mar 2026 18:01:57 +0100
Message-ID: <20260319170231.1455553-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fsverity metadata has two kinds of holes - ones in merkle tree and one
after fsverity descriptor.

Merkle tree holes are blocks full of hashes of zeroed data blocks. These
are not stored on the disk but synthesized on the fly. This saves a bit
of space for sparse files. Due to this iomap also need to lookup
fsverity_info for folios with fsverity metadata. ->vi has a hash of the
zeroed data block which will be used to fill the merkle tree block. This
patch extends lookup of fsverity_info from just for file data but also
for all fsverity metadata.

The hole past descriptor is interpreted as end of metadata region. As we
don't have EOF here we use this hole as an indication that rest of the
folio is empty. This patch marks rest of the folio beyond fsverity
descriptor as uptodate.

For file data, fsverity needs to verify consistency of the whole file
against the root hash, hashes of holes are included in the merkle tree.
Verify them too.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a11e54975df8..fce748dfb2cf 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -551,9 +551,27 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 		if (plen == 0)
 			return 0;
 
-		/* zero post-eof blocks as the page may be mapped */
-		if (iomap_block_needs_zeroing(iter, pos)) {
+		/*
+		 * Handling of fsverity "holes". We hit this for two case:
+		 *   1. No need to go further, the hole after fsverity
+		 *	descriptor is the end of the fsverity metadata.
+		 *
+		 *   2. This folio contains merkle tree blocks which need to be
+		 *	synthesized. If we already have fsverity info (ctx->vi)
+		 *	synthesize these blocks.
+		 */
+		if ((iomap->flags & IOMAP_F_FSVERITY) &&
+		    iomap->type == IOMAP_HOLE) {
+			if (ctx->vi)
+				fsverity_folio_zero_hash(folio, poff, plen,
+							 ctx->vi);
+			iomap_set_range_uptodate(folio, poff, plen);
+		} else if (iomap_block_needs_zeroing(iter, pos)) {
+			/* zero post-eof blocks as the page may be mapped */
 			folio_zero_range(folio, poff, plen);
+			if (ctx->vi &&
+			    !fsverity_verify_blocks(ctx->vi, folio, plen, poff))
+				return -EIO;
 			iomap_set_range_uptodate(folio, poff, plen);
 		} else {
 			if (!*bytes_submitted)
@@ -600,9 +618,12 @@ void iomap_read_folio(const struct iomap_ops *ops,
 
 	trace_iomap_readpage(iter.inode, 1);
 
-	if (iter.pos < i_size_read(iter.inode))
-		ctx->vi = fsverity_get_info(iter.inode);
-	if (ctx->vi)
+	/*
+	 * Fetch fsverity_info for both data and fsverity metadata, as iomap
+	 * needs zeroed hash for merkle tree block synthesis
+	 */
+	ctx->vi = fsverity_get_info(iter.inode);
+	if (ctx->vi && iter.pos < i_size_read(iter.inode))
 		fsverity_readahead(ctx->vi, folio->index,
 				   folio_nr_pages(folio));
 
@@ -673,9 +694,12 @@ void iomap_readahead(const struct iomap_ops *ops,
 
 	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
 
-	if (iter.pos < i_size_read(iter.inode))
-		ctx->vi = fsverity_get_info(iter.inode);
-	if (ctx->vi)
+	/*
+	 * Fetch fsverity_info for both data and fsverity metadata, as iomap
+	 * needs zeroed hash for merkle tree block synthesis
+	 */
+	ctx->vi = fsverity_get_info(iter.inode);
+	if (ctx->vi && iter.pos < i_size_read(iter.inode))
 		fsverity_readahead(ctx->vi, readahead_index(rac),
 				readahead_count(rac));
 
-- 
2.51.2

