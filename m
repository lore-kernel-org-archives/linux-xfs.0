Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD53151CEC
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538961; cv=none; b=LL0lch5tx3CYo1pIiG7cH26Kwtpvv3TCLFYuDluG11yoJkuXTzcUrNOKJP2knLbBcScqAaFz6s7gy9JIWLa9E0WNey1VvRZnAPEYjVEq8rKQJNk+BdDo34dCROeyde9j0of9+aMjZR1KjUb12m3waGBjL8oY6wCIMnJOk8GgaFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538961; c=relaxed/simple;
	bh=fR+m1YBy3WCPgLnXbkXP+d1UGggqPNh4vIKf2cUThEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ujaPcavKcRSU5jWet2PQIOHO91w3i1mniEE97UewlltgSzqtoxDqfV/NDKEXA13Hv38Z7DY+ILPTPSK2NZaUcdfH+FvOHW8shA+5e3/XcS2ppRGC6/MJWfq++ZlRdcI6j2hyLZolEMvEZLnggVtKLJoyIyp3TvergYIFAWfBYRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xd4dyVir; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xd4dyVir"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3bl9Vn2yOyKHb24tVNHqKgoHaJ5sWqc0dgEDrV96FhM=; b=xd4dyVir7JMUrm1jb9NZE9GgiO
	tdiEXqjRTLQoFC1KU3rmyQeK8lKBa/w7bbKGzeZuFsG4IApi8pnzm+nFnLvYUdLkPVgK6NWDxp5B+
	YPABBsW/JNftl/Hd6sn9zwpZ6uSgC/Sq3Py+OnYLYEdVdW/OBryAYG3Oc5URqlBe0lTECzwna+bQY
	ejhdJuVVpcMZ93ewqWYBT+Dj97w1Oc9ihWNJ1RJPbaCLMrcWmjE8ZP7ynq98reE4jRWI4LPh0GWmh
	/KUpAOCpF5MJRMsnD261C+fQdiJvWD932ekEZmquQzujHqTLs59C4bFNCGVbGYDIs3yJcuLqTARpa
	fDwI9xng==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjt-0000000D6Os-3AWh;
	Mon, 29 Jan 2024 14:35:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 15/20] xfs: use shmem_get_folio in in xfile_load
Date: Mon, 29 Jan 2024 15:34:57 +0100
Message-Id: <20240129143502.189370-16-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129143502.189370-1-hch@lst.de>
References: <20240129143502.189370-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Switch to using shmem_get_folio in xfile_load instead of using
shmem_read_mapping_page_gfp.  This gets us support for large folios
and also optimized reading from unallocated space, as
shmem_get_folio with SGP_READ won't allocate a page for them just
to zero the content.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c | 61 +++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 2b4819902b4cc3..c524fe9980fea2 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -34,13 +34,6 @@
  * xfiles assume that the caller will handle all required concurrency
  * management; standard vfs locks (freezer and inode) are not taken.  Reads
  * and writes are satisfied directly from the page cache.
- *
- * NOTE: The current shmemfs implementation has a quirk that in-kernel reads
- * of a hole cause a page to be mapped into the file.  If you are going to
- * create a sparse xfile, please be careful about reading from uninitialized
- * parts of the file.  These pages are !Uptodate and will eventually be
- * reclaimed if not written, but in the short term this boosts memory
- * consumption.
  */
 
 /*
@@ -118,10 +111,7 @@ xfile_load(
 	loff_t			pos)
 {
 	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	struct page		*page = NULL;
 	unsigned int		pflags;
-	int			error = 0;
 
 	if (count > MAX_RW_COUNT)
 		return -ENOMEM;
@@ -132,43 +122,44 @@ xfile_load(
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
+		struct folio	*folio;
 		unsigned int	len;
+		unsigned int	offset;
 
-		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
-
-		/*
-		 * In-kernel reads of a shmem file cause it to allocate a page
-		 * if the mapping shows a hole.  Therefore, if we hit ENOMEM
-		 * we can continue by zeroing the caller's buffer.
-		 */
-		page = shmem_read_mapping_page_gfp(mapping, pos >> PAGE_SHIFT,
-				__GFP_NOWARN);
-		if (IS_ERR(page)) {
-			error = PTR_ERR(page);
-			if (error != -ENOMEM) {
-				error = -ENOMEM;
+		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
+				SGP_READ) < 0)
+			break;
+		if (!folio) {
+			/*
+			 * No data stored at this offset, just zero the output
+			 * buffer until the next page boundary.
+			 */
+			len = min_t(ssize_t, count,
+				PAGE_SIZE - offset_in_page(pos));
+			memset(buf, 0, len);
+		} else {
+			if (filemap_check_wb_err(inode->i_mapping, 0)) {
+				folio_unlock(folio);
+				folio_put(folio);
 				break;
 			}
 
-			memset(buf, 0, len);
-			goto advance;
-		}
-
-		/*
-		 * xfile pages must never be mapped into userspace, so
-		 * we skip the dcache flush.
-		 */
-		memcpy(buf, page_address(page) + offset_in_page(pos), len);
-		put_page(page);
+			offset = offset_in_folio(folio, pos);
+			len = min_t(ssize_t, count, folio_size(folio) - offset);
+			memcpy(buf, folio_address(folio) + offset, len);
 
-advance:
+			folio_unlock(folio);
+			folio_put(folio);
+		}
 		count -= len;
 		pos += len;
 		buf += len;
 	}
 	memalloc_nofs_restore(pflags);
 
-	return error;
+	if (count)
+		return -ENOMEM;
+	return 0;
 }
 
 /*
-- 
2.39.2

