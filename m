Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60876 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728500AbfHACSB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 22:18:01 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/24] xfs:: account for memory freed from metadata buffers
Date: Thu,  1 Aug 2019 12:17:39 +1000
Message-Id: <20190801021752.4986-12-david@fromorbit.com>
In-Reply-To: <20190801021752.4986-1-david@fromorbit.com>
References: <20190801021752.4986-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The buffer cache shrinker frees more than just the xfs_buf slab
objects - it also frees the pages attached to the buffers. Make sure
the memory reclaim code accounts for this memory being freed
correctly, similar to how the inode shrinker accounts for pages
freed from the page cache due to mapping invalidation.

We also need to make sure that the mm subsystem knows these are
reclaimable objects. We provide the memory reclaim subsystem with a
a shrinker to reclaim xfs_bufs, so we should really mark the slab
that way.

We also have a lot of xfs_bufs in a busy system, spread them around
like we do inodes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6e0f76532535..beb816cd54d6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1667,6 +1667,14 @@ xfs_buftarg_shrink_scan(
 		struct xfs_buf *bp;
 		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
 		list_del_init(&bp->b_lru);
+
+		/*
+		 * Account for the buffer memory freed here so memory reclaim
+		 * sees this and not just the xfs_buf slab entry being freed.
+		 */
+		if (current->reclaim_state)
+			current->reclaim_state->reclaimed_pages += bp->b_page_count;
+
 		xfs_buf_rele(bp);
 	}
 
@@ -2057,7 +2065,8 @@ int __init
 xfs_buf_init(void)
 {
 	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
-						KM_ZONE_HWALIGN, NULL);
+			KM_ZONE_HWALIGN | KM_ZONE_SPREAD | KM_ZONE_RECLAIM,
+			NULL);
 	if (!xfs_buf_zone)
 		goto out;
 
-- 
2.22.0
