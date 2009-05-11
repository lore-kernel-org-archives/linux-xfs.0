Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4BG6VFU001126 for <xfs@oss.sgi.com>; Mon, 11 May 2009 11:06:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43510278F64
	for <xfs@oss.sgi.com>; Mon, 11 May 2009 09:06:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vWNfil2BDGWjwMrd for
	<xfs@oss.sgi.com>; Mon, 11 May 2009 09:06:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1M3Y1B-0006zy-ED
	for xfs@oss.sgi.com; Mon, 11 May 2009 16:06:35 +0000
Date: Mon, 11 May 2009 12:06:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: update max log size
Message-ID: <20090511160609.GA18278@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Commit a6634fba3dec4a92f0a2c4e30c80b634c0576ad5 in xfsprogs increased the
maximum log size supported by mkfs.  Merged back the changes to xfs_fs.h
so the growfs enforced the same limit and the headers are in sync.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_fs.h
===================================================================
--- xfs.orig/fs/xfs/xfs_fs.h	2009-02-08 21:51:06.576943974 +0100
+++ xfs/fs/xfs/xfs_fs.h	2009-05-10 21:33:30.970822643 +0200
@@ -239,10 +239,13 @@ typedef struct xfs_fsop_resblks {
  * Minimum and maximum sizes need for growth checks
  */
 #define XFS_MIN_AG_BLOCKS	64
-#define XFS_MIN_LOG_BLOCKS	512
-#define XFS_MAX_LOG_BLOCKS	(64 * 1024)
-#define XFS_MIN_LOG_BYTES	(256 * 1024)
-#define XFS_MAX_LOG_BYTES	(128 * 1024 * 1024)
+#define XFS_MIN_LOG_BLOCKS	512ULL
+#define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
+#define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
+
+/* keep the maximum size under 2^31 by a small amount */
+#define XFS_MAX_LOG_BYTES \
+	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
