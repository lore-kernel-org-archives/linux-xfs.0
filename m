Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932367AbdC2Vz6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 17:55:58 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
References: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
Subject: [PATCH] xfs_io: changes to statx interface [ver #4]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1028.1490824554.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 29 Mar 2017 22:55:54 +0100
Message-ID: <1029.1490824554@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

Here's my fourth attempt at changing Eric's statx patch.  In this one I split
the type out from the mode field.

David
---
diff --git a/io/stat.c b/io/stat.c
index a7aebcd..410d33a 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -44,6 +44,36 @@ filesize(void)
 	return st.st_size;
 }
 
+static int
+dump_raw_stat(struct stat *st)
+{
+	if (fstat(file->fd, st) < 0) {
+		perror("fstat");
+		return -1;
+	}
+
+	printf("stat.blksize: %lu\n", st->st_blksize);
+	printf("stat.nlink: %lu\n", st->st_nlink);
+	printf("stat.uid: %u\n", st->st_uid);
+	printf("stat.gid: %u\n", st->st_gid);
+	printf("stat.type: 0%o\n", st->st_mode & ~07777);
+	printf("stat.mode: 0%o\n", st->st_mode & 07777);
+	printf("stat.ino: %lu\n", st->st_ino);
+	printf("stat.size: %lu\n", st->st_size);
+	printf("stat.blocks: %lu\n", st->st_blocks);
+	printf("stat.atime.tv_sec: %ld\n", st->st_atim.tv_sec);
+	printf("stat.atime.tv_nsec: %ld\n", st->st_atim.tv_nsec);
+	printf("stat.ctime.tv_sec: %ld\n", st->st_ctim.tv_sec);
+	printf("stat.ctime.tv_nsec: %ld\n", st->st_ctim.tv_nsec);
+	printf("stat.mtime.tv_sec: %ld\n", st->st_mtim.tv_sec);
+	printf("stat.mtime.tv_nsec: %ld\n", st->st_mtim.tv_nsec);
+	printf("stat.rdev_major: %u\n", major(st->st_rdev));
+	printf("stat.rdev_minor: %u\n", minor(st->st_rdev));
+	printf("stat.dev_major: %u\n", major(st->st_dev));
+	printf("stat.dev_minor: %u\n", minor(st->st_dev));
+	return 0;
+}
+
 static char *
 filetype(mode_t mode)
 {
@@ -74,7 +104,23 @@ stat_f(
 	struct dioattr	dio;
 	struct fsxattr	fsx, fsxa;
 	struct stat	st;
-	int		verbose = (argc == 2 && !strcmp(argv[1], "-v"));
+	int		c, verbose = 0, raw = 0;
+
+	while ((c = getopt(argc, argv, "rv")) != EOF) {
+		switch (c) {
+		case 'r':
+			raw = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			return command_usage(&stat_cmd);
+		}
+	}
+
+	if (raw)
+		return dump_raw_stat(&st);
 
 	printf(_("fd.path = \"%s\"\n"), file->name);
 	printf(_("fd.flags = %s,%s,%s%s%s%s%s\n"),
@@ -189,12 +235,9 @@ statx_help(void)
 " Display extended file status.\n"
 "\n"
 " Options:\n"
-" -m mask -- Specify the field mask for the statx call (default STATX_ALL)\n"
-" -A -- Suppress terminal automount traversal\n"
+" -m mask -- Specify the field mask for the statx call (can also be 'basic' or 'all'; default STATX_ALL)\n"
 " -D -- Don't sync attributes with the server\n"
 " -F -- Force the attributes to be sync'd with the server\n"
-" -L -- Follow symlinks (statx link target)\n"
-" -O -- Add only basic stats (STATX_BASIC_STATS) to default mask\n"
 "\n"));
 }
 
