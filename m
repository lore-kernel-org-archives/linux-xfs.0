Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38096 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762023AbdEVUGr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 16:06:47 -0400
Subject: [PATCH V2] xfs: fix unaligned access in xfs_btree_visit_blocks
References: <105ed603-971a-e7db-6040-b85e5eecd928@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1ad226af-4b1b-18ca-274c-20a030ca4768@sandeen.net>
Date: Mon, 22 May 2017 15:06:40 -0500
MIME-Version: 1.0
In-Reply-To: <105ed603-971a-e7db-6040-b85e5eecd928@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

This structure copy was throwing unaligned access warnings on sparc64:

Kernel unaligned access at TPC[1043c088] xfs_btree_visit_blocks+0x88/0xe0 [xfs]

xfs_btree_copy_ptrs does a memcpy, which avoids it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5392674..3a673ba 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4395,7 +4395,7 @@ struct xfs_btree_split_args {
 			xfs_btree_readahead_ptr(cur, ptr, 1);
 
 			/* save for the next iteration of the loop */
-			lptr = *ptr;
+			xfs_btree_copy_ptrs(cur, &lptr, ptr, 1);
 		}
 
 		/* for each buffer in the level */

