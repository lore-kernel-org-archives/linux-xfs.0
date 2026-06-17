Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061322E7F3A;
	Wed, 17 Jun 2026 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695269; cv=none; b=POuyyuNRuRkI5cXWGt3OSSlydQrro3qArr6PPSk7KEX5oR/6/tI6y5XjBm8abzhgw8qVft/BkjGzx/t0uP/JXGjBM9WIed2fx3fyo+0phmwFv9SElWeqQUSf/WG6Mc+if6IRKlTYRbI0KzBOPn7IxoRtPju93S8ndANqZy4dib8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695269; c=relaxed/simple;
	bh=MREnbjvEBqMpy7wpSCVhm497D7ruPet95cTI7ds4mXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpkrkLzYkO3y9NRyQJU//0VVOe6ONXdlTYzFq1yYbXbKW+Ds04bsJQKTcPtWUbXC1WD4D7ExWJRy4B4PCZUB5qyi7dC9D2wHPJCf20AhUNUTpbB9+ksznh+3s26Z9WMFI56iQSjWggf1LUCs2q+8BffeZg90M0VnCJqIcQGSJkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUkHrQA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUkHrQA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC511F00A3A;
	Wed, 17 Jun 2026 11:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695266;
	bh=59hR12Fh7OpPXrpLzZyElHGF/zwJFzn0kyHqlK4pJZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUkHrQA+YONO3oj4BSOoZBmQZ1gR3OizoXOhJk32IOEr9/M76A8rLHIT7mCWg3uGS
	 ZJVSN8P0Q3sxeYmOpZCXL9PT9DeLA4JJhpytQ++q7xZDUiM7fU/GzM8DgGbSc8morg
	 s+jO7l+sNwAD5tmKDkrVMO+02NrogchtShJCp6bt2SW6honqI9hcPlPgG67owuhXLr
	 E/GS2Bth9kUhHLlMxjAIy6ZlR1Wk+5Geiz9td6Ne/+e2ykuLn9m5unxSDOwiaqMrk8
	 SzeT92yc07Hocc0UC6+0l9X9GABxxsiyL5UVyd/e6f0SAImico/pDdhm9XBjFBsIGx
	 aOkZHK+LmjOdw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 07/11] fstests: verify libblkid resolution of duplicate UUIDs
Date: Wed, 17 Jun 2026 19:20:34 +0800
Message-ID: <1cedecd48612d912c7501ab1f88be1c70c4aa1b2.1781694879.git.asj@kernel.org>
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

Verify how findmnt, df (libblkid) resolve device paths when multiple
block devices share the same FSUUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/803     | 72 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/803.out |  6 ++++
 2 files changed, 78 insertions(+)
 create mode 100644 tests/generic/803
 create mode 100644 tests/generic/803.out

diff --git a/tests/generic/803 b/tests/generic/803
new file mode 100644
index 000000000000..77901592366c
--- /dev/null
+++ b/tests/generic/803
@@ -0,0 +1,72 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 803
+# Check if the mountinfo based findmnt would resolve to the common uuid
+# as per the blkid (libblkid based).
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
+# Normalize pool devices and mount points names
+filter_pool()
+{
+	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
+	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
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
+# Get the uuid from the source device
+fsuuid=$(blkid -s UUID -o value ${devs[0]})
+
+# Mount both identical UUID filesystems simultaneously
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
+# Btrfs assigned a random uuid for the clone fs before the fix.
+# Cycle mounts and reverse the initialization (source and clone fs) order.
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
diff --git a/tests/generic/803.out b/tests/generic/803.out
new file mode 100644
index 000000000000..3a130c662430
--- /dev/null
+++ b/tests/generic/803.out
@@ -0,0 +1,6 @@
+QA output created by 803
+DEV1 MNT1 FSUUID
+DEV2 MNT2 FSUUID
+**** mount cycle ****
+DEV1 MNT1 FSUUID
+DEV2 MNT2 FSUUID
-- 
2.43.0

