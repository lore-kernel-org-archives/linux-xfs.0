Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751793AbdINJuz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Sep 2017 05:50:55 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 2/4] iomap: Add IOMAP_F_DATA_INLINE flag
Date: Thu, 14 Sep 2017 11:50:45 +0200
Message-Id: <20170914095047.23935-3-agruenba@redhat.com>
In-Reply-To: <20170914095047.23935-1-agruenba@redhat.com>
References: <20170914095047.23935-1-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>

Add a new IOMAP_F_DATA_INLINE flag to indicate that a mapping is in a
disk area that contains data as well as metadata.  In iomap_fiemap, map
this flag to FIEMAP_EXTENT_DATA_INLINE.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/iomap.c            | 2 ++
 include/linux/iomap.h | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 622c731c57a0..20b303ac109b 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -510,6 +510,8 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
 		flags |= FIEMAP_EXTENT_MERGED;
 	if (iomap->flags & IOMAP_F_SHARED)
 		flags |= FIEMAP_EXTENT_SHARED;
+	if (iomap->flags & IOMAP_F_DATA_INLINE)
+		flags |= FIEMAP_EXTENT_DATA_INLINE;
 
 	return fiemap_fill_next_extent(fi, iomap->offset,
 			iomap->addr != IOMAP_NULL_ADDR ? iomap->addr : 0,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 7b8a615fa021..2b0790dbd6ea 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -26,8 +26,9 @@ struct vm_fault;
 /*
  * Flags that only need to be reported for IOMAP_REPORT requests:
  */
-#define IOMAP_F_MERGED	0x10	/* contains multiple blocks/extents */
-#define IOMAP_F_SHARED	0x20	/* block shared with another file */
+#define IOMAP_F_MERGED		0x10	/* contains multiple blocks/extents */
+#define IOMAP_F_SHARED		0x20	/* block shared with another file */
+#define IOMAP_F_DATA_INLINE	0x40	/* data inline in the inode */
 
 /*
  * Magic value for addr:
-- 
2.13.3

