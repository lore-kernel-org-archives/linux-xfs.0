Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12HZCVS066679 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 11:35:12 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jcwBGb9GYFdkkdai for
	<xfs@oss.sgi.com>; Thu, 02 Feb 2012 09:35:11 -0800 (PST)
Message-ID: <4F2AC948.1050909@redhat.com>
Date: Thu, 02 Feb 2012 11:35:04 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: deprecate the "-F" foreign flag
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>

There's no real reason to force the user to specify "-F" for non-xfs
files, when we can just test for that after it's opened.

* Remove the -F flag from usage() & man pages, but still accept it.
* Set IO_FOREIGN when we open the file, if the fd tests as non-xfs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/init.c b/io/init.c
index a166ad1..f416acf 100644
--- a/io/init.c
+++ b/io/init.c
@@ -32,7 +32,7 @@ void
 usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-adFfmrRstx] [-p prog] [-c cmd]... file\n"),
+		_("Usage: %s [-adfmrRstx] [-p prog] [-c cmd]... file\n"),
 		progname);
 	exit(1);
 }
@@ -145,7 +145,7 @@ init(
 			flags |= IO_DIRECT;
 			break;
 		case 'F':
-			flags |= IO_FOREIGN;
+			/* Ignored / deprecated now, handled automatically */
 			break;
 		case 'f':
 			flags |= IO_CREAT;
@@ -188,9 +188,10 @@ init(
 	}
 
 	while (optind < argc) {
-		if ((c = openfile(argv[optind], flags & IO_FOREIGN ?
-					NULL : &geometry, flags, mode)) < 0)
+		if ((c = openfile(argv[optind], &geometry, flags, mode)) < 0)
 			exit(1);
+		if (!platform_test_xfs_fd(c))
+			flags |= IO_FOREIGN;
 		if (addfile(argv[optind], c, &geometry, flags) < 0)
 			exit(1);
 		optind++;
diff --git a/io/open.c b/io/open.c
index f1a6501..97631e2 100644
--- a/io/open.c
+++ b/io/open.c
@@ -163,17 +163,9 @@ openfile(
 		}
 	}
 
-	if (!geom)
+	if (!platform_test_xfs_fd(fd))
 		return fd;
 
-	if (!platform_test_xfs_fd(fd)) {
-		fprintf(stderr, _("%s: specified file "
-			"[\"%s\"] is not on an XFS filesystem\n"),
-			progname, path);
-		close(fd);
-		return -1;
-	}
-
 	if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
 		perror("XFS_IOC_FSGEOMETRY");
 		close(fd);
@@ -282,10 +274,10 @@ open_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "FRacdfm:nrstx")) != EOF) {
+	while ((c = getopt(argc, argv, "Racdfm:nrstx")) != EOF) {
 		switch (c) {
 		case 'F':
-			flags |= IO_FOREIGN;
+			/* Ignored / deprecated now, handled automatically */
 			break;
 		case 'a':
 			flags |= IO_APPEND;
@@ -328,11 +320,13 @@ open_f(
 	if (optind != argc - 1)
 		return command_usage(&open_cmd);
 
-	fd = openfile(argv[optind], flags & IO_FOREIGN ?
-					NULL : &geometry, flags, mode);
+	fd = openfile(argv[optind], &geometry, flags, mode);
 	if (fd < 0)
 		return 0;
 
+	if (!platform_test_xfs_fd(fd))
+		flags |= IO_FOREIGN;
+
 	addfile(argv[optind], fd, &geometry, flags);
 	return 0;
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6fc6bad..332718c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -4,7 +4,7 @@ xfs_io \- debug the I/O path of an XFS filesystem
 .SH SYNOPSIS
 .B xfs_io
 [
-.B \-adFfmrRstx
+.B \-adfmrRstx
 ] [
 .B \-c
 .I cmd
@@ -37,12 +37,6 @@ Set the program name for prompts and some error messages,
 the default value is
 .BR xfs_io .
 .TP
-.B \-F
-Allow
-.I file
-to reside in non-XFS (foreign) filesystems.
-This mode has a restricted set of commands.
-.TP
 .B \-f
 Create
 .I file

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
