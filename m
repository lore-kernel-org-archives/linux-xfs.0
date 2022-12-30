Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CEEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiLaAxP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAxP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:53:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2FA186CF;
        Fri, 30 Dec 2022 16:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B19561D47;
        Sat, 31 Dec 2022 00:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9189C433EF;
        Sat, 31 Dec 2022 00:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447992;
        bh=n4wj0sE2v3XC34dlrIeh+9bA37XaAGa4dS3eOB10hoM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OECNRTgXlu5Z2c0RiVHIMYNJ+dMYjtgXLxD2yNKvHVybB7DY2CIuhKHNOmjpLlG6c
         RzmF2AxC7l8qavpB1SGvcKpuT82VkHIq4nv3BnX6E4k2s+3odAdEQgN3qg38ijpP3l
         vVppu7h9h7VOihlbEk5A7M0mfV9wC6ihP0xWtomdSuHIxTbrTtT69HuKdGRvUeSvll
         PTlU9oKyqJO1QfmQPtu93xsaniUmXIN0I51CFY4NKC3+ceE/7ijM9GTFWmUJ0A3SPL
         1rjICEaz+K7hV5UqI/5tK3Pl7KB+iLSDvlVVSR0wRCRYQ8d3QFGFjTl20LIpI+FKSe
         5M7L1KEHLJJGg==
Subject: [PATCH 6/7] fsx: support FIEXCHANGE_RANGE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:49 -0800
Message-ID: <167243878899.732172.1539601356241657286.stgit@magnolia>
In-Reply-To: <167243878818.732172.6392253687008406885.stgit@magnolia>
References: <167243878818.732172.6392253687008406885.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Upgrade fsx to support exchanging file contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    1 
 include/builddefs.in  |    1 
 ltp/Makefile          |    4 +
 ltp/fsx.c             |  160 ++++++++++++++++++++++++++++++++++++++++++++++++-
 m4/package_libcdev.m4 |   21 ++++++
 src/fiexchange.h      |  101 +++++++++++++++++++++++++++++++
 src/global.h          |    6 ++
 7 files changed, 292 insertions(+), 2 deletions(-)
 create mode 100644 src/fiexchange.h


diff --git a/configure.ac b/configure.ac
index e92bd6b26d..4687d8a3c0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -70,6 +70,7 @@ AC_HAVE_SEEK_DATA
 AC_HAVE_BMV_OF_SHARED
 AC_HAVE_NFTW
 AC_HAVE_RLIMIT_NOFILE
+AC_HAVE_FIEXCHANGE
 
 AC_CHECK_FUNCS([renameat2])
 AC_CHECK_FUNCS([reallocarray])
diff --git a/include/builddefs.in b/include/builddefs.in
index dab10c968f..969acf0da2 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -72,6 +72,7 @@ HAVE_SEEK_DATA = @have_seek_data@
 HAVE_NFTW = @have_nftw@
 HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
 HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
+HAVE_FIEXCHANGE = @have_fiexchange@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 
diff --git a/ltp/Makefile b/ltp/Makefile
index 85f634145c..c2b70d896e 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -36,6 +36,10 @@ ifeq ($(HAVE_COPY_FILE_RANGE),yes)
 LCFLAGS += -DHAVE_COPY_FILE_RANGE
 endif
 
+ifeq ($(HAVE_FIEXCHANGE),yes)
+LCFLAGS += -DHAVE_FIEXCHANGE
+endif
+
 default: depend $(TARGETS)
 
 depend: .dep
