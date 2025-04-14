Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175677E9;
	Mon, 14 Apr 2025 05:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609333; cv=none; b=LetU+2k5dYx+OxpTMSBfnxjjIaluA0aAkdDaj8JRqL44nWHIfYaz1iS/RdJOHm6+Ykl9WOZzFdxqVfY8gFoky9x1UtGzvwE5I8VkshN8B2Z4ClKg/c4OZq9E+HKYO8EE0sJ+aXofsrgNGjehT9b2u0rTT/rlUUSsYYT8ajEqN1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609333; c=relaxed/simple;
	bh=SsPn+OZhKOUhHgqy7dlm3QdSSdG3R6b/F+eMo8Wzj6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A1Br0OvkZleLNbj63y22tnt9RBG3NTg8CC2TtlKEhozoSWdDvb90KUPeOK2kG7nIUO3d/tSmZkPYyL+RPksPgatxiUUuIuXCT5djDnCvtVK9MMjr7unAGRK/w0Lc91H9IACXsvmS22OObpObpF3sFJ2yiI/11HylnGf6Y3oDlpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0sVsIUMi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0sVsIUMi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WlLpoLdl0ikWjAkG3JKdy29qefh1TJNwZl4Cla0sP9g=; b=0sVsIUMiKqayARcLmeCCKTzahc
	3cSCU16huD8sdaADr7ShY95P4vHAv+61zfvDuI/ofU2VMnqKsUpo8z5yXt9zvnIx5tOqKpNforv67
	sloNYmNRwJGdYtO4dAJ74No3/sJ48AySJ8DpABF4VCBd/D02nAMQK/rdkui3SyxkbP522RiH4qhkm
	sWqHkhuNxjgikd0sxGD2nf7xxzrtO5tzUR1NPQvRnlwgEDGhwt+ccSHKpAjKorxGDZnzavvdIzg3L
	m086Mjc8KKMKjEz83H7DPAy7+k5WGIevNSKDO2ZE9OwHiUaUuie8nW5aPAoGEDiGEuPJsaZ7m9JoW
	cPLd78Fw==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4Ca8-00000000iw8-3bP1;
	Mon, 14 Apr 2025 05:42:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] common: remove USE_EXTERNAL
Date: Mon, 14 Apr 2025 07:42:05 +0200
Message-ID: <20250414054205.361383-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The USE_EXTERNAL variable indicates that dedicated log or RT devices are
in use for the scratch and possibly test device.  It gets automatically
set when needed and generally does not provide any benefit over simply
testing the SCRATCH_LOGDEV and SCRATCH_RTDEV variables.

Remove it and replace that test with test for SCRATCH_LOGDEV and
SCRATCH_RTDEV, using the more readable if-based syntaxt for all tests
touched by this change.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 README                   |  1 -
 common/config            | 21 +++---------
 common/ext4              |  4 +--
 common/fail_make_request | 18 ++++++----
 common/metadump          |  8 +++--
 common/populate          | 16 +++++----
 common/quota             |  2 +-
 common/rc                | 52 +++++++++++++---------------
 common/xfs               | 73 +++++++++++++++++++++++++---------------
 tests/generic/537        |  6 ++--
 tests/generic/590        |  3 +-
 tests/xfs/070            |  6 ++--
 tests/xfs/096            |  2 +-
 tests/xfs/098            |  2 +-
 tests/xfs/157            |  6 ----
 tests/xfs/185            |  3 --
 tests/xfs/273            |  2 +-
 tests/xfs/277            |  2 +-
 tests/xfs/438            |  2 +-
 tests/xfs/520            |  2 +-
 tests/xfs/521            |  1 -
 tests/xfs/528            |  1 -
 tests/xfs/530            |  1 -
 23 files changed, 115 insertions(+), 119 deletions(-)

diff --git a/README b/README
index 024d395318f3..588573225712 100644
--- a/README
+++ b/README
@@ -188,7 +188,6 @@ Extra TEST device specifications:
 Extra SCRATCH device specifications:
  - Set SCRATCH_LOGDEV to "device for scratch-fs external log"
  - Set SCRATCH_RTDEV to "device for scratch-fs realtime data"
- - If SCRATCH_LOGDEV and/or SCRATCH_RTDEV, the USE_EXTERNAL environment
 
 Tape device specification for xfsdump testing:
  - Set TAPE_DEV to "tape device for testing xfsdump".
