Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787490;
	b=m2zPFgkmVwMz2cYspgx2jqUQzI2bakHbJKMaklQ3ZuiA3we8ugaCIX2iNbcAJ/+ls8mr
	 VSWlCHFMKxPJscDn2dZAnkJaf5MTsNdk9IqiMZN1XF1fCBBfBztMJAvZMTVGSp57HJPLa
	 65FvWJoR58XiAuG8k52mV7NAO5sgcIUCPxrDrPXMnfsWgt/jjqRlb0msGRA+blmYm2V6C
	 wDTpsFCEaM8OTqaclN24UdW45KET1FSPn22hqc85yhAsAkzpzYWPbK+jsjjKQ/SusCxIF
	 Pnv6kZcuobIcY2fex3n7mVNYzFHY4030mh2Y0c7MA/UJpJqqNEwftT5mKbAbp2kIxKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UliOVaCwk4TKvoISmg/0znmVUkTu+6NzB3YwkNrxI1o=;
	b=lSY4uRJI+LeP3PrQiRSqnSTVOfXaUf/fSO4mRqqooqUfMyeAwAenHLs2rlHuu2CqCXkp
	 8UmIOgX6Br+x2U6fIl3OI4JzrB5DDLmzxa+VYQTi/EkC0blb1Gph5M0N96Dx1QbCAhBDp
	 IbpOKfmc5kFqLScXoZtDjYgWcPxHblkw1NzGV3fLZ62oWQCnxvWuUN/igRaY8um4zeCH4
	 jOKwJyV5W3mBzDhMAeulbj2iHd3rvuKDVYqSbR4z32E4cZKbJz19OhchOeTUEBeKHXJ5p
	 Xe/BvpalAazRtcwYDvseHPYaoaXyuicZOaeONjuyFjVwXQRCacTlTIBpCqe48vb2IhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lL3CMicg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437EC606A31D;
	Fri, 23 Oct 2026 20:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lL3CMicg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E769F1F01828;
	Fri, 23 Oct 2026 20:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787489;
	bh=UliOVaCwk4TKvoISmg/0znmVUkTu+6NzB3YwkNrxI1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lL3CMicg3NKoB5X6z2RxW9tw48Pj1mId68aWw3at7inf+0N8n2Z7ABdiiPDc7tAR2
	 RJ5V3G84suqBCbK5nopl02mPDQ3gJye1DEa4ByWfJ0bmXgVnHi5i+pEKj+sWdRwQAv
	 GJf1PSp3U92mxRO0GoggUZ3eShRMDu3vjPnBbnGxokaCoaUHxILxR3eOTXxkpLV7fi
	 YyfGx8wrDFUtadX1yO41/kxxXaZqKeF6ZVwwRNcs+ARPIiP4EMTQ9PZ+bm9grqpMzF
	 N8MhsoNvhpLaHe5gTVdcBaOriVPXkwnDavNuF9claqw2u0FVLK7915Y65WJBDF7/0o
	 hKYr46p74fZbQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 1/6] fstests: rename _*_fs_sysfs_attr helpers to _*_fs_sysfs_dev_attr
Date: Sat, 24 Oct 2026 04:31:09 +0800
Message-ID: <20261023203114.1655019-2-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023203114.1655019-1-zlang@kernel.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The _set/_get/_has/_require_fs_sysfs_attr helpers all operate on
per-device sysfs entries under /sys/fs/$FSTYP/$dev.  Insert "_dev_"
into their names to distinguish them from other sysfs paths such as
/sys/fs/$FSTYP/features/, and update all callers. No functional
change.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/btrfs    |  4 ++--
 common/rc       | 30 +++++++++++++++---------------
 common/sysfs    |  6 +++---
 common/xfs      | 22 +++++++++++-----------
 tests/btrfs/253 | 22 +++++++++++-----------
 tests/btrfs/334 |  2 +-
 tests/f2fs/025  |  2 +-
 tests/xfs/006   |  2 +-
 tests/xfs/177   |  2 +-
 tests/xfs/264   |  8 ++++----
 tests/xfs/668   |  6 +++---
 tests/xfs/669   |  6 +++---
 tests/xfs/670   |  2 +-
 13 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index b1703b78..b52b4b11 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -906,8 +906,8 @@ _qgroup_mode()
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
index 1eccd60c..43c95930 100644
--- a/common/rc
+++ b/common/rc
@@ -4223,7 +4223,7 @@ _require_fs_survives_data_write_eio()
 		# This is an XFS per-mount sysfs attribute, not a block queue
 		# attribute.  Its existence means XFS mounted this instance with
 		# zoned filesystem semantics.
