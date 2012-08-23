Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55B4Z136080 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:11 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MUfTEomYsPicg652 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:56 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbp-0003K4-9k
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbp-0003ix-7E
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 091/102] xfs: switch to proper __bitwise type for KM_... flags
Date: Thu, 23 Aug 2012 15:02:49 +1000
Message-Id: <1345698180-13612-92-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Al Viro <viro@zeniv.linux.org.uk>

Upstream commit: 77ba78776e90e8de541f13b326e284c74286252f

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xfs/linux-2.6/kmem.c |   10 +++++-----
 fs/xfs/linux-2.6/kmem.h |   21 +++++++++++----------
 fs/xfs/xfs_log.c        |    2 +-
 fs/xfs/xfs_log_priv.h   |    2 +-
 fs/xfs/xfs_trans.c      |    2 +-
 fs/xfs/xfs_trans.h      |    2 +-
 6 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/linux-2.6/kmem.c b/fs/xfs/linux-2.6/kmem.c
index a907de5..4a7286c 100644
--- a/fs/xfs/linux-2.6/kmem.c
+++ b/fs/xfs/linux-2.6/kmem.c
@@ -46,7 +46,7 @@ kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
 }
 
 void *
-kmem_alloc(size_t size, unsigned int __nocast flags)
+kmem_alloc(size_t size, xfs_km_flags_t flags)
 {
 	int	retries = 0;
 	gfp_t	lflags = kmem_flags_convert(flags);
@@ -65,7 +65,7 @@ kmem_alloc(size_t size, unsigned int __nocast flags)
 }
 
 void *
-kmem_zalloc(size_t size, unsigned int __nocast flags)
+kmem_zalloc(size_t size, xfs_km_flags_t flags)
 {
 	void	*ptr;
 
@@ -87,7 +87,7 @@ kmem_free(const void *ptr)
 
 void *
 kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
-	     unsigned int __nocast flags)
+	     xfs_km_flags_t flags)
 {
 	void	*new;
 
@@ -102,7 +102,7 @@ kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
 }
 
 void *
-kmem_zone_alloc(kmem_zone_t *zone, unsigned int __nocast flags)
+kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 {
 	int	retries = 0;
 	gfp_t	lflags = kmem_flags_convert(flags);
@@ -121,7 +121,7 @@ kmem_zone_alloc(kmem_zone_t *zone, unsigned int __nocast flags)
 }
 
 void *
-kmem_zone_zalloc(kmem_zone_t *zone, unsigned int __nocast flags)
+kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 {
 	void	*ptr;
 
diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
index f7c8f7a..642f573 100644
--- a/fs/xfs/linux-2.6/kmem.h
+++ b/fs/xfs/linux-2.6/kmem.h
@@ -27,10 +27,11 @@
  * General memory allocation interfaces
  */
 
-#define KM_SLEEP	0x0001u
-#define KM_NOSLEEP	0x0002u
-#define KM_NOFS		0x0004u
-#define KM_MAYFAIL	0x0008u
+typedef unsigned __bitwise xfs_km_flags_t;
+#define KM_SLEEP	((__force xfs_km_flags_t)0x0001u)
+#define KM_NOSLEEP	((__force xfs_km_flags_t)0x0002u)
+#define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
+#define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
 
 /*
  * We use a special process flag to avoid recursive callbacks into
@@ -38,7 +39,7 @@
  * warnings, so we explicitly skip any generic ones (silly of us).
  */
 static inline gfp_t
-kmem_flags_convert(unsigned int __nocast flags)
+kmem_flags_convert(xfs_km_flags_t flags)
 {
 	gfp_t	lflags;
 
@@ -54,9 +55,9 @@ kmem_flags_convert(unsigned int __nocast flags)
 	return lflags;
 }
 
-extern void *kmem_alloc(size_t, unsigned int __nocast);
-extern void *kmem_zalloc(size_t, unsigned int __nocast);
-extern void *kmem_realloc(const void *, size_t, size_t, unsigned int __nocast);
+extern void *kmem_alloc(size_t, xfs_km_flags_t);
+extern void *kmem_zalloc(size_t, xfs_km_flags_t);
+extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
 extern void  kmem_free(const void *);
 
 static inline void *kmem_zalloc_large(size_t size)
@@ -112,8 +113,8 @@ kmem_zone_destroy(kmem_zone_t *zone)
 		kmem_cache_destroy(zone);
 }
 
-extern void *kmem_zone_alloc(kmem_zone_t *, unsigned int __nocast);
-extern void *kmem_zone_zalloc(kmem_zone_t *, unsigned int __nocast);
+extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
+extern void *kmem_zone_zalloc(kmem_zone_t *, xfs_km_flags_t);
 
 static inline int
 kmem_shake_allow(gfp_t gfp_mask)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9f80aa8..dc37cdb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3194,7 +3194,7 @@ xlog_ticket_alloc(
 	int		cnt,
 	char		client,
 	bool		permanent,
-	int		alloc_flags)
+	xfs_km_flags_t	alloc_flags)
 {
 	struct xlog_ticket *tic;
 	uint		num_headers;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 2152900..b871b6e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -553,7 +553,7 @@ extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
 extern kmem_zone_t *xfs_log_ticket_zone;
 struct xlog_ticket *xlog_ticket_alloc(struct log *log, int unit_bytes,
 				int count, char client, bool permanent,
-				int alloc_flags);
+				xfs_km_flags_t alloc_flags);
 
 
 static inline void
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index cc3bc95..0ee9042 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -585,7 +585,7 @@ xfs_trans_t *
 _xfs_trans_alloc(
 	xfs_mount_t	*mp,
 	uint		type,
-	uint		memflags)
+	xfs_km_flags_t	memflags)
 {
 	xfs_trans_t	*tp;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 53597f4..0269047 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -448,7 +448,7 @@ typedef struct xfs_trans {
  * XFS transaction mechanism exported interfaces.
  */
 xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
-xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
+xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, xfs_km_flags_t);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
