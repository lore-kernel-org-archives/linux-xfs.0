Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758950AbcJQUWj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 16:22:39 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] xfs: fix the AG loop in xfs_alloc_vextent for busy extents
Date: Mon, 17 Oct 2016 22:22:31 +0200
Message-Id: <1476735753-5861-2-git-send-email-hch@lst.de>
In-Reply-To: <1476735753-5861-1-git-send-email-hch@lst.de>
References: <1476735753-5861-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: michaelcallahan@fb.com

If we have too many busy extents, or just enough to make our wanted
allocation impossible we will never move on to another AG in
xfs_alloc_vextent currently.  Change the loop exit condition to keep
looking for an AG if we can't allocate an extent.

For the single AG cases we don't need to change anything as the higher
layers need to handle this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index effb64c..0a04bec 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2753,13 +2753,18 @@ xfs_alloc_vextent(
 				trace_xfs_alloc_vextent_nofix(args);
 				goto error0;
 			}
+
 			/*
-			 * If we get a buffer back then the allocation will fly.
+			 * If we get a buffer back then the allocation will fly,
+			 * unless there are busy extents in the way.
 			 */
 			if (args->agbp) {
-				if ((error = xfs_alloc_ag_vextent(args)))
+				error = xfs_alloc_ag_vextent(args);
+				if (error)
 					goto error0;
-				break;
+				if (args->agbno != NULLAGBLOCK)
+					break;
+				xfs_trans_brelse(args->tp, args->agbp);
 			}
 
 			trace_xfs_alloc_vextent_loopfailed(args);
-- 
2.1.4

