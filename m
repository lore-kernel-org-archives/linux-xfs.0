Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA537hKE176383 for <xfs@oss.sgi.com>; Thu, 4 Nov 2010 22:07:43 -0500
From: Joe Perches <joe@perches.com>
Subject: [PATCH 41/49] fs/xfs: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:05 -0700
Message-Id: <10acc19712bf3d1e0ea68e7c16e1723922541249.1288925425.git.joe@perches.com>
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
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
To: Jiri Kosina <trivial@kernel.org>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/linux-2.6/kmem.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
index f7c8f7a..292eff1 100644
--- a/fs/xfs/linux-2.6/kmem.h
+++ b/fs/xfs/linux-2.6/kmem.h
@@ -61,12 +61,7 @@ extern void  kmem_free(const void *);
 
 static inline void *kmem_zalloc_large(size_t size)
 {
-	void *ptr;
-
-	ptr = vmalloc(size);
-	if (ptr)
-		memset(ptr, 0, size);
-	return ptr;
+	return vzalloc(size);
 }
 static inline void kmem_free_large(void *ptr)
 {
-- 
1.7.3.1.g432b3.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
