Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4761E29CE9;
	Mon, 26 Jan 2026 05:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769406866; cv=none; b=dIxz8M8TlXj/qnofArI6jLx3mpqCeMHMFYEfxYebea0p4EgN30P0cYGt8pEVRx16MgU7+9cND/Mgy6THJVFvZFDYrKXQPCPmypuvSEqokGx8Zd8Mb0OMAezpLhGa8QaXd7YTJGt93HqBJPSiubhHyXjZO8lniZN9ziqSspqMxgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769406866; c=relaxed/simple;
	bh=lj86K+xf7/XSFkbnBTPuDMkTOpkq1xgBRnPM0ejVA+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADcWKqtJ7dWHwLZbOHx4wm+Gzype8LuFZP1oTWxl8y/E91qAaIH1L/sOIBUU0oaLVmrAkAfE1K50dD7+lHyCBj9l8LpVSYHdjgakNyVb/az4Q9UOD2kbHWamGqeKsk19UDs1bJdM2pBk92UeYeGgm77FtMj6UJ7hsiNH2assTtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nzYpFOxS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nzYpFOxS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mmUo+lTNXzuEirBLVORTbi/9YBB+M7V3f33lXtxkVYs=; b=nzYpFOxSXRK4pKWqEEoK2zkzsu
	Man1aRsDh1FHEXhurL9CfC8YOKpAn98TOQBojfqOhULSPi1PIepQQ7DFrLbtBduh1TaRNMmwW05Wq
	fAmBiYrAjCdY4saNc3/rkfu8qZ/l8J32oBBC4B4jXGpOiLKXdcKuWVwQYpsnrtG1a2h96C2deOFYQ
	MF5ikadcBf0zSTNZncF/jho/gZgbWki/mU4cVwhVAviORaxvit69PUge7ko0jrDNY2j9eU+E9aR+n
	sJJ4mtDVYYgBZ26zujFNcudtfGvAZlm9cWSKQb1IU28Xr5zZUcCDhCjr0xwTWf2GF+hUEG2ivYn+Q
	nMpTiiNw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkFYK-0000000BxEq-2D4A;
	Mon, 26 Jan 2026 05:54:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 02/15] block: refactor get_contig_folio_len
Date: Mon, 26 Jan 2026 06:53:33 +0100
Message-ID: <20260126055406.1421026-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126055406.1421026-1-hch@lst.de>
References: <20260126055406.1421026-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move all of the logic to find the contigous length inside a folio into
get_contig_folio_len instead of keeping some of it in the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio.c | 62 +++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ac7703e149c6..d633e80d821f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1172,33 +1172,35 @@ void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
 	bio_set_flag(bio, BIO_CLONED);
 }
 
-static unsigned int get_contig_folio_len(unsigned int *num_pages,
-					 struct page **pages, unsigned int i,
-					 struct folio *folio, size_t left,
+static unsigned int get_contig_folio_len(struct page **pages,
+					 unsigned int *num_pages, size_t left,
 					 size_t offset)
 {
-	size_t bytes = left;
-	size_t contig_sz = min_t(size_t, PAGE_SIZE - offset, bytes);
-	unsigned int j;
+	struct folio *folio = page_folio(pages[0]);
+	size_t contig_sz = min_t(size_t, PAGE_SIZE - offset, left);
+	unsigned int max_pages, i;
+	size_t folio_offset, len;
+
+	folio_offset = PAGE_SIZE * folio_page_idx(folio, pages[0]) + offset;
+	len = min(folio_size(folio) - folio_offset, left);
 
 	/*
-	 * We might COW a single page in the middle of
-	 * a large folio, so we have to check that all
-	 * pages belong to the same folio.
+	 * We might COW a single page in the middle of a large folio, so we have
+	 * to check that all pages belong to the same folio.
 	 */
-	bytes -= contig_sz;
-	for (j = i + 1; j < i + *num_pages; j++) {
-		size_t next = min_t(size_t, PAGE_SIZE, bytes);
+	left -= contig_sz;
+	max_pages = DIV_ROUND_UP(offset + len, PAGE_SIZE);
+	for (i = 1; i < max_pages; i++) {
+		size_t next = min_t(size_t, PAGE_SIZE, left);
 
-		if (page_folio(pages[j]) != folio ||
-		    pages[j] != pages[j - 1] + 1) {
+		if (page_folio(pages[i]) != folio ||
+		    pages[i] != pages[i - 1] + 1)
 			break;
-		}
 		contig_sz += next;
-		bytes -= next;
+		left -= next;
 	}
-	*num_pages = j - i;
 
+	*num_pages = i;
 	return contig_sz;
 }
 
@@ -1222,8 +1224,8 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
 	ssize_t size;
-	unsigned int num_pages, i = 0;
-	size_t offset, folio_offset, left, len;
+	unsigned int i = 0;
+	size_t offset, left, len;
 	int ret = 0;
 
 	/*
@@ -1244,23 +1246,12 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 		return size ? size : -EFAULT;
 
 	nr_pages = DIV_ROUND_UP(offset + size, PAGE_SIZE);
-	for (left = size, i = 0; left > 0; left -= len, i += num_pages) {
-		struct page *page = pages[i];
-		struct folio *folio = page_folio(page);
+	for (left = size; left > 0; left -= len) {
 		unsigned int old_vcnt = bio->bi_vcnt;
+		unsigned int nr_to_add;
 
-		folio_offset = ((size_t)folio_page_idx(folio, page) <<
-			       PAGE_SHIFT) + offset;
-
-		len = min(folio_size(folio) - folio_offset, left);
-
-		num_pages = DIV_ROUND_UP(offset + len, PAGE_SIZE);
-
-		if (num_pages > 1)
-			len = get_contig_folio_len(&num_pages, pages, i,
-						   folio, left, offset);
-
-		if (!bio_add_folio(bio, folio, len, folio_offset)) {
+		len = get_contig_folio_len(&pages[i], &nr_to_add, left, offset);
+		if (!bio_add_page(bio, pages[i], len, offset)) {
 			WARN_ON_ONCE(1);
 			ret = -EINVAL;
 			goto out;
@@ -1275,8 +1266,9 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 			 * single pin per page.
 			 */
 			if (offset && bio->bi_vcnt == old_vcnt)
-				unpin_user_folio(folio, 1);
+				unpin_user_folio(page_folio(pages[i]), 1);
 		}
+		i += nr_to_add;
 		offset = 0;
 	}
 
-- 
2.47.3