diff --git a/common/config b/common/config
index eada3971788d..7d8ac98e4e16 100644
--- a/common/config
+++ b/common/config
@@ -808,13 +808,11 @@ get_next_config() {
 	local OLD_TEST_FS_MOUNT_OPTS=$TEST_FS_MOUNT_OPTS
 	local OLD_MKFS_OPTIONS=$MKFS_OPTIONS
 	local OLD_FSCK_OPTIONS=$FSCK_OPTIONS
-	local OLD_USE_EXTERNAL=$USE_EXTERNAL
 
 	unset MOUNT_OPTIONS
 	unset TEST_FS_MOUNT_OPTS
 	unset MKFS_OPTIONS
 	unset FSCK_OPTIONS
-	unset USE_EXTERNAL
 
 	# We might have deduced SCRATCH_DEV from the SCRATCH_DEV_POOL in the previous
 	# run, so we have to unset it now.
@@ -828,20 +826,11 @@ get_next_config() {
 		[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
 		[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 		[ -z "$FSCK_OPTIONS" ] && _fsck_opts
-
-		# clear the external devices if we are not using them
-		if [ -z "$USE_EXTERNAL" ]; then
-			unset TEST_RTDEV
-			unset TEST_LOGDEV
-			unset SCRATCH_RTDEV
-			unset SCRATCH_LOGDEV
-		fi
 	else
 		[ -z "$MOUNT_OPTIONS" ] && export MOUNT_OPTIONS=$OLD_MOUNT_OPTIONS
 		[ -z "$TEST_FS_MOUNT_OPTS" ] && export TEST_FS_MOUNT_OPTS=$OLD_TEST_FS_MOUNT_OPTS
 		[ -z "$MKFS_OPTIONS" ] && export MKFS_OPTIONS=$OLD_MKFS_OPTIONS
 		[ -z "$FSCK_OPTIONS" ] && export FSCK_OPTIONS=$OLD_FSCK_OPTIONS
-		[ -z "$USE_EXTERNAL" ] && export USE_EXTERNAL=$OLD_USE_EXTERNAL
 	fi
 
 	# set default RESULT_BASE
@@ -889,12 +878,10 @@ get_next_config() {
 	_check_device SCRATCH_DEV optional $SCRATCH_DEV
 	export SCRATCH_MNT=`_canonicalize_mountpoint SCRATCH_MNT $SCRATCH_MNT`
 
-	if [ -n "$USE_EXTERNAL" ]; then
-		_check_device TEST_RTDEV optional $TEST_RTDEV
-		_check_device TEST_LOGDEV optional $TEST_LOGDEV
-		_check_device SCRATCH_RTDEV optional $SCRATCH_RTDEV
-		_check_device SCRATCH_LOGDEV optional $SCRATCH_LOGDEV
-	fi
+	_check_device TEST_RTDEV optional $TEST_RTDEV
+	_check_device TEST_LOGDEV optional $TEST_LOGDEV
+	_check_device SCRATCH_RTDEV optional $SCRATCH_RTDEV
+	_check_device SCRATCH_LOGDEV optional $SCRATCH_LOGDEV
 
 	# Override FSTYP from config when running ./check -overlay
 	# and maybe override base fs TEST/SCRATCH_DEV with overlay base dirs.
diff --git a/common/ext4 b/common/ext4
index f88fa5324441..732f66310e8e 100644
--- a/common/ext4
+++ b/common/ext4
@@ -84,7 +84,7 @@ _scratch_mkfs_ext4()
 	local tmp=`mktemp -u`
 	local mkfs_status
 
-	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ]; then
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 		$MKFS_EXT4_PROG -F -O journal_dev $MKFS_OPTIONS $* $SCRATCH_LOGDEV 2>$tmp.mkfserr 1>$tmp.mkfsstd
 		mkjournal_status=$?
 
@@ -219,7 +219,7 @@ _scratch_ext4_options()
 		log_opt="-o journal_path=$(realpath -q "$SCRATCH_LOGDEV")"
 		;;
 	esac
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	[ ! -z "$SCRATCH_LOGDEV" ] && \
 		SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${log_opt}"
 }
 
diff --git a/common/fail_make_request b/common/fail_make_request
index 564020215ffd..9bff21c40b4a 100644
--- a/common/fail_make_request
+++ b/common/fail_make_request
@@ -46,19 +46,23 @@ _start_fail_scratch_dev()
 
     _prepare_for_eio_shutdown $SCRATCH_DEV
     _bdev_fail_make_request $SCRATCH_DEV 1
-    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
-        _bdev_fail_make_request $SCRATCH_LOGDEV 1
-    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
-        _bdev_fail_make_request $SCRATCH_RTDEV 1
+    if [ ! -z "$SCRATCH_LOGDEV" ]; then
+	_bdev_fail_make_request $SCRATCH_LOGDEV 1
+    fi
+    if [ ! -z "$SCRATCH_RTDEV" ]; then
+	_bdev_fail_make_request $SCRATCH_RTDEV 1
+    fi
 }
 
 _stop_fail_scratch_dev()
 {
     echo "Make SCRATCH_DEV device operable again"
 
-    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
-        _bdev_fail_make_request $SCRATCH_RTDEV 0
-    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+    if [ ! -z "$SCRATCH_RTDEV" ]; then
+	_bdev_fail_make_request $SCRATCH_RTDEV 0
+    fi
+    if [ ! -z "$SCRATCH_LOGDEV" ]; then
         _bdev_fail_make_request $SCRATCH_LOGDEV 0
+    fi
     _bdev_fail_make_request $SCRATCH_DEV 0
 }
diff --git a/common/metadump b/common/metadump
index 61ba3cbb9164..90ca8e8a089e 100644
--- a/common/metadump
+++ b/common/metadump
@@ -38,10 +38,14 @@ _xfs_cleanup_verify_metadump()
 _scratch_xfs_can_metadump_v1()
 {
 	# metadump v1 does not support log devices
-	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_LOGDEV" ] && return 1
+	if [ -n "$SCRATCH_LOGDEV" ]; then
+		return 1
+	fi
 
 	# metadump v1 does not support realtime devices
-	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && return 1
+	if [ -n "$SCRATCH_RTDEV" ]; then
+		return 1
+	fi
 
 	return 0
 }
diff --git a/common/populate b/common/populate
index 50dc75d35259..3e0fb3ca478a 100644
--- a/common/populate
+++ b/common/populate
@@ -244,7 +244,7 @@ _populate_xfs_qmount_option()
 	if [ ! -f /proc/fs/xfs/xqmstat ]; then
 		# No quota support
 		return
-	elif [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_RTDEV}" ]; then
+	elif [ -n "${SCRATCH_RTDEV}" ]; then
 		# We have not mounted the scratch fs, so we can only check
 		# rtquota support from the test fs.  Skip the quota options if
 		# the test fs does not have an rt section.
@@ -1063,11 +1063,11 @@ _scratch_populate_cache_tag() {
 	local logdev_sz="none"
 	local rtdev_sz="none"
 
-	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_LOGDEV}" ]; then
+	if [ -n "${SCRATCH_LOGDEV}" ]; then
 		logdev_sz="$(blockdev --getsz "${SCRATCH_LOGDEV}")"
 	fi
 
-	if [ "${USE_EXTERNAL}" = "yes" ] && [ -n "${SCRATCH_RTDEV}" ]; then
+	if [ -n "${SCRATCH_RTDEV}" ]; then
 		rtdev_sz="$(blockdev --getsz "${SCRATCH_RTDEV}")"
 	fi
 
@@ -1097,9 +1097,9 @@ _scratch_populate_restore_cached() {
 		;;
 	"ext2"|"ext3"|"ext4")
 		local logdev=none
-		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		if [ ! -z "$SCRATCH_LOGDEV" ]; then
 			logdev=$SCRATCH_LOGDEV
-
+		fi
 		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}"
 		return $?
 		;;
@@ -1115,12 +1115,14 @@ _scratch_populate_save_metadump()
 	case "${FSTYP}" in
 	"xfs")
 		local logdev=none
