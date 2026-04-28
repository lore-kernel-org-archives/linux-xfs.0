Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ABC351C13;
	Tue, 28 Apr 2026 06:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358601; cv=none; b=h9iws6UHwX8/5ZFlDzNLHJr12IsZdqw0KHR0OKf4hM2mzbKOu2HwineoMA/G/AAH1sCM3csGytjqxmKfdCZBA+it7D4dzldU7BrllTUpRzAlnAxjJEZ1MKeJc0lREnvPqYFM6bOvvgMN/C2gU8tLXDA+uB09daL3zjtEf3JpgMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358601; c=relaxed/simple;
	bh=A39fwIamuiQCahpTIIYXpcht58U1LThjSWjT+3wKKzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTSdVvLRp2wCfGDr1oJhu17O/eVPIThDdjXv515X5uzLvV98gSqnJlFtNrOQg+xYt9YB6PZ/UCiUgHPWQS+h+S6rHYIosTNc6g2pICx4H0TJzr7fqRz+qxCcgK7KTA+JAIhtRWjBGxp3/1VaUSLz7vNHGlbGBbf41s1GjnbQpkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsXvJqBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsXvJqBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF40C2BCAF;
	Tue, 28 Apr 2026 06:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358601;
	bh=A39fwIamuiQCahpTIIYXpcht58U1LThjSWjT+3wKKzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsXvJqBd6c7UyD/VWDxkPzTPcW3rZ2IlncGPvaK96JP7X/1B289g29XCbw3grYT7y
	 +0G89aAi53sboA7A9vfOJhB9N0BiKtvrqCOfXac2Ef2V4IkmjGIweaF4tPSCxlg0vB
	 5VcEQktAz2judFWCCA7CO1m8IGY1U3pE+tlUnw8luqgtvghbcdhVKBo/rARw5sNP2p
	 ZrBik8yig3bJL6GpfW7t30DCXMHWf/QXZaM2cvqohWl4fw83Ydcy599eEgAHNj5Q1N
	 50svDWXoU0GrVod26HomuOrDWEcXOHLjqBovE5SXW3Z+YcAUOo2+qATfj9toAKoas5
	 IFfhUXpowsuHg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v4 4/9] fstests: verify fanotify isolation on cloned filesystems
Date: Tue, 28 Apr 2026 14:42:54 +0800
Message-ID: <5857d9f33de7f0ea8ddd12c36334c6463c0bfe0f.1777357321.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777357320.git.asj@kernel.org>
References: <cover.1777357320.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify that fanotify events are correctly routed to the appropriate
watcher when cloned filesystems are mounted.
Helps verify kernel's event notification distinguishes between devices
sharing the same FSID/UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/config         |   1 +
 tests/generic/801     | 113 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |   7 +++
 3 files changed, 121 insertions(+)
 create mode 100644 tests/generic/801
 create mode 100644 tests/generic/801.out

diff --git a/common/config b/common/config
index 605a57947a40..1588bdcb1aa1 100644
--- a/common/config
+++ b/common/config
@@ -243,6 +243,7 @@ export PARTED_PROG="$(type -P parted)"
 export XFS_PROPERTY_PROG="$(type -P xfs_property)"
 export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
 export INOTIFYWAIT_PROG="$(type -P inotifywait)"
+export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"
 
 # udev wait functions.
 #
