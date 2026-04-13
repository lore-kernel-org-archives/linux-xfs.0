Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675BC382385;
	Mon, 13 Apr 2026 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102686; cv=none; b=Inx6R+MlUM/CrJ/RnpUib/Jm5YX2niRen5TtMcCAJQwAkoIjCT0uZGrEEwrIq+iKSbcCPPkPOMLrlm/KFX+rL2hxgRRingVue16qbga/KEWRToHSI7PNFtH5OS1Q3l2oPblChMSCMkpWbC+kbVQCN+F6QYno3AVV10D0Qa88h9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102686; c=relaxed/simple;
	bh=Qz7F0+7jpJgrJhcd8oVky1nqnyAbJ9jDc40sApdvZ+I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NKOnsApKfTZnLyprr7VGSuS5Rt7adAhr2jpZ6eixambC5UsyA2f0O4FTtICdvOz1VUy1xeBaCRfLp1aoQQ9YybWIqSlxG+Huj3t3r2S4v9UeKcmpmxQLALBL/XisRitfwMhLOaP72/JDWpKkMy/3n+rSj3s5A8z3mqgWWB/s0yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLyd9Y7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLyd9Y7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C52C2BCAF;
	Mon, 13 Apr 2026 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776102686;
	bh=Qz7F0+7jpJgrJhcd8oVky1nqnyAbJ9jDc40sApdvZ+I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OLyd9Y7hDPb1HQKY8Ff9VK/G8GgceDKe0k2W/FZnN6yoK1fXOaHDNiS+omINqrL4I
	 uV+wtLcsMfr1jNIHUNbMpbXO7pgzIKzUsPYAujnlkeWw2gK8gX+MSZ2dVoqN+eidsO
	 /T6YhtQeLIdTAfNrcNg34z0UsqhoP0ixSd+tv7nWq2MetEYamRQDV++vEs+cSsjcqf
	 1Lg7nDSU9A++Hauafk12i5xnAq+C03Q5TvyrbQbSHng4vLeB5Mz2U1ijT1jEhh7Yxl
	 05yNvH+WToEYmKq6wIDmLXL5ut3FD7OR/qw8d46jK41lBzsJ6dpyYIk8UeFq7bIS0+
	 OrsrJv/T4evUw==
Date: Mon, 13 Apr 2026 10:51:25 -0700
Subject: [PATCH 2/2] check: capture dmesg of mount failures if test fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177610262444.115381.1847570200616394322.stgit@frogsfrogsfrogs>
In-Reply-To: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
References: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
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
 doc/xunit.xsd          |   12 +++++++++++-
 tests/selftest/008     |   20 ++++++++++++++++++++
 tests/selftest/008.out |    1 +
 6 files changed, 86 insertions(+), 3 deletions(-)
 create mode 100755 tests/selftest/008
 create mode 100644 tests/selftest/008.out


diff --git a/check b/check
index cd7a79347eac28..c37921ea58e558 100755
--- a/check
+++ b/check
@@ -608,7 +608,7 @@ _stash_fail_loop_files() {
 	local seq_prefix="${REPORT_DIR}/${1}"
 	local cp_suffix="$2"
 
-	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core" ".hints"; do
+	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core" ".hints" ".mountfail"; do
 		rm -f "${seq_prefix}${i}${cp_suffix}"
 		if [ -f "${seq_prefix}${i}" ]; then
 			cp "${seq_prefix}${i}" "${seq_prefix}${i}${cp_suffix}"
@@ -982,6 +982,7 @@ function run_section()
 				      echo -n "	$seqnum -- "
 			cat $seqres.notrun
 			tc_status="notrun"
+			rm -f "$seqres.mountfail?"
 			_stash_test_status "$seqnum" "$tc_status"
 
 			# Unmount the scratch fs so that we can wipe the scratch
@@ -1045,6 +1046,7 @@ function run_section()
 		if [ ! -f $seq.out ]; then
 			_dump_err "no qualified output"
 			tc_status="fail"
+			rm -f "$seqres.mountfail?"
 			_stash_test_status "$seqnum" "$tc_status"
 			continue;
 		fi
@@ -1081,6 +1083,24 @@ function run_section()
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
index 5fe44e2158ffb3..18ceda1b32cd63 100644
--- a/common/rc
+++ b/common/rc
@@ -288,9 +288,33 @@ _get_hugepagesize()
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
index 7128bbebac8b75..a41a58f790b784 100644
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
diff --git a/doc/xunit.xsd b/doc/xunit.xsd
index d287eaf5a25fb6..efe0badbb338b5 100644
--- a/doc/xunit.xsd
+++ b/doc/xunit.xsd
@@ -131,7 +131,7 @@
                                 </xs:complexType>
                             </xs:element>
                         </xs:choice>
-                        <xs:choice minOccurs="0" maxOccurs="3">
+                        <xs:choice minOccurs="0" maxOccurs="4">
                             <xs:element name="system-out" minOccurs="0" maxOccurs="1">
                                 <xs:annotation>
                                     <xs:documentation xml:lang="en">Data that was written to the .full log file while the test was executed.</xs:documentation>
@@ -162,6 +162,16 @@
                                     </xs:restriction>
                                 </xs:simpleType>
                             </xs:element>
+                            <xs:element name="mount-failure" minOccurs="0" maxOccurs="1">
+                                <xs:annotation>
+                                    <xs:documentation xml:lang="en">Kernel log recorded when mount failed.</xs:documentation>
+                                </xs:annotation>
+                                <xs:simpleType>
+                                    <xs:restriction base="pre-string">
+                                        <xs:whiteSpace value="preserve"/>
+                                    </xs:restriction>
+                                </xs:simpleType>
+                            </xs:element>
                         </xs:choice>
                     </xs:sequence>
                     <xs:attribute name="name" type="xs:token" use="required">
diff --git a/tests/selftest/008 b/tests/selftest/008
new file mode 100755
index 00000000000000..bcd1f13ed27778
--- /dev/null
+++ b/tests/selftest/008
@@ -0,0 +1,20 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
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

