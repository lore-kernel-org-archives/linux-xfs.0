Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36144 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730984AbeITU0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 16:26:18 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g30A1-0006fz-IN
        for linux-xfs@vger.kernel.org; Thu, 20 Sep 2018 14:42:29 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] xfs: skip delalloc COW blocks in xfs_reflink_end_cow
Date: Thu, 20 Sep 2018 16:42:17 +0200
Message-Id: <20180920144220.2181-3-hch@lst.de>
In-Reply-To: <20180920144220.2181-1-hch@lst.de>
References: <20180920144220.2181-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The iomap direct I/O code issues a single ->end_io call for the whole
I/O request, and if some of the extents cowered needed a COW operation
it will call xfs_reflink_end_cow over the whole range.

When we do AIO writes we drop the iolock after doing the initial setup,
but before the I/O completion.  Between dropping the lock and completing
the I/O we can have a racing buffered write create new delalloc COW fork
extents in the region covered by the outstanding direct I/O write, and
thus see delalloc COW fork extents in xfs_reflink_end_cow.  As
concurrent writes are fundamentally racy and no guarantees are given we
can simply skip those.

This can be easily reproduced with xfstests generic/208 in always_cow
mode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ac94ace45424..d1758771f21a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -686,14 +686,12 @@ xfs_reflink_end_cow(
 		if (!del.br_blockcount)
 			goto prev_extent;
 
-		ASSERT(!isnullstartblock(got.br_startblock));
-
 		/*
-		 * Don't remap unwritten extents; these are
-		 * speculatively preallocated CoW extents that have been
-		 * allocated but have not yet been involved in a write.
+		 * Only remap real extent that contain data.  With AIO
+		 * speculatively preallocations can leak into the range we
+		 * are called upon, and we need to skip them.
 		 */
-		if (got.br_state == XFS_EXT_UNWRITTEN)
+		if (!xfs_bmap_is_real_extent(&got))
 			goto prev_extent;
 
 		/* Unmap the old blocks in the data fork. */
-- 
2.18.0