-		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		if [ ! -z "$SCRATCH_LOGDEV" ]; then
 			logdev=$SCRATCH_LOGDEV
+		fi
 
 		local rtdev=none
-		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		if [ ! -z "$SCRATCH_RTDEV" ]; then
 			rtdev=$SCRATCH_RTDEV
+		fi
 
 		mdargs=('-a' '-o')
 		test "$(_xfs_metadump_max_version)" -gt 1 && \
diff --git a/common/quota b/common/quota
index a51386b1dd24..57cb0d1c23fe 100644
--- a/common/quota
+++ b/common/quota
@@ -453,7 +453,7 @@ _scratch_supports_rtquota()
 {
 	case "$FSTYP" in
 	"xfs")
-		if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ]; then
+		if [ -n "$SCRATCH_RTDEV" ]; then
 			_xfs_scratch_supports_rtquota
 			return
 		fi
diff --git a/common/rc b/common/rc
index 9bed6dad9303..1005f332eb2a 100644
--- a/common/rc
+++ b/common/rc
@@ -385,10 +385,12 @@ _test_options()
         log_opt="-o"
 	;;
     esac
-    [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ] && \
+    if [ ! -z "$TEST_RTDEV" ]; then
 	TEST_OPTIONS="$TEST_OPTIONS ${rt_opt}rtdev=$TEST_RTDEV"
