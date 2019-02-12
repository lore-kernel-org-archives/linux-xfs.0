Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36346 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727631AbfBLCRg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 21:17:36 -0500
Subject: [PATCH 1/3] common: fix kmemleak to work with sections
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 11 Feb 2019 18:17:26 -0800
Message-ID: <154993784666.1948.2898373791588046149.stgit@magnolia>
In-Reply-To: <154993784038.1948.7502664832930298472.stgit@magnolia>
References: <154993784038.1948.7502664832930298472.stgit@magnolia>
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
requires changing the location of the "is kmemleak enabled?" flag to use
/tmp instead of RESULT_BASE, scanning for leaks after every test, and
clarifying which functions get used when.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 README    |    2 ++
 check     |    7 +++++--
 common/rc |   32 ++++++++++++++++++++++----------
 3 files changed, 29 insertions(+), 12 deletions(-)


diff --git a/README b/README
index 73f057f3..6e9aa34d 100644
--- a/README
+++ b/README
@@ -99,6 +99,8 @@ Preparing system for tests:
                that relevant results are compared.  For example 'spinningrust'
                for configurations that use spinning disks and 'nvme' for tests
                using nvme drives.
+             - set USE_KMEMLEAK=yes to scan for memory leaks in the kernel
+               after every test, if the kernel supports kmemleak.
 
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
diff --git a/check b/check
index 77a06b00..20e95302 100755
--- a/check
+++ b/check
@@ -496,7 +496,7 @@ _expunge_test()
 	return 0
 }
 
-_init_kmemleak
+_detect_kmemleak
 _prepare_test_list
 
 if $OPTIONS_HAVE_SECTIONS; then
@@ -771,9 +771,12 @@ for section in $HOST_OPTIONS_SECTIONS; do
 			# and log messages that shouldn't be there.
 			_check_filesystems
 			_check_dmesg || err=true
-			_check_kmemleak || err=true
 		fi
 
+		# Scan for memory leaks after every test so that associating
+		# a leak to a particular test will be as accurate as possible.
+		_check_kmemleak || err=true
+
 		# test ends after all checks are done.
 		$timestamp && _timestamp
 		stop=`_wallclock`
diff --git a/common/rc b/common/rc
index b8ed1776..ab468adf 100644
--- a/common/rc
+++ b/common/rc
@@ -3500,7 +3500,7 @@ _check_dmesg()
 # capture the kmemleak report
 _capture_kmemleak()
 {
-	local kern_knob="${DEBUGFS_MNT}/kmemleak"
+	local kern_knob="$DEBUGFS_MNT/kmemleak"
 	local leak_file="$1"
 
 	# Tell the kernel to scan for memory leaks.  Apparently the write
@@ -3521,17 +3521,20 @@ ENDL
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
@@ -3541,17 +3544,26 @@ _init_kmemleak()
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
 
