Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20384 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdF3ENN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 00:13:13 -0400
Date: Thu, 29 Jun 2017 21:13:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/8] common/inject: refactor helpers to use new errortag
 interface
Message-ID: <20170630041308.GF5871@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
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
 common/inject |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 tests/xfs/051 |    7 ++++--
 tests/xfs/141 |    5 +++--
 tests/xfs/196 |   17 ++++++----------
 4 files changed, 73 insertions(+), 18 deletions(-)

diff --git a/common/inject b/common/inject
index 8ecc290..1f12a2b 100644
--- a/common/inject
+++ b/common/inject
@@ -35,10 +35,50 @@ _require_error_injection()
 	esac
 }
 
+# Find a given xfs mount's errortag injection knob in sysfs
+_find_xfs_errortag_knob()
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
+	"log_recovery_delay"|"bug_on_assert")
+		# These apply to all xfs filesystems
+		tagfile="/sys/fs/xfs/debug/${knob}"
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
+
+	# Can we find the error injection knobs via the new errortag
+	# configuration mechanism?
+	test -w "$(_find_xfs_errortag_knob "${TEST_DEV}" "${type}")" && return
+
 	_require_error_injection
 
 	# NOTE: We can't actually test error injection here because xfs
@@ -54,16 +94,34 @@ _require_xfs_io_error_injection()
 _test_inject_error()
 {
 	type="$1"
+	value="$2"
 
-	$XFS_IO_PROG -x -c "inject $type" $TEST_DIR
+	knob="$(_find_xfs_errortag_knob "${TEST_DEV}" "${type}")"
+	if [ -w "${knob}" ]; then
+		test -z "${value}" && value="default"
+		echo -n "${value}" > "${knob}"
+	elif [ -z "${value}" ] || [ "${value}" = "default" ]; then
+		$XFS_IO_PROG -x -c "inject $type" $TEST_DIR
+	else
+		_notrun "Cannot inject error ${type} value ${value}."
+	fi
 }
 
 # Inject an error into the scratch fs
 _scratch_inject_error()
 {
 	type="$1"
+	value="$2"
 
-	$XFS_IO_PROG -x -c "inject $type" $SCRATCH_MNT
+	knob="$(_find_xfs_errortag_knob "${SCRATCH_DEV}" "${type}")"
+	if [ -w "${knob}" ]; then
+		test -z "${value}" && value="default"
+		echo -n "${value}" > "${knob}"
+	elif [ -z "${value}" ] || [ "${value}" = "default" ]; then
+		$XFS_IO_PROG -x -c "inject $type" $SCRATCH_MNT
+	else
+		_notrun "Cannot inject error ${type} value ${value}."
+	fi
 }
 
 # Unmount and remount the scratch device, dumping the log
diff --git a/tests/xfs/051 b/tests/xfs/051
index f38743c..4d02b3c 100755
--- a/tests/xfs/051
+++ b/tests/xfs/051
@@ -43,6 +43,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/dmflakey
+. ./common/inject
 
 # Modify as appropriate.
 _supported_fs xfs
@@ -50,7 +51,7 @@ _supported_os Linux
 
 _require_scratch
 _require_dm_target flakey
-_require_xfs_sysfs debug/log_recovery_delay
+_require_xfs_io_error_injection "log_recovery_delay"
 _require_command "$KILLALL_PROG" killall
 
 echo "Silence is golden."
@@ -77,13 +78,13 @@ _load_flakey_table $FLAKEY_ALLOW_WRITES
 # initial writes to proceed (e.g., stale log block reset) and then let the
 # flakey uptime timer expire such that I/Os will fail by the time log recovery
 # starts.
-echo 10 > /sys/fs/xfs/debug/log_recovery_delay
+_test_inject_error "log_recovery_delay" 10
 
 # The mount should fail due to dm-flakey. Note that this is dangerous on kernels
 # without the xfs_buf log recovery race fixes.
 _mount_flakey > /dev/null 2>&1
 
-echo 0 > /sys/fs/xfs/debug/log_recovery_delay
+_test_inject_error "log_recovery_delay" 0
 
 _cleanup_flakey
 
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
index e9b0649..5afc343 100755
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
+_scratch_inject_error "drop_writes"
 
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
