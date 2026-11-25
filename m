Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642120;
	b=D8YPE9JaJauWdZkuzg0g9pizDG10gam1Yv6BxMH8FVtdTvn2NWe0ZtBz+fXJ599FlWHR
	 4wtfyQxbFDkYzmZZhNlyo9VhOfTxUwqTJlkTBHEEZBymMS8xm+dz1X2ZNKfpwiiCxgxQF
	 /2yLUDV+gGZGoDWtdyl0YDsYTF/4r/9YuR3K2TAcxfh0yYO1DtHkkckMxQo2I8cb01k41
	 /98guL6l/3wt74PRZ2qv59dFeanKHWIYIN7tPeQcJTsVOcPvK7exNr+656FWNBqslKVuu
	 WXAvTavLPGjMQcfhzVzdvfhQJES83cqO8RDXWoFLE/l9vWr0pfojY6vM02iTe6We1sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=9UtX7zzVSsMJUzryDrNCvwr0ZC0Em9X8CNc1KVGMoFY=;
	b=E1uhAdsQZCuteXin2sgoF93t/GBgnrBdFsJ23HGHHguVJqpCPgNXb2GTGIlw9q7GCzpn
	 KyrUkEV4EU7+hQwOdnVCbHXdI5S2Bi58WnfPFyKvpHrXR4USefTgVrC/d99YvtHrtO3Wq
	 IIMKTcvL4RjO/4MPEIRn+q/NKcz7V4/EFnjf/xUV3bm9g4oFwAbpbWkMhSUKtxv1YgE1/
	 SOD42KpX0E35LT2PKETrkGepgLBVqNFWZZA2Ie98OfiJelAGlUXeHOLx4PTYTjv0in9Nv
	 cIWVj+o8jQxYNpM/9LfSO+/ZnRnR55ultthSQ769Uhjqj5Lqk7uSYiNHXS733IP0vBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iTVDBgnj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9BC606A336;
	Wed, 25 Nov 2026 21:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iTVDBgnj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05041F000C0;
	Wed, 25 Nov 2026 21:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642120;
	bh=9UtX7zzVSsMJUzryDrNCvwr0ZC0Em9X8CNc1KVGMoFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTVDBgnjjApXyqlkRfWnFEOXA8y8ZcL6t07dfDIemezlwhNVf4ZUmVgIlo7UK61BM
	 PZ6ReclAlyr6zIT//XKXXd/d3Wuyev7UVCVANO9l/I/K8KFpXnf2UZptkOONyyeUh9
	 JZynEqACkzCH0WbFdoLyyyGvapBCQh34QwdEXhsVLtMLjZQXpuSwPZLcRTBQfhVC+b
	 V8N1a5vmXyZxtqBiRVVJ0FA1m6fE0GMnW+KJhvQFQdqqmeVfLg+rNq4q6T1xcV8XIc
	 eIL4QTjI4QsvwXzmPoR7nNDqpjdopiaMJFpY67eRQCuEH00fNsY5wkKdCK+2STyw2V
	 /ZFqdkltI6HnQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	cem@kernel.org,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 1/6] common: add builtin test hook infrastructure
Date: Thu, 26 Nov 2026 05:28:18 +0800
Message-ID: <20261125212823.3389430-2-zlang@kernel.org>
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

From: Dave Chinner <dchinner@redhat.com>

Add support for user-defined test hooks so users can customize a
test run without modifying fstests. Each hook is a bash script that
defines hook_execute(). 'check' sources it in a subshell at specific
points during a test, giving it full access to the test environment
(devices, mount points, options, and fstests helpers).

Hooks are registered as:

  --hook-pre-test path=/path/to/script[,match=<glob>]...

--hook-post-test and --hook-post-result take the same format. These
options can be repeated; hooks run in the order given. Without a
match pattern, a hook runs for every test; otherwise, it runs only
when the test name (<type>/<seq>, e.g. generic/482) matches at least
one of the glob patterns.

hook_execute() is passed the test name, along with the exit code
(post-test) or final result (post-result). Hook output is saved to
$seqres.hooks, and hook failures are logged without affecting the
test result.

Based on Dave Chinner's hook infrastructure RFC:
https://lore.kernel.org/all/20210722064725.3077558-1-david@fromorbit.com/

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/hooks | 175 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 175 insertions(+)
 create mode 100644 common/hooks

