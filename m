Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A4175A72;
	Tue, 28 Apr 2026 06:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358605; cv=none; b=MVqqzkampC9nMNjzB8i1flsMzHvt5W/1SpTlmhsFZAlJZDkhahsE4t2c8IGW+wgbLTNs+dZPYVf38ucMSx9PKzn8o3fnq1QQFG8WxPTuCXs3oG2FXqI0SrPaH2Zm5+UH37qZtgaom/piyMIaNPErSGOH1b7QLeLMmAF+w3mRTek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358605; c=relaxed/simple;
	bh=k4GyESEu7MP2NHXYX6ENRfo8qnkcpYjGLDdXL79AQF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9b19X4uuWc9I0dvVBa8ZL5/oDB8+vdRRWOhfG4e3DxAs2GO55zfPbaubeJy8c7rh2iYE6eVPLOv/1zH6IIAoB2pS+Vo8bt9VBX3/1PjQRdXbKCOetHBL7PMYcC/qQX9WKWLyJ0YEuNJoYgjfJXAATGEaAs5M4fMOEY45BMefks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbNeyRLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbNeyRLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE68C4AF0E;
	Tue, 28 Apr 2026 06:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358603;
	bh=k4GyESEu7MP2NHXYX6ENRfo8qnkcpYjGLDdXL79AQF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbNeyRLL2O9GoK2WqxffCi0ZMfV2XhGMUmu3cAE2Go/td+frvlrFI52joml6RqDM5
	 iYsoFd7apsPE8fiYawTvCWnkqFt0g60O2hryKLThdepAXgT3zKjo467u9e3nUJIFPo
	 d/jmpMBtRCobfml1s4oIX0+sm5LDdCAk2k0hlWtOVpCLf4OB8jQGdJu/X/sPlBSjSD
	 M3u6kvX/3TiRWtyEksFTMHiE9t0TCg7yhW70p1ZIw8bZfHXR+X1mGgJ0BkrTaXgzjI
	 HnBGnqufnZBSbZ1A5gXKSCIpfc9Mv5gH6B24/Z3WxJw3qVAYunUpmSklawi/FXM9Xi
	 jUq90qMqCFzAA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v4 5/9] fstests: verify f_fsid for cloned filesystems
Date: Tue, 28 Apr 2026 14:42:55 +0800
Message-ID: <90f96625adafa29945c30a35c08ac290a7eaac6a.1777357321.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777357320.git.asj@kernel.org>
References: <cover.1777357320.git.asj@kernel.org>
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

