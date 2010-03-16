Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2GIsOjL192318 for <xfs@oss.sgi.com>; Tue, 16 Mar 2010 13:54:24 -0500
Subject: [PATCH 2/2] xfs: use scalable vmap API
From: Alex Elder <aelder@sgi.com>
Date: Tue, 16 Mar 2010 13:55:56 -0500
Message-ID: <1268765756.1951.27.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: hch@lst.de

Re-apply a commit that had been reverted due to regressions
that have since been fixed.

    From 95f8e302c04c0b0c6de35ab399a5551605eeb006 Mon Sep 17 00:00:00 2001
    From: Nick Piggin <npiggin@suse.de>
    Date: Tue, 6 Jan 2009 14:43:09 +1100

    Implement XFS's large buffer support with the new vmap APIs. See the vmap
    rewrite (db64fe02) for some numbers. The biggest improvement that comes from
    using the new APIs is avoiding the global KVA allocation lock on every call.

    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Reviewed-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

Only modifications here were a minor reformat, plus making the patch
apply given the new use of xfs_buf_is_vmapped().

Modified-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_buf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -268,7 +268,8 @@ xfs_buf_free(
 		uint		i;
 
 		if (xfs_buf_is_vmapped(bp))
-			vunmap(bp->b_addr - bp->b_offset);
+			vm_unmap_ram(bp->b_addr - bp->b_offset,
+					bp->b_page_count);
 
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
@@ -388,8 +389,8 @@ _xfs_buf_map_pages(
 		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 		bp->b_flags |= XBF_MAPPED;
 	} else if (flags & XBF_MAPPED) {
-		bp->b_addr = vmap(bp->b_pages, bp->b_page_count,
-					VM_MAP, PAGE_KERNEL);
+		bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
+					-1, PAGE_KERNEL);
 		if (unlikely(bp->b_addr == NULL))
 			return -ENOMEM;
 		bp->b_addr += bp->b_offset;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
