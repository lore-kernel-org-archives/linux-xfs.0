Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484F939DBF0;
	Mon, 20 Apr 2026 11:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685681; cv=none; b=dcNoVXEDM3MADl7oP1qfJz+/IbCjcP05TAuSUn5O20vFRuQqSFIE06We7SK89gV+vZXTTj+ue+J5nZmNvIGRjvtW9IPlw0/j4NaTMiefDhLhQQOzsgQDNEgn7mWVP8wzBp81kYTFj7R65VkU2ZeSp3VKPUWGI7ovIve3Bwvwc7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685681; c=relaxed/simple;
	bh=828QqygZ+rCpf7T6T6f7PIgnPBQ8F12tnt1TM4pNE9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPSSaTLDb8yOInQrcslH2wSg6Yu3Rjpd5kT8Hb1zBH6iKxVWg5CPOR1NuJSq4qu+AhjvmfrE01frb3sUK6NnL9gxK5xccuoPLevP+zW8e4pYq110aMg7NoFkbk8/I03xmjrHVoUveLAgBhBZ6YXo3OEa62vERWcsd5OAu1YTWi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kx1zArzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kx1zArzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0ABC2BCB6;
	Mon, 20 Apr 2026 11:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685679;
	bh=828QqygZ+rCpf7T6T6f7PIgnPBQ8F12tnt1TM4pNE9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kx1zArzNtu8cYuU9MH0tTSnlDigYMYO3ULtOdvLjutqy5nJ/5EE/BP21dMWoORPzr
	 Xy/7kObBvz3PPGcSpXvkfuX+qU9eNPmASp7LjjmCbIum7TrPV8o8N04IWITEnzGfbi
	 xyP36MQc2LYhvEM67NF569Uo+ZUZUIGxzvCQvr7SfXwdKq0Kj1uSPeedJrmdYX1PDD
	 T+nll93pwxjhHdjLAyLLPIkpmhtFYHA2Vnf/GZAz/N+CRxJvV2uk/88sdgtQWPpj/N
	 yWp/K2EoYzghkWHx0rohwZfhQbLcIBjRGlteDFte6GI8VZ3nnL6x6dxABDjGsbf4i/
	 5ea+R0XZK36AQ==
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
Subject: [PATCH v8 08/22] iomap: teach iomap to read files with fsverity
Date: Mon, 20 Apr 2026 13:46:55 +0200
Message-ID: <20260420114714.1621982-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260420114714.1621982-1-aalbersh@kernel.org>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
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
 include/linux/iomap.h  |  2 ++
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 38c9592fba43..843314852663 100644
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
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 4506a99d5285..4d9202cae29f 100644
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

