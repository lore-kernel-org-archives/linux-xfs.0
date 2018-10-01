Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54264 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbeJATPV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 15:15:21 -0400
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g6xSK-0004JE-KV
        for linux-xfs@vger.kernel.org; Mon, 01 Oct 2018 12:37:44 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/7] xfs: always allocate blocks as unwritten for file data
Date: Mon,  1 Oct 2018 05:37:36 -0700
Message-Id: <20181001123741.32005-3-hch@lst.de>
In-Reply-To: <20181001123741.32005-1-hch@lst.de>
References: <20181001123741.32005-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS historically had a small race that could lead to exposing
uninitialized data in case of a crash.  If we are filling holes using
buffered I/O we convert the delayed allocation to a real allocation
before writing out the data.  If we crash after the blocks were
allocated, but before the data was written this could lead to reading
uninitialized blocks (or leaked data from a previous allocation that was
reused).  Now that we have the CIL logging extent format changes is
cheap, so we can switch to always allocating blocks as unwritten.
Note that this is not be strictly necessary for writes that append
beyond i_size, but given that we have to log a transaction in that
case anyway we might as well give all block allocations a uniform
treatment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 3 +--
 fs/xfs/xfs_aops.h  | 2 --
 fs/xfs/xfs_iomap.c | 4 ++--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 338b9d9984e0..775cdcfe70c2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -437,8 +437,7 @@ xfs_map_blocks(
 			imap.br_blockcount = cow_fsb - imap.br_startoff;
 
 		if (isnullstartblock(imap.br_startblock)) {
-			/* got a delalloc extent */
-			wpc->io_type = XFS_IO_DELALLOC;
+			wpc->io_type = XFS_IO_UNWRITTEN;
 			goto allocate_blocks;
 		}
 
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 494b4338446e..f0710c54cf68 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -13,7 +13,6 @@ extern struct bio_set xfs_ioend_bioset;
  */
 enum {
 	XFS_IO_HOLE,		/* covers region without any block allocation */
-	XFS_IO_DELALLOC,	/* covers delalloc region */
 	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
 	XFS_IO_OVERWRITE,	/* covers already allocated extent */
 	XFS_IO_COW,		/* covers copy-on-write extent */
@@ -21,7 +20,6 @@ enum {
 
 #define XFS_IO_TYPES \
 	{ XFS_IO_HOLE,			"hole" },	\
-	{ XFS_IO_DELALLOC,		"delalloc" },	\
 	{ XFS_IO_UNWRITTEN,		"unwritten" },	\
 	{ XFS_IO_OVERWRITE,		"overwrite" },	\
 	{ XFS_IO_COW,			"CoW" }
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6320aca39f39..10fc93cebc42 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -662,11 +662,11 @@ xfs_iomap_write_allocate(
 	xfs_trans_t	*tp;
 	int		nimaps;
 	int		error = 0;
-	int		flags = XFS_BMAPI_DELALLOC;
+	int		flags = XFS_BMAPI_DELALLOC | XFS_BMAPI_PREALLOC;
 	int		nres;
 
 	if (whichfork == XFS_COW_FORK)
-		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
+		flags |= XFS_BMAPI_COWFORK;
 
 	/*
 	 * Make sure that the dquots are there.
-- 
2.19.0
