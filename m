Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40032 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438164AbfBNKBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 05:01:12 -0500
Received: by mail-pf1-f193.google.com with SMTP id h1so2847510pfo.7
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:12 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] xfs_io: add AT_UTIME_BTIME support
Date: Thu, 14 Feb 2019 02:00:16 -0800
Message-Id: <347edcff487b59d56844f51eb74a42220fac64c9.1550138137.git.osandov@fb.com>
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

In order to test updating btime, make the utimes command optionally take
the btime timestamp.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 io/utimes.c       | 41 +++++++++++++++++++++++++++++++----------
 man/man8/xfs_io.8 |  5 +++--
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/io/utimes.c b/io/utimes.c
index 40117472..72ce68f3 100644
--- a/io/utimes.c
+++ b/io/utimes.c
@@ -4,11 +4,18 @@
  * All Rights Reserved.
  */
 
+#include <fcntl.h>
+#include <sys/syscall.h>
+
 #include "command.h"
 #include "input.h"
 #include "init.h"
 #include "io.h"
 
+#ifndef AT_UTIME_BTIME
+#define AT_UTIME_BTIME 0x8000
+#endif
+
 static cmdinfo_t utimes_cmd;
 
 static void
@@ -16,9 +23,10 @@ utimes_help(void)
 {
 	printf(_(
 "\n"
-" Update file atime and mtime of the current file with nansecond precision.\n"
+" Update file atime, mtime, and optionally btime of the current file with\n"
+" nansecond precision.\n"
 "\n"
-" Usage: utimes atime_sec atime_nsec mtime_sec mtime_nsec.\n"
+" Usage: utimes atime_sec atime_nsec mtime_sec mtime_nsec [btime_sec btime_nsec]\n"
 " *_sec: Seconds elapsed since 1970-01-01 00:00:00 UTC.\n"
 " *_nsec: Nanoseconds since the corresponding *_sec.\n"
 "\n"));
@@ -29,9 +37,13 @@ utimes_f(
 	int		argc,
 	char		**argv)
 {
-	struct timespec t[2];
+	struct timespec t[3];
+	int flags = 0;
 	int result;
 
+	if (argc == 6)
+		return command_usage(&utimes_cmd);
+
 	/* Get the timestamps */
 	result = timespec_from_string(argv[1], argv[2], &t[0]);
 	if (result) {
@@ -43,13 +55,22 @@ utimes_f(
 		fprintf(stderr, "Bad value for mtime\n");
 		return 0;
 	}
-
-	/* Call futimens to update time. */
-	if (futimens(file->fd, t)) {
-		perror("futimens");
-		return 0;
+	if (argc == 7) {
+		result = timespec_from_string(argv[5], argv[6], &t[2]);
+		if (result) {
+			fprintf(stderr, "Bad value for btime\n");
+			return 0;
+		}
+		flags |= AT_UTIME_BTIME;
 	}
 
+	/*
+	 * Use syscall() because the glibc wrapper for utimensat() disallows a
+	 * NULL pathname.
+	 */
+	if (syscall(SYS_utimensat, file->fd, NULL, t, flags))
+		perror("utimensat");
+
 	return 0;
 }
 
@@ -59,9 +80,9 @@ utimes_init(void)
 	utimes_cmd.name = "utimes";
 	utimes_cmd.cfunc = utimes_f;
 	utimes_cmd.argmin = 4;
-	utimes_cmd.argmax = 4;
+	utimes_cmd.argmax = 6;
 	utimes_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	utimes_cmd.args = _("atime_sec atime_nsec mtime_sec mtime_nsec");
+	utimes_cmd.args = _("atime_sec atime_nsec mtime_sec mtime_nsec [btime_sec btime_nsec]");
 	utimes_cmd.oneline = _("Update file times of the current file");
 	utimes_cmd.help = utimes_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index fbf50df5..dbf8098b 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -827,8 +827,9 @@ verbose output will be printed.
 .RE
 .PD
 .TP
-.BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec"
-The utimes command changes the atime and mtime of the current file.
+.BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec [btime_sec btime_nsec]"
+The utimes command changes the atime, mtime, and optionally btime of the
+current file.
 sec uses UNIX timestamp notation and is the seconds elapsed since
 1970-01-01 00:00:00 UTC.
 nsec is the nanoseconds since the sec. This value needs to be in
-- 
2.20.1
