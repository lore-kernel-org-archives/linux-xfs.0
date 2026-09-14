Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21684908AF;
	Mon, 14 Sep 2026 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406731; cv=none; b=kWuwMR+YT6/Bn9MbAHsUwHMUSQKWv7SWS6UiGfst9klf6IZ6XP/oM5UFul0hPk5zaRd7xEgAjd2O2lITFeFUm7mq7SrH4WRa1uwFoFLKPguj9lI3t/xEpP6O4UC23038GTVrhukNatxuPnhUDXEmjxSmIgFhhWn9dxzLKAIwSC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406731; c=relaxed/simple;
	bh=RZBO9kQpSdlKQ1mGmQx4AoPixxFkoPkI7eOttBAq720=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOuUnhmH4hsXuzScDBNdR6cRa8NnDZSP7kPKvtknXbIVpdVovHOhrbgtK0IK3GHmN21ZZ7Vk1VkgAWltkZXiHLzwfLrBWikX2CKpn4kgRR5MYdSIGuXcU77s8XtIntEkSRA4KRmDkONwvbmscajO2HszzHy7zAfjeEGYqmMy7KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SA/Ir9VW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SA/Ir9VW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5E81F00893;
	Mon, 14 Sep 2026 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789406729;
	bh=HxkQWs5m30oHfaPb1/RQzXP/gcEYqiniyU3aupIV01A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SA/Ir9VWDpBwah5S3hRxpaOi6XiKXFPytCwkNEt2F7/v2HeMj7P5JoAzSS2RxqTkt
	 qKzNq7lakdcg5oRC60dfp8IO5rgpn9qhmNIixamlUfuTY8hmnD3eOtvTGmeGGAmpqg
	 EpBlpHrHwzFunmcrXKNNbcPBZ3b5tg8jXiW2u7I+staVRXd6EnD764ykNQlvZp1kU3
	 qQBm4tmUjEXCFSz4mKbHR/3ucKWag5dO2EcF3pVlAc1sLxGCG51hwsZs3JI4YoCxh2
	 /FWbnjq9Z3yS3rdVBG+Emk0Yq825lLrp98lRPFebkbwwWpHMuZ2pON3ItkDt0tLAnr
	 G0KkP9Ez+yN0Q==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 1/5] fstests: consolidate _require_fs_sysfs and _require_fs_sysfs_attr
Date: Tue, 15 Sep 2026 01:25:05 +0800
Message-ID: <20260914172509.3799016-2-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914172509.3799016-1-zlang@kernel.org>
References: <20260914172509.3799016-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is heavy overlap between _require_fs_sysfs and
_require_fs_sysfs_attr, and their ambiguous names make it difficult
to tell them apart.

So merge them into a single function with "_dev_" included in the
name to distinguish per-device entries from other paths like
/sys/fs/$FSTYP/features/.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/btrfs    |  4 +--
 common/rc       | 70 ++++++++++++++++++++-----------------------------
 common/sysfs    |  6 ++---
 common/xfs      | 22 ++++++++--------
 tests/btrfs/253 | 26 +++++++++---------
 tests/btrfs/285 |  2 +-
 tests/btrfs/334 |  2 +-
 tests/f2fs/025  |  2 +-
 tests/xfs/006   |  4 +--
 tests/xfs/177   |  4 +--
 tests/xfs/264   | 14 +++++-----
 tests/xfs/668   |  6 ++---
 tests/xfs/669   |  6 ++---
 tests/xfs/670   |  2 +-
 14 files changed, 78 insertions(+), 92 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index 0bfb02dd..fb1523ab 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -903,8 +903,8 @@ _qgroup_mode()
 		_fail "Usage: _qgroup_mode <mounted_device>"
 	fi
 
-	if _has_fs_sysfs_attr $dev /qgroups/mode; then
-		_get_fs_sysfs_attr $dev qgroups/mode
+	if _has_fs_sysfs_dev_attr $dev /qgroups/mode; then
+		_get_fs_sysfs_dev_attr $dev qgroups/mode
 	else
 		echo "qgroup"
 	fi
