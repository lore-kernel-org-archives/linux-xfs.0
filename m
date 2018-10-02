Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44496 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbeJCA0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 20:26:39 -0400
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g7OgS-0007dg-GO
        for linux-xfs@vger.kernel.org; Tue, 02 Oct 2018 17:42:08 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] xfs: remove XFS_IO_INVALID
Date: Tue,  2 Oct 2018 10:42:00 -0700
Message-Id: <20181002174207.25275-2-hch@lst.de>
In-Reply-To: <20181002174207.25275-1-hch@lst.de>
References: <20181002174207.25275-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The invalid state isn't any different from a hole, so merge the two
states.  Use the more descriptive hole name, but keep it as the first
value of the enum to catch uninitialized fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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
2.19.0
