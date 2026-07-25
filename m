Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3764A2931C4;
	Sat, 25 Jul 2026 07:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965223; cv=none; b=HUcTyni/SZSqLAs3KGIRwyqfvbuoLMk1+7eePo+9w5MW2+aqFaTu6A255pp9TR+y0V/Sh5w4nVhDXPfJATl1Tnj5MWkntJ4oKbHwDJPSmLVDlJmywKvV2Vn+NYeyQpgNrqYSgQFMEx2P/NTqeM99FDOdvBfn3KqklRImjiJ3Qds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965223; c=relaxed/simple;
	bh=tP+rzeiwVmUa4nR6xHtbZjF3mtJAU9ICVrvCdW3HQX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyi5Gz6sqxUNGcbTPbywBwZM08RK6xPu+MLRA1Z/WccrODrWsYjpuVnlt71KQP4POnjWOssqR929EX/yPGt7wXzU6p6O264rlXPrBBIp990sAkN9kkhLkdwBaE3QwinU/4ul6esm4QkNCLP9b1Sqat/DgHgKPh6AfhvEH+ToNMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=almUkf+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="almUkf+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C36B1F000E9;
	Sat, 25 Jul 2026 07:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965221;
	bh=qcH4sN23EYZsX+hkptHPBiYMtvNCnMjEtuTUDDaOdLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=almUkf+iQVK3XYMIc2kTxamUlbqr+NsfVj7RhpotbB4faZozskIyQO3/IHe+HLVaQ
	 LwYC4/tYSnPEQWp2K8PsMn764/lPZJc1j7/64nAaGV5bW6bBVf/KWEuPkhcnThHTh9
	 G84vI4HOC/d/OcdYC0TjjWDaF0y59pwYDqZduYG0Z2rUzGDj7k/KYAphQWAQQu/07/
	 VA7vf5qx6C9wGYvZjAirlGcuI9iIaDPmIO9u8O24VvzgTM7EN2HfFyKrVjbwzsaBIz
	 F6rJjzwzhMGBjVZiPSCxyF9vJbOXoMOKoIQPHWpxdrk/WipoevFZmZyYTrvehsZ0nE
	 sy06HekvfB6eQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 13/13] fstests: test UUID consistency for clones with metadata_uuid
Date: Sat, 25 Jul 2026 15:39:10 +0800
Message-ID: <905a961a3bb2ec345285f056053e3016ad3bef6e.1784949155.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784949154.git.asj@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
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

