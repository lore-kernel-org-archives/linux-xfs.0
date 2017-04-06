Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50510 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753780AbdDFSxn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 14:53:43 -0400
Subject: [PATCH 3/3] xfs_io: hook up statx
References: <4bb89f72-962d-a9a2-c224-daa828558444@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e3d67608-f309-2f18-2122-197b6cf60b26@sandeen.net>
Date: Thu, 6 Apr 2017 13:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <4bb89f72-962d-a9a2-c224-daa828558444@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>

Wire up the statx syscall to xfs_io.

xfs_io> help statx
statx [-v|-r][-m basic | -m all | -m <mask>][-FD] -- extended statistics on the currently open file

 Display extended file status.

 Options:
 -v -- More verbose output
 -r -- Print raw statx structure fields
 -m mask -- Specify the field mask for the statx call
            (can also be 'basic' or 'all'; default STATX_ALL)
 -D -- Don't sync attributes with the server
 -F -- Force the attributes to be sync'd with the server

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V3: remove -A, -L, and -O options
allow "basic" and "all" masks
change raw dump format to match stat raw format
make -r and -v exclusive
follow factoring of stat_f()


diff --git a/io/stat.c b/io/stat.c
index 770f3c7..64d4638 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -2,6 +2,9 @@
  * Copyright (c) 2003-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  *
+ * Copyright (C) 2015, 2017 Red Hat, Inc.
+ * Portions of statx support written by David Howells (dhowells@redhat.com)
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -20,10 +23,14 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "statx.h"
 #include "libxfs.h"
 
+#include <fcntl.h>
+
 static cmdinfo_t stat_cmd;
 static cmdinfo_t statfs_cmd;
+static cmdinfo_t statx_cmd;
 
 off64_t
 filesize(void)
@@ -226,6 +233,146 @@ statfs_f(
 	return 0;
 }
 
