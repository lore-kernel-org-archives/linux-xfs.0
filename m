Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3B53EC2DD;
	Tue, 14 Apr 2026 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776187051; cv=none; b=hl/70xmLQndCyAD4XPaIIabHX75rurZsiJCp9cNm7xASefGIOrYcnscnKZov2Ydoeld7xyJd61wHalc35JRATK7bLyXUmNy+x9uGx8OeUpuUMK4zr6bOmQaIv1t0N2fQxZqn6kk5PAICFyGWKw35q34LGAV2tlHf60lMgGvrJ3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776187051; c=relaxed/simple;
	bh=+goAzdfuhEFuwuyL8EXKvINzosr64q+zr5BPSfxEZDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwbPDRY9IIHqFicGEcBdoaahHWnCCzpvbrrtLMUO8TtzX9uyjoRzR50xhctbyof/20/EuHUHzb45j2yVMvAunezbVSdOL4UeJBXQZFCN+cqN4qIRJs1E8yHE4jmI90mkGrAzjdoO5V3Z8krUBSJYmKFtY9HKq9W4FuFJ5LcphyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDVJH8g7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDVJH8g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC300C19425;
	Tue, 14 Apr 2026 17:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776187050;
	bh=+goAzdfuhEFuwuyL8EXKvINzosr64q+zr5BPSfxEZDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fDVJH8g7b9z859JTPObwUc3xuzRrPGa6EurrmdVN/f5LKpII5V3m4KoLzj0TSO9i2
	 NsRMbA0d6juk+S2wiyIV9tatMGIVYOo4khLfGkiZOMRjIDarlcevkb2CSMObLByp28
	 7KNHZr2ecpZ07rCU02af9hmPW875xHfAX0etcKfbGvJW2MQK3CPowmu/NDRlAPE5u3
	 DAvrwqhXNkeUQ0faHmVCfsogq/0Y0UKqRoHmh+AtM13IU7g3muwDTnAGHFPTA5e3Hj
	 dDOgcDWCx4Aas2cUqx5DzNaiX8x5C7pD32zbabWXOqvDRJYwyGvdA4mBaMHq3/YoQK
	 GkDiEl11InCIQ==
Date: Tue, 14 Apr 2026 10:17:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] check: capture dmesg of mount failures if test fails
Message-ID: <20260414171730.GA149968@frogsfrogsfrogs>
References: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
 <177610262444.115381.1847570200616394322.stgit@frogsfrogsfrogs>
 <ad3z0FFzJqhIiqVQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad3z0FFzJqhIiqVQ@infradead.org>

On Tue, Apr 14, 2026 at 12:59:12AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 13, 2026 at 10:51:25AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Capture the kernel output after a mount failure occurs.  If the test
> > itself fails, then keep the logging output for further diagnosis.
> 
> I have to admit I don't really understand what the xunit and selftests
> stuff is doing.  Can you explain that a bit in the commit message?

The xunit.xsd update specifies that there can be a <mount-failure>
element in the xml output, and that its contents will be the
$seqres.mountfail file.

The new selftest practices creating the .mountfail file in the test
output directory after a mount failure.  Annoyingly there's no way for
the test itself to check that, since the .mountfail file is created in
check.

How about the following?

--D

From: Darrick J. Wong <djwong@kernel.org>
Subject: [PATCH] check: capture dmesg of mount failures if test fails

Capture the kernel output after a mount failure occurs.  If the test
itself fails, then keep the logging output for further diagnosis.  The
xunit.xsd update adds a <mount-failure> element to the xml output, whose
contents are the mountfail file.

Note that because the .mountfail file is preserved by ./check, the new
selftest requires the user to check for the .mountfail file.  This is a
little awkward.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check                  |   22 +++++++++++++++++++++-
 common/config          |    1 +
 common/rc              |   26 +++++++++++++++++++++++++-
 common/report          |    8 ++++++++
 doc/xunit.xsd          |   12 +++++++++++-
 tests/selftest/008     |   22 ++++++++++++++++++++++
 tests/selftest/008.out |    1 +
 7 files changed, 89 insertions(+), 3 deletions(-)
 create mode 100755 tests/selftest/008
 create mode 100644 tests/selftest/008.out

diff --git a/check b/check
index 6ae89feba7c30a..c27cd8d9b81022 100755
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
 
diff --git a/common/config b/common/config
index 2fa9ba44b8ad6c..5462bc061f3664 100644
--- a/common/config
+++ b/common/config
@@ -358,6 +358,7 @@ true "${MAX_OUTPUT_SIZE:=65536}"
 true "${MAX_FULL_SIZE:=$((MAX_OUTPUT_SIZE * 2))}"
 true "${MAX_DMESG_SIZE:=${MAX_OUTPUT_SIZE}}"
 true "${MAX_OUTBAD_SIZE:=${MAX_OUTPUT_SIZE}}"
+true "${MAX_MOUNTFAIL_SIZE:=${MAX_OUTPUT_SIZE}}"
 
 _common_mount_opts()
 {
diff --git a/common/rc b/common/rc
index b11a7d1e404519..7de939d1630dd9 100644
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
