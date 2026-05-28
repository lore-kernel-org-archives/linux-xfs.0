Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032012FE566;
	Thu, 28 May 2026 04:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941197; cv=none; b=dcrGSRwNF08xOcPtcdCGYmVGnC0VUQnMaoUuOOMwJAkv6oC7TYRLQScOOmRW2vJZ6xd+qmebqd8PBpz+lji2gNUlUuLVPv5dt7uzSfA9Xb8f33EXZzdvTZXkQPFtnnUF5hkxgKUDZB76FDNKiHn3C0HP9qonuLplQEKnGqGKKZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941197; c=relaxed/simple;
	bh=T3y5Ubl6Z8Tp6IEXPJe2DFjhXXWg7Gvm+jZyW2VSeYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoUlTEIu/cJHkFLN5FExrzMBKcSc5j7qas3qzpduP7WmFC7wKzNMzvm7akWwhwsTKY9bBLBw7WcHdA53HjW+GPgQkcd0Pvw/emBUV0aBPyBX5aarbrqwjEJR7ifS1ZXPAcw4I2zvLHe9X0bxXFVRvTabf9bfL7T+Ay0HyUfREzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gzYvDBOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gzYvDBOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053371F00A3A;
	Thu, 28 May 2026 04:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941195;
	bh=kB/sRmK5BV5dTZE/cUtAhVaEQ2ruW0M5KZKPeAAY27g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzYvDBOUQ0T1gYNMYXkfyeC42OZ03c2+jbrlcPl/EVsAlgzaLEXR+YLDkXdx0ssqn
	 XIyV6I+g0V2VirbeQNOWCNX285oA7CKMkGKJ0gJJeWsw2uDD01clR0yreyBgKZ3luw
	 9aZY5cGUogShv9kifCaskMwKnim3dixTleMzTz2HDyaixSWW8TcIQdxyYFWnxrABeP
	 LIN1fqNjmGCEntrogjJjNa5FUp77JV4lj5kiGUzHdmDXrrceIS9yMnRRiMSQTmMn2s
	 Jcyk8Mfev6g4AdOBdndTb+354j0wHSJsNN8O0Md69vYYXEV4MYXr1k4fkDQM2Ejlic
	 1IkAIFjCadmoQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 11/11] fstests: test UUID consistency for clones with metadata_uuid
Date: Thu, 28 May 2026 12:05:42 +0800
Message-ID: <7937f3961e03df55fb358a114dc67cfca3fa5f33.1779939330.git.asj@kernel.org>
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

Btrfs and xfs uses the metadata_uuid superblock feature to change the
on-disk UUID without rewriting every block header. This patch adds a
sanity check to ensure UUID consistency when a filesystem with
metadata_uuid enabled is cloned.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/806     | 84 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/806.out | 19 ++++++++++
 2 files changed, 103 insertions(+)
 create mode 100644 tests/generic/806
 create mode 100644 tests/generic/806.out

diff --git a/tests/generic/806 b/tests/generic/806
new file mode 100644
index 000000000000..801671fb9ce9
--- /dev/null
+++ b/tests/generic/806
@@ -0,0 +1,84 @@
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
+# Collect and print device resolution properties across user-space tools
+print_info()
+{
+	local mntpt=$1
+	local tgt=$(findmnt -no SOURCE $mntpt)
+	local fsuuid=$(blkid -s UUID -o value $tgt)
+
+	echo "mntpt=$mntpt tgt=$tgt fsuuid=$fsuuid" >> $seqres.full
+	echo
+	findmnt -o SOURCE,TARGET,UUID "$tgt" | tail -n +2 | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+	awk -v dev="$tgt" '$1 == dev { print $1, $2 }' /proc/self/mounts | \
+								filter_pool
+	df --all --output=source,target "$tgt" | tail -n +2 | filter_pool
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
+# Mount both clone and baseline
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+print_info $mnt1
+print_info $mnt2
+
+# Cycle mounts and reverse the initialization order to ensure UUID tracking
+# doesn't mismatch or flip when metadata_uuid optimization is active.
+echo
+echo "**** mount cycle ****"
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+print_info $mnt1
+print_info $mnt2
+
+status=0
+exit
diff --git a/tests/generic/806.out b/tests/generic/806.out
new file mode 100644
index 000000000000..7315e791ba51
--- /dev/null
+++ b/tests/generic/806.out
@@ -0,0 +1,19 @@
+QA output created by 806
+
+DEV1 MNT1 FSUUID
+DEV1 MNT1
+DEV1 MNT1
+
+DEV2 MNT2 FSUUID
+DEV2 MNT2
+DEV2 MNT2
+
+**** mount cycle ****
+
+DEV1 MNT1 FSUUID
+DEV1 MNT1
+DEV1 MNT1
+
+DEV2 MNT2 FSUUID
+DEV2 MNT2
+DEV2 MNT2
-- 
2.43.0

