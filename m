Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751326AbeE3KBB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 06:01:01 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/18] xfs: simplify xfs_map_blocks by using xfs_iext_lookup_extent directly
Date: Wed, 30 May 2018 12:00:05 +0200
Message-Id: <20180530100013.31358-11-hch@lst.de>
In-Reply-To: <20180530100013.31358-1-hch@lst.de>
References: <20180530100013.31358-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

xfs_bmapi_read adds zero value in xfs_map_blocks.  Replace it with a
direct call to the low-level extent lookup function.

Note that we now always pass a 0 length to the trace points as we ask
for an unspecified len.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 587493e9c8a1..cef2bc3cf98b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -387,7 +387,6 @@ xfs_map_blocks(
 	int			whichfork = XFS_DATA_FORK;
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
-	int			nimaps = 1;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -429,24 +428,16 @@ xfs_map_blocks(
 		goto allocate_blocks;
 	}
 
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				imap, &nimaps, XFS_BMAPI_ENTIRE);
+	if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, imap))
+		imap->br_startoff = end_fsb;	/* fake a hole past EOF */
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	if (error)
-		return error;
 
-	if (!nimaps) {
-		/*
-		 * Lookup returns no match? Beyond eof? regardless,
-		 * return it as a hole so we don't write it
-		 */
+	if (imap->br_startoff > offset_fsb) {
+		/* landed in a hole or beyond EOF */
+		imap->br_blockcount = imap->br_startoff - offset_fsb;
 		imap->br_startoff = offset_fsb;
-		imap->br_blockcount = end_fsb - offset_fsb;
 		imap->br_startblock = HOLESTARTBLOCK;
 		*type = XFS_IO_HOLE;
-	} else if (imap->br_startblock == HOLESTARTBLOCK) {
-		/* landed in a hole */
-		*type = XFS_IO_HOLE;
 	} else {
 		if (isnullstartblock(imap->br_startblock)) {
 			/* got a delalloc extent */
-- 
2.17.0

