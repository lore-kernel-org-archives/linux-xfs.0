Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751329AbdDCLuc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 07:50:32 -0400
Subject: [PATCH 2/4] xfstests: Add first statx test [ver #2]
From: David Howells <dhowells@redhat.com>
Date: Mon, 03 Apr 2017 12:50:19 +0100
Message-ID: <149122021944.24468.15575002259291387408.stgit@warthog.procyon.org.uk>
In-Reply-To: <149122021217.24468.17499686793235286404.stgit@warthog.procyon.org.uk>
References: <149122021217.24468.17499686793235286404.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org

Add a statx test script that does the following:

 (1) Creates one each of the various types of file object and creates a
     hard link to the regular file.

     Note that the creation of an AF_UNIX socket is done with netcat in a
     bash coprocessing thread.  This might be best done with another
     in-house helper to avoid a dependency on nc.

 (2) Invokes the C test program included in this patch after the creation
     and hands it a list of things to check appropriate to each object.

 (3) Asks the test program to check the creation time of each object
     against that of the preceding object.

 (4) Makes various tests on the timestamps of the hardlinked file.

The patch also creates a C[*] test program to do the actual stat checking.
The test program then does the following:

 (1) Compares the output of statx() to that of fstatat().

 (2) Optionally compares the timestamps to see that they're sensibly
     ordered with respect to each other.

 (3) Optionally compares the timestamps to those of a reference file.

 (4) Optionally compares the timestamps to a specified time.

 (5) Optionally compares selected stats to values specified on the command
     line.

 (6) Optionally compares all the stats to those of a reference file,
     requiring them to be the same (hard link checking).

For example:

	./src/stat_test /dev/null \
	       stx_type=char \
	       stx_rdev_major=3 \
	       stx_rdev_minor=8 \
	       stx_nlink=1 \
	       ref=/dev/zero \
	       ts=B,b

The test program can also be given a --check-statx parameter to give a
quick exit code-based answer on whether statx() exists within the kernel.

[*] Note that it proved much easier to do this in C than trying to do it in
    shell script and trying parsing the output of xfs_io.  Using xfs_io has
    other pitfalls also: it wants to *open* the file, even if the file is
    not an appropriate type for this or does not grant permission to do so.
    I can get around this by opening O_PATH, but then xfs_io fails to
    handle XFS files because it wants to issue ioctls on every fd it opens.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 .gitignore            |    1 
 common/rc             |    6 
 src/Makefile          |    2 
 src/stat_test.c       |  718 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/statx.h           |  166 +++++++++++
 tests/generic/420     |  181 ++++++++++++
 tests/generic/420.out |   11 +
 tests/generic/group   |    1 
 8 files changed, 1085 insertions(+), 1 deletion(-)
 create mode 100644 src/stat_test.c
 create mode 100644 src/statx.h
 create mode 100755 tests/generic/420
 create mode 100644 tests/generic/420.out

diff --git a/.gitignore b/.gitignore
index 8a7c052..0336555 100644
--- a/.gitignore
+++ b/.gitignore
@@ -93,6 +93,7 @@
 /src/seek_copy_test
 /src/seek_sanity_test
 /src/stale_handle
+/src/stat_test
 /src/t_access_root
 /src/t_dir_offset
 /src/t_dir_offset2
diff --git a/common/rc b/common/rc
index e1ab2c6..1b61f9d 100644
--- a/common/rc
+++ b/common/rc
@@ -3414,6 +3414,12 @@ _require_fs_sysfs()
 	fi
 }
 
+_require_statx()
+{
+	$here/src/stat_test --check-statx ||
+	_notrun "This test requires the statx system call"
+}
+
 # Write "content" into /sys/fs/$FSTYP/$DEV/$ATTR
 #
 # All arguments are necessary, and in this order:
