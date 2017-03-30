Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753314AbdC3Qcn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 12:32:43 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] xfstests: Add first statx test
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15266.1490891560.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Mar 2017 17:32:40 +0100
Message-ID: <15267.1490891560@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: dhowells@redhat.com, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

Add a statx test that does the following:

 (1) Creates one each of the various types of file object and creates a
     hard link to the regular file.

     Note that the creation of an AF_UNIX socket is done with netcat in a
     bash coprocessing thread.  This might be best done with another
     in-house helper to avoid a dependency on nc.

 (2) Notes the clock time before creating the file.

 (3) Invokes the C test program included in this patch after the creation,
     handing it the clock time from (2) and providing a selection of
     invariants to check.

The patch also creates a C[*] test program to do the actual stat checking.
The test program then does the following:

 (1) Compares the output of statx() to that of fstatat().

 (2) Optionally compares the timestamps to see that they're sensibly
     ordered with respect to the saved clock time[**] and each other.

 (3) Optionally compares selected stats to values specified on the command
     line.

 (4) Optionally compares the stats to those of another file, requiring them
     to be the same (hard link checking).

For example:

        ./src/stat_test /dev/null \
               0.0 \
               stx_type=char \
               stx_rdev_major=3 \
               stx_rdev_minor=8 \
               stx_nlink=1


[*] Note that it proved much easier to do this in C than trying to do it in
    shell script and trying parsing the output of xfs_io.  Using xfs_io has
    other pitfalls also: it wants to *open* the file, even if the file is
    not an appropriate type for this or does not grant permission to do so.
    I can get around this by opening O_PATH, but then xfs_io fails to
    handle XFS files because it wants to issue ioctls on every fd it opens.

[**] It turns out they may be *before* the clock time.  This would seem to
     indicate a bug in the kernel's time-tracking system.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 src/Makefile          |    2 
 src/stat_test.c       |  666 ++++++++++++++++++++++++++++++++++++++++++++++++++
 src/statx.h           |  166 ++++++++++++
 tests/generic/420     |  221 ++++++++++++++++
 tests/generic/420.out |   12 
 tests/generic/group   |    1 
 6 files changed, 1067 insertions(+), 1 deletion(-)

diff --git a/src/Makefile b/src/Makefile
index a7f27f0..7dc53e9 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -22,7 +22,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
 	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
 	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
-	dio-invalidate-cache
+	dio-invalidate-cache stat_test
 
 SUBDIRS =
 