diff --git a/tests/generic/801 b/tests/generic/801
new file mode 100644
index 000000000000..e1282f4e3d71
--- /dev/null
+++ b/tests/generic/801
@@ -0,0 +1,113 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 801
+# Verify fanotify FID functionality on cloned filesystems by setting up
+# watchers and making sure notifications are in the correct logs files.
+
+. ./common/preamble
+
+_begin_fstest auto quick mount clone
+
+_require_test
+_require_block_device $TEST_DEV
+_require_loop
+_require_command "$FSNOTIFYWAIT_PROG" fsnotifywait
+
+_cleanup()
+{
+	cd /
+	[[ -n $pid1 ]] && { kill -TERM "$pid1" 2> /dev/null; wait $pid1; }
+	[[ -n $pid2 ]] && { kill -TERM "$pid2" 2> /dev/null; wait $pid2; }
+	umount $mnt1 $mnt2 2>/dev/null
+	_loop_image_destroy "${devs[@]}" 2> /dev/null
+	rm -r -f $tmp.*
+}
+
+monitor_fanotify()
+{
+	local mmnt=$1
+	exec stdbuf -oL $FSNOTIFYWAIT_PROG -m -F -S -e create "$mmnt" 2>&1
+}
+
+fsid_to_fid_parts()
+{
+	local fsid=$1
+	# Pad to 16 hex chars (64-bit), then split into two 32-bit halves
+	local padded=$(printf '%016x' "0x${fsid}")
+	local hi=$(printf '%x' "0x${padded:0:8}")   # strips leading zeros
+	local lo=$(printf '%x' "0x${padded:8:8}")   # strips leading zeros
+	echo "${hi}.${lo}"
+}
+
+devs=()
+_loop_image_create_clone devs
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
+fsid1=$(stat -f -c "%i" $mnt1)
+fsid2=$(stat -f -c "%i" $mnt2)
+
+[[ "$fsid1" == "$fsid2" ]] && \
+	_notrun "Require clone filesystem with unique f_fsid"
+
+log1=$tmp.fanotify1
+log2=$tmp.fanotify2
+
+pid1=""
+pid2=""
+echo "Setup FID fanotify watchers on both mnt1 and mnt2"
+( monitor_fanotify "$mnt1" > "$log1" ) &
+pid1=$!
+( monitor_fanotify "$mnt2" > "$log2" ) &
+pid2=$!
+sleep 2
+
+echo "Trigger file creation on mnt1"
+touch $mnt1/file_on_mnt1
+sync
+sleep 1
+
+echo "Trigger file creation on mnt2"
+touch $mnt2/file_on_mnt2
+sync
+sleep 1
+
+echo "Verify fsid in the fanotify"
+kill $pid1 $pid2
+wait $pid1 $pid2 2>/dev/null
+pid1=""
+pid2=""
+
+e_fsid1=$(fsid_to_fid_parts "$fsid1")
+e_fsid2=$(fsid_to_fid_parts "$fsid2")
+
+echo $fsid1 $e_fsid1 $fsid2 $e_fsid2 >> $seqres.full
+cat $log1 >> $seqres.full
+cat $log2 >> $seqres.full
+
+if grep -qF "$e_fsid1" "$log1" && ! grep -qF "$e_fsid2" "$log1"; then
+	echo "SUCCESS: mnt1 events found"
+else
+	[ ! -s "$log1" ] && echo "  - mnt1 received no events."
+	grep -qF "$e_fsid2" "$log1" && echo "  - mnt1 received event from mnt2."
+fi
+
+if grep -qF "$e_fsid2" "$log2" && ! grep -qF "$e_fsid1" "$log2"; then
+	echo "SUCCESS: mnt2 events found"
+else
+	[ ! -s "$log2" ] && echo "  - mnt2 received no events."
+	grep -qF "$e_fsid1" "$log2" && echo "  - mnt2 received event from mnt1."
+fi
+
+status=0
+exit
diff --git a/tests/generic/801.out b/tests/generic/801.out
new file mode 100644
index 000000000000..d7b318d9f27c
--- /dev/null
+++ b/tests/generic/801.out
@@ -0,0 +1,7 @@
+QA output created by 801
+Setup FID fanotify watchers on both mnt1 and mnt2
+Trigger file creation on mnt1
+Trigger file creation on mnt2
+Verify fsid in the fanotify
+SUCCESS: mnt1 events found
+SUCCESS: mnt2 events found
-- 
2.43.0

