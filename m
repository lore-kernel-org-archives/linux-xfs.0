Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935331AbdAIPjl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:41 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/32] xfs: track preallocation separately in xfs_bmapi_reserve_delalloc()
Date: Mon,  9 Jan 2017 16:38:43 +0100
Message-Id: <1483976343-661-13-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Brian Foster <bfoster@redhat.com>

commit 974ae922efd93b07b6cdf989ae959883f6f05fd8 upstream.

Speculative preallocation is currently processed entirely by the callers
of xfs_bmapi_reserve_delalloc(). The caller determines how much
preallocation to include, adjusts the extent length and passes down the
resulting request.

While this works fine for post-eof speculative preallocation, it is not
as reliable for COW fork preallocation. COW fork preallocation is
implemented via the cowextszhint, which aligns the start offset as well
as the length of the extent. Further, it is difficult for the caller to
accurately identify when preallocation occurs because the returned
extent could have been merged with neighboring extents in the fork.

To simplify this situation and facilitate further COW fork preallocation
enhancements, update xfs_bmapi_reserve_delalloc() to take a separate
preallocation parameter to incorporate into the allocation request. The
preallocation blocks value is tacked onto the end of the request and
adjusted to accommodate neighboring extents and extent size limits.
Since xfs_bmapi_reserve_delalloc() now knows precisely how much
preallocation was included in the allocation, it can also tag the inodes
appropriately to support preallocation reclaim.

Note that xfs_bmapi_reserve_delalloc() callers are not yet updated to
use the preallocation mechanism. This patch should not change behavior
outside of correctly tagging reflink inodes when start offset
preallocation occurs (which the caller does not handle correctly).

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 23 +++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.h |  2 +-
 fs/xfs/xfs_iomap.c       |  2 +-
 fs/xfs/xfs_reflink.c     |  2 +-
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 09b5d4f..aab523a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -50,6 +50,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_icache.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -4247,8 +4248,9 @@ int
 xfs_bmapi_reserve_delalloc(
 	struct xfs_inode	*ip,
 	int			whichfork,
-	xfs_fileoff_t		aoff,
+	xfs_fileoff_t		off,
 	xfs_filblks_t		len,
+	xfs_filblks_t		prealloc,
 	struct xfs_bmbt_irec	*got,
 	xfs_extnum_t		*lastx,
 	int			eof)
@@ -4260,10 +4262,17 @@ xfs_bmapi_reserve_delalloc(
 	char			rt = XFS_IS_REALTIME_INODE(ip);
 	xfs_extlen_t		extsz;
 	int			error;
+	xfs_fileoff_t		aoff = off;
 
-	alen = XFS_FILBLKS_MIN(len, MAXEXTLEN);
+	/*
+	 * Cap the alloc length. Keep track of prealloc so we know whether to
+	 * tag the inode before we return.
+	 */
+	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
+	if (prealloc && alen >= len)
+		prealloc = alen - len;
 
 	/* Figure out the extent size, adjust alen */
 	if (whichfork == XFS_COW_FORK)
@@ -4329,6 +4338,16 @@ xfs_bmapi_reserve_delalloc(
 	 */
 	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), got);
 
+	/*
+	 * Tag the inode if blocks were preallocated. Note that COW fork
+	 * preallocation can occur at the start or end of the extent, even when
+	 * prealloc == 0, so we must also check the aligned offset and length.
+	 */
+	if (whichfork == XFS_DATA_FORK && prealloc)
+		xfs_inode_set_eofblocks_tag(ip);
+	if (whichfork == XFS_COW_FORK && (prealloc || aoff < off || alen > len))
+		xfs_inode_set_cowblocks_tag(ip);
+
 	ASSERT(got->br_startoff <= aoff);
 	ASSERT(got->br_startoff + got->br_blockcount >= aoff + alen);
 	ASSERT(isnullstartblock(got->br_startblock));
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e3c2b5a..d6d175a 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -242,7 +242,7 @@ struct xfs_bmbt_rec_host *
 		int fork, int *eofp, xfs_extnum_t *lastxp,
 		struct xfs_bmbt_irec *gotp, struct xfs_bmbt_irec *prevp);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
-		xfs_fileoff_t aoff, xfs_filblks_t len,
+		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof);
 
 enum xfs_bmap_intent_type {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 59ffcac..cc25892 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -622,7 +622,7 @@ xfs_file_iomap_begin_delay(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, &got, &idx, eof);
+			end_fsb - offset_fsb, 0, &got, &idx, eof);
 	switch (error) {
 	case 0:
 		break;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ae17b81..e65cd0a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -293,7 +293,7 @@ xfs_reflink_reserve_cow(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
-			end_fsb - imap->br_startoff, &got, &idx, eof);
+			end_fsb - imap->br_startoff, 0, &got, &idx, eof);
 	switch (error) {
 	case 0:
 		break;
-- 
2.1.4

