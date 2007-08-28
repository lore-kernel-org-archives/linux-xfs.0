Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Aug 2007 18:03:12 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7S1384p006212
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2007 18:03:10 -0700
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l7S130F1026138
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 10:03:07 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.192])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l7S0vHme025573
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 09:57:17 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l7S0vHb12692 for xfs@oss.sgi.com; Tue, 28 Aug 2007 09:57:17 +0900 (JST)
Received: from kaishu.jp.nec.com (kaishu.jp.nec.com [10.26.220.5]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l7S0vGa28453 for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 09:57:16 +0900 (JST)
Message-Id: <200708280057.AA05910@TNESG9305.wm.jp.nec.com>
Date: Tue, 28 Aug 2007 09:57:14 +0900
Subject: [PATCH] Fix handling of symbolic links in setfacl/getfacl.
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,
I resend this mail which got lost yesterday.

setfacl and getfacl have 2 problems when a symbolic link is specified.

1) I got an error message when link is relative path and does not exist
  in current directory, because setfacl and getfacl handle the relative path
  returned by readlink() without the conversion to the absolute path.

# pwd
/home/utako/TestProgram/acl-2.2.44/getfacl
# ls -l ~utako/mpnt/attr4
lrwxrwxrwx  1 utako users 5 Jul 31 11:52 /home/utako/mpnt/attr4 -> mpnt2
# getfacl ~utako/mpnt/attr4
getfacl: /home/utako/mpnt/attr4: No such file or directory

2) -P option does not work. I fixed so that resolve_symlinks() returns
  a symbolic link source's path only when opt_walk_physical = 0.

I use realpath() to get the absolute path name because xfsprogs uses it.

Utako

Signed-off-by: Utako Kusaka <u-kusaka@wm.jp.nec.com>
---
diff -uprN acl-2.2.44.orig/getfacl/getfacl.c acl-2.2.44/getfacl/getfacl.c
--- acl-2.2.44.orig/getfacl/getfacl.c	2007-01-23 14:56:39.000000000 +0900
+++ acl-2.2.44/getfacl/getfacl.c	2007-08-27 13:51:21.000000000 +0900
@@ -598,17 +598,17 @@ int __do_print(const char *file, const s
 char *resolve_symlinks(const char *file)
 {
 	static char buffer[4096];
+	struct stat stat;
 	char *path = NULL;
-	ssize_t len;
 
-	len = readlink(file, buffer, sizeof(buffer)-1);
-	if (len < 0) {
-		if (errno == EINVAL)	/* not a symlink, use given path */
-			path = (char *)file;
-	} else {
-		buffer[len+1] = '\0';
-		path = buffer;
-	}
+	if (lstat(file, &stat) == -1)
+		return path;
+
+	if (S_ISLNK(stat.st_mode) && !opt_walk_physical)
+		path = realpath(file, buffer);
+	else
+		path = (char *)file; 	/* not a symlink, use given path */
+
 	return path;
 }
 
diff -uprN acl-2.2.44.orig/setfacl/setfacl.c acl-2.2.44/setfacl/setfacl.c
--- acl-2.2.44.orig/setfacl/setfacl.c	2007-01-23 14:56:40.000000000 +0900
+++ acl-2.2.44/setfacl/setfacl.c	2007-08-27 13:55:15.000000000 +0900
@@ -314,17 +314,17 @@ int __do_set(const char *file, const str
 char *resolve_symlinks(const char *file)
 {
 	static char buffer[4096];
+	struct stat stat;
 	char *path = NULL;
-	ssize_t len;
 
-	len = readlink(file, buffer, sizeof(buffer)-1);
-	if (len < 0) {
-		if (errno == EINVAL)	/* not a symlink, use given path */
-			path = (char *)file;
-	} else {
-		buffer[len+1] = '\0';
-		path = buffer;
-	}
+	if (lstat(file, &stat) == -1)
+		return path;
+
+	if (S_ISLNK(stat.st_mode) && !opt_walk_physical)
+		path = realpath(file, buffer);
+	else
+		path = (char *)file;    /* not a symlink, use given path */
+
 	return path;
 }
 