diff --git a/src/Makefile b/src/Makefile
index 716c178..e62d7a9 100644
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
index 0000000..cb3d4f4
--- /dev/null
+++ b/src/stat_test.c
@@ -0,0 +1,718 @@
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
+
+/* Reference data */
+static struct statx ref;
+static struct statx_timestamp origin;
+static bool ref_set, origin_set;
+
+/*
+ * Field IDs, sorted for bsearch() on field_list[].
+ */
+enum fields {
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
+	nr__fields
+};
+
+struct field {
+	const char *name;		/* Name on command line */
+	unsigned int mask_bit;
+};
+
+/*
+ * List of fields, sorted for bsearch().
+ */
+static const struct field field_list[nr__fields] = {
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
+static int field_cmp(const void *_key, const void *_p)
+{
+	const char *key = _key;
+	const struct field *p = _p;
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
+	fprintf(stderr, "usage: %s --check-statx\n", prog);
+	fprintf(stderr, "usage: %s [-v] [-m<mask>] <testfile> [checks]\n", prog);
+	fprintf(stderr, "\t<mask> can be basic, all or a number; all is the default\n");
+	fprintf(stderr, "checks is a list of zero or more of:\n");
+	fprintf(stderr, "\tcmp_ref -- check that the reference file has identical stats\n");
+	fprintf(stderr, "\tref=<file> -- get reference stats from file\n");
+	fprintf(stderr, "\tstx_<field>=<val> -- statx field value check\n");
+	fprintf(stderr, "\tts=<a>,<b> -- timestamp a <= b, where a and b can each be one of:\n");
+	fprintf(stderr, "\t\t[abcm] -- the timestamps from testfile\n");
+	fprintf(stderr, "\t\t[ABCM] -- the timestamps from the reference file\n");
+	fprintf(stderr, "\t\t0 -- the origin timestamp\n");
+	fprintf(stderr, "\tts_origin=<sec>.<nsec> -- set the origin timestamp\n");
+	fprintf(stderr, "\tts_order -- check the timestamp order\n");
+	fprintf(stderr, "\t\t(for stx_type, fifo char dir, block, file, sym, sock can be used)\n");
+	exit(2);
+}
+
+static __attribute__((noreturn, format(printf, 1, 2)))
+void bad_arg(const char *fmt, ...)
+{
+	va_list va;
+
+	va_start(va, fmt);
+	vfprintf(stderr, fmt, va);
+	va_end(va);
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
+ * Set origin timestamp from a "<sec>.<nsec>" string.
+ */
+static void set_origin_timestamp(const char *arg)
+{
+	long long sec;
+	int nsec;
+
+	switch (sscanf(arg, "%lld.%d", &sec, &nsec)) {
+	case 0:
+		bad_arg("ts_origin= missing seconds value");
+	case 1:
+		bad_arg("ts_origin= missing nanoseconds value");
+	default:
+		origin.tv_sec = sec;
+		origin.tv_nsec = nsec;
+		origin_set = true;
+		break;
+	}
+}
+
+/*
+ * Get reference stats from a file.
+ */
+static void get_reference(const char *file)
+{
+	int ret;
+
+	if (!*file)
+		bad_arg("ref= requires a filename\n");
+
+	memset(&ref, 0xfb, sizeof(ref));
+	ret = xfstests_statx(AT_FDCWD, file, AT_SYMLINK_NOFOLLOW,
+			     STATX_ATIME | STATX_BTIME | STATX_CTIME | STATX_MTIME,
+			     &ref);
+	switch (ret) {
+	case 0:
+		ref_set = true;
+		break;
+	case -1:
+		perror(file);
+		exit(1);
+	default:
+		fprintf(stderr, "Unexpected return %d from statx()\n", ret);
+		exit(1);
+	}
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
+ *	btime <= atime
+ *	btime <= mtime <= ctime
+ */
+static void check_timestamp_order(const struct statx *stx)
+{
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
+	if (strlen(arg) != 3 || arg[1] != ',')
+		bad_arg("ts= requires <a>,<b>\n");
+
+	switch (arg[0]) {
+	case 'a': a = &stx->stx_atime;	an = "atime";	mask = STATX_ATIME; break;
+	case 'b': a = &stx->stx_btime;	an = "btime";	mask = STATX_BTIME; break;
+	case 'c': a = &stx->stx_ctime;	an = "ctime";	mask = STATX_CTIME; break;
+	case 'm': a = &stx->stx_mtime;	an = "mtime";	mask = STATX_MTIME; break;
+	case 'A': a = &ref.stx_atime;	an = "ref_a";	mask = STATX_ATIME; break;
+	case 'B': a = &ref.stx_btime;	an = "ref_b";	mask = STATX_BTIME; break;
+	case 'C': a = &ref.stx_ctime;	an = "ref_c";	mask = STATX_CTIME; break;
+	case 'M': a = &ref.stx_mtime;	an = "ref_m";	mask = STATX_MTIME; break;
+	case '0': a = &origin;		an = "origin";	mask = 0; break;
+	default:
+		bad_arg("ts= timestamp '%c' not supported\n", arg[0]);
+	}
+
+	if (arg[0] == '0') {
+		if (!origin_set)
+			bad_arg("ts= timestamp '%c' requires origin= first\n", arg[0]);
+	} else if (arg[0] <= 'Z') {
+		if (!ref_set)
+			bad_arg("ts= timestamp '%c' requires ref= first\n", arg[0]);
+		if (!(ref.stx_mask & mask))
+			return;
+	} else {
+		if (!(stx->stx_mask & mask))
+			return;
+	}
+
+	switch (arg[2]) {
+	case 'a': b = &stx->stx_atime;	bn = "atime";	mask = STATX_ATIME; break;
+	case 'b': b = &stx->stx_btime;	bn = "btime";	mask = STATX_BTIME; break;
+	case 'c': b = &stx->stx_ctime;	bn = "ctime";	mask = STATX_CTIME; break;
+	case 'm': b = &stx->stx_mtime;	bn = "mtime";	mask = STATX_MTIME; break;
+	case 'A': b = &ref.stx_atime;	bn = "ref_a";	mask = STATX_ATIME; break;
+	case 'B': b = &ref.stx_btime;	bn = "ref_b";	mask = STATX_BTIME; break;
+	case 'C': b = &ref.stx_ctime;	bn = "ref_c";	mask = STATX_CTIME; break;
+	case 'M': b = &ref.stx_mtime;	bn = "ref_m";	mask = STATX_MTIME; break;
+	case '0': b = &origin;		bn = "origin";	mask = 0; break;
+	default:
+		bad_arg("ts= timestamp '%c' not supported\n", arg[2]);
+	}
+
+	if (arg[2] == '0') {
+		if (!origin_set)
+			bad_arg("ts= timestamp '%c' requires origin= first\n", arg[0]);
+	} else if (arg[2] <= 'Z') {
+		if (!ref_set)
+			bad_arg("ts= timestamp '%c' requires ref= first\n", arg[2]);
+		if (!(ref.stx_mask & mask))
+			return;
+	} else {
+		if (!(stx->stx_mask & mask))
+			return;
+	}
+
+	verbose("check %s <= %s\n", an, bn);
+	check_earlier(a, b, an, bn);
+}
+
+/*
+ * Compare to reference file.
+ */
+static void cmp_ref(const struct statx *stx, unsigned int mask)
+{
+#undef cmp
+#define cmp(fmt, x)							\
+	do {								\
+		check(stx->x == ref.x,					\
+		      "attr '%s' differs from ref file, "fmt" != "fmt"\n", \
+		      #x,						\
+		      (unsigned long long)stx->x,			\
+		      (unsigned long long)ref.x);			\
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
+ * Check an field restriction.  Specified on the command line as a key=val pair
+ * in the checks section.  For instance:
+ *
+ *	stx_type=char
+ *	stx_mode=0644
+ */
+static void check_field(const struct statx *stx, char *arg)
+{
+	const struct file_type *type;
+	const struct field *field;
+	unsigned long long ucheck, uval = 0;
+	long long scheck, sval = 0;
+	char *key, *val, *p;
+
+	verbose("check %s\n", arg);
+
+	key = arg;
+	val = strchr(key, '=');
+	if (!val || !val[1])
+		bad_arg("%s check requires value\n", key);
+	*(val++) = 0;
+
+	field = bsearch(key, field_list, nr__fields, sizeof(*field), field_cmp);
+	if (!field)
+		bad_arg("Field '%s' not supported\n", key);
+
+	/* Read the stat information specified by the key. */
+	switch ((enum fields)(field - field_list)) {
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
+	switch ((enum fields)(field - field_list)) {
+	case stx_mask:
+	case stx_attributes:
+		ucheck = strtoull(val, &p, 0);
+		if (*p)
+			bad_arg("Field '%s' requires unsigned integer\n", key);
+		check(uval == ucheck,
+		      "%s differs, 0x%llx != 0x%llx\n", key, uval, ucheck);
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
+		if (*p)
+			bad_arg("Field '%s' requires unsigned integer\n", key);
+	octal_check:
+		check(uval == ucheck,
+		      "%s differs, 0%llo != 0%llo\n", key, uval, ucheck);
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
+		if (*p)
+			bad_arg("Field '%s' requires unsigned integer\n", key);
+		check(uval == ucheck,
+		      "%s differs, %llu != %llu\n", key, uval, ucheck);
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
+		if (*p)
+			bad_arg("Field '%s' requires integer\n", key);
+		check(sval == scheck,
+		      "%s differs, %lld != %lld\n", key, sval, scheck);
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
+	char *p;
+	int c, ret;
+
+	if (argc == 2 && strcmp(argv[1], "--check-statx") == 0) {
+		errno = 0;
+		return (xfstests_statx(AT_FDCWD, "/", 0, 0, &stx) == -1 &&
+			errno == ENOSYS) ? 1 : 0;
+	}
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
+	if (argc < 1)
+		format();
+	testfile = argv[0];
+	argv += 1;
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
+
+		if (strcmp("cmp_ref", arg) == 0) {
+			/* cmp_ref - check ref file has same stats */
+			cmp_ref(&stx, mask);
+			continue;
+		}
+
+		if (strncmp(arg, "stx_", 4) == 0) {
+			/* stx_<field>=<n> - check field set to n */
+			check_field(&stx, *argv);
+			continue;
+		}
+
+		if (strncmp("ref=", arg, 4) == 0) {
+			/* ref=<file> - set reference stats from file */
+			get_reference(arg + 4);
+			continue;
+		}
+
+		if (strcmp("ts_order", arg) == 0) {
+			/* ts_order - check timestamp order */
+			check_timestamp_order(&stx);
+			continue;
+		}
+
+		if (strncmp("ts_origin=", arg, 10) == 0) {
+			/* ts_origin=<sec>.<nsec> - set origin timestamp */
+			set_origin_timestamp(arg + 10);
+			continue;
+		}
+
+		if (strncmp("ts=", arg, 3) == 0) {
+			/* ts=<a>,<b> - check timestamp b is same as a or after */
+			check_timestamp(&stx, arg + 3);
+			continue;
+		}
+
+		bad_arg("check '%s' not supported\n", arg);
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
index 0000000..10ec08d
--- /dev/null
+++ b/tests/generic/420
@@ -0,0 +1,181 @@
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
+status=1
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	rm -rf $TEST_DIR/$seq-*
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
+_require_test_program "af_unix"
+_require_statx
+
+function check_stat () {
+    $here/src/stat_test $* || echo stat_test failed
+}
+
+function create_af_unix () {
+    $here/src/af_unix $* || echo af_unix failed
+}
+
+###############################################################################
+#
+# Check statx'ing of various types of object
+#
+# After each object is created, barring the first, we check that the creation
+# time and the change time of the new object as same as or later than the
+# corresponding timestamps on the previous object created.
+#
+###############################################################################
+echo "Test statx on a fifo"
+mkfifo -m 0600 $TEST_DIR/$seq-fifo
+check_stat $TEST_DIR/$seq-fifo \
+	   ts_order \
+	   stx_type=fifo \
+	   stx_mode=0600 \
+	   stx_rdev_major=0 \
+	   stx_rdev_minor=0 \
+	   stx_nlink=1
+
+echo "Test statx on a chardev"
+mknod -m 0600 $TEST_DIR/$seq-null c 1 3
+check_stat $TEST_DIR/$seq-null \
+	   ts_order \
+	   ref=$TEST_DIR/$seq-fifo \
+	   ts=B,b \
+	   ts=M,m \
+	   stx_type=char \
+	   stx_mode=0600 \
+	   stx_rdev_major=1 \
+	   stx_rdev_minor=3 \
+	   stx_nlink=1
+
+echo "Test statx on a directory"
+mkdir $TEST_DIR/$seq-dir
+check_stat $TEST_DIR/$seq-dir \
+	   ts_order \
+	   ref=$TEST_DIR/$seq-null \
+	   ts=B,b \
+	   ts=M,m \
+	   stx_type=dir \
+	   stx_mode=0755 \
+	   stx_rdev_major=0 \
+	   stx_rdev_minor=0 \
+	   stx_nlink=2
+
+echo "Test statx on a blockdev"
+mknod -m 0600 $TEST_DIR/$seq-loopy b 7 123
+check_stat $TEST_DIR/$seq-loopy \
+	   ts_order \
+	   ref=$TEST_DIR/$seq-dir \
+	   ts=B,b \
+	   ts=M,m \
+	   stx_type=block \
+	   stx_mode=0600 \
+	   stx_rdev_major=7 \
+	   stx_rdev_minor=123 \
+	   stx_nlink=1
+
+echo "Test statx on a file"
+dd if=/dev/zero of=$TEST_DIR/$seq-file bs=1024 count=20
+check_stat $TEST_DIR/$seq-file \
+	   ts_order \
+	   ref=$TEST_DIR/$seq-loopy \
+	   ts=B,b \
+	   ts=M,m \
+	   stx_type=file \
+	   stx_size=20480 \
+	   stx_rdev_major=0 \
+	   stx_rdev_minor=0 \
+	   stx_nlink=1
+
+echo "Test statx on a symlink"
+ln -s $TEST_DIR/$seq-nowhere $TEST_DIR/$seq-symlink
+check_stat $TEST_DIR/$seq-symlink \
+	   ts_order \
+	   ref=$TEST_DIR/$seq-file \
+	   ts=B,b \
+	   ts=M,m \
+	   stx_type=sym \
+	   stx_rdev_major=0 \
+	   stx_rdev_minor=0 \
+	   stx_nlink=1
+
+echo "Test statx on an AF_UNIX socket"
+create_af_unix $TEST_DIR/$seq-sock
+check_stat $TEST_DIR/$seq-sock \
+	   ts_order \
+	   ref=$TEST_DIR/$seq-symlink \
+	   ts=B,b \
+	   ts=M,m \
+	   stx_type=sock \
+	   stx_rdev_major=0 \
+	   stx_rdev_minor=0 \
+	   stx_nlink=1
+
+#
+# Test hard link creation.  Make sure that the file's ctime is now same as or
+# later than the creation time of the socket, but that the file's creation time
+# still lies somewhere between those of the directory and the socket.
+#
+echo "Test a hard link to a file"
+ln $TEST_DIR/$seq-file $TEST_DIR/$seq-link
+check_stat $TEST_DIR/$seq-link \
+	   ref=$TEST_DIR/$seq-dir \
+	   ts=B,b \
+	   ref=$TEST_DIR/$seq-sock \
+	   ts=b,B \
+	   ts=B,c \
+	   ts=C,c \
+	   ref=$TEST_DIR/$seq-file \
+	   cmp_ref \
+	   stx_nlink=2
+
+# Done.  We leave the success determination to the output comparator.
+status=0
+exit
diff --git a/tests/generic/420.out b/tests/generic/420.out
new file mode 100644
index 0000000..21d6ffc
--- /dev/null
+++ b/tests/generic/420.out
@@ -0,0 +1,11 @@
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
diff --git a/tests/generic/group b/tests/generic/group
index 0781f35..5678101 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -422,3 +422,4 @@
 417 auto quick shutdown log
 418 auto rw
 419 auto quick encrypt
+420 auto quick

