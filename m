Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E30E7F69
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 04:27:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E1E08F8052
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 02:27:16 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 8W09BeM87ODsKR8r for
	<xfs@oss.sgi.com>; Mon, 04 Nov 2013 02:27:14 -0800 (PST)
Message-ID: <52777511.1020605@cn.fujitsu.com>
Date: Mon, 04 Nov 2013 18:21:05 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: simplify kmem_{zone_}zalloc
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: bpm@sgi.com, elder@kernel.org
Cc: guz.fnst@cn.fujitsu.com, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
in order to avoid the setting to zero step. 
And following Dave's suggestion, make kmem_{zone_}zalloc static inline
into kmem.h as they're now just a simple wrapper.

V2:
  Make kmem_{zone_}zalloc static inline into kmem.h as Dave suggested.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/xfs/kmem.c |   22 ----------------------
 fs/xfs/kmem.h |   21 ++++++++++++++++++---
 2 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index a02cfb9..66a36be 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -63,17 +63,6 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 }
 
 void *
-kmem_zalloc(size_t size, xfs_km_flags_t flags)
-{
-	void	*ptr;
-
-	ptr = kmem_alloc(size, flags);
-	if (ptr)
-		memset((char *)ptr, 0, (int)size);
-	return ptr;
-}
-
-void *
 kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 {
 	void	*ptr;
@@ -128,14 +117,3 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
-
-void *
-kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
-{
-	void	*ptr;
-
-	ptr = kmem_zone_alloc(zone, flags);
-	if (ptr)
-		memset((char *)ptr, 0, kmem_cache_size(zone));
-	return ptr;
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 3a7371c..64db0e5 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -32,6 +32,7 @@ typedef unsigned __bitwise xfs_km_flags_t;
 #define KM_NOSLEEP	((__force xfs_km_flags_t)0x0002u)
 #define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
 #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
+#define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
 
 /*
  * We use a special process flag to avoid recursive callbacks into
@@ -43,7 +44,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
 {
 	gfp_t	lflags;
 
-	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL));
+	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL|KM_ZERO));
 
 	if (flags & KM_NOSLEEP) {
 		lflags = GFP_ATOMIC | __GFP_NOWARN;
@@ -52,11 +53,14 @@ kmem_flags_convert(xfs_km_flags_t flags)
 		if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
 			lflags &= ~__GFP_FS;
 	}
+
+	if (flags & KM_ZERO)
+		lflags |= __GFP_ZERO;
+
 	return lflags;
 }
 
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
-extern void *kmem_zalloc(size_t, xfs_km_flags_t);
 extern void *kmem_zalloc_large(size_t size, xfs_km_flags_t);
 extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
 extern void  kmem_free(const void *);
@@ -64,6 +68,12 @@ extern void  kmem_free(const void *);
 
 extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
 
+static inline void *
+kmem_zalloc(size_t size, xfs_km_flags_t flags)
+{
+	return kmem_alloc(size, flags | KM_ZERO);
+}
+
 /*
  * Zone interfaces
  */
@@ -102,6 +112,11 @@ kmem_zone_destroy(kmem_zone_t *zone)
 }
 
 extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
-extern void *kmem_zone_zalloc(kmem_zone_t *, xfs_km_flags_t);
+
+static inline void *
+kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
+{
+	return kmem_zone_alloc(zone, flags | KM_ZERO);
+}
 
 #endif /* __XFS_SUPPORT_KMEM_H__ */
-- 
1.7.7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