diff --git a/src/stat_test.c b/src/stat_test.c
new file mode 100644
index 0000000..f9b6d53
--- /dev/null
+++ b/src/stat_test.c
@@ -0,0 +1,666 @@
+/* Perform various tests on stat and statx output
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
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include "statx.h"
+
+static bool failed = false;
+static bool is_verbose = 0;
+static const char *prog;
+static const char *testfile;
+static struct statx_timestamp origin;
+
+/*
+ * Attribute IDs, sorted for bsearch() on attr_list[].
+ */
+enum attrs {
+	stx_atime_tv_nsec,
+	stx_atime_tv_sec,
+	stx_attributes,
+	stx_blksize,
+	stx_blocks,
+	stx_btime_tv_nsec,
+	stx_btime_tv_sec,
+	stx_ctime_tv_nsec,
+	stx_ctime_tv_sec,
+	stx_dev_major,
+	stx_dev_minor,
+	stx_gid,
+	stx_ino,
+	stx_mask,
+	stx_mode,
+	stx_mtime_tv_nsec,
+	stx_mtime_tv_sec,
+	stx_nlink,
+	stx_rdev_major,
+	stx_rdev_minor,
+	stx_size,
+	stx_type,
+	stx_uid,
+	nr__attrs
+};
+
+struct attr {
+	const char *name;		/* Name on command line */
+	unsigned int mask_bit;
+};
+
+/*
+ * List of attributes, sorted for bsearch().
+ */
+static const struct attr attr_list[nr__attrs] = {
+	[stx_atime_tv_nsec]	= { "stx_atime.tv_nsec",	STATX_ATIME },
+	[stx_atime_tv_sec]	= { "stx_atime.tv_sec",		STATX_ATIME },
+	[stx_attributes]	= { "stx_attributes",		0 },
+	[stx_blksize]		= { "stx_blksize",		0 },
+	[stx_blocks]		= { "stx_blocks",		STATX_BLOCKS },
+	[stx_btime_tv_nsec]	= { "stx_btime.tv_nsec",	STATX_BTIME },
+	[stx_btime_tv_sec]	= { "stx_btime.tv_sec",		STATX_BTIME },
+	[stx_ctime_tv_nsec]	= { "stx_ctime.tv_nsec",	STATX_CTIME },
+	[stx_ctime_tv_sec]	= { "stx_ctime.tv_sec",		STATX_CTIME },
+	[stx_dev_major]		= { "stx_dev_major",		0 },
+	[stx_dev_minor]		= { "stx_dev_minor",		0 },
+	[stx_gid]		= { "stx_gid",			STATX_GID },
+	[stx_ino]		= { "stx_ino",			STATX_INO },
+	[stx_mask]		= { "stx_mask",			0 },
+	[stx_mode]		= { "stx_mode",			STATX_MODE },
+	[stx_mtime_tv_nsec]	= { "stx_mtime.tv_nsec",	STATX_MTIME },
+	[stx_mtime_tv_sec]	= { "stx_mtime.tv_sec",		STATX_MTIME },
+	[stx_nlink]		= { "stx_nlink",		STATX_NLINK },
+	[stx_rdev_major]	= { "stx_rdev_major",		0 },
+	[stx_rdev_minor]	= { "stx_rdev_minor",		0 },
+	[stx_size]		= { "stx_size",			STATX_SIZE },
+	[stx_type]		= { "stx_type",			STATX_TYPE },
+	[stx_uid]		= { "stx_uid",			STATX_UID },
+};
+
+static int attr_cmp(const void *_key, const void *_p)
+{
+	const char *key = _key;
+	const struct attr *p = _p;
+	return strcmp(key, p->name);
+}
+
+struct file_type {
+	const char *name;
+	mode_t mode;
+};
+
+/*
+ * List of file types.
+ */
+static const struct file_type file_types[] = {
+	{ "fifo",	S_IFIFO },
+	{ "char",	S_IFCHR },
+	{ "dir",	S_IFDIR },
+	{ "block",	S_IFBLK },
+	{ "file",	S_IFREG },
+	{ "sym",	S_IFLNK },
+	{ "sock",	S_IFSOCK },
+	{ NULL }
+};
+
+static __attribute__((noreturn))
+void format(void)
+{
+	fprintf(stderr, "usage: %s [-v] [-m<mask>] <testfile> <origintime> [checks]\n",
+		prog);
+	fprintf(stderr, "\t<mask> can be basic, all or a number; all is the default\n");
+	fprintf(stderr, "checks is a list of zero or more of:\n");
+	fprintf(stderr, "\tts-order -- check the timestamp order after init\n");
+	fprintf(stderr, "\tts=<a>,<b> -- timestamp a <= b, where a and b are one of 'Oabcm'\n");
+	fprintf(stderr, "\tcmp=<file> -- check that the specified file has identical stats\n");
+	fprintf(stderr, "\tstx_<field>=<val> -- statx field value check\n");
+	fprintf(stderr, "\t\t(for stx_type, fifo char dir, block, file, sym, sock can be used)\n");
+	exit(2);
+}
+
+static __attribute__((format(printf, 1, 2)))
+void verbose(const char *fmt, ...)
+{
+	va_list va;
+
+	if (is_verbose) {
+		va_start(va, fmt);
+		fputs(" - ", stdout);
+		vprintf(fmt, va);
+		va_end(va);
+	}
+}
+
+static __attribute__((format(printf, 2, 3)))
+void check(bool good, const char *fmt, ...)
+{
+	va_list va;
+
+	if (!good) {
+		va_start(va, fmt);
+		fputs("[!] ", stdout);
+		vprintf(fmt, va);
+		va_end(va);
+		failed = true;
+	}
+}
+
+/*
+ * Compare the contents of a statx struct with that of a stat struct and check
+ * that they're the same.
+ */
+static void cmp_statx(const struct statx *stx, const struct stat *st)
+{
+#define cmp(fmt, x)						      \
+	do {							      \
+		check(stx->stx_##x == st->st_##x,		      \
+		      "stat.%s differs, "fmt" != "fmt"\n",	      \
+		      #x,					      \
+		      (unsigned long long)stx->stx_##x,		      \
+		      (unsigned long long)st->st_##x);		      \
+	} while (0)
+
+	cmp("%llu", blksize);
+	cmp("%llu", nlink);
+	cmp("%llu", uid);
+	cmp("%llu", gid);
+	cmp("%llo", mode);
+	cmp("%llu", ino);
+	cmp("%llu", size);
+	cmp("%llu", blocks);
+
+#define devcmp(x) \
+	do {								\
+		check(stx->stx_##x##_major == major(st->st_##x),	\
+		      "stat.%s.major differs, %u != %u\n",		\
+		      #x,						\
+		      stx->stx_##x##_major,				\
+		      major(st->st_##x));				\
+		check(stx->stx_##x##_minor == minor(st->st_##x),	\
+		      "stat.%s.minor differs, %u != %u\n",		\
+		      #x,						\
+		      stx->stx_##x##_minor,				\
+		      minor(st->st_##x));				\
+	} while (0)
+
+	devcmp(dev);
+	devcmp(rdev);
+
+#define timecmp(x) \
+	do {								\
+		check(stx->stx_##x##time.tv_sec == st->st_##x##tim.tv_sec, \
+		      "stat.%stime.tv_sec differs, %lld != %lld\n",	\
+		      #x,						\
+		      (long long)stx->stx_##x##time.tv_sec,		\
+		      (long long)st->st_##x##tim.tv_sec);		\
+		check(stx->stx_##x##time.tv_nsec == st->st_##x##tim.tv_nsec, \
+		      "stat.%stime.tv_nsec differs, %lld != %lld\n",	\
+		      #x,						\
+		      (long long)stx->stx_##x##time.tv_nsec,		\
+		      (long long)st->st_##x##tim.tv_nsec);		\
+	} while (0)
+
+	timecmp(a);
+	timecmp(c);
+	timecmp(m);
+}
+
+/*
+ * Check a pair of timestamps.
+ */
+static void check_earlier(const struct statx_timestamp *A,
+			  const struct statx_timestamp *B,
+			  const char *A_name,
+			  const char *B_name)
+{
+
+	check((B->tv_sec - A->tv_sec) >= 0,
+	      "%s.sec is before %s.sec (%lld < %lld)\n",
+	      B_name, A_name, B->tv_sec, A->tv_sec);
+
+	check((B->tv_nsec - A->tv_nsec) >= 0,
+	      "%s.nsec is before %s.nsec (%d < %d)\n",
+	      B_name, A_name, B->tv_nsec, A->tv_nsec);
+}
+
+/*
+ * Check that the timestamps are reasonably ordered.
+ *
+ * We require the following to hold true immediately after creation if the
+ * relevant timestamps exist on the filesystem:
+ *
+ *	origin <= btime <= atime
+ *	origin <= btime <= mtime <= ctime
+ */
+static void check_timestamp_order(const struct statx *stx)
+{
+	if (stx->stx_mask & STATX_BTIME)
+		check_earlier(&origin, &stx->stx_btime, "origin", "btime");
+	if (stx->stx_mask & STATX_ATIME)
+		check_earlier(&origin, &stx->stx_atime, "origin", "atime");
+	if (stx->stx_mask & STATX_MTIME)
+		check_earlier(&origin, &stx->stx_mtime, "origin", "mtime");
+	if (stx->stx_mask & STATX_CTIME)
+		check_earlier(&origin, &stx->stx_ctime, "origin", "ctime");
+	if ((stx->stx_mask & (STATX_BTIME | STATX_ATIME)) == (STATX_BTIME | STATX_ATIME))
+		check_earlier(&stx->stx_btime, &stx->stx_atime, "btime", "atime");
+	if ((stx->stx_mask & (STATX_BTIME | STATX_MTIME)) == (STATX_BTIME | STATX_MTIME))
+		check_earlier(&stx->stx_btime, &stx->stx_mtime, "btime", "mtime");
+	if ((stx->stx_mask & (STATX_BTIME | STATX_CTIME)) == (STATX_BTIME | STATX_CTIME))
+		check_earlier(&stx->stx_btime, &stx->stx_ctime, "btime", "ctime");
+	if ((stx->stx_mask & (STATX_MTIME | STATX_CTIME)) == (STATX_MTIME | STATX_CTIME))
+		check_earlier(&stx->stx_mtime, &stx->stx_ctime, "mtime", "ctime");
+}
+
+/*
+ * Check that the second timestamp is the same as or after the first timestamp.
+ */
+static void check_timestamp(const struct statx *stx, char *arg)
+{
+	const struct statx_timestamp *a, *b;
+	const char *an, *bn;
+	unsigned int mask;
+
+	if (strlen(arg) != 3 || arg[1] != ',') {
+		fprintf(stderr, "-ts requires <a>,<b>\n");
+		exit(2);
+	}
+
+	switch (arg[0]) {
+	case 'O': a = &origin;		an = "origin";	mask = 0; break;
+	case 'a': a = &stx->stx_atime;	an = "atime";	mask = STATX_ATIME; break;
+	case 'b': a = &stx->stx_btime;	an = "btime";	mask = STATX_BTIME; break;
+	case 'c': a = &stx->stx_ctime;	an = "ctime";	mask = STATX_CTIME; break;
+	case 'm': a = &stx->stx_mtime;	an = "mtime";	mask = STATX_MTIME; break;
+	default:
+		fprintf(stderr, "-ts timestamp '%c' not supported\n", arg[0]);
+		exit(2);
+	}
+
+	if (mask && !(stx->stx_mask & mask))
+		return;
+
+	switch (arg[2]) {
+	case 'O': b = &origin;		bn = "origin";	mask = 0; break;
+	case 'a': b = &stx->stx_atime;	bn = "atime";	mask = STATX_ATIME; break;
+	case 'b': b = &stx->stx_btime;	bn = "btime";	mask = STATX_BTIME; break;
+	case 'c': b = &stx->stx_ctime;	bn = "ctime";	mask = STATX_CTIME; break;
+	case 'm': b = &stx->stx_mtime;	bn = "mtime";	mask = STATX_MTIME; break;
+	default:
+		fprintf(stderr, "-ts timestamp '%c' not supported\n", arg[2]);
+		exit(2);
+	}
+
+	if (mask && !(stx->stx_mask & mask))
+		return;
+
+	verbose("check %s <= %s\n", an, bn);
+	check_earlier(a, b, an, bn);
+}
+
+/*
+ * Compare to another file.
+ */
+static void cmp_to_file(const struct statx *stx, char *arg, unsigned int mask)
+{
+	struct statx stx2;
+	int ret;
+
+	verbose("call statx %s\n", arg);
+	memset(&stx2, 0xfb, sizeof(stx2));
+	ret = xfstests_statx(AT_FDCWD, arg, AT_SYMLINK_NOFOLLOW, mask, &stx2);
+	switch (ret) {
+	case 0:
+		break;
+	case -1:
+		perror(arg);
+		exit(1);
+	default:
+		fprintf(stderr, "Unexpected return %d from statx()\n", ret);
+		exit(1);
+	}
+
+#undef cmp
+#define cmp(fmt, x)							\
+	do {								\
+		check(stx->x == stx2.x,					\
+		      "attr '%s' differs between files, "fmt" != "fmt"\n", \
+		      #x,						\
+		      (unsigned long long)stx->x,			\
+		      (unsigned long long)stx2.x);			\
+	} while (0)
+
+	cmp("%llx", stx_mask);
+	cmp("%llx", stx_attributes);
+	cmp("%llu", stx_blksize);
+	cmp("%llu", stx_attributes);
+	cmp("%llu", stx_nlink);
+	cmp("%llu", stx_uid);
+	cmp("%llu", stx_gid);
+	cmp("%llo", stx_mode);
+	cmp("%llu", stx_ino);
+	cmp("%llu", stx_size);
+	cmp("%llu", stx_blocks);
+	cmp("%lld", stx_atime.tv_sec);
+	cmp("%lld", stx_atime.tv_nsec);
+	cmp("%lld", stx_btime.tv_sec);
+	cmp("%lld", stx_btime.tv_nsec);
+	cmp("%lld", stx_ctime.tv_sec);
+	cmp("%lld", stx_ctime.tv_nsec);
+	cmp("%lld", stx_mtime.tv_sec);
+	cmp("%lld", stx_mtime.tv_nsec);
+	cmp("%llu", stx_rdev_major);
+	cmp("%llu", stx_rdev_minor);
+	cmp("%llu", stx_dev_major);
+	cmp("%llu", stx_dev_minor);
+}
+
+/*
+ * Check an attribute restriction.  Specified on the command line as a key=val
+ * pair in the checks section.  For instance:
+ *
+ *	stx_type=char
+ *	stx_mode=0644
+ */
+static void check_attr(const struct statx *stx, char *arg)
+{
+	const struct file_type *type;
+	const struct attr *attr;
+	unsigned long long ucheck, uval;
+	long long scheck, sval;
+	char *key, *val, *p;
+
+	verbose("check %s\n", arg);
+
+	key = arg;
+	val = strchr(key, '=');
+	if (!val || !val[1])
+		format();
+	*(val++) = 0;
+
+	attr = bsearch(key, attr_list, nr__attrs, sizeof(*attr), attr_cmp);
+	if (!attr) {
+		fprintf(stderr, "Attr '%s' not supported\n", key);
+		exit(2);
+	}
+
+	/* Read the stat information specified by the key. */
+	switch ((enum attrs)(attr - attr_list)) {
+	case stx_mask:		uval = stx->stx_mask;		break;
+	case stx_blksize:	uval = stx->stx_blksize;	break;
+	case stx_attributes:	uval = stx->stx_attributes;	break;
+	case stx_nlink:		uval = stx->stx_nlink;		break;
+	case stx_uid:		uval = stx->stx_uid;		break;
+	case stx_gid:		uval = stx->stx_gid;		break;
+	case stx_type:		uval = stx->stx_mode & ~07777;	break;
+	case stx_mode:		uval = stx->stx_mode & 07777;	break;
+	case stx_ino:		uval = stx->stx_ino;		break;
+	case stx_size:		uval = stx->stx_size;		break;
+	case stx_blocks:	uval = stx->stx_blocks;		break;
+	case stx_rdev_major:	uval = stx->stx_rdev_major;	break;
+	case stx_rdev_minor:	uval = stx->stx_rdev_minor;	break;
+	case stx_dev_major:	uval = stx->stx_dev_major;	break;
+	case stx_dev_minor:	uval = stx->stx_dev_minor;	break;
+
+	case stx_atime_tv_sec:	sval = stx->stx_atime.tv_sec;	break;
+	case stx_atime_tv_nsec:	sval = stx->stx_atime.tv_nsec;	break;
+	case stx_btime_tv_sec:	sval = stx->stx_btime.tv_sec;	break;
+	case stx_btime_tv_nsec:	sval = stx->stx_btime.tv_nsec;	break;
+	case stx_ctime_tv_sec:	sval = stx->stx_ctime.tv_sec;	break;
+	case stx_ctime_tv_nsec:	sval = stx->stx_ctime.tv_nsec;	break;
+	case stx_mtime_tv_sec:	sval = stx->stx_mtime.tv_sec;	break;
+	case stx_mtime_tv_nsec:	sval = stx->stx_mtime.tv_nsec;	break;
+	default:
+		break;
+	}
+
+	/* Parse the specified value as signed or unsigned as
+	 * appropriate and compare to the stat information.
+	 */
+	switch ((enum attrs)(attr - attr_list)) {
+	case stx_mask:
+	case stx_attributes:
+		ucheck = strtoull(val, &p, 0);
+		if (*p) {
+			fprintf(stderr, "Attr '%s' requires unsigned integer\n", key);
+			exit(2);
+		}
+		check(uval == ucheck,
+		      "%s differs, 0x%llx != 0x%llx\n", attr->name, uval, ucheck);
+		break;
+
+	case stx_type:
+		for (type = file_types; type->name; type++) {
+			if (strcmp(type->name, val) == 0) {
+				ucheck = type->mode;
+				goto octal_check;
+			}
+		}
+
+		/* fall through */
+
+	case stx_mode:
+		ucheck = strtoull(val, &p, 0);
+		if (*p) {
+			fprintf(stderr, "Attr '%s' requires unsigned integer\n", key);
+			exit(2);
+		}
+	octal_check:
+		check(uval == ucheck,
+		      "%s differs, 0%llo != 0%llo\n", attr->name, uval, ucheck);
+		break;
+
+	case stx_blksize:
+	case stx_nlink:
+	case stx_uid:
+	case stx_gid:
+	case stx_ino:
+	case stx_size:
+	case stx_blocks:
+	case stx_rdev_major:
+	case stx_rdev_minor:
+	case stx_dev_major:
+	case stx_dev_minor:
+		ucheck = strtoull(val, &p, 0);
+		if (*p) {
+			fprintf(stderr, "Attr '%s' requires unsigned integer\n",
+				key);
+			exit(2);
+		}
+		check(uval == ucheck,
+		      "%s differs, %llu != %llu\n", attr->name, uval, ucheck);
+		break;
+
+	case stx_atime_tv_sec:
+	case stx_atime_tv_nsec:
+	case stx_btime_tv_sec:
+	case stx_btime_tv_nsec:
+	case stx_ctime_tv_sec:
+	case stx_ctime_tv_nsec:
+	case stx_mtime_tv_sec:
+	case stx_mtime_tv_nsec:
+		scheck = strtoll(val, &p, 0);
+		if (*p) {
+			fprintf(stderr, "Attr '%s' requires integer\n", key);
+			exit(2);
+		}
+		check(sval == scheck,
+		      "%s differs, %lld != %lld\n", attr->name, sval, scheck);
+		break;
+
+	default:
+		break;
+	}
+}
+
+/*
+ * Do the testing.
+ */
+int main(int argc, char **argv)
+{
+	struct statx stx;
+	struct stat st;
+	unsigned int mask = STATX_ALL;
+	unsigned int atflags = AT_STATX_SYNC_AS_STAT;
+	long long sec;
+	char *p;
+	int c, ret, nsec;
+
+	prog = argv[0];
+	while (c = getopt(argc, argv, "+DFm:v"),
+	       c != -1
+	       ) {
+		switch (c) {
+		case 'F':
+			atflags &= ~AT_STATX_SYNC_TYPE;
+			atflags |= AT_STATX_FORCE_SYNC;
+			break;
+		case 'D':
+			atflags &= ~AT_STATX_SYNC_TYPE;
+			atflags |= AT_STATX_DONT_SYNC;
+			break;
+		case 'm':
+			if (strcmp(optarg, "basic") == 0) {
+				mask = STATX_BASIC_STATS;
+			} else if (strcmp(optarg, "all") == 0) {
+				mask = STATX_ALL;
+			} else {
+				mask = strtoul(optarg, &p, 0);
+				if (*p)
+					format();
+			}
+			break;
+		case 'v':
+			is_verbose = 1;
+			break;
+		default:
+			format();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+	if (argc < 2)
+		format();
+	testfile = argv[0];
+
+	/* Determine the beginning time reference.  This can be a
+	 * <secs>.<nsecs> format string or the name of a file whose mtime is to
+	 * be used as a reference.
+	 */
+	if (sscanf(argv[1], "%lld.%d", &sec, &nsec) == 2) {
+		origin.tv_sec = sec;
+		origin.tv_nsec = nsec;
+	} else {
+		memset(&stx, 0xfb, sizeof(stx));
+		ret = xfstests_statx(AT_FDCWD, argv[1], 0, mask, &stx);
+		switch (ret) {
+		case 0:
+			origin = stx.stx_mtime;
+			break;
+		case -1:
+			perror(argv[1]);
+			exit(1);
+		default:
+			fprintf(stderr, "Unexpected return %d from statx()\n", ret);
+			exit(1);
+		}
+	}
+
+	argv += 2;
+
+	/* Gather the stats.  We want both statx and stat so that we can
+	 * compare what's in the buffers.
+	 */
+	verbose("call statx %s\n", testfile);
+	memset(&stx, 0xfb, sizeof(stx));
+	ret = xfstests_statx(AT_FDCWD, testfile, atflags | AT_SYMLINK_NOFOLLOW,
+			     mask, &stx);
+	switch (ret) {
+	case 0:
+		break;
+	case -1:
+		perror(testfile);
+		exit(1);
+	default:
+		fprintf(stderr, "Unexpected return %d from statx()\n", ret);
+		exit(1);
+	}
+
+	verbose("call stat %s\n", testfile);
+	ret = fstatat(AT_FDCWD, testfile, &st, AT_SYMLINK_NOFOLLOW);
+	switch (ret) {
+	case 0:
+		break;
+	case -1:
+		perror(testfile);
+		exit(1);
+	default:
+		fprintf(stderr, "Unexpected return %d from stat()\n", ret);
+		exit(1);
+	}
+
+	verbose("compare statx and stat\n");
+	cmp_statx(&stx, &st);
+
+	/* Display the available timestamps */
+	verbose("begin time %llu.%09u\n", origin.tv_sec, origin.tv_nsec);
+	if (stx.stx_mask & STATX_BTIME)
+		verbose("     btime %llu.%09u\n", stx.stx_btime.tv_sec, stx.stx_btime.tv_nsec);
+	if (stx.stx_mask & STATX_ATIME)
+		verbose("     atime %llu.%09u\n", stx.stx_atime.tv_sec, stx.stx_atime.tv_nsec);
+	if (stx.stx_mask & STATX_MTIME)
+		verbose("     mtime %llu.%09u\n", stx.stx_mtime.tv_sec, stx.stx_mtime.tv_nsec);
+	if (stx.stx_mask & STATX_CTIME)
+		verbose("     ctime %llu.%09u\n", stx.stx_ctime.tv_sec, stx.stx_ctime.tv_nsec);
+
+	/* Handle additional checks the user specified */
+	for (; *argv; argv++) {
+		char *arg = *argv;
+		if (arg[0] == 's') {
+			/* stx_<field>=<n> - check field set to n */
+			check_attr(&stx, *argv);
+			continue;
+		}
+
+		if (strcmp("ts_order", arg) == 0) {
+			/* tsorder - check timestamp order */
+			check_timestamp_order(&stx);
+			continue;
+		}
+
+		if (strncmp("ts=", arg, 3) == 0) {
+			/* ts=<a>,<b> - check timestamp b is same as a or after */
+			check_timestamp(&stx, arg + 3);
+			continue;
+		}
+
+		if (strncmp("-cmp=", arg, 4) == 0) {
+			/* cmp=<file> - check files have same stats */
+			cmp_to_file(&stx, arg + 4, mask);
+			continue;
+		}
+	}
+
+	if (failed) {
+		printf("Failed\n");
+		exit(1);
+	}
+
+	verbose("Success\n");
+	exit(0);
+}
diff --git a/src/statx.h b/src/statx.h
new file mode 100644
index 0000000..711d1ba
--- /dev/null
+++ b/src/statx.h
@@ -0,0 +1,166 @@
+#ifndef STATX_H
+#define STATX_H
+
+#include <unistd.h>
+#include <linux/types.h>
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
+static inline
+int xfstests_statx(int dfd, const char *filename, unsigned flags,
+		   unsigned int mask, struct statx *buffer)
+{
+	return syscall(__NR_statx, dfd, filename, flags, mask, buffer);
+}
+
+#endif /* STATX_TYPE */
+#endif /* STATX_H */
diff --git a/tests/generic/420 b/tests/generic/420
new file mode 100755
index 0000000..e9a6dda
--- /dev/null
+++ b/tests/generic/420
@@ -0,0 +1,221 @@
+#! /bin/bash
+# FS QA Test 420
+#
+# Test the statx system call
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_test_program "stat_test"
+
+function check_stat () {
+    $here/src/stat_test $*
+}
+
+###############################################################################
+#
+# Check statx'ing of various types of object
+#
+###############################################################################
+failed=0
+
+echo "Test statx on a fifo"
+origin=`date +%s.%N`
+if mkfifo -m 0600 $SCRATCH_MNT/fifo
+then
+    check_stat $SCRATCH_MNT/fifo \
+	       $origin\
+	       ts_order \
+	       stx_type=fifo \
+	       stx_mode=0600 \
+	       stx_rdev_major=0 \
+	       stx_rdev_minor=0 \
+	       stx_nlink=1 \
+	|| failed=1
+else
+    echo "- mkfifo failed"
+    failed=1
+fi
+
+echo "Test statx on a chardev"
+origin=`date +%s.%N`
+if mknod -m 0600 $SCRATCH_MNT/null c 1 3
+then
+    check_stat $SCRATCH_MNT/null \
+	       $origin \
+	       ts_order \
+	       stx_type=char \
+	       stx_mode=0600 \
+	       stx_rdev_major=1 \
+	       stx_rdev_minor=3 \
+	       stx_nlink=1 \
+	|| failed=1
+else
+    echo "- mknod failed"
+    failed=1
+fi
+
+echo "Test statx on a directory"
+origin=`date +%s.%N`
+if mkdir $SCRATCH_MNT/dir
+then
+    check_stat $SCRATCH_MNT/dir \
+	       $origin \
+	       ts_order \
+	       stx_type=dir \
+	       stx_mode=0755 \
+	       stx_rdev_major=0 \
+	       stx_rdev_minor=0 \
+	       stx_nlink=2 \
+	|| failed=1
+else
+    echo "- mkdir failed"
+    failed=1
+fi
+
+echo "Test statx on a blockdev"
+origin=`date +%s.%N`
+if mknod -m 0600 $SCRATCH_MNT/loopy b 7 123
+then
+    check_stat $SCRATCH_MNT/loopy \
+	       $origin \
+	       ts_order \
+	       stx_type=block \
+	       stx_mode=0600 \
+	       stx_rdev_major=7 \
+	       stx_rdev_minor=123 \
+	       stx_nlink=1 \
+	|| failed=1
+else
+    echo "- mknod failed"
+    failed=1
+fi
+
+echo "Test statx on a file"
+origin=`date +%s.%N`
+if dd if=/dev/zero of=$SCRATCH_MNT/file bs=1024 count=20
+then
+    check_stat $SCRATCH_MNT/file \
+	       $origin \
+	       ts_order \
+	       stx_type=file \
+	       stx_size=20480 \
+	       stx_rdev_major=0 \
+	       stx_rdev_minor=0 \
+	       stx_nlink=1 \
+	|| failed=1
+else
+    echo "- dd failed"
+    failed=1
+fi
+
+echo "Test statx on a symlink"
+origin=`date +%s.%N`
+if ln -s $SCRATCH_MNT/nowhere $SCRATCH_MNT/symlink
+then
+    check_stat $SCRATCH_MNT/symlink \
+	       $origin \
+	       ts_order \
+	       stx_type=sym \
+	       stx_rdev_major=0 \
+	       stx_rdev_minor=0 \
+	       stx_nlink=1 \
+	|| failed=1
+else
+    echo "- ln -s failed"
+    failed=1
+fi
+
+echo "Test statx on an AF_UNIX socket"
+origin=`date +%s.%N`
+if (coproc SERVER { nc -U -l $SCRATCH_MNT/sock </dev/null; };
+    nc -U $SCRATCH_MNT/sock </dev/null;
+    wait)
+then
+    check_stat $SCRATCH_MNT/sock \
+	       $origin \
+	       ts_order \
+	       stx_type=sock \
+	       stx_rdev_major=0 \
+	       stx_rdev_minor=0 \
+	       stx_nlink=1 \
+	|| failed=1
+else
+    echo "- nc failed"
+    failed=1
+fi
+
+echo "Test a hard link to a file"
+origin=`date +%s.%N`
+if ln $SCRATCH_MNT/file $SCRATCH_MNT/link
+then
+    check_stat $SCRATCH_MNT/link \
+	       $origin \
+	       ts=O,c \
+	       cmp=$SCRATCH_MNT/file \
+	       stx_nlink=2 \
+	|| failed=1
+else
+    echo "- ln failed"
+    failed=1
+fi
+
+if [ $failed = 1 ]
+then
+    echo "Test script failed"
+    exit
+fi
+
+echo "Success"
+
+# optional stuff if your test has verbose output to help resolve problems
+#echo
+#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/420.out b/tests/generic/420.out
new file mode 100644
index 0000000..e2956a6
--- /dev/null
+++ b/tests/generic/420.out
@@ -0,0 +1,12 @@
+QA output created by 420
+Test statx on a fifo
+Test statx on a chardev
+Test statx on a directory
+Test statx on a blockdev
+Test statx on a file
+20+0 records in
+20+0 records out
+Test statx on a symlink
+Test statx on an AF_UNIX socket
+Test a hard link to a file
+Success
diff --git a/tests/generic/group b/tests/generic/group
index 0781f35..c420998 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -422,3 +422,4 @@
 417 auto quick shutdown log
 418 auto rw
 419 auto quick encrypt
+420 other
