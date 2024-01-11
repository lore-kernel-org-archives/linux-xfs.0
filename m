Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B5E14F7F;
	Thu, 11 Jan 2024 11:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9YOsJ+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB5DC433C7;
	Thu, 11 Jan 2024 11:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704974382;
	bh=oPNdBs2bxoGUIWEmTtDwyWwT8+RMIkbaIskT+rO7CWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9YOsJ+PdidxrMG7xq/mBEWGba84meN2M4XdPMDKyG2PNzpA3Q2LEGG8zmoHVHsbD
	 AmJWmFF72LZDjzKqmnTXUUGCRyhwZNLfkN6/NV4Vadzt8oEIx1+xG2l9oznYJjm8KC
	 ASXIBtkki/9qGAKBz2T9HmjfS5eHQaqHK0MLTSjSme167ug2MgjRhf8/HM6nHApjpN
	 t2/QOvwMjQEF74PeQQun10eJb4iS2/kGwd68DYqf0wAvFn6xxuHJrRB4CQl3Z8eP9/
	 on6nJAHpvp0xJaKRb/TxlAj4bOv0dkVl7jbq7sCgqXAfUsnqWHQT+rSc6DUI/R8N7H
	 77rBb4K0rXtsw==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH V3 5/5] xfs: Check correctness of metadump/mdrestore's ability to work with dirty log
Date: Thu, 11 Jan 2024 17:28:29 +0530
Message-ID: <20240111115913.1638668-6-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240111115913.1638668-1-chandanbabu@kernel.org>
References: <20240111115913.1638668-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new test to verify if metadump/mdrestore are able to dump and restore
the contents of a dirty log.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 tests/xfs/801     | 178 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/801.out |  14 ++++
 2 files changed, 192 insertions(+)
 create mode 100755 tests/xfs/801
 create mode 100644 tests/xfs/801.out

