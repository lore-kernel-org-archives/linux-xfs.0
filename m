Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CF5182D5
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gRAjktk4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ik7cnTIZhbznlyWw4+r3mPkuN44dpkXMWni2Aw4AUI0=; b=gRAjktk4Su/8TshZNq2nC3vkT6
	vMTgAMvHufHHwQsPb9PqatFRNAynJv19dDAEEFtS6L91vABcKdHXCvu7gPOgR4THSK6nNcLSLUFqi
	APq90y1U9oa7HazrKFy1RytPoRFNktNsgu2FPVux4Yos/evZbQciJqA81sHQhAeThcv5wXw6s/vs1
	JRFlZobiatRk4kxHQWwXoY0bvTByfBFljw9C87awvr6xGl6RzL4/Mza5LK+fXjTsl93p1Vx5fS+Vb
	5IkCtyVKbnYLVuEPBeomtD4W5cFN5xs2WKWOx2aG+qe3QekojXcshwZwjnLCf7CmdmM360+QolgJU
	819dZ7xw==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwpT-00A6mu-2b;
	Wed, 03 Jan 2024 08:42:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/15] xfs: remove xfarray_sortinfo.page_kaddr
Date: Wed,  3 Jan 2024 08:41:21 +0000
Message-Id: <20240103084126.513354-11-hch@lst.de>
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

Now that xfile pages don't need kmapping, there is no need to cache
the kernel virtual address for them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfarray.c | 22 ++++------------------
 fs/xfs/scrub/xfarray.h |  1 -
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 3a44700037924b..c29a240d4e25f4 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -570,18 +570,7 @@ xfarray_sort_get_page(
 	loff_t			pos,
 	uint64_t		len)
 {
-	int			error;
-
-	error = xfile_get_page(si->array->xfile, pos, len, &si->xfpage);
-	if (error)
-		return error;
-
-	/*
-	 * xfile pages must never be mapped into userspace, so we skip the
-	 * dcache flush when mapping the page.
-	 */
-	si->page_kaddr = page_address(si->xfpage.page);
-	return 0;
+	return xfile_get_page(si->array->xfile, pos, len, &si->xfpage);
 }
 
 /* Release a page we grabbed for sorting records. */
@@ -589,11 +578,8 @@ static inline int
 xfarray_sort_put_page(
 	struct xfarray_sortinfo	*si)
 {
-	if (!si->page_kaddr)
+	if (!xfile_page_cached(&si->xfpage))
 		return 0;
-
-	si->page_kaddr = NULL;
-
 	return xfile_put_page(si->array->xfile, &si->xfpage);
 }
 
@@ -636,7 +622,7 @@ xfarray_pagesort(
 		return error;
 
 	xfarray_sort_bump_heapsorts(si);
-	startp = si->page_kaddr + offset_in_page(lo_pos);
+	startp = page_address(si->xfpage.page) + offset_in_page(lo_pos);
 	sort(startp, hi - lo + 1, si->array->obj_size, si->cmp_fn, NULL);
 
 	xfarray_sort_bump_stores(si);
@@ -883,7 +869,7 @@ xfarray_sort_load_cached(
 			return error;
 	}
 
-	memcpy(ptr, si->page_kaddr + offset_in_page(idx_pos),
+	memcpy(ptr, page_address(si->xfpage.page) + offset_in_page(idx_pos),
 			si->array->obj_size);
 	return 0;
 }
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 62b9c506fdd1b7..6f2862054e194d 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -107,7 +107,6 @@ struct xfarray_sortinfo {
 
 	/* Cache a page here for faster access. */
 	struct xfile_page	xfpage;
-	void			*page_kaddr;
 
 #ifdef DEBUG
 	/* Performance statistics. */
-- 
2.39.2