diff --git a/common/rc b/common/rc
index 8add0eed..b99e28a5 100644
--- a/common/rc
+++ b/common/rc
@@ -4209,7 +4209,7 @@ _require_fs_survives_data_write_eio()
 		# This is an XFS per-mount sysfs attribute, not a block queue
 		# attribute.  Its existence means XFS mounted this instance with
 		# zoned filesystem semantics.
-		if _has_fs_sysfs_attr "$dev" "zoned/max_open_zones"; then
+		if _has_fs_sysfs_dev_attr "$dev" "zoned/max_open_zones"; then
 			_notrun "zoned XFS shuts down on data write EIO"
 		fi
 		;;
@@ -5445,8 +5445,8 @@ _fs_sysfs_dname()
 #  - content: the content of $attr
 #
 # Usage example:
-#   _set_fs_sysfs_attr /dev/mapper/scratch-dev error/fail_at_unmount 0
-_set_fs_sysfs_attr()
+#   _set_fs_sysfs_dev_attr /dev/mapper/scratch-dev error/fail_at_unmount 0
+_set_fs_sysfs_dev_attr()
 {
 	local dev=$1
 	shift
@@ -5455,7 +5455,7 @@ _set_fs_sysfs_attr()
 	local content="$*"
 
 	if [ ! -b "$dev" -o -z "$attr" -o -z "$content" ];then
-		_fail "Usage: _set_fs_sysfs_attr <mounted_device> <attr> <content>"
+		_fail "Usage: _set_fs_sysfs_dev_attr <mounted_device> <attr> <content>"
 	fi
 
 	local dname=$(_fs_sysfs_dname $dev)
@@ -5471,14 +5471,14 @@ _set_fs_sysfs_attr()
 #  - attr: path name under /sys/fs/$FSTYP/$dev
 #
 # Usage example:
-#   _get_fs_sysfs_attr /dev/mapper/scratch-dev error/fail_at_unmount
-_get_fs_sysfs_attr()
+#   _get_fs_sysfs_dev_attr /dev/mapper/scratch-dev error/fail_at_unmount
+_get_fs_sysfs_dev_attr()
 {
 	local dev=$1
 	local attr=$2
 
 	if [ ! -b "$dev" -o -z "$attr" ];then
-		_fail "Usage: _get_fs_sysfs_attr <mounted_device> <attr>"
+		_fail "Usage: _get_fs_sysfs_dev_attr <mounted_device> <attr>"
 	fi
 
 	local dname=$(_fs_sysfs_dname $dev)
@@ -5493,14 +5493,14 @@ _get_fs_sysfs_attr()
 #  - attr: path name under /sys/fs/$FSTYP/$dev
 #
 # Usage example:
-#   _has_fs_sysfs_attr /dev/mapper/scratch-dev error/fail_at_unmount
-_has_fs_sysfs_attr()
+#   _has_fs_sysfs_dev_attr /dev/mapper/scratch-dev error/fail_at_unmount
+_has_fs_sysfs_dev_attr()
 {
 	local dev=$1
 	local attr=$2
 
 	if [ ! -b "$dev" -o -z "$attr" ];then
-		_fail "Usage: _has_fs_sysfs_attr <mounted_device> <attr>"
+		_fail "Usage: _has_fs_sysfs_dev_attr <mounted_device> <attr>"
 	fi
 
 	local dname=$(_fs_sysfs_dname $dev)
@@ -5509,43 +5509,29 @@ _has_fs_sysfs_attr()
 }
 
 # Require the existence of a sysfs entry at /sys/fs/$FSTYP/$DEV/$ATTR
-# All arguments are necessary, and in this order:
+#
+# If only one argument is given, it is taken as the attribute under
+# $TEST_DEV.  Otherwise the arguments are, in this order:
 #  - dev: device name, e.g. $SCRATCH_DEV
 #  - attr: path name under /sys/fs/$FSTYP/$dev
 #
-# Usage example:
-#   _require_fs_sysfs_attr /dev/mapper/scratch-dev error/fail_at_unmount
-_require_fs_sysfs_attr()
+# Usage examples:
+#   _require_fs_sysfs_dev_attr error/fail_at_unmount
+#   _require_fs_sysfs_dev_attr /dev/mapper/scratch-dev error/fail_at_unmount
+_require_fs_sysfs_dev_attr()
 {
-	_has_fs_sysfs_attr "$@" && return
-
-	local dev=$1
-	local attr=$2
-	local dname=$(_fs_sysfs_dname $dev)
-
-	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
-}
+	local dev attr
 
-# Test for the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
-#
-# Only one argument is needed:
-#  - attr: path name under /sys/fs/$FSTYP/DEV
-#
-# Usage example:
-#   _has_fs_sysfs error/fail_at_unmount
-_has_fs_sysfs()
-{
-	_has_fs_sysfs_attr $TEST_DEV "$@"
-}
-
-# Require the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
-_require_fs_sysfs()
-{
-	_has_fs_sysfs "$@" && return
-
-	local attr=$1
-	local dname=$(_short_dev $TEST_DEV)
+	if [ $# -eq 1 ];then
+		dev=$TEST_DEV
+		attr=$1
+	else
+		dev=$1
+		attr=$2
+	fi
+	_has_fs_sysfs_dev_attr "$dev" "$attr" && return
 
+	local dname=$(_fs_sysfs_dname $dev)
 	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
 }
 
@@ -6266,7 +6252,7 @@ _require_fanotify_ioerrors()
 		;;
 	ext4)
 		# added at the same time as err_report_sec
-		x="$(_get_fs_sysfs_attr $TEST_DEV err_report_sec)"
+		x="$(_get_fs_sysfs_dev_attr $TEST_DEV err_report_sec)"
 		test -n "$x" && return 0
 		;;
 	f2fs)
diff --git a/common/sysfs b/common/sysfs
index 16d4b482..c36ab426 100644
--- a/common/sysfs
+++ b/common/sysfs
@@ -61,11 +61,11 @@ _set_sysfs_policy()
 	shift
 	local policy=$@
 
-	_set_fs_sysfs_attr $dev $attr ${policy}
+	_set_fs_sysfs_dev_attr $dev $attr ${policy}
 
 	case "$FSTYP" in
 	btrfs)
