Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34892 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752083AbdIQVHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/47] xfs: set firstfsb to NULLFSBLOCK before feeding it to _bmapi_write
Date: Sun, 17 Sep 2017 14:06:37 -0700
Message-Id: <20170917210712.10804-13-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4c1a67bd3606540b9b42caff34a1d5cd94b1cf65 upstream.

We must initialize the firstfsb parameter to _bmapi_write so that it
doesn't incorrectly treat stack garbage as a restriction on which AGs
it can search for free space.

Fixes-coverity-id: 1402025
Fixes-coverity-id: 1415167
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 9 +++++++++
 fs/xfs/xfs_reflink.c     | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b79719a87638..73571fb4dfed 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6639,6 +6639,15 @@ xfs_bmap_finish_one(
 	bmap.br_blockcount = *blockcount;
 	bmap.br_state = state;
 
+	/*
+	 * firstfsb is tied to the transaction lifetime and is used to
+	 * ensure correct AG locking order and schedule work item
+	 * continuations.  XFS_BUI_MAX_FAST_EXTENTS (== 1) restricts us
+	 * to only making one bmap call per transaction, so it should
+	 * be safe to have it as a local variable here.
+	 */
+	firstfsb = NULLFSBLOCK;
+
 	trace_xfs_bmap_deferred(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 29a75ecb2425..350fc64441b1 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -333,7 +333,7 @@ xfs_reflink_convert_cow_extent(
 	struct xfs_defer_ops		*dfops)
 {
 	struct xfs_bmbt_irec		irec = *imap;
-	xfs_fsblock_t			first_block;
+	xfs_fsblock_t			first_block = NULLFSBLOCK;
 	int				nimaps = 1;
 
 	if (imap->br_state == XFS_EXT_NORM)
-- 
2.14.1

