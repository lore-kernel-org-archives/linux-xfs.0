Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36239 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdBBH5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:57:24 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/19] xfs: clear _XBF_PAGES from buffers when readahead page
Date: Thu,  2 Feb 2017 08:56:10 +0100
Message-Id: <1486022171-8076-19-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 2aa6ba7b5ad3189cc27f14540aa2f57f0ed8df4b upstream.

If we try to allocate memory pages to back an xfs_buf that we're trying
to read, it's possible that we'll be so short on memory that the page
allocation fails.  For a blocking read we'll just wait, but for
readahead we simply dump all the pages we've collected so far.

Unfortunately, after dumping the pages we neglect to clear the
_XBF_PAGES state, which means that the subsequent call to xfs_buf_free
thinks that b_pages still points to pages we own.  It then double-frees
the b_pages pages.

This results in screaming about negative page refcounts from the memory
manager, which xfs oughtn't be triggering.  To reproduce this case,
mount a filesystem where the size of the inodes far outweighs the
availalble memory (a ~500M inode filesystem on a VM with 300MB memory
did the trick here) and run bulkstat in parallel with other memory
eating processes to put a huge load on the system.  The "check summary"
phase of xfs_scrub also works for this purpose.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_buf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b5b9bff..d7a67d7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -423,6 +423,7 @@ xfs_buf_allocate_memory(
 out_free_pages:
 	for (i = 0; i < bp->b_page_count; i++)
 		__free_page(bp->b_pages[i]);
+	bp->b_flags &= ~_XBF_PAGES;
 	return error;
 }
 
-- 
2.1.4

