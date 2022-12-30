Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0655CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiL3Wyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbiL3Wyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:54:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913D11D0E2;
        Fri, 30 Dec 2022 14:54:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E20761AC4;
        Fri, 30 Dec 2022 22:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887B4C433D2;
        Fri, 30 Dec 2022 22:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440882;
        bh=sl1BeavL/iPTTWfqEZT3TR+7+516RsIAFpISl65NUOE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g8dUrYRzj23zpw5DvwneShLauAmcXZ1CRM+Y+iwhTXdJgOAxwUaRJ3jXu8WTP36K1
         ysd4g1p1SELHyyQyYPf5GpC8zq/QkuFuL+KSACYCw3qBeHixd3erWe1lBcoqAuhN+d
         VPwlOH6ziQzJ8oGk40Z1qPzxZogJv+diBL57kTh6Gkjt2b3gu7oPKQ6imlNXc4xN7b
         JlTK4ZciAOkoBGh3K2O1jqPccgzupIxedQmRbc7ieQJrfRv42YCTC2vnbAMOqNDBFk
         Cr9c4rXmoQSnIcJR9QUcvxJ0bvd7Ls+yFjUbkM/dFH0ssoxyV1PKxb+xX16kAoadcA
         M7QNkx+dkZfow==
Subject: [PATCH 02/16] xfs/422: move the fsstress/freeze/scrub racing logic to
 common/fuzzy
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:53 -0800
Message-ID: <167243837327.694541.10370212917252408651.stgit@magnolia>
In-Reply-To: <167243837296.694541.13203497631389630964.stgit@magnolia>
References: <167243837296.694541.13203497631389630964.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hoist all this code to common/fuzzy in preparation for making this code
more generic so that we implement a variety of tests that check the
concurrency correctness of online fsck.  Do just enough renaming so that
we don't pollute the test program's namespace; we'll fix the other warts
in subsequent patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy      |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/422     |  104 ++++-------------------------------------------------
 tests/xfs/422.out |    4 +-
 3 files changed, 109 insertions(+), 99 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 70213af5db..979fa55515 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -316,3 +316,103 @@ _scratch_xfs_fuzz_metadata() {
 		done
 	done
 }
+
+# Functions to race fsstress, fs freeze, and xfs metadata scrubbing against
+# each other to shake out bugs in xfs online repair.
+
+# Filter freeze and thaw loop output so that we don't tarnish the golden output
+# if the kernel temporarily won't let us freeze.
+__stress_freeze_filter_output() {
+	grep -E -v '(Device or resource busy|Invalid argument)'
+}
+
+# Filter scrub output so that we don't tarnish the golden output if the fs is
+# too busy to scrub.  Note: Tests should _notrun if the scrub type is not
+# supported.
+__stress_scrub_filter_output() {
+	grep -E -v '(Device or resource busy|Invalid argument)'
+}
+
+# Run fs freeze and thaw in a tight loop.
+__stress_scrub_freeze_loop() {
+	local end="$1"
+
+	while [ "$(date +%s)" -lt $end ]; do
+		$XFS_IO_PROG -x -c 'freeze' -c 'thaw' $SCRATCH_MNT 2>&1 | \
+			__stress_freeze_filter_output
+	done
+}
+
+# Run xfs online fsck commands in a tight loop.
+__stress_scrub_loop() {
+	local end="$1"
+
+	while [ "$(date +%s)" -lt $end ]; do
+		$XFS_IO_PROG -x -c 'repair rmapbt 0' -c 'repair rmapbt 1' $SCRATCH_MNT 2>&1 | \
+			__stress_scrub_filter_output
+	done
+}
+
+# Run fsstress while we're testing online fsck.
+__stress_scrub_fsstress_loop() {
+	local end="$1"
+
+	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000 $FSSTRESS_AVOID)
+
+	while [ "$(date +%s)" -lt $end ]; do
+		$FSSTRESS_PROG $args >> $seqres.full
+	done
+}
+
+# Make sure we have everything we need to run stress and scrub
+_require_xfs_stress_scrub() {
+	_require_xfs_io_command "scrub"
+	_require_command "$KILLALL_PROG" killall
+	_require_freeze
+}
+
+# Make sure we have everything we need to run stress and online repair
+_require_xfs_stress_online_repair() {
+	_require_xfs_stress_scrub
+	_require_xfs_io_command "repair"
+	_require_xfs_io_error_injection "force_repair"
+	_require_freeze
+}
+
+# Clean up after the loops in case they didn't do it themselves.
+_scratch_xfs_stress_scrub_cleanup() {
+	$KILLALL_PROG -TERM xfs_io fsstress >> $seqres.full 2>&1
+	$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
+}
+
+# Start scrub, freeze, and fsstress in background looping processes, and wait
+# for 30*TIME_FACTOR seconds to see if the filesystem goes down.  Callers
+# must call _scratch_xfs_stress_scrub_cleanup from their cleanup functions.
+_scratch_xfs_stress_scrub() {
+	local start="$(date +%s)"
+	local end="$((start + (30 * TIME_FACTOR) ))"
+
+	echo "Loop started at $(date --date="@${start}")," \
+		   "ending at $(date --date="@${end}")" >> $seqres.full
+
+	__stress_scrub_fsstress_loop $end &
+	__stress_scrub_freeze_loop $end &
+	__stress_scrub_loop $end &
+
+	# Wait until 2 seconds after the loops should have finished, then
+	# clean up after ourselves.
+	while [ "$(date +%s)" -lt $((end + 2)) ]; do
+		sleep 1
+	done
+	_scratch_xfs_stress_scrub_cleanup
+
+	echo "Loop finished at $(date)" >> $seqres.full
+}
+
+# Start online repair, freeze, and fsstress in background looping processes,
+# and wait for 30*TIME_FACTOR seconds to see if the filesystem goes down.
+# Same requirements and arguments as _scratch_xfs_stress_scrub.
+_scratch_xfs_stress_online_repair() {
+	$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
+	_scratch_xfs_stress_scrub "$@"
+}
diff --git a/tests/xfs/422 b/tests/xfs/422
index 9ed944ed63..0bf08572f3 100755
--- a/tests/xfs/422
+++ b/tests/xfs/422
@@ -4,40 +4,19 @@
 #
 # FS QA Test No. 422
 #
