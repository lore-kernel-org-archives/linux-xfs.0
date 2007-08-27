Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Aug 2007 02:05:59 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7R95q4p020809
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2007 02:05:56 -0700
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l7R7m08v010427
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2007 16:48:00 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l7R7gbP6020420
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2007 16:42:38 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l7R7gbH28089 for xfs@oss.sgi.com; Mon, 27 Aug 2007 16:42:37 +0900 (JST)
Received: from kuichi.jp.nec.com (kuichi.jp.nec.com [10.26.220.17]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l7R7gbv27128 for <xfs@oss.sgi.com>; Mon, 27 Aug 2007 16:42:37 +0900 (JST)
Message-Id: <200708270742.AA05908@TNESG9305.wm.jp.nec.com>
Date: Mon, 27 Aug 2007 16:42:42 +0900
Subject: [PATCH] Fix handling of symbolic links in getfattr.
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

getfattr -R and -RL give the same result.
This patch implements the similar handling of symbolic links in getfattr 
to getfacl and setfacl.

Utako

Signed-off-by: Utako Kusaka <u-kusaka@wm.jp.nec.com>
---
--- attr-2.4.38/getfattr/getfattr.c.orig	2007-07-31 15:27:27.000000000 +0900
+++ attr-2.4.38/getfattr/getfattr.c	2007-08-22 15:59:28.000000000 +0900
@@ -410,6 +410,38 @@ void help(void)
 "      --help              this help text\n"));
 }
 
+char *resolve_symlinks(const char *file)
+{
+	static char buffer[4096];
+	struct stat stat;
+	char *path = NULL;
+
+	if (lstat(file, &stat) == -1)
+		return path;
+
+	if (S_ISLNK(stat.st_mode) && !opt_walk_physical)
+		path = realpath(file, buffer);
+	else
+		path = (char *)file;    /* not a symlink, use given path */
+
+	return path;
+}
+
+int walk_tree(const char *file)
+{
+	const char *p;
+
+	if ((p = resolve_symlinks(file)) == NULL) {
+		fprintf(stderr, "%s: %s: %s\n", progname,
+			xquote(file), strerror(errno));
+		return 1;
+	} else if (nftw(p, do_print, 0, opt_walk_logical? 0 : FTW_PHYS) < 0) {
+		fprintf(stderr, "%s: %s: %s\n", progname, xquote(file),
+			strerror(errno));
+		return 1;
+	}
+	return 0;
+}
 
 int main(int argc, char *argv[])
 {
@@ -499,12 +531,7 @@ int main(int argc, char *argv[])
 	}
 
 	while (optind < argc) {
-		if (nftw(argv[optind], do_print, 0,
-			 opt_walk_physical * FTW_PHYS) < 0) {
-			fprintf(stderr, "%s: %s: %s\n", progname, argv[optind],
-			        strerror_ea(errno));
-			had_errors++;
-		}
+		had_errors += walk_tree(argv[optind]);
 		optind++;
 	}
 
