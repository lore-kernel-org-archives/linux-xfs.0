Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 21:22:50 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4V4MjWt012312
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 21:22:47 -0700
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.161])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l4V4MjCS022757
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 13:22:45 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l4V4MjP24299 for xfs@oss.sgi.com; Thu, 31 May 2007 13:22:45 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l4V4Mi206567 for <xfs@oss.sgi.com>; Thu, 31 May 2007 13:22:44 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070531.132243.92102468 for <xfs@oss.sgi.com>
	; Thu, 31 May 2007 13:22:44 +0900
Message-Id: <200705310422.AA05481@TNESG9305.tnes.nec.co.jp>
Date: Thu, 31 May 2007 13:22:43 +0900
Subject: [PATCH] Fix xfs_quota command handling.
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

This is my last patch for xfs_quota, maybe.
When path argument is not specified, xfs_quota executes commands repeatedly
to the number of mounted XFS file systems.
As a result, I get the same command report many times. 
This patch implements the similar command loop operation to xfs_db.

# ./xfs_quota -c "print" -c "help"
Filesystem          Pathname
/home/utako/mpnt    /dev/sda6 (uquota)
/home/utako/mpnt/mpnt2 /dev/loop0 (uquota)
/home/utako/mpnt/pjq /dev/sda6 (project 42, logfiles)
/home/utako/mpnt/pjq2 /dev/sda6 (project 43, logfiles2)
Filesystem          Pathname
/home/utako/mpnt    /dev/sda6 (uquota)
/home/utako/mpnt/mpnt2 /dev/loop0 (uquota)
/home/utako/mpnt/pjq /dev/sda6 (project 42, logfiles)
/home/utako/mpnt/pjq2 /dev/sda6 (project 43, logfiles2)
df [-bir] [-hn] [-f file] -- show free and used counts for blocks and inodes
help [command] -- help for one or all commands
print -- list known mount points and projects
quit -- exit the program
quota [-bir] [-gpu] [-hnv] [-f file] [id|name]... -- show usage and limits

Use 'help commandname' for extended help.
df [-bir] [-hn] [-f file] -- show free and used counts for blocks and inodes
help [command] -- help for one or all commands
print -- list known mount points and projects
quit -- exit the program
quota [-bir] [-gpu] [-hnv] [-f file] [id|name]... -- show usage and limits

Use 'help commandname' for extended help.

--
Utako Kusaka


Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.20/quota/init.orig	2007-05-16 11:38:39.000000000 +0900
+++ xfsprogs-2.8.20/quota/init.c	2007-05-30 11:16:56.000000000 +0900
@@ -25,6 +25,8 @@ char	*progname;
 int	exitcode;
 int	expert;
 
+static char **cmdline;	/* table of user commands */
+static int  ncmdline;	/* number of entries in command table */
 static char **projopts;	/* table of project names (cmdline) */
 static int nprojopts;	/* number of entries in name table. */
 
@@ -74,24 +76,6 @@ init_commands(void)
 	state_init();
 }
 
-static int
-init_args_command(
-	int	index)
-{
-	if (index >= fs_count)
-		return 0;
-
-	do {
-		fs_path = &fs_table[index++];
-	} while ((fs_path->fs_flags & FS_PROJECT_PATH) && index < fs_count);
-
-	if (fs_path->fs_flags & FS_PROJECT_PATH)
-		return 0;
-	if (index > fs_count)
-		return 0;
-	return index;
-}
-
 static void
 init(
 	int		argc,
@@ -107,7 +91,12 @@ init(
 	while ((c = getopt(argc, argv, "c:d:D:P:p:t:xV")) != EOF) {
 		switch (c) {
 		case 'c':	/* commands */
-			add_user_command(optarg);
+			cmdline = realloc(cmdline, (ncmdline+1)*sizeof(char*));
+			if (!cmdline) {
+				perror("realloc");
+				exit(1);
+			}
+			cmdline[ncmdline++] = optarg;
 			break;
 		case 'd':
 			add_project_opt(optarg);
@@ -150,7 +139,6 @@ init(
 		free(projopts);
 
 	init_commands();
-	add_args_command(init_args_command);
 }
 
 int
@@ -158,7 +146,32 @@ main(
 	int		argc,
 	char		**argv)
 {
+        int     c, i, done = 0;
+        char    *input;
+        char    **v;
+
 	init(argc, argv);
-	command_loop();
+
+        for (i = 0; !done && i < ncmdline; i++) {
+                v = breakline(cmdline[i], &c);
+                if (c)
+                        done = command(c, v);
+                free(v);
+        }
+        if (cmdline) {
+                free(cmdline);
+                return exitcode;
+        }
+
+        while (!done) {
+                if ((input = fetchline()) == NULL)
+                        break;
+                v = breakline(input, &c);
+                if (c)
+                        done = command(c, v);
+                doneline(input, v);
+        }
+
+
 	return exitcode;
 }
