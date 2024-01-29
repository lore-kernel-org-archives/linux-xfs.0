Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37E1154444
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538954; cv=none; b=kSJtz4Mtrkd5u1NAVUETiYXcaD++3d93zP31c3IBm2iGKslP2Q5BWmLOACx0cy5COH5+V84q+rz0KqN6fmQ9YybMHzO/mAHcH/wp02OP5lpC7GsDhs+3k9p9rpDfH59XqO8cgZhvalHNDto7pXJA/X5onx+TypnJ8LMPS+65U6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538954; c=relaxed/simple;
	bh=iiQ+NQ3Uco7N8zvj0JWM16P0xMJr1KQ8OPDZkFzfEpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oeIOolTxkFLR4CMFV1a5Jg7qJpmA7d4gGrmKanigvgNYnb/djP9FL+mbvDh065Fp9wSBFB5tzJUXB56OHwPUQqPEh98bzEbbPhRTE1dx2Z6h9LF6UC61FjRbZoBJ6cFaMuI0/Br8oH8e0yopcaUYwfx+aQQ/xInq3FWOapw4esU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ndx6oX0I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ndx6oX0I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UUGBMYNgAEuyMsH9DsEDC+bqyUdHBQHIt1xJzsh3ydM=; b=Ndx6oX0IR1JD+I2qz/1pNNkhLa
	1Rzbjm71jFKu/bjnfJYXhabmeWIaWIga7uoXTS9wR5HRnVP4lPTzCN+tRwXZ7CGUsrFvCHtSlh0nk
	sHU8jZcCtrRQO5Ljbbm7KOfQZltyrwKXCT/xo/CWlhLu9DLyRL0rfuA2fTFeV+JKUm7FEEBaV0972
	lnWwfxK15CoEpvMUp9nuGPTxWNsWNbrcsYongV4qhHcTWmAc3fYccTitRt248escxK+suL8GqnB2C
	9JVYMGS0ny5GVKHDbZxaiMgoCN0vyYFAMAngl8vV1VSeiBjTPSaRMtkR4ejo77dMZ72tMhWTceF8C
	LIhA55Mg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjn-0000000D6MX-1iHd;
	Mon, 29 Jan 2024 14:35:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 13/20] xfs: don't allow highmem pages in xfile mappings
Date: Mon, 29 Jan 2024 15:34:55 +0100
Message-Id: <20240129143502.189370-14-hch@lst.de>
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

XFS is generally used on 64-bit, non-highmem platforms and xfile
mappings are accessed all the time.  Reduce our pain by not allowing
any highmem mappings in the xfile page cache and remove all the kmap
calls for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfarray.c |  3 +--
 fs/xfs/scrub/xfile.c   | 21 +++++++++------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 95ac14bceeadd6..d0f98a43b2ba0a 100644
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
index 7e915385ef0011..a669ebbbc02d1d 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -77,6 +77,12 @@ xfile_create(
 	inode = file_inode(xf->file);
 	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
 
+	/*
+	 * We don't want to bother with kmapping data during repair, so don't
+	 * allow highmem pages to back this mapping.
+	 */
+	mapping_set_gfp_mask(inode->i_mapping, GFP_KERNEL);
+
 	trace_xfile_create(xf);
 
 	*xfilep = xf;
@@ -126,7 +132,6 @@ xfile_load(
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
-		void		*p, *kaddr;
 		unsigned int	len;
 
 		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
@@ -153,10 +158,7 @@ xfile_load(
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
@@ -221,14 +223,13 @@ xfile_store(
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

