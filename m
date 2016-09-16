Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40432 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932447AbcIPL1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Sep 2016 07:27:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/12] iomap: add IOMAP_F_NEW flag
Date: Fri, 16 Sep 2016 13:27:03 +0200
Message-Id: <1474025234-13804-2-git-send-email-hch@lst.de>
In-Reply-To: <1474025234-13804-1-git-send-email-hch@lst.de>
References: <1474025234-13804-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_iomap.c    | 2 ++
 include/linux/iomap.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f96c8ff..5d06a2d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -635,6 +635,7 @@ retry:
 	if (end_fsb != orig_end_fsb)
 		xfs_inode_set_eofblocks_tag(ip);
 
+	iomap->flags = IOMAP_F_NEW;
 	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
 done:
 	if (isnullstartblock(got.br_startblock))
@@ -1000,6 +1001,7 @@ xfs_file_iomap_begin(
 		if (error)
 			return error;
 
+		iomap->flags = IOMAP_F_NEW;
 		trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
 	} else {
 		ASSERT(nimaps);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3d70ece..14d7067 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -22,6 +22,7 @@ struct vm_fault;
  * Flags for iomap mappings:
  */
 #define IOMAP_F_MERGED	0x01	/* contains multiple blocks/extents */
+#define IOMAP_F_NEW	0x02	/* blocks have been newly allocated */
 
 /*
  * Magic value for blkno:
-- 
2.1.4

