Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32882 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbeGBO6Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:16 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/22] xfs: use iomap for blocksize == PAGE_SIZE readpage and readpages
Date: Mon,  2 Jul 2018 08:57:52 -0600
Message-Id: <20180702145813.22496-2-hch@lst.de>
In-Reply-To: <20180702145813.22496-1-hch@lst.de>
References: <20180702145813.22496-1-hch@lst.de>
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
index 8eb3ba3d4d00..85e1a625d42a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1401,6 +1401,8 @@ xfs_vm_readpage(
 	struct page		*page)
 {
 	trace_xfs_vm_readpage(page->mapping->host, 1);
+	if (i_blocksize(page->mapping->host) == PAGE_SIZE)
+		return iomap_readpage(page, &xfs_iomap_ops);
 	return mpage_readpage(page, xfs_get_blocks);
 }
 
@@ -1412,6 +1414,8 @@ xfs_vm_readpages(
 	unsigned		nr_pages)
 {
 	trace_xfs_vm_readpages(mapping->host, nr_pages);
+	if (i_blocksize(mapping->host) == PAGE_SIZE)
+		return iomap_readpages(mapping, pages, nr_pages, &xfs_iomap_ops);
 	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
 }
 
-- 
2.18.0

