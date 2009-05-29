Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TIAJnk079796 for <xfs@oss.sgi.com>; Fri, 29 May 2009 13:10:19 -0500
From: Felix Blyakher <felixb@sgi.com>
Subject: [PATCH] xfs: prevent deadlock in xfs_qm_shake()
Date: Fri, 29 May 2009 13:10:31 -0500
Message-Id: <1243620631-10749-2-git-send-email-felixb@sgi.com>
In-Reply-To: <1243620631-10749-1-git-send-email-felixb@sgi.com>
References: <1243620631-10749-1-git-send-email-felixb@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Hedi Berriche <hedi@sgi.com>

It's possible to recurse into filesystem from the memory
allocation, which deadlocks in xfs_qm_shake(). Add check
for __GFP_FS, and bailout if it is not set.

Signed-off-by: Felix Blyakher <felixb@sgi.com>
Signed-off-by: Hedi Berriche <hedi@sgi.com>
---
 fs/xfs/linux-2.6/kmem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
index af6843c..d8d2321 100644
--- a/fs/xfs/linux-2.6/kmem.h
+++ b/fs/xfs/linux-2.6/kmem.h
@@ -103,7 +103,7 @@ extern void *kmem_zone_zalloc(kmem_zone_t *, unsigned int __nocast);
 static inline int
 kmem_shake_allow(gfp_t gfp_mask)
 {
-	return (gfp_mask & __GFP_WAIT) != 0;
+	return ((gfp_mask & __GFP_WAIT && gfp_mask & __GFP_FS) != 0;
 }
 
 #endif /* __XFS_SUPPORT_KMEM_H__ */
-- 
1.5.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
