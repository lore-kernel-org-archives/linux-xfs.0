Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB2629415;
	Tue, 31 Dec 2024 23:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689410; cv=none; b=focomsSVr7eiRAWcVKCz7bsMU0b1S8C+4spyKLGh8GxnVP/ZzUX2fcYx2ZCQxJK9058fywipZVwRqLlOgPZH963Zz5CELMPJKXmkYJ2fM2YSP+CZAgjttrrIKFmgPVn8Lc4lE9o6DlF9d1PGmXH5oBCvHR6VVhwzlq48X94c5wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689410; c=relaxed/simple;
	bh=2LonTCHUZsjK+8dEyY7oma7ZAbxifjPkwzuD4bJwQBk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fu6euOxQeCI5D/HHutPawJOiwCuqd6IU+z5uJ4rU8w6U/u9DiLFXbAj0uqDR0mXq6aCv72VcrcbwjNUZYKGlz465C7YMqnyJbP3yWrVP6IVovSedeYPxk9ZKifxu7sxh89OqmC5Rahwy6jicpjinDR5VO/X1544mpL2CSP65mjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVJ9opbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVJ9opbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384D1C4CED2;
	Tue, 31 Dec 2024 23:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689410;
	bh=2LonTCHUZsjK+8dEyY7oma7ZAbxifjPkwzuD4bJwQBk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EVJ9opbfLeHztlukKqPA5GJCMmi+FAo0I0f6fnZxYRPJ4vWt0TrH5zupVHYvaNQXD
	 fDk6ZCgmDVc1HJNibjvRB7CoSwjNqY0vMUG/hjXWn4Pa5Hufr+jJp+NiXQYC3DAh7V
	 KmVh4OZpMXdx8Of2hE21OuXpqhlUPZfGLnaz9xMlRAosAyW0c6KjsohuFrgk23P865
	 ejU7mVgySN6P5BzQz8z4JskaIFVj2V6IRtlXZ3GmeDgIcCY65V0G5QjHv+y1f8/u+X
	 UXIM2PZ+RVPZtfVDpmE0WJjRRL67qxVrEEWcnnc4sneyWR6i81qtiKJXI+/M06YmtZ
	 Y1pcBicuKlmSg==
Date: Tue, 31 Dec 2024 15:56:49 -0800
Subject: [PATCH 2/2] check: capture dmesg of mount failures if test fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568782758.2712126.12517347004514444060.stgit@frogsfrogsfrogs>
In-Reply-To: <173568782724.2712126.2021149328064840091.stgit@frogsfrogsfrogs>
References: <173568782724.2712126.2021149328064840091.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Capture the kernel output after a mount failure occurs.  If the test
itself fails, then keep the logging output for further diagnosis.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check                  |   22 +++++++++++++++++++++-
 common/rc              |   26 +++++++++++++++++++++++++-
 common/report          |    8 ++++++++
 tests/selftest/008     |   20 ++++++++++++++++++++
 tests/selftest/008.out |    1 +
 5 files changed, 75 insertions(+), 2 deletions(-)
 create mode 100755 tests/selftest/008
 create mode 100644 tests/selftest/008.out


diff --git a/check b/check
index 9222cd7e4f8197..a46ea1a54d78bb 100755
--- a/check
+++ b/check
@@ -614,7 +614,7 @@ _stash_fail_loop_files() {
 	local seq_prefix="${REPORT_DIR}/${1}"
 	local cp_suffix="$2"
 
-	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core" ".hints"; do
+	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core" ".hints" ".mountfail"; do
 		rm -f "${seq_prefix}${i}${cp_suffix}"
 		if [ -f "${seq_prefix}${i}" ]; then
 			cp "${seq_prefix}${i}" "${seq_prefix}${i}${cp_suffix}"
@@ -994,6 +994,7 @@ function run_section()
 				      echo -n "	$seqnum -- "
 			cat $seqres.notrun
 			tc_status="notrun"
+			rm -f "$seqres.mountfail?"
 			_stash_test_status "$seqnum" "$tc_status"
 
 			# Unmount the scratch fs so that we can wipe the scratch
@@ -1053,6 +1054,7 @@ function run_section()
 		if [ ! -f $seq.out ]; then
 			_dump_err "no qualified output"
 			tc_status="fail"
+			rm -f "$seqres.mountfail?"
 			_stash_test_status "$seqnum" "$tc_status"
 			continue;
 		fi
@@ -1089,6 +1091,24 @@ function run_section()
 				rm -f $seqres.hints
 			fi
 		fi
+
+		if [ -f "$seqres.mountfail?" ]; then
+			if [ "$tc_status" = "fail" ]; then
+				# Let the user know if there were mount
+				# failures on a test that failed because that
+				# could be interesting.
+				mv "$seqres.mountfail?" "$seqres.mountfail"
+				_dump_err "check: possible mount failures (see $seqres.mountfail)"
+				test -f $seqres.mountfail && \
+					maybe_compress_logfile $seqres.mountfail $MAX_MOUNTFAIL_SIZE
+			else
+				# Don't retain mount failure logs for tests
+				# that pass or were skipped because some tests
+				# intentionally drive mount failures.
+				rm -f "$seqres.mountfail?"
+			fi
+		fi
+
 		_stash_test_status "$seqnum" "$tc_status"
 	done
 
diff --git a/common/rc b/common/rc
index d7dfb55bbbd7e1..0ede68eb912440 100644
--- a/common/rc
+++ b/common/rc
@@ -204,9 +204,33 @@ _get_hugepagesize()
 	awk '/Hugepagesize/ {print $2 * 1024}' /proc/meminfo
 }
 
