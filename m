Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41282 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbeIRCXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 22:23:08 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g20X1-0005x7-7H
        for linux-xfs@vger.kernel.org; Mon, 17 Sep 2018 20:54:07 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/10] xfs: remove XFS_IO_INVALID
Date: Mon, 17 Sep 2018 22:53:47 +0200
Message-Id: <20180917205354.15401-4-hch@lst.de>
In-Reply-To: <20180917205354.15401-1-hch@lst.de>
References: <20180917205354.15401-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The invalid state isn't any different from a hole, so merge the two
states.  Use the more descriptive hole name, but keep it as the first
value of the enum to catch uninitialized fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c |  4 ++--
 fs/xfs/xfs_aops.h | 14 ++++++--------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 49f5f5896a43..338b9d9984e0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -917,7 +917,7 @@ xfs_vm_writepage(
 	struct writeback_control *wbc)
 {
 	struct xfs_writepage_ctx wpc = {
-		.io_type = XFS_IO_INVALID,
+		.io_type = XFS_IO_HOLE,
 	};
 	int			ret;
 
@@ -933,7 +933,7 @@ xfs_vm_writepages(
 	struct writeback_control *wbc)
 {
 	struct xfs_writepage_ctx wpc = {
-		.io_type = XFS_IO_INVALID,
+		.io_type = XFS_IO_HOLE,
 	};
 	int			ret;
 
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 9af867951a10..494b4338446e 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -12,21 +12,19 @@ extern struct bio_set xfs_ioend_bioset;
  * Types of I/O for bmap clustering and I/O completion tracking.
  */
 enum {
-	XFS_IO_INVALID,		/* initial state */
+	XFS_IO_HOLE,		/* covers region without any block allocation */
 	XFS_IO_DELALLOC,	/* covers delalloc region */
 	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
 	XFS_IO_OVERWRITE,	/* covers already allocated extent */
 	XFS_IO_COW,		/* covers copy-on-write extent */
-	XFS_IO_HOLE,		/* covers region without any block allocation */
 };
 
 #define XFS_IO_TYPES \
-	{ XFS_IO_INVALID,		"invalid" }, \
-	{ XFS_IO_DELALLOC,		"delalloc" }, \
-	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
-	{ XFS_IO_OVERWRITE,		"overwrite" }, \
-	{ XFS_IO_COW,			"CoW" }, \
-	{ XFS_IO_HOLE,			"hole" }
+	{ XFS_IO_HOLE,			"hole" },	\
+	{ XFS_IO_DELALLOC,		"delalloc" },	\
+	{ XFS_IO_UNWRITTEN,		"unwritten" },	\
+	{ XFS_IO_OVERWRITE,		"overwrite" },	\
+	{ XFS_IO_COW,			"CoW" }
 
 /*
  * Structure for buffered I/O completions.
-- 
2.18.0
