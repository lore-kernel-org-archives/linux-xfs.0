Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627D6C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiL3W6z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbiL3W6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:58:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982B51CFC6;
        Fri, 30 Dec 2022 14:58:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 356F561C2F;
        Fri, 30 Dec 2022 22:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94128C433EF;
        Fri, 30 Dec 2022 22:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441132;
        bh=27sFHiFTzpm6A/NAPseIZc1dGKXUHoAVsrTWYif6bUI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Rx9BcMzJXLsXu+EPMVTZ8ViJFDComjtHorw7NI6SavqoahBstHLhQocjmaSiG5EcD
         qLv2zG31TMi/anRCmgrBiR3jrMbuo0DtGF1nV/mygr5ZBMD4ciO1ispLar0ZLUBWGE
         U2H7YHTNOHjZfTYXeeqcuq1TqTMJDap9jZKQbxwbEyyxXdJgXfqxPCKpKrsKZzoV0k
         WHq8eSE6FXuyDm1lUiqOoR7O/8BLCmKHiZr1piZ7BD3XQF7vvB0o+zGHp7fiwxgNV2
         yQt7UnMxnmNnZyb2kaH82KVDGJCckDuk0UbcYcybkacDDWlEN0+MUYSq+fe4OpqKE4
         EBxm0WKC2BsGQ==
Subject: [PATCH 2/3] fuzzy: refactor fsmap stress test to use our helper
 functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:58 -0800
Message-ID: <167243837798.695156.7566942167180753841.stgit@magnolia>
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

Refactor xfs/517 (which races fsstress with fsmap) to use our new
control loop functions instead of open-coding everything.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy      |   30 +++++++++++++++++
 tests/xfs/517     |   91 ++---------------------------------------------------
 tests/xfs/517.out |    4 +-
 3 files changed, 34 insertions(+), 91 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 3512e95e02..58e299d34b 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -362,6 +362,23 @@ __stress_scrub_freeze_loop() {
 	done
 }
 
+# Run individual xfs_io commands in a tight loop.
+__stress_xfs_io_loop() {
+	local end="$1"
+	local runningfile="$2"
+	shift; shift
+
+	local xfs_io_args=()
+	for arg in "$@"; do
+		xfs_io_args+=('-c' "$arg")
+	done
+
+	while __stress_scrub_running "$end" "$runningfile"; do
+		$XFS_IO_PROG -x "${xfs_io_args[@]}" "$SCRATCH_MNT" \
+				> /dev/null 2>> $seqres.full
+	done
+}
+
 # Run individual XFS online fsck commands in a tight loop with xfs_io.
 __stress_one_scrub_loop() {
 	local end="$1"
@@ -540,6 +557,10 @@ __stress_scrub_check_commands() {
 #
 # -f	Run a freeze/thaw loop while we're doing other things.  Defaults to
 #	disabled, unless XFS_SCRUB_STRESS_FREEZE is set.
+# -i	Pass this command to xfs_io to exercise something that is not scrub
+#	in a separate loop.  If zero -i options are specified, do not run.
+#	Callers must check each of these commands (via _require_xfs_io_command)
+#	before calling here.
 # -s	Pass this command to xfs_io to test scrub.  If zero -s options are
 #	specified, xfs_io will not be run.
 # -t	Run online scrub against this file; $SCRATCH_MNT is the default.
@@ -555,15 +576,17 @@ _scratch_xfs_stress_scrub() {
 	local freeze="${XFS_SCRUB_STRESS_FREEZE}"
 	local scrub_delay="${XFS_SCRUB_STRESS_DELAY:--1}"
 	local exerciser="fsstress"
+	local io_args=()
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	rm -f "$runningfile"
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "fs:t:w:X:" c; do
+	while getopts "fi:s:t:w:X:" c; do
 		case "$c" in
 			f) freeze=yes;;
+			i) io_args+=("$OPTARG");;
 			s) one_scrub_args+=("$OPTARG");;
 			t) scrub_tgt="$OPTARG";;
 			w) scrub_delay="$OPTARG";;
