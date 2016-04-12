Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6991F7CA6
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 17:27:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2E758304062
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:27:10 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 3MBQxWvmA5Bzqv2a (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:27:08 -0700 (PDT)
Received: from [67.51.76.21] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1aq6m2-0006AZ-4B
	for xfs@oss.sgi.com; Tue, 12 Apr 2016 22:27:06 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] iomap: support DAX based zeroing
Date: Tue, 12 Apr 2016 15:26:48 -0700
Message-Id: <1460500013-28334-2-git-send-email-hch@lst.de>
In-Reply-To: <1460500013-28334-1-git-send-email-hch@lst.de>
References: <1460500013-28334-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This avoid needing a separate inefficient get_block based DAX zero_range
implementation in file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 28a8fcb..a3e7dea 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -24,6 +24,7 @@
 #include <linux/uio.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/dax.h>
 #include "internal.h"
 
 typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
@@ -264,6 +265,15 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 	if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)
 	    	return count;
 
+#ifdef CONFIG_FS_DAX
+	if (IS_DAX(inode)) {
+		status = dax_clear_sectors(iomap->bdev, iomap->blkno, count);
+		if (status)
+			return status;
+		return count;
+	}
+#endif
+
 	do {
 		unsigned offset, bytes;
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