-    [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
+    fi
+    if [ ! -z "$TEST_LOGDEV" ]; then
 	TEST_OPTIONS="$TEST_OPTIONS ${log_opt}logdev=$TEST_LOGDEV"
+    fi
 }
 
 # Used for mounting non-scratch devices (e.g. loop, dm constructs)
@@ -979,7 +981,7 @@ _scratch_mkfs()
 		mkfs_filter="grep -v -e ^Warning: -e \"^mke2fs \""
 
 		# put journal on separate device?
-		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		[ ! -z "$SCRATCH_LOGDEV" ] && \
 		$mkfs_cmd -O journal_dev $MKFS_OPTIONS $SCRATCH_LOGDEV && \
 		mkfs_cmd="$mkfs_cmd -J device=$SCRATCH_LOGDEV"
 		;;
@@ -1284,7 +1286,7 @@ _try_scratch_mkfs_sized()
 	ext2|ext3|ext4)
 		# Can't use _scratch_mkfs_ext4 here because the block count has
 		# to come after the device path.
-		if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ]; then
+		if [ -z "$SCRATCH_LOGDEV" ]; then
 			${MKFS_PROG} -F -O journal_dev $MKFS_OPTIONS $SCRATCH_LOGDEV || \
 				_notrun "Could not make scratch logdev"
 			MKFS_OPTIONS="$MKFS_OPTIONS -J device=$SCRATCH_LOGDEV"
@@ -2285,8 +2287,10 @@ _require_test()
 _has_logdev()
 {
 	local ret=0
-	[ -z "$SCRATCH_LOGDEV" -o ! -b "$SCRATCH_LOGDEV" ] && ret=1
-	[ "$USE_EXTERNAL" != yes ] && ret=1
+
+	if [ -z "$SCRATCH_LOGDEV" -o ! -b "$SCRATCH_LOGDEV" ]; then
+		ret=1
+	fi
 
 	return $ret
 }