+static ssize_t
+_statx(int dfd, const char *filename, unsigned flags,
+      unsigned int mask, struct statx *buffer)
+{
+	return syscall(__NR_statx, dfd, filename, flags, mask, buffer);
+}
+
+static void
+statx_help(void)
+{
+        printf(_(
+"\n"
+" Display extended file status.\n"
+"\n"
+" Options:\n"
+" -v -- More verbose output\n"
+" -r -- Print raw statx structure fields\n"
+" -m mask -- Specify the field mask for the statx call\n"
+"            (can also be 'basic' or 'all'; default STATX_ALL)\n"
+" -D -- Don't sync attributes with the server\n"
+" -F -- Force the attributes to be sync'd with the server\n"
+"\n"));
+}
+
+/* statx helper */
+static int
+dump_raw_statx(struct statx *stx)
+{
+	printf("stat.mask = 0x%x\n", stx->stx_mask);
+	printf("stat.blksize = %u\n", stx->stx_blksize);
+	printf("stat.attributes = 0x%llx\n", stx->stx_attributes);
+	printf("stat.nlink = %u\n", stx->stx_nlink);
+	printf("stat.uid = %u\n", stx->stx_uid);
+	printf("stat.gid = %u\n", stx->stx_gid);
+	printf("stat.mode: 0%o\n", stx->stx_mode);
+	printf("stat.ino = %llu\n", stx->stx_ino);
+	printf("stat.size = %llu\n", stx->stx_size);
+	printf("stat.blocks = %llu\n", stx->stx_blocks);
+	printf("stat.atime.tv_sec = %lld\n", stx->stx_atime.tv_sec);
+	printf("stat.atime.tv_nsec = %d\n", stx->stx_atime.tv_nsec);
+	printf("stat.btime.tv_sec = %lld\n", stx->stx_btime.tv_sec);
+	printf("stat.btime.tv_nsec = %d\n", stx->stx_btime.tv_nsec);
+	printf("stat.ctime.tv_sec = %lld\n", stx->stx_ctime.tv_sec);
+	printf("stat.ctime.tv_nsec = %d\n", stx->stx_ctime.tv_nsec);
+	printf("stat.mtime.tv_sec = %lld\n", stx->stx_mtime.tv_sec);
+	printf("stat.mtime.tv_nsec = %d\n", stx->stx_mtime.tv_nsec);
+	printf("stat.rdev_major = %u\n", stx->stx_rdev_major);
+	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
+	printf("stat.dev_major = %u\n", stx->stx_dev_major);
+	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
+	return 0;
+}
+
+/*
+ * options:
+ * 	- input flags - query type
+ * 	- output style for flags (and all else?) (chars vs. hex?)
+ * 	- output - mask out incidental flag or not?
+ */
+int
+statx_f(
+	int		argc,
+	char		**argv)
+{
+	int		c, verbose = 0, raw = 0;
+	char		*p;
+	struct statx	stx;
+	int		atflag = 0;
+	unsigned int	mask = STATX_ALL;
+
+	while ((c = getopt(argc, argv, "m:rvFD")) != EOF) {
+		switch (c) {
+		case 'm':
+			if (strcmp(optarg, "basic") == 0)
+				mask = STATX_BASIC_STATS;
+			else if (strcmp(optarg, "all") == 0)
+				mask = STATX_ALL;
+			else {
+				mask = strtoul(optarg, &p, 0);
+				if (!p || p == optarg) {
+					printf(
+				_("non-numeric mask -- %s\n"), optarg);
+					return 0;
+				}
+			}
+			break;
+		case 'r':
+			raw = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 'F':
+			atflag &= ~AT_STATX_SYNC_TYPE;
+			atflag |= AT_STATX_FORCE_SYNC;
+			break;
+		case 'D':
+			atflag &= ~AT_STATX_SYNC_TYPE;
+			atflag |= AT_STATX_DONT_SYNC;
+			break;
+		default:
+			return command_usage(&statx_cmd);
+		}
+	}
+
+	if (raw && verbose)
+		return command_usage(&statx_cmd);
+
+	memset(&stx, 0xbf, sizeof(stx));
+	if (_statx(file->fd, NULL, atflag, mask, &stx) < 0) {
+		perror("statx");
+		return 0;
+	}
+
+	if (raw)
+		return dump_raw_statx(&stx);
+
+	print_file_info();
+
+	printf(_("stat.ino = %lld\n"), (long long)stx.stx_ino);
+	printf(_("stat.type = %s\n"), filetype(stx.stx_mode));
+	printf(_("stat.size = %lld\n"), (long long)stx.stx_size);
+	printf(_("stat.blocks = %lld\n"), (long long)stx.stx_blocks);
+	if (verbose) {
+		printf(_("stat.atime = %s"), ctime((time_t *)&stx.stx_atime.tv_sec));
+		printf(_("stat.mtime = %s"), ctime((time_t *)&stx.stx_mtime.tv_sec));
+		printf(_("stat.ctime = %s"), ctime((time_t *)&stx.stx_ctime.tv_sec));
+		if (stx.stx_mask & STATX_BTIME)
+			printf(_("stat.btime = %s"),
+				ctime((time_t *)&stx.stx_btime.tv_sec));
+	}
+
+	if (file->flags & IO_FOREIGN)
+		return 0;
+
+	print_xfs_info(verbose);
+
+	return 0;
+}
+
 void
 stat_init(void)
 {
@@ -237,6 +384,15 @@ stat_init(void)
 	stat_cmd.args = _("[-v|-r]");
 	stat_cmd.oneline = _("statistics on the currently open file");
 
+	statx_cmd.name = "statx";
+	statx_cmd.cfunc = statx_f;
+	statx_cmd.argmin = 0;
+	statx_cmd.argmax = -1;
+	statx_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	statx_cmd.args = _("[-v|-r][-m basic | -m all | -m <mask>][-FD]");
+	statx_cmd.oneline = _("extended statistics on the currently open file");
+	statx_cmd.help = statx_help;
+
 	statfs_cmd.name = "statfs";
 	statfs_cmd.cfunc = statfs_f;
 	statfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
@@ -244,5 +400,6 @@ stat_init(void)
 		_("statistics on the filesystem of the currently open file");
 
 	add_command(&stat_cmd);
+	add_command(&statx_cmd);
 	add_command(&statfs_cmd);
 }
