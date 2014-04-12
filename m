Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 656607F53
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 03:00:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68E588F8039
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 01:00:01 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id vedx7jJGKJaFTNAs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 00:59:59 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYsr0-0006GW-SO
	for xfs@oss.sgi.com; Sat, 12 Apr 2014 07:59:58 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/9] xfs: don't create a slab cache for filestream items
Date: Sat, 12 Apr 2014 10:02:01 +0200
Message-Id: <1397289723-26243-8-git-send-email-hch@lst.de>
In-Reply-To: <1397289723-26243-1-git-send-email-hch@lst.de>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
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

We only have very few of these around, and allocation isn't that
much of a hot path.  Remove the slab cache to simplify the code,
and to not waste any resources for the usual case of not having
any inodes that use the filestream allocator.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_filestream.c |   25 +++----------------------
 fs/xfs/xfs_filestream.h |    2 --
 fs/xfs/xfs_super.c      |    9 +--------
 3 files changed, 4 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index ff6f902..7b94036 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -39,8 +39,6 @@
 #define TRACE_FREE(mp, ip, pip, ag, cnt)
 #define TRACE_LOOKUP(mp, ip, pip, ag, cnt)
 
-static kmem_zone_t *item_zone;
-
 struct xfs_fstrm_item {
 	struct xfs_mru_cache_elem	mru;
 	struct xfs_inode		*ip;
@@ -141,7 +139,7 @@ xfs_fstrm_free_func(
 	TRACE_FREE(mp, ip, NULL, item->ag,
 		   xfs_filestream_peek_ag(mp, item->ag));
 
-	kmem_zone_free(item_zone, item);
+	kmem_free(item);
 }
 
 /*
@@ -272,7 +270,7 @@ next_ag:
 		return 0;
 
 	err = ENOMEM;
-	item = kmem_zone_zalloc(item_zone, KM_MAYFAIL);
+	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
 	if (!item)
 		goto out_put_ag;
 
@@ -289,7 +287,7 @@ next_ag:
 	return 0;
 
 out_free_item:
-	kmem_zone_free(item_zone, item);
+	kmem_free(item);
 out_put_ag:
 	xfs_filestream_put_ag(mp, *agp);
 	return err;
@@ -474,20 +472,3 @@ xfs_filestream_unmount(
 {
 	xfs_mru_cache_destroy(mp->m_filestream);
 }
-
-
-/* needs to return a positive errno for the init path */
-int
-xfs_filestream_init(void)
-{
-	item_zone = kmem_zone_init(sizeof(struct xfs_fstrm_item), "fstrm_item");
-	if (!item_zone)
-		return -ENOMEM;
-	return 0;
-}
-
-void
-xfs_filestream_uninit(void)
-{
-	kmem_zone_destroy(item_zone);
-}
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index e3a25f8..578d49e 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -22,8 +22,6 @@ struct xfs_mount;
 struct xfs_inode;
 struct xfs_bmalloca;
 
-int xfs_filestream_init(void);
-void xfs_filestream_uninit(void);
 int xfs_filestream_mount(struct xfs_mount *mp);
 void xfs_filestream_unmount(struct xfs_mount *mp);
 void xfs_filestream_deassociate(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f317488..aab37af 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1753,13 +1753,9 @@ init_xfs_fs(void)
 	if (error)
 		goto out_destroy_wq;
 
-	error = xfs_filestream_init();
-	if (error)
-		goto out_mru_cache_uninit;
-
 	error = xfs_buf_init();
 	if (error)
-		goto out_filestream_uninit;
+		goto out_mru_cache_uninit;
 
 	error = xfs_init_procfs();
 	if (error)
@@ -1786,8 +1782,6 @@ init_xfs_fs(void)
 	xfs_cleanup_procfs();
  out_buf_terminate:
 	xfs_buf_terminate();
- out_filestream_uninit:
-	xfs_filestream_uninit();
  out_mru_cache_uninit:
 	xfs_mru_cache_uninit();
  out_destroy_wq:
@@ -1806,7 +1800,6 @@ exit_xfs_fs(void)
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
 	xfs_buf_terminate();
-	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
 	xfs_destroy_zones();
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
