Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E044630595B;
	Mon, 27 Apr 2026 10:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285204; cv=none; b=bizjNDizQBaEFcI3gkURPrxWQ8tXbYHuZgPUEeyWJ7bMoqkymNhnvKiu0xunWtMbj7q1n+MXzE1GbK3UUUhow6cFguQFOa52eegKMhoZn/3Z7FBxMuC0bAFlKijDmu1LnDwpRBxRIEoSNgKiE0LN6Mc5w6MgPp8RPGbIY983OCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285204; c=relaxed/simple;
	bh=AnK9/266XVBJ3UR81lpGj5Wkb9+DgFvDhivXlFWsuBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqI4r8ZITAuzy69+ghBMDdU3g10oaWiFwH05Ke1Q8E8noUvZGmJi442xKRgziFSJWuZQsamT2xdde6MmNlzTnIq1qSzzLxWeY9bRX2HNdbo351GaCURouz6Hj6R6lG+M8/YpaIlAI2l/ckROmKe91vRXNmnObsuwHMxwSt3vedA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZDQq6a3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZDQq6a3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A65C19425;
	Mon, 27 Apr 2026 10:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285203;
	bh=AnK9/266XVBJ3UR81lpGj5Wkb9+DgFvDhivXlFWsuBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZDQq6a3NJn7EMGPgfbCC/VDPWEpLu9Tk9X/jtZslroJompKUUzr6ye3Uvh7Gq4aH
	 peKcdadP8TIjeXubKU0oRXcPdfBRsD8EzIdTrC1a1vK1Hgp/iA3bGQHSkG2x/lxX9M
	 TgdRtSusV9okd35RLdiyntPw14+ObBhuYwh060XCrH9u9G8/q7O8USuKkua3XmZj+K
	 M/o0A8rtF4IQtqcs25w7xvJop33F6q3udI3MwxOWBxsFDqohqGA7nMzuLO3z0ZxnLf
	 QjpcE03vt/16bwn6uuPWrSz8gFkZC7Frq4OtMU2RqpHeB9xDeIOBtdy0OYZgGf05bN
	 Ck0Zt39r33YTg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v3 4/9] fstests: verify fanotify isolation on cloned filesystems
Date: Mon, 27 Apr 2026 18:19:36 +0800
Message-ID: <4777ecd14815b92c9e8577ed4d073d0f999e51ef.1777281778.git.asj@kernel.org>
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

Verify that fanotify events are correctly routed to the appropriate
watcher when cloned filesystems are mounted.
Helps verify kernel's event notification distinguishes between devices
sharing the same FSID/UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/config         |   1 +
 tests/generic/801     | 115 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |   7 +++
 3 files changed, 123 insertions(+)
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
index 000000000000..3f64e4de2206
--- /dev/null
+++ b/tests/generic/801
@@ -0,0 +1,115 @@
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
+_require_loop
+_require_command "$FSNOTIFYWAIT_PROG" fsnotifywait
+
+[ "$FSTYP" = "ext4" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+	"ext4: derive f_fsid from block device to avoid collisions"
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

