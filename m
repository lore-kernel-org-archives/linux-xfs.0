Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfA2QRa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 11:17:30 -0500
Subject: [PATCH 3/4] common: fix kmemleak to work with sections
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 29 Jan 2019 08:17:25 -0800
Message-ID: <154877864538.9277.6249607598508212314.stgit@magnolia>
In-Reply-To: <154877863279.9277.4463697450629081138.stgit@magnolia>
References: <154877863279.9277.4463697450629081138.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the kmemleak code to work correctly with sections.  This
requires changing the report location to use RESULT_DIR instead of
RESULT_BASE, and clarifying which functions get used when.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check     |    4 ++--
 common/rc |   32 ++++++++++++++++++++++----------
 2 files changed, 24 insertions(+), 12 deletions(-)


diff --git a/check b/check
index c0eee0aa..b9eb86cb 100755
--- a/check
+++ b/check
@@ -509,7 +509,7 @@ _expunge_test()
 	return 0
 }
 
-_init_kmemleak
+_detect_kmemleak
 _prepare_test_list
 
 if $OPTIONS_HAVE_SECTIONS; then
@@ -793,8 +793,8 @@ for section in $HOST_OPTIONS_SECTIONS; do
 			# and log messages that shouldn't be there.
 			_check_filesystems
 			_check_dmesg || err=true
-			_check_kmemleak || err=true
 		fi
+		_check_kmemleak || err=true
 
 		# test ends after all checks are done.
 		$timestamp && _timestamp
diff --git a/common/rc b/common/rc
index 19e947df..75771f31 100644
--- a/common/rc
+++ b/common/rc
@@ -3514,7 +3514,7 @@ _check_dmesg()
 # capture the kmemleak report
 _capture_kmemleak()
 {
-	local kern_knob="${DEBUGFS_MNT}/kmemleak"
+	local kern_knob="$DEBUGFS_MNT/kmemleak"
 	local leak_file="$1"
 
 	# Tell the kernel to scan for memory leaks.  Apparently the write
@@ -3535,17 +3535,20 @@ ENDL
 	echo "clear" > "$kern_knob"
 }
 
-# set up kmemleak
-_init_kmemleak()
+# Figure out if the running kernel supports kmemleak; if it does, clear out
+# anything that leaked before we even started testing.  The leak checker only
+# needs to be primed like this once per ./check invocation.
+_detect_kmemleak()
 {
-	local kern_knob="${DEBUGFS_MNT}/kmemleak"
+	local kern_knob="$DEBUGFS_MNT/kmemleak"
+	KMEMLEAK_CHECK_FILE="/tmp/check_kmemleak"
 
 	# Since kernel v4.19-rc3, the kmemleak knob exists even if kmemleak is
 	# disabled, but returns EBUSY on write. So instead of relying on
 	# existance of writable knob file, we use a test file to indicate that
 	# _check_kmemleak() is enabled only if we actually managed to write to
 	# the knob file.
-	rm -f ${RESULT_BASE}/check_kmemleak
+	rm -f "$KMEMLEAK_CHECK_FILE"
 
 	if [ ! -w "$kern_knob" ]; then
 		return 0
@@ -3555,17 +3558,26 @@ _init_kmemleak()
 	# then dump all the leaks recorded so far.
 	if echo "scan=off" > "$kern_knob" 2>/dev/null; then
 		_capture_kmemleak /dev/null
-		touch ${RESULT_BASE}/check_kmemleak
+		touch "$KMEMLEAK_CHECK_FILE"
 	fi
 }
 
-# check kmemleak log
+# Kick the kmemleak checker to scan for leaks.  Background leak scan mode is
+# not enabled, so we must call the kernel to ask for a scan and deal with the
+# results appropriately.  This we do after every test completes, whether or not
+# it was successful.
 _check_kmemleak()
 {
-	local kern_knob="${DEBUGFS_MNT}/kmemleak"
-	local leak_file="${seqres}.kmemleak"
+	local kern_knob="$DEBUGFS_MNT/kmemleak"
+	local leak_file="$seqres.kmemleak"
 
-	if [ ! -f ${RESULT_BASE}/check_kmemleak ]; then
+	if [ ! -f "$KMEMLEAK_CHECK_FILE" ]; then
+		return 0
+	fi
+
+	# Not enabled, so discard any report of leaks found.
+	if [ "$USE_KMEMLEAK" != "yes" ]; then
+		_capture_kmemleak /dev/null
 		return 0
 	fi
 
