Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D290F495CB;
	Thu, 18 Apr 2024 07:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713426062; cv=none; b=Lh5pA6rKn9leRoepK5UZ0Fdt7SLYnitCTBzw4zZ3Bz+fhgjXx05Y7K4tXU6uGD1GPYDVHprxymHsnDgA+Ou80S/SgVXAV6/137L5jnmzlbTKk2m4b8p3kGdbpBDk+hbSUMWF2TBzCeB5UYdOfkxdKKb4zyWQaB/ZCF9+t1/9C/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713426062; c=relaxed/simple;
	bh=LC0Fmo8wvXyc+XEhE2TEbh47qbLawvD6wauZuqU37+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jmClcULgaUdtORJIhrMpNZL/L9MalBRHYmyTVM75xvAE0/kSH+CjLCV7UNH+Pk0hveTopP3L9ore9JgIAtZc9FO2s53Qp5EPTo5NWM0/fNb2kFaaf3TX135v/AbKuYibQxWjR0hrcZkQHJo1rQUGn112FsFm7Fy+W7udb9x2u9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vpwshcbP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vpwshcbP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mVEwGXmBiSH1a7UVx+gUl87Ba45/hjK8qPtyLPBaaMw=; b=vpwshcbPUqCBIdeqkBqg0ZcA/L
	YfGJFI5itA53T2gsnGAG5qamWx89IMWTvEWkXYEONgcdUptZhDbNhcpq9VTkzhIDSyU9NiZ3Tja/j
	CuPlfws03K1ipZHgY5rNMGVHkxI1uzs5GRadmntdloZ2oQvXnHrZqg0iL/feRxfdvy6VVD0qRDhYF
	UoGONgxwOEMR2ZdWZUTF9i6zTGigkoHfVWb80sZj77iQSPVBLH/onjtNC4XLH3dxZ8PBhKOuyZTKv
	OcaLWgZ0mI+uQyWmlh+QaJPhiJfR9+IdgX1OYmMKXGOkTFtBn4bsAm3/U+BxmoMEGpvm/lybOG1r+
	/ReXgS5w==;
Received: from 3.95.143.157.bbcs.as8758.net ([157.143.95.3] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxMOB-00000001Ik1-3o92;
	Thu, 18 Apr 2024 07:41:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 3/5] xfs/512: split out v4 specific tests
Date: Thu, 18 Apr 2024 09:40:44 +0200
Message-Id: <20240418074046.2326450-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240418074046.2326450-1-hch@lst.de>
References: <20240418074046.2326450-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split the v4-specific tests into a new xfs/613.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/513     |  13 ---
 tests/xfs/513.out |   9 ---
 tests/xfs/613     | 198 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/613.out |  15 ++++
 4 files changed, 213 insertions(+), 22 deletions(-)
 create mode 100755 tests/xfs/613
 create mode 100644 tests/xfs/613.out

diff --git a/tests/xfs/513 b/tests/xfs/513
index ce2bb3491..3a85ed429 100755
--- a/tests/xfs/513
+++ b/tests/xfs/513
@@ -193,10 +193,6 @@ do_mkfs -m crc=1
 do_test "" pass "attr2" "true"
 do_test "-o attr2" pass "attr2" "true"
 do_test "-o noattr2" fail
-do_mkfs -m crc=0
-do_test "" pass "attr2" "true"
-do_test "-o attr2" pass "attr2" "true"
-do_test "-o noattr2" pass "attr2" "false"
 
 # Test discard
 do_mkfs
@@ -255,15 +251,6 @@ do_test "-o logbsize=128k" pass "logbsize=128k" "true"
 do_test "-o logbsize=256k" pass "logbsize=256k" "true"
 do_test "-o logbsize=8k" fail
 do_test "-o logbsize=512k" fail
-do_mkfs -m crc=0 -l version=1
-# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
-# prints "logbsize=N" in /proc/mounts, but old kernel not. So the default
-# 'display' about logbsize can't be expected, disable this test.
-#do_test "" pass "logbsize" "false"
-do_test "-o logbsize=16384" pass "logbsize=16k" "true"
-do_test "-o logbsize=16k" pass "logbsize=16k" "true"
-do_test "-o logbsize=32k" pass "logbsize=32k" "true"
-do_test "-o logbsize=64k" fail
 
 # Test logdev
 do_mkfs
