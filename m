Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11E427F58
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 01:17:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A26B1AC002
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 23:17:23 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	shYgqkXT8wsKMcdW for <xfs@oss.sgi.com>;
	Tue, 21 Jan 2014 23:17:22 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W5s3p-0001YO-Kc
	for xfs@oss.sgi.com; Wed, 22 Jan 2014 18:17:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W5s3p-0002jt-Js
	for xfs@oss.sgi.com; Wed, 22 Jan 2014 18:17:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] libxfs: add a flags field to libxfs_getbuf_map
Date: Wed, 22 Jan 2014 18:17:11 +1100
Message-Id: <1390375033-10483-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1390375033-10483-1-git-send-email-david@fromorbit.com>
References: <1390375033-10483-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

It will be needed to make the repair prefetch code aware of compound
buffers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h |  8 ++++----
 libxfs/rdwr.c    | 15 +++++++++------
 libxfs/trans.c   |  4 ++--
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 4bf331c..2872410 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -392,9 +392,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_getbuf(dev, daddr, len) \
 	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len))
-#define libxfs_getbuf_map(dev, map, nmaps) \
+#define libxfs_getbuf_map(dev, map, nmaps, flags) \
 	libxfs_trace_getbuf_map(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (map), (nmaps))
+			    (dev), (map), (nmaps), (flags))
 #define libxfs_getbuf_flags(dev, daddr, len, flags) \
 	libxfs_trace_getbuf_flags(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len), (flags))
@@ -412,7 +412,7 @@ extern int	libxfs_trace_writebuf(const char *, const char *, int,
 extern xfs_buf_t *libxfs_trace_getbuf(const char *, const char *, int,
 			struct xfs_buftarg *, xfs_daddr_t, int);
 extern xfs_buf_t *libxfs_trace_getbuf_map(const char *, const char *, int,
-			struct xfs_buftarg *, struct xfs_buf_map *, int);
+			struct xfs_buftarg *, struct xfs_buf_map *, int, int);
 extern xfs_buf_t *libxfs_trace_getbuf_flags(const char *, const char *, int,
 			struct xfs_buftarg *, xfs_daddr_t, int, unsigned int);
 extern void	libxfs_trace_putbuf (const char *, const char *, int,
@@ -427,7 +427,7 @@ extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 extern int	libxfs_writebuf(xfs_buf_t *, int);
 extern xfs_buf_t *libxfs_getbuf(struct xfs_buftarg *, xfs_daddr_t, int);
 extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
-			struct xfs_buf_map *, int);
+			struct xfs_buf_map *, int, int);
 extern xfs_buf_t *libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t,
 			int, unsigned int);
 extern void	libxfs_putbuf (xfs_buf_t *);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0219a08..bf92788 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -203,7 +203,8 @@ xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
 int		libxfs_writebuf(xfs_buf_t *, int);
 xfs_buf_t	*libxfs_getbuf(struct xfs_buftarg *, xfs_daddr_t, int);
-xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *, int);
+xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
+				int, int);
 xfs_buf_t	*libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t, int,
 				unsigned int);
 void		libxfs_putbuf (xfs_buf_t *);
@@ -255,9 +256,10 @@ libxfs_trace_getbuf(const char *func, const char *file, int line,
 
 xfs_buf_t *
 libxfs_trace_getbuf_map(const char *func, const char *file, int line,
-		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps)
+		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
+		int flags)
 {
-	xfs_buf_t	*bp = libxfs_getbuf_map(btp, map, nmaps);
+	xfs_buf_t	*bp = libxfs_getbuf_map(btp, map, nmaps, flags);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -582,7 +584,8 @@ libxfs_getbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len)
 }
 
 struct xfs_buf *
-libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps)
+libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
+		  int nmaps, int flags)
 {
 	struct xfs_bufkey key = {0};
 	int i;
@@ -595,7 +598,7 @@ libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps)
 	key.map = map;
 	key.nmaps = nmaps;
 
-	return __cache_lookup(&key, 0);
+	return __cache_lookup(&key, flags);
 }
 
 void
@@ -775,7 +778,7 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
 					flags, ops);
 
-	bp = libxfs_getbuf_map(btp, map, nmaps);
+	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
 	if (!bp)
 		return NULL;
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 6a05673..6c9d202 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -511,7 +511,7 @@ libxfs_trans_get_buf_map(
 	xfs_buf_log_item_t	*bip;
 
 	if (tp == NULL)
-		return libxfs_getbuf_map(btp, map, nmaps);
+		return libxfs_getbuf_map(btp, map, nmaps, 0);
 
 	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
 	if (bp != NULL) {
@@ -522,7 +522,7 @@ libxfs_trans_get_buf_map(
 		return bp;
 	}
 
-	bp = libxfs_getbuf_map(btp, map, nmaps);
+	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
 	if (bp == NULL)
 		return NULL;
 #ifdef XACT_DEBUG
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
