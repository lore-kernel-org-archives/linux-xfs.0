Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA29E2931C8;
	Sat, 25 Jul 2026 07:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965209; cv=none; b=pjHi8Dm/VUNELkVa3fRv9YDlfvpwczJnPpHDqh/PxHR1KtmvIbqdFY2VhncYgtzI0jrp/PBBw3Ijbdsc6bkiBQvMwznCl3Aya4cWrxic/OK0I9efbMnz/8nrBC+ThTv98PPFTydFn7W6anRGrUMk8oMIPo2HcxG0QKSDEwNR8hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965209; c=relaxed/simple;
	bh=9KS2QhDFtXstq0laIE1J7X984LbypnyovuVODYY4n+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocf8W1r0Ijjc0cdqmedAk9nT27FUbJrKft3nGEHEqbPuzYAeiV+s9O0cYZE1YgyvfnmnbfiKzPht0i5/WxVeKtCUOyi0MrczM+W/eGYpmhAglp/R01vsqlZP67gXvP2A5BlgjKysx7GGQT2rVM5ecfapU40sEdpTDGdFnh1elzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CziLR9Q8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CziLR9Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7212B1F00A3A;
	Sat, 25 Jul 2026 07:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965207;
	bh=FlMooRTilgvQvegAyzunPUeluQcmMfXOWpgMO7eWB0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CziLR9Q894ixDY6m4AiwjzjfAPdNDQyM45pp2t66QcHiZMxedbTf4QgI4L5y7uvd2
	 8KNj+rA1vYblSiAyXI2k/tOEukrjYtAuKS/pd+MRrOYXW3qMMaHcLvPVk/KEBmfn+2
	 nLVPWQGr5luTvdwBmqL9yXsyIfVSy6NYmDklRHN4z6GgG96eBjvzmNXLm8/zlm3dfm
	 f0Ijriyb1PVPG9g6Xq4Oru6VhQioGauhLkLQexIiRZGiuyRW0flchNtWkfnDQgQc39
	 kirirB7OQ2m8us7RLXdWx4A71qreZy/2yZAU0WeoAI0Rht3pJJFtTgPGUrnTu1kmBy
	 Vl0VILDnsK6ug==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 10/13] fstests: verify IMA isolation on cloned filesystems
Date: Sat, 25 Jul 2026 15:39:07 +0800
Message-ID: <e2ba3b5cf7e17bf87e7e832222d72bcbf8b904f8.1784949155.git.asj@kernel.org>
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

Add testcase to verify IMA measurement isolation when multiple devices
share the same FSUUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/804     | 108 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/804.out |  10 ++++
 2 files changed, 118 insertions(+)
 create mode 100644 tests/generic/804
 create mode 100644 tests/generic/804.out

diff --git a/tests/generic/804 b/tests/generic/804
new file mode 100644
index 000000000000..ced32e6d79dd
--- /dev/null
+++ b/tests/generic/804
@@ -0,0 +1,108 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 804
+# Verify IMA isolation on cloned filesystems:
+# . Mount two devices sharing the same FSUUID (cloned).
+# . Apply an IMA policy to measure files based on that FSUUID.
+# . Create unique files on each mount point to trigger measurements.
+# . Confirm the IMA log correctly attributes events to the respective mounts.
+
+. ./common/preamble
+. ./common/filter
+
+_begin_fstest auto quick clone
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
+	_unmount $mnt1 2>/dev/null
+	_unmount $mnt2 2>/dev/null
+	_loop_image_destroy "${devs[@]}" 2> /dev/null
+}
+
+# Normalize device names and mount points
+filter_pool()
+{
+	sed -e "s|${devs[0]}|DEV1|g" -e "s|$mnt1|MNT1|g" \
+	    -e "s|${devs[1]}|DEV2|g" -e "s|$mnt2|MNT2|g" | _filter_spaces
+}
+
+# Core helper to set IMA policy and check measurement logs
+do_ima()
+{
+	local ima_policy="/sys/kernel/security/ima/policy"
+	local ima_log="/sys/kernel/security/ima/ascii_runtime_measurements"
+	local fsuuid
+	local mnt=$1
+	local enable=$2
+
+	# Since the in-memory IMA audit log is only cleared upon reboot,
+	# use unique random filenames to avoid log collisions.
+	local foofile=$(mktemp --dry-run foobar_XXXXX)
+
+	echo $mnt $enable | filter_pool
+
+	[ -w "$ima_policy" ] || _notrun "IMA policy not writable"
+
+	fsuuid=$(blkid -s UUID -o value ${devs[0]})
+
+	# Load IMA policy to measure file access specifically for this
+	# filesystem UUID.
+	if [[ $enable -eq 1 ]]; then
+		echo "measure func=FILE_CHECK fsuuid=$fsuuid" > "$ima_policy" || \
+			_notrun "Policy rejected"
+	fi
+
+	# Create a file to trigger measurement and verify its entry in
+	# the IMA log.
+	echo "test_data" > $mnt/$foofile
+
+	# IMA log extract
+	grep $foofile "$ima_log" | awk '{ print $5 }' | filter_pool | \
+						sed "s/$foofile/FOOBAR_FILE/"
+
+	echo "dbg: $mnt $fsuuid $foofile" >> $seqres.full
+	cat $ima_log | tail -1 >> $seqres.full
+	echo >> $seqres.full
+}
+
+# Initialize loop base and cloned instances
+devs=()
+_loop_image_create_clone devs
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+# Concurrently mount both clones
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+#  IMA response on baseline and clone configuration
+do_ima $mnt1 1
+do_ima $mnt2 0
+
+# Cycle mount on the second device.
+echo mount cycle
+_unmount $mnt2
+_mount $mount_opts ${devs[1]} $mnt2 || _fail "Failed to mount dev2"
+
+do_ima $mnt1 0
+do_ima $mnt2 0
+
+status=0
+exit
diff --git a/tests/generic/804.out b/tests/generic/804.out
new file mode 100644
index 000000000000..9804181d6c17
--- /dev/null
+++ b/tests/generic/804.out
@@ -0,0 +1,10 @@
+QA output created by 804
+MNT1 1
+MNT1/FOOBAR_FILE
+MNT2 0
+MNT2/FOOBAR_FILE
+mount cycle
+MNT1 0
+MNT1/FOOBAR_FILE
+MNT2 0
+MNT2/FOOBAR_FILE
-- 
2.43.0

