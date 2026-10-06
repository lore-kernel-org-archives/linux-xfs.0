Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABB23E63B2;
	Tue,  6 Oct 2026 08:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277000; cv=none; b=EezgJsM+CXO++s9bs3xYoOE2riLXfGWe0G66v4/T+4fSlJU95dzO4lvHmiz1WcPT2fMindiaSrPxcS/o1YXEdKlnnsnV8vTC9gSdIrTgesiwKGVKPEEReS06KAc9DlIJ/10DPJ6L6KokqPC+RVAombd+hxH5NWPsfl0ku45fknI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277000; c=relaxed/simple;
	bh=iy+uYdKNIr3E/Whp4/8NJaBRkqeN8QzOP0ec7x0e10s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXBm/SWT0VGwh70pbi1gU4HuHTpgh6hv7AaOZcMxvYJzrNfVC4IgsHATvIIyf026qZEIVKGpBbwBI+WU8Y4ktbtrTBBy6usDh/WeSVzEE+oar6iSWytiqsBDNVfYLUlZ4BgkZU+PINFCS/ATKcvi/U0YZSRYE36e/Y/PlpHXWk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RT1dP/yE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RT1dP/yE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D344E1F000FF;
	Tue,  6 Oct 2026 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276998;
	bh=rVp24MqqHiuT/y2pf5QFaoxVDpmr3Y/Sq6SL7jXJJYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RT1dP/yEyVA0tpYfvgb3+liETzh9f+bN/rPzfkxA+u4R+PH2+8Vo0NVfLzwzD5zI+
	 F2JT1zBq+RkJ0n8G06MeYPKi+H2a7988Cs4/nSanyaMDXXGb5jlIKOWwBOaZWg9gGV
	 aDaqfWzLfMufAT1USqqThfXWXRmYHTu2frFMLuTKppdebxNcc2RJvcFmrxsJDEpKJB
	 gZWD53IDjc9ZP0lyvhd5SonnZsdpMvvXxUZbS8ixGoAaxDpBAAn6TUjWgaottNbPyf
	 fs0bc9bUNtDCD0q6br/lJXmB5KhX09Q2MtN6WZhhUTQ28N2Vxos+AV/QA+sLlcsfK9
	 sZuVSeSyqcjrg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 12/21] fstests: verify libblkid resolution of duplicate UUIDs
Date: Tue,  6 Oct 2026 16:55:38 +0800
Message-ID: <819a40991baec14ff589da95f3e68af91c33fdf1.1791272793.git.asj@kernel.org>
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

Verify how findmnt, df (libblkid) resolve device paths when multiple
block devices share the same FSUUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/903     | 71 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/903.out |  6 ++++
 2 files changed, 77 insertions(+)
 create mode 100644 tests/generic/903
 create mode 100644 tests/generic/903.out

diff --git a/tests/generic/903 b/tests/generic/903
new file mode 100644
index 000000000000..d8aeba691fd4
--- /dev/null
+++ b/tests/generic/903
@@ -0,0 +1,71 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 903
+# Check if the mountinfo based findmnt would resolve to the common uuid
+# as per the blkid (libblkid based).
+
+. ./common/preamble
+. ./common/filter
+
+_begin_fstest auto quick mount tempfsid
+
+_require_test
+_require_loop
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	umount $mnt1 $mnt2 2>/dev/null
+	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
+}
+
+# Normalize pool devices and mount points names
+filter_pool()
+{
+	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
+	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
+}
+
+rm -rf $TEST_DIR/$seq 2>/dev/null
+mkdir -p $TEST_DIR/$seq
+# Setup base loop device and its clone
+devs=()
+_create_cloned_loop_devs devs
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+# Get the uuid from the source device
+fsuuid=$(blkid -s UUID -o value ${devs[0]})
+
+# Mount both identical UUID filesystems simultaneously
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+findmnt --noheadings -o SOURCE,TARGET,UUID "${devs[0]}" | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+findmnt --noheadings -o SOURCE,TARGET,UUID "${devs[1]}" | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+
+# Btrfs assigned a random uuid for the clone fs before the fix.
+# Cycle mounts and reverse the initialization (source and clone fs) order.
+echo "**** mount cycle ****"
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+findmnt --noheadings -o SOURCE,TARGET,UUID "${devs[0]}" | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+findmnt --noheadings -o SOURCE,TARGET,UUID "${devs[1]}" | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+
+_exit 0
diff --git a/tests/generic/903.out b/tests/generic/903.out
new file mode 100644
index 000000000000..7683506e1c94
--- /dev/null
+++ b/tests/generic/903.out
@@ -0,0 +1,6 @@
+QA output created by 903
+DEV1 MNT1 FSUUID
+DEV2 MNT2 FSUUID
+**** mount cycle ****
+DEV1 MNT1 FSUUID
+DEV2 MNT2 FSUUID
-- 
2.43.0

