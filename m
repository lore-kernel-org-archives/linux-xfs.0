Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F1FC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 00:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiLUAWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 19:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiLUAVx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 19:21:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E73B5FD8;
        Tue, 20 Dec 2022 16:21:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD7B261628;
        Wed, 21 Dec 2022 00:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FF9C433F1;
        Wed, 21 Dec 2022 00:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671582111;
        bh=rrfa3+25HWCv42IVb5IaQAiUZtc8ys8S3hn6U1mc8Os=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZrqMhzEX/BDMhGLaMKcNM8mbrhLvPArR+7f5UAfOvdPbHdFMsv96JAyKLdRv03Mfr
         Ry6nFi2dEXdBr6zl+JFVf05tiQU09+kUKUWtrcLGXfnbJLcy2HJm3qUwb9Wb5m7RfI
         hkKO0NRRYMH0EA+oDIiPy6C558OlMuJLpNY3ugArDzUQe/Cdj3U+0q5/94zX/TK3/t
         rSUXjLBJXNfOeeqqgLRepC7MeGvcZKh9eD9WpqA7Ck6DZAvixkrifEKcNQxCwS4LvZ
         YzXzCQzxK4wSGCoFfDh+36ACICS8vSmthD6M1OHNlXBiBJm+9f+v3w7syiu/aICF0D
         b2yoASbyuy3sw==
Subject: [PATCH 1/3] xfs: regression test for writeback corruption bug
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Dec 2022 16:21:50 -0800
Message-ID: <167158211088.235429.4011792826230027022.stgit@magnolia>
In-Reply-To: <167158210534.235429.10062024114428012379.stgit@magnolia>
References: <167158210534.235429.10062024114428012379.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for a data corruption bug that existed in XFS'
copy on write code between 4.9 and 4.19.  The root cause is a
concurrency bug wherein we would drop ILOCK_SHARED after querying the
CoW fork in xfs_map_cow and retake it before querying the data fork in
xfs_map_blocks.  See the test description for a lot more details.

Cc: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   15 ++++
 common/tracing    |   66 +++++++++++++++++
 tests/xfs/924     |  210 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/924.out |    2 +
 4 files changed, 293 insertions(+)
 create mode 100644 common/tracing
 create mode 100755 tests/xfs/924
 create mode 100644 tests/xfs/924.out


diff --git a/common/rc b/common/rc
index 67bd74dc89..cac207e6b4 100644
--- a/common/rc
+++ b/common/rc
@@ -3604,6 +3604,21 @@ _check_xflag()
 	fi
 }
 
+# Make sure the given file access mode is set to use the pagecache.  If
+# userspace or kernel don't support statx or STATX_ATTR_DAX, we assume that
+# means pagecache.  The sole parameter must be a directory.
+_require_pagecache_access() {
+	local testfile="$1/testfile"
+
+	touch "$testfile"
+	if ! _check_s_dax "$testfile" 0 &>> $seqres.full; then
+		rm -f "$testfile"
+		_notrun 'test requires pagecache access'
+	fi
+
+	rm -f "$testfile"
+}
+
 # Check if dax mount options are supported
 #
 # $1 can be either 'dax=always' or 'dax'