+# Does dmesg have a --since flag?
+_dmesg_detect_since()
+{
+	if [ -z "$DMESG_HAS_SINCE" ]; then
+		test "$DMESG_HAS_SINCE" = "yes"
+		return
+	elif dmesg --help | grep -q -- --since; then
+		DMESG_HAS_SINCE=yes
+	else
+		DMESG_HAS_SINCE=no
+	fi
+}
+
 _mount()
 {
-    $MOUNT_PROG $*
+	$MOUNT_PROG $*
+	ret=$?
+	if [ "$ret" -ne 0 ]; then
+		echo "\"$MOUNT_PROG $*\" failed at $(date)" >> "$seqres.mountfail?"
+		if _dmesg_detect_since; then
+			dmesg --since '30s ago' >> "$seqres.mountfail?"
+		else
+			dmesg | tail -n 100 >> "$seqres.mountfail?"
+		fi
+	fi
+
+	return $ret
 }
 
 # Call _mount to do mount operation but also save mountpoint to
diff --git a/common/report b/common/report
index 0e91e481f9725a..b57697f76dafb2 100644
--- a/common/report
+++ b/common/report
@@ -199,6 +199,7 @@ _xunit_make_testcase_report()
 		local out_src="${SRC_DIR}/${test_name}.out"
 		local full_file="${REPORT_DIR}/${test_name}.full"
 		local dmesg_file="${REPORT_DIR}/${test_name}.dmesg"
+		local mountfail_file="${REPORT_DIR}/${test_name}.mountfail"
 		local outbad_file="${REPORT_DIR}/${test_name}.out.bad"
 		if [ -z "$_err_msg" ]; then
 			_err_msg="Test $test_name failed, reason unknown"
@@ -225,6 +226,13 @@ _xunit_make_testcase_report()
 			printf ']]>\n'	>>$report
 			echo -e "\t\t</system-err>" >> $report
 		fi
+		if [ -z "$quiet" -a -f "$mountfail_file" ]; then
+			echo -e "\t\t<mount-failure>" >> $report
+			printf	'<![CDATA[\n' >>$report
+			cat "$mountfail_file" | tr -dc '[:print:][:space:]' | encode_cdata >>$report
+			printf ']]>\n'	>>$report
+			echo -e "\t\t</mount-failure>" >> $report
+		fi
 		;;
 	*)
 		echo -e "\t\t<failure message=\"Unknown test_status=$test_status\" type=\"TestFail\"/>" >> $report
diff --git a/tests/selftest/008 b/tests/selftest/008
new file mode 100755
index 00000000000000..db80ffe6f77339
--- /dev/null
+++ b/tests/selftest/008
@@ -0,0 +1,20 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 008
+#
+# Test mount failure capture.
+#
+. ./common/preamble
+_begin_fstest selftest
+
+_require_command "$WIPEFS_PROG" wipefs
+_require_scratch
+
+$WIPEFS_PROG -a $SCRATCH_DEV
+_scratch_mount &>> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/selftest/008.out b/tests/selftest/008.out
new file mode 100644
index 00000000000000..aaff95f3f48372
--- /dev/null
+++ b/tests/selftest/008.out
@@ -0,0 +1 @@
+QA output created by 008

