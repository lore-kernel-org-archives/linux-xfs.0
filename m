Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 605117CA4
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:53:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16C59304066
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:53:30 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id MZM3P0gpR2rWH8Ax (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:53:27 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] fs: move struct iomap from exportfs.h to a separate header
Date: Tue, 12 Apr 2016 13:52:55 -0700
Message-Id: <1460494382-14547-2-git-send-email-hch@lst.de>
In-Reply-To: <1460494382-14547-1-git-send-email-hch@lst.de>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/blocklayout.c    |  1 +
 fs/nfsd/blocklayoutxdr.c |  1 +
 fs/xfs/xfs_pnfs.c        |  1 +
 include/linux/exportfs.h | 16 +---------------
 include/linux/iomap.h    | 21 +++++++++++++++++++++
 5 files changed, 25 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/iomap.h

diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index e55b524..4df16ae 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2014-2016 Christoph Hellwig.
  */
 #include <linux/exportfs.h>
+#include <linux/iomap.h>
 #include <linux/genhd.h>
 #include <linux/slab.h>
 #include <linux/pr.h>
diff --git a/fs/nfsd/blocklayoutxdr.c b/fs/nfsd/blocklayoutxdr.c
index 6c3b316..4ebaaf4 100644
--- a/fs/nfsd/blocklayoutxdr.c
+++ b/fs/nfsd/blocklayoutxdr.c
@@ -3,6 +3,7 @@
  */
 #include <linux/sunrpc/svc.h>
 #include <linux/exportfs.h>
+#include <linux/iomap.h>
 #include <linux/nfs4.h>
 
 #include "nfsd.h"
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 3332bae..0a56787 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2014 Christoph Hellwig.
  */
+#include <linux/iomap.h>
 #include "xfs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index d841450..b03c062 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -6,6 +6,7 @@
 struct dentry;
 struct iattr;
 struct inode;
+struct iomap;
 struct super_block;
 struct vfsmount;
 
@@ -187,21 +188,6 @@ struct fid {
  *    get_name is not (which is possibly inconsistent)
  */
 
-/* types of block ranges for multipage write mappings. */
-#define IOMAP_HOLE	0x01	/* no blocks allocated, need allocation */
-#define IOMAP_DELALLOC	0x02	/* delayed allocation blocks */
-#define IOMAP_MAPPED	0x03	/* blocks allocated @blkno */
-#define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
-
-#define IOMAP_NULL_BLOCK -1LL	/* blkno is not valid */
-
-struct iomap {
-	sector_t	blkno;	/* first sector of mapping */
-	loff_t		offset;	/* file offset of mapping, bytes */
-	u64		length;	/* length of mapping, bytes */
-	int		type;	/* type of mapping */
-};
-
 struct export_operations {
 	int (*encode_fh)(struct inode *inode, __u32 *fh, int *max_len,
 			struct inode *parent);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
new file mode 100644
index 0000000..1b22197
--- /dev/null
+++ b/include/linux/iomap.h
@@ -0,0 +1,21 @@
+#ifndef LINUX_IOMAP_H
+#define LINUX_IOMAP_H 1
+
+#include <linux/types.h>
+
+/* types of block ranges for multipage write mappings. */
+#define IOMAP_HOLE	0x01	/* no blocks allocated, need allocation */
+#define IOMAP_DELALLOC	0x02	/* delayed allocation blocks */
+#define IOMAP_MAPPED	0x03	/* blocks allocated @blkno */
+#define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
+
+#define IOMAP_NULL_BLOCK -1LL	/* blkno is not valid */
+
+struct iomap {
+	sector_t	blkno;	/* first sector of mapping */
+	loff_t		offset;	/* file offset of mapping, bytes */
+	u64		length;	/* length of mapping, bytes */
+	int		type;	/* type of mapping */
+};
+
+#endif /* LINUX_IOMAP_H */
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
