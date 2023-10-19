Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E9BCDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 20:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjJSUJS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 16:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjJSUJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 16:09:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6DD116
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 13:09:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C3FC433C7;
        Thu, 19 Oct 2023 20:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697746154;
        bh=df3MuC2p43Yj8/Se1wUKMo3AEWDnyQGM4oB0Yr7bIFA=;
        h=Date:From:To:Cc:Subject:From;
        b=j5ixAGNndsLebDW+cBpsiEQeTa3UgM0Jf8nCGchPTD1YPWtBkAYqQQhvm9+rUMONq
         4NUX7zzbsd3ja1q8RCtio+3d7tyTG6TB0XFC+Vio3JIPsz4awh8vnWVNSDM89p0Vdp
         2/fLR82DkNrhK2Jx6hP2lovfRYrdeEMETOmqSGMZYwUB1Aoo30DIOVGgk2XYxfMRzN
         TMTOwXXfcGrDo8fxJ+ojnKfrMuMRUtgzwlspXFSByKsC9ogj9qicZ7EEJeu/CdJWZX
         uwfiAsnPp9Pxxnj4DM4yMz3AdLXQkL2p5r8smxOIJl2qs5XjhuXXmQHZGM8u31G3l4
         Wfrt8cCX6D7Ew==
Date:   Thu, 19 Oct 2023 13:09:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [RFC PATCH] generic: test reads racing with slow reflink operations
Message-ID: <20231019200913.GO3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS has a rather slow reflink operation.  While a reflink operation is
running, other programs cannot read the contents of the source file,
which is causing latency spikes.  Catherine Hoang wrote a patch to
permit reads, since the source file contents do  not change.  This is a
functionality test for that patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/Makefile              |    2 
 src/t_reflink_read_race.c |  343 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1953        |   74 ++++++++++
 tests/generic/1953.out    |    6 +
 4 files changed, 424 insertions(+), 1 deletion(-)
 create mode 100644 src/t_reflink_read_race.c
 create mode 100755 tests/generic/1953
 create mode 100644 tests/generic/1953.out

