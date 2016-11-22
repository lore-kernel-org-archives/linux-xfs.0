Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932797AbcKVNBW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Nov 2016 08:01:22 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23AF17FD44
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2016 13:01:22 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uAMD13w4009306
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2016 08:01:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/3] xfs: track preallocation separately in xfs_bmapi_reserve_delalloc()
Date: Tue, 22 Nov 2016 08:01:00 -0500
Message-Id: <1479819662-64416-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1479819662-64416-1-git-send-email-bfoster@redhat.com>
References: <1479819662-64416-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

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
---
 fs/xfs/libxfs/xfs_bmap.c | 23 +++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.h |  2 +-
 fs/xfs/xfs_iomap.c       |  2 +-
 fs/xfs/xfs_reflink.c     |  2 +-
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3ab68db..d17fe6a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -49,6 +49,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
+#include "xfs_icache.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -4141,8 +4142,9 @@ int
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
@@ -4154,10 +4156,17 @@ xfs_bmapi_reserve_delalloc(
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
@@ -4223,6 +4232,16 @@ xfs_bmapi_reserve_delalloc(
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
index ffed1f9..cecd094 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -238,7 +238,7 @@ int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		int num_exts);
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
-		xfs_fileoff_t aoff, xfs_filblks_t len,
+		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof);
 
 enum xfs_bmap_intent_type {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 05eedfb..4062727 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -620,7 +620,7 @@ xfs_file_iomap_begin_delay(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, &got, &idx, eof);
+			end_fsb - offset_fsb, 0, &got, &idx, eof);
 	switch (error) {
 	case 0:
 		break;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4b024e7..812c632 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -295,7 +295,7 @@ xfs_reflink_reserve_cow(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
-			end_fsb - imap->br_startoff, &got, &idx, eof);
+			end_fsb - imap->br_startoff, 0, &got, &idx, eof);
 	switch (error) {
 	case 0:
 		break;
-- 
2.7.4

