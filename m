Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 15:08:20 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1LN8Dfk005457
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 15:08:16 -0800
Date: Fri, 22 Feb 2008 10:08:34 +1100
From: David Chinner <dgc@sgi.com>
Subject: [RFC, patch 1/2] Allow up to 1GB logs in mkfs.xfs
Message-ID: <20080221230833.GG155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Increase the maximum log size supported by mkfs.

The log size can be increased easily in mkfs by changing a few
defines and a couple of types to allow the log size to increase to
1GB. Theoretically, the log size can be made much, much larger than
this (up to 2^32 sectors), but going beyond 2^30 *bytes* causes
integer overflow issues in the kernel log code.

e.g. a 2GB log (2^31 bytes) will not mount because the
space calculations in the kernel use "int" types and
overflow:

STATIC int
xlog_space_left(xlog_t *log, int cycle, int bytes)

Hence logs larger than 2^30 will not work without kernel
modifications.  Therefore this change is limited to increasing the
log size to what we can currently support in kernel space with
needing kernel modifications.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfsprogs/include/xfs_fs.h |    8 ++++----
 xfsprogs/mkfs/xfs_mkfs.c  |   14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

Index: xfs-cmds/xfsprogs/include/xfs_fs.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_fs.h	2008-02-19 11:38:24.333887808 +1100
+++ xfs-cmds/xfsprogs/include/xfs_fs.h	2008-02-19 18:16:21.701796360 +1100
@@ -248,10 +248,10 @@ typedef struct xfs_fsop_resblks {
  * Minimum and maximum sizes need for growth checks
  */
 #define XFS_MIN_AG_BLOCKS	64
-#define XFS_MIN_LOG_BLOCKS	512
-#define XFS_MAX_LOG_BLOCKS	(64 * 1024)
-#define XFS_MIN_LOG_BYTES	(256 * 1024)
-#define XFS_MAX_LOG_BYTES	(128 * 1024 * 1024)
+#define XFS_MIN_LOG_BLOCKS	512ULL
+#define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
+#define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
+#define XFS_MAX_LOG_BYTES	(1 * 1024 * 1024 * 1024ULL)
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
Index: xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c
===================================================================
--- xfs-cmds.orig/xfsprogs/mkfs/xfs_mkfs.c	2008-02-07 20:14:08.000000000 +1100
+++ xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c	2008-02-22 09:56:14.307824979 +1100
@@ -362,13 +362,13 @@ validate_log_size(__uint64_t logblocks, 
 	}
 	if (logblocks > XFS_MAX_LOG_BLOCKS) {
 		fprintf(stderr,
-	_("log size %lld blocks too large, maximum size is %d blocks\n"),
+	_("log size %lld blocks too large, maximum size is %lld blocks\n"),
 			(long long)logblocks, XFS_MAX_LOG_BLOCKS);
 		usage();
 	}
 	if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
 		fprintf(stderr,
-	_("log size %lld bytes too large, maximum size is %d bytes\n"),
+	_("log size %lld bytes too large, maximum size is %lld bytes\n"),
 			(long long)(logblocks << blocklog), XFS_MAX_LOG_BYTES);
 		usage();
 	}
@@ -1728,7 +1728,7 @@ reported by the device (%u).\n"),
 	min_logblocks = max_tr_res * XFS_MIN_LOG_FACTOR;
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
-		min_logblocks = MAX(min_logblocks, (10*1024*1024)>>blocklog);
+		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
 	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
@@ -1748,10 +1748,10 @@ _("size %s specified for log subvolume i
 		logblocks = 0;
 	} else if (loginternal && !logsize) {
 		/*
-		 * logblocks grows from min_logblocks to XFS_MAX_LOG_BLOCKS
-		 * at 128GB
-		 *
-		 * 2048 = 128GB / MAX_LOG_BYTES
+		 * With a 1GB max log size, default to maximum size
+		 * at 2TB. This keeps the same ratio from the older
+		 * max log size of 128M at 256GB fs size. IOWs,
+		 * the ratio of fs size to log size is 2048:1.
 		 */
 		logblocks = (dblocks << blocklog) / 2048;
 		logblocks = logblocks >> blocklog;
