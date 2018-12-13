Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44424 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbeLMWZn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 17:25:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 1/3] iomap: use SECTOR_SIZE instead of 512 in iomap_page
Date: Thu, 13 Dec 2018 16:25:27 -0600
Message-Id: <1544739929-21651-2-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Christoph@sandeen.net, Hellwig@sandeen.net, hch@lst.de

From: Eric Sandeen <sandeen@redhat.com>

because iomap_page_create initializes the uptodate bitmap using the macro,
not the open-coded value.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 include/linux/iomap.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 9a42581..edcdb3a 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h>
 #include <linux/bitmap.h>
+#include <linux/blkdev.h>
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <linux/mm_types.h>
@@ -104,12 +105,13 @@ struct iomap_ops {
 
 /*
  * Structure allocate for each page when block size < PAGE_SIZE to track
- * sub-page uptodate status and I/O completions.
+ * sub-page uptodate status and I/O completions.  Allocate bitmap to
+ * accomodate blocks as small as SECTOR_SIZE
  */
 struct iomap_page {
 	atomic_t		read_count;
 	atomic_t		write_count;
-	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
+	DECLARE_BITMAP(uptodate, PAGE_SIZE / SECTOR_SIZE);
 };
 
 static inline struct iomap_page *to_iomap_page(struct page *page)
-- 
1.8.3.1