diff --git a/tests/xfs/513.out b/tests/xfs/513.out
index eec8155d7..399459071 100644
--- a/tests/xfs/513.out
+++ b/tests/xfs/513.out
@@ -13,10 +13,6 @@ FORMAT: -m crc=1
 TEST: "" "pass" "attr2" "true"
 TEST: "-o attr2" "pass" "attr2" "true"
 TEST: "-o noattr2" "fail"
-FORMAT: -m crc=0
-TEST: "" "pass" "attr2" "true"
-TEST: "-o attr2" "pass" "attr2" "true"
-TEST: "-o noattr2" "pass" "attr2" "false"
 FORMAT: 
 TEST: "" "pass" "discard" "false"
 TEST: "-o discard" "pass" "discard" "true"
@@ -51,11 +47,6 @@ TEST: "-o logbsize=128k" "pass" "logbsize=128k" "true"
 TEST: "-o logbsize=256k" "pass" "logbsize=256k" "true"
 TEST: "-o logbsize=8k" "fail"
 TEST: "-o logbsize=512k" "fail"
-FORMAT: -m crc=0 -l version=1
-TEST: "-o logbsize=16384" "pass" "logbsize=16k" "true"
-TEST: "-o logbsize=16k" "pass" "logbsize=16k" "true"
-TEST: "-o logbsize=32k" "pass" "logbsize=32k" "true"
-TEST: "-o logbsize=64k" "fail"
 FORMAT: 
 TEST: "" "pass" "logdev" "false"
 TEST: "-o logdev=LOOP_SPARE_DEV" "fail"
