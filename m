Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFCAC43462
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7778D613BD
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348971AbhDNBF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346526AbhDNBF5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 454E0613B6;
        Wed, 14 Apr 2021 01:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362337;
        bh=yi2sIIAdHGYO7jAOn7QMDfr/qz0fJkGM1bFi4BhLJMo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cBzZSlUCINxRqJGD0KSWBmBzazBw6sVMc3ZTX5nh8RzAW9tOB4NXKEORugTYcCj3Z
         zBWZqV8YPU0l+CtRRSolbSS3Y03RGKVQFt7rbFZLiLzBZ0c+J+sadmYRdySliPgGzm
         0f/eEs5hctBgvMaglfZdeeRb2ozOGVVMk46RlUxf6Jf0wEDR0wRt2Zh74MOkoNRMaN
         bbVxPOZYuc4ZjAWd/DIaKRWtHNUF3JtO5sUBEwQ0otlP7njlx8P5Fan2rDZHol6BVC
         Hh77J+BlaIbtY7FvTptQxl661KEpGpqXoAC5ZQxSnnYlpoNBEPp7KiEsyEJOjxQOLy
         F/4ge6dipszXA==
Subject: [PATCH 1/1] xfs: test that the needsrepair feature works as
 advertised
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:05:36 -0700
Message-ID: <161836233652.2755262.563331015931843615.stgit@magnolia>
In-Reply-To: <161836233058.2755262.72157999681408577.stgit@magnolia>
References: <161836233058.2755262.72157999681408577.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the needsrepair feature flag can be cleared only by
repair and that mounts are prohibited when the feature is set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs        |   21 ++++++++++++++
 tests/xfs/768     |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/768.out |    4 +++
 tests/xfs/770     |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/770.out |    2 +
 tests/xfs/group   |    2 +
 6 files changed, 191 insertions(+)
 create mode 100755 tests/xfs/768
 create mode 100644 tests/xfs/768.out
 create mode 100755 tests/xfs/770
 create mode 100644 tests/xfs/770.out


diff --git a/common/xfs b/common/xfs
index 887bd001..fa204663 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1114,3 +1114,24 @@ _xfs_get_cowgc_interval() {
 		_fail "Can't find cowgc interval procfs knob?"
 	fi
 }
