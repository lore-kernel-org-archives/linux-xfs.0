Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D55377F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 16:46:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7684F8F8040
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 14:46:54 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id P3xu5pwiSdtG9lgf for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 14:46:52 -0800 (PST)
From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH] xfs: support for non-mmu architectures
Date: Wed, 18 Nov 2015 00:46:21 +0200
Message-Id: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, Octavian Purdila <octavian.purdila@intel.com>, linux-kernel@vger.kernel.org

Naive implementation for non-mmu architectures: allocate physically
contiguous xfs buffers with alloc_pages. Terribly inefficient with
memory and fragmentation on high I/O loads but it may be good enough
for basic usage (which most non-mmu architectures will need).

This patch was tested with lklfuse [1] and basic operations seems to
work even with 16MB allocated for LKL.

[1] https://github.com/lkl/linux

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 fs/xfs/xfs_buf.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8ecffb3..50b5246 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -261,6 +261,7 @@ xfs_buf_free(
 	ASSERT(list_empty(&bp->b_lru));
 
 	if (bp->b_flags & _XBF_PAGES) {
+#ifdef CONFIG_MMU
 		uint		i;
 
 		if (xfs_buf_is_vmapped(bp))
@@ -272,6 +273,10 @@ xfs_buf_free(
 
 			__free_page(page);
 		}
+#else
+		free_pages((unsigned long)page_to_virt(bp->b_pages[0]),
+			   order_base_2(bp->b_page_count));
+#endif
 	} else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
 	_xfs_buf_free_pages(bp);
@@ -338,7 +343,14 @@ use_alloc_page:
 		struct page	*page;
 		uint		retries = 0;
 retry:
+#ifdef CONFIG_MMU
 		page = alloc_page(gfp_mask);
+#else
+		if (i == 0)
+			page = alloc_pages(gfp_mask, order_base_2(page_count));
+		else
+			page = bp->b_pages[0] + i;
+#endif
 		if (unlikely(page == NULL)) {
 			if (flags & XBF_READ_AHEAD) {
 				bp->b_page_count = i;
@@ -372,8 +384,11 @@ retry:
 	return 0;
 
 out_free_pages:
+#ifdef CONFIG_MMU
 	for (i = 0; i < bp->b_page_count; i++)
 		__free_page(bp->b_pages[i]);
+#endif
+
 	return error;
 }
 
@@ -392,6 +407,7 @@ _xfs_buf_map_pages(
 	} else if (flags & XBF_UNMAPPED) {
 		bp->b_addr = NULL;
 	} else {
+#ifdef CONFIG_MMU
 		int retried = 0;
 		unsigned noio_flag;
 
@@ -412,6 +428,9 @@ _xfs_buf_map_pages(
 			vm_unmap_aliases();
 		} while (retried++ <= 1);
 		memalloc_noio_restore(noio_flag);
+#else
+		bp->b_addr = page_to_virt(bp->b_pages[0]);
+#endif
 
 		if (!bp->b_addr)
 			return -ENOMEM;
@@ -816,11 +835,19 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail_free_buf;
 
+#ifdef CONFIG_MMU
 	for (i = 0; i < page_count; i++) {
 		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
 		if (!bp->b_pages[i])
 			goto fail_free_mem;
 	}
+#else
+	bp->b_pages[0] = alloc_pages(flags, order_base_2(page_count));
+	if (!bp->b_pages[0])
+		goto fail_free_buf;
+	for (i = 1; i < page_count; i++)
+		bp->b_pages[i] = bp->b_pages[i-1] + 1;
+#endif
 	bp->b_flags |= _XBF_PAGES;
 
 	error = _xfs_buf_map_pages(bp, 0);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
