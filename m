Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1803DE443;
	Thu,  9 Apr 2026 16:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750605; cv=none; b=FOCKWtiPl7qWocsmd8vyROJ9PRvjOrVI49j7/0C9o02TQZlSCsyWLd77g6zEF3Qc4izH+lMBNnv4WFwxvw9BSlSGcFwjSgOWpZ/MwfHTfH/VKay3K9YNKwBbSFO0ZEoIHw7MSCcjkw9oV1KQVJgxngpnbne9yJz9AA85DOaC0gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750605; c=relaxed/simple;
	bh=3TgbYlxJf2ItsHuCxY9W4SfaeQ7siyU6eh6ifCtkH1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+bGoaxzneB78FalEkZv8PNA5cVOYXOlEobtPp8A9YhWmALloS5Frr3xjesBvz/vhO8Xdfm7OgGBzh3P92BwSvbZvIuGyfpLvad3AUd/18J6WRL+C1No1G/oo4IDr4NTdsBbGR0j+jrbhBOul9G7K6YWuwVaOzXrSColri7Htac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QOyc9qzH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QOyc9qzH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yHuKf2R6hPmZq/lyD6SwLuCsBOBwB+98uzk4f/Q1h8o=; b=QOyc9qzH2e75thhQkjHTN1KHVi
	mKc0XxeymZyrfDuiMIl8i00TLzDpGYoEidfZSzOMCAIxYaNH2irye5JqXRGrjvf3WIwgjpTy/8UdI
	eBL32Q43vpGGLs7SzgCgBw5NoF3CEU3TbR6S5QjxIp8a3gZschRvaYiiPnsKTi1xdgXYyo4WYAYRX
	z4chf+j6oy+HGPNb5W0OvIXyNbtKuQ8IFLKRYyUibu2Lyitc8+hDNihpmoEvBMgK62a3Td7tmWeka
	hqOv15xslwvIdXpycxdFt+0ZJliRCFo/Q+o1cCLeSMAF2C44AGdsicdwnNocbnFl+mR87GWVvC/pM
	gz9/jcAA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArqh-0000000At4a-0TzF;
	Thu, 09 Apr 2026 16:03:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] block: enable RWF_DONTCACHE for block devices
Date: Thu,  9 Apr 2026 18:02:16 +0200
Message-ID: <20260409160243.1008358-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Tal Zussman <tz2294@columbia.edu>

Block device buffered reads and writes already pass through
filemap_read() and iomap_file_buffered_write() respectively, both of
which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
by setting FOP_DONTCACHE in def_blk_fops.

For CONFIG_BUFFER_HEAD=y paths, add block_write_begin_iocb() which
threads the kiocb through so that buffer_head-based I/O can use
DONTCACHE behavior. The existing block_write_begin() is preserved as a
wrapper that passes a NULL iocb. Set BIO_COMPLETE_IN_TASK in
submit_bh_wbc() when the folio has dropbehind so that buffer_head
writeback completions get deferred to task context.

CONFIG_BUFFER_HEAD=n paths are handled by the previously added iomap
BIO_COMPLETE_IN_TASK support.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c                |  5 +++--
 fs/buffer.c                 | 22 +++++++++++++++++++---
 include/linux/buffer_head.h |  3 +++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index bb6642b45937..31b073181d87 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -504,7 +504,8 @@ static int blkdev_write_begin(const struct kiocb *iocb,
 			      unsigned len, struct folio **foliop,
 			      void **fsdata)
 {
-	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     blkdev_get_block);
 }
 
 static int blkdev_write_end(const struct kiocb *iocb,
@@ -966,7 +967,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)
diff --git a/fs/buffer.c b/fs/buffer.c
index d6e062c42a8d..289ab33fe3fd 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2131,14 +2131,19 @@ EXPORT_SYMBOL(block_commit_write);
  *
  * The filesystem needs to handle block truncation upon failure.
  */
-int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
+int block_write_begin_iocb(const struct kiocb *iocb,
+		struct address_space *mapping, loff_t pos, unsigned len,
 		struct folio **foliop, get_block_t *get_block)
 {
 	pgoff_t index = pos >> PAGE_SHIFT;
+	fgf_t fgp_flags = FGP_WRITEBEGIN;
 	struct folio *folio;
 	int status;
 
-	folio = __filemap_get_folio(mapping, index, FGP_WRITEBEGIN,
+	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
+		fgp_flags |= FGP_DONTCACHE;
+
+	folio = __filemap_get_folio(mapping, index, fgp_flags,
 			mapping_gfp_mask(mapping));
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
@@ -2153,6 +2158,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 	*foliop = folio;
 	return status;
 }
+
+int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
+		struct folio **foliop, get_block_t *get_block)
+{
+	return block_write_begin_iocb(NULL, mapping, pos, len, foliop,
+				      get_block);
+}
 EXPORT_SYMBOL(block_write_begin);
 
 int block_write_end(loff_t pos, unsigned len, unsigned copied,
@@ -2481,7 +2493,8 @@ int cont_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 		(*bytes)++;
 	}
 
-	return block_write_begin(mapping, pos, len, foliop, get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     get_block);
 }
 EXPORT_SYMBOL(cont_write_begin);
 
@@ -2711,6 +2724,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
 		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
 
+	if (folio_test_dropbehind(bh->b_folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_write_hint = write_hint;
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e4939e33b4b5..4ce50882d621 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -260,6 +260,9 @@ int block_read_full_folio(struct folio *, get_block_t *);
 bool block_is_partially_uptodate(struct folio *, size_t from, size_t count);
 int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 		struct folio **foliop, get_block_t *get_block);
+int block_write_begin_iocb(const struct kiocb *iocb,
+		struct address_space *mapping, loff_t pos, unsigned len,
+		struct folio **foliop, get_block_t *get_block);
 int __block_write_begin(struct folio *folio, loff_t pos, unsigned len,
 		get_block_t *get_block);
 int block_write_end(loff_t pos, unsigned len, unsigned copied, struct folio *);
-- 
2.47.3

