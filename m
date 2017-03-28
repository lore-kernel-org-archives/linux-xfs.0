Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752773AbdC1ANc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 20:13:32 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170327164628.GA15147@infradead.org>
References: <20170327164628.GA15147@infradead.org> <20170327154003.GA5716@birch.djwong.org> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk> <20170324205322.GA4986@gmail.com> <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca> <23715.1490631926@warthog.procyon.org.uk>
Subject: [PATCH] Add initial batch of statx() LTP tests
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23002.1490660007.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 28 Mar 2017 01:13:27 +0100
Message-ID: <23003.1490660007@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, Andreas Dilger <adilger@dilger.ca>, Eric Biggers <ebiggers3@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Christoph Hellwig <hch@infradead.org> wrote:

> > That means a filesystem can't simply return non-basic data unconditionally if
> > possible.  I prefer letting it do so if it doesn't incur any extra I/O
> > overheads.
> 
> This seems like it will lead to userspace expecting certain fields to
> just be there, and a lot harder to properly verify for tests.  Which btw
> we all need for these odd behaviors.  If we can't get them any time soon
> (e.g. before -rc6) I think we'll simply have to revert statx instead of
> leaving this untested mess in the tree.

Here you go.  First batch of tests.  Please review - and test:-)

David
---
commit fff886ec7ee53aa266a12d9dbb2825952fa1adb9
Author: David Howells <dhowells@redhat.com>
Date:   Mon Mar 27 21:42:32 2017 +0100

    Add initial batch of statx() LTP tests
    
    Add an initial batch of statx() tests for LTP, deriving them from all of
    the stat(), fstat() and lstat() tests.
    
    Note that since statx() is not yet implemented in glibc, a header file is
    added to provide the missing system call bits.
    
    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/include/linux-statx.h b/include/linux-statx.h
new file mode 100644
index 0000000..d25fcbf
--- /dev/null
+++ b/include/linux-statx.h
@@ -0,0 +1,158 @@
+#ifndef _EXTENDED_LINUX_STAT_H
+#define _EXTENDED_LINUX_STAT_H
+
+#include <sys/stat.h>
+#include <linux/types.h>
+#include <linux/stat.h>
+
+#ifndef STATX_TYPE
+
+#ifndef __NR_statx
+#if defined(__x86_64__)
+#define __NR_statx 332
+#elif defined(__i386__)
+#define __NR_statx 383
+#endif
+#endif /* !__NR_statx */
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
+
+static inline
+ssize_t statx(int dfd, const char *filename, unsigned flags,
+	      unsigned int mask, struct statx *buffer)
+{
+	return syscall(__NR_statx, dfd, filename, flags, mask, buffer);
+}
+
+#endif /* STATX_TYPE */
+
+#endif /* _EXTENDED_LINUX_STAT_H */
diff --git a/include/tst_fs.h b/include/tst_fs.h
index 52befbe..c1885c4 100644
--- a/include/tst_fs.h
+++ b/include/tst_fs.h
@@ -201,4 +201,11 @@ static inline int tst_dir_is_empty(void (*cleanup)(void), const char *name, int
 }
 #endif
 
+/*
+ * Compare the contents of a statx struct with that of a stat struct and check
+ * that they're the same.
+ */
+struct statx;
+int tst_cmp_statx(const struct statx *stx, const struct stat *st);
+
 #endif	/* TST_FS_H__ */
