Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 21:12:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K4CObm027981
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 21:12:26 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 009F01801056F
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 23:12:27 -0500 (CDT)
Message-ID: <46A0362B.4090503@sandeen.net>
Date: Thu, 19 Jul 2007 23:12:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 6/7] - clean up xfs_start_flags
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

xfs_start_flags can make use of is_power_of_2 to
tidy up the test a little bit.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/xfs_log_priv.h
===================================================================
--- linux.orig/fs/xfs/xfs_log_priv.h
+++ linux/fs/xfs/xfs_log_priv.h
@@ -35,11 +35,11 @@ struct xfs_mount;
 #define XLOG_VERSION_1		1
 #define XLOG_VERSION_2		2		/* Large IClogs, Log sunit */
 #define XLOG_VERSION_OKBITS	(XLOG_VERSION_1 | XLOG_VERSION_2)
-#define XLOG_RECORD_BSIZE	(16*1024)	/* eventually 32k */
+#define XLOG_MIN_RECORD_BSIZE	(16*1024)	/* eventually 32k */
 #define XLOG_BIG_RECORD_BSIZE	(32*1024)	/* 32k buffers */
 #define XLOG_MAX_RECORD_BSIZE	(256*1024)
 #define XLOG_HEADER_CYCLE_SIZE	(32*1024)	/* cycle data in header */
-#define XLOG_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
+#define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
 #define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
 #define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
 #define XLOG_BTOLSUNIT(log, b)  (((b)+(log)->l_mp->m_sb.sb_logsunit-1) / \
Index: linux/fs/xfs/xfs_vfsops.c
===================================================================
--- linux.orig/fs/xfs/xfs_vfsops.c
+++ linux/fs/xfs/xfs_vfsops.c
@@ -238,11 +238,9 @@ xfs_start_flags(
 	mp->m_logbufs = ap->logbufs;
 	if (ap->logbufsize != -1 &&
 	    ap->logbufsize !=  0 &&
-	    ap->logbufsize != 16 * 1024 &&
-	    ap->logbufsize != 32 * 1024 &&
-	    ap->logbufsize != 64 * 1024 &&
-	    ap->logbufsize != 128 * 1024 &&
-	    ap->logbufsize != 256 * 1024) {
+	    (ap->logbufsize < XLOG_MIN_RECORD_BSIZE ||
+	     ap->logbufsize > XLOG_MAX_RECORD_BSIZE ||
+	     !is_power_of_2(ap->logbufsize))) {
 		cmn_err(CE_WARN,
 	"XFS: invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
 			ap->logbufsize);
