Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 21:12:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K4C4bm027783
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 21:12:05 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id E7F961801056F
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 23:12:07 -0500 (CDT)
Message-ID: <46A03617.3060009@sandeen.net>
Date: Thu, 19 Jul 2007 23:12:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/7] - choose single default logbuf count & size 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Remove sizing of logbuf size & count based on physical memory;
this was never a very good gauge as it's looking at global
memory, but deciding on sizing per-filesystem; no account
is made of the total number of filesystems, for example.

For now just take the largest "default" case, as was set
for machines with >400MB - 8 x 32k buffers.  This can
always be tuned higher or lower with mount options
if necessary.  Removes one more user of xfs_physmem.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/xfs_log.c
===================================================================
--- linux.orig/fs/xfs/xfs_log.c
+++ linux/fs/xfs/xfs_log.c
@@ -1025,10 +1025,7 @@ xlog_bdstrat_cb(struct xfs_buf *bp)
 /*
  * Return size of each in-core log record buffer.
  *
- * Low memory machines only get 2 16KB buffers.  We don't want to waste
- * memory here.  However, all other machines get at least 2 32KB buffers.
- * The number is hard coded because we don't care about the minimum
- * memory size, just 32MB systems.
+ * All machines get 8 x 32KB buffers by default, unless tuned otherwise.
  *
  * If the filesystem blocksize is too large, we may need to choose a
  * larger size since the directory code currently logs entire blocks.
@@ -1041,17 +1038,10 @@ xlog_get_iclog_buffer_size(xfs_mount_t	*
 	int size;
 	int xhdrs;
 
-	if (mp->m_logbufs <= 0) {
-		if (xfs_physmem <= btoc(128*1024*1024)) {
-			log->l_iclog_bufs = XLOG_MIN_ICLOGS;
-		} else if (xfs_physmem <= btoc(400*1024*1024)) {
-			log->l_iclog_bufs = XLOG_MED_ICLOGS;
-		} else {	/* 256K with 32K bufs */
-			log->l_iclog_bufs = XLOG_MAX_ICLOGS;
-		}
-	} else {
+	if (mp->m_logbufs <= 0)
+		log->l_iclog_bufs = XLOG_MAX_ICLOGS;
+	else
 		log->l_iclog_bufs = mp->m_logbufs;
-	}
 
 	/*
 	 * Buffer size passed in from mount system call.
@@ -1082,18 +1072,9 @@ xlog_get_iclog_buffer_size(xfs_mount_t	*
 		goto done;
 	}
 
-	/*
-	 * Special case machines that have less than 32MB of memory.
-	 * All machines with more memory use 32KB buffers.
-	 */
-	if (xfs_physmem <= btoc(32*1024*1024)) {
-		/* Don't change; min configuration */
-		log->l_iclog_size = XLOG_RECORD_BSIZE;		/* 16k */
-		log->l_iclog_size_log = XLOG_RECORD_BSHIFT;
-	} else {
-		log->l_iclog_size = XLOG_BIG_RECORD_BSIZE;	/* 32k */
-		log->l_iclog_size_log = XLOG_BIG_RECORD_BSHIFT;
-	}
+	/* All machines use 32KB buffers by default. */
+	log->l_iclog_size = XLOG_BIG_RECORD_BSIZE;
+	log->l_iclog_size_log = XLOG_BIG_RECORD_BSHIFT;
 
 	/* the default log size is 16k or 32k which is one header sector */
 	log->l_iclog_hsize = BBSIZE;
Index: linux/fs/xfs/xfs_log_priv.h
===================================================================
--- linux.orig/fs/xfs/xfs_log_priv.h
+++ linux/fs/xfs/xfs_log_priv.h
@@ -30,7 +30,6 @@ struct xfs_mount;
  */
 
 #define XLOG_MIN_ICLOGS		2
-#define XLOG_MED_ICLOGS		4
 #define XLOG_MAX_ICLOGS		8
 #define XLOG_HEADER_MAGIC_NUM	0xFEEDbabe	/* Invalid cycle number */
 #define XLOG_VERSION_1		1
