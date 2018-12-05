Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:30691 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbeLEEQY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 23:16:24 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gUOOI-0006KF-Hl
        for linux-xfs@vger.kernel.org; Wed, 05 Dec 2018 15:02:26 +1100
Date: Wed, 5 Dec 2018 15:02:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2 V2] xfs_io: allow open file permissions to be changed
Message-ID: <20181205040226.GS6311@dastard>
References: <20181202205343.7104-1-david@fromorbit.com>
 <20181202205343.7104-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181202205343.7104-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

I need to be able to open a file read-write, then change the
permissions on the file to read-only to check that copy_file_range
returns EPERM correctly in that case. This can't be done as root,
because root ignores file permissions, but as a normal user we can't
open a 0444 file for writing and so can't actually test writing to
a read-only file without some method of "open read-write, change
permissions to read-only, try to write to file through open
read-write file".

So, allow adding or removing write permissions on an open file.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
Version 2:
- include a man page update from the new function

 io/open.c         | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |  9 +++++++++
 2 files changed, 63 insertions(+)

diff --git a/io/open.c b/io/open.c
index 21c0e054f8d2..2663c38e9681 100644
--- a/io/open.c
+++ b/io/open.c
@@ -44,6 +44,7 @@ static cmdinfo_t chproj_cmd;
 static cmdinfo_t lsproj_cmd;
 static cmdinfo_t extsize_cmd;
 static cmdinfo_t inode_cmd;
+static cmdinfo_t chmod_cmd;
 static prid_t prid;
 static long extsize;
 
@@ -809,6 +810,48 @@ inode_f(
 	return 0;
 }
 
+static void
+chmod_help(void)
+{
+	printf(_(
+"\n"
+" Change the read/write permissions on the current file\n"
+"\n"
+" Options:\n"
+" -r -- make the file read only (0444 permissions)\n"
+" -w -- make the file read/write (0664 permissions)\n"
+"\n"));
+}
+
+static int
+chmod_f(
+	int		argc,
+	char		**argv)
+{
+	mode_t		mode = S_IRUSR | S_IRGRP | S_IROTH;
+	int		c;
+
+	while ((c = getopt(argc, argv, "rw")) != EOF) {
+		switch (c) {
+		case 'r':
+			break;
+		case 'w':
+			mode |= S_IWUSR | S_IWGRP;
+			break;
+		default:
+			return command_usage(&chmod_cmd);
+		}
+	}
+
+	if (argc != optind)
+		return command_usage(&chmod_cmd);
+
+	if (fchmod(file->fd, mode) < 0) {
+		exitcode = 1;
+		perror("fchmod");
+	}
+	return 0;
+}
 void
 open_init(void)
 {
@@ -871,10 +914,21 @@ open_init(void)
 		_("Query inode number usage in the filesystem");
 	inode_cmd.help = inode_help;
 
+	chmod_cmd.name = "chmod";
+	chmod_cmd.cfunc = chmod_f;
+	chmod_cmd.args = _("-r | -w");
+	chmod_cmd.argmin = 1;
+	chmod_cmd.argmax = 1;
+	chmod_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
+	chmod_cmd.oneline =
+		_("change the read/write permissios on the currently open file");
+	chmod_cmd.help = chmod_help;
+
 	add_command(&open_cmd);
 	add_command(&close_cmd);
 	add_command(&chproj_cmd);
 	add_command(&lsproj_cmd);
 	add_command(&extsize_cmd);
 	add_command(&inode_cmd);
+	add_command(&chmod_cmd);
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index f1099c32de66..68e03b4558b9 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1226,6 +1226,15 @@ characters long.
 .B crc32cselftest
 Test the internal crc32c implementation to make sure that it computes results
 correctly.
+.TP
+.B chmod \-r | \-w
+Change the mode of the currently open file. The
+.B \-r
+option will set the file permissions to read-only (0444), whilst the
+.B \-w
+option will set the file permissions to read-write (0644). This allows xfs_io to
+set up mismatches between the file permissions and the open file descriptor
+read/write mode to exercise permission checks inside various syscalls.
 .SH SEE ALSO
 .BR mkfs.xfs (8),
 .BR xfsctl (3),
