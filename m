Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41320 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbeIRCX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 22:23:26 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g20XJ-0005za-B9
        for linux-xfs@vger.kernel.org; Mon, 17 Sep 2018 20:54:25 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/10] xfs: remove the unused trimmed argument from xfs_reflink_trim_around_shared
Date: Mon, 17 Sep 2018 22:53:53 +0200
Message-Id: <20180917205354.15401-10-hch@lst.de>
In-Reply-To: <20180917205354.15401-1-hch@lst.de>
References: <20180917205354.15401-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c |  4 ++--
 fs/xfs/xfs_iomap.c     |  5 ++---
 fs/xfs/xfs_reflink.c   | 15 +++++----------
 fs/xfs/xfs_reflink.h   |  2 +-
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 418e1e725f3a..3f9d4d2777e4 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -406,10 +406,10 @@ xfs_getbmap_report_one(
 	struct xfs_bmbt_irec	*got)
 {
 	struct kgetbmap		*p = out + bmv->bmv_entries;
-	bool			shared = false, trimmed = false;
+	bool			shared = false;
 	int			error;
 
-	error = xfs_reflink_trim_around_shared(ip, got, &shared, &trimmed);
+	error = xfs_reflink_trim_around_shared(ip, got, &shared);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0d815b00643b..9079196bbc35 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1025,7 +1025,7 @@ xfs_file_iomap_begin(
 	struct xfs_bmbt_irec	imap;
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	int			nimaps = 1, error = 0;
-	bool			shared = false, trimmed = false;
+	bool			shared = false;
 	unsigned		lockmode;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -1061,8 +1061,7 @@ xfs_file_iomap_begin(
 
 	if (flags & IOMAP_REPORT) {
 		/* Trim the mapping to the nearest shared extent boundary. */
-		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
-				&trimmed);
+		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
 		if (error)
 			goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0b41d29d433d..e0111d31140b 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -182,8 +182,7 @@ int
 xfs_reflink_trim_around_shared(
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*irec,
-	bool			*shared,
-	bool			*trimmed)
+	bool			*shared)
 {
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
@@ -209,7 +208,7 @@ xfs_reflink_trim_around_shared(
 	if (error)
 		return error;
 
-	*shared = *trimmed = false;
+	*shared = false;
 	if (fbno == NULLAGBLOCK) {
 		/* No shared blocks at all. */
 		return 0;
@@ -222,8 +221,6 @@ xfs_reflink_trim_around_shared(
 		 */
 		irec->br_blockcount = flen;
 		*shared = true;
-		if (flen != aglen)
-			*trimmed = true;
 		return 0;
 	} else {
 		/*
@@ -233,7 +230,6 @@ xfs_reflink_trim_around_shared(
 		 * start of the shared region.
 		 */
 		irec->br_blockcount = fbno - agbno;
-		*trimmed = true;
 		return 0;
 	}
 }
@@ -255,7 +251,7 @@ xfs_reflink_reserve_cow(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec	got;
 	int			error = 0;
-	bool			eof = false, trimmed;
+	bool			eof = false;
 	struct xfs_iext_cursor	icur;
 	bool			shared;
 
@@ -277,7 +273,7 @@ xfs_reflink_reserve_cow(
 	}
 
 	/* Trim the mapping to the nearest shared extent boundary. */
-	error = xfs_reflink_trim_around_shared(ip, imap, &shared, &trimmed);
+	error = xfs_reflink_trim_around_shared(ip, imap, &shared);
 	if (error)
 		return error;
 
@@ -366,7 +362,6 @@ xfs_find_trim_cow_extent(
 	xfs_filblks_t		count_fsb = imap->br_blockcount;
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	got;
-	bool			trimmed;
 
 	*found = false;
 
@@ -376,7 +371,7 @@ xfs_find_trim_cow_extent(
 	 */
 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got) ||
 	    got.br_startoff > offset_fsb)
-		return xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
+		return xfs_reflink_trim_around_shared(ip, imap, shared);
 
 	*shared = true;
 	if (isnullstartblock(got.br_startblock)) {
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index b77f4079022a..7f47202b5639 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -10,7 +10,7 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, xfs_agblock_t agbno, xfs_extlen_t aglen,
 		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
-		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
+		struct xfs_bmbt_irec *irec, bool *shared);
 
 extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);
-- 
2.18.0
