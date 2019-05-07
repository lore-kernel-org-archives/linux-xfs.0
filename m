Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59554 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfEGQ51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:57:27 -0400
Subject: [PATCH ] xfs: validate unicode filesystem labels
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 May 2019 09:57:23 -0700
Message-ID: <155724824306.2624769.17050442466246363524.stgit@magnolia>
In-Reply-To: <155724823157.2624769.14347748235168250309.stgit@magnolia>
References: <155724823157.2624769.14347748235168250309.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we can set and retrieve unicode labels, including emoji.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/739     |  169 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/739.out |    1 
 tests/xfs/group   |    1 
 3 files changed, 171 insertions(+)
 create mode 100755 tests/xfs/739
 create mode 100644 tests/xfs/739.out


diff --git a/tests/xfs/739 b/tests/xfs/739
new file mode 100755
index 00000000..f8796cc3
--- /dev/null
+++ b/tests/xfs/739
@@ -0,0 +1,169 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 739
+#
+# Create a directory with multiple filenames that all appear the same
+# (in unicode, anyway) but point to different inodes.  In theory all
+# Linux filesystems should allow this (filenames are a sequence of
+# arbitrary bytes) even if the user implications are horrifying.
+#
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_nocheck
+_require_xfs_io_command 'label'
+
+# Only run this on xfs if xfs_scrub is available and has the unicode checker
+check_xfs_scrub() {
+	_scratch_mkfs >> $seqres.full 2>&1
+	_scratch_mount >> $seqres.full 2>&1
+	_supports_xfs_scrub "$SCRATCH_MNT" "$SCRATCH_DEV"
+	res=$?
+	_scratch_unmount
+
+	test $res -ne 0 && return 1
+
+	# We only care if xfs_scrub has unicode string support...
+	if ! type ldd > /dev/null 2>&1 || \
+	   ! ldd "${XFS_SCRUB_PROG}" | grep -q libicui18n; then
+		return 1
+	fi
+
+	return 0
+}
+
+want_scrub=
+check_xfs_scrub && want_scrub=yes
+
+filter_scrub() {
+	grep 'Unicode' | sed -e 's/^.*Duplicate/Duplicate/g'
+}
+
+maybe_scrub() {
+	test "$want_scrub" = "yes" || return
+
+	output="$(LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -v -n "${SCRATCH_MNT}" 2>&1)"
+	echo "xfs_scrub output:" >> $seqres.full
+	echo "$output" >> $seqres.full
+	echo "$output" >> $tmp.scrub
+}
+
+testlabel() {
+	local label="$(echo -e "$1")"
+	local expected_label="label = \"$label\""
+
+	echo "Formatting label '$1'." >> $seqres.full
+	# First, let's see if we can recover the label when we set it
+	# with mkfs.
+	_scratch_mkfs -L "$label" >> $seqres.full 2>&1
+	_scratch_mount >> $seqres.full 2>&1
+	blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g" >> $seqres.full
+	blkid -d -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g" >> $seqres.full
+
+	# Did it actually stick?
+	local actual_label="$($XFS_IO_PROG -c label $SCRATCH_MNT)"
+	echo "$actual_label" >> $seqres.full
+
+	if [ "${actual_label}" != "${expected_label}" ]; then
+		echo "Saw '${expected_label}', expected '${actual_label}'."
+	fi
+	maybe_scrub
+	_scratch_unmount
+
+	# Now let's try setting the label online to see what happens.
+	echo "Setting label '$1'." >> $seqres.full
+	_scratch_mkfs >> $seqres.full 2>&1
+	_scratch_mount >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "label -s $label" $SCRATCH_MNT >> $seqres.full
+	blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g" >> $seqres.full
+	blkid -d -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g" >> $seqres.full
+	_scratch_cycle_mount
+
+	# Did it actually stick?
+	local actual_label="$($XFS_IO_PROG -c label $SCRATCH_MNT)"
+	echo "$actual_label" >> $seqres.full
+
+	if [ "${actual_label}" != "${expected_label}" ]; then
+		echo "Saw '${expected_label}'; expected '${actual_label}'."
+	fi
+	maybe_scrub
+	_scratch_unmount
+}
+
+# Simple test
+testlabel "simple"
+
+# Two different renderings of the same label
+testlabel "caf\xc3\xa9.fs"
+testlabel "cafe\xcc\x81.fs"
+
+# Arabic code point can expand into a muuuch longer series
+testlabel "xfs_\xef\xb7\xba.fs"
+
+# Fake slash?
+testlabel "urk\xc0\xafmoo"
+
+# Emoji: octopus butterfly owl giraffe
+testlabel "\xf0\x9f\xa6\x91\xf0\x9f\xa6\x8b\xf0\x9f\xa6\x89"
+
+# unicode rtl widgets too...
+testlabel "mo\xe2\x80\xaegnp.txt"
+testlabel "motxt.png"
+
+# mixed-script confusables
+testlabel "mixed_t\xce\xbfp"
+testlabel "mixed_top"
+
+# single-script spoofing
+testlabel "a\xe2\x80\x90b.fs"
+testlabel "a-b.fs"
+
+testlabel "dz_dze.fs"
+testlabel "dz_\xca\xa3e.fs"
+
+# symbols
+testlabel "_Rs.fs"
+testlabel "_\xe2\x82\xa8.fs"
+
+# zero width joiners
+testlabel "moocow.fs"
+testlabel "moo\xe2\x80\x8dcow.fs"
+
+# combining marks
+testlabel "\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.fs"
+testlabel "\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.fs"
+
+# fake dotdot entry
+testlabel ".\xe2\x80\x8d"
+testlabel "..\xe2\x80\x8d"
+
+# Did scrub choke on anything?
+if [ "$want_scrub" = "yes" ]; then
+	grep -q "^Warning.*gnp.txt.*suspicious text direction" $tmp.scrub || \
+		echo "No complaints about direction overrides?"
+	grep -q "^Warning.*control characters" $tmp.scrub || \
+		echo "No complaints about control characters?"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/739.out b/tests/xfs/739.out
new file mode 100644
index 00000000..f4f653e2
--- /dev/null
+++ b/tests/xfs/739.out
@@ -0,0 +1 @@
+QA output created by 739
diff --git a/tests/xfs/group b/tests/xfs/group
index e71b058f..c8620d72 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -501,3 +501,4 @@
 501 auto quick unlink
 502 auto quick unlink
 503 auto copy metadump
+739 auto quick mkfs label
