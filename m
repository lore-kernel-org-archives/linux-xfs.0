Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42287 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752160AbdHDPhO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2017 11:37:14 -0400
Date: Fri, 4 Aug 2017 08:37:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 3/5] common/inject: refactor helpers to use new errortag
 interface
Message-ID: <20170804153707.GA24087@magnolia>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
 <150067468569.30639.11717903404151243816.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150067468569.30639.11717903404151243816.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Brian Foster <bfoster@redhat.com>

Refactor the XFS error injection helpers to use the new errortag
interface to configure error injection.  If that isn't present, fall
back either to the xfs_io/ioctl based injection or the older sysfs
knobs.  Refactor existing testcases to use the new helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix _notrun to _fail when we can't set a knob to a particular value
v2: fix name of the 'find knob' function to communicate that it takes a
mountpoint's device, not the mountpoint itself; check for debug before
we check for knobs
---
 common/inject |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 tests/xfs/141 |    5 +++--
 tests/xfs/196 |   17 ++++++----------
 3 files changed, 66 insertions(+), 15 deletions(-)

diff --git a/common/inject b/common/inject
index 8ecc290..f30d0ba 100644
--- a/common/inject
+++ b/common/inject
@@ -35,12 +35,49 @@ _require_error_injection()
 	esac
 }
 
