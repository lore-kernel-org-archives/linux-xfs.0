Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99FC3E317F;
	Tue,  6 Oct 2026 08:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277004; cv=none; b=nnxjyKp3Gk3xH62hU76XZZdaWgI/9xThJXq5FsqO+E6R8Ddg5lOsuLjdaSIoAmkvAyj9kA9Gyx4c9S0jA0efUD12izTxrchvHgmIlCcQ85lj2PIMlwCWUXW3uZtUt/smVj3PPh3nkqe4N84s2f4SQwahJ9JSfmBlZqc/N4vBIJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277004; c=relaxed/simple;
	bh=WC1wm1Imyh+jWy7NiG8wMQrmdw4ZBnfo0qCDFMRtxmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iC5SVMnysKawupgCvEif2ArW0gQ6v+nGaoBKYlxdvm++oQHX4cyngFfGCHTtQ+2VbEWoBAieEbuU5OGxpWzUQOrEhAG6kx81hL1vFikkXJLd9S9tokXcI0WN053282D23a7cSp+XtNR1RnSKvefGMR01emhc98mPqCfYxSEUxvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/9yXFvP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/9yXFvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8E71F000FF;
	Tue,  6 Oct 2026 08:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277002;
	bh=HHu7gDlAiTv8ITMcBiXQcO0crJQVWjNEEBbX8nVsW9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/9yXFvPzboRx+4x8PtFUM7NKtNwOdbevO5JKvZLRhE/Ylv/FumlgU4e7e+uH1SPj
	 Vgw5FvschVG2G0lxuBT/2LfghxDpdKWFQUEoChcs5h5nkXJA0cXYXR9rZQuVMo6SDs
	 8C7tAEDYpIxCn9v9UKGTiywnaM7CdkfTJR9tEczoLek5+HzVjnQeBL+/jIpsXmSvPs
	 R/iyzAtbQJvUA1MI8YGymZWSin4InbsuZjabwf84UeWxzP20u0J2GIiriRePOZ1qeB
	 rt1WmuoG/0HKd+/cO7Arn5suVX7AWgzY+LfqgHOzecO7iH6sk8hDki2lg8p3iZYxrZ
	 C+X72jFfgrXkg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 14/21] fstests: verify IMA isolation on cloned filesystems
Date: Tue,  6 Oct 2026 16:55:40 +0800
Message-ID: <ed4b48e156ccad10cff02f17ece3c624cc9dd749.1791272793.git.asj@kernel.org>
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

Add testcase to verify IMA measurement isolation when multiple devices
share the same FSUUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/904     | 113 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/904.out |  10 ++++
 2 files changed, 123 insertions(+)
 create mode 100644 tests/generic/904
 create mode 100644 tests/generic/904.out

diff --git a/tests/generic/904 b/tests/generic/904
new file mode 100644
index 000000000000..d8412d0bc402
--- /dev/null
+++ b/tests/generic/904
@@ -0,0 +1,113 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 904
+# Verify IMA isolation on cloned filesystems:
+# . Mount two devices sharing the same FSUUID (cloned).
+# . Apply an IMA policy to measure files based on that FSUUID.
+# . Create unique files on each mount point to trigger measurements.
+# . Confirm the IMA log correctly attributes events to the respective mounts.
+
+. ./common/preamble
+. ./common/filter
+
+_begin_fstest tempfsid
+
+_require_test
+_require_loop
+_require_security_ima
+
+_fixed_by_fs_commit btrfs df84f6c77377 \
+	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
+_fixed_by_fs_commit btrfs c2a74ed0494c \
+	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
+_fixed_by_fs_commit btrfs 72de4807ba84 \
+	"btrfs: derive f_fsid with dev_t only when temp_fsid is active"
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	_unmount $mnt1 2>/dev/null
+	_unmount $mnt2 2>/dev/null
+	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
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
+	fsuuid=$(blkid -s UUID -o value ${devs[0]})
+
+	# Load IMA policy to measure file access specifically for this
+	# filesystem UUID.
+	if [[ $enable -eq 1 ]]; then
+		echo "measure func=FILE_CHECK fsuuid=$fsuuid" > "$ima_policy" || \
+			_fail "Policy rejected"
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
+	tail -1 "$ima_log" >> $seqres.full
+	echo >> $seqres.full
+}
+
+# Core helper to set IMA policy and check measurement logs
+
+rm -rf $TEST_DIR/$seq 2>/dev/null
+mkdir -p $TEST_DIR/$seq
+
+# Initialize loop base and cloned instances
+devs=()
+_create_cloned_loop_devs devs
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+# Concurrently mount both clones
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+#  IMA response on baseline and clone configuration
+do_ima $mnt1 1
+do_ima $mnt2 0
+
+# Cycle mount on the second device.
+echo mount cycle
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+do_ima $mnt1 0
+do_ima $mnt2 0
+
+_exit 0
diff --git a/tests/generic/904.out b/tests/generic/904.out
new file mode 100644
index 000000000000..22340f236a45
--- /dev/null
+++ b/tests/generic/904.out
@@ -0,0 +1,10 @@
+QA output created by 904
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

