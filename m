Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE882FE59C;
	Wed, 17 Jun 2026 11:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695279; cv=none; b=KwUz0xP0OcLxWSvm8KzxYRqudEQdFEt9gUIC1JhhWdV+cmH4iE9YYY/kmunsRemWQxRfRlFw+gEBdDmKxdVr7qKQsXiDhIHe8rutVgALoyb9FXfnsCmgD4UgA2b6DcP846U/LfrSLGX1W4YiEhM9tW3LrH6snlKFUVHF/Yqpamo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695279; c=relaxed/simple;
	bh=tP+rzeiwVmUa4nR6xHtbZjF3mtJAU9ICVrvCdW3HQX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJucNqqhCOq+2CRsT7XBdth2LDx911yKMJglFfI2lCQfl0T1bGL7rRDG2tbMCnZRSvNMBSdpJ7RirqJ1roq66MPfJ/E7dib+c1mlaa7KoL0UhM/vo50VjjvzNYh0Qc2011IGdaaym3ejyUU9G507338kC/YDsnhlIanjdTsFf/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcnZlyNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcnZlyNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866FB1F00A3E;
	Wed, 17 Jun 2026 11:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695276;
	bh=qcH4sN23EYZsX+hkptHPBiYMtvNCnMjEtuTUDDaOdLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IcnZlyNqeJg9cOc8R+KHh1pthzTkpcj4oV+dULG88BsbeA5nf4xvkEP36pzJanbGv
	 2NyGQt3aqbXlIIAYdMI+4W0qV1SpytTX6W/aaKEt5XCnbwLtM9dKxQmC90R6SOT3UQ
	 WCEcJbDfKLIsYAwd0uHgz9rDX0WEQa/FeWw9uU/1iV4EO92hs6lGhn85XbrkpLmwyE
	 dBFPw2x5uww5GRh5IcMQTNq+tOpLrLRGNzgZT/Z4+FhuEns0JFdYxXv7GIigDMh8LO
	 T6zClUoAtdDuPdGl76kzedEf7jKmMrLnfpazQciZYVsNtVnG5PHUlnsvZCMiTXbYO7
	 KO0iX3OL9iMrA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 11/11] fstests: test UUID consistency for clones with metadata_uuid
Date: Wed, 17 Jun 2026 19:20:38 +0800
Message-ID: <01427e737e37032c9cead978a6f79c981f4b92b4.1781694879.git.asj@kernel.org>
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

Btrfs and xfs uses the metadata_uuid superblock feature to change the
on-disk UUID without rewriting every block header. This patch adds a
sanity check to ensure UUID consistency when a filesystem with
metadata_uuid enabled is cloned.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/806     | 74 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/806.out |  6 ++++
 2 files changed, 80 insertions(+)
 create mode 100644 tests/generic/806
 create mode 100644 tests/generic/806.out

diff --git a/tests/generic/806 b/tests/generic/806
new file mode 100644
index 000000000000..6d3166491006
--- /dev/null
+++ b/tests/generic/806
@@ -0,0 +1,74 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 806
+#
+# Verify that the cloned filesystem UUID remains consistent, even when the
+# `metadata_uuid` feature is enabled.
+#
+
+. ./common/preamble
+. ./common/filter
+
+_begin_fstest auto quick mount clone
+
+_require_test
+_require_block_device $TEST_DEV
+_require_loop
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	umount $mnt1 $mnt2 2>/dev/null
+	_loop_image_destroy "${devs[@]}" 2> /dev/null
+}
+
+filter_pool()
+{
+	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
+	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
+}
+
+# Create base loop device and its clone, applying the metadata_uuid tuning
+# callback to the base filesystem before the copy occurs.
+devs=()
+_loop_image_create_clone devs _change_metadata_uuid
+mkdir -p $TEST_DIR/$seq
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+# Get the uuid from the source device
+fsuuid=$(blkid -s UUID -o value ${devs[0]})
+
+# Mount both clone and baseline
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+
+# Cycle mounts and reverse the initialization order to ensure UUID tracking
+# doesn't mismatch or flip when metadata_uuid optimization is active.
+echo "**** mount cycle ****"
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+
+status=0
+exit
diff --git a/tests/generic/806.out b/tests/generic/806.out
new file mode 100644
index 000000000000..918f422ecddf
--- /dev/null
+++ b/tests/generic/806.out
@@ -0,0 +1,6 @@
+QA output created by 806
+DEV1 MNT1 FSUUID
+DEV2 MNT2 FSUUID
+**** mount cycle ****
+DEV1 MNT1 FSUUID
+DEV2 MNT2 FSUUID
-- 
2.43.0