@@ -202,28 +245,29 @@ statx_help(void)
 static void
 dump_statx(struct statx *stx)
 {
-	printf("stx_mask: 0x%x\n", stx->stx_mask);
-	printf("stx_blksize: %u\n", stx->stx_blksize);
-	printf("stx_attributes: 0x%llx\n", stx->stx_attributes);
-	printf("stx_nlink: %u\n", stx->stx_nlink);
-	printf("stx_uid: %u\n", stx->stx_uid);
-	printf("stx_gid: %u\n", stx->stx_gid);
-	printf("stx_mode: 0%o\n", stx->stx_mode);
-	printf("stx_ino: %llu\n", stx->stx_ino);
-	printf("stx_size: %llu\n", stx->stx_size);
-	printf("stx_blocks: %llu\n", stx->stx_blocks);
-	printf("stx_atime.tv_sec: %lld\n", stx->stx_atime.tv_sec);
-	printf("stx_atime.tv_nsec: %d\n", stx->stx_atime.tv_nsec);
-	printf("stx_btime.tv_sec: %lld\n", stx->stx_btime.tv_sec);
-	printf("stx_btime.tv_nsec: %d\n", stx->stx_btime.tv_nsec);
-	printf("stx_ctime.tv_sec: %lld\n", stx->stx_ctime.tv_sec);
-	printf("stx_ctime.tv_nsec: %d\n", stx->stx_ctime.tv_nsec);
-	printf("stx_mtime.tv_sec: %lld\n", stx->stx_mtime.tv_sec);
-	printf("stx_mtime.tv_nsec: %d\n", stx->stx_mtime.tv_nsec);
-	printf("stx_rdev_major: %u\n", stx->stx_rdev_major);
-	printf("stx_rdev_minor: %u\n", stx->stx_rdev_minor);
-	printf("stx_dev_major: %u\n", stx->stx_dev_major);
-	printf("stx_dev_minor: %u\n", stx->stx_dev_minor);
+	printf("stat.mask: 0x%x\n", stx->stx_mask);
+	printf("stat.blksize: %u\n", stx->stx_blksize);
+	printf("stat.attributes: 0x%llx\n", stx->stx_attributes);
+	printf("stat.nlink: %u\n", stx->stx_nlink);
+	printf("stat.uid: %u\n", stx->stx_uid);
+	printf("stat.gid: %u\n", stx->stx_gid);
+	printf("stat.type: 0%o\n", stx->stx_mode & ~07777);
+	printf("stat.mode: 0%o\n", stx->stx_mode & 07777);
+	printf("stat.ino: %llu\n", stx->stx_ino);
+	printf("stat.size: %llu\n", stx->stx_size);
+	printf("stat.blocks: %llu\n", stx->stx_blocks);
+	printf("stat.atime.tv_sec: %lld\n", stx->stx_atime.tv_sec);
+	printf("stat.atime.tv_nsec: %d\n", stx->stx_atime.tv_nsec);
+	printf("stat.btime.tv_sec: %lld\n", stx->stx_btime.tv_sec);
+	printf("stat.btime.tv_nsec: %d\n", stx->stx_btime.tv_nsec);
+	printf("stat.ctime.tv_sec: %lld\n", stx->stx_ctime.tv_sec);
+	printf("stat.ctime.tv_nsec: %d\n", stx->stx_ctime.tv_nsec);
+	printf("stat.mtime.tv_sec: %lld\n", stx->stx_mtime.tv_sec);
+	printf("stat.mtime.tv_nsec: %d\n", stx->stx_mtime.tv_nsec);
+	printf("stat.rdev_major: %u\n", stx->stx_rdev_major);
+	printf("stat.rdev_minor: %u\n", stx->stx_rdev_minor);
+	printf("stat.dev_major: %u\n", stx->stx_dev_major);
+	printf("stat.dev_minor: %u\n", stx->stx_dev_minor);
 }
 
 /*
@@ -239,16 +283,18 @@ statx_f(
 {
 	int		c;
 	struct statx	stx;
-	int		atflag = AT_SYMLINK_NOFOLLOW;
-	unsigned int	m_mask = 0;	/* mask requested with -m */
-	int		Oflag = 0, mflag = 0;	/* -O or -m was used */
+	int		atflag = 0;
 	unsigned int	mask = STATX_ALL;
 
-	while ((c = getopt(argc, argv, "m:FDLOA")) != EOF) {
+	while ((c = getopt(argc, argv, "m:FD")) != EOF) {
 		switch (c) {
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
@@ -258,38 +304,19 @@ statx_f(
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
-
+	
 	dump_statx(&stx);
-
 	return 0;
 }
 
@@ -301,7 +328,7 @@ stat_init(void)
 	stat_cmd.argmin = 0;
 	stat_cmd.argmax = 1;
 	stat_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	stat_cmd.args = _("[-v]");
+	stat_cmd.args = _("[-rv]");
 	stat_cmd.oneline = _("information about the currently open file");
 
 	statfs_cmd.name = "statfs";
@@ -315,7 +342,7 @@ stat_init(void)
 	statx_cmd.argmin = 0;
 	statx_cmd.argmax = -1;
 	statx_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	statx_cmd.args = _("[-O | -m mask][-FDLAP]");
+	statx_cmd.args = _("[-m basic | -m all | -m <mask>][-FD]");
 	statx_cmd.oneline =
  _("extended information about the currently open file");
 	statx_cmd.help = statx_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index e77be40..416f718 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -882,24 +882,29 @@ Only available in expert mode and requires privileges.
 Force the filesystem to shutdown (with or without flushing the log).
 Only available in expert mode and requires privileges.
 .TP
-.BR stat " [ " \-v " ]"
+.BR stat " [ \-" rv " ]"
 Selected statistics from
 .BR stat (2)
 and the XFS_IOC_GETXATTR system call on the current file. If the
 .B \-v
 option is specified, the atime (last access), mtime
-(last modify), and ctime (last change) timestamps are also displayed.
+(last modify), and ctime (last change) timestamps are also displayed. If the
+.B \-r
+option is specified, the raw output will be dumped in the same form as the
+output for the statx command, but with some fields missing.
 .TP
-.BR statx " [ " \-O " | " "\-m mask" " ][ \-" FDLA " ]"
+.BR statx " [ " "\-m mask" " ][ \-" FD " ]"
 Extended information from the statx syscall.
 .RS 1.0i
 .PD 0
 .TP 0.4i
 .B \-m mask
-Specify the field mask for the statx call (default STATX_ALL)
-.TP
-.B \-O
-Add only basic stats (STATX_BASIC_STATS) to default mask
+Specify the field mask for the statx call as an decimal, hex or octal integer
+or
+.RI \" basic "\" or \"" all \"
+to specify the basic stats that
+.IR stat ()
+returns or all the stats known by the header file.  All is the default.
 .TP
 .B \-F
 Force the attributes to be sync'd with the server
@@ -907,12 +912,6 @@ Force the attributes to be sync'd with the server
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