diff --git a/common/hooks b/common/hooks
new file mode 100644
index 00000000..b40028f2
--- /dev/null
+++ b/common/hooks
@@ -0,0 +1,175 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test hooks let you customize a test run without modifying fstests.
+# Each hook is a bash script that 'check' sources in a subshell at
+# specific points during a test, with full access to the test
+# environment (devices, mount points, options, and fstests helpers).
+#
+# Register hooks on the command line:
+#
+#	--hook-pre-test path=/path/to/script[,match=<glob>]...
+#
+# --hook-post-test and --hook-post-result take the same format. These
+# options can be repeated; hooks run in the order given. Without a
+# match pattern, a hook runs for every test; otherwise, it runs only
+# when the test name (<type>/<seq>, e.g. generic/482) matches at least
+# one of the glob patterns.
+#
+# Relative paths are resolved from $here (the fstests root directory).
+# Tilde (~) expansion is not supported; use $HOME or an absolute path.
+# Match patterns cannot contain whitespace or commas.
+#
+# Each hook script should define a hook_execute() function, which is
+# invoked with:
+#
+#	$1		test name (e.g. generic/482)
+#	$2		status: test exit code (post-test), final result
+#			such as pass/fail/notrun/expunge (post-result),
+#			or unset (pre-test)
+#	HOOK_EVENT	the event name (pre-test, post-test, post-result)
+#	runtime		test runtime in seconds (if applicable)
+#	cwd		$here
+#	stdout/stderr	appended to $seqres.hooks
+#
+# Scripts that don't define hook_execute() are silently skipped. Hook
+# failures are logged to $seqres.hooks and never affect the test result.
+
+_hook_pre_test_paths=()
+_hook_pre_test_matches=()
+_hook_post_test_paths=()
+_hook_post_test_matches=()
+_hook_post_result_paths=()
+_hook_post_result_matches=()
+
+# Parse a single --hook-<event> option and record it in the per-event
+# arrays. Repeated options are preserved in the order given.
+_hook_parse_args()
+{
+	local event="$1" args="$2"
+	local opts pair key value
+	local path="" matches=()
+
+	case "$event" in
+	pre-test|post-test|post-result)
+		;;
+	*)
+		_fatal "hook $event: unknown event"
+		;;
+	esac
+
+	IFS=, read -ra opts <<< "$args"
+	for pair in "${opts[@]}"; do
+		key="${pair%%=*}"
+		value="${pair#*=}"
+		if [ "$key" = "$pair" ]; then
+			_fatal "hook $event: expected key=value, got '$pair'"
+		fi
+		case "$key" in
+		path)
+			[ -z "$path" ] || _fatal "hook $event: duplicate 'path'"
+			path="$value"
+			;;
+		match)
+			matches+=("$value")
+			;;
+		*)
+			_fatal "hook $event: unknown option '$key'"
+			;;
+		esac
+	done
+
+	[ -n "$path" ] || _fatal "hook $event: missing 'path'"
+	case "$path" in
+	/*)	;;
+	*)	path="$here/$path" ;;
+	esac
+	[ -r "$path" ] || _fatal "hook $event: hook script not readable: $path"
+
+	case "$event" in
+	pre-test)
+		_hook_pre_test_paths+=("$path")
+		_hook_pre_test_matches+=("${matches[*]}")
+		;;
+	post-test)
+		_hook_post_test_paths+=("$path")
+		_hook_post_test_matches+=("${matches[*]}")
+		;;
+	post-result)
+		_hook_post_result_paths+=("$path")
+		_hook_post_result_matches+=("${matches[*]}")
+		;;
+	esac
+}
+
+# Return 0 if $test_seqnum matches any of the space-separated patterns,
+# or if no patterns are specified.
+_hook_matches()
+{
+	local test_seqnum="$1" patterns="$2"
+	local p
+
+	[ -z "$patterns" ] && return 0
+	for p in $patterns; do
+		[[ "$test_seqnum" == $p ]] && return 0
+	done
+	return 1
+}
+
+# Run a single hook in a subshell if its patterns match $test_seqnum.
+# Output and errors go to $seqres.hooks; failures never fail the test.
+_hook_run_one()
+{
+	local event="$1" test_seqnum="$2" status="$3" runtime="$4"
+	local path="$5" patterns="$6"
+	local rc log="$seqres.hooks"
+
+	_hook_matches "$test_seqnum" "$patterns" || return 0
+
+	(
+		export HOOK_EVENT="$event"
+		export runtime="$runtime"
+		. "$path"
+		declare -F hook_execute > /dev/null || return 0
+		hook_execute "$test_seqnum" ${status:+"$status"}
+	) >> "$log" 2>&1
+	rc=$?
+	if [ $rc -ne 0 ]; then
+		echo "hook $event: $path failed (exit code $rc)" >> "$log"
+	fi
+}
+
+# Run all hooks registered for $event that match $test_seqnum, in the
+# order they were given. $status and $runtime are optional and depend
+# on the event.
+_hook_run_event()
+{
+	local event="$1" test_seqnum="$2" status="$3" runtime="$4"
+	local i
+
+	case "$event" in
+	pre-test)
+		for ((i = 0; i < ${#_hook_pre_test_paths[@]}; i++)); do
+			_hook_run_one "$event" "$test_seqnum" \
+				"$status" "$runtime" \
+				"${_hook_pre_test_paths[$i]}" \
+				"${_hook_pre_test_matches[$i]}"
+		done
+		;;
+	post-test)
+		for ((i = 0; i < ${#_hook_post_test_paths[@]}; i++)); do
+			_hook_run_one "$event" "$test_seqnum" \
+				"$status" "$runtime" \
+				"${_hook_post_test_paths[$i]}" \
+				"${_hook_post_test_matches[$i]}"
+		done
+		;;
+	post-result)
+		for ((i = 0; i < ${#_hook_post_result_paths[@]}; i++)); do
+			_hook_run_one "$event" "$test_seqnum" \
+				"$status" "$runtime" \
+				"${_hook_post_result_paths[$i]}" \
+				"${_hook_post_result_matches[$i]}"
+		done
+		;;
+	esac
+}
-- 
2.56.0

