Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbfBOOro (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 09:47:44 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/10] xfs: move stat accounting to xfs_bmapi_convert_delalloc
Date: Fri, 15 Feb 2019 15:47:22 +0100
Message-Id: <20190215144725.8894-8-hch@lst.de>
In-Reply-To: <20190215144725.8894-1-hch@lst.de>
References: <20190215144725.8894-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

This way we can actually count how many bytes got converted and how many
calls we need, unlike in the caller which doesn't have the detailed
view.

Note that this includes a slight change in behavior as the
xs_xstrat_quick is now bumped for every allocation instead of just the
one covering the requested writeback offset, which makes a lot more
sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 3 +++
 fs/xfs/xfs_iomap.c       | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fc4f1d3145c4..4cf83475f0d0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4516,6 +4516,9 @@ xfs_bmapi_convert_delalloc(
 	if (WARN_ON_ONCE(!bma.got.br_startblock && !XFS_IS_REALTIME_INODE(ip)))
 		goto out_finish;
 
+	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
+	XFS_STATS_INC(mp, xs_xstrat_quick);
+
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
 	*imap = bma.got;
 	*seq = READ_ONCE(ifp->if_seq);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 39be741cac5a..15da53b5fb53 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -707,9 +707,6 @@ xfs_iomap_write_allocate(
 	map_start_fsb = imap->br_startoff;
 	map_count_fsb = imap->br_blockcount;
 
-	XFS_STATS_ADD(mp, xs_xstrat_bytes,
-		      XFS_FSB_TO_B(mp, imap->br_blockcount));
-
 	while (true) {
 		/*
 		 * Allocate in a loop because it may take several attempts to
@@ -741,7 +738,6 @@ xfs_iomap_write_allocate(
 		if ((offset_fsb >= imap->br_startoff) &&
 		    (offset_fsb < (imap->br_startoff +
 				   imap->br_blockcount))) {
-			XFS_STATS_INC(mp, xs_xstrat_quick);
 			xfs_trim_extent(imap, map_start_fsb, map_count_fsb);
 			ASSERT(offset_fsb >= imap->br_startoff &&
 			       offset_fsb < imap->br_startoff + imap->br_blockcount);
-- 
2.20.1