diff --git a/src/Makefile b/src/Makefile
index 72c8a13007..b5e2b84dae 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -33,7 +33,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
-	uuid_ioctl usemem_and_swapoff
+	uuid_ioctl usemem_and_swapoff t_reflink_read_race
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/t_reflink_read_race.c b/src/t_reflink_read_race.c
new file mode 100644
index 0000000000..acf8f8f73c
--- /dev/null
+++ b/src/t_reflink_read_race.c
@@ -0,0 +1,343 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Race reads with reflink to see if reads continue while we're cloning.
+ * Copyright 2023 Oracle.  All rights reserved.
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+#include <time.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <signal.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+
+#ifndef FICLONE
+# define FICLONE	_IOW(0x94, 9, int)
+#endif
+
+static pid_t mypid;
+
+static FILE *outcome_fp;
+
+/* Significant timestamps.  Initialized to zero */
+static double program_start, clone_start, clone_end;
+
+/* Coordinates access to timestamps */
+static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
+
+struct readinfo {
+	int fd;
+	unsigned int blocksize;
+	char *descr;
+};
+
+struct cloneinfo {
+	int src_fd, dst_fd;
+};
+
+#define MSEC_PER_SEC	1000
+#define NSEC_PER_MSEC	1000000
+
+/*
+ * Assume that it shouldn't take longer than 100ms for the FICLONE ioctl to
+ * enter the kernel and take locks on an uncontended file.  This is also the
+ * required CLOCK_MONOTONIC granularity.
+ */
+#define EARLIEST_READ_MS	(MSEC_PER_SEC / 10)
+
+/*
+ * We want to be reasonably sure that the FICLONE takes long enough that any
+ * read initiated after clone operation locked the source file could have
+ * completed a disk IO before the clone finishes.  Therefore, we require that
+ * the clone operation must take at least 4x the maximum setup time.
+ */
+#define MINIMUM_CLONE_MS	(EARLIEST_READ_MS * 5)
+
+static double timespec_to_msec(const struct timespec *ts)
+{
+	return (ts->tv_sec * (double)MSEC_PER_SEC) +
+	       (ts->tv_nsec / (double)NSEC_PER_MSEC);
+}
+
+static void sleep_ms(unsigned int len)
+{
+	struct timespec time = {
+		.tv_nsec = len * NSEC_PER_MSEC,
+	};
+
+	nanosleep(&time, NULL);
+}
+
+static void outcome(const char *str)
+{
+	fprintf(outcome_fp, "%s\n", str);
+	fflush(outcome_fp);
+}
+
+static void *reader_fn(void *arg)
+{
+	struct timespec now;
+	struct readinfo *ri = arg;
+	char *buf = malloc(ri->blocksize);
+	loff_t pos = 0;
+	ssize_t copied;
+	int ret;
+
+	if (!buf) {
+		perror("alloc buffer");
+		goto kill_error;
+	}
+
+	/* Wait for the FICLONE to start */
+	pthread_mutex_lock(&lock);
+	while (clone_start < program_start) {
+		pthread_mutex_unlock(&lock);
+#ifdef DEBUG
+		printf("%s read waiting for clone to start; cs=%.2f ps=%.2f\n",
+				ri->descr, clone_start, program_start);
+		fflush(stdout);
+#endif
+		sleep_ms(1);
+		pthread_mutex_lock(&lock);
+	}
+	pthread_mutex_unlock(&lock);
+	sleep_ms(EARLIEST_READ_MS);
+
+	/* Read from the file... */
+	while ((copied = read(ri->fd, buf, ri->blocksize)) > 0) {
+		double read_completion;
+
+		ret = clock_gettime(CLOCK_MONOTONIC, &now);
+		if (ret) {
+			perror("clock_gettime");
+			goto kill_error;
+		}
+		read_completion = timespec_to_msec(&now);
+
+		/*
+		 * If clone_end is still zero, the FICLONE is still running.
+		 * If the read completion occurred a safe duration after the
+		 * start of the ioctl, then report that as an early read
+		 * completion.
+		 */
+		pthread_mutex_lock(&lock);
+		if (clone_end < program_start &&
+		    read_completion > clone_start + EARLIEST_READ_MS) {
+			pthread_mutex_unlock(&lock);
+
+			/* clone still running... */
+			printf("finished %s read early at %.2fms\n",
+					ri->descr,
+					read_completion - program_start);
+			fflush(stdout);
+			outcome("finished read early");
+			goto kill_done;
+		}
+		pthread_mutex_unlock(&lock);
+
+		sleep_ms(1);
+		pos += copied;
+	}
+	if (copied < 0) {
+		perror("read");
+		goto kill_error;
+	}
+
+	return NULL;
+kill_error:
+	outcome("reader error");
+kill_done:
+	kill(mypid, SIGTERM);
+	return NULL;
+}
+
+static void *clone_fn(void *arg)
+{
+	struct timespec now;
+	struct cloneinfo *ci = arg;
+	int ret;
+
+	/* Record the approximate start time of this thread */
+	ret = clock_gettime(CLOCK_MONOTONIC, &now);
+	if (ret) {
+		perror("clock_gettime clone start");
+		goto kill_error;
+	}
+	pthread_mutex_lock(&lock);
+	clone_start = timespec_to_msec(&now);
+	pthread_mutex_unlock(&lock);
+
+	printf("started clone at %.2fms\n", clone_start - program_start);
+	fflush(stdout);
+
+	/* Kernel call, only killable with a fatal signal */
+	ret = ioctl(ci->dst_fd, FICLONE, ci->src_fd);
+	if (ret) {
+		perror("FICLONE");
+		goto kill_error;
+	}
+
+	/* If the ioctl completes, note the completion time */
+	ret = clock_gettime(CLOCK_MONOTONIC, &now);
+	if (ret) {
+		perror("clock_gettime clone end");
+		goto kill_error;
+	}
+
+	pthread_mutex_lock(&lock);
+	clone_end = timespec_to_msec(&now);
+	pthread_mutex_unlock(&lock);
+
+	printf("finished clone at %.2fms\n",
+			clone_end - program_start);
+	fflush(stdout);
+
+	/* Complain if we didn't take long enough to clone. */
+	if (clone_end < clone_start + MINIMUM_CLONE_MS) {
+		printf("clone did not take enough time (%.2fms)\n",
+				clone_end - clone_start);
+		fflush(stdout);
+		outcome("clone too fast");
+		goto kill_done;
+	}
+
+	outcome("clone finished before any reads");
+	goto kill_done;
+
+kill_error:
+	outcome("clone error");
+kill_done:
+	kill(mypid, SIGTERM);
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	struct cloneinfo ci;
+	struct readinfo bufio = { .descr = "buffered" };
+	struct readinfo directio = { .descr = "directio" };
+	struct timespec now;
+	pthread_t clone_thread, bufio_thread, directio_thread;
+	double clockres;
+	int ret;
+
+	if (argc != 4) {
+		printf("Usage: %s src_file dst_file outcome_file\n", argv[0]);
+		return 1;
+	}
+
+	mypid = getpid();
+
+	/* Check for sufficient clock precision. */
+	ret = clock_getres(CLOCK_MONOTONIC, &now);
+	if (ret) {
+		perror("clock_getres MONOTONIC");
+		return 2;
+	}
+	printf("CLOCK_MONOTONIC resolution: %llus %luns\n",
+			(unsigned long long)now.tv_sec,
+			(unsigned long)now.tv_nsec);
+	fflush(stdout);
+
+	clockres = timespec_to_msec(&now);
+	if (clockres > EARLIEST_READ_MS) {
+		fprintf(stderr, "insufficient CLOCK_MONOTONIC resolution\n");
+		return 2;
+	}
+
+	/*
+	 * Measure program start time since the MONOTONIC time base is not
+	 * all that well defined.
+	 */
+	ret = clock_gettime(CLOCK_MONOTONIC, &now);
+	if (ret) {
+		perror("clock_gettime MONOTONIC");
+		return 2;
+	}
+	if (now.tv_sec == 0 && now.tv_nsec == 0) {
+		fprintf(stderr, "Uhoh, start time is zero?!\n");
+		return 2;
+	}
+	program_start = timespec_to_msec(&now);
+
+	outcome_fp = fopen(argv[3], "w");
+	if (!outcome_fp) {
+		perror(argv[3]);
+		return 2;
+	}
+
+	/* Open separate fds for each thread */
+	ci.src_fd = open(argv[1], O_RDONLY);
+	if (ci.src_fd < 0) {
+		perror(argv[1]);
+		return 2;
+	}
+
+	ci.dst_fd = open(argv[2], O_RDWR | O_CREAT, 0600);
+	if (ci.dst_fd < 0) {
+		perror(argv[2]);
+		return 2;
+	}
+
+	bufio.fd = open(argv[1], O_RDONLY);
+	if (bufio.fd < 0) {
+		perror(argv[1]);
+		return 2;
+	}
+	bufio.blocksize = 37;
+
+	directio.fd = open(argv[1], O_RDONLY | O_DIRECT);
+	if (directio.fd < 0) {
+		perror(argv[1]);
+		return 2;
+	}
+	directio.blocksize = 512;
+
+	/* Start threads */
+	ret = pthread_create(&clone_thread, NULL, clone_fn, &ci);
+	if (ret) {
+		fprintf(stderr, "create clone thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	ret = pthread_create(&bufio_thread, NULL, reader_fn, &bufio);
+	if (ret) {
+		fprintf(stderr, "create bufio thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	ret = pthread_create(&directio_thread, NULL, reader_fn, &directio);
+	if (ret) {
+		fprintf(stderr, "create directio thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	/* Wait for threads */
+	ret = pthread_join(clone_thread, NULL);
+	if (ret) {
+		fprintf(stderr, "join clone thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	ret = pthread_join(bufio_thread, NULL);
+	if (ret) {
+		fprintf(stderr, "join bufio thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	ret = pthread_join(directio_thread, NULL);
+	if (ret) {
+		fprintf(stderr, "join directio thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	printf("Program should have killed itself?\n");
+	outcome("program failed to end early");
+	return 0;
+}
diff --git a/tests/generic/1953 b/tests/generic/1953
new file mode 100755
index 0000000000..058538e6fe
--- /dev/null
+++ b/tests/generic/1953
@@ -0,0 +1,74 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 1953
+#
+# Race file reads with a very slow reflink operation to see if the reads
+# actually complete while the reflink is ongoing.  This is a functionality
+# test for XFS commit f3ba4762fa56 "xfs: allow read IO and FICLONE to run
+# concurrently".
+#
+. ./common/preamble
+_begin_fstest auto clone punch
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "fpunch"
+_require_test_program "punch-alternating"
+_require_test_program "t_reflink_read_race"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+mkdir "$testdir"
+
+calc_space() {
+	blocks_needed=$(( 2 ** (fnr + 1) ))
+	space_needed=$((blocks_needed * blksz * 5 / 4))
+}
+
+# Figure out the number of blocks that we need to get the reflink runtime above
+# 1 seconds
+echo "Create a many-block file"
+for ((fnr = 1; fnr < 40; fnr++)); do
+	free_blocks=$(stat -f -c '%a' "$testdir")
+	blksz=$(_get_file_block_size "$testdir")
+	space_avail=$((free_blocks * blksz))
+	calc_space
+	test $space_needed -gt $space_avail && \
+		_notrun "Insufficient space for stress test; would only create $blocks_needed extents."
+
+	off=$(( (2 ** fnr) * blksz))
+	$XFS_IO_PROG -f -c "pwrite -S 0x61 -b 4194304 $off $off" "$testdir/file1" >> "$seqres.full"
+	"$here/src/punch-alternating" "$testdir/file1" >> "$seqres.full"
+
+	timeout 1s cp --reflink=always "$testdir/file1" "$testdir/garbage" || break
+done
+echo "fnr=$fnr" >> $seqres.full
+
+echo "Reflink the big file"
+$here/src/t_reflink_read_race "$testdir/file1" "$testdir/file2" \
+	"$testdir/outcome" &>> $seqres.full
+
+if [ ! -e "$testdir/outcome" ]; then
+	echo "Could not set up program"
+elif grep -q "finished read early" "$testdir/outcome"; then
+	echo "test completed successfully"
+else
+	cat "$testdir/outcome"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1953.out b/tests/generic/1953.out
new file mode 100644
index 0000000000..8eaacb7ff0
--- /dev/null
+++ b/tests/generic/1953.out
@@ -0,0 +1,6 @@
+QA output created by 1953
+Format and mount
+Create a many-block file
+Reflink the big file
+Terminated
+test completed successfully
