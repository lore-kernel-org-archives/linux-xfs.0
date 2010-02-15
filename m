Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1FM12TN091785 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 16:01:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6498A1D25D2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 14:02:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oSvg0jdKviNlgMqZ for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2010 14:02:20 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Nh91H-000220-Tm
	for xfs@oss.sgi.com; Mon, 15 Feb 2010 22:02:19 +0000
Date: Mon, 15 Feb 2010 17:02:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix xfs_fsblock_t tracing
Message-ID: <20100215220219.GA4890@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Using a static buffer in xfs_fmtfsblock means we can corrupt traces if
multiple CPUs hit this code path at the same.  Just remove xfs_fmtfsblock
for now and print the block number purely numerical.  If we want the
NULLFSBLOCK and NULLSTARTBLOCK formatting back the best way would be
a decoding plugin in the trace-cmd userspace command.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_trace.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.c	2010-02-15 16:38:56.584022819 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_trace.c	2010-02-15 22:57:41.336004102 +0100
@@ -52,22 +52,6 @@
 #include "quota/xfs_dquot.h"
 
 /*
- * Format fsblock number into a static buffer & return it.
- */
-STATIC char *xfs_fmtfsblock(xfs_fsblock_t bno)
-{
-	static char rval[50];
-
-	if (bno == NULLFSBLOCK)
-		sprintf(rval, "NULLFSBLOCK");
-	else if (isnullstartblock(bno))
-		sprintf(rval, "NULLSTARTBLOCK(%lld)", startblockval(bno));
-	else
-		sprintf(rval, "%lld", (xfs_dfsbno_t)bno);
-	return rval;
-}
-
-/*
  * We include this last to have the helpers above available for the trace
  * event implementations.
  */
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-02-15 16:38:56.595017231 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2010-02-15 22:57:41.338004172 +0100
@@ -197,13 +197,13 @@ TRACE_EVENT(xfs_iext_insert,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s idx %ld "
-		  "offset %lld block %s count %lld flag %d caller %pf",
+		  "offset %lld block %lld count %lld flag %d caller %pf",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
 		  (long)__entry->idx,
 		  __entry->startoff,
-		  xfs_fmtfsblock(__entry->startblock),
+		  (__int64_t)__entry->startblock,
 		  __entry->blockcount,
 		  __entry->state,
 		  (char *)__entry->caller_ip)
@@ -241,13 +241,13 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s idx %ld "
-		  "offset %lld block %s count %lld flag %d caller %pf",
+		  "offset %lld block %lld count %lld flag %d caller %pf",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
 		  (long)__entry->idx,
 		  __entry->startoff,
-		  xfs_fmtfsblock(__entry->startblock),
+		  (__int64_t)__entry->startblock,
 		  __entry->blockcount,
 		  __entry->state,
 		  (char *)__entry->caller_ip)
@@ -881,7 +881,7 @@ TRACE_EVENT(name, \
 	), \
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx " \
 		  "offset 0x%llx count %zd flags %s " \
-		  "startoff 0x%llx startblock %s blockcount 0x%llx", \
+		  "startoff 0x%llx startblock %lld blockcount 0x%llx", \
 		  MAJOR(__entry->dev), MINOR(__entry->dev), \
 		  __entry->ino, \
 		  __entry->size, \
@@ -890,7 +890,7 @@ TRACE_EVENT(name, \
 		  __entry->count, \
 		  __print_flags(__entry->flags, "|", BMAPI_FLAGS), \
 		  __entry->startoff, \
-		  xfs_fmtfsblock(__entry->startblock), \
+		  (__int64_t)__entry->startblock, \
 		  __entry->blockcount) \
 )
 DEFINE_IOMAP_EVENT(xfs_iomap_enter);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
