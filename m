Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE173A2E3F;
	Wed, 20 May 2026 12:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280671; cv=none; b=DWmvted1iE4RM8cGN8fxJ3CQcv4heAPGeWPyQmC0CfSBBkBnK1FiklP03d19H9bna/gMTbcPf9OujPJd3bK+f0Mm7ZSPHCo92X2sS0DrcOPPhLbmg3DedQ0bKi5HaVd4sW+G272on49lfxtsZDAaN42aA6aZT62WxGJW8Q6qXqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280671; c=relaxed/simple;
	bh=zstVptgKM2D/tEW7lhqy5Iv8bF+kKWCKyre6uXYSM8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a92vdsoC1D6WaDBslksdeF3WjCvVUN2ySXEhwHdVnWwpQYxWfTdQw7B25GLZ9IcAOG2WtMXAxwpzLUv7+RK7exRaYNm91J+e57Tymht4RJ68abe6zHxGaV80a4jouyGubb6RM2jyRrMvH331rQ/N26ng6OclJuZB6mgCn43MDRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cbz1F8g3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cbz1F8g3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171471F00894;
	Wed, 20 May 2026 12:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280668;
	bh=p1vQC2ub1UA9ygBk2EcKtqp5ZHh1Jmwwvx64Z+1Yosw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cbz1F8g3j9sMytZ6bpGR+ayY4TDv7h+Dm44W6dcZDXKk7ErsAD03rZQ56pMtT7d73
	 6FNcLiFDL6zRFaiPC/bCcyQpOLAVdJGz4gzkg3lzSCKL9n2WVNN+PaxXwKJxTxcqJJ
	 r+NdYezlEJXsxKVGPbTFbclxcZ0kmGTuXlG3t1LARoDy9KVpk0x1QaAEtHZx3jrMDt
	 Xkr1gYoXJKShEs39xluw7JVjuKUoAg+itYWIvfoLjoBXlALiF5VRzqi88U+vw11VuR
	 Z/6hPX+NFKSdeKzbIyfteayY5acBf+J9vVZ/5UMVKNYqq5Mc52OPuY0EH/wPhC4E7V
	 8Crd+wizdsQXA==
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
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v10 08/22] iomap: teach iomap to read files with fsverity
Date: Wed, 20 May 2026 14:37:06 +0200
Message-ID: <20260520123722.405752-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Obtain fsverity info for folios with file data and fsverity metadata.
Filesystem can pass vi down to ioend and then to fsverity for
verification. This is different from other filesystems ext4, f2fs, btrfs
supporting fsverity, these filesystems don't need fsverity_info for
reading fsverity metadata. While reading merkle tree iomap requires
fsverity info to synthesize hashes for zeroed data block.

fsverity metadata has two kinds of holes - ones in merkle tree and one
after fsverity descriptor.

Merkle tree holes are blocks full of hashes of zeroed data blocks. These
are not stored on the disk but synthesized on the fly. This saves a bit
of space for sparse files. Due to this iomap also need to lookup
fsverity_info for folios with fsverity metadata. ->vi has a hash of the
zeroed data block which will be used to fill the merkle tree block.

The hole past descriptor is interpreted as end of metadata region. As we
don't have EOF here we use this hole as an indication that rest of the
folio is empty. This patch marks rest of the folio beyond fsverity
descriptor as uptodate.

For file data, fsverity needs to verify consistency of the whole file
against the root hash, hashes of holes are included in the merkle tree.
Verify them too.

Issue reading of fsverity merkle tree on the fsverity inodes. This way
metadata will be available at I/O completion time.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 41 +++++++++++++++++++++++++++++++++++++++--
 fs/iomap/ioend.c       |  1 +
 include/linux/iomap.h  |  2 ++
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 3e0976bdb3ef..1c66a1c362a7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -9,6 +9,7 @@
 #include <linux/swap.h>
 #include <linux/migrate.h>
 #include <linux/fserror.h>
+#include <linux/fsverity.h>
 #include "internal.h"
 #include "trace.h"
 
@@ -561,9 +562,27 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
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
+				fsverity_fill_zerohash(folio, poff, plen,
+						       ctx->vi);
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
@@ -614,6 +633,15 @@ void iomap_read_folio(const struct iomap_ops *ops,
 
 	trace_iomap_readpage(iter.inode, 1);
 
+	/*
+	 * Fetch fsverity_info for both data and fsverity metadata, as iomap
+	 * needs zeroed hash for merkle tree block synthesis
+	 */
+	ctx->vi = fsverity_get_info(iter.inode);
+	if (ctx->vi && iter.pos < i_size_read(iter.inode))
+		fsverity_readahead(ctx->vi, folio->index,
+				   folio_nr_pages(folio));
+
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
@@ -681,6 +709,15 @@ void iomap_readahead(const struct iomap_ops *ops,
 
 	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
 
+	/*
+	 * Fetch fsverity_info for both data and fsverity metadata, as iomap
+	 * needs zeroed hash for merkle tree block synthesis
+	 */
+	ctx->vi = fsverity_get_info(iter.inode);
+	if (ctx->vi && iter.pos < i_size_read(iter.inode))
+		fsverity_readahead(ctx->vi, readahead_index(rac),
+				readahead_count(rac));
+
 	while (iomap_iter(&iter, ops) > 0)
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index acf3cf98b23a..f7c3e0c70fd7 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -28,6 +28,7 @@ struct iomap_ioend *iomap_init_ioend(struct inode *inode,
 	ioend->io_offset = file_offset;
 	ioend->io_size = bio->bi_iter.bi_size;
 	ioend->io_sector = bio->bi_iter.bi_sector;
+	ioend->io_vi = NULL;
 	ioend->io_private = NULL;
 	return ioend;
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index ad1e39cde5e0..94afe4e170d0 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -435,6 +435,7 @@ struct iomap_ioend {
 	loff_t			io_offset;	/* offset in the file */
 	sector_t		io_sector;	/* start sector of ioend */
 	void			*io_private;	/* file system private data */
+	struct fsverity_info	*io_vi;		/* fsverity info */
 	struct bio		io_bio;		/* MUST BE LAST! */
 };
 
@@ -509,6 +510,7 @@ struct iomap_read_folio_ctx {
 	struct readahead_control *rac;
 	void			*read_ctx;
 	loff_t			read_ctx_file_offset;
+	struct fsverity_info	*vi;
 };
 
 struct iomap_read_ops {
-- 
2.51.2

