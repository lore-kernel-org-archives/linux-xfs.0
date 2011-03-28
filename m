Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SL66Z1185405 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 16:06:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1067F1DEB003
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:09:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3q9GSW3VDscPmUtD for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:09:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q4JgZ-0001tI-Dr
	for xfs@oss.sgi.com; Mon, 28 Mar 2011 21:09:15 +0000
Message-Id: <20110328210915.396135841@bombadil.infradead.org>
Date: Mon, 28 Mar 2011 17:06:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: update busy extent tracing
References: <20110328210614.832613417@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-busy-trace-update
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

Add new tracepoint for the new busy extent handling helpers, and update the
existing ones to use a common class.  Also drop the busysearch tracepoint
now that a plain busylist search only happens in a debug assert and the
FITRIM handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-03-28 16:02:55.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-03-28 16:46:51.373340927 +0200
@@ -1151,44 +1151,7 @@ TRACE_EVENT(xfs_bunmap,
 
 );
 
-#define XFS_BUSY_SYNC \
-	{ 0,	"async" }, \
-	{ 1,	"sync" }
-
-TRACE_EVENT(xfs_alloc_busy,
-	TP_PROTO(struct xfs_trans *trans, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len, int sync),
-	TP_ARGS(trans, agno, agbno, len, sync),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(struct xfs_trans *, tp)
-		__field(int, tid)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
-		__field(int, sync)
-	),
-	TP_fast_assign(
-		__entry->dev = trans->t_mountp->m_super->s_dev;
-		__entry->tp = trans;
-		__entry->tid = trans->t_ticket->t_tid;
-		__entry->agno = agno;
-		__entry->agbno = agbno;
-		__entry->len = len;
-		__entry->sync = sync;
-	),
-	TP_printk("dev %d:%d trans 0x%p tid 0x%x agno %u agbno %u len %u %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->tp,
-		  __entry->tid,
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len,
-		  __print_symbolic(__entry->sync, XFS_BUSY_SYNC))
-
-);
-
-TRACE_EVENT(xfs_alloc_unbusy,
+DECLARE_EVENT_CLASS(xfs_busy_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len),
 	TP_ARGS(mp, agno, agbno, len),
@@ -1210,35 +1173,45 @@ TRACE_EVENT(xfs_alloc_unbusy,
 		  __entry->agbno,
 		  __entry->len)
 );
+#define DEFINE_BUSY_EVENT(name) \
+DEFINE_EVENT(xfs_busy_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len), \
+	TP_ARGS(mp, agno, agbno, len))
+DEFINE_BUSY_EVENT(xfs_alloc_busy);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_enomem);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_force);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_reuse);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_clear);
 
-#define XFS_BUSY_STATES \
-	{ 0,	"missing" }, \
-	{ 1,	"found" }
-
-TRACE_EVENT(xfs_alloc_busysearch,
+TRACE_EVENT(xfs_alloc_busy_trim,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len, int found),
-	TP_ARGS(mp, agno, agbno, len, found),
+		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 xfs_agblock_t tbno, xfs_extlen_t tlen),
+	TP_ARGS(mp, agno, agbno, len, tbno, tlen),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
-		__field(int, found)
+		__field(xfs_agblock_t, tbno)
+		__field(xfs_extlen_t, tlen)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
-		__entry->found = found;
+		__entry->tbno = tbno;
+		__entry->tlen = tlen;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u %s",
+	TP_printk("dev %d:%d agno %u agbno %u len %u tbno %u tlen %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len,
-		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
+		  __entry->tbno,
+		  __entry->tlen)
 );
 
 TRACE_EVENT(xfs_trans_commit_lsn,
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-28 16:14:49.000000000 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-03-28 16:46:51.397342798 +0200
@@ -2483,7 +2483,7 @@ xfs_alloc_busy_insert(
 		 * block, make this a synchronous transaction to insure that
 		 * the block is not reused before this transaction commits.
 		 */
-		trace_xfs_alloc_busy(tp, agno, bno, len, 1);
+		trace_xfs_alloc_busy_enomem(tp->t_mountp, agno, bno, len);
 		xfs_trans_set_sync(tp);
 		return;
 	}
@@ -2495,7 +2495,7 @@ xfs_alloc_busy_insert(
 	INIT_LIST_HEAD(&new->list);
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_alloc_busy(tp, agno, bno, len, 0);
+	trace_xfs_alloc_busy(tp->t_mountp, agno, bno, len);
 
 	pag = xfs_perag_get(tp->t_mountp, new->agno);
 	spin_lock(&pag->pagb_lock);
@@ -2569,7 +2569,6 @@ xfs_alloc_busy_search(
 		}
 	}
 	spin_unlock(&pag->pagb_lock);
-	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!match);
 	xfs_perag_put(pag);
 	return match;
 }
@@ -2738,10 +2737,16 @@ restart:
 						   fbno, fbno + flen);
 		if (ret != XFS_BUSY_REUSE_OK || userdata) {
 			spin_unlock(&pag->pagb_lock);
-			if (ret == XFS_BUSY_LOG_FORCE)
+			if (ret == XFS_BUSY_LOG_FORCE) {
+				trace_xfs_alloc_busy_force(tp->t_mountp, agno,
+							   fbno, flen);
 				xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
+			}
  			goto restart;
 		}
+
+		trace_xfs_alloc_busy_reuse(tp->t_mountp, agno, fbno, flen);
+
 #if 0
 		/*
 		 * No more busy extents to search.
@@ -2918,6 +2923,8 @@ xfs_alloc_busy_trim(
 	}
 	spin_unlock(&args->pag->pagb_lock);
 out:
+	if (fbno != bno || flen != len)
+		trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len, fbno, flen);
 	*rbno = fbno;
 	*rlen = flen;
 	return;
@@ -2927,6 +2934,7 @@ fail:
 	 * re-check if the trimmed extent satisfies the minlen requirement.
 	 */
 	spin_unlock(&args->pag->pagb_lock);
+	trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len, fbno, 0);
 	*rbno = fbno;
 	*rlen = 0;
 }
@@ -2938,15 +2946,15 @@ xfs_alloc_busy_clear(
 {
 	struct xfs_perag	*pag;
 
-	trace_xfs_alloc_unbusy(mp, busyp->agno, busyp->bno,
-						busyp->length);
-
 	list_del_init(&busyp->list);
 
 	pag = xfs_perag_get(mp, busyp->agno);
 	spin_lock(&pag->pagb_lock);
-	if (busyp->length)
+	if (busyp->length) {
+		trace_xfs_alloc_busy_clear(mp, busyp->agno, busyp->bno,
+						busyp->length);
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
+	}
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
