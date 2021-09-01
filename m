Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12FBC432BE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B871C6103D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbhIAANM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243032AbhIAANL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:13:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5EBF6102A;
        Wed,  1 Sep 2021 00:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455135;
        bh=QrtU3Mmuurv59xszpKCvdnx28JEIHpgcpqNtSr4GS/U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P4Q+saUCCeQsS4A7PfytpoiXqTtkvXbSkk0mF52CWU55xq3X1HHt6knp6FZeK59Zw
         sBIeS6miskrD8Dcu6o9dVMbYu4KQIzTuv5DX1y3lgUQ14EM4osOoaOtMjFV+kDXeuR
         UGeK2oa0CMUGQLz3Aa0EDZLnQVQji6Qwu2v9Cru4szcpnFe0e5GDa+4abSNSk8sVu8
         dnLvqaxg5GXYJjyfdaTlUIQXpegbvl4u+UMImbQeZe7F7p4fvgM4NbZIL0cJijtF7b
         OeFihUEjZNLGreXV6GdLuZwN9ccC7qeYtsgsLpA42CujIcQYw+Owv3Js0OnpLlyn0l
         TxQ/tRhoF45sQ==
Subject: [PATCH 2/4] xfs: test DONTCACHE behavior with the inode cache
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:15 -0700
Message-ID: <163045513546.771394.2538376698194727593.stgit@magnolia>
In-Reply-To: <163045512451.771394.12554760323831932499.stgit@magnolia>
References: <163045512451.771394.12554760323831932499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Basic testing that DONTCACHE affects the XFS inode cache in the manner
that we expect.  The only way we can do that (for XFS, anyway) is to
play around with the BULKSTAT ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/780     |  207 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/780.out |   18 +++++
 2 files changed, 225 insertions(+)
 create mode 100755 tests/xfs/780
 create mode 100644 tests/xfs/780.out