diff --git a/io/statx.h b/io/statx.h
new file mode 100644
index 0000000..729a147
--- /dev/null
+++ b/io/statx.h
@@ -0,0 +1,158 @@
+#ifndef XFS_IO_STATX_H
+#define XFS_IO_STATX_H
+
+#include <unistd.h>
+
+#ifndef AT_STATX_SYNC_TYPE
+#define AT_STATX_SYNC_TYPE      0x6000  /* Type of synchronisation required from statx() */
+#define AT_STATX_SYNC_AS_STAT   0x0000  /* - Do whatever stat() does */
+#define AT_STATX_FORCE_SYNC     0x2000  /* - Force the attributes to be sync'd with the server */
+#define AT_STATX_DONT_SYNC      0x4000  /* - Don't sync attributes with the server */
+#endif
+
+#ifndef AT_NO_AUTOMOUNT
+#define AT_NO_AUTOMOUNT		0x800	/* Suppress terminal automount traversal */
+#endif
+
+#ifdef __i386__
+#define __NR_statx 383
+#elif defined (__ILP32__)
+#define __NR_statx (__X32_SYSCALL_BIT + 332)
+#else
+#define __NR_statx 332
+#endif
+
+#ifndef STATX_TYPE
+
+/*
+ * Timestamp structure for the timestamps in struct statx.
+ *
+ * tv_sec holds the number of seconds before (negative) or after (positive)
+ * 00:00:00 1st January 1970 UTC.
+ *
+ * tv_nsec holds a number of nanoseconds before (0..-999,999,999 if tv_sec is
+ * negative) or after (0..999,999,999 if tv_sec is positive) the tv_sec time.
+ *
+ * Note that if both tv_sec and tv_nsec are non-zero, then the two values must
+ * either be both positive or both negative.
+ *
+ * __reserved is held in case we need a yet finer resolution.
+ */
+struct statx_timestamp {
+	__s64	tv_sec;
+	__s32	tv_nsec;
+	__s32	__reserved;
+};
+
+/*
+ * Structures for the extended file attribute retrieval system call
+ * (statx()).
+ *
+ * The caller passes a mask of what they're specifically interested in as a
+ * parameter to statx().  What statx() actually got will be indicated in
+ * st_mask upon return.
+ *
+ * For each bit in the mask argument:
+ *
+ * - if the datum is not supported:
+ *
+ *   - the bit will be cleared, and
+ *
+ *   - the datum will be set to an appropriate fabricated value if one is
+ *     available (eg. CIFS can take a default uid and gid), otherwise
+ *
+ *   - the field will be cleared;
+ *
+ * - otherwise, if explicitly requested:
+ *
+ *   - the datum will be synchronised to the server if AT_STATX_FORCE_SYNC is
+ *     set or if the datum is considered out of date, and
+ *
+ *   - the field will be filled in and the bit will be set;
+ *
+ * - otherwise, if not requested, but available in approximate form without any
+ *   effort, it will be filled in anyway, and the bit will be set upon return
+ *   (it might not be up to date, however, and no attempt will be made to
+ *   synchronise the internal state first);
+ *
+ * - otherwise the field and the bit will be cleared before returning.
+ *
+ * Items in STATX_BASIC_STATS may be marked unavailable on return, but they
+ * will have values installed for compatibility purposes so that stat() and
+ * co. can be emulated in userspace.
+ */
+struct statx {
+	/* 0x00 */
+	__u32	stx_mask;	/* What results were written [uncond] */
+	__u32	stx_blksize;	/* Preferred general I/O size [uncond] */
+	__u64	stx_attributes;	/* Flags conveying information about the file [uncond] */
+	/* 0x10 */
+	__u32	stx_nlink;	/* Number of hard links */
+	__u32	stx_uid;	/* User ID of owner */
+	__u32	stx_gid;	/* Group ID of owner */
+	__u16	stx_mode;	/* File mode */
+	__u16	__spare0[1];
+	/* 0x20 */
+	__u64	stx_ino;	/* Inode number */
+	__u64	stx_size;	/* File size */
+	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
+	__u64	__spare1[1];
+	/* 0x40 */
+	struct statx_timestamp	stx_atime;	/* Last access time */
+	struct statx_timestamp	stx_btime;	/* File creation time */
+	struct statx_timestamp	stx_ctime;	/* Last attribute change time */
+	struct statx_timestamp	stx_mtime;	/* Last data modification time */
+	/* 0x80 */
+	__u32	stx_rdev_major;	/* Device ID of special file [if bdev/cdev] */
+	__u32	stx_rdev_minor;
+	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
+	__u32	stx_dev_minor;
+	/* 0x90 */
+	__u64	__spare2[14];	/* Spare space for future expansion */
+	/* 0x100 */
+};
+
+/*
+ * Flags to be stx_mask
+ *
+ * Query request/result mask for statx() and struct statx::stx_mask.
+ *
+ * These bits should be set in the mask argument of statx() to request
+ * particular items when calling statx().
+ */
+#define STATX_TYPE		0x00000001U	/* Want/got stx_mode & S_IFMT */
+#define STATX_MODE		0x00000002U	/* Want/got stx_mode & ~S_IFMT */
+#define STATX_NLINK		0x00000004U	/* Want/got stx_nlink */
+#define STATX_UID		0x00000008U	/* Want/got stx_uid */
+#define STATX_GID		0x00000010U	/* Want/got stx_gid */
+#define STATX_ATIME		0x00000020U	/* Want/got stx_atime */
+#define STATX_MTIME		0x00000040U	/* Want/got stx_mtime */
+#define STATX_CTIME		0x00000080U	/* Want/got stx_ctime */
+#define STATX_INO		0x00000100U	/* Want/got stx_ino */
+#define STATX_SIZE		0x00000200U	/* Want/got stx_size */
+#define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
+#define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
+#define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
+#define STATX_ALL		0x00000fffU	/* All currently supported flags */
+
+/*
+ * Attributes to be found in stx_attributes
+ *
+ * These give information about the features or the state of a file that might
+ * be of use to ordinary userspace programs such as GUIs or ls rather than
+ * specialised tools.
+ *
+ * Note that the flags marked [I] correspond to generic FS_IOC_FLAGS
+ * semantically.  Where possible, the numerical value is picked to correspond
+ * also.
+ */
+#define STATX_ATTR_COMPRESSED		0x00000004 /* [I] File is compressed by the fs */
+#define STATX_ATTR_IMMUTABLE		0x00000010 /* [I] File is marked immutable */
+#define STATX_ATTR_APPEND		0x00000020 /* [I] File is append-only */
+#define STATX_ATTR_NODUMP		0x00000040 /* [I] File is not to be dumped */
+#define STATX_ATTR_ENCRYPTED		0x00000800 /* [I] File requires key to decrypt in fs */
+
+#define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
+
+#endif /* STATX_TYPE */
+#endif /* XFS_IO_STATX_H */
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index e384327..f732216 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -882,6 +882,36 @@ option is specified, the atime (last access), mtime
 .B \-r
 option dumps raw fields from the stat structure.
 .TP
+.BI "statx [ \-v|\-r ][ \-m " basic " | \-m " all " | -m " <mask> " ][ \-FD ]"
+Selected statistics from
+.BR stat (2)
+and the XFS_IOC_GETXATTR system call on the current file.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-v
+Show timestamps
+.TP
+.B \-r
+Dump raw statx structure values
+.TP
+.B \-m basic 
+Set the field mask for the statx call to STATX_BASIC_STATS
+.TP
+.B \-m all
+Set the the field mask for the statx call to STATX_ALL (default)
+.TP
+.B \-m <mask>
+Specify a numeric field mask for the statx call
+.TP
+.B \-F
+Force the attributes to be synced with the server
+.TP
+.B \-D
+Don't sync attributes with the server
+.PD
+.RE
+.TP
 .B statfs
 Selected statistics from
 .BR statfs (2)

