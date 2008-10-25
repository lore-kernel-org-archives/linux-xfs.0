Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 11:46:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PIjtll017149
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 11:45:55 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59A0212A91CF
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 11:45:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id e6jOoUnAOsnCWdJA for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 11:45:54 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 269A0A9C9C1
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:45:54 -0500 (CDT)
Message-ID: <49036961.8070100@sandeen.net>
Date: Sat, 25 Oct 2008 13:45:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix nr of args in open calls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Fix a few problematic open calls which strict checking catches;
in most cases just missing a mode with O_CREAT.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfstests/ltp/iogen.c
===================================================================
--- xfstests.orig/ltp/iogen.c
+++ xfstests/ltp/iogen.c
@@ -1060,7 +1060,11 @@ int 	nbytes;
 
     Oflags |= O_CREAT | O_WRONLY;
 
+#ifdef CRAY
     if ((fd = open(path, Oflags, 0666, Ocbits, Ocblks)) == -1) {
+#else
+    if ((fd = open(path, Oflags, 0666)) == -1) {
+#endif
 	fprintf(stderr, "iogen%s:  Could not create/open file %s: %s (%d)\n",
 		TagName, path, SYSERR, errno);
 	return -1;
Index: xfstests/src/multi_open_unlink.c
===================================================================
--- xfstests.orig/src/multi_open_unlink.c
+++ xfstests/src/multi_open_unlink.c
@@ -92,7 +92,7 @@ main(int argc, char *argv[])
 			return 1;
 		}
 
-		fd = open(path, O_RDWR|O_CREAT|O_EXCL);
+		fd = open(path, O_RDWR|O_CREAT|O_EXCL, 0666);
 		if (fd == -1) {
 			fprintf(stderr, "%s: failed to create \"%s\": %s\n", prog, path, strerror(errno));
 			return 1;
Index: xfstests/src/enospc_unlink.c
===================================================================
--- xfstests.orig/src/enospc_unlink.c
+++ xfstests/src/enospc_unlink.c
@@ -40,7 +40,7 @@ int main(int argc, char **argv)
 	memset(ptr, 0xffffffff, sz);
 
 	for (i = 0; i < count; i++) {
-		fd = open(argv[1], O_CREAT|O_WRONLY);
+		fd = open(argv[1], O_CREAT|O_WRONLY, 0666);
 		if (fd < 0) {
 			perror(argv[1]);
 			exit(1);
Index: xfstests/src/dmiperf.c
===================================================================
--- xfstests.orig/src/dmiperf.c
+++ xfstests/src/dmiperf.c
@@ -203,7 +203,7 @@ mkfile(char *name, char *attr)
 	ssize_t		wrote, wsize;
 	off64_t		bytes = fsize;
 
-	if ((fd = open(name, O_WRONLY | O_CREAT | O_EXCL | O_DIRECT)) < 0) {
+	if ((fd = open(name, O_WRONLY | O_CREAT | O_EXCL | O_DIRECT, 0666)) < 0) {
 		perror("open");
 		exit(1);
 	}
