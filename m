Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49856 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdH3ElO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 00:41:14 -0400
Subject: [PATCH 4/4] generic: try various unicode normalization games
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 29 Aug 2017 21:41:09 -0700
Message-ID: <150406806922.31349.14339807533367840438.stgit@magnolia>
In-Reply-To: <150406805060.31349.16766271336969357123.stgit@magnolia>
References: <150406805060.31349.16766271336969357123.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Linux filesystems generally treat filenames as a bag of bytes, which
means that there can be unique sequences of bytes that render the same
on most modern GUIs.  So, let's rig up a test to see if it's really
true that we can create filenames that look the same but point to
different files.  xfs_scrub will warn about these kinds of situations,
though they're not technically fs "corruption".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/703     |  151 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/703.out |    6 ++
 tests/generic/group   |    1 
 3 files changed, 158 insertions(+)
 create mode 100755 tests/generic/703
 create mode 100644 tests/generic/703.out


diff --git a/tests/generic/703 b/tests/generic/703
new file mode 100755
index 0000000..1ae70ed
--- /dev/null
+++ b/tests/generic/703
@@ -0,0 +1,151 @@
+#! /bin/bash
+# FS QA Test No. 703
+#
+# Create a directory with multiple filenames that all appear the same
+# (in unicode, anyway) but point to different inodes.  In theory all
+# Linux filesystems should allow this (filenames are a sequence of
+# arbitrary bytes) even if the user implications are horrifying.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+_supported_os Linux
+_require_scratch
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir="${SCRATCH_MNT}/test-${seq}"
+mkdir $testdir
+
+hexbytes() {
+	echo -n "$1" | od -tx1 -w99999 | head -n1 | sed -e 's/^0* //g'
+}
+
+setf() {
+	key="$(echo -e "$1")"
+	value="$2"
+
+	echo "${value}" > "${testdir}/${key}"
+	echo "Storing ${key} ($(hexbytes "${key}")) -> ${value}" >> $seqres.full
+}
+
+testf() {
+	key="$(echo -e "$1")"
+	value="$2"
+	fname="${testdir}/${key}"
+
+	echo "Testing ${key} ($(hexbytes "${key}")) -> ${value}" >> $seqres.full
+
+	if [ ! -e "${fname}" ]; then
+		echo "Key ${key} does not exist for ${value} test??"
+		return
+	fi
+
+	actual_value="$(cat "${fname}")"
+	if [ "${actual_value}" != "${value}" ]; then
+		echo "Key ${key} has value ${value}, expected ${actual_value}."
+	fi
+}
+
+filter_scrub() {
+	grep 'Unicode' | sed -e 's/^.*Duplicate/Duplicate/g'
+}
+
+echo "Create files"
+# These two render the same
+setf "french_caf\xc3\xa9.txt" "NFC"
+setf "french_cafe\xcc\x81.txt" "NFD"
+
+# These two may have different widths
+setf "chinese_\xef\xbd\xb6.txt" "NFKC1"
+setf "chinese_\xe3\x82\xab.txt" "NFKC2"
+
+# Same point, different byte representations in NFC/NFD/NFKC/NFKD
+setf "greek_\xcf\x93.txt" "GREEK UPSILON WITH ACUTE AND HOOK SYMBOL, NFC"
+setf "greek_\xcf\x92\xcc\x81.txt" "GREEK UPSILON WITH ACUTE AND HOOK SYMBOL, NFD"
+setf "greek_\xce\x8e.txt" "GREEK UPSILON WITH ACUTE AND HOOK SYMBOL, NFKC"
+setf "greek_\xce\xa5\xcc\x81.txt" "GREEK UPSILON WITH ACUTE AND HOOK SYMBOL, NFKD"
+
+# Arabic code point can expand into a muuuch longer series
+setf "arabic_\xef\xb7\xba.txt" "ARABIC LIGATURE SALLALLAHOU ALAYHE WASALLAM, NFC"
+setf "arabic_\xd8\xb5\xd9\x84\xd9\x89\x20\xd8\xa7\xd9\x84\xd9\x84\xd9\x87\x20\xd8\xb9\xd9\x84\xd9\x8a\xd9\x87\x20\xd9\x88\xd8\xb3\xd9\x84\xd9\x85.txt" "ARABIC LIGATURE SALLALLAHOU ALAYHE WASALLAM, NFKC"
+
+# Fake slash?
+setf "urk\xc0\xafmoo" "FAKESLASH"
+
+ls -la $testdir >> $seqres.full
+
+echo "Test files"
+testf "french_caf\xc3\xa9.txt" "NFC"
+testf "french_cafe\xcc\x81.txt" "NFD"
+
+testf "chinese_\xef\xbd\xb6.txt" "NFKC1"
+testf "chinese_\xe3\x82\xab.txt" "NFKC2"
+
+testf "greek_\xcf\x93.txt" "GREEK UPSILON WITH ACUTE AND HOOK SYMBOL, NFC"
+testf "greek_\xcf\x92\xcc\x81.txt" "GREEK UPSILON WITH ACUTE AND HOOK SYMBOL, NFD"
+testf "greek_\xce\x8e.txt" "GREEK UPSILON WITH ACUTE AND HOOK SYMBOL, NFKC"
+testf "greek_\xce\xa5\xcc\x81.txt" "GREEK UPSILON WITH ACUTE AND HOOK SYMBOL, NFKD"
+
+testf "arabic_\xef\xb7\xba.txt" "ARABIC LIGATURE SALLALLAHOU ALAYHE WASALLAM, NFC"
+testf "arabic_\xd8\xb5\xd9\x84\xd9\x89\x20\xd8\xa7\xd9\x84\xd9\x84\xd9\x87\x20\xd8\xb9\xd9\x84\xd9\x8a\xd9\x87\x20\xd9\x88\xd8\xb3\xd9\x84\xd9\x85.txt" "ARABIC LIGATURE SALLALLAHOU ALAYHE WASALLAM, NFKC"
+
+testf "urk\xc0\xafmoo" "FAKESLASH"
+
+echo "Uniqueness of inodes?"
+stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
+	if [ "${nr}" -gt 1 ]; then
+		echo "${nr} ${inum}"
+	fi
+done
+
+echo "Test XFS online scrub, if applicable"
+# Only run this on xfs if xfs_scrub is available and has the unicode checker
+if [ "${FSTYP}" = "xfs" ] && \
+   [ -x "${XFS_SCRUB_PROG}" ] && \
+   type ldd > /dev/null 2>&1 && ldd "${XFS_SCRUB_PROG}" | grep -q libunistring; then
+	output="$(${XFS_SCRUB_PROG} -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
+	echo "${output}" | grep -q "french_" || echo "No complaints about french e accent?"
+	echo "${output}" | grep -q "chinese_" || echo "No complaints about chinese width-different?"
+	echo "${output}" | grep -q "greek_" || echo "No complaints about greek letter mess?"
+	echo "${output}" | grep -q "arabic_" || echo "No complaints about arabic expanded string?"
+	echo "Actual xfs_scrub output:" >> $seqres.full
+	echo "${output}" >> $seqres.full
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/703.out b/tests/generic/703.out
new file mode 100644
index 0000000..f46b1c6
--- /dev/null
+++ b/tests/generic/703.out
@@ -0,0 +1,6 @@
+QA output created by 703
+Format and mount
+Create files
+Test files
+Uniqueness of inodes?
+Test XFS online scrub, if applicable
diff --git a/tests/generic/group b/tests/generic/group
index 044ec3f..2255865 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -453,3 +453,4 @@
 448 auto quick rw
 449 auto quick acl enospc
 450 auto quick rw
+703 auto quick dir

