Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D3B177CBC
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 16:29:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7380304043
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 14:29:36 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id A5LA0ZPVuOAs60KY (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 14:29:35 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/14] iomap: support DAX based zeroing
Date: Tue,  3 May 2016 23:29:02 +0200
Message-Id: <1462310947-16132-10-git-send-email-hch@lst.de>
In-Reply-To: <1462310947-16132-1-git-send-email-hch@lst.de>
References: <1462310947-16132-1-git-send-email-hch@lst.de>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org

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
