Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E4D77F76
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 17:52:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4813AC004
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 15:52:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6z56WtutI9UQJerz for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 15:52:32 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 7/9] xfs: add xfs_verifier_error()
Date: Tue, 18 Feb 2014 17:52:27 -0600
Message-Id: <1392767549-25574-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
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
 fs/xfs/xfs_error.c |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_error.h |    1 +
 fs/xfs/xfs_linux.h |    1 +
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9995b80..8733c59 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -178,3 +178,29 @@ xfs_corruption_error(
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
+	/* XXX handle page-mapped buffers too? */
+	if (xfs_error_level >= XFS_ERRLEVEL_LOW && bp->b_addr) {
+		xfs_alert(mp, "First 64 bytes of corrupted metadata buffer:");
+		xfs_hex_dump(bp->b_addr, 64);
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
index e8fed74..016ea8d 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -179,6 +179,7 @@ typedef __uint64_t __psunsigned_t;
 #define ENOATTR		ENODATA		/* Attribute not found */
 #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
 #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
+#define EFSBADCRC	EILSEQ		/* Bad CRC detected */
 
 #define SYNCHRONIZE()	barrier()
 #define __return_address __builtin_return_address(0)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
