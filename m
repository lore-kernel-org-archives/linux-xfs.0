Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755402AbeEAPkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 11:40:01 -0400
Subject: [PATCH 6/9] generic/453: test creation of malicious directory
 entries
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 01 May 2018 08:39:57 -0700
Message-ID: <152518919767.23023.15585535417009112941.stgit@magnolia>
In-Reply-To: <152518916007.23023.4793255395982876953.stgit@magnolia>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create malicious . and .. entries (you didn't see the zero-width
joiners at the end, did you?) in a directory to see if scrub will pick
them up.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/453 |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)


diff --git a/tests/generic/453 b/tests/generic/453
index 91d163ca..8841f581 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -62,6 +62,15 @@ setf() {
 	echo "Storing ${key} ($(hexbytes "${key}")) -> ${value}" >> $seqres.full
 }
 
+setd() {
+	key="$(echo -e "$1")"
+	value="$2"
+
+	mkdir -p "${testdir}/${key}"
+	echo "${value}" > "${testdir}/${key}/value"
+	echo "Storing ${key} ($(hexbytes "${key}")) -> ${value}" >> $seqres.full
+}
+
 testf() {
 	key="$(echo -e "$1")"
 	value="$2"
@@ -80,6 +89,24 @@ testf() {
 	fi
 }
 
+testd() {
+	key="$(echo -e "$1")"
+	value="$2"
+	fname="${testdir}/${key}/value"
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
 filter_scrub() {
 	grep 'Unicode' | sed -e 's/^.*Duplicate/Duplicate/g'
 }
@@ -143,6 +170,10 @@ setf "zerojoin_moo\xe2\x80\x8dcow.txt" "zero width joiners"
 setf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
 setf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 
+# fake dotdot entry
+setd ".\xe2\x80\x8d" "zero width joiners in dot entry"
+setd "..\xe2\x80\x8d" "zero width joiners in dotdot entry"
+
 ls -la $testdir >> $seqres.full
 
 echo "Test files"
@@ -190,6 +221,9 @@ testf "zerojoin_moo\xe2\x80\x8dcow.txt" "zero width joiners"
 testf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
 testf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 
+testd ".\xe2\x80\x8d" "zero width joiners in dot entry"
+testd "..\xe2\x80\x8d" "zero width joiners in dotdot entry"
+
 echo "Uniqueness of inodes?"
 stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
 	if [ "${nr}" -gt 1 ]; then