diff --git a/tests/xfs/613 b/tests/xfs/613
new file mode 100755
index 000000000..522358cb3
--- /dev/null
+++ b/tests/xfs/613
@@ -0,0 +1,198 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
+#
+# FS QA Test No. 613
+#
+# XFS v4 mount options sanity check, refer to 'man 5 xfs'.
+#
+. ./common/preamble
+_begin_fstest auto mount prealloc
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	$UMOUNT_PROG $LOOP_MNT 2>/dev/null
+	if [ -n "$LOOP_DEV" ];then
+		_destroy_loop_device $LOOP_DEV 2>/dev/null
+	fi
+	if [ -n "$LOOP_SPARE_DEV" ];then
+		_destroy_loop_device $LOOP_SPARE_DEV 2>/dev/null
+	fi
+	rm -f $LOOP_IMG
+	rm -f $LOOP_SPARE_IMG
+	rmdir $LOOP_MNT
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_fixed_by_kernel_commit 237d7887ae72 \
+	"xfs: show the proper user quota options"
+
+_require_test
+_require_loop
+_require_xfs_io_command "falloc"
+
+LOOP_IMG=$TEST_DIR/$seq.dev
+LOOP_SPARE_IMG=$TEST_DIR/$seq.logdev
+LOOP_MNT=$TEST_DIR/$seq.mnt
+
+echo "** create loop device"
+$XFS_IO_PROG -f -c "truncate 32g" $LOOP_IMG
+LOOP_DEV=`_create_loop_device $LOOP_IMG`
+
+echo "** create loop log device"
+$XFS_IO_PROG -f -c "truncate 1g" $LOOP_SPARE_IMG
+LOOP_SPARE_DEV=`_create_loop_device $LOOP_SPARE_IMG`
+
+echo "** create loop mount point"
+rmdir $LOOP_MNT 2>/dev/null
+mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
+
+filter_loop()
+{
+	sed -e "s,\B$LOOP_MNT,LOOP_MNT,g" \
+	    -e "s,\B$LOOP_DEV,LOOP_DEV,g" \
+	    -e "s,\B$LOOP_SPARE_DEV,LOOP_SPARE_DEV,g"
+}
+
+filter_xfs_opt()
+{
+	sed -e "s,allocsize=$pagesz,allocsize=PAGESIZE,g"
+}
+
+# avoid the effection from MKFS_OPTIONS
+MKFS_OPTIONS=""
+do_mkfs()
+{
+	echo "FORMAT: $@" | filter_loop | tee -a $seqres.full
+	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >>$seqres.full 2>$tmp.mkfs
+	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
+		_fail "Fails on _mkfs_dev $* $LOOP_DEV"
+	fi
+	. $tmp.mkfs
+}
+
+is_dev_mounted()
+{
+	findmnt --source $LOOP_DEV >/dev/null
+	return $?
+}
+
+get_mount_info()
+{
+	findmnt --source $LOOP_DEV -o OPTIONS -n
+}
+
+force_unmount()
+{
+	$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
+}
+
+# _do_test <mount options> <should be mounted?> [<key string> <key should be found?>]
+_do_test()
+{
+	local opts="$1"
+	local mounted="$2"	# pass or fail
+	local key="$3"
+	local found="$4"	# true or false
+	local rc
+	local info
+
+	# mount test
+	_mount $LOOP_DEV $LOOP_MNT $opts 2>>$seqres.full
+	rc=$?
+	if [ $rc -eq 0 ];then
+		if [ "${mounted}" = "fail" ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: expect mount to fail, but it succeeded"
+			return 1
+		fi
+		is_dev_mounted
+		if [ $? -ne 0 ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: fs not mounted even mount return 0"
+			return 1
+		fi
+	else
+		if [ "${mounted}" = "pass" ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: expect mount to succeed, but it failed"
+			return 1
+		fi
+		is_dev_mounted
+		if [ $? -eq 0 ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: fs is mounted even mount return non-zero"
+			return 1
+		fi
+	fi
+
+	# Skip below checking if "$key" argument isn't specified
+	if [ -z "$key" ];then
+		return 0
+	fi
+	# Check the mount options after fs mounted.
+	info=`get_mount_info`
+	echo ${info} | grep -q "${key}"
+	rc=$?
+	if [ $rc -eq 0 ];then
+		if [ "$found" != "true" ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: expected to find \"$key\" in mount info \"$info\""
+			return 1
+		fi
+	else
+		if [ "$found" != "false" ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: did not expect to find \"$key\" in \"$info\""
+			return 1
+		fi
+	fi
+
+	return 0
+}
+
+do_test()
+{
+	# Print each argument, include nil ones
+	echo -n "TEST:" | tee -a $seqres.full
+	for i in "$@";do
+		echo -n " \"$i\"" | filter_loop | filter_xfs_opt | tee -a $seqres.full
+	done
+	echo | tee -a $seqres.full
+
+	# force unmount before testing
+	force_unmount
+	_do_test "$@"
+	# force unmount after testing
+	force_unmount
+}
+
+echo "** start xfs mount testing ..."
+# Test attr2
+do_mkfs -m crc=0
+do_test "" pass "attr2" "true"
+do_test "-o attr2" pass "attr2" "true"
+do_test "-o noattr2" pass "attr2" "false"
+
+# Test logbsize=value.
+do_mkfs -m crc=0 -l version=1
+# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
+# prints "logbsize=N" in /proc/mounts, but old kernel not. So the default
+# 'display' about logbsize can't be expected, disable this test.
+#do_test "" pass "logbsize" "false"
+do_test "-o logbsize=16384" pass "logbsize=16k" "true"
+do_test "-o logbsize=16k" pass "logbsize=16k" "true"
+do_test "-o logbsize=32k" pass "logbsize=32k" "true"
+do_test "-o logbsize=64k" fail
+
+echo "** end of testing"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/613.out b/tests/xfs/613.out
new file mode 100644
index 000000000..1624617ee
--- /dev/null
+++ b/tests/xfs/613.out
@@ -0,0 +1,15 @@
+QA output created by 613
+** create loop device
+** create loop log device
+** create loop mount point
+** start xfs mount testing ...
+FORMAT: -m crc=0
+TEST: "" "pass" "attr2" "true"
+TEST: "-o attr2" "pass" "attr2" "true"
+TEST: "-o noattr2" "pass" "attr2" "false"
+FORMAT: -m crc=0 -l version=1
+TEST: "-o logbsize=16384" "pass" "logbsize=16k" "true"
+TEST: "-o logbsize=16k" "pass" "logbsize=16k" "true"
+TEST: "-o logbsize=32k" "pass" "logbsize=32k" "true"
+TEST: "-o logbsize=64k" "fail"
+** end of testing
-- 
2.39.2

