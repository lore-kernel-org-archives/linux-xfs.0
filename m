Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAC13D8104;
	Wed, 17 Jun 2026 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695267; cv=none; b=lBRVhDq1tYXh9yUbAP/LzVJbNAv7LXIGET9TePv/HG/HrCBgxDuEjkTLFjzbLzSU2xAawFZWoPVN37faXqCPFr26+uX4u/LY7GYHbdAYFO8QeI4bNPfF8Icpy9Ymu9hrMI1svuFg5rDGvaRzjkO4aDGlViNRGOZM8zqWvp84P+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695267; c=relaxed/simple;
	bh=tJZzMF1Z7aWUxj/SMLB6BgcrfQYSTr8XZcal0HPcp8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKgRrUJMM4qC/xIwmrsWF3y+/VROQNbKiUaL2CE/6CxXg4VA7ndFaQoZt0ntjBlYDPQzh+rUpBqSuWsuQ+W2H6M3jiLnfh3jcTav76+JbGd1wUa+RD0cuzblAmbjwiRIXk316xV6zw6OwhTP6e60IG5Hjw2FKLTj8KXEfNUNvfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijL21kDe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijL21kDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F081F00A3D;
	Wed, 17 Jun 2026 11:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695264;
	bh=VFzRoel95Mk0OMd9ieiVtGk8xEu55dadodVvWCnTMiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijL21kDexzzyC6kTgJJNIMk9UZljl26RIlsr5eggHWnjRaOFAdklGIqSwuI27JNht
	 ckwVbxBjO5EG1xDJf14h5z/0bvyy5qP34FvlE+ktbW0Pq8weTJr0MA4r7+xR3gN037
	 7j/ppBJvPIPAbJFldLA88yvyKqlsmlv38mQifanrtjmE+/AgJQS5TwY75xH7bVJQDj
	 FeGS0/cgQc5SqJuI+XU0jpamMSOj8W4Nv5dmJ9dwWxSDcvoYqg+9BLzZlsY0EvzqCp
	 dtyqySQe+UC+r2cDgudo7ICdgHZLoXcIz6j6oLeMk+BJedl83EM233h7dh5DHr+pA6
	 /T8PgUJpO0KdQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 06/11] fstests: verify f_fsid for cloned filesystems
Date: Wed, 17 Jun 2026 19:20:33 +0800
Message-ID: <2ac5fb22fd6b51973d11082a1ee8fe354926c63c.1781694879.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781694879.git.asj@kernel.org>
References: <cover.1781694879.git.asj@kernel.org>
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
 tests/generic/802     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/802.out |  4 +++
 2 files changed, 68 insertions(+)
 create mode 100644 tests/generic/802
 create mode 100644 tests/generic/802.out

diff --git a/tests/generic/802 b/tests/generic/802
new file mode 100644
index 000000000000..910807c11584
--- /dev/null
+++ b/tests/generic/802
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 802
+# Check that the cloned filesystem provides an f_fsid that is persistent
+# across mount cycles if the block device maj:min remains unchanged.
+
+. ./common/preamble
+
+_begin_fstest auto quick mount clone
+
+_require_test
+_require_block_device $TEST_DEV
+_require_loop
+
+_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
+	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
+_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
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
index 000000000000..0202a9a2c108
--- /dev/null
+++ b/tests/generic/802.out
@@ -0,0 +1,4 @@
+QA output created by 802
+**** fsid after mount cycle ****
+FSID_SCRATCH
+FSID_CLONE
-- 
2.43.0

