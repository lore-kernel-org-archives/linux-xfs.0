Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43706 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965732AbeAKThw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:37:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 7/8] libxfs: add function to free all bufferse in bcache
Date: Thu, 11 Jan 2018 13:37:37 -0600
Message-Id: <1515699458-6925-8-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

libxfs_bcache_purge simply moves all "free" buffers
onto the xfs_buf_freelist mru list; add a new function to
actually free them when we tear everything down, so leak
checkers don't go nuts about lots of unfreed xfs_bufs
at exit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 libxfs/init.c      |  2 ++
 libxfs/libxfs_io.h |  1 +
 libxfs/rdwr.c      | 16 ++++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/libxfs/init.c b/libxfs/init.c
index 7bde8b7..aea308b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -889,6 +889,8 @@ void
 libxfs_destroy(void)
 {
 	manage_zones(1);
+	libxfs_bcache_purge();
+	libxfs_bcache_free();
 	cache_destroy(libxfs_bcache);
 }
 
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 2fce04d..81d2804 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -191,6 +191,7 @@ extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
 			const struct xfs_buf_ops *ops);
 extern xfs_buf_t *libxfs_getsb(struct xfs_mount *, int);
 extern void	libxfs_bcache_purge(void);
+extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(void);
 extern void	libxfs_purgebuf(xfs_buf_t *);
 extern int	libxfs_bcache_overflowed(void);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index c5ffd4d..1dcabdd 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1278,6 +1278,22 @@ libxfs_bulkrelse(
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
+ 	cm_list = &xfs_buf_freelist.cm_list;
+	list_for_each_entry_safe(bp, next, cm_list, b_node.cn_mru) {
+		free(bp->b_addr);
+		free(bp);
+	}
+}
+
+/*
  * When a buffer is marked dirty, the error is cleared. Hence if we are trying
  * to flush a buffer prior to cache reclaim that has an error on it it means
  * we've already tried to flush it and it failed. Prevent repeated corruption
-- 
1.8.3.1