diff --git a/ltp/fsx.c b/ltp/fsx.c
index 12c2cc33bf..ee4b8fe45d 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -111,6 +111,7 @@ enum {
 	OP_CLONE_RANGE,
 	OP_DEDUPE_RANGE,
 	OP_COPY_RANGE,
+	OP_EXCHANGE_RANGE,
 	OP_MAX_FULL,
 
 	/* integrity operations */
@@ -175,6 +176,7 @@ int	check_file = 0;			/* -X flag enables */
 int	clone_range_calls = 1;		/* -J flag disables */
 int	dedupe_range_calls = 1;		/* -B flag disables */
 int	copy_range_calls = 1;		/* -E flag disables */
+int	xchg_range_calls = 1;		/* -0 flag disables */
 int	integrity = 0;			/* -i flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -268,6 +270,7 @@ static const char *op_names[] = {
 	[OP_DEDUPE_RANGE] = "dedupe_range",
 	[OP_COPY_RANGE] = "copy_range",
 	[OP_FSYNC] = "fsync",
+	[OP_EXCHANGE_RANGE] = "xchg_range",
 };
 
 static const char *op_name(int operation)
@@ -452,6 +455,20 @@ logdump(void)
 			if (overlap)
 				prt("\t******IIII");
 			break;
+		case OP_EXCHANGE_RANGE:
+			prt("XCHG 0x%x thru 0x%x\t(0x%x bytes) to 0x%x thru 0x%x",
+			    lp->args[0], lp->args[0] + lp->args[1] - 1,
+			    lp->args[1],
+			    lp->args[2], lp->args[2] + lp->args[1] - 1);
+			overlap2 = badoff >= lp->args[2] &&
+				  badoff < lp->args[2] + lp->args[1];
+			if (overlap && overlap2)
+				prt("\tXXXX**XXXX");
+			else if (overlap)
+				prt("\tXXXX******");
+			else if (overlap2)
+				prt("\t******XXXX");
+			break;
 		case OP_CLONE_RANGE:
 			prt("CLONE 0x%x thru 0x%x\t(0x%x bytes) to 0x%x thru 0x%x",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
@@ -1369,6 +1386,116 @@ do_insert_range(unsigned offset, unsigned length)
 }
 #endif
 
+#ifdef FIEXCHANGE_RANGE
+static __u64 swap_flags = 0;
+
+int
+test_xchg_range(void)
+{
+	struct file_xchg_range	fsr = {
+		.file1_fd = fd,
+		.flags = FILE_XCHG_RANGE_DRY_RUN | swap_flags,
+	};
+	int ret, e;
+
+retry:
+	ret = ioctl(fd, FIEXCHANGE_RANGE, &fsr);
+	e = ret < 0 ? errno : 0;
+	if (e == EOPNOTSUPP && !(swap_flags & FILE_XCHG_RANGE_NONATOMIC)) {
+		/*
+		 * If the call fails with atomic mode, try again with non
+		 * atomic mode.
+		 */
+		swap_flags = FILE_XCHG_RANGE_NONATOMIC;
+		fsr.flags |= swap_flags;
+		goto retry;
+	}
+	if (e == EOPNOTSUPP || errno == ENOTTY) {
+		if (!quiet)
+			fprintf(stderr,
+				"main: filesystem does not support "
+				"exchange range, disabling!\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+void
+do_xchg_range(unsigned offset, unsigned length, unsigned dest)
+{
+	struct file_xchg_range	fsr = {
+		.file1_fd = fd,
+		.file1_offset = offset,
+		.file2_offset = dest,
+		.length = length,
+		.flags = swap_flags,
+	};
+	void *p;
+
+	if (length == 0) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping zero length exchange range\n");
+		log5(OP_EXCHANGE_RANGE, offset, length, dest, FL_SKIPPED);
+		return;
+	}
+
+	if ((loff_t)offset >= file_size || (loff_t)dest >= file_size) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping exchange range behind EOF\n");
+		log5(OP_EXCHANGE_RANGE, offset, length, dest, FL_SKIPPED);
+		return;
+	}
+
+	p = malloc(length);
+	if (!p) {
+		if (!quiet && testcalls > simulatedopcount)
+			prt("skipping exchange range due to ENOMEM\n");
+		log5(OP_EXCHANGE_RANGE, offset, length, dest, FL_SKIPPED);
+		return;
+	}
+
+	log5(OP_EXCHANGE_RANGE, offset, length, dest, FL_NONE);
+
+	if (testcalls <= simulatedopcount)
+		goto out_free;
+
+	if ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug && (monitorstart == -1 || monitorend == -1 ||
+		       dest <= monitorstart || dest + length <= monitorend))) {
+		prt("%lu swap\tfrom 0x%x to 0x%x, (0x%x bytes) at 0x%x\n",
+			testcalls, offset, offset+length, length, dest);
+	}
+
+	if (ioctl(fd, FIEXCHANGE_RANGE, &fsr) == -1) {
+		prt("exchange range: 0x%x to 0x%x at 0x%x\n", offset,
+				offset + length, dest);
+		prterr("do_xchg_range: FIEXCHANGE_RANGE");
+		report_failure(161);
+		goto out_free;
+	}
+
+	memcpy(p, good_buf + offset, length);
+	memcpy(good_buf + offset, good_buf + dest, length);
+	memcpy(good_buf + dest, p, length);
+out_free:
+	free(p);
+}
+
+#else
+int
+test_xchg_range(void)
+{
+	return 0;
+}
+
+void
+do_xchg_range(unsigned offset, unsigned length, unsigned dest)
+{
+	return;
+}
+#endif
+
 #ifdef FICLONERANGE
 int
 test_clone_range(void)
