Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56141 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752017AbcLGDrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 22:47:35 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] libxcmd: rename args_command to command_iterator
Date: Wed,  7 Dec 2016 14:47:20 +1100
Message-Id: <20161207034724.1613-3-david@fromorbit.com>
In-Reply-To: <20161207034724.1613-1-david@fromorbit.com>
References: <20161207034724.1613-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, amir73il@gmail.com

From: Dave Chinner <dchinner@redhat.com>

It is not particularly easy to understand the function of the
args_command abstraction. it's actually a command iterator interface
that allows callers to specify the target of the command and iterate
the command multiple times over different targets. Rename and
document the abstraction to make this functionality clear.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 include/command.h |  4 ++--
 io/init.c         |  9 +++++++--
 libxcmd/command.c | 16 ++++++++--------
 quota/init.c      |  9 +++++++--
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/include/command.h b/include/command.h
index 58bfcaac44a0..637ee06e6e9a 100644
--- a/include/command.h
+++ b/include/command.h
@@ -50,12 +50,12 @@ extern int		ncmds;
 extern void		help_init(void);
 extern void		quit_init(void);
 
-typedef int (*argsfunc_t)(int index);
+typedef int (*iterfunc_t)(int index);
 typedef int (*checkfunc_t)(const cmdinfo_t *ci);
 
 extern void		add_command(const cmdinfo_t *ci);
 extern void		add_user_command(char *optarg);
-extern void		add_args_command(argsfunc_t af);
+extern void		add_command_iterator(iterfunc_t func);
 extern void		add_check_command(checkfunc_t cf);
 
 extern const cmdinfo_t	*find_command(const char *cmd);
diff --git a/io/init.c b/io/init.c
index ab40f3745390..34009b024833 100644
--- a/io/init.c
+++ b/io/init.c
@@ -90,8 +90,13 @@ init_commands(void)
 	cowextsize_init();
 }
 
+/*
+ * This allows xfs_io commands specified on the command line to be run on every
+ * open file in the file table. Commands that should not be iterated across all
+ * open files need to specify CMD_FLAG_ONESHOT in their command flags.
+ */
 static int
-init_args_command(
+filetable_iterator(
 	int	index)
 {
 	if (index >= filecount)
@@ -214,7 +219,7 @@ init(
 	}
 
 	init_commands();
-	add_args_command(init_args_command);
+	add_command_iterator(filetable_iterator);
 	add_check_command(init_check_command);
 }
 
diff --git a/libxcmd/command.c b/libxcmd/command.c
index dce8361ce3ea..789aeb5c5e5a 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -23,7 +23,7 @@
 cmdinfo_t	*cmdtab;
 int		ncmds;
 
-static argsfunc_t	args_func;
+static iterfunc_t	iter_func;
 static checkfunc_t	check_func;
 static int		ncmdline;
 static char		**cmdline;
@@ -130,7 +130,7 @@ add_user_command(char *optarg)
  * so we abort straight away.
  */
 static int
-args_command(
+iterate_command(
 	const cmdinfo_t	*ct,
 	int		index)
 {
@@ -138,16 +138,16 @@ args_command(
 		return 0;
 	if (ct->flags & CMD_FLAG_ONESHOT)
 		return -1;
-	if (args_func)
-		return args_func(index);
+	if (iter_func)
+		return iter_func(index);
 	return 0;
 }
 
 void
-add_args_command(
-	argsfunc_t	af)
+add_command_iterator(
+	iterfunc_t	func)
 {
-	args_func = af;
+	iter_func = func;
 }
 
 void
@@ -171,7 +171,7 @@ command_loop(void)
 			ct = find_command(v[0]);
 			if (ct) {
 				j = 0;
-				while (!done && (j = args_command(ct, j)))
+				while (!done && (j = iterate_command(ct, j)))
 					done = command(ct, c, v);
 			} else
 				fprintf(stderr, _("command \"%s\" not found\n"),
diff --git a/quota/init.c b/quota/init.c
index 3bebbb8735f3..193f6421fd59 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -75,8 +75,13 @@ init_commands(void)
 	state_init();
 }
 
+/*
+ * This function allows xfs_quota commands to iterate across all discovered
+ * quota enabled filesystems. Commands that should not iterate all filesystems
+ * should specify CMD_FLAG_ONESHOT in their command flags.
+ */
 static int
-init_args_command(
+filesystem_iterator(
 	int	index)
 {
 	if (index >= fs_count)
@@ -189,7 +194,7 @@ init(
 	free(projopts);
 
 	init_commands();
-	add_args_command(init_args_command);
+	add_command_iterator(filesystem_iterator);
 	add_check_command(init_check_command);
 
 	/*
-- 
2.10.2

