Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4879 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725778AbeLBUxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 15:53:54 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gTYkM-0002gC-AG
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 07:53:46 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gTYkM-0001sC-9C
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 07:53:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs_io: allow open file permissions to be changed
Date: Mon,  3 Dec 2018 07:53:43 +1100
Message-Id: <20181202205343.7104-3-david@fromorbit.com>
In-Reply-To: <20181202205343.7104-1-david@fromorbit.com>
References: <20181202205343.7104-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 io/open.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/io/open.c b/io/open.c
index b1d9a0fa317c..153d4a836d4c 100644
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
-- 
2.19.1
