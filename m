Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A49125A62C;
	Tue,  4 Feb 2025 21:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704374; cv=none; b=mCu39/UaVcaSVRKZbrVes40/qMMtoXcD0gGy2hFhzZ34SvjoU6VGstwMvCHzZBfohGZt/kAE7pxpjFE6yxiIRSyCNScmYKwjgDM02x2TMbbrP4mzHN7l9LCHKMvRDGjZF+KA9PQ1uJa0zLl43RrZkGmwlhdH88HVtFKB6cUcnMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704374; c=relaxed/simple;
	bh=sA3EM5ORVc1iBn2A0zIva4/KzIUZtofsyJLdhz9kKU0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQBD8vLWgv0QFC1/cwuYvOTgghP4FoQ4bBBtkGGujYL+6fMr+d7aONLp0dKhX4xJ2Jyefj7bdPmeDjvYSF0GJDikW+h9cztpj7xeBWelpfwDkmFgcdw23wO7/djx9AGHl1vjwgPcNNuPu6ojG/28MzYwOZtXWGDDPa1WzSpyPxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDPPadDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDPPadDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C53C4CEDF;
	Tue,  4 Feb 2025 21:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704374;
	bh=sA3EM5ORVc1iBn2A0zIva4/KzIUZtofsyJLdhz9kKU0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MDPPadDUq+UGQJ8FnXiL+DcWCUa0VTT4n02KiM8LdZ+gVWMJmTU5uasA6un8V1Ifz
	 kAUOBNGKV5Dck+UoMAUO8m+RP+sI1JCscCQOU/MJnUScdiSu+TboZKs/8kUkMii9n2
	 cfgudF6xeQWQ3OAkZxpkSabCLWeu9gnC0Imbz31ChoVX/1LBdi54d4PzeFCHEmRhKt
	 f+ggDxWij/rosgbdChda+BJKKt6AOUbpPZzmGX8y93qDKJH/PWI8Qu6j3wxtIxf6OL
	 5pxLImtmq2e0/UDAr5QVntwuZO7dwZUnQJZ3tHRI5yqeNKkicGNhFcELl+RTKU2PK/
	 kDl0BzyP7A0YA==
Date: Tue, 04 Feb 2025 13:26:13 -0800
Subject: [PATCH 15/34] check: run tests in a private pid/mount namespace
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406337.546134.5825194290554919668.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

As mentioned in the previous patch, trying to isolate processes from
separate test instances through the use of distinct Unix process
sessions is annoying due to the many complications with signal handling.

Instead, we could just use nsexec to run the test program with a private
pid namespace so that each test instance can only see its own processes;
and private mount namespace so that tests writing to /tmp cannot clobber
other tests or the stuff running on the main system.

However, it's not guaranteed that a particular kernel has pid and mount
namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces have
been around for a long time, but there's no hard requirement for the
latter to be enabled in the kernel.  Therefore, this bugfix slips
namespace support in alongside the session id thing.

Declaring CONFIG_PID_NS=n a deprecated configuration and removing
support should be a separate conversation, not something that I have to
do in a bug fix to get mainline QA back up.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check               |   34 +++++++++++++++++++++++-----------
 common/rc           |   12 ++++++++++--
 src/nsexec.c        |   18 +++++++++++++++---
 tests/generic/504   |   15 +++++++++++++--
 tools/run_seq_pidns |   28 ++++++++++++++++++++++++++++
 5 files changed, 89 insertions(+), 18 deletions(-)
 create mode 100755 tools/run_seq_pidns


diff --git a/check b/check
index d854515ed1aac5..24b21cf139f927 100755
--- a/check
+++ b/check
@@ -674,6 +674,11 @@ _stash_test_status() {
 	esac
 }
 
+# Can we run in a private pid/mount namespace?
+HAVE_PRIVATENS=
+./tools/run_seq_pidns bash -c "exit 77"
+test $? -eq 77 && HAVE_PRIVATENS=yes
+
 # Can we run systemd scopes?
 HAVE_SYSTEMD_SCOPES=
 systemctl reset-failed "fstests-check" &>/dev/null
