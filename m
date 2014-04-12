Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 18CFA7F66
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 03:00:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 017F3304062
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 01:00:03 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id TWWXxKfkqrLMHgv1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 01:00:01 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYsr2-0006Ge-Hf
	for xfs@oss.sgi.com; Sat, 12 Apr 2014 08:00:00 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/9] xfs: add filestream allocator tracepoints
Date: Sat, 12 Apr 2014 10:02:03 +0200
Message-Id: <1397289723-26243-10-git-send-email-hch@lst.de>
In-Reply-To: <1397289723-26243-1-git-send-email-hch@lst.de>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_filestream.c |   29 +++++++-----------------
 fs/xfs/xfs_filestream.h |    1 +
 fs/xfs/xfs_trace.c      |    1 +
 fs/xfs/xfs_trace.h      |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index c8a8840..8ec81be 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -33,12 +33,6 @@
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
 
-#define TRACE_AG_SCAN(mp, ag, ag2)
-#define TRACE_AG_PICK1(mp, max_ag, maxfree)
-#define TRACE_AG_PICK2(mp, ag, ag2, cnt, free, scan, flag)
-#define TRACE_FREE(mp, ip, pip, ag, cnt)
-#define TRACE_LOOKUP(mp, ip, pip, ag, cnt)
-
 struct xfs_fstrm_item {
 	struct xfs_mru_cache_elem	mru;
 	struct xfs_inode		*ip;
@@ -87,7 +81,7 @@ enum xfs_fstrm_alloc {
  * the cache that reference per-ag array elements that have since been
  * reallocated.
  */
-static int
+int
 xfs_filestream_peek_ag(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno)
@@ -136,8 +130,7 @@ xfs_fstrm_free_func(
 
 	xfs_filestream_put_ag(item->ip->i_mount, item->ag);
 
-	TRACE_FREE(mp, ip, NULL, item->ag,
-		   xfs_filestream_peek_ag(mp, item->ag));
+	trace_xfs_filestream_free(item->ip, item->ag);
 
 	kmem_free(item);
 }
@@ -157,9 +150,8 @@ xfs_filestream_pick_ag(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_fstrm_item	*item;
 	struct xfs_perag	*pag;
-	xfs_extlen_t		longest, free, minfree, maxfree = 0;
+	xfs_extlen_t		longest, free = 0, minfree, maxfree = 0;
 	xfs_agnumber_t		ag, max_ag = NULLAGNUMBER;
-	int			streams, max_streams;
 	int			err, trylock, nscan;
 
 	ASSERT(S_ISDIR(ip->i_d.di_mode));
@@ -174,8 +166,9 @@ xfs_filestream_pick_ag(
 	trylock = XFS_ALLOC_FLAG_TRYLOCK;
 
 	for (nscan = 0; 1; nscan++) {
+		trace_xfs_filestream_scan(ip, ag);
+
 		pag = xfs_perag_get(mp, ag);
-		TRACE_AG_SCAN(mp, ag, atomic_read(&pag->pagf_fstrms));
 
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
@@ -192,7 +185,6 @@ xfs_filestream_pick_ag(
 		/* Keep track of the AG with the most free blocks. */
 		if (pag->pagf_freeblks > maxfree) {
 			maxfree = pag->pagf_freeblks;
-			max_streams = atomic_read(&pag->pagf_fstrms);
 			max_ag = ag;
 		}
 
@@ -215,7 +207,6 @@ xfs_filestream_pick_ag(
 
 			/* Break out, retaining the reference on the AG. */
 			free = pag->pagf_freeblks;
-			streams = atomic_read(&pag->pagf_fstrms);
 			xfs_perag_put(pag);
 			*agp = ag;
 			break;
@@ -251,20 +242,18 @@ next_ag:
 		 */
 		if (max_ag != NULLAGNUMBER) {
 			xfs_filestream_get_ag(mp, max_ag);
-			TRACE_AG_PICK1(mp, max_ag, maxfree);
-			streams = max_streams;
 			free = maxfree;
 			*agp = max_ag;
 			break;
 		}
 
 		/* take AG 0 if none matched */
-		TRACE_AG_PICK1(mp, max_ag, maxfree);
+		trace_xfs_filestream_pick(ip, *agp, free, nscan);
 		*agp = 0;
 		return 0;
 	}
 
-	TRACE_AG_PICK2(mp, startag, *agp, streams, free, nscan, flags);
+	trace_xfs_filestream_pick(ip, *agp, free, nscan);
 
 	if (*agp == NULLAGNUMBER)
 		return 0;
@@ -330,7 +319,6 @@ xfs_filestream_lookup_ag(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_inode	*pip = NULL;
 	xfs_agnumber_t		startag, ag = NULLAGNUMBER;
-	int			ref = 0;
 	struct xfs_mru_cache_elem *mru;
 
 	ASSERT(S_ISREG(ip->i_d.di_mode));
@@ -344,8 +332,7 @@ xfs_filestream_lookup_ag(
 		ag = container_of(mru, struct xfs_fstrm_item, mru)->ag;
 		xfs_mru_cache_done(mp->m_filestream);
 
-		ref = xfs_filestream_peek_ag(ip->i_mount, ag);
-		TRACE_LOOKUP(mp, ip, pip, ag, ref);
+		trace_xfs_filestream_lookup(ip, ag);
 		goto out;
 	}
 
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 2de853e..2ef4340 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -27,6 +27,7 @@ void xfs_filestream_unmount(struct xfs_mount *mp);
 void xfs_filestream_deassociate(struct xfs_inode *ip);
 xfs_agnumber_t xfs_filestream_lookup_ag(struct xfs_inode *ip);
 int xfs_filestream_new_ag(struct xfs_bmalloca *ap, xfs_agnumber_t *agp);
+int xfs_filestream_peek_ag(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 static inline int
 xfs_inode_is_filestream(
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index dee3279..1e85bcd 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -46,6 +46,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_filestream.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 65d8c79..6910458 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -538,6 +538,64 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_buf_ordered);
 
+DECLARE_EVENT_CLASS(xfs_filestream_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno),
+	TP_ARGS(ip, agno),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agnumber_t, agno)
+		__field(int, streams)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->agno = agno;
+		__entry->streams = xfs_filestream_peek_ag(ip->i_mount, agno);
+	),
+	TP_printk("dev %d:%d ino 0x%llx agno %u streams %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->agno,
+		  __entry->streams)
+)
+#define DEFINE_FILESTREAM_EVENT(name) \
+DEFINE_EVENT(xfs_filestream_class, name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno), \
+	TP_ARGS(ip, agno))
+DEFINE_FILESTREAM_EVENT(xfs_filestream_free);
+DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
+DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
+
+TRACE_EVENT(xfs_filestream_pick,
+	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno,
+		 xfs_extlen_t free, int nscan),
+	TP_ARGS(ip, agno, free, nscan),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agnumber_t, agno)
+		__field(int, streams)
+		__field(xfs_extlen_t, free)
+		__field(int, nscan)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->agno = agno;
+		__entry->streams = xfs_filestream_peek_ag(ip->i_mount, agno);
+		__entry->free = free;
+		__entry->nscan = nscan;
+	),
+	TP_printk("dev %d:%d ino 0x%llx agno %u streams %d free %d nscan %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->agno,
+		  __entry->streams,
+		  __entry->free,
+		  __entry->nscan)
+);
+
 DECLARE_EVENT_CLASS(xfs_lock_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags,
 		 unsigned long caller_ip),
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
