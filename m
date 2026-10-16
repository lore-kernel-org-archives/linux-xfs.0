Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511882E7375;
	Fri, 16 Oct 2026 03:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121721; cv=none; b=AV5NzQNbaTNXTHT0ygwvGFwCidLVM8PJPjNfv+luK9pC8QDPSwIBq5w0oOE/6/im2ztpVdUhBJ/NRYNhuHyqOT5B5PR5fQ2U56U7GCeOfRNfK+8OVlCZmOxFPw9gVDbxi2MLDyXQrbr7bCWtjDol4UCVuPFivaxLLyBFOFy0V/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121721; c=relaxed/simple;
	bh=ezLljHoNB3dpMc21EGWjEBhp1r00/FX0/xgsQ0AkJ8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzx0dhriFTzB3l8GE6QpblDpNo6hdrJJIs2fZ6wlFK3IoBzcYD3pvjyC1y/S74EWJEyuEQSxA6p7oLqHL/zEvauiIxW56T7hilIKBsYcMnIAXUb8R2Tsd2MMiHFiy+zz/HSAddJ+C5J3kMxp3VME7A5ZWafeTL4ytPAYahZSQMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=etj+7qco; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="etj+7qco"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=/d
	BrDuY+/9lz/3o82z218CPpZVY4QP5e5ObYzT/IukI=; b=etj+7qcoeZ/7Mgm3YN
	XeoaSZp0ZfwejWyPJBZYHNnh6ww9VTKlW43TZXWb+HuHbZ8hqhMkkibEoJ7KoDDv
	vHk2vtIkbxE9qnr4qBNjk3jcXNeuZkJrUsk7k9ujIKVpc3kSeXJFLJJszYsXxcfJ
	gVtWqIDbVU6nC8Qlfc+HGIKgY=
Received: from czl-pc (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDnU5c7m9Fqw1V+AA--.15038S4;
	Fri, 16 Oct 2026 11:34:22 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v3 2/8] exfat: zero the invalid tail of the straddle block under the folio lock
Date: Fri, 16 Oct 2026 11:33:43 +0800
Message-ID: <20261016033349.3104509-3-chizhiling@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016033349.3104509-1-chizhiling@163.com>
References: <20261016033349.3104509-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDnU5c7m9Fqw1V+AA--.15038S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxtFWrZryxXFyrKFWDtr1DWrg_yoW7WryDp3
	90ka45GFZ7X3W7ur1DGFy5Z3WYkw1ftFWxWryfG3sxZryqyrW2ka4jgFyj9Fy5J3sFyr4j
	gF4vgry8JrnrCr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jztC7UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3B4FomrRmz4mjAAA3R

From: Chi Zhiling <chizhiling@kylinos.cn>

A buffered write that does not fully cover the block containing
valid_size makes iomap read that block from disk, loading the stale
bytes beyond valid_size into the page cache.  exfat_write_iomap_begin()
zeroes them with iomap_truncate_page() before iomap locks the write
folio.

That relied on i_rwsem serializing valid_size against page_mkwrite().
Once exfat_page_mkwrite() stops taking i_rwsem, a fault can advance
valid_size and store data into the tail after exfat_write_iomap_begin()
read valid_size but before iomap_truncate_page() zeroes it, erasing the
stored data.

Moving the zeroing logic from exfat_write_iomap_begin() to ->put_folio
won't solve it, because the folio has already been marked uptodate
before ->put_folio is called.

Do the zeroing from an ->read_folio_range handler instead.  iomap calls
it with the folio locked, so reading valid_size and zeroing
[valid_size, end) is serialized against page_mkwrite() advancing
valid_size for the same folio.  This mirrors the read path, which
already zeroes the invalid tail in exfat_iomap_read_end_io().

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/exfat/file.c  |  5 +++--
 fs/exfat/iomap.c | 54 +++++++++++++++++++++++++++++-------------------
 fs/exfat/iomap.h |  1 +
 3 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index dc57d2c2f0f0..aa0e1e47e3d1 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -829,7 +829,7 @@ static ssize_t exfat_fallback_buffered_write(struct kiocb *iocb,
 	inode_dio_wait(file_inode(iocb->ki_filp));
 
 	written = iomap_file_buffered_write(iocb, from, &exfat_write_iomap_ops,
-			NULL, NULL);
+			&exfat_iomap_write_ops, NULL);
 	if (written < 0)
 		return written;
 
