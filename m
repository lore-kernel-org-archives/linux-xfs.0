Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642124;
	b=5Y00xyv6ziAramK1HDl+TIQk1ae6Mbr03qy5oIxvVEoPZ+gLDrmbLSpbEP+lY2S5Bben
	 6SgXa8LMFLePSR0uuqAUujXPiQxMw0D1h36Ydhz8RA4TAFujuvNs0y1OwRIup4nwrb5Ac
	 G6j78GDtEtTdcJyZft1p+gPUG5QFJvXYmuvTeySl2iRC4rOndw6umRqCh0ViKLgt+LAiz
	 h18Pw4Pu197c+xdRap6skfv8zcQ7yEfdZpCS3iRyW9xsxXheaDs2Xfs8uSu63MoLum0Su
	 y6uaDeJZKdWifR9P9lQlrCslvjmamV0mLLF1TuV+2uKRgwsH9vNa1qpLyUTqYPmEpsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=gpx4DOuL4JzICUbBZ8OCXdLFPpauat4q7Z4GhUCuBFU=;
	b=KcJkWARPJC/7n+RSme1gZomoCfsmIBnzKxRYHQWk2+xdIbOlXcS3JXpiIcwM+ksF505S
	 7ZX2ckraKPjcNRNenIFd+M0OA69VaGy5hrX+P2ZIGYK+zVh2qAimhH8g3MUaNeL77Y2Yo
	 Qda87TGbXMjaaPn7OZLbrrqBOSUBtSkRp23B4GRK6I3x2CwYsyhNOKH9hIoHBcK1gN4pp
	 lIlMYYLb89jNO/vK0GlgAIkBFScPp09HKerxBYTNVLkplAmyxwpPNzsexBeqAdmOvaAVy
	 DCdSPL448CfXKblNfHxtDc3mQdQIf0LYWxsrN6/JxGpiVQofYwH1CeOoqDDQFXFvgzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nJxea/W9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED58606A31E;
	Wed, 25 Nov 2026 21:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nJxea/W9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D611F000D4;
	Wed, 25 Nov 2026 21:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642124;
	bh=gpx4DOuL4JzICUbBZ8OCXdLFPpauat4q7Z4GhUCuBFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJxea/W9TzWemDuZ3MzGX8fcedcF0NP78n/WqA93ieyVZzjpUMicJ16nn0mjYkvt9
	 Ck5UHrM5Kab7b7kbozPhOVyieSqB84OXCUsa2Y+Ry8e9lQEWQ5K5DYrYGZEurVO7J9
	 GV0XrbXL07SprhvWeL3uWZ3WWFDe1SwL8A50su+LyhBfrSi/w2raroU4VYrKmQAq1C
	 iM5F49TohOUhQtB5dDoP++oL5blQkP9UHMB5d+Ww84ynjkZ7laFKRBp1NIh5E/8DrA
	 bQCHA6iOXxIf2nEJu813RGpOslXoHncJUdtWcbb+JEZ1FeTg6UJGIzoAx/Wf8LNJ/F
	 czTbO2t9v3A9A==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	cem@kernel.org,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 2/6] common: add out-of-process hook mode
Date: Thu, 26 Nov 2026 05:28:19 +0800
Message-ID: <20261125212823.3389430-3-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261125212823.3389430-1-zlang@kernel.org>
References: <20261125212823.3389430-1-zlang@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add mode=out to the --hook-* options to run hooks as standalone
executables rather than sourcing them in-process. This allows hooks
to be written in any language. In-process sourcing remains the
default (mode=in).

Both modes expose the same context to hooks:
- Test name and result as $1 and $2
- HOOK_EVENT and runtime variables
- Variables from 'check' listed in HOOK_ENV_LIST

Hooks always receive the full set of variables, with any irrelevant
or missing values left empty. Since out-of-process hooks do not share
the test shell environment, check explicitly passes this context to
them, whereas in-process hooks inherit it directly.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/hooks | 107 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 81 insertions(+), 26 deletions(-)

