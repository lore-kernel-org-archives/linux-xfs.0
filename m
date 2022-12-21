Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0385C46467
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 16:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiLUQ5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 11:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiLUQ5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 11:57:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5073C4;
        Wed, 21 Dec 2022 08:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 819B261857;
        Wed, 21 Dec 2022 16:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9972C433D2;
        Wed, 21 Dec 2022 16:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671641823;
        bh=I5azBKcXw+FkB6zYEZyUEqcS9DZe0v83Q1kSgPM33YA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pXoaMiqInh1micsNFzqZAq9vfa650BnNzgLwmc+YQBDhRLrCktVI1Bwi1ADBUzIb3
         DTnn8ywDX7twzL3kF4LdskWSD0umnu9aAoE7DndnxQ42yC+tc3TpfEphExkXcZRrPx
         /OoXPkUWeTskTlcZVaFBIwsp/R8WqZApbmF3HIjH/7FyYQpTydirkvbFL/sMzQlzdM
         iSD3QIHcpI4H+fBUWWB6HfFPIWejoCWrvlKaBkL3s02QJQNgEJCq4p7aU3llOHK16W
         xiF3Uy7gri4IxVl3OJFOgO5jpTcXi/MaLyuTFNPiyfNi/APrJX6axGkyg/zxww68dY
         6Oe6SICzAfBvw==
Date:   Wed, 21 Dec 2022 08:57:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v1.1 2/3] xfs: regression test for writes racing with reclaim
 writeback
Message-ID: <Y6M632A1x7l9m4HQ@magnolia>
References: <167158210534.235429.10062024114428012379.stgit@magnolia>
 <167158211644.235429.5374511574924758421.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167158211644.235429.5374511574924758421.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test uses the new write delay debug knobs to set up a slow-moving
write racing with writeback of an unwritten block at the end of the
file range targetted by the slow write.  The test succeeds if the file
does not end up corrupt and if the ftrace log captures a message about
the revalidation occurring.

NOTE: I'm not convinced that madvise actually causes the page to be
removed from the pagecache, which means that this is effectively a
functional test for the invalidation, not a corruption reproducer.
On the other hand, the functional test can be done quickly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: add regression annotations
---
 tests/xfs/925     |  126 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/925.out |    2 +
 2 files changed, 128 insertions(+)
 create mode 100755 tests/xfs/925
 create mode 100644 tests/xfs/925.out

diff --git a/tests/xfs/925 b/tests/xfs/925
new file mode 100755
index 0000000000..49d22019d3
--- /dev/null
+++ b/tests/xfs/925
@@ -0,0 +1,126 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 925
+#
+# This is a regression test for a data corruption bug that existed in iomap's
+# buffered write routines.
+#
+. ./common/preamble
+_begin_fstest auto quick rw
+
+# Import common functions.
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
+_require_ftrace
+_require_xfs_io_command "falloc"
+_require_xfs_io_error_injection "write_delay_ms"
+_require_scratch
+
+_fixed_by_kernel_commit 304a68b9c63b \
+	"xfs: use iomap_valid method to detect stale cached iomaps"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+# This is a pagecache test, so try to disable fsdax mode.
+$XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
+_require_pagecache_access $SCRATCH_MNT
+
+blocks=10
+blksz=$(get_page_size)
+filesz=$((blocks * blksz))
+dirty_offset=$(( filesz - 1 ))
+write_len=$(( ( (blocks - 1) * blksz) + 1 ))
+
+# Create a large file with a large unwritten range.
+$XFS_IO_PROG -f -c "falloc 0 $filesz" $SCRATCH_MNT/file >> $seqres.full
+
+# Write the same data to file.compare as we're about to do to file.  Do this
+# before slowing down writeback to avoid unnecessary delay.
+_pwrite_byte 0x58 $dirty_offset 1 $SCRATCH_MNT/file.compare >> $seqres.full
+_pwrite_byte 0x57 0 $write_len $SCRATCH_MNT/file.compare >> $seqres.full
+
+# Reinitialize the page cache for this file.
+_scratch_cycle_mount
+
+# Dirty the last page in the range and immediately set the write delay so that
+# any subsequent writes have to wait.
+$XFS_IO_PROG -c "pwrite -S 0x58 $dirty_offset 1" $SCRATCH_MNT/file >> $seqres.full
+_scratch_inject_error "write_delay_ms" 500
+
+_ftrace_setup
+_ftrace_record_events 'xfs_iomap_invalid'
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
+			_scratch_inject_error "write_delay_ms" 0
+			_ftrace_ignore_events
+			break;
+		fi
+		sleep 0.5
+	done
+}
+touch $sentryfile
+wait_for_errortag &
+
+# Start thread 1 + writeback above
+($XFS_IO_PROG -c "pwrite -S 0x57 -b $write_len 0 $write_len" \
+	$SCRATCH_MNT/file >> $seqres.full; rm -f $sentryfile) &
+sleep 1
+
+# Start thread 2 to simulate reclaim writeback via sync_file_range and fadvise
+# to drop the page cache.
+#	-c "fadvise -d $dirty_offset 1" \
+dirty_pageoff=$((filesz - blksz))
+$XFS_IO_PROG -c "sync_range -a -w $dirty_pageoff $blksz" \
+	-c "mmap -r 0 $filesz" \
+	-c "madvise -d 0 $filesz" \
+	$SCRATCH_MNT/file >> $seqres.full
+wait
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
+	echo "Expected to hear about write iomap invalidation?"
+fi
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/925.out b/tests/xfs/925.out
new file mode 100644
index 0000000000..95088ce8a5
--- /dev/null
+++ b/tests/xfs/925.out
@@ -0,0 +1,2 @@
+QA output created by 925
+Silence is golden