@@ -691,22 +696,29 @@ _adjust_oom_score -500
 # the system runs out of memory it'll be the test that gets killed and not the
 # test framework.  The test is run in a separate process without any of our
 # functions, so we open-code adjusting the OOM score.
-#
-# If systemd is available, run the entire test script in a scope so that we can
-# kill all subprocesses of the test if it fails to clean up after itself.  This
-# is essential for ensuring that the post-test unmount succeeds.  Note that
-# systemd doesn't automatically remove transient scopes that fail to terminate
-# when systemd tells them to terminate (e.g. programs stuck in D state when
-# systemd sends SIGKILL), so we use reset-failed to tear down the scope.
-#
-# Use setsid to run the test program with a separate session id so that we
-# can pkill only the processes started by this test.
 _run_seq() {
 	local res
 	unset CHILDPID
 	unset FSTESTS_ISOL	# set by tools/run_seq_*
 
-	if [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
+	if [ -n "${HAVE_PRIVATENS}" ]; then
+		# If pid and mount namespaces are available, run the whole test
+		# inside them so that the test cannot access any process or
+		# /tmp contents that it does not itself create.  The ./$seq
+		# process is considered the "init" process of the pid
+		# namespace, so all subprocesses will be sent SIGKILL when it
+		# terminates.
+		./tools/run_seq_pidns "./$seq"
+		res=$?
+	elif [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
+		# If systemd is available, run the entire test script in a
+		# scope so that we can kill all subprocesses of the test if it
+		# fails to clean up after itself.  This is essential for
+		# ensuring that the post-test unmount succeeds.  Note that
+		# systemd doesn't automatically remove transient scopes that
+		# fail to terminate when systemd tells them to terminate (e.g.
+		# programs stuck in D state when systemd sends SIGKILL), so we
+		# use reset-failed to tear down the scope.
 		local unit="$(systemd-escape "fs$seq").scope"
 		systemctl reset-failed "${unit}" &> /dev/null
 		systemd-run --quiet --unit "${unit}" --scope \
diff --git a/common/rc b/common/rc
index bda80995f8dd55..25900533acb974 100644
--- a/common/rc
+++ b/common/rc
@@ -33,7 +33,11 @@ _test_sync()
 # Kill only the processes started by this test.
 _pkill()
 {
-	pkill --session 0 "$@"
+	if [ "$FSTESTS_ISOL" = "setsid" ]; then
+		pkill --session 0 "$@"
+	else
+		pkill "$@"
+	fi
 }
 
 # Common execution handling for fsstress invocation.
@@ -2736,7 +2740,11 @@ _require_user_exists()
 # not, passing $SHELL in this manner works both for "su" and "su -c cmd".
 _su()
 {
-	su --session-command $SHELL "$@"
+	if [ "$FSTESTS_ISOL" = "setsid" ]; then
+		su --session-command $SHELL "$@"
+	else
+		su "$@"
+	fi
 }
 
 # check if a user exists and is able to execute commands.
diff --git a/src/nsexec.c b/src/nsexec.c
index 750d52df129716..5c0bc922153514 100644
--- a/src/nsexec.c
+++ b/src/nsexec.c
@@ -54,6 +54,7 @@ usage(char *pname)
     fpe("            If -M or -G is specified, -U is required\n");
     fpe("-s          Set uid/gid to 0 in the new user namespace\n");
     fpe("-v          Display verbose messages\n");
+    fpe("-z          Return child's return value\n");
     fpe("\n");
     fpe("Map strings for -M and -G consist of records of the form:\n");
     fpe("\n");
@@ -144,6 +145,8 @@ int
 main(int argc, char *argv[])
 {
     int flags, opt;
+    int return_child_status = 0;
+    int child_status = 0;
     pid_t child_pid;
     struct child_args args;
     char *uid_map, *gid_map;
@@ -161,7 +164,7 @@ main(int argc, char *argv[])
     setid = 0;
     gid_map = NULL;
     uid_map = NULL;
-    while ((opt = getopt(argc, argv, "+imnpuUM:G:vs")) != -1) {
+    while ((opt = getopt(argc, argv, "+imnpuUM:G:vsz")) != -1) {
         switch (opt) {
         case 'i': flags |= CLONE_NEWIPC;        break;
         case 'm': flags |= CLONE_NEWNS;         break;
@@ -173,6 +176,7 @@ main(int argc, char *argv[])
         case 'G': gid_map = optarg;             break;
         case 'U': flags |= CLONE_NEWUSER;       break;
         case 's': setid = 1;                    break;
+        case 'z': return_child_status = 1;      break;
         default:  usage(argv[0]);
         }
     }
@@ -229,11 +233,19 @@ main(int argc, char *argv[])
 
     close(args.pipe_fd[1]);
 
-    if (waitpid(child_pid, NULL, 0) == -1)      /* Wait for child */
+    if (waitpid(child_pid, &child_status, 0) == -1)      /* Wait for child */
         errExit("waitpid");
 
     if (verbose)
-        printf("%s: terminating\n", argv[0]);
+        printf("%s: terminating %d\n", argv[0], WEXITSTATUS(child_status));
+
+    if (return_child_status) {
+        if (WIFEXITED(child_status))
+            exit(WEXITSTATUS(child_status));
+        if (WIFSIGNALED(child_status))
+            exit(WTERMSIG(child_status) + 128); /* like sh */
+	exit(EXIT_FAILURE);
+    }
 
     exit(EXIT_SUCCESS);
 }
diff --git a/tests/generic/504 b/tests/generic/504
index 271c040e7b842a..96f18a0bbc7ba2 100755
--- a/tests/generic/504
+++ b/tests/generic/504
@@ -18,7 +18,7 @@ _cleanup()
 {
 	exec {test_fd}<&-
 	cd /
-	rm -f $tmp.*
+	rm -r -f $tmp.*
 }
 
 # Import common functions.
@@ -35,13 +35,24 @@ echo inode $tf_inode >> $seqres.full
 
 # Create new fd by exec
 exec {test_fd}> $testfile
-# flock locks the fd then exits, we should see the lock info even the owner is dead
+# flock locks the fd then exits, we should see the lock info even the owner is
+# dead.  If we're using pid namespace isolation we have to move /proc so that
+# we can access the /proc/locks from the init_pid_ns.
+if [ "$FSTESTS_ISOL" = "privatens" ]; then
+	move_proc="$tmp.procdir"
+	mkdir -p "$move_proc"
+	mount --move /proc "$move_proc"
+fi
 flock -x $test_fd
 cat /proc/locks >> $seqres.full
 
 # Checking
 grep -q ":$tf_inode " /proc/locks || echo "lock info not found"
 
+if [ -n "$move_proc" ]; then
+	mount --move "$move_proc" /proc
+fi
+
 # success, all done
 status=0
 echo "Silence is golden"
diff --git a/tools/run_seq_pidns b/tools/run_seq_pidns
new file mode 100755
index 00000000000000..df94974ab30c3c
--- /dev/null
+++ b/tools/run_seq_pidns
@@ -0,0 +1,28 @@
+#!/bin/bash
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# Try starting things in a private pid/mount namespace with a private /tmp
+# and /proc so that child process trees cannot interfere with each other.
+
+if [ -n "${FSTESTS_ISOL}" ]; then
+	for path in /proc /tmp; do
+		mount --make-private "$path"
+	done
+	mount -t proc proc /proc
+	mount -t tmpfs tmpfs /tmp
+
+	# Allow the test to become a target of the oom killer
+	oom_knob="/proc/self/oom_score_adj"
+	test -w "${oom_knob}" && echo 250 > "${oom_knob}"
+
+	exec "$@"
+fi
+
+if [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 command [args...]"
+	exit 1
+fi
+
+FSTESTS_ISOL=privatens exec "$(dirname "$0")/../src/nsexec" -z -m -p "$0" "$@"