-		_get_fs_sysfs_attr $dev $attr | grep -q "[${policy}]"
+		_get_fs_sysfs_dev_attr $dev $attr | grep -q "[${policy}]"
 		if [[ $? != 0 ]]; then
 			echo "Setting sysfs $attr $policy failed"
 		fi
@@ -85,7 +85,7 @@ _set_sysfs_policy_must_fail()
 	shift
 	local policy=$@
 
-	_set_fs_sysfs_attr $dev $attr ${policy} | _filter_sysfs_error \
+	_set_fs_sysfs_dev_attr $dev $attr ${policy} | _filter_sysfs_error \
 							   | tee -a $seqres.full
 }
 
diff --git a/common/xfs b/common/xfs
index 98981e62..cb484a06 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1167,23 +1167,23 @@ _reset_xfs_sysfs_error_handling()
 		_fail "Usage: reset_xfs_sysfs_error_handling <device>"
 	fi
 
-	_set_fs_sysfs_attr $dev error/fail_at_unmount 1
+	_set_fs_sysfs_dev_attr $dev error/fail_at_unmount 1
 	echo -n "error/fail_at_unmount="
-	_get_fs_sysfs_attr $dev error/fail_at_unmount
+	_get_fs_sysfs_dev_attr $dev error/fail_at_unmount
 
 	# Make sure all will be configured to retry forever by default, except
 	# for ENODEV, which is an unrecoverable error, so it will be configured
 	# to not retry on error by default.
 	for e in default EIO ENOSPC; do
-		_set_fs_sysfs_attr $dev \
+		_set_fs_sysfs_dev_attr $dev \
 				   error/metadata/${e}/max_retries -1
 		echo -n "error/metadata/${e}/max_retries="
-		_get_fs_sysfs_attr $dev error/metadata/${e}/max_retries
+		_get_fs_sysfs_dev_attr $dev error/metadata/${e}/max_retries
 