diff --git a/tests/xfs/801 b/tests/xfs/801
new file mode 100755
index 00000000..56acc5ed
--- /dev/null
+++ b/tests/xfs/801
@@ -0,0 +1,178 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test 801
+#
+# Test metadump/mdrestore's ability to dump a dirty log and restore it
+# correctly.
+#
+. ./common/preamble
+_begin_fstest auto quick metadump log logprint punch
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	_scratch_unmount > /dev/null 2>&1
+	[[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
+		_destroy_loop_device $logdev
+	[[ -n $datadev ]] && _destroy_loop_device $datadev
+	rm -r -f $metadump_file $TEST_DIR/data-image \
+	   $TEST_DIR/log-image
+}
+
+# Import common functions.
+. ./common/dmflakey
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_test
+_require_loop
+_require_xfs_debug
+_require_xfs_io_error_injection log_item_pin
+_require_dm_target flakey
+_require_xfs_io_command "pwrite"
+_require_test_program "punch-alternating"
+
+metadump_file=${TEST_DIR}/${seq}.md
+testfile=${SCRATCH_MNT}/testfile
+
+echo "Format filesystem on scratch device"
+_scratch_mkfs >> $seqres.full 2>&1
+
+max_md_version=1
+_scratch_metadump_v2_supported && max_md_version=2
+
+external_log=0
+if [[ $USE_EXTERNAL = yes && -n "$SCRATCH_LOGDEV" ]]; then
+	external_log=1
+fi
+
+if [[ $max_md_version == 1 && $external_log == 1 ]]; then
+	_notrun "metadump v1 does not support external log device"
+fi
+
+verify_metadump_v1()
+{
+	local version=""
+	if [[ $max_md_version == 2 ]]; then
+		version="-v 1"
+	fi
+
+	_scratch_xfs_metadump $metadump_file -a -o $version
+
+	SCRATCH_DEV=$TEST_DIR/data-image _scratch_xfs_mdrestore $metadump_file
+
+	datadev=$(_create_loop_device $TEST_DIR/data-image)
+
+	SCRATCH_DEV=$datadev _scratch_mount
+	SCRATCH_DEV=$datadev _check_scratch_fs
+	SCRATCH_DEV=$datadev _scratch_unmount
+
+	_destroy_loop_device $datadev
+	datadev=""
+	rm -f $TEST_DIR/data-image
+}
+
+verify_metadump_v2()
+{
+	local version="-v 2"
+
+	_scratch_xfs_metadump $metadump_file -a -o $version
+
+	# Metadump v2 files can contain contents dumped from an external log
+	# device. Use a temporary file to hold the log device contents restored
+	# from such a metadump file.
+	slogdev=""
+	if [[ -n $SCRATCH_LOGDEV ]]; then
+		slogdev=$TEST_DIR/log-image
+	fi
+
+	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
+		   _scratch_xfs_mdrestore $metadump_file
+
+	datadev=$(_create_loop_device $TEST_DIR/data-image)
+
+	logdev=""
+	if [[ -s $slogdev ]]; then
+		logdev=$(_create_loop_device $slogdev)
+	fi
+
+	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
+	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _check_scratch_fs
+	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
+
+	if [[ -s $logdev ]]; then
+		_destroy_loop_device $logdev
+		logdev=""
+		rm -f $slogdev
+	fi
+
+	_destroy_loop_device $datadev
+	datadev=""
+	rm -f $TEST_DIR/data-image
+}
+
+echo "Initialize and mount filesystem on flakey device"
+_init_flakey
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+echo "Create test file"
+$XFS_IO_PROG -s -f -c "pwrite 0 5M" $testfile >> $seqres.full
+
+echo "Punch alternative blocks of test file"
+$here/src/punch-alternating $testfile
+
+echo "Mount cycle the filesystem on flakey device"
+_unmount_flakey
+_mount_flakey
+
+device=$(readlink -f $FLAKEY_DEV)
+device=$(_short_dev $device)
+
+echo "Pin log items in the AIL"
+echo 1 > /sys/fs/xfs/${device}/errortag/log_item_pin
+
+echo "Create two checkpoint transactions on ondisk log"
+for ct in $(seq 1 2); do
+	offset=$($XFS_IO_PROG -c 'fiemap' $testfile | tac |  grep -v hole | \
+			 head -n 1 | awk -F '[\\[.]' '{ print $2 * 512; }')
+	$XFS_IO_PROG -c "truncate $offset" -c fsync $testfile
+done
+
+echo "Drop writes to filesystem from here onwards"
+_load_flakey_table $FLAKEY_DROP_WRITES
+
+echo "Unpin log items in AIL"
+echo 0 > /sys/fs/xfs/${device}/errortag/log_item_pin
+
+echo "Unmount filesystem on flakey device"
+_unmount_flakey
+
+echo "Clean up flakey device"
+_cleanup_flakey
+
+echo -n "Filesystem has a "
+_print_logstate
+
+echo "Create metadump file, restore it and check restored fs"
+
+if [[ $external_log == 0 ]]; then
+	verify_metadump_v1 $max_md_version
+fi
+
+if [[ $max_md_version == 2 ]]; then
+	verify_metadump_v2
+fi
+
+# Mount the fs to replay the contents from the dirty log.
+_scratch_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/801.out b/tests/xfs/801.out
new file mode 100644
index 00000000..a2f2abca
--- /dev/null
+++ b/tests/xfs/801.out
@@ -0,0 +1,14 @@
+QA output created by 801
+Format filesystem on scratch device
+Initialize and mount filesystem on flakey device
+Create test file
+Punch alternative blocks of test file
+Mount cycle the filesystem on flakey device
+Pin log items in the AIL
+Create two checkpoint transactions on ondisk log
+Drop writes to filesystem from here onwards
+Unpin log items in AIL
+Unmount filesystem on flakey device
+Clean up flakey device
+Filesystem has a dirty log
+Create metadump file, restore it and check restored fs
-- 
2.43.0

