Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51058 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756028AbeEaSIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:08:22 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/21] xfs: do not set the page uptodate in xfs_writepage_map
Date: Thu, 31 May 2018 20:07:44 +0200
Message-Id: <20180531180759.21631-7-hch@lst.de>
In-Reply-To: <20180531180759.21631-1-hch@lst.de>
References: <20180531180759.21631-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

We already track the page uptodate status based on the buffer uptodate
status, which is updated whenever reading or zeroing blocks.

This code has been there since commit a ptool commit in 2002, which
claims to:

    "merge" the 2.4 fsx fix for block size < page size to 2.5.  This needed
    major changes to actually fit.

and isn't present in other writepage implementations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5dd09e83c81c..236154d2572f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -850,7 +850,6 @@ xfs_writepage_map(
 	uint64_t		offset;
 	int			error = 0;
 	int			count = 0;
-	int			uptodate = 1;
 	unsigned int		new_type;
 
 	bh = head = page_buffers(page);
@@ -858,8 +857,6 @@ xfs_writepage_map(
 	do {
 		if (offset >= end_offset)
 			break;
-		if (!buffer_uptodate(bh))
-			uptodate = 0;
 
 		/*
 		 * set_page_dirty dirties all buffers in a page, independent
@@ -923,9 +920,6 @@ xfs_writepage_map(
 
 	} while (offset += len, ((bh = bh->b_this_page) != head));
 
-	if (uptodate && bh == head)
-		SetPageUptodate(page);
-
 	ASSERT(wpc->ioend || list_empty(&submit_list));
 
 out:
-- 
2.17.0

