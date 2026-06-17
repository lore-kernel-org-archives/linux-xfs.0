Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A929B3C9893;
	Wed, 17 Jun 2026 11:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695272; cv=none; b=J820pw7/zV+VoWFF6l+WBenENJZxanjdG8ad0QURpFToJ0ET9hOS/CdTtO7gJ1qt0DctNjYN48qdgv/4xIDlK1ZmyCLvyPj9SFmEAqFKq8uNDH1EJtlvGhymcm4g+qoDIJuqbas3AM1sdJ0g350PcreRVGHSMYdq+QwC2idJUkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695272; c=relaxed/simple;
	bh=9KS2QhDFtXstq0laIE1J7X984LbypnyovuVODYY4n+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjlMgabf3A42c1Ve2NgUhwrQDILonl5IrheTIbkepfQ+JtAMUdId55moOobrve/aj0yLEsOXCcIzKUOpbJFdVpYrOlvXp7p1SeeSwFaxv65m2DnNujOymOdzuZg9HrmJX4IANxMF65CGtlU8l1QwDKZ/laFRqYTt8ryZaGxmVwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sx8LeEVq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sx8LeEVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4111F000E9;
	Wed, 17 Jun 2026 11:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695269;
	bh=FlMooRTilgvQvegAyzunPUeluQcmMfXOWpgMO7eWB0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sx8LeEVqmupxMrWGET07LrDPhRDEwUtHPFIC6J5LHFL+yJzWqjd6IzYZ0BzsScqXt
	 LTgGCchnlrtioDBeLV4Bt6AmHG14bKR5WwPXL+GXEq0gKVxYd9ZZoaUm5wUAYclhak
	 hBU/7PPE891mxC2CCpvoeCrEHr9hQluI3mF1Pf627GVJofzIdZBSRIzheB+WFltLnz
	 jiv5mwvntLEMF1hF5C4HqnFrizjBu0uZmu3JiG7Z2fKYpVnnQ4U6lN3DCl/I6eF5vl
	 EvNEAiwa6O/0RkRg1Q5kk99fru5cr/VjPrkiymE9E+HyyBCnr66hZZoE8gNJRRBv+2
	 +Wks6vitUTQsA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 08/11] fstests: verify IMA isolation on cloned filesystems
Date: Wed, 17 Jun 2026 19:20:35 +0800
Message-ID: <14beb121638f0cb65a507e064b30afb69f94bbd8.1781694879.git.asj@kernel.org>
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

