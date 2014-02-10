Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 51B5A7F4E
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 20:33:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6EDEAC002
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 18:33:52 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7fQGmEl0SHjyzWl2 for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 18:33:51 -0800 (PST)
Message-ID: <52F83A8D.7030506@sandeen.net>
Date: Sun, 09 Feb 2014 20:33:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 5/6] xfs: add xfs_verifier_error()
References: <52F83630.4020008@redhat.com>
In-Reply-To: <52F83630.4020008@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

We want to distinguish between corruption, CRC errors,
etc.  In addition, the full stack trace on verifier errors
seems less than helpful; it looks more like an oops than
corruption.  

Create a new function to specifically alert the user to
verifier errors, which can differentiate between
EFSCORRUPTED and CRC mismatches.  It doesn't dump stack
unless the xfs error level is turned up high.

Define a new error message (EFSBADCRC) to clearly identify
CRC errors.  (Defined to EILSEQ, bad byte sequence)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_error.c |   22 ++++++++++++++++++++++
 fs/xfs/xfs_error.h |    3 +++
 fs/xfs/xfs_linux.h |    1 +
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9995b80..08d76f4 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -178,3 +178,25 @@ xfs_corruption_error(
 	xfs_error_report(tag, level, mp, filename, linenum, ra);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
 }
+
+/*
+ * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
+ * values, and omit the stack trace unless the error level is tuned high.
+ */
+void
+__xfs_verifier_error(
+	const char		*func,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+
+	xfs_alert(mp,
+"%sCorruption detected in %s, block 0x%llx. Unmount and run xfs_repair",
+		  bp->b_error == EFSBADCRC ? "CRC " : "", func, bp->b_bn);
+
+        if (xfs_error_level >= XFS_ERRLEVEL_LOW)
+                xfs_hex_dump(bp->b_addr, 64);
+
+	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
+		xfs_stack_trace();
+}
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 079a367..f4315c2 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -34,12 +34,15 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, void *p, const char *filename,
 			int linenum, inst_t *ra);
+extern void __xfs_verifier_error(const char *func, struct xfs_buf *bp);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
 	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
 #define	XFS_CORRUPTION_ERROR(e, lvl, mp, mem)	\
 	xfs_corruption_error(e, lvl, mp, mem, \
 			     __FILE__, __LINE__, __return_address)
+#define	xfs_verifier_error(bp)	\
+	__xfs_verifier_error(__func__, bp)
 
 #define XFS_ERRLEVEL_OFF	0
 #define XFS_ERRLEVEL_LOW	1
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f9bb590..283b98b 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -178,6 +178,7 @@ typedef __uint64_t __psunsigned_t;
 #define ENOATTR		ENODATA		/* Attribute not found */
 #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
 #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
+#define EFSBADCRC	EILSEQ		/* Bad CRC detected */
 
 #define SYNCHRONIZE()	barrier()
 #define __return_address __builtin_return_address(0)
-- 1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
