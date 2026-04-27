Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453FF30AAB8;
	Mon, 27 Apr 2026 10:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285210; cv=none; b=XmG9tRsM6iuo2zXgbSffHb70LsV5Auf6wqHQBlT1w546fHSidWLWbWbZcFQCXyqJAt5AVzIBBmKV2zBUi6LwoU/yKv9iTypV9G8DI5m57Ba/Jl4iwITXMQg/RYnl442ASD6p8HTHb2c94+gX0gqWHhfccHSRjcZRHF0YzjxFVCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285210; c=relaxed/simple;
	bh=9/N0AQH0CI6Lb0+Ddp6I4qUiPXUMGAFK20BPKCcVG8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alHddxgcP/AwE2qnFlazpH7Xs1xCMJdVcIUSak85kaGBkgXIdQl4brJcSXw/rUXgybLTlZNeq4yPey/k3NFuHWm/Az6AAfFA/UmTSPRozAjoH2Q7dh53NY+e+dbKPsP3NaPOBbVyOb02TfEoDVr8flQFF6Ipm936VcGljlgY52k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O8aczSUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8aczSUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7E2C2BCB4;
	Mon, 27 Apr 2026 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285209;
	bh=9/N0AQH0CI6Lb0+Ddp6I4qUiPXUMGAFK20BPKCcVG8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8aczSUN4iKloTWS1l13LpTiT0t6vy4ooqU2vYhmPHMx6fJKw3fe4T3Jc0zSv/iKY
	 hCXLIRY9ZyQn//Arz0UapGbNRbOMEpmQluSfoSY32g5Aj4cyniEJFTuwWbOyuTFCAA
	 mlD0cZ+LC8/BygBXYx9NUFm4mQXm32IyFzjHxAdoggqBYU1Xep1h73irOmPUKeivKa
	 j9xaeAhGAEtEUlqc39mr2mDQmVArtzKInHm5aLNuZB2x1qW7xWxBZ+Yv1QAIDlKQQz
	 NumxdbTS/X9AT2rhStTmdL/PQIjnI8vkRx7wCIy2ReUrXOGQxyBWl9oYj5NvHbzBQI
	 G7wsrdek3JZsQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v3 7/9] fstests: verify IMA isolation on cloned filesystems
Date: Mon, 27 Apr 2026 18:19:39 +0800
Message-ID: <42e881ea9b95eed28efda3edf0387b18a0b01b5d.1777281778.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777281778.git.asj@kernel.org>
References: <cover.1777281778.git.asj@kernel.org>
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
 tests/generic/804     | 102 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/804.out |  10 +++++
 2 files changed, 112 insertions(+)
 create mode 100644 tests/generic/804
 create mode 100644 tests/generic/804.out

diff --git a/tests/generic/804 b/tests/generic/804
new file mode 100644
index 000000000000..5f5c04f97579
--- /dev/null
+++ b/tests/generic/804
@@ -0,0 +1,102 @@
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
+_require_loop
+
+[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
+[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
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
+filter_pool()
+{
+	sed -e "s|${devs[0]}|DEV1|g" -e "s|$mnt1|MNT1|g" \
+	    -e "s|${devs[1]}|DEV2|g" -e "s|$mnt2|MNT2|g" | _filter_spaces
+}
+
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
+	# For $ima_log column entry please ref to
+	grep $foofile "$ima_log" | awk '{ print $5 }' | filter_pool | \
+						sed "s/$foofile/FOOBAR_FILE/"
+
+	echo "dbg: $mnt $fsuuid $foofile" >> $seqres.full
+	cat $ima_log | tail -1 >> $seqres.full
+	echo >> $seqres.full
+}
+
+devs=()
+_loop_image_create_clone devs
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
+do_ima $mnt1 1
+do_ima $mnt2 0
+
+# Btrfs uses in-memory dynamic temp_fsid
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

