Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C9D3C09E2;
	Tue,  6 Oct 2026 08:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276991; cv=none; b=fk9SCgTIteyx+BYAsIYiYjrBaLlcho37MPjZwIXkfXs59VI3xs06yAOYhM2zjUmeHddzYZeJkCIJbaa8/Z/2LuTkFFsFNZmeH7pK/68xkFeUnNy2yfNLTj/TOOtZa7VbMb0I17MiZaXPxnK97Cvy0qEI9jwEpLDSebq6RjHRAfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276991; c=relaxed/simple;
	bh=TkEITCfMgKROTTnre8pvlDj8z8W0R6OIDxLj4v4AJWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cy5Ui65k8c2paLOSfcyJOIvb+XrG2AxLgmPboJuYyS13rwKTTNt9IZdH+kfKH1o0ftkZa4XCjfTJfjmNYpzCjoObw9wsOpGVwbG5hrHq1Y27jGD5iKMYPNrFk9Aw2F1GvbRJSwKZCx5TbsAP77nLLACP4rrXX5vJDiH6BcntpiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkH6fwpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkH6fwpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5521F000FF;
	Tue,  6 Oct 2026 08:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276990;
	bh=1Y9Rspeo04EJqvw+V0/Waciw0DhWmA3cTc51A0KgWUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nkH6fwpJRQOQATBlTMfu9IIHHwiTtcJm6HG23AXPkSNpjzuifYzFs+CMxBtMsS9ca
	 LtQr/sDmzG4PRxPyGnBtoS/2v7//IGRdKxG83hNIP0hmYvCFmlvmHWosRG1my5HMXi
	 olNJx/smX4+14uXJ8ZNegGpUMvTaNN9woljs5Rvtr/dPTdyfD+7YwYeA2RSa765+ra
	 TCap4tafwgdXRJ1vUIGycvqTISgk2XXCxeXW13/PNuO7/86vF+aSUrj/3181qAbEpC
	 A5SLlkJKLetJ5Ib6zJBlaO8awQa7JG5NFwR+3cZuG6Y49uhxG6y+/2RXV628/bxxv5
	 2quny9EMe9ZrQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 08/21] fstests: verify fanotify isolation on cloned filesystems
Date: Tue,  6 Oct 2026 16:55:34 +0800
Message-ID: <4a9b0540afb1af06b37a47b9171a0ca2b840da17.1791272793.git.asj@kernel.org>
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

Verify that fanotify events are correctly routed to the appropriate
watcher when cloned filesystems are mounted.
Helps verify kernel's event notification distinguishes between devices
sharing the same FSID/UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/901     | 142 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/901.out |   7 +++
 2 files changed, 149 insertions(+)
 create mode 100644 tests/generic/901
 create mode 100644 tests/generic/901.out

diff --git a/tests/generic/901 b/tests/generic/901
new file mode 100644
index 000000000000..55be6c10cf46
--- /dev/null
+++ b/tests/generic/901
@@ -0,0 +1,142 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 901
+# Verify fanotify FID functionality on cloned filesystems by setting up
+# watchers and making sure notifications are in the correct logs files.
+
+. ./common/preamble
+
+_begin_fstest auto quick mount tempfsid
+
+_require_test
+_require_loop
+_require_command "$SEMANAGE_PROG" semanage
+_require_command "$FSNOTIFYWAIT_PROG" fsnotifywait
+_require_fanotify_function
+_require_unique_f_fsid
+
+_cleanup()
+{
+	cd /
+	[[ -n $pid1 ]] && { kill -TERM "$pid1" 2> /dev/null; wait $pid1; }
+	[[ -n $pid2 ]] && { kill -TERM "$pid2" 2> /dev/null; wait $pid2; }
+
+	if [ "$semanage_added" = "yes" ]; then
+		semanage permissive -d unconfined_t >/dev/null 2>&1 || true
+	fi
+
+	umount $mnt1 $mnt2 >/dev/null 2>&1
+	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
+	rm -r -f $tmp.*
+}
+
+# Run fsnotifywait in unbuffered mode to watch filesystem-wide create events
+monitor_fanotify()
+{
+	local mmnt=$1
+	exec stdbuf -oL $FSNOTIFYWAIT_PROG -m -F -S -e create "$mmnt" 2>&1
+}
+
+# Transform f_fsid into the hi.lo format used in fanotify FID logs
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
+rm -rf $TEST_DIR/$seq 2>/dev/null
+mkdir -p $TEST_DIR/$seq
+# Create base loop device and its clone
+devs=()
+_create_cloned_loop_devs devs
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+# Mount both base and clone filesystems using required clone mount options
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+# Fetch filesystem IDs to verify the kernel can differentiate between them
+fsid1=$(stat -f -c "%i" $mnt1)
+fsid2=$(stat -f -c "%i" $mnt2)
+
+log1=$tmp.fanotify1
+log2=$tmp.fanotify2
+
+pid1=""
+pid2=""
+echo "Setup FID fanotify watchers on both mnt1 and mnt2"
+
+# Permit unconfined_t domains when SELinux is enforcing to prevent fanotify
+# blockages
+semanage_added="no"
+if [ "$(getenforce 2>/dev/null)" = "Enforcing" ]; then
+    if ! semanage permissive -l | grep -q "unconfined_t"; then
+        semanage permissive -a unconfined_t >/dev/null 2>&1 && semanage_added="yes"
+    fi
+fi
+
+# Start asynchronous fanotify monitors
+( monitor_fanotify "$mnt1" > "$log1" ) &
+pid1=$!
+( monitor_fanotify "$mnt2" > "$log2" ) &
+pid2=$!
+sleep 2
+
+if ! kill -0 "$pid1" 2>/dev/null || ! kill -0 "$pid2" 2>/dev/null; then
+	cat "$log1"
+	cat "$log2"
+	_fail "$FSNOTIFYWAIT_PROG setup failed"
+fi
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
+# Dump debug details to the full log
+echo $fsid1 $e_fsid1 $fsid2 $e_fsid2 >> $seqres.full
+cat $log1 >> $seqres.full
+cat $log2 >> $seqres.full
+
+# Ensure monitor 1 only captured events belonging to mnt 1 and fsid 1
+if grep -qF "$e_fsid1" "$log1" && ! grep -qF "$e_fsid2" "$log1"; then
+	echo "SUCCESS: mnt1 events found"
+else
+	[ ! -s "$log1" ] && echo "  - mnt1 received no events."
+	grep -qF "$e_fsid2" "$log1" && echo "  - mnt1 received event from mnt2."
+fi
+
+# Ensure monitor 2 only captured events belonging to mnt 2 and fsid 2
+if grep -qF "$e_fsid2" "$log2" && ! grep -qF "$e_fsid1" "$log2"; then
+	echo "SUCCESS: mnt2 events found"
+else
+	[ ! -s "$log2" ] && echo "  - mnt2 received no events."
+	grep -qF "$e_fsid1" "$log2" && echo "  - mnt2 received event from mnt1."
+fi
+
+_exit 0
diff --git a/tests/generic/901.out b/tests/generic/901.out
new file mode 100644
index 000000000000..414e12d10b27
--- /dev/null
+++ b/tests/generic/901.out
@@ -0,0 +1,7 @@
+QA output created by 901
+Setup FID fanotify watchers on both mnt1 and mnt2
+Trigger file creation on mnt1
+Trigger file creation on mnt2
+Verify fsid in the fanotify
+SUCCESS: mnt1 events found
+SUCCESS: mnt2 events found
-- 
2.43.0

