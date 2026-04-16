Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4E02D2385;
	Thu, 16 Apr 2026 19:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776366945; cv=none; b=du4y143fyYzU7PC6emUk4k0RNL0QoKF57ZNT1wiuZMHLTa5UAD8BjyN5U3Hh2/kLyQSz7OGHT9tHd7oPaMOM7OMYpeoqlaexuokEmzyZQiAfnezcXaLne1DIkFC2FgqeB72285pc6IQtFVNyK+MiO3JNBgzS1pl1+HdCG6jVHLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776366945; c=relaxed/simple;
	bh=3+Mvi2FW9KgtgFXgnU/8woVtrrsul4/dwfq2+Ur+wDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ps/SAfDKCmoy44g4FyMYGJWebAqg2RlMrOqhfxVITfFgyZTH9MNBkIsVSoMtPiZfckBAWiRSs9C3tdbab4vMt2WEl7YLxzDboaf7RzppvhOZZpHqbVTq3OvJwYLRo7oHiVoBbHUFLpF/+4zBrUYZTwAgWccgQpj9kFV4R0hZVwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eWV9oI9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eWV9oI9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3709BC2BCF6;
	Thu, 16 Apr 2026 19:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776366944;
	bh=3+Mvi2FW9KgtgFXgnU/8woVtrrsul4/dwfq2+Ur+wDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eWV9oI9l5FbQAwYJNluIZmWBazz7F7D3ewHSqf9wZBaPh9rqaUnIEfW4EeXQq7mMt
	 gGEVzv34Ym75+pIGioUDUrDNYbT8dzlkIM7sKMkFh8Lxm90BUi5MV5KMuM4gWSX6/x
	 Gz71mmQcv141WlTrzC1qErCe0/1t2eAhWvnPKuF3+RLvsfw8b5SBWvXdEiztBiKd8u
	 2DyCiMqSKL1hxR11sirvt1Sn12sj7sobjr59uMWPtC5pLfBW8adwpdAs9NceEcpBji
	 7+5YMCZW9gn+mmZvA1bmwimVYmRf9f0/J3zm9OAfjLZY3hj/7rQv/puCxybbpAvpz6
	 Ikqf0EgR+nORw==
Date: Thu, 16 Apr 2026 12:15:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v1.1 2/2] check: capture dmesg of mount failures if test fails
Message-ID: <20260416191543.GB114194@frogsfrogsfrogs>
References: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
 <177610262444.115381.1847570200616394322.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177610262444.115381.1847570200616394322.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Capture the kernel output after a mount failure occurs.  If the test
itself fails, then keep the logging output for further diagnosis.  The
xunit.xsd update adds a <mount-failure> element to the xml output, whose
output is the mountfail file.

Note that because the .mountfail file is preserved by ./check, the new
selftest requires the user to check for the .mountfail file.  This is a
little awkward.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v1.1: remove extraneous cruft, simplify dmesg detection
---
 check                  |   20 +++++++++++++++++++-
 common/rc              |   19 ++++++++++++++++++-
 common/report          |    8 ++++++++
 doc/xunit.xsd          |   12 +++++++++++-
 tests/selftest/008     |   22 ++++++++++++++++++++++
 tests/selftest/008.out |    1 +
 6 files changed, 79 insertions(+), 3 deletions(-)
 create mode 100755 tests/selftest/008
 create mode 100644 tests/selftest/008.out

diff --git a/check b/check
index 6ae89feba7c30a..1455efeb3d8601 100755
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
@@ -1051,6 +1052,7 @@ function run_section()
 		if [ ! -f $seq.out ]; then
 			_dump_err "no qualified output"
 			tc_status="fail"
+			rm -f "$seqres.mountfail?"
 			_stash_test_status "$seqnum" "$tc_status"
 			continue;
 		fi
@@ -1089,6 +1091,22 @@ function run_section()
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
index b11a7d1e404519..b59f4681b4f32b 100644
--- a/common/rc
+++ b/common/rc
@@ -288,9 +288,26 @@ _get_hugepagesize()
 	awk '/Hugepagesize/ {print $2 * 1024}' /proc/meminfo
 }
 
+# Does dmesg have a --since flag?
+_has_dmesg_since_option()
+{
+	grep -q -- --since <(dmesg --help)
+}
+
 _mount()
 {
-    $MOUNT_PROG $*
+	$MOUNT_PROG $*
+	ret=$?
+	if [ "$ret" -ne 0 ]; then
+		echo "\"$MOUNT_PROG $*\" failed at $(date)" >> "$seqres.mountfail?"
+		if _has_dmesg_since_option; then
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
index 00000000000000..e6cc87fec99680
--- /dev/null
+++ b/tests/selftest/008
@@ -0,0 +1,22 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 008
+#
+# Test mount failure capture.  Test runners will have to look for the
+# 008.mountfail file in the results directory since ./check handles the
+# preservation.
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
