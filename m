Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44426 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbeLMWZn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 17:25:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 2/3] iomap: don't search past page end in iomap_is_partially_uptodate
Date: Thu, 13 Dec 2018 16:25:28 -0600
Message-Id: <1544739929-21651-3-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Christoph@sandeen.net, Hellwig@sandeen.net, hch@lst.de

From: Eric Sandeen <sandeen@redhat.com>

iomap_is_partially_uptodate() is intended to check wither blocks within
the selected range of a not-uptodate page are uptodate; if the range we
care about is up to date, it's an optimization.

However, the iomap implementation continues to check all blocks up to
from+count, which is beyond the page, and can even be well beyond the
iop->uptodate bitmap.

I think the worst that will happen is that we may eventually find a zero
bit and return "not partially uptodate" when it would have otherwise
returned true, and skip the optimization.  Still, it's clearly an invalid
memory access that must be fixed.

So: fix this by limiting the search to within the page as is done in the
non-iomap variant, block_is_partially_uptodate().

Zorro noticed thiswhen KASAN went off for 512 byte blocks on a 64k
page system:

 BUG: KASAN: slab-out-of-bounds in iomap_is_partially_uptodate+0x1a0/0x1e0
 Read of size 8 at addr ffff800120c3a318 by task fsstress/22337

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 fs/iomap.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d6bc98a..ce837d9 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -492,16 +492,29 @@ struct iomap_readpage_ctx {
 }
 EXPORT_SYMBOL_GPL(iomap_readpages);
 
+/*
+ * iomap_is_partially_uptodate checks whether blocks within a page are
+ * uptodate or not.
+ *
+ * Returns true if all blocks which correspond to a file portion
+ * we want to read within the page are uptodate.
+ */
 int
 iomap_is_partially_uptodate(struct page *page, unsigned long from,
 		unsigned long count)
 {
 	struct iomap_page *iop = to_iomap_page(page);
 	struct inode *inode = page->mapping->host;
-	unsigned first = from >> inode->i_blkbits;
-	unsigned last = (from + count - 1) >> inode->i_blkbits;
+	unsigned len, first, last;
 	unsigned i;
 
+	/* Limit range to one page */
+	len = min_t(unsigned, PAGE_SIZE - from, count);
+
+	/* First and last blocks in range within page */
+	first = from >> inode->i_blkbits;
+	last = (from + len - 1) >> inode->i_blkbits;
+
 	if (iop) {
 		for (i = first; i <= last; i++)
 			if (!test_bit(i, iop->uptodate))
-- 
1.8.3.1
