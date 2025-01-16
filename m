Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A73232438;
	Thu, 16 Jan 2025 23:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070036; cv=none; b=OPV7KBmo0glB1arbWxk3CMZWSuSq9X8jBZO8qhh6rR3OSdrvKVDD6+Hzy8gzTFisZc/Ox3ialdOF2ZL/jcfIx1fsbZt5edxFYp5C3ROwWFTbuVgBZ/uGqlCiXEeIy0lP6IcUbqzQKe4/rucCXQsS6evI11lhMuACZZvTB3I2q9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070036; c=relaxed/simple;
	bh=oMzGVeg4ZdgtOWYLq0T6ROEUmRySL652sqQCJMoVQ1M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qaXrDiAfvS+o05b73k3e6GDkTNwtoDanDZyn1AAxRVBLZ4cIlV32iBIvWEhZdUcJ3R28XWUE689xGmFMh3FyLvValZoTbsi/gJi3998ximqdVMpIk3j6zTRAmVw9GDuVHr8traCXVH1hF+rPATlcbkh7UG1kJV6TD0KH6BCqguw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iwT1tyHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iwT1tyHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1086BC4CED6;
	Thu, 16 Jan 2025 23:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070036;
	bh=oMzGVeg4ZdgtOWYLq0T6ROEUmRySL652sqQCJMoVQ1M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iwT1tyHXkxOSbJLJObSW6aNUg0PX1frwi8hAIalRvZyvzqN5tH5ur0vGvjU6KeA8x
	 ddNhvgJtpYyYluQNv2H79THAauonYtKZTav4kWADA9KKbNOrfIKxW/LsZtDHe6WMiG
	 I5/38GDFszh+hNWZMNXlBGbNA4ZtzkBhzCiB+tWLqxgsZFTPxqPIaPa6vMgrrQz3QK
	 qYdjslYl3dSf9mLPqYBWjM5ewk8jf6nvdRkr6cB2PqAOqrK74aCDCXbZe96PmWS0sM
	 Wevx8k0NVUbM9rappgL+VQwOnw9CAwCOT45bYXSamCVSRR7XqPtzZI6NH5no2jUqGh
	 e8q6Y7L7uBYYQ==
Date: Thu, 16 Jan 2025 15:27:15 -0800
Subject: [PATCH 08/23] common: fix pkill by running test program in a separate
 session
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Run each test program with a separate session id so that we can tell
pkill to kill all processes of a given name, but only within our own
session id.  This /should/ suffice to run multiple fstests on the same
machine without one instance shooting down processes of another
instance.

This fixes a general problem with using "pkill --parent" -- if the
process being targeted is not a direct descendant of the bash script
calling pkill, then pkill will not do anything.  The scrub stress tests
make use of multiple background subshells, which is how a ^C in the
parent process fails to result in fsx/fsstress being killed.

This is necessary to fix SOAK_DURATION runtime constraints for all the
scrub stress tests.  However, there is a cost -- the test program no
longer runs with the same controlling tty as ./check, which means that
^Z doesn't work and SIGINT/SIGQUIT are set to SIG_IGN.  IOWs, if a test
wants to kill its subprocesses, it must use another signal such as
SIGPIPE.  Fortunately, bash doesn't whine about children dying due to
fatal signals if the children run in a different session id.

I also explored alternate designs, and this was the least unsatisfying:

a) Setting the process group didn't work because background subshells
are assigned a new group id.

b) Constraining the pkill/pgrep search to a cgroup could work, but we'd
have to set up a cgroup in which to run the fstest.

c) Putting test subprocesses in a systemd sub-scope and telling systemd
to kill the sub-scope could work because ./check can already use it to
ensure that all child processes of a test are killed.  However, this is
an *optional* feature, which means that we'd have to require systemd.

d) Constraining the pkill/pgrep search to a particular mount namespace
could work, but we already have tests that set up their own mount
namespaces, which means the constrained pgrep will not find all child
processes of a test.

e) Constraining to any other type of namespace (uts, pid, etc) might not
work because those namespaces might not be enabled.

f) Revert check-parallel and go back to one fstests instance per system.
Zorro already chose not to revert.

