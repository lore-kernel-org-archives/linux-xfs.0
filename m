Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59B338B7A6;
	Sat, 21 Mar 2026 11:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094336; cv=none; b=fOrGzBKs6wqcMEx/zVORwRodqGWOJohOJBqtIvOvIyZ6+DQKqz9nb4fjbB+1VIONCTZjnJX0sPiCEbQ5IZM5kkshynBM8KD5iOx93RvTJ+rpMhvTP/rAygHVFKK7yjlOGVwgcRvS3G8CjI6GSWpp6kwy7/Nd64ckPFHHUjm8R8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094336; c=relaxed/simple;
	bh=/MXssURa7qmlNPosGBTMuJB/s2sg32i6UHKROghwJEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB7p7zgpGtbJGCCKrp5j0z5PUp4lqqLT7+h8fCkMddx0pYtRpFv6Hc+UGzd9BgsHKuF+7YUYMKV4cd7czznn3wnwy3WWpR+0Takv/mFYboSziwF/FrG064N+cOHtXZ13rhN8ZiNt18Htys5ly7EKTftcehZQ/e5J/Ed0DBBSxBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tGfQhbeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tGfQhbeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B67C19421;
	Sat, 21 Mar 2026 11:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094336;
	bh=/MXssURa7qmlNPosGBTMuJB/s2sg32i6UHKROghwJEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGfQhbegF95xXaQmP9LFwQKQEV5QIkRsVN825cdT0Bt076nsnU5ZzXsM/BfFlbh/X
	 qCCTxeMgpHvIAG3QVvJlOXM6WhGq/vBBa5pO8lHdD1ruBxzbagoB+5rW9E7TlQC8aN
	 Nh7GTMDJ35cLjjAHOYbfZ9Ob5u7J0hLQZCbsypz9LbfRK9KntsbSv6bZcIK5VaD1/s
	 XoUuiXp28ALj6IfgLvBI+yS31xsq/YiT4ZKDIF6pprPvSWojFCclicPBlM/3kf4Br/
	 1+kmNv3exP7JMHcoVGx/fuGogtH1XGwCiPN5Qn5/KxxgzXrJXzr7YjAn7y3xPBB7O/
	 SJx3sY7rzzAQA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v2 8/9] fstests: verify IMA isolation on cloned filesystems
Date: Sat, 21 Mar 2026 19:58:29 +0800
Message-ID: <a8553879b23720a1c701cd9314f135150cd5f36b.1774090817.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774090817.git.asj@kernel.org>
References: <cover.1774090817.git.asj@kernel.org>
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
 tests/generic/794     | 103 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/794.out |  10 ++++
 2 files changed, 113 insertions(+)
 create mode 100644 tests/generic/794
 create mode 100644 tests/generic/794.out

diff --git a/tests/generic/794 b/tests/generic/794
new file mode 100644
index 000000000000..391563b84cfc
--- /dev/null
+++ b/tests/generic/794
@@ -0,0 +1,103 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 794
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
+_require_nouuid_mountopt
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
diff --git a/tests/generic/794.out b/tests/generic/794.out
new file mode 100644
index 000000000000..492f8b0b0bec
--- /dev/null
+++ b/tests/generic/794.out
@@ -0,0 +1,10 @@
+QA output created by 794
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

