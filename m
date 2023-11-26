Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BJjXnxsM"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F2BEE;
	Sun, 26 Nov 2023 04:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=53uG9fPRAx/CyHUV194Rw5RYICApajAWSzsMOx+ZM2A=; b=BJjXnxsMdWG0tdS31+zIu9J4dH
	WupXdwT5ANsdMjODZuDvIuOBoN4eyJ+AXyMrJW8hWgtpHPLhyZ6Zi6GbcjiJnmt++WTU1+tMek2ci
	njxJ5rrJGXkipRyE3GivFb5+9sZ/Vu7W4irD3Nw8ndzVO2IJWrK0BkJLaZp95Z0T2xr7rwa8Y7yMZ
	/nQA6EXjKVSlPzMesv3FOyROXcMulVTPhtAMumh/bCG27i+kdQJoUYqfWaxzaWnNwOfhtrASApCdN
	z5Cvq9kH2+CfZgw9O0zN2d9BNZgNqcCmoAmJZHVMhuat6IpYI8RyUHFSc7POzqfGSx+qTkraIkdSO
	81P/EG/w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r7EYK-00BCTI-3B;
	Sun, 26 Nov 2023 12:48:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 11/13] iomap: factor out a iomap_writepage_map_block helper
Date: Sun, 26 Nov 2023 13:47:18 +0100
Message-Id: <20231126124720.1249310-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231126124720.1249310-1-hch@lst.de>
References: <20231126124720.1249310-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split the loop body that calls into the file system to map a block and
add it to the ioend into a separate helper to prefer for refactoring of
the surrounding code.

Note that this was the only place in iomap_writepage_map that could
return an error, so include the call to ->discard_folio into the new
helper as that will help to avoid code duplication in the future.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 72 +++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e1d5076251702d..9f223820f60d22 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1723,6 +1723,45 @@ static void iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 	wbc_account_cgroup_owner(wbc, &folio->page, len);
 }
 
+static int iomap_writepage_map_blocks(struct iomap_writepage_ctx *wpc,
+		struct writeback_control *wbc, struct folio *folio,
+		struct inode *inode, u64 pos, unsigned *count,
+		struct list_head *submit_list)
+{
+	int error;
+
+	error = wpc->ops->map_blocks(wpc, inode, pos);
+	if (error)
+		goto fail;
+	trace_iomap_writepage_map(inode, &wpc->iomap);
+
+	switch (wpc->iomap.type) {
+	case IOMAP_INLINE:
+		WARN_ON_ONCE(1);
+		error = -EIO;
+		break;
+	case IOMAP_HOLE:
+		break;
+	default:
+		iomap_add_to_ioend(wpc, wbc, folio, inode, pos, submit_list);
+		(*count)++;
+	}
+
+fail:
+	/*
+	 * We cannot cancel the ioend directly here on error.  We may have
+	 * already set other pages under writeback and hence we have to run I/O
+	 * completion to mark the error state of the pages under writeback
+	 * appropriately.
+	 *
+	 * Just let the file system know what portion of the folio failed to
+	 * map.
+	 */
+	if (error && wpc->ops->discard_folio)
+		wpc->ops->discard_folio(folio, pos);
+	return error;
+}
+
 /*
  * Check interaction of the folio with the file end.
  *
@@ -1807,7 +1846,8 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	unsigned nblocks = i_blocks_per_folio(inode, folio);
 	u64 pos = folio_pos(folio);
 	u64 end_pos = pos + folio_size(folio);
-	int error = 0, count = 0, i;
+	unsigned count = 0;
+	int error = 0, i;
 	LIST_HEAD(submit_list);
 
 	trace_iomap_writepage(inode, pos, folio_size(folio));
@@ -1833,19 +1873,10 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	for (i = 0; i < nblocks && pos < end_pos; i++, pos += len) {
 		if (ifs && !ifs_block_is_dirty(folio, ifs, i))
 			continue;
-
-		error = wpc->ops->map_blocks(wpc, inode, pos);
+		error = iomap_writepage_map_blocks(wpc, wbc, folio, inode, pos,
+				&count, &submit_list);
 		if (error)
 			break;
-		trace_iomap_writepage_map(inode, &wpc->iomap);
-		if (WARN_ON_ONCE(wpc->iomap.type == IOMAP_INLINE)) {
-			error = -EIO;
-			break;
-		}
-		if (wpc->iomap.type == IOMAP_HOLE)
-			continue;
-		iomap_add_to_ioend(wpc, wbc, folio, inode, pos, &submit_list);
-		count++;
 	}
 	if (count)
 		wpc->nr_folios++;
@@ -1855,23 +1886,6 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	WARN_ON_ONCE(folio_test_writeback(folio));
 	WARN_ON_ONCE(folio_test_dirty(folio));
 
-	/*
-	 * We cannot cancel the ioend directly here on error.  We may have
-	 * already set other pages under writeback and hence we have to run I/O
-	 * completion to mark the error state of the pages under writeback
-	 * appropriately.
-	 */
-	if (unlikely(error)) {
-		/*
-		 * Let the filesystem know what portion of the current page
-		 * failed to map. If the page hasn't been added to ioend, it
-		 * won't be affected by I/O completion and we must unlock it
-		 * now.
-		 */
-		if (wpc->ops->discard_folio)
-			wpc->ops->discard_folio(folio, pos);
-	}
-
 	/*
 	 * We can have dirty bits set past end of file in page_mkwrite path
 	 * while mapping the last partial folio. Hence it's better to clear
-- 
2.39.2

