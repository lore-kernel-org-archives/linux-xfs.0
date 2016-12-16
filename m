Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6436 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756966AbcLPEpd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 23:45:33 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cHkKb-00023k-Pz
        for linux-xfs@vger.kernel.org; Fri, 16 Dec 2016 15:41:17 +1100
Received: from dave by discord.disaster.area with local (Exim 4.88)
        (envelope-from <david@fromorbit.com>)
        id 1cHkKb-0005Zl-Ov
        for linux-xfs@vger.kernel.org; Fri, 16 Dec 2016 15:41:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] libxcmd: check CMD_FLAG_GLOBAL inside args_command()
Date: Fri, 16 Dec 2016 15:41:10 +1100
Message-Id: <20161216044115.21287-2-david@fromorbit.com>
In-Reply-To: <20161216044115.21287-1-david@fromorbit.com>
References: <20161216044115.21287-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rather than having multiple methods of executing commands from the
CLI, use CMD_FLAG_GLOBAL to indicate a one-shot command rather than
an iterative command from args_command(). This simplifies the main
loop processing.

To make it more obvious what this CMD_FLAG_GLOBAL flag does, rename
it to CMD_FLAG_ONESHOT to indicate that the command should only ever
be executed once and not iterated.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 include/command.h |  7 ++++++-
 io/file.c         |  2 +-
 io/init.c         |  2 +-
 libxcmd/command.c | 20 +++++++++++++-------
 libxcmd/help.c    |  2 +-
 libxcmd/quit.c    |  2 +-
 quota/path.c      |  4 ++--
 quota/report.c    |  2 +-
 8 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/include/command.h b/include/command.h
index 81d5a4dbb7f3..58bfcaac44a0 100644
--- a/include/command.h
+++ b/include/command.h
@@ -20,7 +20,12 @@
 
 #include <sys/time.h>
 
-#define CMD_FLAG_GLOBAL		(1<<31)	/* don't iterate "args" */
+/*
+ * A "oneshot" command ony runs once per command execution. It does
+ * not iterate the command args function callout and so can be used
+ * for functions like "help" that should only ever be run once.
+ */
+#define CMD_FLAG_ONESHOT	(1<<31)
 #define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
 
 typedef int (*cfunc_t)(int argc, char **argv);
diff --git a/io/file.c b/io/file.c
index d4bc4f8fc1d5..8e3f07122922 100644
--- a/io/file.c
+++ b/io/file.c
@@ -104,7 +104,7 @@ file_init(void)
 	print_cmd.argmin = 0;
 	print_cmd.argmax = 0;
 	print_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK |
-				CMD_FLAG_GLOBAL;
+				CMD_FLAG_ONESHOT;
 	print_cmd.oneline = _("list current open files and memory mappings");
 
 	add_command(&file_cmd);
diff --git a/io/init.c b/io/init.c
index a9191cfa072d..ab40f3745390 100644
--- a/io/init.c
+++ b/io/init.c
@@ -104,7 +104,7 @@ static int
 init_check_command(
 	const cmdinfo_t	*ct)
 {
-	if (ct->flags & CMD_FLAG_GLOBAL)
+	if (ct->flags & CMD_FLAG_ONESHOT)
 		return 1;
 
 	if (!file && !(ct->flags & CMD_NOFILE_OK)) {
diff --git a/libxcmd/command.c b/libxcmd/command.c
index dd0034cc6d83..dce8361ce3ea 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -124,10 +124,20 @@ add_user_command(char *optarg)
 	cmdline[ncmdline-1] = optarg;
 }
 
+/*
+ * To detect one-shot commands, they will return a negative index. If we
+ * get a negative index on entry, we've already run the one-shot command,
+ * so we abort straight away.
+ */
 static int
 args_command(
-	int	index)
+	const cmdinfo_t	*ct,
+	int		index)
 {
+	if (index < 0)
+		return 0;
+	if (ct->flags & CMD_FLAG_ONESHOT)
+		return -1;
 	if (args_func)
 		return args_func(index);
 	return 0;
@@ -160,13 +170,9 @@ command_loop(void)
 		if (c) {
 			ct = find_command(v[0]);
 			if (ct) {
-				if (ct->flags & CMD_FLAG_GLOBAL)
+				j = 0;
+				while (!done && (j = args_command(ct, j)))
 					done = command(ct, c, v);
-				else {
-					j = 0;
-					while (!done && (j = args_command(j)))
-						done = command(ct, c, v);
-				}
 			} else
 				fprintf(stderr, _("command \"%s\" not found\n"),
 					v[0]);
diff --git a/libxcmd/help.c b/libxcmd/help.c
index 8894c7931f89..bc31d6df1d8a 100644
--- a/libxcmd/help.c
+++ b/libxcmd/help.c
@@ -89,7 +89,7 @@ help_init(void)
 	help_cmd.cfunc = help_f;
 	help_cmd.argmin = 0;
 	help_cmd.argmax = 1;
-	help_cmd.flags = CMD_FLAG_GLOBAL | CMD_ALL_FSTYPES;
+	help_cmd.flags = CMD_FLAG_ONESHOT | CMD_ALL_FSTYPES;
 	help_cmd.args = _("[command]");
 	help_cmd.oneline = _("help for one or all commands");
 
diff --git a/libxcmd/quit.c b/libxcmd/quit.c
index e0af91629b81..19431015aee2 100644
--- a/libxcmd/quit.c
+++ b/libxcmd/quit.c
@@ -39,7 +39,7 @@ quit_init(void)
 	quit_cmd.cfunc = quit_f;
 	quit_cmd.argmin = -1;
 	quit_cmd.argmax = -1;
-	quit_cmd.flags = CMD_FLAG_GLOBAL | CMD_ALL_FSTYPES;
+	quit_cmd.flags = CMD_FLAG_ONESHOT | CMD_ALL_FSTYPES;
 	quit_cmd.oneline = _("exit the program");
 
 	add_command(&quit_cmd);
diff --git a/quota/path.c b/quota/path.c
index 57d14f0b5511..330a3bef6aa9 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -141,7 +141,7 @@ path_init(void)
 	path_cmd.cfunc = path_f;
 	path_cmd.argmin = 0;
 	path_cmd.argmax = 1;
-	path_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
+	path_cmd.flags = CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
 	path_cmd.oneline = _("set current path, or show the list of paths");
 
 	print_cmd.name = "print";
@@ -149,7 +149,7 @@ path_init(void)
 	print_cmd.cfunc = print_f;
 	print_cmd.argmin = 0;
 	print_cmd.argmax = 0;
-	print_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
+	print_cmd.flags = CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
 	print_cmd.oneline = _("list known mount points and projects");
 
 	if (expert)
diff --git a/quota/report.c b/quota/report.c
index 604f50dc6001..ca9d2b2c9564 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -770,7 +770,7 @@ report_init(void)
 	report_cmd.args = _("[-bir] [-gpu] [-ahnt] [-f file]");
 	report_cmd.oneline = _("report filesystem quota information");
 	report_cmd.help = report_help;
-	report_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
+	report_cmd.flags = CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
 
 	if (expert) {
 		add_command(&dump_cmd);
-- 
2.10.2

