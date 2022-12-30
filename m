Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE3CC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbiL3W73 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235687AbiL3W72 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:59:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829271CFCB;
        Fri, 30 Dec 2022 14:59:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EDFFB81DA0;
        Fri, 30 Dec 2022 22:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4419C433D2;
        Fri, 30 Dec 2022 22:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441163;
        bh=ZKTMNzuENiwQaaY4j8dZAATemGn3RvbLFZo9RIvt8pM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=szjkGRS7iRc0El1tw6ANnDf0o6RI5omgldiksLTMNClPI1nNRxPTzSAT6/gzg6gG9
         SpEKNi8uDE+8UY5tpcIe74v9XiSP2ncYmKwghLp9fJv+xakav7bNOuXiw82fbQ7c5h
         YgZUIJJEQilTUgCd9E5LYlPBXjmPaLM++TE5mOFALrk/zd4usNW02Uq4Qg61n3u08k
         LoCfzYjauU6M+hFK3DAzdiDF8h184jEYrJW6PL1X3oDMZVzcEjrDb6saYuvxSX+BH4
         hIZ7rxoirkV+vaqZz4Wv8Ch1hyStSs8u/5655GdY90VKNUrN+DWxj/w6vChCYw0lE2
         /squlUXwUVdTw==
Subject: [PATCH 1/2] xfs: stress test xfs_scrub(8) with fsstress
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:13:00 -0800
Message-ID: <167243838078.695417.14865209512228809790.stgit@magnolia>
In-Reply-To: <167243838066.695417.12457890635253015617.stgit@magnolia>
References: <167243838066.695417.12457890635253015617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port the two existing tests that check that xfs_scrub(8) (aka the main
userspace driver program) doesn't clash with fsstress to use our new
framework.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy      |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 tests/xfs/285     |   44 ++++++++++---------------------------
 tests/xfs/285.out |    4 +--
 tests/xfs/286     |   46 ++++++++++-----------------------------
 tests/xfs/286.out |    4 +--
 5 files changed, 86 insertions(+), 75 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index ee97aa4298..e39f787e78 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -411,6 +411,42 @@ __stress_one_scrub_loop() {
 	done
 }
 
+# Run xfs_scrub online fsck in a tight loop.
+__stress_xfs_scrub_loop() {
+	local end="$1"
+	local runningfile="$2"
+	local scrub_startat="$3"
+	shift; shift; shift
+	local sigint_ret="$(( $(kill -l SIGINT) + 128 ))"
+	local scrublog="$tmp.scrub"
+
+	while __stress_scrub_running "$scrub_startat" "$runningfile"; do
+		sleep 1
+	done
+
+	while __stress_scrub_running "$end" "$runningfile"; do
+		_scratch_scrub "$@" &> $scrublog
+		res=$?
+		if [ "$res" -eq "$sigint_ret" ]; then
+			# Ignore SIGINT because the cleanup function sends
+			# that to terminate xfs_scrub
+			res=0
+		fi
+		echo "xfs_scrub exits with $res at $(date)" >> $seqres.full
+		if [ "$res" -ge 128 ]; then
+			# Report scrub death due to fatal signals
+			echo "xfs_scrub died with SIG$(kill -l $res)"
+			cat $scrublog >> $seqres.full 2>/dev/null
+		elif [ "$((res & 0x1))" -gt 0 ]; then
+			# Report uncorrected filesystem errors
+			echo "xfs_scrub reports uncorrected errors:"
+			grep -E '(Repair unsuccessful;|Corruption:)' $scrublog
+			cat $scrublog >> $seqres.full 2>/dev/null
+		fi
+		rm -f $scrublog
+	done
+}
+
 # Clean the scratch filesystem between rounds of fsstress if there is 2%
 # available space or less because that isn't an interesting stress test.
 #
