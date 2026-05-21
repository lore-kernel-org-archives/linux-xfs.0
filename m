Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087B93D9036;
	Thu, 21 May 2026 13:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368431; cv=none; b=o5+4PtHixzVZPJNNTSmtyjoT+LTEeEhkqiTr6xilaaYkrwiz6MLZSV5ldt/AgP6+2pRdkko38+BlW3wbw7AUKvzCx7fNBDNciV/L/EQhUwS6K/KqH9SpimGOXCAQJjqaalqR23Qwnsv7LBPZ//2cVhlVFW94lXhwAfzEa42kLjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368431; c=relaxed/simple;
	bh=k4GyESEu7MP2NHXYX6ENRfo8qnkcpYjGLDdXL79AQF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOSCPR8ad6eu9DCOATBcAQZ92xRBvJvOwPUicA0N6MGtpuGN9chYSptFj/l7IAPeXT9K9l0wHRUJ20X+3xgPh4zXH5FE6BpHsL7KKUBmME2KSl9+M4M/r7fNiyj0yoHBPcXnCSysi/yEfgvKs0lfOIHrOJ5D2AuEdsQWpN6MtfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2yAqN3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2yAqN3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1707F1F00A3B;
	Thu, 21 May 2026 13:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368429;
	bh=PxdU5PmUAGtDPc2wjha/eSzkOvbJceSH1HNXrNDiSws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2yAqN3TF4ioh7daxWvHhR2zHtjxu2Rz34aAbSFF8km/AeJg1muu64DeVVip9EYD8
	 cT4lydRvxf57IywLRHSWA30fD0p24rNOSY94kPzBZLT7Fa0QPVhrB+QFwZ4SgtMqd6
	 +yUb6DkonTK9uL0xnmQiR8WIxNSBxZBcq7Pw3fofPoM6W+PIROxbDzFex5s9SHD5b8
	 acCbEVLLIee203hAC3vnU2K9dsANyu2v/38vbYndlmJIK5DkAbij0DC1NhjT4J4w8Y
	 Q6G/3bvDL5LurY8ALqIrG0vwHpxgERdqTKugzoN4kRBLVOPE9uTE+wua0fSdwHRPto
	 t5BWwO0Ho7dJw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v5 05/10] fstests: verify f_fsid for cloned filesystems
Date: Thu, 21 May 2026 20:54:55 +0800
Message-ID: <a24645463979d0550e0010030995b0ed609215c1.1779367627.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779367627.git.asj@kernel.org>
References: <cover.1779367627.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify that the cloned filesystem provides an f_fsid that is persistent
across mount cycles, yet unique from the original filesystem's f_fsid.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/802     | 62 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/802.out |  7 +++++
 2 files changed, 69 insertions(+)
 create mode 100644 tests/generic/802
 create mode 100644 tests/generic/802.out

diff --git a/tests/generic/802 b/tests/generic/802
new file mode 100644
index 000000000000..31044695f3a8
--- /dev/null
+++ b/tests/generic/802
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 802
+# Verify f_fsid and s_uuid of cloned filesystems across mount cycle.
+
+. ./common/preamble
+
+_begin_fstest auto quick mount clone
+
+_require_test
+_require_block_device $TEST_DEV
+_require_loop
+
+[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
+[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	umount $mnt1 $mnt2 2>/dev/null
+	_loop_image_destroy "${devs[@]}" 2> /dev/null
+}
+
+devs=()
+_loop_image_create_clone devs
+mkdir -p $TEST_DIR/$seq
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+fsid_scratch=$(stat -f -c "%i" $mnt1)
+fsid_clone=$(stat -f -c "%i" $mnt2)
+
+echo "**** fsid initially ****"
+echo $fsid_scratch | sed -e "s/$fsid_scratch/FSID_SCRATCH/g"
+echo $fsid_clone | sed -e "s/$fsid_clone/FSID_CLONE/g"
+
+# Make sure fsid still match across a mount cycle, also reverse the order.
+echo "**** fsid after mount cycle ****"
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+stat -f -c "%i" $mnt1 | sed -e "s/$fsid_scratch/FSID_SCRATCH/g"
+stat -f -c "%i" $mnt2 | sed -e "s/$fsid_clone/FSID_CLONE/g"
+
+status=0
+exit
diff --git a/tests/generic/802.out b/tests/generic/802.out
new file mode 100644
index 000000000000..d1e008f122bb
--- /dev/null
+++ b/tests/generic/802.out
@@ -0,0 +1,7 @@
+QA output created by 802
+**** fsid initially ****
+FSID_SCRATCH
+FSID_CLONE
+**** fsid after mount cycle ****
+FSID_SCRATCH
+FSID_CLONE
-- 
2.43.0

