Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58426 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753805AbeCFVyv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 16:54:51 -0500
Subject: [PATCH 2/5] libxfs: add function to free all buffers in bcache
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5b3368e5-6ce7-e225-e75c-5dc6486d4b57@sandeen.net>
Date: Tue, 6 Mar 2018 15:54:51 -0600
MIME-Version: 1.0
In-Reply-To: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

libxfs_bcache_purge simply moves all "free" buffers
onto the xfs_buf_freelist mru list; add a new function to
actually free them when we tear everything down, so leak
checkers don't go nuts about lots of unfreed xfs_bufs
at exit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/init.c      |  5 ++++-
 libxfs/libxfs_io.h |  1 +
 libxfs/rdwr.c      | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 7bde8b7..c7d73b6 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -888,8 +888,11 @@ libxfs_umount(xfs_mount_t *mp)
 void
 libxfs_destroy(void)
 {
-	manage_zones(1);
+	/* Free everything from the buffer cache before freeing buffer zone */
+	libxfs_bcache_purge();
+	libxfs_bcache_free();
 	cache_destroy(libxfs_bcache);
+	manage_zones(1);
 }
 
 int
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 78b6780..6de6fcb 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -188,6 +188,7 @@ extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
 			const struct xfs_buf_ops *ops);
 extern xfs_buf_t *libxfs_getsb(struct xfs_mount *, int);
 extern void	libxfs_bcache_purge(void);
+extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(void);
 extern void	libxfs_purgebuf(xfs_buf_t *);
 extern int	libxfs_bcache_overflowed(void);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3c5def2..81701b7 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1275,6 +1275,24 @@ libxfs_bulkrelse(
 }
 
 /*
+ * Free everything from the xfs_buf_freelist MRU, used at final teardown
+ */
+void
+libxfs_bcache_free(void)
+{
+	struct list_head	*cm_list;
+	xfs_buf_t		*bp, *next;
+
+	cm_list = &xfs_buf_freelist.cm_list;
+	list_for_each_entry_safe(bp, next, cm_list, b_node.cn_mru) {
+		free(bp->b_addr);
+		if (bp->b_maps != &bp->__b_map)
+			free(bp->b_maps);
+		kmem_zone_free(xfs_buf_zone, bp);
+	}
+}
+
+/*
  * When a buffer is marked dirty, the error is cleared. Hence if we are trying
  * to flush a buffer prior to cache reclaim that has an error on it it means
  * we've already tried to flush it and it failed. Prevent repeated corruption
-- 
1.8.3.1