@@ -571,7 +607,7 @@ _scratch_xfs_stress_scrub_cleanup() {
 	# Send SIGINT so that bash won't print a 'Terminated' message that
 	# distorts the golden output.
 	echo "Killing stressor processes at $(date)" >> $seqres.full
-	$KILLALL_PROG -INT xfs_io fsstress fsx >> $seqres.full 2>&1
+	$KILLALL_PROG -INT xfs_io fsstress fsx xfs_scrub >> $seqres.full 2>&1
 
 	# Tests are not allowed to exit with the scratch fs frozen.  If we
 	# started a fs freeze/thaw background loop, wait for that loop to exit
@@ -649,6 +685,8 @@ __stress_scrub_check_commands() {
 #	XFS_SCRUB_STRESS_REMOUNT_PERIOD is set.
 # -s	Pass this command to xfs_io to test scrub.  If zero -s options are
 #	specified, xfs_io will not be run.
+# -S	Pass this option to xfs_scrub.  If zero -S options are specified,
+#	xfs_scrub will not be run.  To select repair mode, pass '-k' or '-v'.
 # -t	Run online scrub against this file; $SCRATCH_MNT is the default.
 # -w	Delay the start of the scrub/repair loop by this number of seconds.
 #	Defaults to no delay unless XFS_SCRUB_STRESS_DELAY is set.  This value
@@ -657,6 +695,7 @@ __stress_scrub_check_commands() {
 #       options are 'fsx' and 'fsstress'.  The default is 'fsstress'.
 _scratch_xfs_stress_scrub() {
 	local one_scrub_args=()
+	local xfs_scrub_args=()
 	local scrub_tgt="$SCRATCH_MNT"
 	local runningfile="$tmp.fsstress"
 	local freeze="${XFS_SCRUB_STRESS_FREEZE}"
@@ -671,12 +710,13 @@ _scratch_xfs_stress_scrub() {
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "fi:r:s:t:w:X:" c; do
+	while getopts "fi:r:s:S:t:w:X:" c; do
 		case "$c" in
 			f) freeze=yes;;
 			i) io_args+=("$OPTARG");;
 			r) remount_period="$OPTARG";;
 			s) one_scrub_args+=("$OPTARG");;
+			S) xfs_scrub_args+=("$OPTARG");;
 			t) scrub_tgt="$OPTARG";;
 			w) scrub_delay="$OPTARG";;
 			X) exerciser="$OPTARG";;