diff --git a/tests/xfs/780 b/tests/xfs/780
new file mode 100755
index 00000000..464692ee
--- /dev/null
+++ b/tests/xfs/780
@@ -0,0 +1,207 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test 780
+#
+# Functional test for commit:
+#
+# f38a032b165d ("xfs: fix I_DONTCACHE")
+#
+# Functional testing for the I_DONTCACHE inode flag, as set by the BULKSTAT
+# ioctl.  This flag neuters the inode cache's tendency to try to hang on to
+# incore inodes for a while after the last program closes the file, which
+# is helpful for filesystem scanners to avoid trashing the inode cache.
+#
+# However, the inode cache doesn't always honor the DONTCACHE behavior -- the
+# only time it really applies is to cache misses from a bulkstat scan.  If
+# any other threads accessed the inode before or immediately after the scan,
+# the DONTCACHE flag is ignored.  This includes other scans.
+#
+# Regrettably, there is no way to poke /only/ XFS inode reclamation directly,
+# so we're stuck with setting xfssyncd_centisecs to a low value and sleeping
+# while watching the internal inode cache counters.
+#
+. ./common/preamble
+_begin_fstest auto ioctl
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	test -n "$old_centisecs" && echo "$old_centisecs" > "$xfs_centisecs_file"
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_io_command "bulkstat"
+_require_scratch
+
+# We require /sys/fs/xfs/$device/stats/stats to monitor per-filesystem inode
+# cache usage.
+_require_fs_sysfs stats/stats
+
+count_xfs_inode_objs() {
+	_get_fs_sysfs_attr $SCRATCH_DEV stats/stats | awk '/vnodes/ {print $2}'
+}
+
+dump_debug_info() {
+	echo "round $1 baseline: $baseline_count high: $high_count fresh: $fresh_count post: $post_count end: $end_count" >> $seqres.full
+}
+
+# Either of these need to be available to monitor slab usage
+xfs_ino_objcount_file=/sys/kernel/slab/xfs_inode/objects
+slabinfo_file=/proc/slabinfo
+if [ ! -r "$xfs_ino_objcount_file" ] && [ ! -r "$slabinfo_file" ]; then
+	_notrun "Cannot find xfs_inode slab count?"
+fi
+
+# Background reclamation of disused xfs inodes is scheduled for ($xfssyncd / 6)
+# centiseconds after the first inode is tagged for reclamation.  It's not great
+# to encode this implementation detail in a test like this, but there isn't
+# any means to trigger *only* inode cache reclaim -- actual memory pressure
+# can trigger the VFS to drop non-DONTCACHE inodes, which is not what we want.
+xfs_centisecs_file=/proc/sys/fs/xfs/xfssyncd_centisecs
+test -w "$xfs_centisecs_file" || _notrun "Cannot find xfssyncd_centisecs?"
+
+# Set the syncd knob to the minimum value 100cs (aka 1s) so that we don't have
+# to wait forever.
+old_centisecs="$(cat "$xfs_centisecs_file")"
+echo 100 > "$xfs_centisecs_file" || _notrun "Cannot adjust xfssyncd_centisecs?"
+delay_centisecs="$(cat "$xfs_centisecs_file")"
+
+# Sleep one second more than the xfssyncd delay to give background inode
+# reclaim enough time to run.
+sleep_seconds=$(( ( (99 + (delay_centisecs / 6) ) / 100) + 1))
+echo "Will sleep $sleep_seconds seconds to expire inodes" >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+junkdir=$SCRATCH_MNT/$seq.junk
+
+# Sample the baseline count of cached inodes after a fresh remount.
+_scratch_cycle_mount
+baseline_count=$(count_xfs_inode_objs)
+
+# Create a junk directory with about a thousand files.
+nr_files=1024
+mkdir -p $junkdir
+for ((i = 0; i < nr_files; i++)); do
+	touch "$junkdir/$i"
+done
+new_files=$(find $junkdir | wc -l)
+echo "created $new_files files" >> $seqres.full
+_within_tolerance "new file count" $new_files $nr_files 5 -v
+
+# Sanity check: Make sure that all those new inodes are still in the cache.
+# We assume that memory limits are not so low that reclaim started for a bunch
+# of empty files.  We hope there will never be more than 100 metadata inodes
+# or automatic mount time scanners.
+high_count=$(count_xfs_inode_objs)
+echo "cached inodes: $high_count" >> $seqres.full
+_within_tolerance "inodes after creating files" $high_count $new_files 0 100 -v
+
+################
+# Round 1: Check DONTCACHE behavior when it is invoked once.  The inodes should
+# be reclaimed if we wait longer than the reclaim interval.
+echo "Round 1"
+
+_scratch_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+$XFS_IO_PROG -c 'bulkstat' $junkdir > /dev/null
+post_count=$(count_xfs_inode_objs)
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+dump_debug_info 1
+
+# Even with our greatly reduced reclaim timeout, the inodes should still be in
+# memory immediately after the bulkstat concludes.
+_within_tolerance "inodes after bulkstat" $post_count $high_count 5 -v
+
+# After we've given inode reclaim time to run, the inodes should no longer be
+# cached in memory, which means we should have the fresh count again.
+_within_tolerance "inodes after expire" $end_count $fresh_count 5 -v
+
+################
+# Round 2: Check DONTCACHE behavior when it is invoked multiple times in rapid
+# succession.  The inodes should remain in memory even after reclaim because
+# the cache notices repeat DONTCACHE hits and ignores them.
+echo "Round 2"
+
+_scratch_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+$XFS_IO_PROG -c 'bulkstat' $junkdir > /dev/null
+$XFS_IO_PROG -c 'bulkstat' $junkdir > /dev/null
+post_count=$(count_xfs_inode_objs)
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+dump_debug_info 2
+
+# Inodes should still be in memory immediately after the second bulkstat
+# concludes and after the reclaim interval.
+_within_tolerance "inodes after double bulkstat" $post_count $high_count 5 -v
+_within_tolerance "inodes after expire" $end_count $high_count 5 -v
+
+################
+# Round 3: Check DONTCACHE evictions when it is invoked repeatedly but with
+# enough time between scans for inode reclaim to remove the inodes.
+echo "Round 3"
+
+_scratch_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+$XFS_IO_PROG -c 'bulkstat' $junkdir > /dev/null
+sleep $sleep_seconds
+post_count=$(count_xfs_inode_objs)
+$XFS_IO_PROG -c 'bulkstat' $junkdir > /dev/null
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+dump_debug_info 3
+
+# Inodes should not still be cached after either scan and reclaim interval.
+_within_tolerance "inodes after slow bulkstat 1" $post_count $fresh_count 5 -v
+_within_tolerance "inodes after slow bulkstat 2" $end_count $fresh_count 5 -v
+
+################
+# Round 4: Check that DONTCACHE has no effect when all the files are read
+# immediately after a bulkstat.
+echo "Round 4"
+
+_scratch_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+$XFS_IO_PROG -c 'bulkstat' $junkdir > /dev/null
+find $junkdir -type f -print0 | xargs -0 cat > /dev/null
+post_count=$(count_xfs_inode_objs)
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+dump_debug_info 4
+
+# Inodes should still be cached after the scan/read and the reclaim interval.
+_within_tolerance "inodes after bulkstat/read" $post_count $high_count 5 -v
+_within_tolerance "inodes after reclaim" $end_count $high_count 5 -v
+
+################
+# Round 5: Check that DONTCACHE has no effect if the inodes were already in
+# cache due to reader programs.
+echo "Round 5"
+
+_scratch_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+find $junkdir -type f -print0 | xargs -0 cat > /dev/null
+$XFS_IO_PROG -c 'bulkstat' $junkdir > /dev/null
+post_count=$(count_xfs_inode_objs)
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+dump_debug_info 5
+
+# Inodes should still be cached after the read/scan and the reclaim interval.
+_within_tolerance "inodes after read/bulkstat" $post_count $high_count 5 -v
+_within_tolerance "inodes after reclaim" $end_count $high_count 5 -v
+
+status=0
+exit
diff --git a/tests/xfs/780.out b/tests/xfs/780.out
new file mode 100644
index 00000000..879c473e
--- /dev/null
+++ b/tests/xfs/780.out
@@ -0,0 +1,18 @@
+QA output created by 780
+new file count is in range
+inodes after creating files is in range
+Round 1
+inodes after bulkstat is in range
+inodes after expire is in range
+Round 2
+inodes after double bulkstat is in range
+inodes after expire is in range
+Round 3
+inodes after slow bulkstat 1 is in range
+inodes after slow bulkstat 2 is in range
+Round 4
+inodes after bulkstat/read is in range
+inodes after reclaim is in range
+Round 5
+inodes after read/bulkstat is in range
+inodes after reclaim is in range