@@ -2297,8 +2301,6 @@ _require_logdev()
 {
     [ -z "$SCRATCH_LOGDEV" -o ! -b "$SCRATCH_LOGDEV" ] && \
         _notrun "This test requires a valid \$SCRATCH_LOGDEV"
-    [ "$USE_EXTERNAL" != yes ] && \
-        _notrun "This test requires USE_EXTERNAL to be enabled"
 
     # ensure its not mounted
     _unmount $SCRATCH_LOGDEV 2>/dev/null
@@ -2308,8 +2310,9 @@ _require_logdev()
 #
 _require_no_logdev()
 {
-	[ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_LOGDEV" ] && \
+	if [ -n "$SCRATCH_LOGDEV" ]; then
 		_notrun "Test not compatible with external logs, skipped this test"
+	fi
 }
 
 # this test requires loopback device support
@@ -2347,18 +2350,18 @@ _require_no_large_scratch_dev()
 #
 _require_realtime()
 {
-    [ "$USE_EXTERNAL" = yes ] || \
-	_notrun "External volumes not in use, skipped this test"
-    [ "$SCRATCH_RTDEV" = "" ] && \
-	_notrun "Realtime device required, skipped this test"
+	if [ "$SCRATCH_RTDEV" = "" ]; then
+		_notrun "Realtime device required, skipped this test"
+	fi
 }
 
 # This test requires that a realtime subvolume is not in use
 #
 _require_no_realtime()
 {
-	[ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ] && \
+	if [ -n "$SCRATCH_RTDEV" ]; then
 		_notrun "Test not compatible with realtime subvolumes, skipped this test"
+	fi
 }
 
 # this test requires that a specified command (executable) exists
@@ -2551,8 +2554,9 @@ _require_non_zoned_device()
 #
 _require_nonexternal()
 {
-    [ "$USE_EXTERNAL" = yes ] && \
+    if [ -n "$SCRATCH_RTDEV" -o -n "$SCRATCH_LOGDEV" ]; then
 	_notrun "External device testing in progress, skipped this test"
+    fi
 }
 
 # this test requires that the kernel supports asynchronous I/O
@@ -4956,19 +4960,11 @@ init_rc()
 		_exit 1
 	fi
 
-	# if $TEST_DEV is not mounted, mount it now as XFS
-	if [ -z "`_fs_type $TEST_DEV`" ]
-	then
-		# $TEST_DEV is not mounted
-		if ! _test_mount
-		then
-			echo "common/rc: retrying test device mount with external set"
-			[ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
-			if ! _test_mount
-			then
-				echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
-				_exit 1
-			fi
+	# if $TEST_DEV is not mounted, mount it now as $FSTYP
+	if [ -z "`_fs_type $TEST_DEV`" ]; then
+		if ! _test_mount; then
+			echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
+			_exit 1
 		fi
 	fi
 
diff --git a/common/xfs b/common/xfs
index 96c15f3c7bb0..d1f0277f4048 100644
--- a/common/xfs
+++ b/common/xfs
@@ -248,7 +248,7 @@ _xfs_get_dir_blocksize()
 # Decide if this path is a file on the realtime device
 _xfs_is_realtime_file()
 {
-	if [ "$USE_EXTERNAL" != "yes" ] || [ -z "$SCRATCH_RTDEV" ]; then
+	if [ -z "$SCRATCH_RTDEV" ]; then
 		return 1
 	fi
 	$XFS_IO_PROG -c 'stat -v' "$1" | grep -q -w realtime
@@ -308,18 +308,21 @@ _scratch_xfs_options()
         log_opt="-o"
 	;;
     esac
-    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+    if [ ! -z "$SCRATCH_RTDEV" ]; then
 	SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${rt_opt}rtdev=$SCRATCH_RTDEV"
-    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+    fi
+    if [ ! -z "$SCRATCH_LOGDEV" ]; then
 	SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${log_opt}logdev=$SCRATCH_LOGDEV"
+    fi
 }
 
 _scratch_xfs_db_options()
 {
 	SCRATCH_OPTIONS=""
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
-	if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_RTDEV" ]; then
+	fi
+	if [ ! -z "$SCRATCH_RTDEV" ]; then
 		$XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev' && \
 			SCRATCH_OPTIONS="$SCRATCH_OPTIONS -R$SCRATCH_RTDEV"
 	fi
@@ -334,8 +337,9 @@ _scratch_xfs_db()
 _test_xfs_db_options()
 {
 	TEST_OPTIONS=""
-	[ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
+	if [ ! -z "$TEST_LOGDEV" ]; then
 		TEST_OPTIONS="-l$TEST_LOGDEV"
+	fi
 	echo $TEST_OPTIONS $* $TEST_DEV
 }
 
@@ -348,9 +352,10 @@ _scratch_xfs_admin()
 {
 	local options=("$SCRATCH_DEV")
 	local rt_opts=()
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 		options+=("$SCRATCH_LOGDEV")
-	if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ]; then
+	fi
+	if [ -n "$SCRATCH_RTDEV" ]; then
 		$XFS_ADMIN_PROG --help 2>&1 | grep -q 'rtdev' || \
 			_notrun 'xfs_admin does not support rt devices'
 		rt_opts+=(-r "$SCRATCH_RTDEV")
@@ -367,16 +372,18 @@ _scratch_xfs_admin()
 _scratch_xfs_logprint()
 {
 	SCRATCH_OPTIONS=""
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+	fi
 	$XFS_LOGPRINT_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
 _test_xfs_logprint()
 {
 	TEST_OPTIONS=""
-	[ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
+	if [ ! -z "$TEST_LOGDEV" ]; then
 		TEST_OPTIONS="-l$TEST_LOGDEV"
+	fi
 	$XFS_LOGPRINT_PROG $TEST_OPTIONS $* $TEST_DEV
 }
 
@@ -391,10 +398,12 @@ _require_libxfs_debug_flag() {
 _scratch_xfs_repair()
 {
 	SCRATCH_OPTIONS=""
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+	fi
+	if [ ! -z "$SCRATCH_RTDEV" ]; then
 		SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -r$SCRATCH_RTDEV"
+	fi
 	$XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
@@ -740,11 +749,13 @@ _scratch_xfs_metadump()
 	local logdev=none
 	local rtdev=none
 
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 		logdev=$SCRATCH_LOGDEV
+	fi
 
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+	if [ ! -z "$SCRATCH_RTDEV" ]; then
 		rtdev=$SCRATCH_RTDEV
+	fi
 
 	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" nocompress "$@"
 }
@@ -762,12 +773,13 @@ _scratch_xfs_mdrestore()
 	# the following conditions are met.
 	# 1. Metadump is in v2 format.
 	# 2. Metadump has contents dumped from an external log device.
-	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ]; then
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 		logdev=$SCRATCH_LOGDEV
 	fi
 
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+	if [ ! -z "$SCRATCH_RTDEV" ]; then
 		rtdev=$SCRATCH_RTDEV
+	fi
 
 	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" "$@"
 }
@@ -1026,11 +1038,13 @@ _check_xfs_test_fs()
 {
 	TEST_LOG="none"
 	TEST_RT="none"
-	[ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
+	if [ ! -z "$TEST_LOGDEV" ]; then
 		TEST_LOG="$TEST_LOGDEV"
+	fi
 
-	[ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ] && \
+	if [ ! -z "$TEST_RTDEV" ]; then
 		TEST_RT="$TEST_RTDEV"
+	fi
 
 	_check_xfs_filesystem $TEST_DEV $TEST_LOG $TEST_RT
 	return $?
@@ -1041,12 +1055,13 @@ _check_xfs_scratch_fs()
 	local device="${1:-$SCRATCH_DEV}"
 	local scratch_log="none"
 	local scratch_rt="none"
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 	    scratch_log="$SCRATCH_LOGDEV"
+	fi
 
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+	if [ ! -z "$SCRATCH_RTDEV" ]; then
 	    scratch_rt="$SCRATCH_RTDEV"
-
+	fi
 	_check_xfs_filesystem $device $scratch_log $scratch_rt
 }
 
@@ -1054,10 +1069,12 @@ _check_xfs_scratch_fs()
 _test_xfs_repair()
 {
 	TEST_OPTIONS=""
-	[ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
+	if [ ! -z "$TEST_LOGDEV" ]; then
 		TEST_OPTIONS="-l$TEST_LOGDEV"
-	[ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ] && \
+	fi
+	if [ ! -z "$TEST_RTDEV" ]; then
 		TEST_OPTIONS=$TEST_OPTIONS" -r$TEST_RTDEV"
+	fi
 	[ "$LARGE_TEST_DEV" = yes ] && TEST_OPTIONS=$TEST_OPTIONS" -t"
 	$XFS_REPAIR_PROG $TEST_OPTIONS $* $TEST_DEV
 }
@@ -1553,8 +1570,10 @@ _try_wipe_scratch_xfs()
 _require_xfs_copy()
 {
 	[ -n "$XFS_COPY_PROG" ] || _notrun "xfs_copy binary not yet installed"
-	[ "$USE_EXTERNAL" = yes ] && \
+
+	if [ -n "$SCRATCH_RTDEV" -o -n "$SCRATCH_LOGDEV" ]; then
 		_notrun "Cannot xfs_copy with external devices"
+	fi
 
 	$XFS_INFO_PROG "$TEST_DIR" | grep -q 'realtime.*internal' &&
 		_notrun "Cannot xfs_copy with internal rt device"
@@ -2054,7 +2073,7 @@ _scratch_xfs_force_no_metadir()
 {
 	_require_non_zoned_device $SCRATCH_DEV
 	# metadir is required for when the rt device is on a zoned device
-	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
+	if [ ! -z "$SCRATCH_RTDEV" ]; then
 		_require_non_zoned_device $SCRATCH_RTDEV
 	fi
 
@@ -2184,8 +2203,6 @@ _xfs_fs_supports_rtquota() {
 
 	test -d "$mntpt" || \
 		echo "_xfs_fs_supports_rtquota needs a mountpoint"
-	test "$USE_EXTERNAL" == "yes" || \
-		echo "_xfs_fs_supports_rtquota needs USE_EXTERNAL=yes"
 	test -n "$rtdev" || \
 		echo "_xfs_fs_supports_rtquota needs an rtdev"
 
@@ -2209,7 +2226,7 @@ _xfs_scratch_supports_rtquota() {
 # can check that quickly, and we make the bold assumption that the same will
 # apply to any scratch fs that might be created.
 _require_xfs_rtquota_if_rtdev() {
-	if [ "$USE_EXTERNAL" != "yes" ]; then
+        if [ -z "$SCRATCH_RTDEV" ]; then
 		$XFS_INFO_PROG "$TEST_DIR" | grep -q 'realtime.*internal' &&
 			_notrun "Quota on internal rt device not supported"
 	fi
diff --git a/tests/generic/537 b/tests/generic/537
index 3be743c4133f..87673447f64c 100755
--- a/tests/generic/537
+++ b/tests/generic/537
@@ -47,10 +47,8 @@ _scratch_unmount
 # ondisk metadata and reject the mount because it thinks that will require
 # quotacheck.  Edit out the quota mount options for this specific
 # configuration.
-if [ "$FSTYP" = "xfs" ]; then
-	if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
-		_qmount_option ""
-	fi
+if [ "$FSTYP" = "xfs" -a -n "$SCRATCH_RTDEV" ]; then
+	_qmount_option ""
 fi
 
 echo "fstrim on ro mount with no log replay"
diff --git a/tests/generic/590 b/tests/generic/590
index ba1337a856f1..8ae5da493893 100755
--- a/tests/generic/590
+++ b/tests/generic/590
@@ -52,13 +52,12 @@ extra_options=""
 if [[ $FSTYP = xfs ]]; then
 	# If we don't have a realtime device, set up a loop device on the test
 	# filesystem.
-	if [[ $USE_EXTERNAL != yes || -z $SCRATCH_RTDEV ]]; then
+	if [[ -z $SCRATCH_RTDEV ]]; then
 		_require_test
 		loopsz="$((filesz + (1 << 26)))"
 		_require_fs_space "$TEST_DIR" $((loopsz / 1024))
 		$XFS_IO_PROG -c "truncate $loopsz" -f "$TEST_DIR/$seq"
 		loop_dev="$(_create_loop_device "$TEST_DIR/$seq")"
-		USE_EXTERNAL=yes
 		SCRATCH_RTDEV="$loop_dev"
 		disabled_features=()
 
diff --git a/tests/xfs/070 b/tests/xfs/070
index 143f56888c1e..9017f8ec6417 100755
--- a/tests/xfs/070
+++ b/tests/xfs/070
@@ -36,10 +36,12 @@ _cleanup()
 _xfs_repair_noscan()
 {
 	# invoke repair directly so we can kill the process if need be
-	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 		log_repair_opts="-l $SCRATCH_LOGDEV"
-	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
+	fi
+	if [ -n "$SCRATCH_RTDEV" ]; then
 		rt_repair_opts="-r $SCRATCH_RTDEV"
+	fi
 	$XFS_REPAIR_PROG $log_repair_opts $rt_repair_opts $SCRATCH_DEV 2>&1 |
 		tee -a $seqres.full > $tmp.repair &
 	repair_pid=$!
diff --git a/tests/xfs/096 b/tests/xfs/096
index 4c4fdfa12ef8..1dd249e64e6b 100755
--- a/tests/xfs/096
+++ b/tests/xfs/096
@@ -20,7 +20,7 @@ _require_scratch
 _require_xfs_quota
 _require_xfs_nocrc
 
-if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ]; then
+if [ -n "$SCRATCH_RTDEV" ]; then
 	_notrun "Realtime quotas not supported on V4 filesystems"
 fi
 
diff --git a/tests/xfs/098 b/tests/xfs/098
index a47cda67e14e..4307ac9727c1 100755
--- a/tests/xfs/098
+++ b/tests/xfs/098
@@ -66,7 +66,7 @@ logstart="$(_scratch_xfs_get_sb_field logstart)"
 logstart="$(_scratch_xfs_db -c "convert fsblock ${logstart} byte" | sed -e 's/^.*(\([0-9]*\).*$/\1/g')"
 logblocks="$(_scratch_xfs_get_sb_field logblocks)"
 
-if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_LOGDEV" ]; then
+if [ ! -z "$SCRATCH_LOGDEV" ]; then
 	logdev=$SCRATCH_LOGDEV
 else
 	logdev=$SCRATCH_DEV
diff --git a/tests/xfs/157 b/tests/xfs/157
index e102a5a10abe..0a3a5c11e109 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -52,7 +52,6 @@ truncate -s $fs_size $fake_rtfile
 
 # Save the original variables
 orig_ddev=$SCRATCH_DEV
-orig_external=$USE_EXTERNAL
 orig_logdev=$SCRATCH_LOGDEV
 orig_rtdev=$SCRATCH_RTDEV
 
@@ -60,7 +59,6 @@ scenario() {
 	echo "$@" | tee -a $seqres.full
 
 	SCRATCH_DEV=$orig_ddev
-	USE_EXTERNAL=$orig_external
 	SCRATCH_LOGDEV=$orig_logdev
 	SCRATCH_RTDEV=$orig_rtdev
 }
@@ -78,23 +76,19 @@ SCRATCH_DEV=$fake_datafile
 check_label -f
 
 scenario "S2: Check that setting with logdev works"
-USE_EXTERNAL=yes
 SCRATCH_LOGDEV=$fake_logfile
 check_label
 
 scenario "S3: Check that setting with rtdev works"
-USE_EXTERNAL=yes
 SCRATCH_RTDEV=$fake_rtfile
 check_label
 
 scenario "S4: Check that setting with rtdev + logdev works"
-USE_EXTERNAL=yes
 SCRATCH_LOGDEV=$fake_logfile
 SCRATCH_RTDEV=$fake_rtfile
 check_label
 
 scenario "S5: Check that setting with nortdev + nologdev works"
-USE_EXTERNAL=
 SCRATCH_LOGDEV=
 SCRATCH_RTDEV=
 check_label
diff --git a/tests/xfs/185 b/tests/xfs/185
index 7aceb383ce46..3cf0e14b31ef 100755
--- a/tests/xfs/185
+++ b/tests/xfs/185
@@ -27,7 +27,6 @@ _cleanup()
 	test -n "$rtloop" && _destroy_loop_device "$rtloop"
 	test -n "$ddfile" && rm -f "$ddfile"
 	test -n "$rtfile" && rm -f "$rtfile"
-	test -n "$old_use_external" && USE_EXTERNAL="$old_use_external"
 }
 
 _require_test
@@ -67,8 +66,6 @@ test $ddmajor -le $rtmajor || \
 # Inject our custom-built devices as an rt-capable scratch device.
 # We avoid touching "require_scratch" so that post-test fsck will not try to
 # run on our synthesized scratch device.
-old_use_external="$USE_EXTERNAL"
-USE_EXTERNAL=yes
 SCRATCH_RTDEV="$rtloop"
 SCRATCH_DEV="$ddloop"
 
diff --git a/tests/xfs/273 b/tests/xfs/273
index 7e743179975e..f253074e3ec3 100755
--- a/tests/xfs/273
+++ b/tests/xfs/273
@@ -48,7 +48,7 @@ ddev_daddrs=$((ddev_fsblocks * fsblock_bytes / 512))
 rtdev_daddrs=$((rtdev_fsblocks * fsblock_bytes / 512))
 
 ddev_devno=$(stat -c '%t:%T' $SCRATCH_DEV)
-if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
+if [ -n "$SCRATCH_RTDEV" ]; then
 	rtdev_devno=$(stat -c '%t:%T' $SCRATCH_RTDEV)
 fi
 
diff --git a/tests/xfs/277 b/tests/xfs/277
index 87423b96454f..874b4c429f71 100755
--- a/tests/xfs/277
+++ b/tests/xfs/277
@@ -21,7 +21,7 @@ _cleanup()
 
 _require_xfs_scratch_rmapbt
 _require_xfs_io_command "fsmap"
-if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_LOGDEV" ]; then
+if [ -n "$SCRATCH_LOGDEV" ]; then
 	_notrun "Cannot have external log device"
 fi
 
diff --git a/tests/xfs/438 b/tests/xfs/438
index 6d1988c8b9b8..92fa2264571d 100755
--- a/tests/xfs/438
+++ b/tests/xfs/438
@@ -46,7 +46,7 @@ make_xfs_scratch_flakey_table()
 
 	# If using an external log device, just making the writing of
 	# entire data/metadata area fail forever.
-	if [ "${USE_EXTERNAL}" = "yes" -a ! -z "$SCRATCH_LOGDEV" ]; then
+	if [ ! -z "$SCRATCH_LOGDEV" ]; then
 		echo "0 ${dev_sz} $tgt $dev 0 $opt"
 		return
 	fi
diff --git a/tests/xfs/520 b/tests/xfs/520
index 2d80188b2972..f52689b82945 100755
--- a/tests/xfs/520
+++ b/tests/xfs/520
@@ -31,7 +31,7 @@ _require_check_dmesg
 _require_scratch_nocheck
 
 # Don't let the rtbitmap fill up the data device and screw up this test
-unset USE_EXTERNAL
+unset SCRATCH_RTDEV
 
 force_crafted_metadata() {
 	_scratch_mkfs_xfs -f $fsdsopt "$4" >> $seqres.full 2>&1
diff --git a/tests/xfs/521 b/tests/xfs/521
index 0da05a55a276..74f9018056c0 100755
--- a/tests/xfs/521
+++ b/tests/xfs/521
@@ -38,7 +38,6 @@ truncate -s 400m $TEST_DIR/$seq.rtvol
 rt_loop_dev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
 
 echo "Format and mount 100m rt volume"
-export USE_EXTERNAL=yes
 export SCRATCH_RTDEV=$rtdev
 _scratch_mkfs -r size=100m > $seqres.full
 _try_scratch_mount || _notrun "Could not mount scratch with synthetic rt volume"
diff --git a/tests/xfs/528 b/tests/xfs/528
index a1efbbd27b96..61a3875aa131 100755
--- a/tests/xfs/528
+++ b/tests/xfs/528
@@ -158,7 +158,6 @@ $XFS_IO_PROG -f -c "truncate 400m" $TEST_DIR/$seq.rtvol
 rt_loop_dev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
 
 echo "Make sure synth rt volume works"
-export USE_EXTERNAL=yes
 export SCRATCH_RTDEV=$rt_loop_dev
 _scratch_mkfs > $seqres.full
 _try_scratch_mount || \
diff --git a/tests/xfs/530 b/tests/xfs/530
index 4a41127e3b82..70524ee626ef 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -56,7 +56,6 @@ rt_loop_dev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
 
 echo "Format and mount rt volume"
 
-export USE_EXTERNAL=yes
 export SCRATCH_RTDEV=$rt_loop_dev
 _scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
 	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
-- 
2.47.2

