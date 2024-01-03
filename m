Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDB3182A3
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bkB1qm0Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZYCJ0kG+pWM4oodYCkxfKcpnYZVCJ8j75y4k6ct5MCQ=; b=bkB1qm0YMsFr9mxnSj8PpONLuX
	W8YvxJ9YkL7XqHOWVDelz4YWiOsflj/EprYOJtVD26eZiLqKQTCLcTA2nSLjCR4ljXV+NMfLgJ8h4
	+Gb+shJZiajQsbLyfOTRpIqcYs/BIMmn0wpVlhFqW+3HQTBHeDveywd49wXbzK2gGKgAoGDZMlqpq
	Q0OBOzrlMMIthj1gjoVudMddO4C1DGe1eu9CqqdddfBKj5wZU7ewftJ064MYHyFK8Vcfyei9/c9H9
	svn45AkUgzb7RK6puDFlUk5hw7vMXPX7Hn0s01uzm16XIdlPrScFkBfoU6sGm4x9ZE7Se9spmgQ9h
	/6isd0SA==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwpx-00A72t-0z;
	Wed, 03 Jan 2024 08:42:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 15/15] xfs: use xfile_get_page and xfile_put_page in xfile_obj_load
Date: Wed,  3 Jan 2024 08:41:26 +0000
Message-Id: <20240103084126.513354-16-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103084126.513354-1-hch@lst.de>
References: <20240103084126.513354-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Switch xfile_obj_load to use xfile_get_page and xfile_put_page to access
the shmem page cache.  The former uses shmem_get_folio(..., SGP_READ),
which returns a NULL folio for a hole instead of allocating one to
optimize the case where the caller is reading from a whole and doesn't
want to a zeroed folio to the page cache.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfile.c | 51 +++++++++++---------------------------------
 1 file changed, 12 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 987b03df241b02..3f9e416376d2f7 100644
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
@@ -117,58 +110,38 @@ xfile_obj_load(
 	size_t			count,
 	loff_t			pos)
 {
-	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	struct page		*page = NULL;
-	unsigned int		pflags;
-	int			error = 0;
-
 	if (count > MAX_RW_COUNT)
 		return -ENOMEM;
-	if (inode->i_sb->s_maxbytes - pos < count)
+	if (file_inode(xf->file)->i_sb->s_maxbytes - pos < count)
 		return -ENOMEM;
 
 	trace_xfile_obj_load(xf, pos, count);
 
-	pflags = memalloc_nofs_save();
 	while (count > 0) {
+		struct page	*page;
 		unsigned int	len;
 
 		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
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
-				break;
-			}
-
+		page = xfile_get_page(xf, pos, len, 0);
+		if (IS_ERR(page))
+			return -ENOMEM;
+		if (!page) {
+			/*
+			 * No data stored at this offset, just zero the output
+			 * buffer.
+			 */
 			memset(buf, 0, len);
 			goto advance;
 		}
-
-		/*
-		 * xfile pages must never be mapped into userspace, so
-		 * we skip the dcache flush.
-		 */
 		memcpy(buf, page_address(page) + offset_in_page(pos), len);
-		put_page(page);
-
+		xfile_put_page(xf, page);
 advance:
 		count -= len;
 		pos += len;
 		buf += len;
 	}
-	memalloc_nofs_restore(pflags);
 
-	return error;
+	return 0;
 }
 
 /*
-- 
2.39.2

