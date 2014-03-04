Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEA417F66
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8EE3DAC002
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:20 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	u5o1YDYhCt0wpZ4d for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:19 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006Hd-OQ
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006zj-NB
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/13] libxfs: add xfs_verifier_error()
Date: Tue,  4 Mar 2014 19:51:54 +1100
Message-Id: <1393923117-9559-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
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

[userspace port]

We want to distinguish between corruption, CRC errors,
etc.  In addition, the full stack trace on verifier errors
seems less than helpful; it looks more like an oops than
corruption.

Create a new function to specifically alert the user to
verifier errors, which can differentiate between
EFSCORRUPTED and CRC mismatches.  It doesn't dump stack
unless the xfs error level is turned up high.

Define a new error message (EFSBADCRC) to clearly identify
CRC errors.  (Defined to EBADMSG, bad message)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/darwin.h      |  1 +
 include/freebsd.h     |  1 +
 include/gnukfreebsd.h |  1 +
 include/irix.h        |  2 ++
 include/linux.h       |  1 +
 libxfs/util.c         | 13 +++++++++++++
 libxfs/xfs.h          |  1 +
 7 files changed, 20 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index 97b8990..95f865b 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -150,6 +150,7 @@ typedef unsigned char	uchar_t;
 
 #define ENOATTR		989     /* Attribute not found */
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
+#define EFSBADCRC	991	/* Bad CRC detected */
 #define constpp		char * const *
 
 #define HAVE_FID	1
diff --git a/include/freebsd.h b/include/freebsd.h
index 2e1ae49..b51688b 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -45,6 +45,7 @@
 #define constpp	char * const *
 
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
+#define EFSBADCRC	991	/* Bad CRC detected */
 
 typedef off_t		xfs_off_t;
 typedef off_t		off64_t;
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 1ec291f..2140acd 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -36,6 +36,7 @@
 #define constpp	char * const *
 
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
+#define EFSBADCRC	991	/* Bad CRC detected */
 
 typedef off_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
diff --git a/include/irix.h b/include/irix.h
index a450684..5040451 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -52,6 +52,8 @@ typedef char*		xfs_caddr_t;
 #define xfs_flock64	flock64
 #define xfs_flock64_t	struct flock64
 
+#define EFSBADCRC	991	/* Bad CRC detected */
+
 typedef struct xfs_error_injection {
 	__int32_t	fd;
 	__int32_t	errtag;
diff --git a/include/linux.h b/include/linux.h
index 502fd1f..5586290 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -136,6 +136,7 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 
 #define ENOATTR		ENODATA	/* Attribute not found */
 #define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
+#define EFSBADCRC	EBADMSG	/* Bad CRC detected */
 
 typedef loff_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
diff --git a/libxfs/util.c b/libxfs/util.c
index 8109ab3..1b05540 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -730,3 +730,16 @@ cmn_err(int level, char *fmt, ...)
 	fputs("\n", stderr);
 	va_end(ap);
 }
+
+/*
+ * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
+ * values, and omit the stack trace unless the error level is tuned high.
+ */
+void
+xfs_verifier_error(
+	struct xfs_buf		*bp)
+{
+	xfs_alert(NULL, "Metadata %s detected at block 0x%llx/0x%x",
+		  bp->b_error == EFSBADCRC ? "CRC error" : "corruption",
+		  bp->b_bn, BBTOB(bp->b_length));
+}
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 364fd83..5a21590 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -449,3 +449,4 @@ int  xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 void xfs_trans_mod_sb(xfs_trans_t *, uint, long);
 void xfs_trans_init(struct xfs_mount *);
 int  xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
+void xfs_verifier_error(struct xfs_buf *bp);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
