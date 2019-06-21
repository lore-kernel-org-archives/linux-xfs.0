Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57654 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfFUT5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:23 -0400
Subject: [PATCH 3/6] libxfs: fix uncached buffer refcounting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jun 2019 12:57:12 -0700
Message-ID: <156114703289.1643538.16263048212251920271.stgit@magnolia>
In-Reply-To: <156114701371.1643538.316410894576032261.stgit@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Currently, uncached buffers in userspace are created with zero refcount
and are fed to cache_node_put when they're released.  This is totally
broken -- the refcount should be 1 (because the caller now holds a
reference) and we should never be dumping uncached buffers into the
cache.  Fix both of these problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h   |   18 ++++++++++++++++++
 libxfs/libxfs_priv.h |    2 --
 libxfs/rdwr.c        |    5 ++++-
 3 files changed, 22 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 94261270..b6f8756a 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -225,4 +225,22 @@ xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
 	return 0;
 }
 
+/*
+ * Allocate an uncached buffer that points nowhere.  The refcount will be 1,
+ * and the cache node hash list will be empty to indicate that it's uncached.
+ */
+static inline struct xfs_buf *
+xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
+{
+	struct xfs_buf	*bp;
+
+	bp = libxfs_getbufr(targ, XFS_BUF_DADDR_NULL, bblen);
+	if (!bp)
+		return NULL;
+
+	INIT_LIST_HEAD(&bp->b_node.cn_hash);
+	bp->b_node.cn_count = 1;
+	return bp;
+}
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9004ff0c..eb92942a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -378,8 +378,6 @@ roundup_64(uint64_t x, uint32_t y)
 	(len) = __bar; /* no set-but-unused warning */	\
 	NULL;						\
 })
-#define xfs_buf_get_uncached(t,n,f)     \
-	libxfs_getbufr((t), XFS_BUF_DADDR_NULL, (n));
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 998862af..9c6c93a7 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -866,7 +866,10 @@ libxfs_putbuf(xfs_buf_t *bp)
 		}
 	}
 
-	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+	if (!list_empty(&bp->b_node.cn_hash))
+		cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+	else if (--bp->b_node.cn_count == 0)
+		libxfs_putbufr(bp);
 }
 
 void
