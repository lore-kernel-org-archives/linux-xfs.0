Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754386AbcKUQjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2016 11:39:19 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c8rck-0001Qu-Nu
        for linux-xfs@vger.kernel.org; Mon, 21 Nov 2016 16:39:19 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/14] xfs: remove prev argument to xfs_bmapi_reserve_delalloc
Date: Mon, 21 Nov 2016 17:38:48 +0100
Message-Id: <1479746336-10986-7-git-send-email-hch@lst.de>
In-Reply-To: <1479746336-10986-1-git-send-email-hch@lst.de>
References: <1479746336-10986-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We can easily lookup the previous extent for the cases where we need it,
which saves the callers from looking it up for us later in the series.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 8 ++++++--
 fs/xfs/libxfs/xfs_bmap.h | 3 +--
 fs/xfs/xfs_iomap.c       | 3 +--
 fs/xfs/xfs_reflink.c     | 2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3ed2157..f5de137 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4235,7 +4235,6 @@ xfs_bmapi_reserve_delalloc(
 	xfs_fileoff_t		aoff,
 	xfs_filblks_t		len,
 	struct xfs_bmbt_irec	*got,
-	struct xfs_bmbt_irec	*prev,
 	xfs_extnum_t		*lastx,
 	int			eof)
 {
@@ -4257,7 +4256,12 @@ xfs_bmapi_reserve_delalloc(
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
index 0edf835..52cdfba 100644
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

