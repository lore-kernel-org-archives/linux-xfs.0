Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36115 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbcLEUjv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 15:39:51 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] xfs_io: support -c "open foo" command
Date: Mon,  5 Dec 2016 22:39:26 +0200
Message-Id: <1480970366-23648-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

There is an undocumented and possibly unused feature in xfs_io
where all commands are executed per file when multiple files
are provided in the args list.

This feature creates ambiguity when trying to execute commands
such as "open" and "file" from command line and result in an
endless loop in the command loop code, e.g.:

xfs_io -r -c "open -f bar" -c print foo
bar: Too many open files
[000] foo            (foreign,non-sync,non-direct,read-only)
 001  bar            (foreign,non-sync,non-direct,read-write)
 002  bar            (foreign,non-sync,non-direct,read-write)
 003  bar            (foreign,non-sync,non-direct,read-write)
 004  bar            (foreign,non-sync,non-direct,read-write)
 005  bar            (foreign,non-sync,non-direct,read-write)
 006  bar            (foreign,non-sync,non-direct,read-write)

Also, when running xfs_io -c <cmd> without any file args, xfs_io
exits without doing anything. This behavior is also undocumented
and makes very little sense.

Change the behavior of xfs_io to accept zero or one file in args
list and forbid multiple files in args list. If more than a single
file is given in args list, xfs_io exits and prints usage info.
The usage info and man page were both modified to reflect this change.

Commands given with -c <cmd> are executed exactly once, regardless
if a file was provided in args list or not. This enables writing
proper xfs_io scripts in command line, which include "open" and
"file" commands.

This change does not modify the behavior of xfs_io in the most
commonly used case of single file argument in command line and
no "open" and "file" commands in command line.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 io/init.c         | 15 ++++++++++-----
 man/man8/xfs_io.8 |  3 ++-
 2 files changed, 12 insertions(+), 6 deletions(-)

v3:
- Forbid multiple file args
- Update man page and usage to allow no file arg
- Add endless loop bug report to commit message

v2:
- Fix the case of multiple file args

v1:
- Fix the case of zero file args

diff --git a/io/init.c b/io/init.c
index a9191cf..d5993a4 100644
--- a/io/init.c
+++ b/io/init.c
@@ -34,7 +34,7 @@ void
 usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-adfinrRstVx] [-m mode] [-p prog] [-c cmd]... file\n"),
+		_("Usage: %s [-adfinrRstVx] [-m mode] [-p prog] [-c cmd]... [file]\n"),
 		progname);
 	exit(1);
 }
@@ -90,14 +90,15 @@ init_commands(void)
 	cowextsize_init();
 }
 
+/*
+ * Return true for first call and false for the next call,
+ * to execute each command once.
+ */
 static int
 init_args_command(
 	int	index)
 {
-	if (index >= filecount)
-		return 0;
-	file = &filetable[index++];
-	return index;
+	return !index;
 }
 
 static int
@@ -203,6 +204,10 @@ init(
 		}
 	}
 
+	/* Multiple file args is not supported */
+	if (optind + 1 < argc)
+		usage();
+
 	while (optind < argc) {
 		if ((c = openfile(argv[optind], &geometry, flags, mode)) < 0)
 			exit(1);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 885df7f..a0c6d17 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -11,8 +11,9 @@ xfs_io \- debug the I/O path of an XFS filesystem
 ] ... [
 .B \-p
 .I prog
-]
+] [
 .I file
+]
 .br
 .B xfs_io \-V
 .SH DESCRIPTION
-- 
2.7.4

