Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F88182A2
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ushH/vho"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vsVwWXzNp/uF3VedPHiPLXVFz+eMZwvkb3rlfHln50o=; b=ushH/vhogOKJM3dNcUq2jCv9IU
	q8maRJKSzV35pfdLYBkzK2kXNLfpfTFmJ0/yRj44opJilvDQZzZ7vWgMgeMgr8BqFr2kbeKm8/JuI
	tFGKIjSbiQprPzQvRjdG5OqHdBLexBDwTl25ZGYwXUMyvyMfx6L/W9C4fMccYIM2FySS3GHDwP03I
	Y2V9eFYKnpreihOWfze6ik5bw2PufxUXxUECRo+vlFR6JGaIUAs/nKiaTusk9tMckadbG9/R0IjW1
	GvK1CFewMDD0bL5nII7yyovgXzFVM0kOIAMKmKnVUy+LbR0R2Duw8/zmq3keDLk2Lz0LEO/8VZosm
	rqFGj2Aw==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwpr-00A6zm-2U;
	Wed, 03 Jan 2024 08:42:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 14/15] xfs: use xfile_get_page and xfile_put_page in xfile_obj_store
Date: Wed,  3 Jan 2024 08:41:25 +0000
Message-Id: <20240103084126.513354-15-hch@lst.de>
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

Rewrite xfile_obj_store to use xfile_get_page and xfile_put_page to
access the data in the shmem page cache instead of abusing the
shmem write_begin and write_end aops.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfile.c | 66 ++++++++------------------------------------
 1 file changed, 11 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 3ed7fb82a4497b..987b03df241b02 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -182,74 +182,30 @@ xfile_obj_store(
 	size_t			count,
 	loff_t			pos)
 {
-	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	struct page		*page = NULL;
-	unsigned int		pflags;
-	int			error = 0;
-
 	if (count > MAX_RW_COUNT)
 		return -ENOMEM;
-	if (inode->i_sb->s_maxbytes - pos < count)
+	if (file_inode(xf->file)->i_sb->s_maxbytes - pos < count)
 		return -ENOMEM;
 
 	trace_xfile_obj_store(xf, pos, count);
 
-	pflags = memalloc_nofs_save();
 	while (count > 0) {
-		void		*fsdata = NULL;
-		void		*p, *kaddr;
+		struct page	*page;
 		unsigned int	len;
-		int		ret;
 
 		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
+		page = xfile_get_page(xf, pos, len, XFILE_ALLOC);
+		if (IS_ERR(page))
+			return -ENOMEM;
+		memcpy(page_address(page) + offset_in_page(pos), buf, len);
+		xfile_put_page(xf, page);
 
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
-			break;
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
-			break;
-		}
-
-		if (ret != len) {
-			error = -ENOMEM;
-			break;
-		}
-
-		count -= ret;
-		pos += ret;
-		buf += ret;
+		count -= len;
+		pos += len;
+		buf += len;
 	}
-	memalloc_nofs_restore(pflags);
 
-	return error;
+	return 0;
 }
 
 /* Find the next written area in the xfile data for a given offset. */
-- 
2.39.2

