Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 18:29:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6O1SQDW010534
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 18:28:38 -0700
Date: Mon, 24 Jul 2006 11:27:37 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: fix remount vs barrier options
Message-ID: <20060724112737.D2085715@wobbly.melbourne.sgi.com>
References: <20060721152807.D1998769@wobbly.melbourne.sgi.com> <20060723190650.GA22180@infradead.org> <20060724100147.F2083275@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060724100147.F2083275@wobbly.melbourne.sgi.com>; from nathans@sgi.com on Mon, Jul 24, 2006 at 10:01:48AM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, jeremy@sgi.com

On Mon, Jul 24, 2006 at 10:01:48AM +1000, Nathan Scott wrote:
> On Sun, Jul 23, 2006 at 08:06:50PM +0100, Christoph Hellwig wrote:
> > Shouldn't we make sure we clear all flags when reusing a log buffer?
> > Relying on clearing individual flags seems rather fragile to me.
> 
> *nod* - good idea.  I'll rework xlog_sync, and resend later.

After looking more, I'm less convinced.  There's some flags we wont
want to touch - the "internal" flags like PAGE_CACHE, etc (that one
is obviously not relevent here, but still, at some point a flag may
be introduced that we accidentally break by clearing all flags).

There is a ZEROFLAGS macro, I've added ORDERED to that and used it
instead.  I also fixed the double barrier issue for the split log
write case - here's an updated patch...

cheers.

-- 
Nathan


Index: xfs-linux/xfs_log.c
===================================================================
--- xfs-linux.orig/xfs_log.c	2006-07-21 08:55:24.520992250 +1000
+++ xfs-linux/xfs_log.c	2006-07-24 11:13:22.743144500 +1000
@@ -1444,7 +1444,7 @@ xlog_sync(xlog_t		*log,
 	ops = iclog->ic_header.h_num_logops;
 	INT_SET(iclog->ic_header.h_num_logops, ARCH_CONVERT, ops);
 
-	bp	    = iclog->ic_bp;
+	bp = iclog->ic_bp;
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, unsigned long) == (unsigned long)1);
 	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)2);
 	XFS_BUF_SET_ADDR(bp, BLOCK_LSN(INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT)));
@@ -1461,15 +1461,14 @@ xlog_sync(xlog_t		*log,
 	}
 	XFS_BUF_SET_PTR(bp, (xfs_caddr_t) &(iclog->ic_header), count);
 	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
+	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
 	/*
 	 * Do an ordered write for the log block.
-	 *
-	 * It may not be needed to flush the first split block in the log wrap
-	 * case, but do it anyways to be safe -AK
+	 * Its unnecessary to flush the first split block in the log wrap case.
 	 */
-	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
+	if (!split && (log->l_mp->m_flags & XFS_MOUNT_BARRIER))
 		XFS_BUF_ORDERED(bp);
 
 	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
@@ -1491,7 +1490,7 @@ xlog_sync(xlog_t		*log,
 		return error;
 	}
 	if (split) {
-		bp		= iclog->ic_log->l_xbuf;
+		bp = iclog->ic_log->l_xbuf;
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, unsigned long) ==
 							(unsigned long)1);
 		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)2);
@@ -1499,6 +1498,7 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
 					    (__psint_t)count), split);
 		XFS_BUF_SET_FSPRIVATE(bp, iclog);
+		XFS_BUF_ZEROFLAGS(bp);
 		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
Index: xfs-linux/linux-2.6/xfs_buf.h
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_buf.h	2006-07-24 11:04:17.203179750 +1000
+++ xfs-linux/linux-2.6/xfs_buf.h	2006-07-24 11:09:29.652577250 +1000
@@ -247,8 +247,8 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define BUF_BUSY		XBF_DONT_BLOCK
 
 #define XFS_BUF_BFLAGS(bp)	((bp)->b_flags)
-#define XFS_BUF_ZEROFLAGS(bp)	\
-	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI))
+#define XFS_BUF_ZEROFLAGS(bp)	((bp)->b_flags &= \
+		~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED))
 
 #define XFS_BUF_STALE(bp)	((bp)->b_flags |= XFS_B_STALE)
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XFS_B_STALE)
