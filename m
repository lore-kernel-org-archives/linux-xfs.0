Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9883C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 23:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95793610CB
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 23:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhHYXHv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 19:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhHYXHu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Aug 2021 19:07:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A049610C7;
        Wed, 25 Aug 2021 23:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629932824;
        bh=mGQ67LM4p4PgUFzhPHjFcZhbot55XXEW3sJuDLcJhaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eHJpSg+azAfs2VlTDFdqWfCfwcvE81PhfvPYU9ThzX3AB8oWT4FCvKEdRRW7fjHvH
         sLlOc271YxbcsTui6OAaJ2ShVUGrMnCMAXUoM+nEQrVwewdzSsvX5ZrkDqCfBausK9
         zQvMpDQA6UqVjXFFLTMBtbQrQ8siJbg2foG3DGUMayKrUOaNdhFoL6Fx5zMouXNfX6
         dDRvb6Tc5/cdTXEZagZGxvfY8WfVpfUkSLJ7cPGnu4eQJL06kzRXnA/Gzs2IEiuFqi
         bihBUib8NWQBf2DXWdT8cCl6hXZC64rOLAzg+9jJEWSATjsCFT75d9+/SD58N/UUZr
         t3BZjZmBI7VOA==
Date:   Wed, 25 Aug 2021 16:07:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>
Subject: [RFC PATCH] xfs: test DONTCACHE behavior with the inode cache
Message-ID: <20210825230703.GH12640@magnolia>
References: <20210824023208.392670-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824023208.392670-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Basic testing that DONTCACHE affects the XFS inode cache in the manner
that we expect.  The only way we can do that (for XFS, anyway) is to
play around with the BULKSTAT ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/780     |  293 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/780.out |    7 +
 2 files changed, 300 insertions(+)
 create mode 100755 tests/xfs/780
 create mode 100644 tests/xfs/780.out

