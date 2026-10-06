Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB7C3F107F;
	Tue,  6 Oct 2026 08:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277011; cv=none; b=OrwyaDQUH7aBdHoCbvZWOIgwkRuKQhTbHSQa3NrEc/2LVeRZocCEDxK15ctNLZDhdHyIiaOkX1jMW5uUlZ/xqUm3zwSJGEnFToi51ytP/DgPNX5MzcAp35XqLOhrFLtdru6Y4Ha3aTPGVYF/MUUe+/lxXBHfEg4PgHOeTQBiGzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277011; c=relaxed/simple;
	bh=zANQBvVoPxv6AdLSFU4YNx2i+WR0rEo4Fjxg6MXtWfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKl3maTPDNwSo6zy+M75L5Cu2HuVZ75rMR9EVEQYc39u9HFoFpV/SysYhzQeRSxdBKsZ75POxsITWGrpJFdHWeK+qbV5GxFJdYVKZcNiGczfNppnXbkseGEIEu7nJX9g7L/EYH1G10sw5p5pB2DZOPhTKLamMcxXg/eD8nR59vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oUJxlXtk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUJxlXtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FE91F000FF;
	Tue,  6 Oct 2026 08:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277010;
	bh=n6YiOGHdD1eF0PETDafh7ZLbd8RCK1qUeembi0JxOTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUJxlXtk1C4pP/LVHMt645aW935v/OeN9WvSxdbGDOuYh/2XqoTOMvF7/nNpJ1Hly
	 PrahsQQ4YgxlgREqcxTo3fWgEdo0GauF3JMrPtYeUFfaMi+OkZmm9C9EB2G4eUanFb
	 mdUSfohxaTHkVckwUNGBXGZVgM99O7PM6Ybt5tZz3y4yW80LYCrhtGnaerjkphzzeC
	 NOeiLoFRSLsVZBUhdL+Yr9TcTsnHeZ72HNMVREdMYgxQ71P5XYqxK6gjO6oXgBjmMT
	 6CN6lJpRJ7DUOzsV4GYv+vo68uS4IgPMAdUIOzQ4Sv+PEFCiozKAH0vZz9OyHeCmeE
	 rbzr3LD98GHJQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 18/21] fstests: test UUID consistency for clones with metadata_uuid
Date: Tue,  6 Oct 2026 16:55:44 +0800
Message-ID: <97ba190c96d3fa545404d2c2f489d34f8f9466e9.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
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
 tests/generic/906     | 74 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/906.out |  6 ++++
 2 files changed, 80 insertions(+)
 create mode 100644 tests/generic/906
 create mode 100644 tests/generic/906.out

diff --git a/tests/generic/906 b/tests/generic/906
new file mode 100644
index 000000000000..99516f18aa39
--- /dev/null
+++ b/tests/generic/906
@@ -0,0 +1,74 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 906
+#
+# Verify that the cloned filesystem UUID remains consistent, even when the
+# `metadata_uuid` feature is enabled.
+#
+
+. ./common/preamble
+. ./common/filter
+
+_begin_fstest auto quick mount tempfsid
+
+_require_test
+_require_loop
+_require_metadata_uuid
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	umount $mnt1 $mnt2 2>/dev/null
+	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
+}
+
+filter_pool()
+{
+	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
+	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
+}
+
+rm -rf $TEST_DIR/$seq 2>/dev/null
+mkdir -p $TEST_DIR/$seq
+# Create base loop device and its clone, applying the metadata_uuid tuning
+# callback to the base filesystem before the copy occurs.
+devs=()
+_create_cloned_loop_devs devs _change_metadata_uuid
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+# Get the uuid from the source device
+fsuuid=$(blkid -s UUID -o value ${devs[0]})
+
+# Mount both clone and baseline
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
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
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+
+_exit 0
diff --git a/tests/generic/906.out b/tests/generic/906.out
new file mode 100644
index 000000000000..b484c86d8e7f
--- /dev/null
+++ b/tests/generic/906.out
@@ -0,0 +1,6 @@
+QA output created by 906
+DEV1 MNT1 FSUUID
+DEV2 MNT2 FSUUID
+**** mount cycle ****
+DEV1 MNT1 FSUUID
+DEV2 MNT2 FSUUID
-- 
2.43.0