+# Find the errortag injection knob in sysfs for a given xfs mount's
+# block device.
+_find_xfs_mountdev_errortag_knob()
+{
+	dev="$1"
+	knob="$2"
+	shortdev="$(_short_dev "${dev}")"
+	tagfile="/sys/fs/xfs/${shortdev}/errortag/${knob}"
+
+	# Some of the new sysfs errortag knobs were previously available via
+	# another sysfs path.
+	case "${knob}" in
+	"log_bad_crc")
+		if [ ! -w "${tagfile}" ]; then
+			tagfile="/sys/fs/xfs/${shortdev}/log/log_badcrc_factor"
+		fi
+		;;
+	"drop_writes")
+		if [ ! -w "${tagfile}" ]; then
+			tagfile="/sys/fs/xfs/${shortdev}/drop_writes"
+		fi
+		if [ ! -w "${tagfile}" ]; then
+			tagfile="/sys/fs/xfs/${shortdev}/fail_writes"
+		fi
+		;;
+	*)
+		;;
+	esac
+
+	echo "${tagfile}"
+}
+
 # Requires that xfs_io inject command knows about this error type
 _require_xfs_io_error_injection()
 {
 	type="$1"
 	_require_error_injection
 
+	# Can we find the error injection knobs via the new errortag
+	# configuration mechanism?
+	knob="$(_find_xfs_mountdev_errortag_knob "${TEST_DEV}" "${type}")"
+	test -w "${knob}" && return
+
 	# NOTE: We can't actually test error injection here because xfs
 	# hasn't always range checked the argument to xfs_errortag_add.
 	# We also don't want to trip an error before we're ready to deal
@@ -54,16 +91,34 @@ _require_xfs_io_error_injection()
 _test_inject_error()
 {
 	type="$1"
+	value="$2"
 
-	$XFS_IO_PROG -x -c "inject $type" $TEST_DIR
+	knob="$(_find_xfs_mountdev_errortag_knob "${TEST_DEV}" "${type}")"
+	if [ -w "${knob}" ]; then
+		test -z "${value}" && value="default"
+		echo -n "${value}" > "${knob}"
+	elif [ -z "${value}" ] || [ "${value}" = "default" ]; then
+		$XFS_IO_PROG -x -c "inject $type" $TEST_DIR
+	else
+		_fail "Cannot inject error ${type} value ${value}."
+	fi
 }
 
 # Inject an error into the scratch fs
 _scratch_inject_error()
 {
 	type="$1"
+	value="$2"
 
-	$XFS_IO_PROG -x -c "inject $type" $SCRATCH_MNT
+	knob="$(_find_xfs_mountdev_errortag_knob "${SCRATCH_DEV}" "${type}")"
+	if [ -w "${knob}" ]; then
+		test -z "${value}" && value="default"
+		echo -n "${value}" > "${knob}"
+	elif [ -z "${value}" ] || [ "${value}" = "default" ]; then
+		$XFS_IO_PROG -x -c "inject $type" $SCRATCH_MNT
+	else
+		_fail "Cannot inject error ${type} value ${value}."
+	fi
 }
 
 # Unmount and remount the scratch device, dumping the log
diff --git a/tests/xfs/141 b/tests/xfs/141
index 56ff14e..f61e524 100755
--- a/tests/xfs/141
+++ b/tests/xfs/141
@@ -47,13 +47,14 @@ rm -f $seqres.full
 
 # get standard environment, filters and checks
 . ./common/rc
+. ./common/inject
 
 # real QA test starts here
 
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os Linux
-_require_xfs_sysfs $(_short_dev $TEST_DEV)/log/log_badcrc_factor
+_require_xfs_io_error_injection "log_bad_crc"
 _require_scratch
 _require_command "$KILLALL_PROG" killall
 
@@ -69,7 +70,7 @@ for i in $(seq 1 5); do
 	# (increase this value to run fsstress longer).
 	factor=$((RANDOM % 100 + 1))
 	echo iteration $i log_badcrc_factor: $factor >> $seqres.full 2>&1
-	echo $factor > /sys/fs/xfs/$sdev/log/log_badcrc_factor
+	_scratch_inject_error "log_bad_crc" "$factor"
 
 	# Run fsstress until the filesystem shuts down. It will shut down
 	# automatically when error injection triggers.
diff --git a/tests/xfs/196 b/tests/xfs/196
index e9b0649..fe3f570 100755
--- a/tests/xfs/196
+++ b/tests/xfs/196
@@ -45,6 +45,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/punch
+. ./common/inject
 
 # real QA test starts here
 rm -f $seqres.full
@@ -53,13 +54,7 @@ rm -f $seqres.full
 _supported_fs generic
 _supported_os Linux
 _require_scratch
-
-DROP_WRITES="drop_writes"
-# replace "drop_writes" with "fail_writes" for old kernel
-if [ -f /sys/fs/xfs/$(_short_dev $TEST_DEV)/fail_writes ];then
-	DROP_WRITES="fail_writes"
-fi
-_require_xfs_sysfs $(_short_dev $TEST_DEV)/${DROP_WRITES}
+_require_xfs_io_error_injection "drop_writes"
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
@@ -72,7 +67,7 @@ bytes=$((64 * 1024))
 $XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
 
 # Enable write drops. All buffered writes are dropped from this point on.
-echo 1 > /sys/fs/xfs/$sdev/$DROP_WRITES
+_scratch_inject_error "drop_writes" 1
 
 # Write every other 4k range to split the larger delalloc extent into many more
 # smaller extents. Use pwrite because with write failures enabled, all
@@ -89,7 +84,7 @@ for i in $(seq 4096 8192 $endoff); do
 	$XFS_IO_PROG -c "pwrite $i 4k" $file >> $seqres.full 2>&1
 done
 
-echo 0 > /sys/fs/xfs/$sdev/$DROP_WRITES
+_scratch_inject_error "drop_writes" 0
 
 _scratch_cycle_mount
 $XFS_IO_PROG -c 'bmap -vp' $file | _filter_bmap
@@ -104,9 +99,9 @@ for offset in $(seq 0 100 500); do
 	$XFS_IO_PROG -fc "pwrite ${offset}m 100m" $file >> $seqres.full 2>&1
 
 	punchoffset=$((offset + 75))
-	echo 1 > /sys/fs/xfs/$sdev/$DROP_WRITES
+	_scratch_inject_error "drop_writes"
 	$XFS_IO_PROG -c "pwrite ${punchoffset}m 4k" $file >> $seqres.full 2>&1
-	echo 0 > /sys/fs/xfs/$sdev/$DROP_WRITES
+	_scratch_inject_error "drop_writes" 0
 done
 
 echo "Silence is golden."
