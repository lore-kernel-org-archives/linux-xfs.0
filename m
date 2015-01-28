Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C695D7FCA
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 00:08:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 62FB5AC001
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 22:08:55 -0800 (PST)
Received: from seldrel01.sonyericsson.com (seldrel01.sonyericsson.com
	[212.209.106.2]) by cuda.sgi.com with ESMTP id YIlYLH5GWAWENzcd
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2015 22:08:53 -0800 (PST)
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Date: Wed, 28 Jan 2015 14:08:47 +0800
Subject: [PATCH] xfs:change kmem_free to use generic kvfree()
Message-ID: <35FD53F367049845BC99AC72306C23D1044A02027DFF@CNBJMBX05.corpusers.net>
Content-Language: en-US
MIME-Version: 1.0
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
To: "'david@fromorbit.com'" <david@fromorbit.com>, "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

Change kmem_free to use kvfree() generic function,
remove the duplicated code.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 fs/xfs/kmem.c | 10 ----------
 fs/xfs/kmem.h |  5 ++++-
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 53e95b2..a7a3a63 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -91,16 +91,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 	return ptr;
 }
 
-void
-kmem_free(const void *ptr)
-{
-	if (!is_vmalloc_addr(ptr)) {
-		kfree(ptr);
-	} else {
-		vfree(ptr);
-	}
-}
-
 void *
 kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
 	     xfs_km_flags_t flags)
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 64db0e5..cc6b768 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -63,7 +63,10 @@ kmem_flags_convert(xfs_km_flags_t flags)
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
 extern void *kmem_zalloc_large(size_t size, xfs_km_flags_t);
 extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
-extern void  kmem_free(const void *);
+static inline void  kmem_free(const void *ptr)
+{
+	kvfree(ptr);
+}
 
 
 extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
-- 
2.2.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
