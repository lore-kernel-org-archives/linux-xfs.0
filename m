Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B171D7F58
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 05:31:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 715C38F8040
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 03:31:15 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id scH8XTAaFZygbhsN for
	<xfs@oss.sgi.com>; Fri, 01 Nov 2013 03:31:13 -0700 (PDT)
Message-ID: <52738187.1000807@cn.fujitsu.com>
Date: Fri, 01 Nov 2013 18:25:11 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: simplify kmem_{zone_}zalloc
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


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/xfs/kmem.c |   14 ++------------
 fs/xfs/kmem.h |    7 ++++++-
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index a02cfb9..d56fcc9 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -65,12 +65,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 void *
 kmem_zalloc(size_t size, xfs_km_flags_t flags)
 {
-	void	*ptr;
-
-	ptr = kmem_alloc(size, flags);
-	if (ptr)
-		memset((char *)ptr, 0, (int)size);
-	return ptr;
+	return kmem_alloc(size, flags | KM_ZERO);
 }
 
 void *
@@ -132,10 +127,5 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 void *
 kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 {
-	void	*ptr;
-
-	ptr = kmem_zone_alloc(zone, flags);
-	if (ptr)
-		memset((char *)ptr, 0, kmem_cache_size(zone));
-	return ptr;
+	return kmem_zone_alloc(zone, flags | KM_ZERO);
 }
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 3a7371c..8ea21fd 100644
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
@@ -52,6 +53,10 @@ kmem_flags_convert(xfs_km_flags_t flags)
 		if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
 			lflags &= ~__GFP_FS;
 	}
+
+	if (flags & KM_ZERO)
+		lflags |= __GFP_ZERO;
+
 	return lflags;
 }
 
-- 
1.7.7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
