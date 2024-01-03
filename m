Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D1118631
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AEOGE+RO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2KE1Kh+ZAgxqJkjsL++Zam+feO4h6BGJKXIVU+dtdSs=; b=AEOGE+ROrm/TD6OfiPIJrXkOEK
	HfbsUiSffAfnMAir2ck8taGTe3HUcvNa0iluN4fBMlu4zoU13e4vFL5USf14JbdYS4kA7+UhQNn5X
	rVPDivxjVH4FHdcanzUmnFSJdFBxCyxVg7Leemv3G3Er5j2Ho/Bn2RqsLGLh1JdLVuT9LdDALipvW
	vnCLyUjM85qLbtiEXuLZ2FyaT+PuGqOl1DusLhtk+gLJO2CA7uH0Qc2mPvzxQrrXhaM7SU1h6rojm
	21AtHUTi1DZ9xhxI194g2fME96ND+ZsV/OsP5B09kEGvW9xqm1KPps0Ao9v2E6zv11j6bR1Y1YLx0
	3oISB21g==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwpO-00A6lI-0G;
	Wed, 03 Jan 2024 08:42:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/15] xfs: don't allow highmem pages in xfile mappings
Date: Wed,  3 Jan 2024 08:41:20 +0000
Message-Id: <20240103084126.513354-10-hch@lst.de>
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

XFS is generally used on 64-bit, non-highmem platforms and xfile
mappings are accessed all the time.  Reduce our pain by not allowing
any highmem mappings in the xfile page cache and remove all the kmap
calls for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfarray.c |  3 +--
 fs/xfs/scrub/xfile.c   | 21 +++++++++------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index f0f532c10a5acc..3a44700037924b 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -580,7 +580,7 @@ xfarray_sort_get_page(
 	 * xfile pages must never be mapped into userspace, so we skip the
 	 * dcache flush when mapping the page.
 	 */
-	si->page_kaddr = kmap_local_page(si->xfpage.page);
+	si->page_kaddr = page_address(si->xfpage.page);
 	return 0;
 }
 
@@ -592,7 +592,6 @@ xfarray_sort_put_page(
 	if (!si->page_kaddr)
 		return 0;
 
-	kunmap_local(si->page_kaddr);
 	si->page_kaddr = NULL;
 
 	return xfile_put_page(si->array->xfile, &si->xfpage);
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index e872f4f0263f59..afbd205289e9b0 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -77,6 +77,12 @@ xfile_create(
 	inode = file_inode(xf->file);
 	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
 
+	/*
+	 * We don't want to bother with kmapping data during repair, so don't
+	 * allow highmem pages to back this mapping.
+	 */
+	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+
 	trace_xfile_create(xf);
 
 	*xfilep = xf;
@@ -126,7 +132,6 @@ xfile_obj_load(
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
-		void		*p, *kaddr;
 		unsigned int	len;
 
 		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
@@ -153,10 +158,7 @@ xfile_obj_load(
 		 * xfile pages must never be mapped into userspace, so
 		 * we skip the dcache flush.
 		 */
-		kaddr = kmap_local_page(page);
-		p = kaddr + offset_in_page(pos);
-		memcpy(buf, p, len);
-		kunmap_local(kaddr);
+		memcpy(buf, page_address(page) + offset_in_page(pos), len);
 		put_page(page);
 
 advance:
@@ -221,14 +223,13 @@ xfile_obj_store(
 		 * the dcache flush.  If the page is not uptodate, zero it
 		 * before writing data.
 		 */
-		kaddr = kmap_local_page(page);
+		kaddr = page_address(page);
 		if (!PageUptodate(page)) {
 			memset(kaddr, 0, PAGE_SIZE);
 			SetPageUptodate(page);
 		}
 		p = kaddr + offset_in_page(pos);
 		memcpy(p, buf, len);
-		kunmap_local(kaddr);
 
 		ret = aops->write_end(NULL, mapping, pos, len, len, page,
 				fsdata);
@@ -314,11 +315,7 @@ xfile_get_page(
 	 * to the caller and make sure the backing store will hold on to them.
 	 */
 	if (!PageUptodate(page)) {
-		void	*kaddr;
-
-		kaddr = kmap_local_page(page);
-		memset(kaddr, 0, PAGE_SIZE);
-		kunmap_local(kaddr);
+		memset(page_address(page), 0, PAGE_SIZE);
 		SetPageUptodate(page);
 	}
 
-- 
2.39.2

