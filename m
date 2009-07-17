Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6HIdfSR106520 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 13:39:42 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72D8BA902BE
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 11:48:08 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 68g83RaqRLACI2r5 for
	<xfs@oss.sgi.com>; Fri, 17 Jul 2009 11:48:08 -0700 (PDT)
Message-ID: <4A60C593.1010201@sandeen.net>
Date: Fri, 17 Jul 2009 13:40:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: event tracing support
References: <20090616214844.GA12310@infradead.org>	<20090717145031.GA17590@infradead.org>
	<20090717180435.GA6561@infradead.org>
In-Reply-To: <20090717180435.GA6561@infradead.org>
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>

minor whitespace fixups for ya on top of that patch:

Index: linux-2.6.30.1/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6.30.1.orig/fs/xfs/linux-2.6/xfs_buf.h
+++ linux-2.6.30.1/fs/xfs/linux-2.6/xfs_buf.h
@@ -104,7 +104,7 @@ typedef enum {
 	{ XBF_DELWRI,		"DELWRI" }, \
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_FS_MANAGED,	"FS_MANAGED" }, \
- 	{ XBF_ORDERED,		"ORDERED" }, \
+	{ XBF_ORDERED,		"ORDERED" }, \
 	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
 	{ XBF_LOCK,		"LOCK" },  	/* should never be set */\
 	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* ditto */\
Index: linux-2.6.30.1/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6.30.1.orig/fs/xfs/linux-2.6/xfs_lrw.c
+++ linux-2.6.30.1/fs/xfs/linux-2.6/xfs_lrw.c
@@ -667,7 +667,7 @@ start:
 			need_i_mutex = 0;
 		}
 
- 		trace_xfs_rw(xip, count, *offset, ioflags, "write");
+		trace_xfs_rw(xip, count, *offset, ioflags, "write");
 		ret = generic_file_direct_write(iocb, iovp,
 				&segs, pos, offset, count, ocount);
 
Index: linux-2.6.30.1/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6.30.1.orig/fs/xfs/linux-2.6/xfs_trace.h
+++ linux-2.6.30.1/fs/xfs/linux-2.6/xfs_trace.h
@@ -107,7 +107,7 @@ TRACE_EVENT(xfs_attr_list,
 		   __entry->count,
 		   __entry->firstu,
 		   __entry->flags,
-	 	   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS)
+		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS)
 		   /* we currently miss out on the per-type a13/14/15 here */
 	)
 );
@@ -219,7 +219,7 @@ TRACE_EVENT(xfs_buf,
 		  __entry->hold,
 		  __entry->lockval,
 		  __entry->val,
-                  (unsigned long long)__entry->file_offset,
+		  (unsigned long long)__entry->file_offset,
 		  __entry->buffer_length,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
 		  (void *)__entry->caller_ip)
@@ -891,8 +891,8 @@ TRACE_EVENT(xfs_free_extent,
 		  __entry->len,
 		  __entry->isfl,
 		  __entry->haveleft ?
-		  	(__entry->haveright ? "both" : "left") :
-			 (__entry->haveright ? "right" : "none"))
+			(__entry->haveright ? "both" : "left") :
+			(__entry->haveright ? "right" : "none"))
 
 );
 
Index: linux-2.6.30.1/fs/xfs/xfs_trans.h
===================================================================
--- linux-2.6.30.1.orig/fs/xfs/xfs_trans.h
+++ linux-2.6.30.1/fs/xfs/xfs_trans.h
@@ -138,11 +138,11 @@ typedef struct xfs_trans_header {
 	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
 	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
 	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
-  	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
+	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
 	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
- 	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
- 	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
- 	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
+	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
+	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
+	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
 
 /*
  * This structure is used to track log items associated with

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
