Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49806 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdJZFvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 01:51:50 -0400
Subject: [PATCH 2/6] common/xfs: refactor xfs_scrub presence testing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 Oct 2017 22:51:45 -0700
Message-ID: <150899710564.18389.16849719285455223701.stgit@magnolia>
In-Reply-To: <150899709935.18389.17266737014565285073.stgit@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move all the requirements checking for xfs_scrub into a helper function.
Make sure the helper properly detects the presence of the scrub ioctl
and situations where we can't run scrub (e.g. norecovery).

Refactor the existing three xfs_scrub call sites to use the helper to
check if it's appropriate to run scrub.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 README            |    6 +++---
 common/rc         |    2 +-
 common/xfs        |   40 +++++++++++++++++++++++++++++++++-------
 tests/generic/453 |   11 +----------
 tests/generic/454 |   11 +----------
 5 files changed, 39 insertions(+), 31 deletions(-)


diff --git a/README b/README
index 4963d28..a9da4f0 100644
--- a/README
+++ b/README
@@ -88,9 +88,9 @@ Preparing system for tests:
                run xfs_repair -n to check the filesystem; xfs_repair to rebuild
                metadata indexes; and xfs_repair -n (a third time) to check the
                results of the rebuilding.
-             - set TEST_XFS_SCRUB=1 to have _check_xfs_filesystem run
-               xfs_scrub -vd to scrub the filesystem metadata online before
-               unmounting to run the offline check.
+             - xfs_scrub, if present, will always check the test and scratch
+               filesystems if they are still online at the end of the test.
+               It is no longer necessary to set TEST_XFS_SCRUB.
              - setenv LOGWRITES_DEV to a block device to use for power fail
                testing.
 
diff --git a/common/rc b/common/rc
index 1a4d81e..83aaced 100644
--- a/common/rc
+++ b/common/rc
@@ -2091,7 +2091,7 @@ _require_xfs_io_command()
 			_notrun "xfs_io $command support is missing"
 		;;
 	"scrub"|"repair")
-		testio=`$XFS_IO_PROG -x -c "$command test 0" $TEST_DIR 2>&1`
+		testio=`$XFS_IO_PROG -x -c "$command probe 0" $TEST_DIR 2>&1`
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
diff --git a/common/xfs b/common/xfs
index dff8454..df7d029 100644
--- a/common/xfs
+++ b/common/xfs
@@ -298,6 +298,29 @@ _require_xfs_db_command()
 		_notrun "xfs_db $command support is missing"
 }
 
+# Does the filesystem mounted from a particular device support scrub?
+_supports_xfs_scrub()
+{
+	mountpoint="$1"
+	device="$2"
+
+	if [ ! -b "$device" ] || [ ! -e "$mountpoint" ]; then
+		echo "Usage: _supports_xfs_scrub mountpoint device"
+		exit 1
+	fi
+
+	test "$FSTYP" = "xfs" || return 1
+	test -x "$XFS_SCRUB_PROG" || return 1
+
+	# Probe for kernel support...
+	$XFS_IO_PROG -x -c "scrub probe 0" "$mountpoint" 2>&1 | grep -q "Inappropriate ioctl" && return 1
+
+	# Scrub can't run on norecovery mounts
+	_fs_options "$device" | grep -q "norecovery" && return 1
+
+	return 0
+}
+
 # run xfs_check and friends on a FS.
 _check_xfs_filesystem()
 {
@@ -330,14 +353,17 @@ _check_xfs_filesystem()
 	type=`_fs_type $device`
 	ok=1
 
-	if [ "$type" = "xfs" ]; then
-		if [ -n "$TEST_XFS_SCRUB" ] && [ -x "$XFS_SCRUB_PROG" ]; then
-			"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device >>$seqres.full
-			if [ $? -ne 0 ]; then
-				_log_err "filesystem on $device failed scrub"
-				ok=0
-			fi
+	# Run online scrub if we can.
+	mntpt="$(_is_mounted $device)"
+	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
+		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device >>$seqres.full 2>&1
+		if [ $? -ne 0 ]; then
+			_log_err "filesystem on $device failed scrub"
+			ok=0
 		fi
+	fi
+
+	if [ "$type" = "xfs" ]; then
 		# mounted ...
 		mountpoint=`_umount_or_remount_ro $device`
 	fi
diff --git a/tests/generic/453 b/tests/generic/453
index ff29736..40fae91 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -136,10 +136,7 @@ echo "Test XFS online scrub, if applicable"
 
 # Only run this on xfs if xfs_scrub is available and has the unicode checker
 check_xfs_scrub() {
-	# Ignore non-XFS fs or no scrub program...
-	if [ "${FSTYP}" != "xfs" ] || [ ! -x "${XFS_SCRUB_PROG}" ]; then
-		return 1
-	fi
+	_supports_xfs_scrub "$SCRATCH_MNT" "$SCRATCH_DEV" || return 1
 
 	# We only care if xfs_scrub has unicode string support...
 	if ! type ldd > /dev/null 2>&1 || \
@@ -147,12 +144,6 @@ check_xfs_scrub() {
 		return 1
 	fi
 
-	# Does the ioctl work?
-	if $XFS_IO_PROG -x -c "scrub probe 0" $SCRATCH_MNT 2>&1 | \
-	   grep -q "Inappropriate ioctl"; then
-		return 1
-	fi
-
 	return 0
 }
 
diff --git a/tests/generic/454 b/tests/generic/454
index 01279ee..462185a 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -132,10 +132,7 @@ echo "Test XFS online scrub, if applicable"
 
 # Only run this on xfs if xfs_scrub is available and has the unicode checker
 check_xfs_scrub() {
-	# Ignore non-XFS fs or no scrub program...
-	if [ "${FSTYP}" != "xfs" ] || [ ! -x "${XFS_SCRUB_PROG}" ]; then
-		return 1
-	fi
+	_supports_xfs_scrub "$SCRATCH_MNT" "$SCRATCH_DEV" || return 1
 
 	# We only care if xfs_scrub has unicode string support...
 	if ! type ldd > /dev/null 2>&1 || \
@@ -143,12 +140,6 @@ check_xfs_scrub() {
 		return 1
 	fi
 
-	# Does the ioctl work?
-	if $XFS_IO_PROG -x -c "scrub probe 0" $SCRATCH_MNT 2>&1 | \
-	   grep -q "Inappropriate ioctl"; then
-		return 1
-	fi
-
 	return 0
 }
 