diff --git a/common/tracing b/common/tracing
new file mode 100644
index 0000000000..b3051c27a7
--- /dev/null
+++ b/common/tracing
@@ -0,0 +1,66 @@
+##/bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# Routines for dealing with ftrace (or any other tracing).
+
+FTRACE_INSTANCES_DIR="/sys/kernel/debug/tracing/instances/"
+
+_require_ftrace() {
+	test -d "$FTRACE_INSTANCES_DIR" || \
+		_notrun "kernel does not support ftrace"
+}
+
+_ftrace_cleanup() {
+	if [ -d "$FTRACE_DIR" ]; then
+		_ftrace_ignore_events
+		# Removing an ftrace buffer requires rmdir, even though the
+		# virtual directory contains children.
+		rmdir "$FTRACE_DIR"
+	fi
+}
+
+_ftrace_setup() {
+	test -n "$FTRACE_DIR" && _fail "_ftrace_setup already run?"
+
+	# Give this fstest its own ftrace buffer so that we don't mess up
+	# any other tracers that might be running.
+	FTRACE_DIR="$FTRACE_INSTANCES_DIR/fstests.$seq"
+
+	test -d "$FTRACE_DIR" && rmdir "$FTRACE_DIR"
+	mkdir "$FTRACE_DIR"
+}
+
+# Intercept the given events.  Arguments may be regular expressions.
+_ftrace_record_events() {
+	test -d "$FTRACE_DIR" || _fail "_ftrace_setup not run?"
+
+	for arg in "$@"; do
+		# Replace slashes with semicolons per ftrace convention
+		find "$FTRACE_DIR/events/" -type d -name "$arg" -printf '%P\n' | \
+			tr '/' ':' >> "$FTRACE_DIR/set_event"
+	done
+}
+
+# Stop intercepting the given events.  If no arguments, stops all events.
+_ftrace_ignore_events() {
+	test -d "$FTRACE_DIR" || _fail "_ftrace_setup not run?"
+
+	if [ "$#" -eq 0 ]; then
+		echo > "$FTRACE_DIR/set_event"
+	else
+		for arg in "$@"; do
+			# Replace slashes with semicolons per ftrace convention
+			find "$FTRACE_DIR/events/" -type d -name "$arg" -printf '!%P\n' | \
+				tr '/' ':' >> "$FTRACE_DIR/set_event"
+		done
+	fi
+}
+
+# Dump whatever was written to the ftrace buffer since the last time this
+# helper was called.
+_ftrace_dump() {
+	test -d "$FTRACE_DIR" || _fail "_ftrace_setup not run?"
+
+	cat "$FTRACE_DIR/trace"
+}
diff --git a/tests/xfs/924 b/tests/xfs/924
new file mode 100755
index 0000000000..ce566c9259
--- /dev/null
+++ b/tests/xfs/924
@@ -0,0 +1,210 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 924
+#
+# This is a regression test for a data corruption bug that existed in XFS' copy
+# on write code between 4.9 and 4.19.  The root cause is a concurrency bug
+# wherein we would drop ILOCK_SHARED after querying the CoW fork in xfs_map_cow
+# and retake it before querying the data fork in xfs_map_blocks.  If a second
+# thread changes the CoW fork mappings between the two calls, it's possible for
+# xfs_map_blocks to return a zero-block mapping, which results in writeback
+# being elided for that block.  Elided writeback of dirty data results in
+# silent loss of writes.
+#
+# Worse yet, kernels from that era still used buffer heads, which means that an
+# elided writeback leaves the page clean but the bufferheads dirty.  Due to a
+# naïve optimization in mark_buffer_dirty, the SetPageDirty call is elided if
+# the bufferhead is dirty, which means that a subsequent rewrite of the data
+# block will never result in the page being marked dirty, and all subsequent
+# writes are lost.
+#
+# It turns out that Christoph Hellwig unwittingly fixed the race in commit
+# 5c665e5b5af6 ("xfs: remove xfs_map_cow"), and no testcase was ever written.
+# Four years later, we hit it on a production 4.14 kernel.  This testcase
+# relies on a debugging knob that introduces artificial delays into writeback.
+#
+# Before the race, the file blocks 0-1 are not shared and blocks 2-5 are
+# shared.  There are no extents in CoW fork.
+#
+# Two threads race like this:
+#
+# Thread 1 (writeback block 0)     | Thread 2  (write to block 2)
+# ---------------------------------|--------------------------------
+#                                  |
+# 1. Check if block 0 in CoW fork  |
+#    from xfs_map_cow.             |
+#                                  |
+# 2. Block 0 not found in CoW      |
+#    fork; the block is considered |
+#    not shared.                   |
+#                                  |
+# 3. xfs_map_blocks looks up data  |
+#    fork to get a map covering    |
+#    block 0.                      |
+#                                  |
+# 4. It gets a data fork mapping   |
+#    for block 0 with length 2.    |
+#                                  |
+#                                  | 1. A buffered write to block 2 sees
+#                                  |    that it is a shared block and no
+#                                  |    extent covers block 2 in CoW fork.
+#                                  |
+#                                  |    It creates a new CoW fork mapping.
+#                                  |    Due to the cowextsize, the new
+#                                  |    extent starts at block 0 with
+#                                  |    length 128.
+#                                  |
+#                                  |
+# 5. It lookup CoW fork again to   |
+#    trim the map (0, 2) to a      |
+#    shared block boundary.        |
+#                                  |
+# 5a. It finds (0, 128) in CoW fork|
+# 5b. It trims the data fork map   |
+#     from (0, 1) to (0, 0) (!!!)  |
+#                                  |
+# 6. The xfs_imap_valid call after |
+#    the xfs_map_blocks call checks|
+#    if the mapping (0, 0) covers  |
+#    block 0.  The result is "NO". |
+#                                  |
+# 7. Since block 0 has no physical |
+#    block mapped, it's not added  |
+#    to the ioend.  This is the    |
+#    first problem.                |
+#                                  |
+# 8. xfs_add_to_ioend usually      |
+#    clears the bufferhead dirty   |
+#    flag  Because this is skipped,|
+#    we leave the page clean with  |
+#    the associated buffer head(s) |
+#    dirty (the second problem).   |
+#    Now the dirty state is        |
+#    inconsistent.
+#
+# On newer kernels, this is also a functionality test for the ifork sequence
+# counter because the writeback completions will change the data fork and force
+# revalidations of the wb mapping.
+#
+. ./common/preamble
+_begin_fstest auto quick clone
+
+# Import common functions.
+. ./common/reflink
+. ./common/inject
+. ./common/tracing
+
+# real QA test starts here
+_cleanup()
+{
+	test -n "$sentryfile" && rm -f $sentryfile
+	wait
+	_ftrace_cleanup
+	cd /
+	rm -r -f $tmp.* $sentryfile $tracefile
+}
+
+# Modify as appropriate.
+_supported_fs xfs
+_fixed_by_kernel_commit 5c665e5b5af6 "xfs: remove xfs_map_cow"
+_require_ftrace
+_require_xfs_io_error_injection "wb_delay_ms"
+_require_scratch_reflink
+_require_cp_reflink
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+# This is a pagecache test, so try to disable fsdax mode.
+$XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
+_require_pagecache_access $SCRATCH_MNT
+
+blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
+
+# Make sure we have sufficient extent size to create speculative CoW
+# preallocations.
+$XFS_IO_PROG -c 'cowextsize 1m' $SCRATCH_MNT
+
+# Write out a file with the first two blocks unshared and the rest shared.
+_pwrite_byte 0x59 0 $((160 * blksz)) $SCRATCH_MNT/file >> $seqres.full
+_pwrite_byte 0x59 0 $((160 * blksz)) $SCRATCH_MNT/file.compare >> $seqres.full
+sync
+
+_cp_reflink $SCRATCH_MNT/file $SCRATCH_MNT/file.reflink
+
+_pwrite_byte 0x58 0 $((2 * blksz)) $SCRATCH_MNT/file >> $seqres.full
+_pwrite_byte 0x58 0 $((2 * blksz)) $SCRATCH_MNT/file.compare >> $seqres.full
+sync
+
+# Avoid creation of large folios on newer kernels by cycling the mount and
+# immediately writing to the page cache.
+_scratch_cycle_mount
+
+# Write the same data to file.compare as we're about to do to file.  Do this
+# before slowing down writeback to avoid unnecessary delay.
+_pwrite_byte 0x57 0 $((2 * blksz)) $SCRATCH_MNT/file.compare >> $seqres.full
+_pwrite_byte 0x56 $((2 * blksz)) $((2 * blksz)) $SCRATCH_MNT/file.compare >> $seqres.full
+sync
+
+# Introduce a half-second wait to each writeback block mapping call.  This
+# gives us a chance to race speculative cow prealloc with writeback.
+_scratch_inject_error "wb_delay_ms" 500
+
+_ftrace_setup
+_ftrace_record_events 'xfs_wb*iomap_invalid'
+
+# Start thread 1 + writeback above
+$XFS_IO_PROG -c "pwrite -S 0x57 0 $((2 * blksz))" \
+	-c 'fsync' $SCRATCH_MNT/file >> $seqres.full &
+sleep 1
+
+# Start a sentry to look for evidence of invalidation tracepoint tripping.  If
+# we see that, we know we've forced writeback to revalidate a mapping.  The
+# test has been successful, so turn off the delay.
+sentryfile=$TEST_DIR/$seq.sentry
+tracefile=$TEST_DIR/$seq.ftrace
+wait_for_errortag() {
+	while [ -e "$sentryfile" ]; do
+		_ftrace_dump | grep iomap_invalid >> "$tracefile"
+		if grep -q iomap_invalid "$tracefile"; then
+			_scratch_inject_error "wb_delay_ms" 0
+			_ftrace_ignore_events
+			break;
+		fi
+		sleep 0.5
+	done
+}
+touch $sentryfile
+wait_for_errortag &
+
+# Start thread 2 to create the cowextsize reservation
+$XFS_IO_PROG -c "pwrite -S 0x56 $((2 * blksz)) $((2 * blksz))" \
+	-c 'fsync' $SCRATCH_MNT/file >> $seqres.full
+rm -f $sentryfile
+
+cat "$tracefile" >> $seqres.full
+grep -q iomap_invalid "$tracefile"
+saw_invalidation=$?
+
+# Flush everything to disk.  If the bug manifests, then after the cycle,
+# file should have stale 0x58 in block 0 because we silently dropped a write.
+_scratch_cycle_mount
+
+if ! cmp -s $SCRATCH_MNT/file $SCRATCH_MNT/file.compare; then
+	echo file and file.compare do not match
+	$XFS_IO_PROG -c 'bmap -celpv' -c 'bmap -elpv' $SCRATCH_MNT/file &>> $seqres.full
+	echo file.compare
+	od -tx1 -Ad -c $SCRATCH_MNT/file.compare
+	echo file
+	od -tx1 -Ad -c $SCRATCH_MNT/file
+elif [ $saw_invalidation -ne 0 ]; then
+	# The files matched, but nothing got logged about the revalidation?
+	echo "Expected to hear about writeback iomap invalidations?"
+fi
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/924.out b/tests/xfs/924.out
new file mode 100644
index 0000000000..c6655da35a
--- /dev/null
+++ b/tests/xfs/924.out
@@ -0,0 +1,2 @@
+QA output created by 924
+Silence is golden