@@ -1856,6 +1983,7 @@ static int
 op_args_count(int operation)
 {
 	switch (operation) {
+	case OP_EXCHANGE_RANGE:
 	case OP_CLONE_RANGE:
 	case OP_DEDUPE_RANGE:
 	case OP_COPY_RANGE:
@@ -2053,6 +2181,9 @@ test(void)
 	case OP_COPY_RANGE:
 		generate_dest_range(true, maxfilelen, &offset, &size, &offset2);
 		break;
+	case OP_EXCHANGE_RANGE:
+		generate_dest_range(false, file_size, &offset, &size, &offset2);
+		break;
 	}
 
 have_op:
@@ -2096,6 +2227,12 @@ test(void)
 			goto out;
 		}
 		break;
+	case OP_EXCHANGE_RANGE:
+		if (!xchg_range_calls) {
+			log5(op, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+		break;
 	case OP_CLONE_RANGE:
 		if (!clone_range_calls) {
 			log5(op, offset, size, offset2, FL_SKIPPED);
@@ -2180,6 +2317,18 @@ test(void)
 
 		do_insert_range(offset, size);
 		break;
+	case OP_EXCHANGE_RANGE:
+		if (size == 0) {
+			log5(OP_EXCHANGE_RANGE, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+		if (offset2 + size > maxfilelen) {
+			log5(OP_EXCHANGE_RANGE, offset, size, offset2, FL_SKIPPED);
+			goto out;
+		}
+
+		do_xchg_range(offset, size, offset2);
+		break;
 	case OP_CLONE_RANGE:
 		if (size == 0) {
 			log5(OP_CLONE_RANGE, offset, size, offset2, FL_SKIPPED);
@@ -2294,6 +2443,9 @@ usage(void)
 #ifdef HAVE_COPY_FILE_RANGE
 "	-E: Do not use copy range calls\n"
 #endif
+#ifdef FIEXCHANGE_RANGE
+"	-0: Do not use exchange range calls\n"
+#endif
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
@@ -2608,12 +2760,11 @@ main(int argc, char **argv)
 	page_size = getpagesize();
 	page_mask = page_size - 1;
 	mmap_mask = page_mask;
-	
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
+				 "0b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -2747,6 +2898,9 @@ main(int argc, char **argv)
 		case 'I':
 			insert_range_calls = 0;
 			break;
+		case '0':
+			xchg_range_calls = 0;
+			break;
 		case 'J':
 			clone_range_calls = 0;
 			break;
@@ -2988,6 +3142,8 @@ main(int argc, char **argv)
 		dedupe_range_calls = test_dedupe_range();
 	if (copy_range_calls)
 		copy_range_calls = test_copy_range();
+	if (xchg_range_calls)
+		xchg_range_calls = test_xchg_range();
 
 	while (numops == -1 || numops--)
 		if (!test())
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index e1b381c16f..db663970c2 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -157,3 +157,24 @@ AC_DEFUN([AC_HAVE_RLIMIT_NOFILE],
        AC_MSG_RESULT(no))
     AC_SUBST(have_rlimit_nofile)
   ])
+
+#
+# Check if we have a FIEXCHANGE_RANGE ioctl (Linux)
+#
+AC_DEFUN([AC_HAVE_FIEXCHANGE],
+  [ AC_MSG_CHECKING([for FIEXCHANGE_RANGE])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+#include <linux/fs.h>
+#include <linux/fiexchange.h>
+    ], [
+         struct file_xchg_range fxr;
+         ioctl(-1, FIEXCHANGE_RANGE, &fxr);
+    ], have_fiexchange=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_fiexchange)
+  ])
diff --git a/src/fiexchange.h b/src/fiexchange.h
new file mode 100644
index 0000000000..29b3ac0ff5
--- /dev/null
+++ b/src/fiexchange.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
+/*
+ * FIEXCHANGE ioctl definitions, to facilitate exchanging parts of files.
+ *
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef _LINUX_FIEXCHANGE_H
+#define _LINUX_FIEXCHANGE_H
+
+#include <linux/types.h>
+
+/*
+ * Exchange part of file1 with part of the file that this ioctl that is being
+ * called against (which we'll call file2).  Filesystems must be able to
+ * restart and complete the operation even after the system goes down.
+ */
+struct file_xchg_range {
+	__s64		file1_fd;
+	__s64		file1_offset;	/* file1 offset, bytes */
+	__s64		file2_offset;	/* file2 offset, bytes */
+	__s64		length;		/* bytes to exchange */
+
+	__u64		flags;		/* see FILE_XCHG_RANGE_* below */
+
+	/* file2 metadata for optional freshness checks */
+	__s64		file2_ino;	/* inode number */
+	__s64		file2_mtime;	/* modification time */
+	__s64		file2_ctime;	/* change time */
+	__s32		file2_mtime_nsec; /* mod time, nsec */
+	__s32		file2_ctime_nsec; /* change time, nsec */
+
+	__u64		pad[6];		/* must be zeroes */
+};
+
+/*
+ * Atomic exchange operations are not required.  This relaxes the requirement
+ * that the filesystem must be able to complete the operation after a crash.
+ */
+#define FILE_XCHG_RANGE_NONATOMIC	(1 << 0)
+
+/*
+ * Check that file2's inode number, mtime, and ctime against the values
+ * provided, and return -EBUSY if there isn't an exact match.
+ */
+#define FILE_XCHG_RANGE_FILE2_FRESH	(1 << 1)
+
+/*
+ * Check that the file1's length is equal to file1_offset + length, and that
+ * file2's length is equal to file2_offset + length.  Returns -EDOM if there
+ * isn't an exact match.
+ */
+#define FILE_XCHG_RANGE_FULL_FILES	(1 << 2)
+
+/*
+ * Exchange file data all the way to the ends of both files, and then exchange
+ * the file sizes.  This flag can be used to replace a file's contents with a
+ * different amount of data.  length will be ignored.
+ */
+#define FILE_XCHG_RANGE_TO_EOF		(1 << 3)
+
+/* Flush all changes in file data and file metadata to disk before returning. */
+#define FILE_XCHG_RANGE_FSYNC		(1 << 4)
+
+/* Dry run; do all the parameter verification but do not change anything. */
+#define FILE_XCHG_RANGE_DRY_RUN		(1 << 5)
+
+/*
+ * Do not exchange any part of the range where file1's mapping is a hole.  This
+ * can be used to emulate scatter-gather atomic writes with a temp file.
+ */
+#define FILE_XCHG_RANGE_SKIP_FILE1_HOLES (1 << 6)
+
+/*
+ * Commit the contents of file1 into file2 if file2 has the same inode number,
+ * mtime, and ctime as the arguments provided to the call.  The old contents of
+ * file2 will be moved to file1.
+ *
+ * With this flag, all committed information can be retrieved even if the
+ * system crashes or is rebooted.  This includes writing through or flushing a
+ * disk cache if present.  The call blocks until the device reports that the
+ * commit is complete.
+ *
+ * This flag should not be combined with NONATOMIC.  It can be combined with
+ * SKIP_FILE1_HOLES.
+ */
+#define FILE_XCHG_RANGE_COMMIT		(FILE_XCHG_RANGE_FILE2_FRESH | \
+					 FILE_XCHG_RANGE_FSYNC)
+
+#define FILE_XCHG_RANGE_ALL_FLAGS	(FILE_XCHG_RANGE_NONATOMIC | \
+					 FILE_XCHG_RANGE_FILE2_FRESH | \
+					 FILE_XCHG_RANGE_FULL_FILES | \
+					 FILE_XCHG_RANGE_TO_EOF | \
+					 FILE_XCHG_RANGE_FSYNC | \
+					 FILE_XCHG_RANGE_DRY_RUN | \
+					 FILE_XCHG_RANGE_SKIP_FILE1_HOLES)
+
+#define FIEXCHANGE_RANGE	_IOWR('X', 129, struct file_xchg_range)
+
+#endif /* _LINUX_FIEXCHANGE_H */
diff --git a/src/global.h b/src/global.h
index b44070993c..49570ef117 100644
--- a/src/global.h
+++ b/src/global.h
@@ -171,6 +171,12 @@
 #include <sys/mman.h>
 #endif
 
+#ifdef HAVE_FIEXCHANGE
+# include <linux/fiexchange.h>
+#else
+# include "fiexchange.h"
+#endif
+
 static inline unsigned long long
 rounddown_64(unsigned long long x, unsigned int y)
 {

