Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7A8313E2B;
	Thu, 28 May 2026 04:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941192; cv=none; b=jE8chQJrPN4rbOtVuELqV5/93n4Hemi2MbjcM/DOmeGYFBfZjgyZIWVzPz35lsoElktYJeq2HZODCcZuOo4aPs67lAd9Hsj/JPTq0ynKcvBgETNF735FwbfGsXfd3k7puJDHX/VJUQ5ocKbR3OKXrqX3A+JaDFkbhU8CzsPmHn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941192; c=relaxed/simple;
	bh=dwf1Frz49BcW8zHTGUJ7/c5ax//HXgsZhx/8B4vFU80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ut4tM+7uiq3LwV1ZKV0IqI6b1NB0OBwfqYSHhLVlxIpGOjPq+GqkBRV7YwI2zgtRLs+rFtrCE65N1axap3Pui+CT/5HumxBOISyQC/Kja4QC+qEtJAJbEDpAHfTkRfd/GATyXv41wOBPWG4Tfr4syPPOBTKVpZ7/Vil1DmIKrTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLjlDQz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLjlDQz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE521F00A3A;
	Thu, 28 May 2026 04:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941191;
	bh=cA76/PYw1pPj8n2hc9fHEPPWqFsIP0EVym6yQnBFCxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLjlDQz+bwVuH+CLTRgxwCKHxBT6/CSFYZy5OGndfsskO37Nsv468yumlcUrD8ahQ
	 JEkii97cPaPADyAY6OCOXP/SUNJYqWd9c8rlwHwxlRLbGwItizEw+nODpw4zYV7ctn
	 RSD4m/k5gy5el5lTSWbFKgd4Cl5ABdpaw6VGtzyM5l1N2L7reBv4R7/MdrmI6yyRbK
	 8dthUojsqc1ueAFjThviKUdCRtEKynycQbUiJBBzAcTWD4pfcAJM/6i1Y97s0nvkjd
	 n2/DwxZLcqX65h39sBadH/ebny2QFN7y/kSuVmJryQ7I2C4xRc7zYod60hSrSDWcAV
	 6HoR2T3wP6rRg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 09/11] fstests: verify exportfs file handles on cloned filesystems
Date: Thu, 28 May 2026 12:05:40 +0800
Message-ID: <3d74747ec4149c9166ee9db301b8e4533f822085.1779939330.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779939330.git.asj@kernel.org>
References: <cover.1779939330.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure that exportfs can correctly decode file handles on a cloned
filesystem across a mount cycle, by file handles generated on a
cloned device remain valid after mount cycle.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/805     | 80 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/805.out |  2 ++
 2 files changed, 82 insertions(+)
 create mode 100644 tests/generic/805
 create mode 100644 tests/generic/805.out

diff --git a/tests/generic/805 b/tests/generic/805
new file mode 100644
index 000000000000..5827eee039df
--- /dev/null
+++ b/tests/generic/805
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 805
+# Verify that file handles encoded on a cloned filesystem remain valid and
+# resolvable via open_by_handle across a mount cycle and mount order swap.
+
+. ./common/preamble
+
+_begin_fstest auto quick exportfs clone
+
+_require_test
+_require_block_device $TEST_DEV
+_require_exportfs
+_require_loop
+_require_test_program "open_by_handle"
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	_unmount $mnt1 2>/dev/null
+	_unmount $mnt2 2>/dev/null
+	_loop_image_destroy "${devs[@]}" 2> /dev/null
+}
+
+# Create test dir and test files, encode file handles and store to tmp file
+create_test_files()
+{
+	rm -rf $testdir
+	mkdir -p $testdir
+	$here/src/open_by_handle -cwp -o $tmp.handles_file $testdir $NUMFILES
+}
+
+# Attempt to read and decode the saved file handles on the targeted mount point.
+test_file_handles()
+{
+	local opt=$1
+	local when=$2
+
+	echo test_file_handles after $when
+	$here/src/open_by_handle $opt -i $tmp.handles_file $mnt2 $NUMFILES
+}
+
+# Setup base loop device and its clone
+devs=()
+_loop_image_create_clone devs
+mkdir -p $TEST_DIR/$seq
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+# Mount both identical UUID filesystems simultaneously
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+NUMFILES=1
+testdir=$mnt2/testdir
+
+# Decode file handles of files/dir after cycle mount
+create_test_files
+
+# Cycle mounts and reverse initialization sequence to check if
+# file handle lookups are okay
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+# Verify file handles can still be resolved post-mount-cycle
+test_file_handles -rp "cycle mount"
+
+status=0
+exit
diff --git a/tests/generic/805.out b/tests/generic/805.out
new file mode 100644
index 000000000000..29b11ec77ffb
--- /dev/null
+++ b/tests/generic/805.out
@@ -0,0 +1,2 @@
+QA output created by 805
+test_file_handles after cycle mount
-- 
2.43.0

