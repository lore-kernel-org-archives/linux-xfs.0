Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 16:35:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAM0Z8oh011661
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 16:35:10 -0800
Date: Thu, 22 Nov 2007 11:35:12 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 3/9] Use _META bio I/O types for metadata I/O
Message-ID: <20071122003512.GI114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>

Improve metadata I/O merging in the elevator

Change all async metadata buffers to use [READ|WRITE]_META I/O types
so that the I/O doesn't get issued immediately. This allows merging
of adjacent metadata requests but still prioritises them over bulk
data. This shows a 10-15% improvement in sequential create speed of
small files.

Don't include the log buffers in this classification - leave them
as sync types so they are issued immediately.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    6 +++++-
 include/linux/fs.h         |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-11-22 10:53:11.556186722 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-11-22 10:53:43.748024392 +1100
@@ -1175,10 +1175,14 @@ _xfs_buf_ioapply(
 	if (bp->b_flags & XBF_ORDERED) {
 		ASSERT(!(bp->b_flags & XBF_READ));
 		rw = WRITE_BARRIER;
-	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
+	} else if (bp->b_flags & XBF_LOG_BUFFER) {
 		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
 		bp->b_flags &= ~_XBF_RUN_QUEUES;
 		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
+	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
+		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
+		bp->b_flags &= ~_XBF_RUN_QUEUES;
+		rw = (bp->b_flags & XBF_WRITE) ? WRITE_META : READ_META;
 	} else {
 		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
 		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
Index: 2.6.x-xfs-new/include/linux/fs.h
===================================================================
--- 2.6.x-xfs-new.orig/include/linux/fs.h	2007-11-22 10:47:21.965392742 +1100
+++ 2.6.x-xfs-new/include/linux/fs.h	2007-11-22 10:53:43.748024392 +1100
@@ -83,6 +83,7 @@ extern int dir_notify_enable;
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNC))
 #define READ_META	(READ | (1 << BIO_RW_META))
 #define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNC))
+#define WRITE_META	(WRITE | (1 << BIO_RW_META))
 #define WRITE_BARRIER	((1 << BIO_RW) | (1 << BIO_RW_BARRIER))
 
 #define SEL_IN		1