diff --git a/lib/tst_cmp_stat.c b/lib/tst_cmp_stat.c
new file mode 100644
index 0000000..fe1427b
--- /dev/null
+++ b/lib/tst_cmp_stat.c
@@ -0,0 +1,73 @@
+/* Compare statx struct and stat struct contents.
+ *
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <sys/stat.h>
+#include "test.h"
+#include "linux-statx.h"
+
+/*
+ * Compare the contents of a statx struct with that of a stat struct and check
+ * that they're the same.
+ */
+int tst_cmp_statx(const struct statx *stx, const struct stat *st)
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
+	tst_resm(TINFO, "Mismatch between stx_%s and st_%s",
+		 what, what);
+	return -1;
+}
diff --git a/testcases/kernel/syscalls/statx/Makefile b/testcases/kernel/syscalls/statx/Makefile
new file mode 100644
index 0000000..bf12010
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/Makefile
@@ -0,0 +1,26 @@
+#
+#  Copyright (c) International Business Machines  Corp., 2001
+#
+#  This program is free software;  you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY;  without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+#  the GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program;  if not, write to the Free Software
+#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+top_srcdir		?= ../../../..
+
+include $(top_srcdir)/include/mk/testcases.mk
+include $(abs_srcdir)/../utils/newer_64.mk
+
+%_64: CPPFLAGS += -D_FILE_OFFSET_BITS=64
+
+include $(top_srcdir)/include/mk/generic_leaf_target.mk
diff --git a/testcases/kernel/syscalls/statx/statx01.c b/testcases/kernel/syscalls/statx/statx01.c
new file mode 100644
index 0000000..a33d23d
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx01.c
@@ -0,0 +1,166 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from stat01.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) International Business Machines  Corp., 2001
+ *  07/2001 John George
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+/*
+ *  Verify that, statx(2) succeeds to get the status of a file and fills the
+ *  statx structure elements.
+ */
+#include <stdio.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <pwd.h>
+
+#include "test.h"
+#include "safe_macros.h"
+#include "linux-statx.h"
+
+#define FILE_MODE	0644
+#define TESTFILE	"testfile"
+#define FILE_SIZE       1024
+#define BUF_SIZE	256
+#define MASK		0777
+
+char *TCID = "statx01";
+int TST_TOTAL = 1;
+
+static uid_t user_id;
+static gid_t group_id;
+
+static void setup(void);
+static void cleanup(void);
+
+static void verify(void)
+{
+	struct statx statx_buf;
+	struct stat stat_buf;
+	int fail = 0;
+
+	TEST(statx(AT_FDCWD, TESTFILE, 0, STATX_BASIC_STATS, &statx_buf));
+
+	if (TEST_RETURN == -1) {
+		tst_resm(TFAIL | TTERRNO, "statx(%s) failed", TESTFILE);
+		return;
+	}
+
+	TEST(stat(TESTFILE, &stat_buf));
+	if (TEST_RETURN == -1) {
+		tst_resm(TFAIL | TTERRNO, "stat(%s) failed", TESTFILE);
+		return;
+	}
+
+	if (tst_cmp_statx(&statx_buf, &stat_buf) == -1)
+		return;
+
+	if (statx_buf.stx_uid != user_id) {
+		tst_resm(TINFO, "statx_buf.stx_uid = %i expected %i",
+		         statx_buf.stx_uid, user_id);
+		fail++;
+	}
+
+	if (statx_buf.stx_gid != group_id) {
+		tst_resm(TINFO, "statx_buf.stx_gid = %i expected %i",
+		         statx_buf.stx_gid, group_id);
+		fail++;
+	}
+
+	if (statx_buf.stx_size != FILE_SIZE) {
+		tst_resm(TINFO, "statx_buf.stx_size = %llu expected %i",
+		         statx_buf.stx_size, FILE_SIZE);
+		fail++;
+	}
+
+        if ((statx_buf.stx_mode & MASK) != FILE_MODE) {
+		tst_resm(TINFO, "statx_buf.stx_mode = %o expected %o",
+		         (statx_buf.stx_mode & MASK), FILE_MODE);
+		fail++;
+	}
+
+	if (fail) {
+		tst_resm(TFAIL, "functionality of statx incorrect");
+		return;
+	}
+
+	tst_resm(TPASS, "functionality of stat correct");
+}
+
+int main(int ac, char **av)
+{
+	int lc;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++)
+		verify();
+
+	cleanup();
+	tst_exit();
+}
+
+static void setup(void)
+{
+	struct passwd *ltpuser;
+	char tst_buff[BUF_SIZE];
+	int wbytes;
+	int write_len = 0;
+	int fd;
+
+	tst_require_root();
+
+	tst_sig(NOFORK, DEF_HANDLER, cleanup);
+
+	ltpuser = SAFE_GETPWNAM(NULL, "nobody");
+	SAFE_SETUID(NULL, ltpuser->pw_uid);
+
+	TEST_PAUSE;
+
+	tst_tmpdir();
+
+	umask(022);
+
+	fd = SAFE_OPEN(tst_rmdir, TESTFILE, O_WRONLY | O_CREAT, FILE_MODE);
+
+	/* Fill the test buffer with the known data */
+	memset(tst_buff, 'a', BUF_SIZE - 1);
+
+	/* Write to the file 1k data from the buffer */
+	while (write_len < FILE_SIZE) {
+		if ((wbytes = write(fd, tst_buff, sizeof(tst_buff))) <= 0)
+			tst_brkm(TBROK | TERRNO, cleanup, "write failed");
+		else
+			write_len += wbytes;
+	}
+
+	SAFE_CLOSE(tst_rmdir, fd);
+
+	user_id = getuid();
+	group_id = getgid();
+}
+
+static void cleanup(void)
+{
+	tst_rmdir();
+}
diff --git a/testcases/kernel/syscalls/statx/statx02.c b/testcases/kernel/syscalls/statx/statx02.c
new file mode 100644
index 0000000..9bcbea0
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx02.c
@@ -0,0 +1,243 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from stat02.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) International Business Machines  Corp., 2001
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+/*
+ * Test Name: statx02
+ *
+ * Test Description:
+ *  Verify that, statx(2) succeeds to get the status of a file and fills the
+ *  statx structure elements though process doesn't have read access to the
+ *  file.
+ *
+ * Expected Result:
+ *  statx() should return value 0 on success and the statx structure elements
+ *  should be filled with specified 'file' information.
+ *
+ * Algorithm:
+ *  Setup:
+ *   Setup signal handling.
+ *   Create temporary directory.
+ *   Pause for SIGUSR1 if option specified.
+ *
+ *  Test:
+ *   Loop if the proper options are given.
+ *   Execute system call
+ *   Check return code, if system call failed (return=-1)
+ *   	Log the errno and Issue a FAIL message.
+ *   Otherwise,
+ *   	Verify the Functionality of system call
+ *      if successful,
+ *      	Issue Functionality-Pass message.
+ *      Otherwise,
+ *		Issue Functionality-Fail message.
+ *  Cleanup:
+ *   Print errno log and/or timing stats if options given
+ *   Delete the temporary directory created.
+ *
+ * Usage:  <for command-line>
+ *  statx02 [-c n] [-e] [-f] [-i n] [-I x] [-p x] [-t]
+ *	where,  -c n : Run n copies concurrently.
+ *		-e   : Turn on errno logging.
+ *		-f   : Turn off functionality Testing.
+ *		-i n : Execute test n times.
+ *		-I x : Execute test for x seconds.
+ *		-P x : Pause for x seconds between iterations.
+ *		-t   : Turn on syscall timing.
+ *
+ * Restrictions:
+ *
+ */
+#include <stdio.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <pwd.h>
+
+#include "test.h"
+#include "linux-statx.h"
+
+#define FILE_MODE	S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
+#define TESTFILE	"testfile"
+#define FILE_SIZE       1024
+#define BUF_SIZE	256
+#define NEW_MODE	0222
+#define MASK		0777
+
+char *TCID = "statx02";
+int TST_TOTAL = 1;
+
+uid_t user_id;			/* eff. user id/group id of test process */
+gid_t group_id;
+char nobody_uid[] = "nobody";
+struct passwd *ltpuser;
+
+void setup();
+void cleanup();
+
+int main(int ac, char **av)
+{
+	struct statx statx_buf;
+	struct stat stat_buf;
+	int lc;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+
+		tst_count = 0;
+
+		/*
+		 * Call statx(2) to get the status of
+		 * specified 'file' into statx structure.
+		 */
+		TEST(statx(AT_FDCWD, TESTFILE, 0, STATX_BASIC_STATS, &statx_buf));
+		if (TEST_RETURN == -1) {
+			tst_resm(TFAIL,
+				 "statx(%s, &statx_buf) Failed, errno=%d : %s",
+				 TESTFILE, TEST_ERRNO, strerror(TEST_ERRNO));
+			goto next;
+		}
+
+		TEST(stat(TESTFILE, &stat_buf));
+		if (TEST_RETURN == -1) {
+			tst_resm(TFAIL,
+				 "stat(%s, &statx_buf) Failed, errno=%d : %s",
+				 TESTFILE, TEST_ERRNO, strerror(TEST_ERRNO));
+			goto next;
+		}
+
+		if (tst_cmp_statx(&statx_buf, &stat_buf) == -1)
+			goto next;
+
+		statx_buf.stx_mode &= ~S_IFREG;
+		/*
+		 * Verify the data returned by statx(2) against the
+		 * expected data.
+		 */
+		if ((statx_buf.stx_uid != user_id) ||
+		    (statx_buf.stx_gid != group_id) ||
+		    (statx_buf.stx_size != FILE_SIZE) ||
+		    ((statx_buf.stx_mode & MASK) != NEW_MODE)) {
+			tst_resm(TFAIL, "Functionality of "
+				 "statx(2) on '%s' Failed",
+				 TESTFILE);
+		} else {
+			tst_resm(TPASS, "Functionality of "
+				 "statx(2) on '%s' Successful",
+				 TESTFILE);
+		}
+
+	next:
+		tst_count++;	/* incr TEST_LOOP counter */
+	}
+
+	cleanup();
+	tst_exit();
+}
+
+/*
+ * void
+ * setup() -  Performs setup function for the test.
+ *  Creat a temporary directory and change directory to it.
+ *  Creat a testfile and write some data into it.
+ *  Modify the mode permissions of testfile such that test process
+ *  has read-only access to testfile.
+ */
+void setup(void)
+{
+	int i, fd;		/* counter, file handle for file */
+	char tst_buff[BUF_SIZE];	/* data buffer for file */
+	int wbytes;		/* no. of bytes written to file */
+	int write_len = 0;
+
+	tst_require_root();
+
+	tst_sig(NOFORK, DEF_HANDLER, cleanup);
+
+	/* Switch to nobody user for correct error code collection */
+	ltpuser = getpwnam(nobody_uid);
+	if (setuid(ltpuser->pw_uid) == -1) {
+		tst_resm(TINFO, "setuid failed to "
+			 "to set the effective uid to %d", ltpuser->pw_uid);
+		perror("setuid");
+	}
+
+	/* Pause if that option was specified
+	 * TEST_PAUSE contains the code to fork the test with the -i option.
+	 * You want to make sure you do this before you create your temporary
+	 * directory.
+	 */
+	TEST_PAUSE;
+
+	tst_tmpdir();
+
+	if ((fd = open(TESTFILE, O_RDWR | O_CREAT, FILE_MODE)) == -1) {
+		tst_brkm(TBROK, cleanup,
+			 "open(%s, O_RDWR|O_CREAT, %#o) Failed, errno=%d : %s",
+			 TESTFILE, FILE_MODE, errno, strerror(errno));
+	}
+
+	/* Fill the test buffer with the known data */
+	for (i = 0; i < BUF_SIZE; i++) {
+		tst_buff[i] = 'a';
+	}
+
+	/* Write to the file 1k data from the buffer */
+	while (write_len < FILE_SIZE) {
+		if ((wbytes = write(fd, tst_buff, sizeof(tst_buff))) <= 0) {
+			tst_brkm(TBROK | TERRNO, cleanup, "write to %s failed",
+				 TESTFILE);
+		} else {
+			write_len += wbytes;
+		}
+	}
+
+	if (close(fd) == -1) {
+		tst_resm(TWARN | TERRNO, "closing %s failed", TESTFILE);
+	}
+
+	/* Modify mode permissions on the testfile */
+	if (chmod(TESTFILE, NEW_MODE) < 0) {
+		tst_brkm(TBROK | TERRNO, cleanup, "chmodding %s failed",
+			 TESTFILE);
+	}
+
+	/* Get the uid/gid of the process */
+	user_id = getuid();
+	group_id = getgid();
+
+}
+
+/*
+ * cleanup() - performs all ONE TIME cleanup for this test at
+ *	       completion or premature exit.
+ *  Remove the temporary directory and file created.
+ */
+void cleanup(void)
+{
+
+	tst_rmdir();
+}
diff --git a/testcases/kernel/syscalls/statx/statx03.c b/testcases/kernel/syscalls/statx/statx03.c
new file mode 100644
index 0000000..24f5b60
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx03.c
@@ -0,0 +1,388 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from stat03.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) International Business Machines  Corp., 2001
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+/*
+ * Test Name: statx03
+ *
+ * Test Description:
+ *   Verify that,
+ *   1) statx(2) returns -1 and sets errno to EACCES if search permission is
+ *      denied on a component of the path prefix.
+ *   2) statx(2) returns -1 and sets errno to ENOENT if the specified file
+ *	does not exists or empty string.
+ *   3) statx(2) returns -1 and sets errno to EFAULT if pathname points
+ *	outside user's accessible address space.
+ *   4) statx(2) returns -1 and sets errno to ENAMETOOLONG if the pathname
+ *	component is too long.
+ *   5) statx(2) returns -1 and sets errno to ENOTDIR if the directory
+ *	component in pathname is not a directory.
+ *
+ * Expected Result:
+ *  statx() should fail with return value -1 and set expected errno.
+ *
+ * Algorithm:
+ *  Setup:
+ *   Setup signal handling.
+ *   Create temporary directory.
+ *   Pause for SIGUSR1 if option specified.
+ *
+ *  Test:
+ *   Loop if the proper options are given.
+ *   Execute system call
+ *   Check return code, if system call failed (return=-1)
+ *   	if errno set == expected errno
+ *   		Issue sys call fails with expected return value and errno.
+ *   	Otherwise,
+ *		Issue sys call fails with unexpected errno.
+ *   Otherwise,
+ *	Issue sys call returns unexpected value.
+ *
+ *  Cleanup:
+ *   Print errno log and/or timing stats if options given
+ *   Delete the temporary directory(s)/file(s) created.
+ *
+ * Usage:  <for command-line>
+ *  statx03 [-c n] [-e] [-i n] [-I x] [-p x] [-t]
+ *	where,  -c n : Run n copies concurrently.
+ *		-e   : Turn on errno logging.
+ *		-i n : Execute test n times.
+ *		-I x : Execute test for x seconds.
+ *		-P x : Pause for x seconds between iterations.
+ *		-t   : Turn on syscall timing.
+ *
+ * Restrictions:
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <pwd.h>
+
+#include "test.h"
+#include "linux-statx.h"
+
+#define MODE_RWX	S_IRWXU | S_IRWXG | S_IRWXO
+#define FILE_MODE	S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
+#define DIR_TEMP	"testdir_1"
+#define TEST_FILE1	"testdir_1/tfile_1"
+#define TEST_FILE2	"t_file/tfile_2"
+
+int no_setup();
+int setup1();			/* setup function to test chmod for EACCES */
+int setup2();			/* setup function to test chmod for ENOTDIR */
+int longpath_setup();		/* setup function to test chmod for ENAMETOOLONG */
+char nobody_uid[] = "nobody";
+struct passwd *ltpuser;
+
+char Longpathname[PATH_MAX + 2];
+char High_address_node[64];
+
+struct test_case_t {		/* test case struct. to hold ref. test cond's */
+	char *pathname;
+	char *desc;
+	int exp_errno;
+	int (*setupfunc) ();
+} Test_cases[] = {
+	{
+	TEST_FILE1, "No Search permissions to process", EACCES, setup1},
+#if !defined(UCLINUX)
+	{
+	High_address_node, "Address beyond address space", EFAULT, no_setup},
+	{
+	(char *)-1, "Negative address", EFAULT, no_setup},
+#endif
+	{
+	Longpathname, "Pathname too long", ENAMETOOLONG, longpath_setup}, {
+	"", "Pathname is empty", ENOENT, no_setup}, {
+	TEST_FILE2, "Path contains regular file", ENOTDIR, setup2}, {
+	NULL, NULL, 0, no_setup}
+};
+
+char *TCID = "statx03";
+int TST_TOTAL = ARRAY_SIZE(Test_cases);
+
+char *bad_addr = 0;
+
+void setup();			/* Main setup function for the tests */
+void cleanup();			/* cleanup function for the test */
+
+int main(int ac, char **av)
+{
+	struct statx statx_buf;
+	struct stat stat_buf;
+	int lc;
+	char *file_name;	/* ptr. for file name whose mode is modified */
+	char *test_desc;	/* test specific error message */
+	int ind;		/* counter to test different test conditions */
+	int x_retval, x_errno;
+	int s_retval, s_errno;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	/*
+	 * Invoke setup function to call individual test setup functions
+	 * to simulate test conditions.
+	 */
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+
+		tst_count = 0;
+
+		for (ind = 0; Test_cases[ind].desc != NULL; ind++) {
+			file_name = Test_cases[ind].pathname;
+			test_desc = Test_cases[ind].desc;
+
+#if !defined(UCLINUX)
+			if (file_name == High_address_node) {
+				file_name = (char *)get_high_address();
+			}
+#endif
+
+			/*
+			 * Call statx(2) to test different test conditions.
+			 * verify that it fails with -1 return value and
+			 * sets appropriate errno.
+			 */
+			TEST(statx(AT_FDCWD, file_name, 0, STATX_BASIC_STATS, &statx_buf));
+			x_retval = TEST_RETURN;
+			x_errno = TEST_ERRNO;
+			TEST(stat(file_name, &stat_buf));
+			s_retval = TEST_RETURN;
+			s_errno = TEST_ERRNO;
+
+			/* Check return code from statx(2) */
+			if (x_retval != s_retval) {
+				tst_resm(TFAIL,
+					 "statx(), %s, return %d inconsistent with"
+					 " stat() return %d, expected errno:%d",
+					 test_desc, x_retval, s_retval,
+					 Test_cases[ind].exp_errno);
+			} else if (x_retval == -1 && x_errno != s_errno) {
+				tst_resm(TFAIL,
+					 "statx(), %s, error %d inconsistent with"
+					 " stat() error %d, exp %d",
+					 test_desc, x_errno, s_errno,
+					 Test_cases[ind].exp_errno);
+			} else if (TEST_RETURN == -1) {
+				if (TEST_ERRNO == Test_cases[ind].exp_errno) {
+					tst_resm(TPASS,
+						 "statx() fails, %s, errno:%d",
+						 test_desc, TEST_ERRNO);
+				} else {
+					tst_resm(TFAIL,
+						 "statx() fails, %s, errno:%d, expected errno:%d",
+						 test_desc, TEST_ERRNO,
+						 Test_cases[ind].exp_errno);
+				}
+			} else if (tst_cmp_statx(&statx_buf, &stat_buf) == -1) {
+				;
+			} else {
+				tst_resm(TFAIL,
+					 "statx(2) returned %ld, expected -1, errno:%d",
+					 TEST_RETURN,
+					 Test_cases[ind].exp_errno);
+			}
+		}
+		tst_count++;	/* incr TEST_LOOP counter */
+	}
+
+	/*
+	 * Invoke cleanup() to delete the test directory/file(s) created
+	 * in the setup().
+	 */
+	cleanup();
+	tst_exit();
+
+}
+
+/*
+ * void
+ * setup(void) - performs all ONE TIME setup for this test.
+ * 	Exit the test program on receipt of unexpected signals.
+ *	Create a temporary directory and change directory to it.
+ *	Invoke individual test setup functions according to the order
+ *	set in struct. definition.
+ */
+void setup(void)
+{
+	int ind;
+
+	tst_require_root();
+
+	/* Capture unexpected signals */
+	tst_sig(FORK, DEF_HANDLER, cleanup);
+
+	/* Switch to nobody user for correct error code collection */
+	ltpuser = getpwnam(nobody_uid);
+	if (setuid(ltpuser->pw_uid) == -1) {
+		tst_resm(TINFO, "setuid failed to "
+			 "to set the effective uid to %d", ltpuser->pw_uid);
+		perror("setuid");
+	}
+
+	/* Pause if that option was specified
+	 * TEST_PAUSE contains the code to fork the test with the -i option.
+	 * You want to make sure you do this before you create your temporary
+	 * directory.
+	 */
+	TEST_PAUSE;
+
+	/* Make a temp dir and cd to it */
+	tst_tmpdir();
+
+#if !defined(UCLINUX)
+	bad_addr = mmap(0, 1, PROT_NONE,
+			MAP_PRIVATE_EXCEPT_UCLINUX | MAP_ANONYMOUS, 0, 0);
+	if (bad_addr == MAP_FAILED) {
+		tst_brkm(TBROK, cleanup, "mmap failed");
+	}
+	Test_cases[2].pathname = bad_addr;
+#endif
+
+	/* call individual setup functions */
+	for (ind = 0; Test_cases[ind].desc != NULL; ind++) {
+		Test_cases[ind].setupfunc();
+	}
+}
+
+/*
+ * int
+ * no_setup() - Some test conditions for statx(2) do not any setup.
+ *              Hence, this function just returns 0.
+ *  This function simply returns 0.
+ */
+int no_setup(void)
+{
+	return 0;
+}
+
+/*
+ * int
+ * setup1() - setup function for a test condition for which statx(2)
+ *	      returns -1 and sets errno to EACCES.
+ *  Create a test directory under temporary directory and create a test file
+ *  under this directory with mode "0666" permissions.
+ *  Modify the mode permissions on test directory such that process will not
+ *  have search permissions on test directory.
+ *
+ *  The function returns 0.
+ */
+int setup1(void)
+{
+	int fd;			/* file handle for testfile */
+
+	/* Creat a test directory */
+	if (mkdir(DIR_TEMP, MODE_RWX) < 0) {
+		tst_brkm(TBROK, cleanup, "mkdir(2) of %s failed", DIR_TEMP);
+	}
+
+	/* Creat a test file under above test directory */
+	if ((fd = open(TEST_FILE1, O_RDWR | O_CREAT, 0666)) == -1) {
+		tst_brkm(TBROK, cleanup,
+			 "open(%s, O_RDWR|O_CREAT, 0666) failed, errno=%d : %s",
+			 TEST_FILE1, errno, strerror(errno));
+	}
+	/* Close the test file */
+	if (close(fd) == -1) {
+		tst_brkm(TBROK, cleanup,
+			 "close(%s) Failed, errno=%d : %s",
+			 TEST_FILE1, errno, strerror(errno));
+	}
+
+	/* Modify mode permissions on test directory */
+	if (chmod(DIR_TEMP, FILE_MODE) < 0) {
+		tst_brkm(TBROK, cleanup, "chmod(2) of %s failed", DIR_TEMP);
+	}
+	return 0;
+}
+
+/*
+ * int
+ * setup2() - setup function for a test condition for which statx(2)
+ *	     returns -1 and sets errno to ENOTDIR.
+ *
+ *  Create a test file under temporary directory so that test tries to
+ *  change mode of a testfile "tfile_2" under "t_file" which happens to be
+ *  another regular file.
+ */
+int setup2(void)
+{
+	int fd;			/* File handle for test file */
+
+	/* Creat a test file under temporary directory */
+	if ((fd = open("t_file", O_RDWR | O_CREAT, MODE_RWX)) == -1) {
+		tst_brkm(TBROK, cleanup,
+			 "open(2) on t_file failed, errno=%d : %s",
+			 errno, strerror(errno));
+	}
+	/* Close the test file created above */
+	if (close(fd) == -1) {
+		tst_brkm(TBROK, cleanup,
+			 "close(t_file) Failed, errno=%d : %s",
+			 errno, strerror(errno));
+	}
+	return 0;
+}
+
+/*
+ * int
+ * longpath_setup() - setup to create a node with a name length exceeding
+ *                    the MAX. length of PATH_MAX.
+ *   This function retruns 0.
+ */
+int longpath_setup(void)
+{
+	int ind;		/* counter variable */
+
+	for (ind = 0; ind <= (PATH_MAX + 1); ind++) {
+		Longpathname[ind] = 'a';
+	}
+	return 0;
+}
+
+/*
+ * void
+ * cleanup() - Performs all ONE TIME cleanup for this test at
+ *             completion or premature exit.
+ *	Print test timing stats and errno log if test executed with options.
+ *	Remove temporary directory and sub-directories/files under it
+ *	created during setup().
+ *	Exit the test program with normal exit code.
+ */
+void cleanup(void)
+{
+
+	/* Restore mode permissions on test directory created in setup2() */
+	if (chmod(DIR_TEMP, MODE_RWX) < 0) {
+		tst_brkm(TFAIL, NULL, "chmod(2) of %s failed", DIR_TEMP);
+	}
+
+	tst_rmdir();
+}
diff --git a/testcases/kernel/syscalls/statx/statx05.c b/testcases/kernel/syscalls/statx/statx05.c
new file mode 100644
index 0000000..8726e48
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx05.c
@@ -0,0 +1,206 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from stat05.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) 2000 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Further, this software is distributed without any warranty that it is
+ * free of the rightful claim of any third person regarding infringement
+ * or the like.  Any license provided herein, whether implied or
+ * otherwise, applies only to this software file.  Patent licenses, if
+ * any, provided herein do not apply to combinations of this program with
+ * other software, or any other product whatsoever.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Contact information: Silicon Graphics, Inc., 1600 Amphitheatre Pkwy,
+ * Mountain View, CA  94043, or:
+ *
+ * http://www.sgi.com
+ *
+ * For further information regarding this notice, see:
+ *
+ * http://oss.sgi.com/projects/GenInfo/NoticeExplan/
+ *
+ */
+
+/**********************************************************
+ *
+ *    TEST IDENTIFIER	: statx05
+ *
+ *    EXECUTED BY	: anyone
+ *
+ *    TEST TITLE	: Basic test for statx(2)
+ *
+ *    TEST CASE TOTAL	: 1
+ *
+ *    WALL CLOCK TIME	: 1
+ *
+ *    CPU TYPES		: ALL
+ *
+ *    TEST CASES
+ *
+ * 	1.) statx(2) returns...(See Description)
+ *
+ *    INPUT SPECIFICATIONS
+ * 	The standard options for system call tests are accepted.
+ *	(See the parse_opts(3) man page).
+ *
+ *    OUTPUT SPECIFICATIONS
+ *$
+ *    DURATION
+ * 	Terminates - with frequency and infinite modes.
+ *
+ *    SIGNALS
+ * 	Uses SIGUSR1 to pause before test if option set.
+ * 	(See the parse_opts(3) man page).
+ *
+ *    RESOURCES
+ * 	None
+ *
+ *    ENVIRONMENTAL NEEDS
+ *      No run-time environmental needs.
+ *
+ *    SPECIAL PROCEDURAL REQUIREMENTS
+ * 	None
+ *
+ *    INTERCASE DEPENDENCIES
+ * 	None
+ *
+ *    DETAILED DESCRIPTION
+ *	This is a Phase I test for the statx(2) system call.  It is intended
+ *	to provide a limited exposure of the system call, for now.  It
+ *	should/will be extended when full functional tests are written for
+ *	statx(2).
+ *
+ * 	Setup:
+ * 	  Setup signal handling.
+ *	  Pause for SIGUSR1 if option specified.
+ *
+ * 	Test:
+ *	 Loop if the proper options are given.
+ * 	  Execute system call
+ *	  Check return code, if system call failed (return=-1)
+ *		Log the errno and Issue a FAIL message.
+ *	  Otherwise, Issue a PASS message.
+ *
+ * 	Cleanup:
+ * 	  Print errno log and/or timing stats if options given
+ *
+ *
+ *#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#**/
+
+#include <sys/types.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include "test.h"
+#include "linux-statx.h"
+
+void setup();
+void cleanup();
+
+char *TCID = "statx05";
+int TST_TOTAL = 1;
+
+char fname[255];
+int fd;
+struct statx stxatter;
+struct stat statter;
+
+int main(int ac, char **av)
+{
+	int x_retval, x_errno;
+	int s_retval, s_errno;
+	int lc;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+
+		tst_count = 0;
+
+		/*
+		 * Call statx(2) with F_CLRALF argument on fname
+		 */
+		TEST(statx(AT_FDCWD, fname, 0, STATX_BASIC_STATS, &stxatter));
+		x_retval = TEST_RETURN;
+		x_errno = TEST_ERRNO;
+		TEST(stat(fname, &statter));
+		s_retval = TEST_RETURN;
+		s_errno = TEST_ERRNO;
+
+		/* check return code */
+		if (x_retval != s_retval) {
+			tst_resm(TFAIL,
+				 "statx() return %d inconsistent with"
+				 " stat() return %d",
+				 x_retval, s_retval);
+		} else if (x_retval == -1 && x_errno != s_errno) {
+			tst_resm(TFAIL,
+				 "statx() error %d inconsistent with"
+				 " stat() error %d",
+				 x_errno, s_errno);
+		} else if (TEST_RETURN == -1) {
+			tst_resm(TFAIL, "statx(%s, &statter) failed", fname);
+		} else if (tst_cmp_statx(&stxatter, &statter) == -1) {
+			;
+		} else {
+			tst_resm(TPASS,
+				 "statx(%s, &stxatter) returned %ld",
+				 fname, TEST_RETURN);
+		}
+
+	}
+
+	cleanup();
+	tst_exit();
+}
+
+/***************************************************************
+ * setup() - performs all ONE TIME setup for this test.
+ ***************************************************************/
+void setup(void)
+{
+
+	tst_sig(NOFORK, DEF_HANDLER, cleanup);
+
+	TEST_PAUSE;
+
+	tst_tmpdir();
+
+	sprintf(fname, "tfile_%d", getpid());
+	if ((fd = open(fname, O_RDWR | O_CREAT, 0700)) == -1) {
+		tst_brkm(TBROK, cleanup,
+			 "open(%s, O_RDWR|O_CREAT,0700) Failed, errno=%d : %s",
+			 fname, errno, strerror(errno));
+	}
+
+	if (close(fd) == -1) {
+		tst_resm(TWARN | TERRNO, "close(%s) failed", fname);
+	}
+}
+
+/***************************************************************
+ * cleanup() - performs all ONE TIME cleanup for this test at
+ *		completion or premature exit.
+ ***************************************************************/
+void cleanup(void)
+{
+
+	tst_rmdir();
+}
diff --git a/testcases/kernel/syscalls/statx/statx06.c b/testcases/kernel/syscalls/statx/statx06.c
new file mode 100644
index 0000000..5f931fb
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx06.c
@@ -0,0 +1,355 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from stat06.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) 2000 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Further, this software is distributed without any warranty that it is
+ * free of the rightful claim of any third person regarding infringement
+ * or the like.  Any license provided herein, whether implied or
+ * otherwise, applies only to this software file.  Patent licenses, if
+ * any, provided herein do not apply to combinations of this program with
+ * other software, or any other product whatsoever.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Contact information: Silicon Graphics, Inc., 1600 Amphitheatre Pkwy,
+ * Mountain View, CA  94043, or:
+ *
+ * http://www.sgi.com
+ *
+ * For further information regarding this notice, see:
+ *
+ * http://oss.sgi.com/projects/GenInfo/NoticeExplan/
+ *
+ */
+
+/**********************************************************
+ *
+ *    TEST IDENTIFIER	: statx06
+ *
+ *    EXECUTED BY	: anyone
+ *
+ *    TEST TITLE	: statx(2) negative path testcases
+ *
+ *    TEST CASE TOTAL	: 7
+ *
+ *    WALL CLOCK TIME	: 1
+ *
+ *    CPU TYPES		: ALL
+ *
+ *    TEST CASES
+ *
+ * 	1-7) See Testcases structure below.
+ *
+ *    INPUT SPECIFICATIONS
+ * 	The standard options for system call tests are accepted.
+ *	(See the parse_opts(3) man page).
+ *      -h  : print help and exit
+ *
+ *    OUTPUT SPECIFICATIONS
+ *$
+ *    DURATION
+ * 	Terminates - with frequency and infinite modes.
+ *
+ *    SIGNALS
+ * 	Uses SIGUSR1 to pause before test if option set.
+ * 	(See the parse_opts(3) man page).
+ *
+ *    RESOURCES
+ * 	None
+ *
+ *    ENVIRONMENTAL NEEDS
+ * 	The libcuts.a and libsys.a libraries must be included in
+ *	the compilation of this test.
+ *
+ *    SPECIAL PROCEDURAL REQUIREMENTS
+ * 	None
+ *
+ *    INTERCASE DEPENDENCIES
+ * 	None
+ *
+ *    DETAILED DESCRIPTION
+ *	This is a Phase I test for the statx(2) system call.  It is intended
+ *	to provide a limited exposure of the system call, for now.  It
+ *	should/will be extended when full functional tests are written for
+ *	statx(2).
+ *
+ * 	Setup:
+ * 	  Setup signal handling.
+ *	  Pause for SIGUSR1 if option specified.
+ *
+ * 	Test:
+ *	 Loop if the proper options are given.
+ * 	  Execute system call
+ *	  Check return code, if system call failed (return=-1)
+ *		Log the errno and Issue a FAIL message.
+ *	  Otherwise, Issue a PASS message.
+ *
+ * 	Cleanup:
+ * 	  Print errno log and/or timing stats if options given
+ *
+ *
+ *#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#**/
+
+#include <sys/types.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <setjmp.h>
+#include <unistd.h>
+#include "test.h"
+#include "linux-statx.h"
+
+void setup();
+void cleanup();
+
+char *TCID = "statx06";
+
+char *bad_addr = 0;
+
+#if !defined(UCLINUX)
+int high_address_setup();
+char High_address[64];
+#endif
+int longpath_setup();
+int no_setup();
+int filepath_setup();
+char Longpathname[PATH_MAX + 2];
+struct statx statxbuf;
+jmp_buf sig11_recover;
+void sig11_handler(int sig);
+
+struct test_case_t {
+	char *pathname;
+	struct statx *stxbuf;
+	char *desc;
+	int exp_errno;
+	int (*setupfunc) ();
+} Test_cases[] = {
+	{
+	"nonexistfile", &statxbuf, "non-existent file", ENOENT, no_setup}, {
+	"", &statxbuf, "path is empty string", ENOENT, no_setup}, {
+	"nefile/file", &statxbuf, "path contains a non-existent file",
+		    ENOENT, no_setup}, {
+	"file/file", &statxbuf, "path contains a regular file",
+		    ENOTDIR, filepath_setup}, {
+	Longpathname, &statxbuf, "pathname too long", ENAMETOOLONG,
+		    longpath_setup},
+#if !defined(UCLINUX)
+	{
+	High_address, &statxbuf, "address beyond address space", EFAULT,
+		    high_address_setup}, {
+	(char *)-1, &statxbuf, "negative address", EFAULT, no_setup},
+#endif
+	{
+	NULL, NULL, NULL, 0, no_setup}
+};
+
+int TST_TOTAL = ARRAY_SIZE(Test_cases);
+
+/***********************************************************************
+ * Main
+ ***********************************************************************/
+int main(int ac, char **av)
+{
+	int lc;
+	char *fname;
+	char *desc;
+	int ind;
+	struct statx *stxbuf;
+	struct sigaction sa, osa;
+
+    /***************************************************************
+     * parse standard options
+     ***************************************************************/
+	tst_parse_opts(ac, av, NULL, NULL);
+
+    /***************************************************************
+     * perform global setup for test
+     ***************************************************************/
+	setup();
+
+    /***************************************************************
+     * check looping state if -c option given
+     ***************************************************************/
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+
+		tst_count = 0;
+
+		for (ind = 0; Test_cases[ind].desc != NULL; ind++) {
+
+			fname = Test_cases[ind].pathname;
+			desc = Test_cases[ind].desc;
+			stxbuf = Test_cases[ind].stxbuf;
+
+			if (stxbuf == (struct statx *)-1L) {
+				/* special sig11 case */
+				sa.sa_handler = &sig11_handler;
+				sigemptyset(&sa.sa_mask);
+				sa.sa_flags = 0;
+
+				sigaction(SIGSEGV, NULL, &osa);
+				sigaction(SIGSEGV, &sa, NULL);
+
+				if (setjmp(sig11_recover)) {
+					TEST_RETURN = -1;
+					TEST_ERRNO = EFAULT;
+				} else {
+					TEST(statx(AT_FDCWD, fname, 0,
+						   STATX_BASIC_STATS, stxbuf));
+				}
+				sigaction(SIGSEGV, &osa, NULL);
+			} else {
+				/*
+				 *  Call statx(2)
+				 */
+
+				TEST(statx(AT_FDCWD, fname, 0,
+					   STATX_BASIC_STATS, stxbuf));
+			}
+
+			/* check return code */
+			if (TEST_RETURN == -1) {
+				if (TEST_ERRNO ==
+				    Test_cases[ind].exp_errno)
+					tst_resm(TPASS,
+						 "statx(<%s>, &stbuf) Failed, errno=%d",
+						 desc, TEST_ERRNO);
+				else
+					tst_resm(TFAIL,
+						 "statx(<%s>, &stbuf) Failed, errno=%d, expected errno:%d",
+						 desc, TEST_ERRNO,
+						 Test_cases
+						 [ind].exp_errno);
+			} else {
+				tst_resm(TFAIL,
+					 "statx(<%s>, &stbuf) returned %ld, expected -1, errno:%d",
+					 desc, TEST_RETURN,
+					 Test_cases[ind].exp_errno);
+			}
+		}
+
+	}
+
+	cleanup();
+	tst_exit();
+}
+
+/***************************************************************
+ * setup() - performs all ONE TIME setup for this test.
+ ***************************************************************/
+void setup(void)
+{
+	int ind;
+
+	tst_sig(NOFORK, DEF_HANDLER, cleanup);
+
+	TEST_PAUSE;
+
+	tst_tmpdir();
+
+#if !defined(UCLINUX)
+	bad_addr = mmap(0, 1, PROT_NONE,
+			MAP_PRIVATE_EXCEPT_UCLINUX | MAP_ANONYMOUS, 0, 0);
+	if (bad_addr == MAP_FAILED) {
+		tst_brkm(TBROK, cleanup, "mmap failed");
+	}
+	Test_cases[6].pathname = bad_addr;
+#endif
+
+	for (ind = 0; Test_cases[ind].desc != NULL; ind++) {
+		Test_cases[ind].setupfunc();
+	}
+
+}
+
+/***************************************************************
+ * cleanup() - performs all ONE TIME cleanup for this test at
+ *		completion or premature exit.
+ ***************************************************************/
+void cleanup(void)
+{
+
+	tst_rmdir();
+
+}
+
+/******************************************************************
+ * no_setup() - does nothing
+ ******************************************************************/
+int no_setup(void)
+{
+	return 0;
+}
+
+#if !defined(UCLINUX)
+
+/******************************************************************
+ * high_address_setup() - generates an address that should cause a segfault
+ ******************************************************************/
+int high_address_setup(void)
+{
+	int ind;
+
+	for (ind = 0; Test_cases[ind].desc != NULL; ind++) {
+		if (Test_cases[ind].pathname == High_address) {
+			/*if (strcmp(Test_cases[ind].pathname, HIGH_ADDRESS) == 0) { ** */
+			Test_cases[ind].pathname = (char *)(sbrk(0) + 5);
+			break;
+		}
+	}
+	return 0;
+
+}
+#endif
+
+/******************************************************************
+ * longpath_setup() - creates a filename that is too long
+ ******************************************************************/
+int longpath_setup(void)
+{
+	int ind;
+
+	for (ind = 0; ind <= PATH_MAX + 1; ind++) {
+		Longpathname[ind] = 'a';
+	}
+	return 0;
+
+}
+
+/******************************************************************
+ * filepath_setup() creates a file the exists that we will treat as a directory
+ ******************************************************************/
+int filepath_setup(void)
+{
+	int fd;
+
+	if ((fd = creat("file", 0777)) == -1) {
+		tst_brkm(TBROK, cleanup, "creat(file) failed, errno:%d %s",
+			 errno, strerror(errno));
+	}
+	close(fd);
+	return 0;
+}
+
+/******************************************************************
+ * sig11_handler() - our segfault recover hack
+ ******************************************************************/
+void sig11_handler(int sig)
+{
+	longjmp(sig11_recover, 1);
+}
diff --git a/testcases/kernel/syscalls/statx/statx11.c b/testcases/kernel/syscalls/statx/statx11.c
new file mode 100644
index 0000000..cae9fb0
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx11.c
@@ -0,0 +1,179 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from fstat01.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) 2000 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Further, this software is distributed without any warranty that it is
+ * free of the rightful claim of any third person regarding infringement
+ * or the like.  Any license provided herein, whether implied or
+ * otherwise, applies only to this software file.  Patent licenses, if
+ * any, provided herein do not apply to combinations of this program with
+ * other software, or any other product whatsoever.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Contact information: Silicon Graphics, Inc., 1600 Amphitheatre Pkwy,
+ * Mountain View, CA  94043, or:
+ *
+ * http://www.sgi.com
+ *
+ * For further information regarding this notice, see:
+ *
+ * http://oss.sgi.com/projects/GenInfo/NoticeExplan/
+ *
+ */
+
+/**********************************************************
+ *
+ *    TEST IDENTIFIER	: statx11
+ *
+ *    EXECUTED BY	: anyone
+ *
+ *    TEST TITLE	: Basic test for statx(2) on fd
+ *
+ *    TEST CASE TOTAL	: 1
+ *
+ *    WALL CLOCK TIME	: 1
+ *
+ *    CPU TYPES		: ALL
+ *
+ *    TEST CASES
+ *
+ *	1.) statx(2) on fd returns...(See Description)
+ *
+ *    INPUT SPECIFICATIONS
+ *	The standard options for system call tests are accepted.
+ *	(See the parse_opts(3) man page).
+ *
+ *    OUTPUT SPECIFICATIONS
+ *
+ *    DURATION
+ *	Terminates - with frequency and infinite modes.
+ *
+ *    SIGNALS
+ *	Uses SIGUSR1 to pause before test if option set.
+ *	(See the parse_opts(3) man page).
+ *
+ *    RESOURCES
+ *	None
+ *
+ *    ENVIRONMENTAL NEEDS
+ *      No run-time environmental needs.
+ *
+ *    SPECIAL PROCEDURAL REQUIREMENTS
+ *	None
+ *
+ *    INTERCASE DEPENDENCIES
+ *	None
+ *
+ *    DETAILED DESCRIPTION
+ *	This is a Phase I test for the statx(2) system call.  It is intended
+ *	to provide a limited exposure of the system call, for now.  It
+ *	should/will be extended when full functional tests are written for
+ *	statx(2).
+ *
+ *	Setup:
+ *	  Setup signal handling.
+ *	  Pause for SIGUSR1 if option specified.
+ *
+ *	Test:
+ *	 Loop if the proper options are given.
+ *	  Execute system call
+ *	  Check return code, if system call failed (return=-1)
+ *		Log the errno and Issue a FAIL message.
+ *	  Otherwise, Issue a PASS message.
+ *
+ *	Cleanup:
+ *	  Print errno log and/or timing stats if options given
+ *
+ *
+ *#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#**/
+
+#include <sys/types.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include "test.h"
+#include "linux-statx.h"
+
+void setup();
+void cleanup();
+
+char *TCID = "statx11";
+int TST_TOTAL = 1;
+
+char fname[255];
+int fd;
+struct statx stxatter;
+struct stat statter;
+
+int main(int ac, char **av)
+{
+	int lc;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+
+		tst_count = 0;
+
+		TEST(statx(fd, NULL, 0, STATX_BASIC_STATS, &stxatter));
+		if (TEST_RETURN == -1) {
+			tst_resm(TFAIL | TTERRNO, "statx failed");
+			continue;
+		}
+
+		TEST(fstat(fd, &statter));
+		if (TEST_RETURN == -1) {
+			tst_resm(TFAIL | TTERRNO, "fstat failed");
+			continue;
+		}
+
+		if (tst_cmp_statx(&stxatter, &statter) == -1)
+			continue;
+
+		tst_resm(TPASS, "statx on fd returned %ld", TEST_RETURN);
+	}
+
+	cleanup();
+	tst_exit();
+}
+
+void setup(void)
+{
+
+	tst_sig(NOFORK, DEF_HANDLER, cleanup);
+
+	TEST_PAUSE;
+
+	tst_tmpdir();
+
+	sprintf(fname, "tfile_%d", getpid());
+	fd = open(fname, O_RDWR | O_CREAT, 0700);
+	if (fd == -1)
+		tst_brkm(TBROK | TERRNO, cleanup, "open failed");
+}
+
+void cleanup(void)
+{
+	if (close(fd) == -1)
+		tst_resm(TWARN | TERRNO, "close(%s) failed", fname);
+
+	tst_rmdir();
+
+}
diff --git a/testcases/kernel/syscalls/statx/statx12.c b/testcases/kernel/syscalls/statx/statx12.c
new file mode 100644
index 0000000..06fd2a6
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx12.c
@@ -0,0 +1,164 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from fstat02.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) International Business Machines  Corp., 2001
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+/*
+ * fstat() should return value 0 on success and the stat structure elements
+ * should be filled with specified 'file' information.
+ */
+#include <stdio.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <pwd.h>
+
+#include "test.h"
+#include "safe_macros.h"
+#include "linux-statx.h"
+
+#define FILE_MODE	0644
+#define TESTFILE	"testfile"
+#define FILE_SIZE       1024
+#define BUF_SIZE	256
+#define MASK		0777
+
+char *TCID = "statx12";
+int TST_TOTAL = 1;
+static uid_t user_id;
+static gid_t group_id;
+static int fildes;
+
+static void setup(void);
+static void cleanup(void);
+
+static void verify(void)
+{
+	struct statx statx_buf;
+	struct stat stat_buf;
+	int fail = 0;
+
+	TEST(statx(fildes, NULL, 0, STATX_BASIC_STATS, &statx_buf));
+	if (TEST_RETURN == -1) {
+		tst_resm(TFAIL | TTERRNO, "statx(%s) failed", TESTFILE);
+		return;
+	}
+
+	TEST(fstat(fildes, &stat_buf));
+	if (TEST_RETURN == -1) {
+		tst_resm(TFAIL | TTERRNO, "fstat(%s) failed", TESTFILE);
+		return;
+	}
+
+	if (tst_cmp_statx(&statx_buf, &stat_buf) == -1)
+		return;
+
+	if (statx_buf.stx_uid != user_id) {
+		tst_resm(TINFO, "statx_buf.stx_uid = %i expected %i",
+		         statx_buf.stx_uid, user_id);
+		fail++;
+	}
+
+	if (statx_buf.stx_gid != group_id) {
+		tst_resm(TINFO, "statx_buf.stx_gid = %i expected %i",
+		         statx_buf.stx_gid, group_id);
+		fail++;
+	}
+
+	if (statx_buf.stx_size != FILE_SIZE) {
+		tst_resm(TINFO, "statx_buf.stx_size = %llu expected %i",
+		         statx_buf.stx_size, FILE_SIZE);
+		fail++;
+	}
+
+        if ((statx_buf.stx_mode & MASK) != FILE_MODE) {
+		tst_resm(TINFO, "statx_buf.stx_mode = %o expected %o",
+		         (statx_buf.stx_mode & MASK), FILE_MODE);
+		fail++;
+	}
+
+	if (fail) {
+		tst_resm(TFAIL, "functionality of statx on fd incorrect");
+		return;
+	}
+
+	tst_resm(TPASS, "functionality of statx on fd correct");
+}
+
+int main(int ac, char **av)
+{
+	int lc;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++)
+		verify();
+
+	cleanup();
+	tst_exit();
+}
+
+static void setup(void)
+{
+	struct passwd *ltpuser;
+	char tst_buff[BUF_SIZE];
+	int wbytes;
+	int write_len = 0;
+
+	tst_require_root();
+
+	tst_sig(NOFORK, DEF_HANDLER, cleanup);
+
+	ltpuser = SAFE_GETPWNAM(NULL, "nobody");
+	SAFE_SETUID(NULL, ltpuser->pw_uid);
+
+	TEST_PAUSE;
+
+	tst_tmpdir();
+
+	umask(022);
+
+	fildes = SAFE_OPEN(tst_rmdir, TESTFILE, O_WRONLY | O_CREAT, FILE_MODE);
+
+	/* Fill the test buffer with the known data */
+	memset(tst_buff, 'a', BUF_SIZE - 1);
+
+	/* Write to the file 1k data from the buffer */
+	while (write_len < FILE_SIZE) {
+		if ((wbytes = write(fildes, tst_buff, sizeof(tst_buff))) <= 0)
+			tst_brkm(TBROK | TERRNO, cleanup, "write failed");
+		else
+			write_len += wbytes;
+	}
+
+	user_id = getuid();
+	group_id = getgid();
+}
+
+static void cleanup(void)
+{
+	if (close(fildes) == -1)
+		tst_resm(TWARN | TERRNO, "close failed");
+
+	tst_rmdir();
+}
diff --git a/testcases/kernel/syscalls/statx/statx13.c b/testcases/kernel/syscalls/statx/statx13.c
new file mode 100644
index 0000000..cc45c3b
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx13.c
@@ -0,0 +1,163 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from fstat03.c by David Howells (dhowells@redhat.com)
+ *
+ * Test Name: statx13
+ *
+ * Test Description:
+ *   Verify that, statx(2) returns -1 and sets errno to EBADF if the file
+ *   pointed to by file descriptor is not valid.
+ *
+ * Expected Result:
+ *  xstat() should fail with return value -1 and set expected errno.
+ *
+ * Algorithm:
+ *  Setup:
+ *   Setup signal handling.
+ *   Create temporary directory.
+ *   Pause for SIGUSR1 if option specified.
+ *
+ *  Test:
+ *   Loop if the proper options are given.
+ *   Execute system call
+ *   Check return code, if system call failed (return=-1)
+ *	if errno set == expected errno
+ *		Issue sys call fails with expected return value and errno.
+ *	Otherwise,
+ *		Issue sys call fails with unexpected errno.
+ *   Otherwise,
+ *	Issue sys call returns unexpected value.
+ *
+ *  Cleanup:
+ *   Print errno log and/or timing stats if options given
+ *   Delete the temporary directory(s)/file(s) created.
+ *
+ * Usage:  <for command-line>
+ *  statx13 [-c n] [-e] [-i n] [-I x] [-P x] [-t]
+ *     where,  -c n : Run n copies concurrently.
+ *             -e   : Turn on errno logging.
+ *	       -i n : Execute test n times.
+ *	       -I x : Execute test for x seconds.
+ *	       -P x : Pause for x seconds between iterations.
+ *	       -t   : Turn on syscall timing.
+ *
+ * RESTRICTIONS:
+ *  This test should be executed by 'non-super-user' only.
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include "test.h"
+#include "linux-statx.h"
+
+#define FILE_MODE	S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
+#define TEST_FILE	"testfile"
+
+char *TCID = "statx13";
+int TST_TOTAL = 1;
+
+int fildes;			/* testfile descriptor */
+
+void setup();			/* Main setup function for the tests */
+void cleanup();			/* cleanup function for the test */
+
+int main(int ac, char **av)
+{
+	struct statx statx_buf;
+	int lc;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	/*
+	 * Invoke setup function to create a testfile under temporary
+	 * directory.
+	 */
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+
+		tst_count = 0;
+		/*
+		 * Call xstat(2) to get the status information
+		 * of a closed testfile pointed to by 'fd'.
+		 * verify that fstat fails with -1 return value and
+		 * sets appropriate errno.
+		 */
+		TEST(statx(fildes, NULL, 0, STATX_BASIC_STATS, &statx_buf));
+
+		/* Check return code from fstat(2) */
+		if (TEST_RETURN == -1) {
+			if (TEST_ERRNO == EBADF) {
+				tst_resm(TPASS,
+					 "statx() on fd fails with expected error EBADF");
+			} else {
+				tst_resm(TFAIL | TTERRNO,
+					 "statx() on fd did not fail with EBADF");
+			}
+		} else {
+			tst_resm(TFAIL, "statx() on fd returned %ld, expected -1",
+				 TEST_RETURN);
+		}
+	}
+
+	/*
+	 * Invoke cleanup() to delete the test directory/file(s) created
+	 * in the setup().
+	 */
+	cleanup();
+
+	tst_exit();
+}
+
+/*
+ * void
+ * setup(void) - performs all ONE TIME setup for this test.
+ *	Exit the test program on receipt of unexpected signals.
+ *	Create a temporary directory and change directory to it.
+ *      Create a testfile under temporary directory.
+ *      Close the testfile.
+ */
+void setup(void)
+{
+	/* Capture unexpected signals */
+	tst_sig(NOFORK, DEF_HANDLER, cleanup);
+
+	TEST_PAUSE;
+
+	/* Make a temp dir and cd to it */
+	tst_tmpdir();
+
+	/* Create a testfile under temporary directory */
+	fildes = open(TEST_FILE, O_RDWR | O_CREAT, 0666);
+	if (fildes == -1)
+		tst_brkm(TBROK | TERRNO, cleanup,
+			 "open(%s, O_RDWR|O_CREAT, 0666) failed", TEST_FILE);
+
+	if (close(fildes) == -1)
+		tst_brkm(TBROK | TERRNO, cleanup, "close(%s) failed",
+			 TEST_FILE);
+}
+
+/*
+ * void
+ * cleanup() - Performs all ONE TIME cleanup for this test at
+ *             completion or premature exit.
+ *	Print test timing stats and errno log if test executed with options.
+ *	Close the testfile if still opened.
+ *	Remove temporary directory and sub-directories/files under it
+ *	created during setup().
+ *	Exit the test program with normal exit code.
+ */
+void cleanup(void)
+{
+	tst_rmdir();
+}
diff --git a/testcases/kernel/syscalls/statx/statx15.c b/testcases/kernel/syscalls/statx/statx15.c
new file mode 100644
index 0000000..8505ef3
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx15.c
@@ -0,0 +1,248 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from fstat05.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (C) Bull S.A. 2001
+ * Copyright (c) International Business Machines  Corp., 2001
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+/*
+ * Test Name: statx15
+ *
+ * Test Description:
+ *   Verify that,
+ *   if buffer points outside user's accessible address space statx(2)
+ *	either returns -1 and sets errno to EFAULT
+ *	or SIGSEGV is returned instead of EFAULT
+ *
+ * Expected Result:
+ *   statx() should fail with return value -1 and set expected errno.
+ *    or
+ *   statx() should fail with SIGSEGV returned.
+ *   Both results are considered as acceptable.
+ *
+ * Algorithm:
+ *  Setup:
+ *   Setup signal handling SIGSEGV included.
+ *   Switch to nobody user.
+ *   Pause for SIGUSR1 if option specified.
+ *   Create temporary directory.
+ *   Create a testfile under temporary directory.
+ *
+ *  Test:
+ *   Buffer points outside user's accessible address space.
+ *   Loop if the proper options are given.
+ *   Execute system call
+ *   Check return code, if system call failed (return=-1)
+ *	if errno set == expected errno
+ *		Issue sys call fails with expected return value and errno.
+ *	Otherwise,
+ *		Issue sys call fails with unexpected errno.
+ *   Otherwise,
+ *	Issue sys call returns unexpected value.
+ *
+ *  Sighandler:
+ *	if signal == SIGSEGV
+ *		Issue sys call fails with expected signal
+ *      Otherwise,
+ *              Issue sys call fails with unexpected signal.
+ *
+ *  Cleanup:
+ *   Print errno log and/or timing stats if options given
+ *   Close the test file
+ *   Delete the temporary directory(s)/file(s) created.
+ *
+ * Usage:  <for command-line>
+ *  statx15 [-c n] [-e] [-i n] [-I x] [-p x] [-t]
+ *	where,  -c n : Run n copies concurrently.
+ *		-e   : Turn on errno logging.
+ *		-i n : Execute test n times.
+ *		-I x : Execute test for x seconds.
+ *		-P x : Pause for x seconds between iterations.
+ *		-t   : Turn on syscall timing.
+ *
+ * Restrictions:
+ *      This test must be run as root.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <pwd.h>
+
+#include "test.h"
+#include "linux-statx.h"
+
+#define TEST_FILE       "testfile"
+
+char nobody_uid[] = "nobody";
+struct passwd *ltpuser;
+
+char *TCID = "statx15";
+int TST_TOTAL = 1;
+
+int fildes;			/* testfile descriptor */
+
+void setup();			/* Main setup function for the tests */
+void cleanup();			/* cleanup function for the test */
+void sighandler(int sig);	/* signals handler function for the test */
+
+int siglist[] = { SIGHUP, SIGINT, SIGQUIT, SIGILL, SIGTRAP, SIGABRT, SIGIOT,
+	SIGBUS, SIGFPE, SIGUSR1, SIGSEGV, SIGUSR2, SIGPIPE, SIGALRM,
+	SIGTERM,
+#ifdef SIGSTKFLT
+	SIGSTKFLT,
+#endif
+	SIGCHLD, SIGCONT, SIGTSTP, SIGTTIN,
+	SIGTTOU, SIGURG, SIGXCPU, SIGXFSZ, SIGVTALRM, SIGPROF,
+	SIGWINCH, SIGIO, SIGPWR, SIGSYS,
+#ifdef SIGUNUSED
+	SIGUNUSED
+#endif
+};
+
+int SIG_SEEN = sizeof(siglist) / sizeof(int);
+
+#if !defined(UCLINUX)
+
+int main(int ac, char **av)
+{
+	struct statx statx_buf;
+	struct statx *ptr_str;
+	int lc;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	/* Buffer points outside user's accessible address space. */
+	ptr_str = &statx_buf;	/* if it was for conformance testing */
+	ptr_str = (void *)sbrk(0) + (4 * getpagesize());
+
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+
+		tst_count = 0;
+
+		/* Call statx(2).
+		 * verify that it fails with -1 return value and
+		 * sets appropriate errno.
+		 */
+		TEST(statx(fildes, NULL, 0, STATX_BASIC_STATS, ptr_str));
+
+		/* Check return code from statx(2) */
+		if (TEST_RETURN == -1) {
+			if (TEST_ERRNO == EFAULT)
+				tst_resm(TPASS,
+					 "statx failed with EFAULT as expected");
+			else
+				tst_resm(TFAIL | TTERRNO,
+					 "statx failed unexpectedly");
+		} else {
+			tst_resm(TFAIL, "statx() returned %ld but we wanted -1",
+				 TEST_RETURN);
+		}
+	}
+
+	/*
+	 * Invoke cleanup() to delete the test directory/file(s) created
+	 * in the setup().
+	 */
+	cleanup();
+	tst_exit();
+}
+
+#else
+
+int main(void)
+{
+	tst_brkm(TCONF, NULL, "test is not available on uClinux");
+}
+
+#endif /* if !defined(UCLINUX) */
+
+/*
+ * void
+ * setup(void) - performs all ONE TIME setup for this test.
+ *	Exit the test program on receipt of unexpected signals.
+ *	Create a temporary directory and change directory to it.
+ */
+void setup(void)
+{
+	int i;
+
+	tst_require_root();
+
+	/*
+	 * Capture unexpected signals SIGSEGV included
+	 * SIGSEGV being considered as acceptable as returned value
+	 */
+	for (i = 0; i < SIG_SEEN; i++)
+		signal(siglist[i], &sighandler);
+
+	ltpuser = getpwnam(nobody_uid);
+	if (setuid(ltpuser->pw_uid) == -1)
+		tst_brkm(TBROK | TERRNO, NULL, "setuid(%d) failed",
+			 ltpuser->pw_uid);
+
+	tst_tmpdir();
+
+	/* Create a testfile under temporary directory */
+	fildes = open(TEST_FILE, O_RDWR | O_CREAT, 0666);
+	if (fildes == -1)
+		tst_brkm(TBROK | TERRNO, cleanup,
+			 "open(%s, O_RDWR|O_CREAT, 0666) failed", TEST_FILE);
+
+	TEST_PAUSE;
+}
+
+/*
+ * void
+ * cleanup() - Performs all ONE TIME cleanup for this test at
+ *             completion or premature exit.
+ *	Print test timing stats and errno log if test executed with options.
+ *	Remove temporary directory and sub-directories/files under it
+ *	created during setup().
+ *	Exit the test program with normal exit code.
+ */
+void cleanup(void)
+{
+	if (close(fildes) == -1)
+		tst_brkm(TBROK | TERRNO, cleanup, "close(%s) failed",
+			 TEST_FILE);
+
+	tst_rmdir();
+}
+
+/*
+ * sighandler() - handle the signals
+ */
+
+void sighandler(int sig)
+{
+	if (sig == SIGSEGV)
+		tst_resm(TPASS, "statx failed as expected with SIGSEGV");
+	else
+		tst_brkm(TBROK, NULL, "Unexpected signal %d received.", sig);
+	cleanup();
+	tst_exit();
+}
diff --git a/testcases/kernel/syscalls/statx/statx21.c b/testcases/kernel/syscalls/statx/statx21.c
new file mode 100644
index 0000000..ebd43c6
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx21.c
@@ -0,0 +1,215 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from lstat01.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) 2000 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Further, this software is distributed without any warranty that it is
+ * free of the rightful claim of any third person regarding infringement
+ * or the like.  Any license provided herein, whether implied or
+ * otherwise, applies only to this software file.  Patent licenses, if
+ * any, provided herein do not apply to combinations of this program with
+ * other software, or any other product whatsoever.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Contact information: Silicon Graphics, Inc., 1600 Amphitheatre Pkwy,
+ * Mountain View, CA  94043, or:
+ *
+ * http://www.sgi.com
+ *
+ * For further information regarding this notice, see:
+ *
+ * http://oss.sgi.com/projects/GenInfo/NoticeExplan/
+ *
+ */
+
+/**********************************************************
+ *
+ *    TEST IDENTIFIER	: statx21
+ *
+ *    EXECUTED BY	: anyone
+ *
+ *    TEST TITLE	: Basic test for statx(2)
+ *
+ *    TEST CASE TOTAL	: 1
+ *
+ *    WALL CLOCK TIME	: 1
+ *
+ *    CPU TYPES		: ALL
+ *
+ *    TEST CASES
+ *
+ * 	1.) statx(2) returns...(See Description)
+ *
+ *    INPUT SPECIFICATIONS
+ * 	The standard options for system call tests are accepted.
+ *	(See the parse_opts(3) man page).
+ *
+ *    OUTPUT SPECIFICATIONS
+ *$
+ *    DURATION
+ * 	Terminates - with frequency and infinite modes.
+ *
+ *    SIGNALS
+ * 	Uses SIGUSR1 to pause before test if option set.
+ * 	(See the parse_opts(3) man page).
+ *
+ *    RESOURCES
+ * 	None
+ *
+ *    ENVIRONMENTAL NEEDS
+ *      No run-time environmental needs.
+ *
+ *    SPECIAL PROCEDURAL REQUIREMENTS
+ * 	None
+ *
+ *    INTERCASE DEPENDENCIES
+ * 	None
+ *
+ *    DETAILED DESCRIPTION
+ *	This is a Phase I test for the statx(2) system call.  It is intended
+ *	to provide a limited exposure of the system call, for now.  It
+ *	should/will be extended when full functional tests are written for
+ *	statx(2).
+ *
+ * 	Setup:
+ * 	  Setup signal handling.
+ *	  Pause for SIGUSR1 if option specified.
+ *
+ * 	Test:
+ *	 Loop if the proper options are given.
+ * 	  Execute system call
+ *	  Check return code, if system call failed (return=-1)
+ *		Log the errno and Issue a FAIL message.
+ *	  Otherwise, Issue a PASS message.
+ *
+ * 	Cleanup:
+ * 	  Print errno log and/or timing stats if options given
+ *
+ *
+ *#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#**/
+
+#include <sys/types.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <fcntl.h>
+#include "test.h"
+#include "linux-statx.h"
+
+void setup();
+void cleanup();
+
+char *TCID = "statx21";
+int TST_TOTAL = 1;
+
+char fname[255], lname[255], symlnk[255], buf[255];
+int fd;
+struct statx stxatter;
+struct stat statter;
+
+int main(int ac, char **av)
+{
+	int lc;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+	setup();
+
+	/***************************************************************
+	 * check looping state if -c option given
+	 ***************************************************************/
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+
+		tst_count = 0;
+
+		/*
+		 *  Call statx(2)
+		 */
+		TEST(statx(AT_FDCWD, symlnk, AT_SYMLINK_NOFOLLOW,
+			   STATX_BASIC_STATS, &stxatter));
+		if (TEST_RETURN == -1) {
+			tst_resm(TFAIL,
+				 "statx(%s, &statter) Failed, errno=%d : %s",
+				 symlnk, TEST_ERRNO, strerror(TEST_ERRNO));
+			continue;
+		}
+
+		TEST(lstat(symlnk, &statter));
+		if (TEST_RETURN == -1) {
+			tst_resm(TFAIL,
+				 "lstat(%s, &statter) Failed, errno=%d : %s",
+				 symlnk, TEST_ERRNO, strerror(TEST_ERRNO));
+			continue;
+		}
+
+		if (tst_cmp_statx(&stxatter, &statter) == -1)
+			continue;
+
+		tst_resm(TPASS,
+			 "statx(%s, &statter) returned %ld",
+			 symlnk, TEST_RETURN);
+	}
+
+	cleanup();
+	tst_exit();
+}
+
+/***************************************************************
+ * setup() - performs all ONE TIME setup for this test.
+ ***************************************************************/
+void setup(void)
+{
+
+	tst_sig(FORK, DEF_HANDLER, cleanup);
+
+	TEST_PAUSE;
+
+	tst_tmpdir();
+
+	sprintf(fname, "tfile_%d", getpid());
+	if ((fd = open(fname, O_RDWR | O_CREAT, 0700)) == -1) {
+		tst_brkm(TBROK, cleanup,
+			 "open(%s, O_RDWR|O_CREAT,0700) Failed, errno=%d : %s",
+			 fname, errno, strerror(errno));
+	} else if (close(fd) == -1) {
+		tst_resm(TWARN, "close(%s) Failed, errno=%d : %s",
+			 fname, errno, strerror(errno));
+	}
+
+	sprintf(symlnk, "lnfile_%d", getpid());
+	if (symlink(fname, symlnk) == -1) {
+		tst_resm(TWARN, "symlink(%s, %s) Failed, errno=%d : %s",
+			 fname, symlnk, errno, strerror(errno));
+	} else if (readlink(symlnk, buf, 255) == -1) {
+		tst_resm(TWARN, "readlink(%s, buf, 255) Failed, errno=%d : %s",
+			 symlnk, errno, strerror(errno));
+	} else if (strcmp(buf, fname) != 0) {
+		tst_resm(TWARN,
+			 "Setup Failure : Expected symbolic link contents of %s : Actual is %s",
+			 fname, buf);
+	}
+}
+
+/***************************************************************
+ * cleanup() - performs all ONE TIME cleanup for this test at
+ *		completion or premature exit.
+ ***************************************************************/
+void cleanup(void)
+{
+
+	tst_rmdir();
+
+}
diff --git a/testcases/kernel/syscalls/statx/statx22.c b/testcases/kernel/syscalls/statx/statx22.c
new file mode 100644
index 0000000..93eb454
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx22.c
@@ -0,0 +1,192 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from lstat02.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) International Business Machines  Corp., 2001
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+/*
+ * Test Description:
+ *   Verify that,
+ *   1) statx(2) returns -1 and sets errno to EACCES if search permission is
+ *	denied on a component of the path prefix.
+ *   2) statx(2) returns -1 and sets errno to ENOENT if the specified file
+ *	does not exists or empty string.
+ *   3) statx(2) returns -1 and sets errno to EFAULT if pathname points
+ *	outside user's accessible address space.
+ *   4) statx(2) returns -1 and sets errno to ENAMETOOLONG if the pathname
+ *	component is too long.
+ *   5) statx(2) returns -1 and sets errno to ENOTDIR if the directory
+ *	component in pathname is not a directory.
+ *   6) statx(2) returns -1 and sets errno to ELOOP if the pathname has too
+ *	many symbolic links encountered while traversing.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <pwd.h>
+
+#include "test.h"
+#include "safe_macros.h"
+#include "linux-statx.h"
+
+#define MODE_RWX	S_IRWXU | S_IRWXG | S_IRWXO
+#define FILE_MODE	S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
+#define TEST_DIR	"test_dir"
+#define TEST_EACCES	TEST_DIR"/test_eacces"
+#define TEST_ENOENT	""
+#define TEST_ENOTDIR	"test_file/test_enotdir"
+#define TEST_ELOOP	"/test_eloop"
+
+static char longpathname[PATH_MAX + 2];
+static char elooppathname[sizeof(TEST_ELOOP) * 43] = ".";
+
+#if !defined(UCLINUX)
+static void bad_addr_setup(int);
+static void high_address_setup(int);
+#endif
+
+static struct test_case_t {
+	char *pathname;
+	int exp_errno;
+	void (*setup) ();
+} test_cases[] = {
+	{TEST_EACCES, EACCES, NULL},
+	{TEST_ENOENT, ENOENT, NULL},
+#if !defined(UCLINUX)
+	{NULL, EFAULT, bad_addr_setup},
+	{NULL, EFAULT, high_address_setup},
+#endif
+	{longpathname, ENAMETOOLONG, NULL},
+	{TEST_ENOTDIR, ENOTDIR, NULL},
+	{elooppathname, ELOOP, NULL},
+};
+
+char *TCID = "statx22";
+int TST_TOTAL = ARRAY_SIZE(test_cases);
+
+static void setup(void);
+static void statx_verify(int);
+static void cleanup(void);
+
+int main(int ac, char **av)
+{
+	int lc;
+	int i;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+		tst_count = 0;
+		for (i = 0; i < TST_TOTAL; i++)
+			statx_verify(i);
+	}
+
+	cleanup();
+	tst_exit();
+}
+
+static void setup(void)
+{
+	int i;
+	struct passwd *ltpuser;
+
+	tst_require_root();
+
+	tst_sig(NOFORK, DEF_HANDLER, cleanup);
+
+	ltpuser = SAFE_GETPWNAM(cleanup, "nobody");
+	SAFE_SETEUID(cleanup, ltpuser->pw_uid);
+
+	TEST_PAUSE;
+
+	tst_tmpdir();
+
+	SAFE_MKDIR(cleanup, TEST_DIR, MODE_RWX);
+	SAFE_TOUCH(cleanup, TEST_EACCES, 0666, NULL);
+	if (chmod(TEST_DIR, FILE_MODE) < 0)
+		tst_brkm(TBROK, cleanup, "chmod(2) of %s failed", TEST_DIR);
+
+	SAFE_TOUCH(cleanup, "test_file", MODE_RWX, NULL);
+
+	memset(longpathname, 'a', PATH_MAX+1);
+
+	SAFE_MKDIR(cleanup, "test_eloop", MODE_RWX);
+	SAFE_SYMLINK(cleanup, "../test_eloop", "test_eloop/test_eloop");
+	/*
+	 * NOTE: the ELOOP test is written based on that the consecutive
+	 * symlinks limits in kernel is hardwired to 40.
+	 */
+	for (i = 0; i < 43; i++)
+		strcat(elooppathname, TEST_ELOOP);
+}
+
+#if !defined(UCLINUX)
+static void bad_addr_setup(int i)
+{
+	test_cases[i].pathname = SAFE_MMAP(cleanup, 0, 1, PROT_NONE,
+					   MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
+}
+
+static void high_address_setup(int i)
+{
+	test_cases[i].pathname = (char *)get_high_address();
+}
+#endif
+
+static void statx_verify(int i)
+{
+	struct statx statx_buf;
+
+	if (test_cases[i].setup != NULL)
+		test_cases[i].setup(i);
+
+	TEST(statx(AT_FDCWD, test_cases[i].pathname, AT_SYMLINK_NOFOLLOW,
+		   STATX_BASIC_STATS, &statx_buf));
+
+	if (TEST_RETURN != -1) {
+		tst_resm(TFAIL, "statx() returned %ld, expected -1, errno=%d",
+			 TEST_RETURN, test_cases[i].exp_errno);
+		return;
+	}
+
+	if (TEST_ERRNO == test_cases[i].exp_errno) {
+		tst_resm(TPASS | TTERRNO, "statx() failed as expected");
+	} else {
+		tst_resm(TFAIL | TTERRNO,
+			 "statx() failed unexpectedly; expected: %d - %s",
+			 test_cases[i].exp_errno,
+			 strerror(test_cases[i].exp_errno));
+	}
+}
+
+static void cleanup(void)
+{
+	if (seteuid(0))
+		tst_resm(TINFO | TERRNO, "Failet to seteuid(0) before cleanup");
+
+	tst_rmdir();
+}
diff --git a/testcases/kernel/syscalls/statx/statx23.c b/testcases/kernel/syscalls/statx/statx23.c
new file mode 100644
index 0000000..9256d14
--- /dev/null
+++ b/testcases/kernel/syscalls/statx/statx23.c
@@ -0,0 +1,136 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Derived from lstat03.c by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (c) International Business Machines  Corp., 2001
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+/*
+ * Test Name: statx03
+ *
+ * Test Description:
+ *  Verify that, statx(2) succeeds to get the status of a file pointed to by
+ *  symlink and fills the stat structure elements.
+ *
+ * Expected Result:
+ *  statx() should return value 0 on success and the stat structure elements
+ *  should be filled with the symlink file information.
+ */
+#include <stdio.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <pwd.h>
+
+#include "test.h"
+#include "safe_macros.h"
+#include "linux-statx.h"
+
+#define FILE_MODE	S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
+#define TESTFILE	"testfile"
+#define SFILE		"sfile"
+#define FILE_SIZE       1024
+#define BUF_SIZE	256
+#define PERMS		0644
+
+char *TCID = "statx23";
+int TST_TOTAL = 1;
+static uid_t user_id;
+static gid_t group_id;
+
+static char nobody_uid[] = "nobody";
+static struct passwd *ltpuser;
+
+static void setup(void);
+static void cleanup(void);
+
+int main(int ac, char **av)
+{
+	struct statx statx_buf;
+	struct stat stat_buf;
+	int lc;
+
+	tst_parse_opts(ac, av, NULL, NULL);
+
+	setup();
+
+	for (lc = 0; TEST_LOOPING(lc); lc++) {
+		tst_count = 0;
+
+		TEST(statx(AT_FDCWD, SFILE, AT_SYMLINK_NOFOLLOW,
+			   STATX_BASIC_STATS, &statx_buf));
+
+		if (TEST_RETURN == -1) {
+			tst_resm(TFAIL | TTERRNO, "statx(%s) failed", SFILE);
+			continue;
+		}
+
+		TEST(lstat(SFILE, &stat_buf));
+
+		if (TEST_RETURN == -1) {
+			tst_resm(TFAIL | TTERRNO, "lstat(%s) failed", SFILE);
+			continue;
+		}
+
+		if (tst_cmp_statx(&statx_buf, &stat_buf) == -1)
+			continue;
+
+		if ((statx_buf.stx_uid != user_id) ||
+		    (statx_buf.stx_gid != group_id) ||
+		    ((statx_buf.stx_mode & S_IFMT) != S_IFLNK) ||
+		    (statx_buf.stx_size != strlen(TESTFILE))) {
+			tst_resm(TFAIL, "Functionality of statx(2) on "
+				 "'%s' Failed", SFILE);
+		} else {
+			tst_resm(TPASS, "Functionality of statx(2) on "
+				 "'%s' Succcessful", SFILE);
+		}
+	}
+
+	cleanup();
+	tst_exit();
+}
+
+static void setup(void)
+{
+	tst_sig(NOFORK, DEF_HANDLER, cleanup);
+
+	tst_require_root();
+
+	ltpuser = SAFE_GETPWNAM(NULL, nobody_uid);
+	SAFE_SETUID(NULL, ltpuser->pw_uid);
+
+	TEST_PAUSE;
+
+	tst_tmpdir();
+
+	if (tst_fill_file(TESTFILE, 'a', 1024, 1))
+		tst_brkm(TBROK, cleanup, "Failed to create " TESTFILE);
+
+	SAFE_SYMLINK(cleanup, TESTFILE, SFILE);
+
+	user_id = getuid();
+	group_id = getgid();
+}
+
+static void cleanup(void)
+{
+	tst_rmdir();
+}