+
+# Print the status of the given features on the scratch filesystem.
+# Returns 0 if all features are found, 1 otherwise.
+_check_scratch_xfs_features()
+{
+	local features="$(_scratch_xfs_db -c 'version')"
+	local output=("FEATURES:")
+	local found=0
+
+	for feature in "$@"; do
+		local status="NO"
+		if echo "${features}" | grep -q -w "${feature}"; then
+			status="YES"
+			found=$((found + 1))
+		fi
+		output+=("${feature}:${status}")
+	done
+
+	echo "${output[@]}"
+	test "${found}" -eq "$#"
+}
diff --git a/tests/xfs/768 b/tests/xfs/768
new file mode 100755
index 00000000..dd9c53be
--- /dev/null
+++ b/tests/xfs/768
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 768
+#
+# Make sure that the kernel won't mount a filesystem if repair forcibly sets
+# NEEDSREPAIR while fixing metadata.  Corrupt a directory in such a way as
+# to force repair to write an invalid dirent value as a sentinel to trigger a
+# repair activity in a later phase.  Use a debug knob in xfs_repair to abort
+# the repair immediately after forcing the flag on.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
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
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+grep -q LIBXFS_DEBUG_WRITE_CRASH $XFS_REPAIR_PROG || \
+		_notrun "libxfs write failure injection hook not detected?"
+
+rm -f $seqres.full
+
+# Set up a real filesystem for our actual test
+_scratch_mkfs -m crc=1 >> $seqres.full
+
+# Create a directory large enough to have a dir data block.  2k worth of
+# dirent names ought to do it.
+_scratch_mount
+mkdir -p $SCRATCH_MNT/fubar
+for i in $(seq 0 256 2048); do
+	fname=$(printf "%0255d" $i)
+	ln -s -f urk $SCRATCH_MNT/fubar/$fname
+done
+inum=$(stat -c '%i' $SCRATCH_MNT/fubar)
+_scratch_unmount
+
+# Fuzz the directory
+_scratch_xfs_db -x -c "inode $inum" -c "dblock 0" \
+	-c "fuzz -d bu[2].inumber add" >> $seqres.full
+
+# Try to repair the directory, force it to crash after setting needsrepair
+LIBXFS_DEBUG_WRITE_CRASH=ddev=2 _scratch_xfs_repair 2>> $seqres.full
+test $? -eq 137 || echo "repair should have been killed??"
+
+# We can't mount, right?
+_check_scratch_xfs_features NEEDSREPAIR
+_try_scratch_mount &> $tmp.mount
+res=$?
+_filter_scratch < $tmp.mount
+if [ $res -eq 0 ]; then
+	echo "Should not be able to mount after needsrepair crash"
+	_scratch_unmount
+fi
+
+# Repair properly this time and retry the mount
+_scratch_xfs_repair 2>> $seqres.full
+_check_scratch_xfs_features NEEDSREPAIR
+
+_scratch_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/768.out b/tests/xfs/768.out
new file mode 100644
index 00000000..1168ba25
--- /dev/null
+++ b/tests/xfs/768.out
@@ -0,0 +1,4 @@
+QA output created by 768
+FEATURES: NEEDSREPAIR:YES
+mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
+FEATURES: NEEDSREPAIR:NO
diff --git a/tests/xfs/770 b/tests/xfs/770
new file mode 100755
index 00000000..574047d5
--- /dev/null
+++ b/tests/xfs/770
@@ -0,0 +1,82 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 770
+#
+# Populate a filesystem with all types of metadata, then run repair with the
+# libxfs write failure trigger set to go after a single write.  Check that the
+# injected error trips, causing repair to abort, that needsrepair is set on the
+# fs, the kernel won't mount; and that a non-injecting repair run clears
+# needsrepair and makes the filesystem mountable again.
+#
+# Repeat with the trip point set to successively higher numbers of writes until
+# we hit ~200 writes or repair manages to run to completion without tripping.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
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
+. ./common/populate
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_scratch_xfs_crc		# needsrepair only exists for v5
+_require_populate_commands
+
+rm -f ${RESULT_DIR}/require_scratch	# we take care of checking the fs
+rm -f $seqres.full
+
+# Populate the filesystem
+_scratch_populate_cached nofill >> $seqres.full 2>&1
+
+max_writes=200			# 200 loops should be enough for anyone
+nr_incr=$((13 / TIME_FACTOR))
+test $nr_incr -lt 1 && nr_incr=1
+for ((nr_writes = 1; nr_writes < max_writes; nr_writes += nr_incr)); do
+	# Start a repair and force it to abort after some number of writes
+	LIBXFS_DEBUG_WRITE_CRASH=ddev=$nr_writes _scratch_xfs_repair 2>> $seqres.full
+	res=$?
+	if [ $res -ne 0 ] && [ $res -ne 137 ]; then
+		echo "repair failed with $res??"
+		break
+	elif [ $res -eq 0 ]; then
+		[ $nr_writes -eq 1 ] && \
+			echo "ran to completion on the first try?"
+		break
+	fi
+
+	# Check the state of NEEDSREPAIR after repair fails.  If it isn't set
+	# but if repair -n says the fs is clean, then it's possible that the
+	# injected error caused it to abort immediately after the write that
+	# cleared NEEDSREPAIR.
+	if ! _check_scratch_xfs_features NEEDSREPAIR > /dev/null &&
+	   ! _scratch_xfs_repair -n &>> $seqres.full; then
+		echo "NEEDSREPAIR should be set on corrupt fs"
+	fi
+
+	# Repair properly this time and retry the mount
+	_scratch_xfs_repair 2>> $seqres.full
+	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \
+		echo "Repair failed to clear NEEDSREPAIR on the $nr_writes writes test"
+done
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/xfs/770.out b/tests/xfs/770.out
new file mode 100644
index 00000000..725d740b
--- /dev/null
+++ b/tests/xfs/770.out
@@ -0,0 +1,2 @@
+QA output created by 770
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index fe83f82d..09fddb5a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -520,3 +520,5 @@
 537 auto quick
 538 auto stress
 539 auto quick mount
+768 auto quick repair
+770 auto repair

