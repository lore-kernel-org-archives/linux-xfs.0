Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934508AbdAIPji (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:38 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/32] xfs: remove prev argument to xfs_bmapi_reserve_delalloc
Date: Mon,  9 Jan 2017 16:38:42 +0100
Message-Id: <1483976343-661-12-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

commit 65c5f419788d623a0410eca1866134f5e4628594 upstream.

We can easily lookup the previous extent for the cases where we need it,
which saves the callers from looking it up for us later in the series.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 8 ++++++--
 fs/xfs/libxfs/xfs_bmap.h | 3 +--
 fs/xfs/xfs_iomap.c       | 3 +--
 fs/xfs/xfs_reflink.c     | 2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 00188f5..09b5d4f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4250,7 +4250,6 @@ xfs_bmapi_reserve_delalloc(
 	xfs_fileoff_t		aoff,
 	xfs_filblks_t		len,
 	struct xfs_bmbt_irec	*got,
-	struct xfs_bmbt_irec	*prev,
 	xfs_extnum_t		*lastx,
 	int			eof)
 {
@@ -4272,7 +4271,12 @@ xfs_bmapi_reserve_delalloc(
 	else
 		extsz = xfs_get_extsz_hint(ip);
 	if (extsz) {
-		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
+		struct xfs_bmbt_irec	prev;
+
+		if (!xfs_iext_get_extent(ifp, *lastx - 1, &prev))
+			prev.br_startoff = NULLFILEOFF;
+
+		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, rt, eof,
 					       1, 0, &aoff, &alen);
 		ASSERT(!error);
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 7cae6ec..e3c2b5a 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -243,8 +243,7 @@ struct xfs_bmbt_rec_host *
 		struct xfs_bmbt_irec *gotp, struct xfs_bmbt_irec *prevp);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t aoff, xfs_filblks_t len,
-		struct xfs_bmbt_irec *got, struct xfs_bmbt_irec *prev,
-		xfs_extnum_t *lastx, int eof);
+		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 436e109..59ffcac 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -622,8 +622,7 @@ xfs_file_iomap_begin_delay(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, &got,
-			&prev, &idx, eof);
+			end_fsb - offset_fsb, &got, &idx, eof);
 	switch (error) {
 	case 0:
 		break;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4d99100..ae17b81 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -293,7 +293,7 @@ xfs_reflink_reserve_cow(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
-			end_fsb - imap->br_startoff, &got, &prev, &idx, eof);
+			end_fsb - imap->br_startoff, &got, &idx, eof);
 	switch (error) {
 	case 0:
 		break;
-- 
2.1.4

