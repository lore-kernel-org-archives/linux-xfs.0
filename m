Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33229 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752761AbdIBVzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 17:55:09 -0400
Received: by mail-pf0-f196.google.com with SMTP id r25so2157405pfk.0
        for <linux-xfs@vger.kernel.org>; Sat, 02 Sep 2017 14:55:09 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] Rename progname as it is provided by libc
Date: Sat,  2 Sep 2017 14:54:51 -0700
Message-Id: <20170902215451.29265-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

Rename local variable progname to avoid a clash with libc
global symbols

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 io/init.c                 | 10 +++++-----
 mdrestore/xfs_mdrestore.c | 10 +++++-----
 quota/init.c              | 10 +++++-----
 spaceman/init.c           |  8 ++++----
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/io/init.c b/io/init.c
index 20d5f80..e82e101 100644
--- a/io/init.c
+++ b/io/init.c
@@ -23,7 +23,7 @@
 #include "init.h"
 #include "io.h"
 
-char	*progname;
+char	*io_progname;
 int	exitcode;
 int	expert;
 int	idlethread;
@@ -35,7 +35,7 @@ usage(void)
 {
 	fprintf(stderr,
 _("Usage: %s [-adfinrRstVx] [-m mode] [-p prog] [[-c|-C] cmd]... file\n"),
-		progname);
+		io_progname);
 	exit(1);
 }
 
@@ -142,7 +142,7 @@ init(
 	xfs_fsop_geom_t	geometry = { 0 };
 	struct fs_path	fsp;
 
-	progname = basename(argv[0]);
+	io_progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
@@ -186,7 +186,7 @@ init(
 			flags |= IO_NONBLOCK;
 			break;
 		case 'p':
-			progname = optarg;
+			io_progname = optarg;
 			break;
 		case 'r':
 			flags |= IO_READONLY;
@@ -207,7 +207,7 @@ init(
 			expert = 1;
 			break;
 		case 'V':
-			printf(_("%s version %s\n"), progname, VERSION);
+			printf(_("%s version %s\n"), io_progname, VERSION);
 			exit(0);
 		default:
 			usage();
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 9d1b4e8..b840a54 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -19,7 +19,7 @@
 #include "libxfs.h"
 #include "xfs_metadump.h"
 
-char 		*progname;
+char 		*mdrestore_progname;
 int		show_progress = 0;
 int		show_info = 0;
 int		progress_since_warning = 0;
@@ -30,7 +30,7 @@ fatal(const char *msg, ...)
 	va_list		args;
 
 	va_start(args, msg);
-	fprintf(stderr, "%s: ", progname);
+	fprintf(stderr, "%s: ", mdrestore_progname);
 	vfprintf(stderr, msg, args);
 	exit(1);
 }
@@ -194,7 +194,7 @@ perform_restore(
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] source target\n", mdrestore_progname);
 	exit(1);
 }
 
@@ -212,7 +212,7 @@ main(
 	struct stat	statbuf;
 	int		is_target_file;
 
-	progname = basename(argv[0]);
+	mdrestore_progname = basename(argv[0]);
 
 	while ((c = getopt(argc, argv, "giV")) != EOF) {
 		switch (c) {
@@ -223,7 +223,7 @@ main(
 				show_info = 1;
 				break;
 			case 'V':
-				printf("%s version %s\n", progname, VERSION);
+				printf("%s version %s\n", mdrestore_progname, VERSION);
 				exit(0);
 			default:
 				usage();
diff --git a/quota/init.c b/quota/init.c
index d45dc4c..46403de 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -21,7 +21,7 @@
 #include "input.h"
 #include "init.h"
 
-char	*progname;
+char	*quota_progname;
 int	exitcode;
 int	expert;
 bool	foreign_allowed = false;
@@ -47,7 +47,7 @@ usage(void)
 {
 	fprintf(stderr,
 		_("Usage: %s [-V] [-x] [-f] [-p prog] [-c cmd]... [-d project]... [path]\n"),
-		progname);
+		quota_progname);
 	exit(1);
 }
 
@@ -147,7 +147,7 @@ init(
 {
 	int		c;
 
-	progname = basename(argv[0]);
+	quota_progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
@@ -173,13 +173,13 @@ init(
 			projid_file = optarg;
 			break;
 		case 'p':
-			progname = optarg;
+			quota_progname = optarg;
 			break;
 		case 'x':
 			expert++;
 			break;
 		case 'V':
-			printf(_("%s version %s\n"), progname, VERSION);
+			printf(_("%s version %s\n"), quota_progname, VERSION);
 			exit(0);
 		default:
 			usage();
diff --git a/spaceman/init.c b/spaceman/init.c
index b3eface..bedf112 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -23,7 +23,7 @@
 #include "path.h"
 #include "space.h"
 
-char	*progname;
+char	*spaceman_progname;
 int	exitcode;
 
 void
@@ -31,7 +31,7 @@ usage(void)
 {
 	fprintf(stderr,
 		_("Usage: %s [-c cmd] file\n"),
-		progname);
+		spaceman_progname);
 	exit(1);
 }
 
@@ -74,7 +74,7 @@ init(
 	xfs_fsop_geom_t	geometry = { 0 };
 	struct fs_path	fsp;
 
-	progname = basename(argv[0]);
+	spaceman_progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
@@ -86,7 +86,7 @@ init(
 			add_user_command(optarg);
 			break;
 		case 'V':
-			printf(_("%s version %s\n"), progname, VERSION);
+			printf(_("%s version %s\n"), spaceman_progname, VERSION);
 			exit(0);
 		default:
 			usage();
-- 
2.14.1

