Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ABF3E0245;
	Thu, 21 May 2026 13:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368442; cv=none; b=sQdA5BH8fgpp4zpBrcOL+lmS1JpUh8lo2M6BLB17bFDTIks1wW/GIQdSjiCfKeHtB/GjtH36sd+/CwkRs6Wr56DyidCQj6/0ETLynCfN++wJi9loU/ZHoZBKHOGIPYhp7AIV4+wQuN9jFswbJclR9+HznOV2mabnFH9oxoU5w6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368442; c=relaxed/simple;
	bh=WjZE0lw+kIRrw88mlLLxcHIB9y8pNWWlx7yQb5ZhhZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1aLxBT8oFXsH7AMoWUj/R8hCel4wOu64fcGqNtmUR1rYAtjd+uJZFsxHCnchCtMP+5mSIaH4Tln7PwphNvNeUpaNBnqQFWmqXeNV0SLxmL5kwIyiUCD0hNuEsqDS/qGNKHPvgReXMAqgAA0MdMBeSnNfMSBv4dF3gb252ReggY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmBgGEW6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmBgGEW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22CB1F000E9;
	Thu, 21 May 2026 13:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368441;
	bh=aZN8mbxtxCFUtRaR4pRYVfr1zIJ/p51FRse13QkQL2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmBgGEW666V3vs6bbPrzdpAB75Xa8bVqh0fnqGCruA3HHxU7YXhGx/abxAUeA23yn
	 B68uNZScFWSPlyEXIISlcxzI005MY8TQUCS/1Rab43VOcnO85LuyeHqQWJJzumY+ID
	 B3gROxDWebjMsJKTYvCepJKl4MtOWYnpjr/IHBnRa1PUlfO/5xwUhrsHmnfwnLWCXP
	 s3KadBZOcdCtcJFAjMN4/C2eQBDALmojcMVtb2j82+hPRzONSiYNe7b8KPr43ph1hh
	 TUzfcdFaiTraGURXz3TSBsMz3/EixK9zfGFmJPc75E0KZeast6f9SWmOQ6RQ6HbEX6
	 p39JtG/F5t7dQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v5 10/10] fstests: test UUID consistency for clones with metadata_uuid
Date: Thu, 21 May 2026 20:55:00 +0800
Message-ID: <b1001bb1a90b81ee8b60914dd8211efd37b98bc4.1779367627.git.asj@kernel.org>
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

Btrfs and xfs uses the metadata_uuid superblock feature to change the
on-disk UUID without rewriting every block header. This patch adds a
sanity check to ensure UUID consistency when a filesystem with
metadata_uuid enabled is cloned.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/806     | 78 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/806.out | 19 +++++++++++
 2 files changed, 97 insertions(+)
 create mode 100644 tests/generic/806
 create mode 100644 tests/generic/806.out

diff --git a/tests/generic/806 b/tests/generic/806
new file mode 100644
index 000000000000..222d138976d3
--- /dev/null
+++ b/tests/generic/806
@@ -0,0 +1,78 @@
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
+devs=()
+_loop_image_create_clone devs pre_clone_tune_uuid
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
+print_info $mnt1
+print_info $mnt2
+
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

