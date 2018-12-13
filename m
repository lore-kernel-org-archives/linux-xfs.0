Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44428 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbeLMWZn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 17:25:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 3/3] iomap: optimize iomap_is_partially_uptodate for full page range
Date: Thu, 13 Dec 2018 16:25:29 -0600
Message-Id: <1544739929-21651-4-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Christoph@sandeen.net, Hellwig@sandeen.net, hch@lst.de

From: Eric Sandeen <sandeen@redhat.com>

We only call ->is_partially_uptodate to look for an uptodate range
within a not-uptodate page.

If the range covers all blocks in the page, there is no point to checking
each block individually - if the whole range (i.e. the whole page) were
uptodate, the page would be uptodate as well.  Hence in this case, we
can return early and skip the loop.

This is similar to what is done in block_is_partially_uptodate().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 fs/iomap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index ce837d9..7d7d985 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -515,6 +515,10 @@ struct iomap_readpage_ctx {
 	first = from >> inode->i_blkbits;
 	last = (from + len - 1) >> inode->i_blkbits;
 
+	/* If page wasn't uptodate and range covers all blocks: no partial */
+	if (first == 0 && last == (PAGE_SIZE - 1) >> inode->i_blkbits)
+		return 0;
+
 	if (iop) {
 		for (i = first; i <= last; i++)
 			if (!test_bit(i, iop->uptodate))
-- 
1.8.3.1