diff --git a/tests/xfs/780 b/tests/xfs/780
new file mode 100755
index 00000000..9bf1f482
--- /dev/null
+++ b/tests/xfs/780
@@ -0,0 +1,293 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test 780
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
+# so we're stuck with setting xfssyncd_centisecs to a low value and watching
+# the slab counters.
+#
+. ./common/preamble
+_begin_fstest auto ioctl
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	test -n "$junkdir" && rm -r -f "$junkdir"
+	test -n "$old_centisecs" && echo "$old_centisecs" > "$xfs_centisecs_file"
+}
+
+# Import common functions.
+# . ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_test
+
+# Either of these need to be available to monitor slab usage
+xfs_ino_objcount_file=/sys/kernel/slab/xfs_inode/objects
+slabinfo_file=/proc/slabinfo
+if [ ! -r "$xfs_ino_objcount_file" ] && [ ! -r "$slabinfo_file" ]; then
+	_notrun "Cannot find xfs_inode slab count?"
+fi
+
+# Background reclamation of disused xfs inodes is scheduled for $xfssyncd
+# centiseconds after the first inode is tagged for reclamation.  It's not great
+# to encode this implementation detail in a test like this, but there isn't
+# any means to trigger *only* inode cache reclaim -- actual memory pressure
+# can trigger the VFS to drop non-DONTCACHE inodes, which is not what we want.
+xfs_centisecs_file=/proc/sys/fs/xfs/xfssyncd_centisecs
+test -w "$xfs_centisecs_file" || _notrun "Cannot find xfssyncd_centisecs?"
+
+# Set the syncd knob to the minimum value 100cs (aka 1s) 
+old_centisecs="$(cat "$xfs_centisecs_file")"
+echo 100 > "$xfs_centisecs_file" || _notrun "Cannot adjust xfssyncd_centisecs?"
+delay_centisecs="$(cat "$xfs_centisecs_file")"
+
+# Sleep one second more than the xfssyncd delay to give background inode
+# reclaim enough time to run.
+sleep_seconds=$(( ( (99 + delay_centisecs) / 100) + 1))
+
+count_xfs_inode_objs() {
+	if [ -r "$xfs_ino_objcount_file" ]; then
+		cat "$xfs_ino_objcount_file" | cut -d ' ' -f 1
+	elif [ -r "$slabinfo_file" ]; then
+		grep -w '^xfs_inode' "$slabinfo_file" | awk '{print $2}'
+	else
+		echo "ERROR"
+	fi
+}
+
+junkdir=$TEST_DIR/$seq.junk
+nr_cpus=$(getconf _NPROCESSORS_ONLN)
+
+# Sample the baseline count of cached inodes after a fresh remount.
+_test_cycle_mount
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
+test "$new_files" -gt "$nr_files" || \
+	echo "created $new_files files, expected $nr_files"
+
+# Sanity check: Make sure that all those new inodes are still in the cache.
+# We assume that memory limits are not so low that reclaim started for a bunch
+# of empty files.
+work_count=$(count_xfs_inode_objs)
+test "$work_count" -ge "$new_files" || \
+	echo "found $work_count cached inodes after creating $new_files files?"
+
+# Round 1: Check the DONTCACHE behavior when it is invoked once per inode.
+# The inodes should be reclaimed if we wait long enough.
+echo "Round 1"
+
+# Sample again to see if we're still within the baseline.
+_test_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+
+# Run bulkstat to exercise DONTCACHE behavior, and sample again.
+$here/src/bstat -q $junkdir
+post_count=$(count_xfs_inode_objs)
+
+# Let background reclaim run
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+
+# Even with our greatly reduced syncd value, the inodes should still be in
+# memory immediately after the second bulkstat concludes.
+test "$post_count" -ge "$new_files" || \
+	echo "found $post_count cached inodes after bulkstat $new_files files?"
+
+# After we've let memory reclaim run, the inodes should no longer be cached
+# in memory.
+test "$end_count" -le "$new_files" || \
+	echo "found $end_count cached inodes after letting $new_files DONTCACHE files expire?"
+
+# Dump full results for debugging
+cat >> $seqres.full << ENDL
+round1 baseline: $baseline_count
+work: $work_count
+fresh: $fresh_count
+post: $post_count
+end: $end_count
+ENDL
+
+# Round 2: Check the DONTCACHE behavior when it is invoked multiple times per
+# inode in rapid succession.  The inodes should remain in memory even after
+# reclaim because the cache gets wise to repeated scans.
+echo "Round 2"
+
+# Sample again to see if we're still within the baseline.
+_test_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+
+# Run bulkstat twice in rapid succession to exercise DONTCACHE behavior.
+# The first bulkstat run will bring the inodes into memory (marked DONTCACHE).
+# The second bulkstat causes cache hits before the inodes can reclaimed, which
+# means that they should stay in memory.  Sample again afterwards.
+$here/src/bstat -q $junkdir
+$here/src/bstat -q $junkdir
+post_count=$(count_xfs_inode_objs)
+
+# Let background reclaim run
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+
+# Even with our greatly reduced syncd value, the inodes should still be in
+# memory immediately after the second bulkstat concludes.
+test "$post_count" -ge "$new_files" || \
+	echo "found $post_count cached inodes after bulkstat $new_files files?"
+
+# After we've let memory reclaim run and cache hits happen, the inodes should
+# still be cached in memory.
+test "$end_count" -ge "$new_files" || \
+	echo "found $end_count cached inodes after letting $new_files DONTCACHE files expire?"
+
+# Dump full results for debugging
+cat >> $seqres.full << ENDL
+round2 baseline: $baseline_count
+work: $work_count
+fresh: $fresh_count
+post: $post_count
+end: $end_count
+ENDL
+
+# Round 3: Check that DONTCACHE results in inode evictions when it is invoked
+# multiple times per inode but there's enough time between each bulkstat for
+# reclaim to kill the inodes.
+echo "Round 3"
+
+# Sample again to see if we're still within the baseline.
+_test_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+
+# Run bulkstat twice in slow succession to exercise DONTCACHE behavior.
+# The first bulkstat run will bring the inodes into memory (marked DONTCACHE).
+# Pause long enough for reclaim to tear down the inodes so that the second
+# bulkstat brings them back into memory (again marked DONTCACHE).
+# Sample again afterwards.
+$here/src/bstat -q $junkdir
+sleep $sleep_seconds
+post_count=$(count_xfs_inode_objs)
+
+$here/src/bstat -q $junkdir
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+
+# Even with our greatly reduced syncd value, the inodes should still be in
+# memory immediately after the second bulkstat concludes.
+test "$post_count" -le "$new_files" || \
+	echo "found $post_count cached inodes after bulkstat $new_files files?"
+
+# After we've let memory reclaim run, the inodes should no longer be cached
+# in memory.
+test "$end_count" -le "$new_files" || \
+	echo "found $end_count cached inodes after letting $new_files DONTCACHE files expire?"
+
+# Dump full results for debugging
+cat >> $seqres.full << ENDL
+round3 baseline: $baseline_count
+work: $work_count
+fresh: $fresh_count
+post: $post_count
+end: $end_count
+ENDL
+
+# Round 4: Check that DONTCACHE doesn't do much when all the files are accessed
+# immediately after a bulkstat.
+echo "Round 4"
+
+# Sample again to see if we're still within the baseline.
+_test_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+
+# Run bulkstat and then cat every file in the junkdir so that the new inode
+# grabs will clear DONTCACHE off the inodes.  Sample again afterwards.
+$here/src/bstat -q $junkdir
+find $junkdir -type f -print0 | xargs -0 cat
+post_count=$(count_xfs_inode_objs)
+
+# Let background reclaim run
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+
+# Even with our greatly reduced syncd value, the inodes should still be in
+# memory immediately after the second bulkstat concludes.
+test "$post_count" -ge "$new_files" || \
+	echo "found $post_count cached inodes after bulkstat $new_files files?"
+
+# After we've let memory reclaim run, the inodes should stll be cached in
+# memory because we opened everything.
+test "$end_count" -ge "$new_files" || \
+	echo "found $end_count cached inodes after letting $new_files DONTCACHE files expire?"
+
+# Dump full results for debugging
+cat >> $seqres.full << ENDL
+round4 baseline: $baseline_count
+work: $work_count
+fresh: $fresh_count
+post: $post_count
+end: $end_count
+ENDL
+
+# Round 5: Check that DONTCACHE has no effect if the inodes were already in
+# cache due to reader programs.
+echo "Round 5"
+
+# Sample again to see if we're still within the baseline.
+_test_cycle_mount
+fresh_count=$(count_xfs_inode_objs)
+
+# cat every file in the junkdir and then run BULKSTAT so that the DONTCACHE
+# flags passed to iget by bulkstat will be ignored for already-cached inodes.
+# Sample again afterwards.
+find $junkdir -type f -print0 | xargs -0 cat
+$here/src/bstat -q $junkdir
+post_count=$(count_xfs_inode_objs)
+
+# Let background reclaim run
+sleep $sleep_seconds
+end_count=$(count_xfs_inode_objs)
+
+# Even with our greatly reduced syncd value, the inodes should still be in
+# memory immediately after the second bulkstat concludes.
+test "$post_count" -ge "$new_files" || \
+	echo "found $post_count cached inodes after bulkstat $new_files files?"
+
+# After we've let memory reclaim run, the inodes should stll be cached in
+# memory because we opened everything.
+test "$end_count" -ge "$new_files" || \
+	echo "found $end_count cached inodes after letting $new_files DONTCACHE files expire?"
+
+# Dump full results for debugging
+cat >> $seqres.full << ENDL
+round5 baseline: $baseline_count
+work: $work_count
+fresh: $fresh_count
+post: $post_count
+end: $end_count
+ENDL
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/780.out b/tests/xfs/780.out
new file mode 100644
index 00000000..7366678c
--- /dev/null
+++ b/tests/xfs/780.out
@@ -0,0 +1,7 @@
+QA output created by 780
+Round 1
+Round 2
+Round 3
+Round 4
+Round 5
+Silence is golden