diff --git a/common/hooks b/common/hooks
index b40028f2..abbdc04d 100644
--- a/common/hooks
+++ b/common/hooks
@@ -1,13 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # Test hooks let you customize a test run without modifying fstests.
-# Each hook is a bash script that 'check' sources in a subshell at
-# specific points during a test, with full access to the test
-# environment (devices, mount points, options, and fstests helpers).
+# Each hook is a script or executable that 'check' runs at specific
+# points during a test.
 #
 # Register hooks on the command line:
 #
-#	--hook-pre-test path=/path/to/script[,match=<glob>]...
+#	--hook-pre-test path=/path/to/script[,mode=in|out][,match=<glob>]...
 #
 # --hook-post-test and --hook-post-result take the same format. These
 # options can be repeated; hooks run in the order given. Without a
@@ -19,27 +18,51 @@
 # Tilde (~) expansion is not supported; use $HOME or an absolute path.
 # Match patterns cannot contain whitespace or commas.
 #
-# Each hook script should define a hook_execute() function, which is
-# invoked with:
+# The default mode is "in": the script is sourced in a subshell and
+# has full access to the test environment (devices, mount points,
+# options, and fstests helpers). It should define hook_execute();
+# scripts without it are silently skipped.
+#
+# With mode=out, the hook runs as a standalone executable (written in
+# any language). It has no access to the test shell environment and
+# receives the hook context described below instead.
+#
+# Both modes receive the same context:
 #
 #	$1		test name (e.g. generic/482)
 #	$2		status: test exit code (post-test), final result
 #			such as pass/fail/notrun/expunge (post-result),
-#			or unset (pre-test)
+#			or invalid (pre-test)
 #	HOOK_EVENT	the event name (pre-test, post-test, post-result)
-#	runtime		test runtime in seconds (if applicable)
+#	runtime		test runtime in seconds (post-result only; invalid
+#			for pre-test and post-test)
+#	<HOOK_ENV_LIST>	test variables exposed by 'check' (see below)
 #	cwd		$here
+#	stdin		/dev/null
 #	stdout/stderr	appended to $seqres.hooks
 #
-# Scripts that don't define hook_execute() are silently skipped. Hook
-# failures are logged to $seqres.hooks and never affect the test result.
+# Hook failures are logged to $seqres.hooks and never affect the test
+# result. mode=out requires env(1).
+
+# Variables exported to mode=out hooks (mode=in hooks already inherit
+# them from the test environment). Unconfigured variables may be empty.
+# Add to this list if hooks need more context from 'check'.
+HOOK_ENV_LIST=(
+	FSTYP section iters
+	TEST_DEV TEST_DIR SCRATCH_DEV SCRATCH_MNT
+	MKFS_OPTIONS MOUNT_OPTIONS
+	RESULT_BASE REPORT_DIR seqres seqnum
+)
 
 _hook_pre_test_paths=()
 _hook_pre_test_matches=()
+_hook_pre_test_modes=()
 _hook_post_test_paths=()
 _hook_post_test_matches=()
+_hook_post_test_modes=()
 _hook_post_result_paths=()
 _hook_post_result_matches=()
+_hook_post_result_modes=()
 
 # Parse a single --hook-<event> option and record it in the per-event
 # arrays. Repeated options are preserved in the order given.
@@ -47,7 +70,7 @@ _hook_parse_args()
 {
 	local event="$1" args="$2"
 	local opts pair key value
-	local path="" matches=()
+	local path="" matches=() mode="in"
 
 	case "$event" in
 	pre-test|post-test|post-result)
@@ -72,6 +95,11 @@ _hook_parse_args()
 		match)
 			matches+=("$value")
 			;;
+		mode)
+			[ "$value" = "in" -o "$value" = "out" ] || \
+				_fatal "hook $event: invalid mode '$value'"
+			mode="$value"
+			;;
 		*)
 			_fatal "hook $event: unknown option '$key'"
 			;;
