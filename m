Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B6BF7FE9
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 20:58:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 31BB48F8081
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 18:58:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vPlc6ZkriPkSUFgk for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 18:58:12 -0800 (PST)
Message-ID: <53056F43.7070005@sandeen.net>
Date: Wed, 19 Feb 2014 20:58:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 7/9 V2] xfs: add xfs_verifier_error()
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1392767549-25574-8-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

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

V2: Switch to EBADMSG, use xfs_buf_offset()

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9995b80..a8b2ecb 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -178,3 +178,28 @@ xfs_corruption_error(
 	xfs_error_report(tag, level, mp, filename, linenum, ra);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
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
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+
+	xfs_alert(mp, "Metadata %s detected at %pF, block 0x%llx",
+		  bp->b_error == EFSBADCRC ? "CRC error" : "corruption",
+		  __return_address, bp->b_bn);
+
+	xfs_alert(mp, "Unmount and run xfs_repair");
+
+	if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
+		xfs_alert(mp, "First 64 bytes of corrupted metadata buffer:");
+		xfs_hex_dump(xfs_buf_offset(bp, 0), 64);
+	}
+
+	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
+		xfs_stack_trace();
+}
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 079a367..c1c57d4 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -34,6 +34,7 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, void *p, const char *filename,
 			int linenum, inst_t *ra);
+extern void xfs_verifier_error(struct xfs_buf *bp);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
 	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index e8fed74..825249d 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -179,6 +179,7 @@ typedef __uint64_t __psunsigned_t;
 #define ENOATTR		ENODATA		/* Attribute not found */
 #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
 #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
+#define EFSBADCRC	EBADMSG		/* Bad CRC detected */
 
 #define SYNCHRONIZE()	barrier()
 #define __return_address __builtin_return_address(0)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
