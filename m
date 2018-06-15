Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36576 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756218AbeFONCX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 09:02:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/24] xfs: use iomap for blocksize == PAGE_SIZE readpage and readpages
Date: Fri, 15 Jun 2018 15:01:47 +0200
Message-Id: <20180615130209.1970-3-hch@lst.de>
In-Reply-To: <20180615130209.1970-1-hch@lst.de>
References: <20180615130209.1970-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

For file systems with a block size that equals the page size we never do
partial reads, so we can use the buffer_head-less iomap versions of
readpage and readpages without conflicting with the buffer_head structures
create later in write_begin.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index ca6903726689..dba439ebfe4c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1402,6 +1402,8 @@ xfs_vm_readpage(
 	struct page		*page)
 {
 	trace_xfs_vm_readpage(page->mapping->host, 1);
+	if (i_blocksize(page->mapping->host) == PAGE_SIZE)
+		return iomap_readpage(page, &xfs_iomap_ops);
 	return mpage_readpage(page, xfs_get_blocks);
 }
 
@@ -1413,6 +1415,8 @@ xfs_vm_readpages(
 	unsigned		nr_pages)
 {
 	trace_xfs_vm_readpages(mapping->host, nr_pages);
+	if (i_blocksize(mapping->host) == PAGE_SIZE)
+		return iomap_readpages(mapping, pages, nr_pages, &xfs_iomap_ops);
 	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
 }
 
-- 
2.17.1