@@ -595,6 +618,11 @@ _scratch_xfs_stress_scrub() {
 		__SCRUB_STRESS_FREEZE_PID="$!"
 	fi
 
+	if [ "${#io_args[@]}" -gt 0 ]; then
+		__stress_xfs_io_loop "$end" "$runningfile" \
+				"${io_args[@]}" &
+	fi
+
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
 				"$scrub_startat" "${one_scrub_args[@]}" &
diff --git a/tests/xfs/517 b/tests/xfs/517
index 99fc89b05f..4481ba41da 100755
--- a/tests/xfs/517
+++ b/tests/xfs/517
@@ -11,29 +11,11 @@ _begin_fstest auto quick fsmap freeze
 
 _register_cleanup "_cleanup" BUS
 
-# First kill and wait the freeze loop so it won't try to freeze fs again
-# Then make sure fs is not frozen
-# Then kill and wait for the rest of the workers
-# Because if fs is frozen a killed writer will never exit
-kill_loops() {
-	local sig=$1
-
-	[ -n "$freeze_pid" ] && kill $sig $freeze_pid
-	wait $freeze_pid
-	unset freeze_pid
-	$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT
-	[ -n "$stress_pid" ] && kill $sig $stress_pid
-	[ -n "$fsmap_pid" ] && kill $sig $fsmap_pid
-	wait
-	unset stress_pid
-	unset fsmap_pid
-}
-
 # Override the default cleanup function.
 _cleanup()
 {
-	kill_loops -9 > /dev/null 2>&1
 	cd /
+	_scratch_xfs_stress_scrub_cleanup
 	rm -rf $tmp.*
 }
 
@@ -46,78 +28,13 @@ _cleanup()
 _supported_fs xfs
 _require_xfs_scratch_rmapbt
 _require_xfs_io_command "fsmap"
-_require_command "$KILLALL_PROG" killall
-_require_freeze
+_require_xfs_stress_scrub
 
-echo "Format and populate"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
-
-STRESS_DIR="$SCRATCH_MNT/testdir"
-mkdir -p $STRESS_DIR
-
-for i in $(seq 0 9); do
-	mkdir -p $STRESS_DIR/$i
-	for j in $(seq 0 9); do
-		mkdir -p $STRESS_DIR/$i/$j
-		for k in $(seq 0 9); do
-			echo x > $STRESS_DIR/$i/$j/$k
-		done
-	done
-done
-
-cpus=$(( $(src/feature -o) * 4 * LOAD_FACTOR))
-
-echo "Concurrent fsmap and freeze"
-filter_output() {
-	grep -E -v '(Device or resource busy|Invalid argument)'
-}
-freeze_loop() {
-	end="$1"
-
-	while [ "$(date +%s)" -lt $end ]; do
-		$XFS_IO_PROG -x -c 'freeze' $SCRATCH_MNT 2>&1 | filter_output
-		$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT 2>&1 | filter_output
-	done
-}
-fsmap_loop() {
-	end="$1"
-
-	while [ "$(date +%s)" -lt $end ]; do
-		$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT > /dev/null
-	done
-}
-stress_loop() {
-	end="$1"
-
-	FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000 $FSSTRESS_AVOID)
-	while [ "$(date +%s)" -lt $end ]; do
-		$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
-	done
-}
-
-start=$(date +%s)
-end=$((start + (30 * TIME_FACTOR) ))
-
-echo "Loop started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
-stress_loop $end &
-stress_pid=$!
-freeze_loop $end &
-freeze_pid=$!
-fsmap_loop $end &
-fsmap_pid=$!
-
-# Wait until 2 seconds after the loops should have finished...
-while [ "$(date +%s)" -lt $((end + 2)) ]; do
-	sleep 1
-done
-
-# ...and clean up after the loops in case they didn't do it themselves.
-kill_loops >> $seqres.full 2>&1
-
-echo "Loop finished at $(date)" >> $seqres.full
-echo "Test done"
+_scratch_xfs_stress_scrub -i 'fsmap -v'
 
 # success, all done
+echo "Silence is golden"
 status=0
 exit
diff --git a/tests/xfs/517.out b/tests/xfs/517.out
index da6366e52b..49c53bcaa9 100644
--- a/tests/xfs/517.out
+++ b/tests/xfs/517.out
@@ -1,4 +1,2 @@
 QA output created by 517
-Format and populate
-Concurrent fsmap and freeze
-Test done
+Silence is golden