-		_set_fs_sysfs_attr $dev \
+		_set_fs_sysfs_dev_attr $dev \
 				   error/metadata/${e}/retry_timeout_seconds -1
 		echo -n "error/metadata/${e}/retry_timeout_seconds="
-		_get_fs_sysfs_attr $dev \
+		_get_fs_sysfs_dev_attr $dev \
 				   error/metadata/${e}/retry_timeout_seconds
 	done
 }
@@ -1226,13 +1226,13 @@ _xfs_prepare_for_eio_shutdown()
 	_add_dmesg_filter "Internal error"
 
 	# Don't retry any writes during the (presumably) post-shutdown unmount
-	_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 1
+	_has_fs_sysfs_dev_attr $dev "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 1
 
 	# Disable retry of metadata writes that fail with EIO
 	for ctl in max_retries retry_timeout_seconds; do
 		ctlfile="error/metadata/EIO/$ctl"
 
-		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 0
+		_has_fs_sysfs_dev_attr $dev "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 0
 	done
 }
 
@@ -2146,7 +2146,7 @@ _scratch_xfs_force_no_metadir()
 # do not run on zoned file systems
 _require_xfs_scratch_non_zoned()
 {
-	if _has_fs_sysfs_attr $SCRATCH_DEV "zoned/max_open_zones"; then
+	if _has_fs_sysfs_dev_attr $SCRATCH_DEV "zoned/max_open_zones"; then
 		_notrun "Not supported on zoned file systems"
 	fi
 }
@@ -2157,12 +2157,12 @@ _require_xfs_scratch_zoned()
 	local attr="zoned/max_open_zones"
 	local min_open_zones=$1
 
-	if ! _has_fs_sysfs_attr $SCRATCH_DEV $attr; then
+	if ! _has_fs_sysfs_dev_attr $SCRATCH_DEV $attr; then
 		_notrun "Requires zoned file system"
 	fi
 
 	if [ -n "${min_open_zones}" ]; then
-		local has_open_zones=`_get_fs_sysfs_attr $SCRATCH_DEV $attr`
+		local has_open_zones=`_get_fs_sysfs_dev_attr $SCRATCH_DEV $attr`
 
 		if [ "${min_open_zones}" -gt "${has_open_zones}" ]; then
 			_notrun "Requires at least ${min_open_zones} open zones"