-# Race freeze and rmapbt repair for a while to see if we crash or livelock.
+# Race fsstress and rmapbt repair for a while to see if we crash or livelock.
 # rmapbt repair requires us to freeze the filesystem to stop all filesystem
 # activity, so we can't have userspace wandering in and thawing it.
 #
 . ./common/preamble
 _begin_fstest online_repair dangerous_fsstress_repair freeze
 
-_register_cleanup "_cleanup" BUS
-
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
-	[ -n "$repair_pid" ] && kill $sig $repair_pid
-	wait
-	unset stress_pid
-	unset repair_pid
-}
-
-# Override the default cleanup function.
-_cleanup()
-{
-	kill_loops -9 > /dev/null 2>&1
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
 	cd /
-	rm -rf $tmp.*
+	rm -r -f $tmp.*
 }
+_register_cleanup "_cleanup" BUS
 
 # Import common functions.
 . ./common/filter
@@ -47,80 +26,13 @@ _cleanup()
 # real QA test starts here
 _supported_fs xfs
 _require_xfs_scratch_rmapbt
-_require_xfs_io_command "scrub"
-_require_xfs_io_error_injection "force_repair"
-_require_command "$KILLALL_PROG" killall
-_require_freeze
+_require_xfs_stress_online_repair
 
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
-cpus=$(( $($here/src/feature -o) * 4 * LOAD_FACTOR))
-
-echo "Concurrent repair"
-filter_output() {
-	grep -E -v '(Device or resource busy|Invalid argument)'
-}
-freeze_loop() {
-	end="$1"
-
-	while [ "$(date +%s)" -lt $end ]; do
-		$XFS_IO_PROG -x -c 'freeze' -c 'thaw' $SCRATCH_MNT 2>&1 | filter_output
-	done
-}
-repair_loop() {
-	end="$1"
-
-	while [ "$(date +%s)" -lt $end ]; do
-		$XFS_IO_PROG -x -c 'repair rmapbt 0' -c 'repair rmapbt 1' $SCRATCH_MNT 2>&1 | filter_output
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
-$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
-
-start=$(date +%s)
-end=$((start + (30 * TIME_FACTOR) ))
-
-echo "Loop started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
-stress_loop $end &
-stress_pid=$!
-freeze_loop $end &
-freeze_pid=$!
-repair_loop $end &
-repair_pid=$!
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
+_scratch_xfs_stress_online_repair
 
 # success, all done
+echo Silence is golden
 status=0
 exit
diff --git a/tests/xfs/422.out b/tests/xfs/422.out
index 3818c48fa8..f70693fde6 100644
--- a/tests/xfs/422.out
+++ b/tests/xfs/422.out
@@ -1,4 +1,2 @@
 QA output created by 422
-Format and populate
-Concurrent repair
-Test done
+Silence is golden

