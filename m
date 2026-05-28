Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35B0302753;
	Thu, 28 May 2026 04:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941185; cv=none; b=iaGY9Fi33nbhWtSk9V0HcJ4V5Q/oQLarYMp95tnYdvBMlTYLBwPjMez+tkAGnj2S5zOxSQBCbdvCAYMQHHtLIUZF20Q76krpP42EqD3JOh6fOrVKyQC98EPBezeFjVIQNWtsTZxoIDMQNy7zlRi9GA76LTo92lUZiFCYzhcKbmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941185; c=relaxed/simple;
	bh=SzcJi6/cCwzOjOc6GGVr/aCHZjyjzsjQpQkke3DN3G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyHVzCTHChqqosLY1/rUj/MPWfG5AtMLTxUd0Vx+ytRBjTxKBTf7vLdl0q5rVZhvTD8FB8qPxCUFFOY/gP4K9juceXY5QQgjf5A6PZWfYIyFe8DuKX0E/Z2SlbJqkGysVl7k8Pevuu4qB6WgJJBNPJAhFlgnErU996rCUSmx0pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTsBRN/3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTsBRN/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A29F1F000E9;
	Thu, 28 May 2026 04:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941184;
	bh=SrWd8RGaKGZqPbrQx3334hcjBVMONqyLjfS/Cvkywb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTsBRN/3l65WRGaeT5AsFSUxC3LUEfxWCpmHybMSAJsvN2QPCr0m3CGr/1e116Tsm
	 RyHXnGMGHda9Ozi0U2e61GBXmBl7xAqGdFpXTu5SBmRRegurqFvCZX6eHdsJd1RYIO
	 8hcJlmHvN60EWOAtSp/NU/UHXxgI1obVbypPc9gSFE5k+sJLN6Uel7cD0ofhrx7a4+
	 /vPZqp7m6CK7DXicVOM2dV/3urbuoofPfhrkm54o9yurUKLnyc5NmX2BVvQa9y4Bfv
	 QD6PR3EEegwtUiO0hRcYVoBDLfBrVfS66z8PQBTXDDiDedxwMe3O7qJBvBN7LLTE+w
	 yVY139B7F5Fqg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 06/11] fstests: verify f_fsid for cloned filesystems
Date: Thu, 28 May 2026 12:05:37 +0800
Message-ID: <e029755044a32de6ec2a0d3391f3ff0089fc3c30.1779939330.git.asj@kernel.org>
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

Verify that the cloned filesystem provides an f_fsid that is persistent
across mount cycles, yet unique from the original filesystem's f_fsid.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/802     | 67 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/802.out |  7 +++++
 2 files changed, 74 insertions(+)
 create mode 100644 tests/generic/802
 create mode 100644 tests/generic/802.out

diff --git a/tests/generic/802 b/tests/generic/802
new file mode 100644
index 000000000000..653e74e11b53
--- /dev/null
+++ b/tests/generic/802
@@ -0,0 +1,67 @@
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
+# Setup base loop device and its clone
+devs=()
+_loop_image_create_clone devs
+mkdir -p $TEST_DIR/$seq
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+# Mount both filesystems simultaneously using mandatory clone mount options
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+# Capture baseline filesystem IDs for comparison
+fsid_scratch=$(stat -f -c "%i" $mnt1)
+fsid_clone=$(stat -f -c "%i" $mnt2)
+
+echo "**** fsid initially ****"
+echo $fsid_scratch | sed -e "s/$fsid_scratch/FSID_SCRATCH/g"
+echo $fsid_clone | sed -e "s/$fsid_clone/FSID_CLONE/g"
+
+# Verify that the fsids remain stable after a mount cycle, even when the
+# mount order is reversed.
+echo "**** fsid after mount cycle ****"
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+# Compare post mount-cycle values against the baseline
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

