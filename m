Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46818 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbfCIPgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Mar 2019 10:36:45 -0500
From: Sean Fu <fxinrong@gmail.com>
Subject: [PATCH] xfs: Use kmem_zalloc for bp->b_pages.
Date: Sat,  9 Mar 2019 23:36:36 +0800
Message-Id: <20190309153636.14154-1-fxinrong@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Sean Fu <fxinrong@gmail.com>

Change the allocation of bp->b_pages to use kmem_zalloc instead of
kmem_alloc.
Remove unnecessary memset for bp->b_pages.

This reduces text size by 42 bytes.
Before:
   text	   data	    bss	    dec	    hex	filename
  23335	    588	      8	  23931	   5d7b	./fs/xfs/xfs_buf.o
After:
   text	   data	    bss	    dec	    hex	filename
  23293	    588	      8	  23889	   5d51	./fs/xfs/xfs_buf.o

Signed-off-by: Sean Fu <fxinrong@gmail.com>
---
 fs/xfs/xfs_buf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4f5f2ff3f70f..be4f740b97c1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -289,12 +289,11 @@ _xfs_buf_get_pages(
 		if (page_count <= XB_PAGES) {
 			bp->b_pages = bp->b_page_array;
 		} else {
-			bp->b_pages = kmem_alloc(sizeof(struct page *) *
+			bp->b_pages = kmem_zalloc(sizeof(struct page *) *
 						 page_count, KM_NOFS);
 			if (bp->b_pages == NULL)
 				return -ENOMEM;
 		}
-		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
 	}
 	return 0;
 }
-- 
2.16.4
