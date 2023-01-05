Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A02AC4708E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Jan 2023 18:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbjAES3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Jan 2023 13:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjAES3A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2023 13:29:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AA5564DC;
        Thu,  5 Jan 2023 10:28:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EC8761BD1;
        Thu,  5 Jan 2023 18:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEE9C433EF;
        Thu,  5 Jan 2023 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672943337;
        bh=equuPtuj/xVYbzxz5sRYuFOxWTHYhxWmakc53gbx27U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y/8G9S3Ur6hDGyLBGSb4y00Cr8LV38sYxmNiqlxTCJ9MIV3+RgfaSomUPOOim/vCU
         c5HqkSa5lq3Wd1mO9ktYwMjdvbQzn0hWAg6fAyx8nOjBLa5ahtmMJMZeljI7xTi7U5
         ADq4MqiDu3tm9ZaXxwCwv4wgHNzbaEQUutMjhbbbBubucCHmhhMyCpbzyqZvVBx5ky
         vqZLS7IZzCeUlvzAOdSdy9Npq/BlqawbSIibHt57SIv2a/owJDEkr1JVyf+NAdsJLo
         8RFpyfZiXkCyew7XKqIircg2FnBec9fL26IR2RjvTgemyklP/2lq+zVJmx/gF1lMnT
         /WKVNlXPPZlGQ==
Date:   Thu, 5 Jan 2023 10:28:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v24.1 1/3] fuzzy: enhance scrub stress testing to use fsx
Message-ID: <Y7cW6ZkJKkrKKQlz@magnolia>
References: <167243837772.695156.17793145241363597974.stgit@magnolia>
 <167243837785.695156.13821918047950372871.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243837785.695156.13821918047950372871.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a couple of new online fsck stress tests that race fsx against
online fsck.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v24.1: move the addition of the group to this patch
---
 common/fuzzy        |   39 ++++++++++++++++++++++++++++++++++++---
 doc/group-names.txt |    1 +
 tests/xfs/847       |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/847.out   |    2 ++
 tests/xfs/848       |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/848.out   |    2 ++
 6 files changed, 117 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/847
 create mode 100644 tests/xfs/847.out
 create mode 100755 tests/xfs/848
 create mode 100644 tests/xfs/848.out

diff --git a/common/fuzzy b/common/fuzzy
index 7994665ef7..a764de461e 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -417,6 +417,30 @@ __stress_scrub_clean_scratch() {
 	return 0
 }
 
+# Run fsx while we're testing online fsck.
+__stress_scrub_fsx_loop() {
+	local end="$1"
+	local runningfile="$2"
+	local focus=(-q -X)	# quiet, validate file contents
+
+	# As of November 2022, 2 million fsx ops should be enough to keep
+	# any filesystem busy for a couple of hours.
+	focus+=(-N 2000000)
+	focus+=(-o $((128000 * LOAD_FACTOR)) )
+	focus+=(-l $((600000 * LOAD_FACTOR)) )
+
+	local args="$FSX_AVOID ${focus[@]} ${SCRATCH_MNT}/fsx.$seq"
+	echo "Running $here/ltp/fsx $args" >> $seqres.full
+
+	while __stress_scrub_running "$end" "$runningfile"; do
+		# Need to recheck running conditions if we cleared anything
+		__stress_scrub_clean_scratch && continue
+		$here/ltp/fsx $args >> $seqres.full
+		echo "fsx exits with $? at $(date)" >> $seqres.full
+	done
+	rm -f "$runningfile"
+}
+
 # Run fsstress while we're testing online fsck.
 __stress_scrub_fsstress_loop() {
 	local end="$1"
@@ -463,7 +487,7 @@ _scratch_xfs_stress_scrub_cleanup() {
 	# Send SIGINT so that bash won't print a 'Terminated' message that
 	# distorts the golden output.
 	echo "Killing stressor processes at $(date)" >> $seqres.full
-	$KILLALL_PROG -INT xfs_io fsstress >> $seqres.full 2>&1
+	$KILLALL_PROG -INT xfs_io fsstress fsx >> $seqres.full 2>&1
 
 	# Tests are not allowed to exit with the scratch fs frozen.  If we
 	# started a fs freeze/thaw background loop, wait for that loop to exit
@@ -531,30 +555,39 @@ __stress_scrub_check_commands() {
 # -w	Delay the start of the scrub/repair loop by this number of seconds.
 #	Defaults to no delay unless XFS_SCRUB_STRESS_DELAY is set.  This value
 #	will be clamped to ten seconds before the end time.
+# -X	Run this program to exercise the filesystem.  Currently supported
+#       options are 'fsx' and 'fsstress'.  The default is 'fsstress'.
 _scratch_xfs_stress_scrub() {
 	local one_scrub_args=()
 	local scrub_tgt="$SCRATCH_MNT"
 	local runningfile="$tmp.fsstress"
 	local freeze="${XFS_SCRUB_STRESS_FREEZE}"
 	local scrub_delay="${XFS_SCRUB_STRESS_DELAY:--1}"
+	local exerciser="fsstress"
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	rm -f "$runningfile"
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "fs:t:w:" c; do
+	while getopts "fs:t:w:X:" c; do
 		case "$c" in
 			f) freeze=yes;;
 			s) one_scrub_args+=("$OPTARG");;
 			t) scrub_tgt="$OPTARG";;
 			w) scrub_delay="$OPTARG";;
