Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1217A7CAF
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 03:47:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDCCC304032
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 01:47:43 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id L5bcz6BCjGFQGjdi (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 01:47:42 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/15] fs: support DAX based iomap zeroing
Date: Mon,  9 May 2016 10:47:07 +0200
Message-Id: <1462783638-4968-5-git-send-email-hch@lst.de>
In-Reply-To: <1462783638-4968-1-git-send-email-hch@lst.de>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
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
Cc: rpeterso@redhat.com, vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org

This avoid needing a separate inefficient get_block based DAX zero_range
implementation in file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index fac9285..f84c6eb 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -24,6 +24,7 @@
 #include <linux/uio.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/dax.h>
 #include "internal.h"
 
 typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
@@ -268,6 +269,15 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
 	return iomap_write_end(inode, pos, bytes, bytes, page);
 }
 
+static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
+		struct iomap *iomap)
+{
+	sector_t sector = iomap->blkno +
+		(((pos & ~(PAGE_SIZE - 1)) - iomap->offset) >> 9);
+
+	return __dax_zero_page_range(iomap->bdev, sector, offset, bytes);
+}
+
 static loff_t
 iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 		void *data, struct iomap *iomap)
@@ -286,7 +296,10 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 		offset = pos & (PAGE_SIZE - 1); /* Within page */
 		bytes = min_t(unsigned, PAGE_SIZE - offset, count);
 
-		status = iomap_zero(inode, pos, offset, bytes, iomap);
+		if (IS_DAX(inode))
+			status = iomap_dax_zero(pos, offset, bytes, iomap);
+		else
+			status = iomap_zero(inode, pos, offset, bytes, iomap);
 		if (status < 0)
 			return status;
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
