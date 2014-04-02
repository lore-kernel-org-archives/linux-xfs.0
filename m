Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4EB0329DF9
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 10:33:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2380F304032
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 08:33:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YNAGcqA0bKRyC2Nm for
	<xfs@oss.sgi.com>; Wed, 02 Apr 2014 08:33:28 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] fsstress: Add fallocate collapse range operation
Date: Wed,  2 Apr 2014 17:33:20 +0200
Message-Id: <1396452800-25775-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1396452800-25775-1-git-send-email-lczerner@redhat.com>
References: <1396452800-25775-1-git-send-email-lczerner@redhat.com>
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
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

This commit adds collapse operation support for fsstress, which is
meant to exercise fallocate FALLOC_FL_COLLAPSE_RANGE support.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsstress.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index fd258bf..1eec11a 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -71,6 +71,7 @@ typedef enum {
 	OP_MKNOD,
 	OP_PUNCH,
 	OP_ZERO,
+	OP_COLLAPSE,
 	OP_READ,
 	OP_READLINK,
 	OP_RENAME,
@@ -168,6 +169,7 @@ void	mkdir_f(int, long);
 void	mknod_f(int, long);
 void	punch_f(int, long);
 void	zero_f(int, long);
+void	collapse_f(int, long);
 void	read_f(int, long);
 void	readlink_f(int, long);
 void	rename_f(int, long);
@@ -206,6 +208,7 @@ opdesc_t	ops[] = {
 	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
 	{ OP_PUNCH, "punch", punch_f, 1, 1 },
 	{ OP_ZERO, "zero", zero_f, 1, 1 },
+	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
 	{ OP_READ, "read", read_f, 1, 0 },
 	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
@@ -2173,6 +2176,7 @@ struct print_flags falloc_flags [] = {
 	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
 	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
+	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ -1, NULL}
 };
 
@@ -2223,6 +2227,14 @@ do_fallocate(int opno, long r, int mode)
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
 	len = (off64_t)(random() % (1024 * 1024));
+	/*
+	 * Collapse range requires off and len to be block aligned, make it
+	 * more likely to be the case.
+	 */
+	if (FALLOC_FL_COLLAPSE_RANGE && (opno % 2)) {
+		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
+		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
+	}
 	mode |= FALLOC_FL_KEEP_SIZE & random();
 	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
 	if (v)
@@ -2637,6 +2649,14 @@ zero_f(int opno, long r)
 }
 
 void
+collapse_f(int opno, long r)
+{
+#ifdef HAVE_LINUX_FALLOC_H
+	do_fallocate(opno, r, FALLOC_FL_COLLAPSE_RANGE);
+#endif
+}
+
+void
 read_f(int opno, long r)
 {
 	char		*buf;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
