Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF05AC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiL3W6m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbiL3W6l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:58:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0BE1CFCA;
        Fri, 30 Dec 2022 14:58:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A7BF9CE19BE;
        Fri, 30 Dec 2022 22:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9561C433EF;
        Fri, 30 Dec 2022 22:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441116;
        bh=tBqjCYgSq2v6PM3lru5DvWDwucpIryGUv15z50zYh98=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V5dLJMpvZfDCglAqP8v5bKHHWudbYpRQajijyeS9WDCXiihXYovn3GUuO3FAeAhSU
         yR1H4yMPDzIcTZDEviMbNqomWcsssjmGv+IRbqfxzAvC37g2A+C2LbGnqAg1RCuI23
         nI3c0AVOMngaLcIIrudRj/PGMUpfQXHhG4z+nBxOvRHunECZRK94oGMGdLnVj8Bwfn
         Wm/fkMj9YUC04XdfY9yZPnwB+NdDxAUDYvl5EyDM6hKz8ZIydJvSbfgEh1H33q69h9
         eugL32XrC9H1p8/B4iyAF4dOQIbYQ5cfzJEpXMpwSuKlC2hxECEnekJh9NZpEaZaw7
         tOHMRJVlP0q8Q==
Subject: [PATCH 1/3] fuzzy: enhance scrub stress testing to use fsx
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:57 -0800
Message-ID: <167243837785.695156.13821918047950372871.stgit@magnolia>
In-Reply-To: <167243837772.695156.17793145241363597974.stgit@magnolia>
References: <167243837772.695156.17793145241363597974.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a couple of new online fsck stress tests that race fsx against
online fsck.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy      |   39 ++++++++++++++++++++++++++++++++++++---
 tests/xfs/847     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/847.out |    2 ++
 tests/xfs/848     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/848.out |    2 ++
 5 files changed, 116 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/847
 create mode 100644 tests/xfs/847.out
 create mode 100755 tests/xfs/848
 create mode 100644 tests/xfs/848.out


diff --git a/common/fuzzy b/common/fuzzy
index 1df51a6dd8..3512e95e02 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -408,6 +408,30 @@ __stress_scrub_clean_scratch() {
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
@@ -454,7 +478,7 @@ _scratch_xfs_stress_scrub_cleanup() {
 	# Send SIGINT so that bash won't print a 'Terminated' message that
 	# distorts the golden output.
 	echo "Killing stressor processes at $(date)" >> $seqres.full
-	$KILLALL_PROG -INT xfs_io fsstress >> $seqres.full 2>&1
+	$KILLALL_PROG -INT xfs_io fsstress fsx >> $seqres.full 2>&1
 
 	# Tests are not allowed to exit with the scratch fs frozen.  If we
 	# started a fs freeze/thaw background loop, wait for that loop to exit
@@ -522,30 +546,39 @@ __stress_scrub_check_commands() {
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
@@ -555,7 +588,7 @@ _scratch_xfs_stress_scrub() {
 	echo "Loop started at $(date --date="@${start}")," \
 		   "ending at $(date --date="@${end}")" >> $seqres.full
 
-	__stress_scrub_fsstress_loop "$end" "$runningfile" &
+	"__stress_scrub_${exerciser}_loop" "$end" "$runningfile" &
 
 	if [ -n "$freeze" ]; then
 		__stress_scrub_freeze_loop "$end" "$runningfile" &
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

