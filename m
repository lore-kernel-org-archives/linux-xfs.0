Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:33980 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751636AbcLFGC4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 01:02:56 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4] xfs_io: support -c "open foo" command
Date: Tue,  6 Dec 2016 07:43:58 +0200
Message-Id: <1481003038-23740-1-git-send-email-amir73il@gmail.com>
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

Change the behavior of xfs_io, so commands given with -c <cmd>
are executed exactly once, regardless of the number of file args.
This enables writing proper xfs_io scripts in command line, which
include "open" and "file" commands.

Update the man page and usage to reflect the fact that multiple
as well as zero file args can be given in args list.

This change does not modify the behavior of xfs_io in the most
commonly used case of single file argument in command line and
no "open" and "file" commands in command line.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 io/init.c         | 11 ++++++-----
 man/man8/xfs_io.8 |  9 +++++++--
 2 files changed, 13 insertions(+), 7 deletions(-)

v4:
- Allow multiple file args
- Update man page and usage to allow multiple file args
  and spell out the expected behavior in this case

v3:
- Forbid multiple file args
- Update man page and usage to allow no file arg
- Add endless loop bug report to commit message

v2:
- Fix the case of multiple file args

v1:
- Fix the case of zero file args

diff --git a/io/init.c b/io/init.c
index a9191cf..54b998c 100644
--- a/io/init.c
+++ b/io/init.c
@@ -34,7 +34,7 @@ void
 usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-adfinrRstVx] [-m mode] [-p prog] [-c cmd]... file\n"),
+		_("Usage: %s [-adfinrRstVx] [-m mode] [-p prog] [-c cmd]... [file]...\n"),
 		progname);
 	exit(1);
 }
@@ -90,14 +90,15 @@ init_commands(void)
 	cowextsize_init();
 }
 
+/*
+ * Return true for first call and false for the next call,
+ * to execute each command just once.
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
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 885df7f..f61eee6 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -11,8 +11,9 @@ xfs_io \- debug the I/O path of an XFS filesystem
 ] ... [
 .B \-p
 .I prog
-]
+] [
 .I file
+] ...
 .br
 .B xfs_io \-V
 .SH DESCRIPTION
@@ -42,7 +43,11 @@ the default value is
 .B \-f
 Create
 .I file
-if it does not already exist.
+if it does not already exist. Multiple
+.I file
+arguments may be given. The files are open before the
+.B \-c
+commands are executed.
 .TP
 .B \-r
 Open
-- 
2.7.4