So.  Change _run_seq to create a the ./$seq process with a new session
id, update _su calls to use the same session as the parent test, update
all the pkill sites to use a wrapper so that we only target processes
created by *this* instance of fstests, and update SIGINT to SIGPIPE.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check             |   33 ++++++++++++++++++++++++++++-----
 common/fuzzy      |   17 ++++++++---------
 common/rc         |   12 ++++++++++--
 tests/generic/310 |    6 +++---
 tests/generic/561 |    2 +-
 5 files changed, 50 insertions(+), 20 deletions(-)


diff --git a/check b/check
index 607d2456e6a1fe..bafe48bf12db67 100755
--- a/check
+++ b/check
@@ -698,18 +698,41 @@ _adjust_oom_score -500
 # systemd doesn't automatically remove transient scopes that fail to terminate
 # when systemd tells them to terminate (e.g. programs stuck in D state when
 # systemd sends SIGKILL), so we use reset-failed to tear down the scope.
+#
+# Use setsid to run the test program with a separate session id so that we
+# can pkill only the processes started by this test.
 _run_seq() {
-	local cmd=(bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq")
+	local cmd=(bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec setsid bash ./$seq")
 
 	if [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
 		local unit="$(systemd-escape "fs$seq").scope"
 		systemctl reset-failed "${unit}" &> /dev/null
-		systemd-run --quiet --unit "${unit}" --scope "${cmd[@]}"
+		systemd-run --quiet --unit "${unit}" --scope "${cmd[@]}" &
+		CHILDPID=$!
+		wait
 		res=$?
+		unset CHILDPID
 		systemctl stop "${unit}" &> /dev/null
 		return "${res}"
 	else
-		"${cmd[@]}"
+		# bash won't run the SIGINT trap handler while there are
+		# foreground children in a separate session, so we must run
+		# the test in the background and wait for it.
+		"${cmd[@]}" &
+		CHILDPID=$!
+		wait
+		unset CHILDPID
+	fi
+}
+
+_kill_seq() {
+	if [ -n "$CHILDPID" ]; then
+		# SIGPIPE will kill all the children (including fsstress)
+		# without bash logging fatal signal termination messages to the
+		# console
+		pkill -PIPE --session "$CHILDPID"
+		wait
+		unset CHILDPID
 	fi
 }
 
@@ -718,9 +741,9 @@ _prepare_test_list
 fstests_start_time="$(date +"%F %T")"
 
 if $OPTIONS_HAVE_SECTIONS; then
-	trap "_summary; exit \$status" 0 1 2 3 15
+	trap "_kill_seq; _summary; exit \$status" 0 1 2 3 15
 else
-	trap "_wrapup; exit \$status" 0 1 2 3 15
+	trap "_kill_seq; _wrapup; exit \$status" 0 1 2 3 15
 fi
 
 function run_section()
diff --git a/common/fuzzy b/common/fuzzy
index 0a2d91542b561e..772ce7ddcff6d8 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -891,7 +891,7 @@ __stress_xfs_scrub_loop() {
 	local runningfile="$2"
 	local scrub_startat="$3"
 	shift; shift; shift
-	local sigint_ret="$(( $(kill -l SIGINT) + 128 ))"
+	local signal_ret="$(( $(kill -l SIGPIPE) + 128 ))"
 	local scrublog="$tmp.scrub"
 
 	while __stress_scrub_running "$scrub_startat" "$runningfile"; do
@@ -901,8 +901,8 @@ __stress_xfs_scrub_loop() {
 	while __stress_scrub_running "$end" "$runningfile"; do
 		_scratch_scrub "$@" &> $scrublog
 		res=$?
-		if [ "$res" -eq "$sigint_ret" ]; then
-			# Ignore SIGINT because the cleanup function sends
+		if [ "$res" -eq "$signal_ret" ]; then
+			# Ignore SIGPIPE because the cleanup function sends
 			# that to terminate xfs_scrub
 			res=0
 		fi
@@ -1173,13 +1173,11 @@ _scratch_xfs_stress_scrub_cleanup() {
 	rm -f "$runningfile"
 	echo "Cleaning up scrub stress run at $(date)" >> $seqres.full
 
-	# Send SIGINT so that bash won't print a 'Terminated' message that
-	# distorts the golden output.
 	echo "Killing stressor processes at $(date)" >> $seqres.full
-	_kill_fsstress
-	pkill -INT --parent $$ xfs_io >> $seqres.full 2>&1
-	pkill -INT --parent $$ fsx >> $seqres.full 2>&1
-	pkill -INT --parent $$ xfs_scrub >> $seqres.full 2>&1
+	_pkill --echo -PIPE fsstress >> $seqres.full 2>&1
+	_pkill --echo -PIPE xfs_io >> $seqres.full 2>&1
+	_pkill --echo -PIPE fsx >> $seqres.full 2>&1
+	_pkill --echo -PIPE xfs_scrub >> $seqres.full 2>&1
 
 	# Tests are not allowed to exit with the scratch fs frozen.  If we
 	# started a fs freeze/thaw background loop, wait for that loop to exit
@@ -1209,6 +1207,7 @@ _scratch_xfs_stress_scrub_cleanup() {
 	# Wait for the remaining children to exit.
 	echo "Waiting for children to exit at $(date)" >> $seqres.full
 	wait
+	echo "Children exited as of $(date)" >> $seqres.full
 
 	# Ensure the scratch fs is also writable before we exit.
 	if [ -n "$__SCRUB_STRESS_REMOUNT_LOOP" ]; then
diff --git a/common/rc b/common/rc
index 459be11c11c405..d143ba36265c6c 100644
--- a/common/rc
+++ b/common/rc
@@ -30,6 +30,12 @@ _test_sync()
 	_sync_fs $TEST_DIR
 }
 
+# Kill only the test processes started by this test
+_pkill()
+{
+	pkill --session 0 "$@"
+}
+
 # Common execution handling for fsstress invocation.
 #
 # We need per-test fsstress binaries because of the way fsstress forks and
@@ -69,7 +75,7 @@ _kill_fsstress()
 	if [ -n "$_FSSTRESS_PID" ]; then
 		# use SIGPIPE to avoid "Killed" messages from bash
 		echo "killing $_FSSTRESS_BIN" >> $seqres.full
-		pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
+		_pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
 		_wait_for_fsstress
 		return $?
 	fi
@@ -2740,9 +2746,11 @@ _require_user_exists()
 	[ "$?" == "0" ] || _notrun "$user user not defined."
 }
 
+# Run all non-root processes in the same session as the root.  Believe it or
+# not, passing $SHELL in this manner works both for "su" and "su -c cmd".
 _su()
 {
-	su "$@"
+	su --session-command $SHELL "$@"
 }
 
 # check if a user exists and is able to execute commands.
diff --git a/tests/generic/310 b/tests/generic/310
index 52babfdc803a21..570cc5f3859548 100755
--- a/tests/generic/310
+++ b/tests/generic/310
@@ -29,7 +29,7 @@ _begin_fstest auto
 # Override the default cleanup function.
 _cleanup()
 {
-	pkill -9 $seq.t_readdir > /dev/null 2>&1
+	_pkill -9 $seq.t_readdir > /dev/null 2>&1
 	wait
 	rm -rf $TEST_DIR/tmp
 	rm -f $tmp.*
@@ -83,7 +83,7 @@ _test_read()
 {
 	 $TEST_DIR/$seq.t_readdir_1 $SEQ_DIR > /dev/null 2>&1 &
 	sleep $RUN_TIME
-	pkill -PIPE $seq.t_readdir_1
+	_pkill -PIPE $seq.t_readdir_1
 	wait
 
 	check_kernel_bug
@@ -97,7 +97,7 @@ _test_lseek()
 	$TEST_DIR/$seq.t_readdir_2 $SEQ_DIR > /dev/null 2>&1 &
 	readdir_pid=$!
 	sleep $RUN_TIME
-	pkill -PIPE $seq.t_readdir_2
+	_pkill -PIPE $seq.t_readdir_2
 	wait
 
 	check_kernel_bug
diff --git a/tests/generic/561 b/tests/generic/561
index afe727ac56cbd9..b260aaf16c9256 100755
--- a/tests/generic/561
+++ b/tests/generic/561
@@ -40,7 +40,7 @@ function end_test()
 	# stop duperemove running
 	if [ -e $dupe_run ]; then
 		rm -f $dupe_run
-		pkill $dedup_bin >/dev/null 2>&1
+		_pkill $dedup_bin >/dev/null 2>&1
 		wait $dedup_pids
 		rm -f $dedup_prog
 	fi