diff --git a/tests/btrfs/253 b/tests/btrfs/253
index a0cc9b55..5843643d 100755
--- a/tests/btrfs/253
+++ b/tests/btrfs/253
@@ -90,8 +90,8 @@ _scratch_mkfs_sized $((10 * 1024 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 # Check if there is sufficient sysfs support.
-_require_fs_sysfs allocation/metadata/chunk_size
-_require_fs_sysfs allocation/metadata/force_chunk_alloc
+_require_fs_sysfs_dev_attr allocation/metadata/chunk_size
+_require_fs_sysfs_dev_attr allocation/metadata/force_chunk_alloc
 
 # Get free space.
 free_space  FREE_SPACE_MB
@@ -119,7 +119,7 @@ FIRST_DATA_CHUNK_SIZE_B=$((1024 * 1024 * 1024))
 
 # For metadata, we are safe to use the exported value, as the default
 # metadata chunk size limit is already smaller than its stripe size.
-FIRST_METADATA_CHUNK_SIZE_B=$(_get_fs_sysfs_attr ${SCRATCH_BDEV} allocation/metadata/chunk_size)
+FIRST_METADATA_CHUNK_SIZE_B=$(_get_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/metadata/chunk_size)
 
 echo "Orig Data chunk size    = ${FIRST_DATA_CHUNK_SIZE_B}"     >> ${seqres}.full
 echo "Orig Metaata chunk size = ${FIRST_METADATA_CHUNK_SIZE_B}" >> ${seqres}.full
@@ -138,8 +138,8 @@ alloc_size "Metadata" METADATA_SIZE_START_MB
 echo "Block group Data alloc size     = ${DATA_SIZE_START_MB}MB"     >> $seqres.full
 echo "Block group Metadata alloc size = ${METADATA_SIZE_START_MB}MB" >> $seqres.full
 
-_set_fs_sysfs_attr ${SCRATCH_BDEV} allocation/data/force_chunk_alloc 1
-_set_fs_sysfs_attr ${SCRATCH_BDEV} allocation/metadata/force_chunk_alloc 1
+_set_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/data/force_chunk_alloc 1
+_set_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/metadata/force_chunk_alloc 1
 
 alloc_size "Data"     FIRST_DATA_SIZE_MB
 alloc_size "Metadata" FIRST_METADATA_SIZE_MB
@@ -171,15 +171,15 @@ fi
 echo "Second block group Data alloc size     = ${SECOND_DATA_CHUNK_SIZE_B}"     >> $seqres.full
 echo "Second block group Metadata alloc size = ${SECOND_METADATA_CHUNK_SIZE_B}" >> $seqres.full
 
-_set_fs_sysfs_attr ${SCRATCH_BDEV} allocation/data/chunk_size ${SECOND_DATA_CHUNK_SIZE_B}
-_set_fs_sysfs_attr ${SCRATCH_BDEV} allocation/metadata/chunk_size ${SECOND_METADATA_CHUNK_SIZE_B}
+_set_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/data/chunk_size ${SECOND_DATA_CHUNK_SIZE_B}
+_set_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/metadata/chunk_size ${SECOND_METADATA_CHUNK_SIZE_B}
 
-SECOND_DATA_CHUNK_SIZE_READ_B=$(_get_fs_sysfs_attr ${SCRATCH_BDEV} allocation/data/chunk_size)
-SECOND_METADATA_CHUNK_SIZE_READ_B=$(_get_fs_sysfs_attr ${SCRATCH_BDEV} allocation/metadata/chunk_size)
+SECOND_DATA_CHUNK_SIZE_READ_B=$(_get_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/data/chunk_size)
+SECOND_METADATA_CHUNK_SIZE_READ_B=$(_get_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/metadata/chunk_size)
 
-_set_fs_sysfs_attr ${SCRATCH_BDEV} allocation/data/force_chunk_alloc 1
+_set_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/data/force_chunk_alloc 1
 echo "Allocated data chunk" >> $seqres.full
-_set_fs_sysfs_attr ${SCRATCH_BDEV} allocation/metadata/force_chunk_alloc 1
+_set_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/metadata/force_chunk_alloc 1
 echo "Allocated metadata chunk" >> $seqres.full
 
 alloc_size "Data"     SECOND_DATA_SIZE_MB
@@ -210,12 +210,12 @@ echo "Allocation size in bytes = ${THIRD_DATA_CHUNK_SIZE_B}"  >> ${seqres}.full
 # Do allocation until free space is exhausted.
 #
 echo "Third allocation."
-_set_fs_sysfs_attr ${SCRATCH_BDEV} allocation/data/chunk_size ${THIRD_DATA_CHUNK_SIZE_B}
+_set_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/data/chunk_size ${THIRD_DATA_CHUNK_SIZE_B}
 
 free_space FREE_SPACE_MB
 while [ $FREE_SPACE_MB -gt $THIRD_DATA_CHUNK_SIZE_MB ]; do
 	alloc_size "Data" THIRD_DATA_SIZE_MB
-	_set_fs_sysfs_attr ${SCRATCH_BDEV} allocation/data/force_chunk_alloc 1
+	_set_fs_sysfs_dev_attr ${SCRATCH_BDEV} allocation/data/force_chunk_alloc 1
 
 	free_space FREE_SPACE_MB
 done
diff --git a/tests/btrfs/285 b/tests/btrfs/285
index 5ceb69d4..6a1eb236 100755
--- a/tests/btrfs/285
+++ b/tests/btrfs/285
@@ -16,7 +16,7 @@ sysfs_size_classes() {
 
 _require_scratch
 _require_btrfs_fs_sysfs
-_require_fs_sysfs allocation/data/size_classes
+_require_fs_sysfs_dev_attr allocation/data/size_classes
 
 f="$SCRATCH_MNT/f"
 small=$((16 * 1024))
diff --git a/tests/btrfs/334 b/tests/btrfs/334
index d81ec921..08b66dc7 100755
--- a/tests/btrfs/334
+++ b/tests/btrfs/334
@@ -13,7 +13,7 @@ _begin_fstest auto quick
 . ./common/filter
 
 _require_test
-_require_fs_sysfs_attr $TEST_DEV allocation/data/chunk_size
+_require_fs_sysfs_dev_attr $TEST_DEV allocation/data/chunk_size
 
 _verify_sysfs_syntax $TEST_DEV allocation/data/chunk_size 256m
 
diff --git a/tests/f2fs/025 b/tests/f2fs/025
index 6fc18d98..31dd56a8 100755
--- a/tests/f2fs/025
+++ b/tests/f2fs/025
@@ -21,7 +21,7 @@ _require_scratch_shutdown
 _require_xfs_io_command "pwrite"
 _require_xfs_io_command "truncate"
 _require_f2fs_io_command gc_urgent
-_require_fs_sysfs_attr $TEST_DEV gc_urgent
+_require_fs_sysfs_dev_attr $TEST_DEV gc_urgent
 _require_check_dmesg
 
 # Clear options to avoid interference from external configurations
diff --git a/tests/xfs/006 b/tests/xfs/006
index 20fd104b..443e2db2 100755
--- a/tests/xfs/006
+++ b/tests/xfs/006
@@ -25,7 +25,7 @@ _cleanup()
 
 _require_scratch
 _require_dm_target error
-_require_fs_sysfs error/fail_at_unmount
+_require_fs_sysfs_dev_attr error/fail_at_unmount
 
 _scratch_mkfs > $seqres.full 2>&1
 _dmerror_init
@@ -38,7 +38,7 @@ _reset_xfs_sysfs_error_handling $DMERROR_DEV
 # errors at unmount time. _fail the test if we fail to set it to 1,
 # because the test probably will hang in such case and block
 # subsequent tests.
-attr=`_get_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount`
+attr=`_get_fs_sysfs_dev_attr $DMERROR_DEV error/fail_at_unmount`
 if [ "$attr" != "1" ]; then
 	_fail "Failed to set error/fail_at_unmount: $attr"
 fi
diff --git a/tests/xfs/177 b/tests/xfs/177
index 8d23f66d..e9b4661d 100755
--- a/tests/xfs/177
+++ b/tests/xfs/177
@@ -48,10 +48,10 @@ _require_scratch
 
 # We require /sys/fs/xfs/$device/stats/stats to monitor per-filesystem inode
 # cache usage.
-_require_fs_sysfs stats/stats
+_require_fs_sysfs_dev_attr stats/stats
 
 count_xfs_inode_objs() {
-	_get_fs_sysfs_attr $SCRATCH_DEV stats/stats | awk '/vnodes/ {print $2}'
+	_get_fs_sysfs_dev_attr $SCRATCH_DEV stats/stats | awk '/vnodes/ {print $2}'
 }
 
 dump_debug_info() {
diff --git a/tests/xfs/264 b/tests/xfs/264
index a6e816d3..0820eecd 100755
--- a/tests/xfs/264
+++ b/tests/xfs/264
@@ -24,9 +24,9 @@ _cleanup()
 
 _require_scratch
 _require_dm_target error
-_require_fs_sysfs error/fail_at_unmount
-_require_fs_sysfs error/metadata/EIO/max_retries
-_require_fs_sysfs error/metadata/EIO/retry_timeout_seconds
+_require_fs_sysfs_dev_attr error/fail_at_unmount
+_require_fs_sysfs_dev_attr error/metadata/EIO/max_retries
+_require_fs_sysfs_dev_attr error/metadata/EIO/retry_timeout_seconds
 
 _scratch_mkfs >> $seqres.full 2>&1
 _dmerror_init
@@ -39,12 +39,12 @@ do_test()
 	_dmerror_mount
 	_reset_xfs_sysfs_error_handling $DMERROR_DEV
 	# Disable fail_at_unmount before test EIO error handling
-	_set_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount 0
+	_set_fs_sysfs_dev_attr $DMERROR_DEV error/fail_at_unmount 0
 	echo -n "error/fail_at_unmount="
-	_get_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount
+	_get_fs_sysfs_dev_attr $DMERROR_DEV error/fail_at_unmount
 
-	_set_fs_sysfs_attr $DMERROR_DEV $attr 1
-	num=`_get_fs_sysfs_attr $DMERROR_DEV $attr`
+	_set_fs_sysfs_dev_attr $DMERROR_DEV $attr 1
+	num=`_get_fs_sysfs_dev_attr $DMERROR_DEV $attr`
 	echo "$attr=$num"
 	# _fail the test if we fail to set $attr to 1, because the test
 	# probably will hang in such case and block subsequent tests.
diff --git a/tests/xfs/668 b/tests/xfs/668
index 940a6a38..900099e8 100755
--- a/tests/xfs/668
+++ b/tests/xfs/668
@@ -36,7 +36,7 @@ done
 # remount read-only and set the gc limit to free up unused space
 _scratch_remount ro
 rt_available_pre="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
-_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
+_set_fs_sysfs_dev_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
 
 # reclaiming a zone with 5% used blocks should take way less than 1 second
 sleep 1
@@ -46,14 +46,14 @@ rt_available_post="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
 [ "$rt_available_post" -gt "$rt_available_pre" ] && \
 	_fail "gc should not run while read only"
 
-_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 0
+_set_fs_sysfs_dev_attr $SCRATCH_DEV "zoned/zonegc_low_space" 0
 
 # remount rw and check that gc starts, frees up blocks and stops after
 # the threshold is set to reclaim the unused blocks
 _scratch_remount rw
 
 rt_available_pre="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
-_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
+_set_fs_sysfs_dev_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
 
 i=0
 while [ $(_xfs_get_rt_gc_required "$SCRATCH_MNT") -eq "1" ]; do
diff --git a/tests/xfs/669 b/tests/xfs/669
index 25e3f04a..c9c5bc79 100755
--- a/tests/xfs/669
+++ b/tests/xfs/669
@@ -35,7 +35,7 @@ $MKFS_XFS_PROG -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
 _mount $SCRATCH_DEV $SCRATCH_MNT -o max_open_zones=${open_zones} || \
 	_notrun "Zoned allocator not supported"
 
-_has_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones || \
+_has_fs_sysfs_dev_attr $SCRATCH_DEV zoned/nr_open_zones || \
 	_notrun "This test requires /sys/fs/${FSTYP}/$SCRATCH_DEV/zoned/nr_open_zones"
 
 for i in $(seq 1 $nr_files); do
@@ -51,8 +51,8 @@ done
 _scratch_unmount
 _mount $SCRATCH_DEV $SCRATCH_MNT -o max_open_zones=${open_zones}
 
-max_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/max_open_zones)
-nr_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones)
+max_open=$(_get_fs_sysfs_dev_attr $SCRATCH_DEV zoned/max_open_zones)
+nr_open=$(_get_fs_sysfs_dev_attr $SCRATCH_DEV zoned/nr_open_zones)
 
 if [ ${max_open} -ne $((open_zones - 1)) ]; then
 	_fail "Test needs adjustments for multiple open GC zones"
diff --git a/tests/xfs/670 b/tests/xfs/670
index 9b248d96..a9df3deb 100755
--- a/tests/xfs/670
+++ b/tests/xfs/670
@@ -36,7 +36,7 @@ $XFS_GROWFS_PROG $SCRATCH_MNT -R $((2 * rblocks)) >> $seqres.full 2>&1 || \
 # For zoned file systems, check that the growfs did increase the available free
 # zones.  This avoids a hang on unfixed kernels when filling later.
 free_zones_post=$(_xfs_get_mountstat $SCRATCH_MNT "free zones:")
-if _has_fs_sysfs_attr $SCRATCH_DEV "zoned/max_open_zones"; then
+if _has_fs_sysfs_dev_attr $SCRATCH_DEV "zoned/max_open_zones"; then
 	if [ "$free_zones_pre" == "$free_zones_post" ]; then
 		_fail "growfs did not increase free zones"
 	fi
-- 
2.55.0