+			X) exerciser="$OPTARG";;
 			*) return 1; ;;
 		esac
 	done
 
 	__stress_scrub_check_commands "$scrub_tgt" "${one_scrub_args[@]}"
 
+	if ! command -v "__stress_scrub_${exerciser}_loop" &>/dev/null; then
+		echo "${exerciser}: Unknown fs exercise program."
+		return 1
+	fi
+
 	local start="$(date +%s)"
 	local end="$((start + (30 * TIME_FACTOR) ))"
 	local scrub_startat="$((start + scrub_delay))"
@@ -564,7 +597,7 @@ _scratch_xfs_stress_scrub() {
 	echo "Loop started at $(date --date="@${start}")," \
 		   "ending at $(date --date="@${end}")" >> $seqres.full
 
-	__stress_scrub_fsstress_loop "$end" "$runningfile" &
+	"__stress_scrub_${exerciser}_loop" "$end" "$runningfile" &
 
 	if [ -n "$freeze" ]; then
 		__stress_scrub_freeze_loop "$end" "$runningfile" &
diff --git a/doc/group-names.txt b/doc/group-names.txt
index ac219e05b3..771ce937ae 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -35,6 +35,7 @@ dangerous_fuzzers	fuzzers that can crash your computer
 dangerous_norepair	fuzzers to evaluate kernel metadata verifiers
 dangerous_online_repair	fuzzers to evaluate xfs_scrub online repair
 dangerous_fsstress_repair	race fsstress and xfs_scrub online repair
+dangerous_fsstress_scrub	race fsstress and xfs_scrub checking
 dangerous_repair	fuzzers to evaluate xfs_repair offline repair
 dangerous_scrub		fuzzers to evaluate xfs_scrub checking
 data			data loss checkers
diff --git a/tests/xfs/847 b/tests/xfs/847
new file mode 100755
index 0000000000..856e9a6c26
--- /dev/null
+++ b/tests/xfs/847
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 847
+#
+# Race fsx and xfs_scrub in read-only mode for a while to see if we crash
+# or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -S '-n' -X 'fsx'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/847.out b/tests/xfs/847.out
new file mode 100644
index 0000000000..b7041db159
--- /dev/null
+++ b/tests/xfs/847.out
@@ -0,0 +1,2 @@
+QA output created by 847
+Silence is golden
diff --git a/tests/xfs/848 b/tests/xfs/848
new file mode 100755
index 0000000000..ab32020624
--- /dev/null
+++ b/tests/xfs/848
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 848
+#
+# Race fsx and xfs_scrub in force-repair mode for a while to see if we
+# crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -S '-k' -X 'fsx'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/848.out b/tests/xfs/848.out
new file mode 100644
index 0000000000..23f674045c
--- /dev/null
+++ b/tests/xfs/848.out
@@ -0,0 +1,2 @@
+QA output created by 848
+Silence is golden