@@ -83,20 +111,32 @@ _hook_parse_args()
 	/*)	;;
 	*)	path="$here/$path" ;;
 	esac
-	[ -r "$path" ] || _fatal "hook $event: hook script not readable: $path"
+	case "$mode" in
+	in)
+		[ -r "$path" ] || \
+			_fatal "hook $event: hook script not readable: $path"
+		;;
+	out)
+		[ -x "$path" ] || \
+			_fatal "hook $event: program not executable: $path"
+		;;
+	esac
 
 	case "$event" in
 	pre-test)
 		_hook_pre_test_paths+=("$path")
 		_hook_pre_test_matches+=("${matches[*]}")
+		_hook_pre_test_modes+=("$mode")
 		;;
 	post-test)
 		_hook_post_test_paths+=("$path")
 		_hook_post_test_matches+=("${matches[*]}")
+		_hook_post_test_modes+=("$mode")
 		;;
 	post-result)
 		_hook_post_result_paths+=("$path")
 		_hook_post_result_matches+=("${matches[*]}")
+		_hook_post_result_modes+=("$mode")
 		;;
 	esac
 }
@@ -115,23 +155,35 @@ _hook_matches()
 	return 1
 }
 
-# Run a single hook in a subshell if its patterns match $test_seqnum.
-# Output and errors go to $seqres.hooks; failures never fail the test.
+# Run a single hook if its patterns match $test_seqnum. Output and
+# errors go to $seqres.hooks; failures never fail the test.
 _hook_run_one()
 {
 	local event="$1" test_seqnum="$2" status="$3" runtime="$4"
-	local path="$5" patterns="$6"
-	local rc log="$seqres.hooks"
+	local path="$5" patterns="$6" mode="$7"
+	local rc log="$seqres.hooks" hook_env=() v
 
 	_hook_matches "$test_seqnum" "$patterns" || return 0
 
-	(
-		export HOOK_EVENT="$event"
-		export runtime="$runtime"
-		. "$path"
-		declare -F hook_execute > /dev/null || return 0
-		hook_execute "$test_seqnum" ${status:+"$status"}
-	) >> "$log" 2>&1
+	case "$mode" in
+	in)
+		(
+			export HOOK_EVENT="$event"
+			export runtime="$runtime"
+			. "$path"
+			declare -F hook_execute > /dev/null || return 0
+			hook_execute "$test_seqnum" "$status"
+		) < /dev/null >> "$log" 2>&1
+		;;
+	out)
+		for v in "${HOOK_ENV_LIST[@]}"; do
+			hook_env+=("$v=${!v}")
+		done
+		hook_env+=(HOOK_EVENT="$event" runtime="$runtime")
+		env "${hook_env[@]}" "$path" "$test_seqnum" "$status" \
+			< /dev/null >> "$log" 2>&1
+		;;
+	esac
 	rc=$?
 	if [ $rc -ne 0 ]; then
 		echo "hook $event: $path failed (exit code $rc)" >> "$log"
@@ -152,7 +204,8 @@ _hook_run_event()
 			_hook_run_one "$event" "$test_seqnum" \
 				"$status" "$runtime" \
 				"${_hook_pre_test_paths[$i]}" \
-				"${_hook_pre_test_matches[$i]}"
+				"${_hook_pre_test_matches[$i]}" \
+				"${_hook_pre_test_modes[$i]}"
 		done
 		;;
 	post-test)
@@ -160,7 +213,8 @@ _hook_run_event()
 			_hook_run_one "$event" "$test_seqnum" \
 				"$status" "$runtime" \
 				"${_hook_post_test_paths[$i]}" \
-				"${_hook_post_test_matches[$i]}"
+				"${_hook_post_test_matches[$i]}" \
+				"${_hook_post_test_modes[$i]}"
 		done
 		;;
 	post-result)
@@ -168,7 +222,8 @@ _hook_run_event()
 			_hook_run_one "$event" "$test_seqnum" \
 				"$status" "$runtime" \
 				"${_hook_post_result_paths[$i]}" \
-				"${_hook_post_result_matches[$i]}"
+				"${_hook_post_result_matches[$i]}" \
+				"${_hook_post_result_modes[$i]}"
 		done
 		;;
 	esac
-- 
2.56.0