@@ -691,6 +731,18 @@ _scratch_xfs_stress_scrub() {
 		return 1
 	fi
 
+	if [ "${#xfs_scrub_args[@]}" -gt 0 ]; then
+		_scratch_scrub "${xfs_scrub_args[@]}" &> "$tmp.scrub"
+		res=$?
+		if [ $res -ne 0 ]; then
+			echo "xfs_scrub ${xfs_scrub_args[@]} failed, err $res" >> $seqres.full
+			cat "$tmp.scrub" >> $seqres.full
+			rm -f "$tmp.scrub"
+			_notrun 'scrub not supported on scratch filesystem'
+		fi
+		rm -f "$tmp.scrub"
+	fi
+
 	local start="$(date +%s)"
 	local end="$((start + (30 * TIME_FACTOR) ))"
 	local scrub_startat="$((start + scrub_delay))"
@@ -722,6 +774,11 @@ _scratch_xfs_stress_scrub() {
 				"$scrub_startat" "${one_scrub_args[@]}" &
 	fi
 
+	if [ "${#xfs_scrub_args[@]}" -gt 0 ]; then
+		__stress_xfs_scrub_loop "$end" "$runningfile" "$scrub_startat" \
+				"${xfs_scrub_args[@]}" &
+	fi
+
 	# Wait until the designated end time or fsstress dies, then kill all of
 	# our background processes.
 	while __stress_scrub_running "$end" "$runningfile"; do
@@ -741,5 +798,5 @@ _scratch_xfs_stress_scrub() {
 # Same requirements and arguments as _scratch_xfs_stress_scrub.
 _scratch_xfs_stress_online_repair() {
 	$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
-	_scratch_xfs_stress_scrub "$@"
+	XFS_SCRUB_FORCE_REPAIR=1 _scratch_xfs_stress_scrub "$@"
 }
diff --git a/tests/xfs/285 b/tests/xfs/285
index 711211d412..0056baeb1c 100755
--- a/tests/xfs/285
+++ b/tests/xfs/285
@@ -4,55 +4,35 @@
 #
 # FS QA Test No. 285
 #
-# Race fio and xfs_scrub for a while to see if we crash or livelock.
+# Race fsstress and xfs_scrub in read-only mode for a while to see if we crash
+# or livelock.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub
+_begin_fstest scrub dangerous_fsstress_scrub
 
+_cleanup() {
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	rm -r -f $tmp.*
+}
 _register_cleanup "_cleanup" BUS
 
 # Import common functions.
 . ./common/filter
 . ./common/fuzzy
 . ./common/inject
+. ./common/xfs
 
 # real QA test starts here
 _supported_fs xfs
-_require_test_program "feature"
-_require_command "$KILLALL_PROG" killall
-_require_command "$TIMEOUT_PROG" timeout
-_require_scrub
 _require_scratch
+_require_xfs_stress_scrub
 
-echo "Format and populate"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
-
-STRESS_DIR="$SCRATCH_MNT/testdir"
-mkdir -p $STRESS_DIR
-
-cpus=$(( $($here/src/feature -o) * 4 * LOAD_FACTOR))
-$FSSTRESS_PROG -d $STRESS_DIR -p $cpus -n $((cpus * 100000)) $FSSTRESS_AVOID >/dev/null 2>&1 &
-$XFS_SCRUB_PROG -d -T -v -n $SCRATCH_MNT >> $seqres.full
-
-killstress() {
-	sleep $(( 60 * TIME_FACTOR ))
-	$KILLALL_PROG -q $FSSTRESS_PROG
-}
-
-echo "Concurrent scrub"
-start=$(date +%s)
-end=$((start + (60 * TIME_FACTOR) ))
-killstress &
-echo "Scrub started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
-while [ "$(date +%s)" -lt "$end" ]; do
-	$TIMEOUT_PROG -s TERM $(( end - $(date +%s) + 2 )) $XFS_SCRUB_PROG -d -T -v -n $SCRATCH_MNT >> $seqres.full 2>&1
-done
-
-echo "Test done"
-echo "Scrub finished at $(date)" >> $seqres.full
-$KILLALL_PROG -q $FSSTRESS_PROG
+_scratch_xfs_stress_scrub -S '-n'
 
 # success, all done
+echo Silence is golden
 status=0
 exit
diff --git a/tests/xfs/285.out b/tests/xfs/285.out
index be6b49a9fb..ab12da9ae7 100644
--- a/tests/xfs/285.out
+++ b/tests/xfs/285.out
@@ -1,4 +1,2 @@
 QA output created by 285
-Format and populate
-Concurrent scrub
-Test done
+Silence is golden
diff --git a/tests/xfs/286 b/tests/xfs/286
index 7edc9c427b..0f61a924db 100755
--- a/tests/xfs/286
+++ b/tests/xfs/286
@@ -4,57 +4,35 @@
 #
 # FS QA Test No. 286
 #
-# Race fio and xfs_scrub for a while to see if we crash or livelock.
+# Race fsstress and xfs_scrub in force-repair mode for a while to see if we
+# crash or livelock.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest online_repair dangerous_fsstress_repair
 
+_cleanup() {
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	rm -r -f $tmp.*
+}
 _register_cleanup "_cleanup" BUS
 
 # Import common functions.
 . ./common/filter
 . ./common/fuzzy
 . ./common/inject
+. ./common/xfs
 
 # real QA test starts here
 _supported_fs xfs
-_require_test_program "feature"
-_require_command "$KILLALL_PROG" killall
-_require_command "$TIMEOUT_PROG" timeout
-_require_scrub
 _require_scratch
-# xfs_scrub will turn on error injection itself
-_require_xfs_io_error_injection "force_repair"
+_require_xfs_stress_online_repair
 
-echo "Format and populate"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
-
-STRESS_DIR="$SCRATCH_MNT/testdir"
-mkdir -p $STRESS_DIR
-
-cpus=$(( $($here/src/feature -o) * 4 * LOAD_FACTOR))
-$FSSTRESS_PROG -d $STRESS_DIR -p $cpus -n $((cpus * 100000)) $FSSTRESS_AVOID >/dev/null 2>&1 &
-$XFS_SCRUB_PROG -d -T -v -n $SCRATCH_MNT >> $seqres.full
-
-killstress() {
-	sleep $(( 60 * TIME_FACTOR ))
-	$KILLALL_PROG -q $FSSTRESS_PROG
-}
-
-echo "Concurrent repair"
-start=$(date +%s)
-end=$((start + (60 * TIME_FACTOR) ))
-killstress &
-echo "Repair started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
-while [ "$(date +%s)" -lt "$end" ]; do
-	XFS_SCRUB_FORCE_REPAIR=1 $TIMEOUT_PROG -s TERM $(( end - $(date +%s) + 2 )) $XFS_SCRUB_PROG -d -T -v $SCRATCH_MNT >> $seqres.full
-done
-
-echo "Test done"
-echo "Repair finished at $(date)" >> $seqres.full
-$KILLALL_PROG -q $FSSTRESS_PROG
+_scratch_xfs_stress_online_repair -S '-k'
 
 # success, all done
+echo Silence is golden
 status=0
 exit
diff --git a/tests/xfs/286.out b/tests/xfs/286.out
index 80e12b5495..35c4800694 100644
--- a/tests/xfs/286.out
+++ b/tests/xfs/286.out
@@ -1,4 +1,2 @@
 QA output created by 286
-Format and populate
-Concurrent repair
-Test done
+Silence is golden

