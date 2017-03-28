Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10385 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751986AbdC1OjL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 10:39:11 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
References: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
Subject: [PATCH] xfs_io: changes to statx interface [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29457.1490711932.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 28 Mar 2017 15:38:52 +0100
Message-ID: <29458.1490711932@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

Here are my current changes to Eric's statx interface patch.  I've made it
analoguous to the stat command and so it only does statx-of-fd.

I've made the "-m" flag able to take the words "basic" and "all" in
preference to a number and able to take an octal or hex number as an
alternative too.

I've dropped the -A and -L flags since it no longer passes a path over.

Finally, I've added a -c flag that causes an fstat() to be done as well and
the buffers compared as a consistency check.

David
---
diff --git a/io/stat.c b/io/stat.c
index a7aebcd..961b6d1 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -189,12 +189,10 @@ statx_help(void)
 " Display extended file status.\n"
 "\n"
 " Options:\n"
-" -m mask -- Specify the field mask for the statx call (default STATX_ALL)\n"
-" -A -- Suppress terminal automount traversal\n"
+" -c -- Compare against fstat/fstatat on the same file/fd\n"
+" -m mask -- Specify the field mask for the statx call (can also be 'basic' or 'all'; default STATX_ALL)\n"
 " -D -- Don't sync attributes with the server\n"
 " -F -- Force the attributes to be sync'd with the server\n"
-" -L -- Follow symlinks (statx link target)\n"
-" -O -- Add only basic stats (STATX_BASIC_STATS) to default mask\n"
 "\n"));
 }
 
@@ -227,6 +225,65 @@ dump_statx(struct statx *stx)
 }
 
 /*
+ * Compare the contents of a statx struct with that of a stat struct and check
+ * that they're the same.
+ */
+static int
+cmp_statx(const struct statx *stx, const struct stat *st)
+{
+	const char *what = NULL;
+
+#define cmp(x) \
+	do {					\
+		what = #x;		\
+		if (stx->stx_##x != st->st_##x)	\
+			goto mismatch;		\
+	} while (0)
+
+	cmp(blksize);
+	cmp(nlink);
+	cmp(uid);
+	cmp(gid);
+	cmp(mode);
+	cmp(ino);
+	cmp(size);
+	cmp(blocks);
+
+#define devcmp(x) \
+	do {						\
+		what = #x".major";			\
+		if (stx->stx_##x##_major != major(st->st_##x))	\
+			goto mismatch;			\
+		what = #x".minor";			\
+		if (stx->stx_##x##_minor != minor(st->st_##x))	\
+			goto mismatch;			\
+	} while (0)
+
+	devcmp(dev);
+	devcmp(rdev);
+
+#define timecmp(x) \
+	do {						\
+		what = #x".tv_sec";			\
+		if (stx->stx_##x##time.tv_sec != st->st_##x##tim.tv_sec)	\
+			goto mismatch;			\
+		what = #x".tv_nsec";			\
+		if (stx->stx_##x##time.tv_nsec != st->st_##x##tim.tv_nsec)	\
+			goto mismatch;			\
+	} while (0)
+
+	timecmp(a);
+	timecmp(c);
+	timecmp(m);
+
+	return 0;
+
+mismatch:
+	fprintf(stderr, "Mismatch between stat and statx output (%s)\n", what);
+	return -1;
+}
+
+/*
  * options:
  * 	- input flags - query type
  * 	- output style for flags (and all else?) (chars vs. hex?)
@@ -239,16 +296,23 @@ statx_f(
 {
 	int		c;
 	struct statx	stx;
-	int		atflag = AT_SYMLINK_NOFOLLOW;
-	unsigned int	m_mask = 0;	/* mask requested with -m */
-	int		Oflag = 0, mflag = 0;	/* -O or -m was used */
+	struct stat	st;
+	int		atflag = 0;
 	unsigned int	mask = STATX_ALL;
+	int		compare = 0;
 
-	while ((c = getopt(argc, argv, "m:FDLOA")) != EOF) {
+	while ((c = getopt(argc, argv, "cm:FD")) != EOF) {
 		switch (c) {
+		case 'c':
+			compare = 1;
+			break;
 		case 'm':
-			m_mask = atoi(optarg);
-			mflag = 1;
+			if (strcmp(optarg, "basic") == 0)
+				mask = STATX_BASIC_STATS;
+			else if (strcmp(optarg, "all") == 0)
+				mask = STATX_ALL;
+			else
+				mask = strtoul(optarg, NULL, 0);
 			break;
 		case 'F':
 			atflag &= ~AT_STATX_SYNC_TYPE;
@@ -258,38 +322,28 @@ statx_f(
 			atflag &= ~AT_STATX_SYNC_TYPE;
 			atflag |= AT_STATX_DONT_SYNC;
 			break;
-		case 'L':
-			atflag &= ~AT_SYMLINK_NOFOLLOW;
-			break;
-		case 'O':
-			mask = STATX_BASIC_STATS;
-			Oflag = 1;
-			break;
-		case 'A':
-			atflag |= AT_NO_AUTOMOUNT;
-			break;
 		default:
 			return command_usage(&statx_cmd);
 		}
 	}
 
-	if (Oflag && mflag) {
-		printf("Cannot specify both -m mask and -O\n");
-		return 0;
-	}
-
-	/* -m overrides any other mask options */
-	if (mflag)
-		mask = m_mask;
-
 	memset(&stx, 0xbf, sizeof(stx));
-	if (statx(AT_FDCWD, file->name, atflag, mask, &stx) < 0) {
+
+	if (statx(file->fd, NULL, atflag, mask, &stx) < 0) {
 		perror("statx");
 		return 0;
 	}
 
-	dump_statx(&stx);
+	if (compare) {
+		if (fstat(file->fd, &st) < 0) {
+			perror("fstat");
+			return 0;
+		}
 
+		cmp_statx(&stx, &st);
+	}
+	
+	dump_statx(&stx);
 	return 0;
 }
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 77ba760..d82f882 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -884,16 +884,23 @@ and the XFS_IOC_GETXATTR system call on the current file. If the
 option is specified, the atime (last access), mtime
 (last modify), and ctime (last change) timestamps are also displayed.
 .TP
-.BR statx " [ " \-O " | " "\-m mask" " ][ \-" FDLA " ]"
+.BR statx " [ " "\-m mask" " ][ \-" cFD " ]"
 Extended information from the statx syscall.
 .RS 1.0i
 .PD 0
 .TP 0.4i
 .B \-m mask
-Specify the field mask for the statx call (default STATX_ALL)
+Specify the field mask for the statx call as an decimal, hex or octal integer
+or
+.RI \" basic "\" or \"" all \"
+to specify the basic stats that
+.IR stat ()
+returns or all the stats known by the header file.  All is the default.
 .TP
-.B \-O
-Add only basic stats (STATX_BASIC_STATS) to default mask
+.B \-c
+Do an
+.IR fstat ()
+call as well and compare the buffers.
 .TP
 .B \-F
 Force the attributes to be sync'd with the server
@@ -901,12 +908,6 @@ Force the attributes to be sync'd with the server
 .B \-D
 Don't sync attributes with the server
 .TP
-.B \-L
-Follow symlinks (statx link target)
-.TP
-.B \-A
-Suppress terminal automount traversal
-.TP
 .RE
 .IP
 .TP
