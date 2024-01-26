Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1A51B811
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275812; cv=none; b=KrKuOlC7RD/dXOyFFxa0Mdmp33Qak5CxxrBOL/iX9bppm+cI0q1qBS1gDJI+bqIwFViX/4M+jPf0LMyaPwxGaOSJqguHhnaWQt9ldpkb6RsnR/njOwr5scjoWgulimDI2kw7E5+u5YHfhv84ELcJXd2IGD3HkVkXrsdO0/GrDn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275812; c=relaxed/simple;
	bh=Nj9Kn/c1tFS/RDO7I27aysyrUEw4p36XKlnv4L07ff4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QVt0uaWyWhF/6PQVX6BCHxgrsM5x7BkFr7uSpGlbJOzj4FqZ7YqYCjQjxIpsOR/CdHAtt9TsZdkAYE+JhUPAgvYdSEoZmXSxYX+x+Nh9LbbUbVE46LQ9c8v8DJnFL2h92UCWu4iM+XgYuoltJIIf55FudLgv3UTs/VjqmLLy7r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Uon45Ynj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uon45Ynj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PN3djP3juVhL/KNUknZcP0OIUVZdWEXnGZgCPDCtRNQ=; b=Uon45YnjXTuIOePuwZJX0gy+k5
	KIaB3xbNpNu4+wx4OaU1k7IpfEOKnpm6VpR0Eu/ao9enWMc9/Kstx1dr14gx1XLhmrg4BApGb5blJ
	xsVMXblOjihwDPnPlAFbh9GlfRVMwVC1ikMaysmGRdwwdV5Q+7yFDf7yHnDJTjm4qxnWgXOB5yZek
	kdVj/WJSQCHa6EgUtd1cSQRp+34iSJMZCoqztZ1AJTmgBVcxPTA6vqX+fJMCHJ4wvIwcTiqv4mk2/
	0otUImdgTldDWzM/7f7qVBuLhO46e6+yeT2noDysOOoFvuwWttwM/yeeRU6/AGUj/C6I9auF/tYtC
	5qx2wKOQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMHY-00000004Cr7-38VI;
	Fri, 26 Jan 2024 13:30:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 14/21] xfs: use shmem_get_folio in xfile_obj_store
Date: Fri, 26 Jan 2024 14:28:56 +0100
Message-Id: <20240126132903.2700077-15-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Switch to using shmem_get_folio and manually dirtying the page instead
of abusing aops->write_begin and aops->write_end in xfile_get_page.

This simplifies the code by not doing indirect calls of not actually
exported interfaces that don't really fit the use case very well, and
happens to get us large folio support for free.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c | 75 +++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 623bbde91ae3fe..c71c853c9ffdd7 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -183,11 +183,7 @@ xfile_store(
 	loff_t			pos)
 {
 	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	struct page		*page = NULL;
 	unsigned int		pflags;
-	int			error = 0;
 
 	if (count > MAX_RW_COUNT)
 		return -ENOMEM;
@@ -196,60 +192,47 @@ xfile_store(
 
 	trace_xfile_store(xf, pos, count);
 
+	/*
+	 * Increase the file size first so that shmem_get_folio(..., SGP_CACHE),
+	 * actually allocates a folio instead of erroring out.
+	 */
+	if (pos + count > i_size_read(inode))
+		i_size_write(inode, pos + count);
+
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
-		void		*fsdata = NULL;
-		void		*p, *kaddr;
+		struct folio	*folio;
 		unsigned int	len;
-		int		ret;
+		unsigned int	offset;
 
-		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
-
-		/*
-		 * We call write_begin directly here to avoid all the freezer
-		 * protection lock-taking that happens in the normal path.
-		 * shmem doesn't support fs freeze, but lockdep doesn't know
-		 * that and will trip over that.
-		 */
-		error = aops->write_begin(NULL, mapping, pos, len, &page,
-				&fsdata);
-		if (error) {
-			error = -ENOMEM;
+		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
+				SGP_CACHE) < 0)
 			break;
-		}
-
-		/*
-		 * xfile pages must never be mapped into userspace, so we skip
-		 * the dcache flush.  If the page is not uptodate, zero it
-		 * before writing data.
-		 */
-		kaddr = page_address(page);
-		if (!PageUptodate(page)) {
-			memset(kaddr, 0, PAGE_SIZE);
-			SetPageUptodate(page);
-		}
-		p = kaddr + offset_in_page(pos);
-		memcpy(p, buf, len);
-
-		ret = aops->write_end(NULL, mapping, pos, len, len, page,
-				fsdata);
-		if (ret < 0) {
-			error = -ENOMEM;
+		if (folio_test_hwpoison(folio) ||
+		    (folio_test_large(folio) &&
+		     folio_test_has_hwpoisoned(folio))) {
+			folio_unlock(folio);
+			folio_put(folio);
 			break;
 		}
 
-		if (ret != len) {
-			error = -ENOMEM;
-			break;
-		}
+		offset = offset_in_folio(folio, pos);
+		len = min_t(ssize_t, count, folio_size(folio) - offset);
+		memcpy(folio_address(folio) + offset, buf, len);
+
+		folio_mark_dirty(folio);
+		folio_unlock(folio);
+		folio_put(folio);
 
-		count -= ret;
-		pos += ret;
-		buf += ret;
+		count -= len;
+		pos += len;
+		buf += len;
 	}
 	memalloc_nofs_restore(pflags);
 
-	return error;
+	if (count)
+		return -ENOMEM;
+	return 0;
 }
 
 /* Find the next written area in the xfile data for a given offset. */
-- 
2.39.2

