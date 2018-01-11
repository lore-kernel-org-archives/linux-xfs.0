Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43704 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965724AbeAKThw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:37:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 6/8] libxfs: manage xfs_buf_zone count within cache
Date: Thu, 11 Jan 2018 13:37:36 -0600
Message-Id: <1515699458-6925-7-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Fake up the xfs_buf_zone allocated count a bit to account
for buffers freed to and allocated from cache.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 libxfs/rdwr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 474e5eb..c5ffd4d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -665,6 +665,7 @@ __libxfs_getbufr(int blen)
 				free(bp->b_maps);
 			bp->b_maps = NULL;
 		}
+		xfs_buf_zone->allocated++;
 	} else
 		bp = kmem_zone_zalloc(xfs_buf_zone, 0);
 	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
@@ -1245,6 +1246,7 @@ libxfs_brelse(
 			"releasing dirty buffer to free list!");
 
 	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
+	xfs_buf_zone->allocated--;
 	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
 	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
 }
@@ -1268,6 +1270,7 @@ libxfs_bulkrelse(
 	}
 
 	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
+	xfs_buf_zone->allocated -= count;
 	list_splice(list, &xfs_buf_freelist.cm_list);
 	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
 
-- 
1.8.3.1