-		if _has_fs_sysfs_attr "$dev" "zoned/max_open_zones"; then
+		if _has_fs_sysfs_dev_attr "$dev" "zoned/max_open_zones"; then
 			_notrun "zoned XFS shuts down on data write EIO"
 		fi
 		;;
@@ -5481,8 +5481,8 @@ _fs_sysfs_dname()
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
@@ -5491,7 +5491,7 @@ _set_fs_sysfs_attr()
 	local content="$*"
 
 	if [ ! -b "$dev" -o -z "$attr" -o -z "$content" ];then
-		_fail "Usage: _set_fs_sysfs_attr <mounted_device> <attr> <content>"
+		_fail "Usage: _set_fs_sysfs_dev_attr <mounted_device> <attr> <content>"
 	fi
 
 	local dname=$(_fs_sysfs_dname $dev)
@@ -5507,14 +5507,14 @@ _set_fs_sysfs_attr()
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
@@ -5529,14 +5529,14 @@ _get_fs_sysfs_attr()
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
@@ -5550,10 +5550,10 @@ _has_fs_sysfs_attr()
 #  - attr: path name under /sys/fs/$FSTYP/$dev
 #
 # Usage example:
-#   _require_fs_sysfs_attr /dev/mapper/scratch-dev error/fail_at_unmount
-_require_fs_sysfs_attr()
+#   _require_fs_sysfs_dev_attr /dev/mapper/scratch-dev error/fail_at_unmount
+_require_fs_sysfs_dev_attr()
 {
-	_has_fs_sysfs_attr "$@" && return
+	_has_fs_sysfs_dev_attr "$@" && return
 
 	local dev=$1
 	local attr=$2
@@ -5571,7 +5571,7 @@ _require_fs_sysfs_attr()
 #   _has_fs_sysfs error/fail_at_unmount
 _has_fs_sysfs()
 {
-	_has_fs_sysfs_attr $TEST_DEV "$@"
+	_has_fs_sysfs_dev_attr $TEST_DEV "$@"
 }
 
 # Require the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
@@ -6302,7 +6302,7 @@ _require_fanotify_ioerrors()
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
index 318b1a3b..8bd144e3 100644
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
+	_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 1
 
 	# Disable retry of metadata writes that fail with EIO
 	for ctl in max_retries retry_timeout_seconds; do
 		ctlfile="error/metadata/EIO/$ctl"
 
-		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 0
+		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 0
 	done
 }
 
@@ -2149,7 +2149,7 @@ _scratch_xfs_force_no_metadir()
 # do not run on zoned file systems
 _require_xfs_scratch_non_zoned()
 {
-	if _has_fs_sysfs_attr $SCRATCH_DEV "zoned/max_open_zones"; then
+	if _has_fs_sysfs_dev_attr $SCRATCH_DEV "zoned/max_open_zones"; then
 		_notrun "Not supported on zoned file systems"
 	fi
 }
@@ -2160,12 +2160,12 @@ _require_xfs_scratch_zoned()
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
index a0cc9b55..d8b58f49 100755
--- a/tests/btrfs/253
+++ b/tests/btrfs/253
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
index 20fd104b..e03ade1d 100755
--- a/tests/xfs/006
+++ b/tests/xfs/006
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
index 8d23f66d..38b68a7d 100755
--- a/tests/xfs/177
+++ b/tests/xfs/177
@@ -51,7 +51,7 @@ _require_scratch
 _require_fs_sysfs stats/stats
 
 count_xfs_inode_objs() {
-	_get_fs_sysfs_attr $SCRATCH_DEV stats/stats | awk '/vnodes/ {print $2}'
+	_get_fs_sysfs_dev_attr $SCRATCH_DEV stats/stats | awk '/vnodes/ {print $2}'
 }
 
 dump_debug_info() {
diff --git a/tests/xfs/264 b/tests/xfs/264
index a6e816d3..c8a2f714 100755
--- a/tests/xfs/264
+++ b/tests/xfs/264
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

