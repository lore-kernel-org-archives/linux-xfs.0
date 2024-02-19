Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5737B200AC
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324089; cv=none; b=QutUsSRalVT6kpbXA+ycdrH2Fjru8VjMtijWDg0Vvc1xjMyKjlv6dvrnyXbNFp3BdJE4TozDB6P+G7a+VJSGaufsq9+HZgREiBWX07TP8MdxQJRd5usLv83hOQVPt45tMfRraiKFOHgNJGECEYVt6YfXDp0ZHNDU85GM7c3LFm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324089; c=relaxed/simple;
	bh=tSuGjRFoDO7ZR5X9ECIBb5A6GAARIxgkuQ9FF8c8pgI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SsTCasVT7VCIKNdgpHcCELyqb94Iz7pyfqonKcW2iCzWhUZtoOl2dII3pmru74vAZ8UpsGnc4Dqp6Iz0a1DPcBXHlkc5DWi75KyTIDU33fOXvda9MKdDiBwGXKHii3bgCYDlgG1qYtNUf3KOyChrPRTpjUXsR6NhQ5ldwCkW8EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e2uivlW0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e2uivlW0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4yvOV2MFFDBEYH3fUNbndLoOzOA31/axOU+QN+8ByXE=; b=e2uivlW03g1+8GmPK2PN83ONDb
	8r2sIyKWw55ly82HcTFXQ3kifK+iVITq1bZuyY4AGlqCN3lGKOmYotnk+DiQFqbJw8nBSpHTp1akr
	SG0I6RDyp6qQP4VegoxnWaOfTFOLB1wpkazAM5VDuh4Waq6h8Be2PRV4KeVXXKSXrEXj8+6nTiLL6
	AUiomGcGpS8RyBeDMThtqT4Jj7U0srNcyPcchaLWs4pkpDq4OHqzQaraEVnyCTJqZhUajtp8t39M/
	R+77fnfIKA9dsgJ7unLxvnmm7IVQAwscrzyN+5fwMgDmdrTLenopCMcujqXKDOCn07o8A2nse68l8
	zmfUA8rA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx8I-00000009FKl-1Xb6;
	Mon, 19 Feb 2024 06:28:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 17/22] xfs: use shmem_get_folio in in xfile_load
Date: Mon, 19 Feb 2024 07:27:25 +0100
Message-Id: <20240219062730.3031391-18-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
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
index a4480f4020ae16..2229f0b7f9ca49 100644
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