@@ -921,7 +921,8 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		 */
 		inode_dio_wait(inode);
 		ret = iomap_file_buffered_write(iocb, iter,
-				&exfat_write_iomap_ops, NULL, NULL);
+				&exfat_write_iomap_ops, &exfat_iomap_write_ops,
+				NULL);
 	}
 	if (ret != -EIOCBQUEUED && end > i_size_read(inode))
 		exfat_write_failed(inode);
diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index e50ecbfbfbe0..32ca90b61b1a 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -160,27 +160,7 @@ static int exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 static int exfat_write_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
-	struct exfat_inode_info *ei = EXFAT_I(inode);
-	loff_t valid_size = exfat_get_valid_size(ei);
-	loff_t end;
-	int err;
-
-	err = __exfat_iomap_begin(inode, offset, length, flags, iomap, true);
-	if (err || flags & (IOMAP_DIRECT | IOMAP_FAULT) ||
-	    iomap->flags & IOMAP_F_NEW)
-		return err;
-
-	end = iomap->offset + iomap->length;
-	if (end >= valid_size ||
-	    round_up(end, i_blocksize(inode)) <= valid_size)
-		return 0;
-
-	/*
-	 * Zero the invalid bytes from valid_size to the end of the block
-	 * to prevent stale data from being exposed through the page cache.
-	 */
-	return iomap_truncate_page(inode, valid_size, NULL, &exfat_iomap_ops,
-				   NULL, NULL);
+	return __exfat_iomap_begin(inode, offset, length, flags, iomap, true);
 }
 
 static DEFINE_IOMAP_ITER_NEXT(exfat_iomap_next, exfat_iomap_begin);
@@ -252,6 +232,38 @@ const struct iomap_ops exfat_write_iomap_ops = {
 	.iomap_next	= exfat_write_iomap_next,
 };
 
+/*
+ * exfat_iomap_read_folio_range - Read a block range during a buffered write
+ *
+ * A buffered write that does not fully cover the block containing
+ * valid_size makes iomap read that "straddle block" from disk.  The bytes
+ * beyond valid_size in this block are stale and must be zeroed to prevent
+ * them from being exposed through the page cache, like the read path does
+ * in exfat_iomap_read_end_io().
+ */
+static int exfat_iomap_read_folio_range(const struct iomap_iter *iter,
+		struct folio *folio, loff_t pos, size_t len)
+{
+	loff_t valid_size;
+	int ret;
+
+	ret = iomap_bio_read_folio_range_sync(iter, folio, pos, len);
+	if (ret)
+		return ret;
+
+	valid_size = exfat_get_valid_size(EXFAT_I(iter->inode));
+	if (pos <= valid_size && valid_size < pos + len)
+		folio_zero_segment(folio,
+				offset_in_folio(folio, valid_size),
+				offset_in_folio(folio, pos + len));
+
+	return 0;
+}
+
+const struct iomap_write_ops exfat_iomap_write_ops = {
+	.read_folio_range = exfat_iomap_read_folio_range,
+};
+
 /*
  * exfat_writeback_range - Map folio during writeback
  *
diff --git a/fs/exfat/iomap.h b/fs/exfat/iomap.h
index fd8a913f7794..39c93f8cd790 100644
--- a/fs/exfat/iomap.h
+++ b/fs/exfat/iomap.h
@@ -9,6 +9,7 @@
 extern const struct iomap_dio_ops exfat_write_dio_ops;
 extern const struct iomap_ops exfat_iomap_ops;
 extern const struct iomap_ops exfat_write_iomap_ops;
+extern const struct iomap_write_ops exfat_iomap_write_ops;
 extern const struct iomap_writeback_ops exfat_writeback_ops;
 extern const struct iomap_read_ops exfat_iomap_bio_read_ops;
 
-- 
2.53.0

