Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46418 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbcJYXFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:05:53 -0400
Subject: [PATCH 21/39] xfs_io: try to unshare copy-on-write blocks via
 fallocate
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:05:49 -0700
Message-ID: <147743674989.11035.3299885515631848323.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Wire up the "unshare" flag to the xfs_io fallocate command.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/prealloc.c     |   42 ++++++++++++++++++++++++++++++++++++++++--
 man/man8/xfs_io.8 |    5 +++++
 2 files changed, 45 insertions(+), 2 deletions(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 7f5c200..a9d66cc 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -40,6 +40,10 @@
 #define FALLOC_FL_INSERT_RANGE 0x20
 #endif
 
+#ifndef FALLOC_FL_UNSHARE_RANGE
+#define FALLOC_FL_UNSHARE_RANGE 0x40
+#endif
+
 static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
@@ -181,6 +185,7 @@ falloc_help(void)
 " -i -- inserts a hole into the given range of the file.\n"
 " -k -- do not change file size.\n"
 " -p -- unmap the given range from the file.\n"
+" -u -- unshare shared extents in the given range.\n"
 "\n"));
 }
 
@@ -193,7 +198,7 @@ fallocate_f(
 	int		mode = 0;
 	int		c;
 
-	while ((c = getopt(argc, argv, "cikp")) != EOF) {
+	while ((c = getopt(argc, argv, "cikpu")) != EOF) {
 		switch (c) {
 		case 'c':
 			mode = FALLOC_FL_COLLAPSE_RANGE;
@@ -207,6 +212,9 @@ fallocate_f(
 		case 'p':
 			mode = FALLOC_FL_PUNCH_HOLE;
 			break;
+		case 'u':
+			mode = FALLOC_FL_UNSHARE_RANGE;
+			break;
 		default:
 			command_usage(&falloc_cmd);
 		}
@@ -306,6 +314,26 @@ fzero_f(
 	}
 	return 0;
 }
+
+static int
+funshare_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_UNSHARE_RANGE;
+	int		index = 1;
+
+	if (!offset_length(argv[index], argv[index + 1], &segment))
+		return 0;
+
+	if (fallocate(file->fd, mode,
+			segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		return 0;
+	}
+	return 0;
+}
 #endif	/* HAVE_FALLOCATE */
 
 void
@@ -366,7 +394,7 @@ prealloc_init(void)
 	falloc_cmd.argmin = 2;
 	falloc_cmd.argmax = -1;
 	falloc_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	falloc_cmd.args = _("[-c] [-k] [-p] off len");
+	falloc_cmd.args = _("[-c] [-k] [-p] [-u] off len");
 	falloc_cmd.oneline =
 	_("allocates space associated with part of a file via fallocate");
 	falloc_cmd.help = falloc_help;
@@ -411,5 +439,15 @@ prealloc_init(void)
 	fzero_cmd.oneline =
 	_("zeroes space and eliminates holes by preallocating");
 	add_command(&fzero_cmd);
+
+	fzero_cmd.name = "funshare";
+	fzero_cmd.cfunc = funshare_f;
+	fzero_cmd.argmin = 2;
+	fzero_cmd.argmax = 2;
+	fzero_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	fzero_cmd.args = _("off len");
+	fzero_cmd.oneline =
+	_("unshares shared blocks within the range");
+	add_command(&fzero_cmd);
 #endif	/* HAVE_FALLOCATE */
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 2365550..eb7b878 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -431,6 +431,11 @@ the FALLOC_FL_PUNCH_HOLE flag as described in the
 .BR fallocate (2)
 manual page.
 .TP
+.BI funshare " offset length"
+Call fallocate with FALLOC_FL_UNSHARE_RANGE flag as described in the
+.BR fallocate (2)
+manual page to unshare all shared blocks within the range.
+.TP
 .BI fzero " offset length"
 Call fallocate with FALLOC_FL_ZERO_RANGE flag as described in the
 .BR fallocate (2)

