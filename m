Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A45E38BF61;
	Sat, 21 Mar 2026 11:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094328; cv=none; b=PuCY97wneatKix3Km0z/XIUKX0jwJonDCdUO9QEV4S9V+Fm9M8FTph6yiWA7faCEMEwCawSkws3WIsU2hQsowBvyyDelAtC0hM+j96HC+ehvW8ygCry4VBwE9OYMQownbFL9c59BZzDZl5iUv0pRLneI9BdWV662C1Wn026LpuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094328; c=relaxed/simple;
	bh=cBbVVvvxRRnBP9JTCv3AJBnP+b5WAT0chN2Cja6qwLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgzD+AMpjIpwG22a5xkVYgN8cZfvnutRVOzvgSHxthcyfnGamqCjVX5wIuoHVXMaOi0Mwv2lHnVRllAEENopI4HKIzJxE+7AiziBvzhWOeN+S9062ZFEIaF3QxZnaTpuMnHCsocNuD11hhcSsUqRVUxC3fiqpOSyfqGSnyLuM1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJxYUIsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJxYUIsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D048C19421;
	Sat, 21 Mar 2026 11:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094327;
	bh=cBbVVvvxRRnBP9JTCv3AJBnP+b5WAT0chN2Cja6qwLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJxYUIsw4jP7oY1KLy+M4wd2FN+p0vBslmxTIfVMeaIdLAzq/RxoPZLpsQacWuI68
	 M6xmd6EsDsG9KyPH/aELR4FQZHGQyUtx4DeT7jqNsRGZcUM9FBxWCP5cQ/veiU10wE
	 YgyeVj2o0TqmVQ0nMyYjG5JgCGTk4FGWneen52UsUTsiP022EWVlMrYlflGJFEBTxb
	 xpYS9rkA6Rj22c4ve477pky7JCI4fTp/jC4UNbLt2HkbF17+EcGHnUDc5yzEpplUG+
	 Vu7T5Q7GiEI3SzXtQGUrHXwHczIennXATwu1sShuWii4jISO8K6/5mJQ4HtYY1ICMe
	 RTnTwUWk2g5Jw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v2 4/9] fstests: add test for inotify isolation on cloned devices
Date: Sat, 21 Mar 2026 19:58:25 +0800
Message-ID: <ca3f9be5cdd6f7677dd790660225b3ab5954d0bf.1774090817.git.asj@kernel.org>
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

Add a new test, to verify that the kernel correctly differentiates between
two block devices sharing the same FSID/UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/config         |  1 +
 tests/generic/790     | 89 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/790.out |  7 ++++
 3 files changed, 97 insertions(+)
 create mode 100644 tests/generic/790
 create mode 100644 tests/generic/790.out

diff --git a/common/config b/common/config
index 1420e35ddfee..c08f828575a2 100644
--- a/common/config
+++ b/common/config
@@ -228,6 +228,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
 export PARTED_PROG="$(type -P parted)"
 export XFS_PROPERTY_PROG="$(type -P xfs_property)"
 export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
+export INOTIFYWAIT_PROG="$(type -P inotifywait)"
 
 # udev wait functions.
 #
diff --git a/tests/generic/790 b/tests/generic/790
new file mode 100644
index 000000000000..3d9036ee095f
--- /dev/null
+++ b/tests/generic/790
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 790
+#
+# Verify if the kernel or userspace becomes confused when two block devices
+# share the same fid/fsid/uuid. Create inotify on both original and cloned
+# filesystem. Monitor the notification in the respective logs.
+
+. ./common/preamble
+
+_begin_fstest auto quick mount clone
+
+_require_test
+_require_loop
+_require_nouuid_mountopt
+_require_command "$INOTIFYWAIT_PROG" inotifywait
+
+_cleanup()
+{
+	cd /
+	[[ -n $pid1 ]] && { kill -TERM "$pid1" 2> /dev/null; wait $pid1; }
+	[[ -n $pid2 ]] && { kill -TERM "$pid2" 2> /dev/null; wait $pid2; }
+	rm -r -f $tmp.*
+	_unmount $mnt1 2>/dev/null
+	_unmount $mnt2 2>/dev/null
+	_loop_image_destroy "${devs[@]}" 2> /dev/null
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
+log1=$tmp.inotify1
+log2=$tmp.inotify2
+
+pid1=""
+pid2=""
+echo "Setup inotify watchers on both mnt1 and mnt2"
+$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt1 > $log1 2>&1 &
+pid1=$!
+$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt2 > $log2 2>&1 &
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
+echo "Verify inotify isolation"
+kill $pid1 $pid2
+wait $pid1 $pid2 2>/dev/null
+pid1=""
+pid2=""
+
+if grep -q "file_on_mnt1" $log1 && ! grep -q "file_on_mnt2" $log1; then
+	echo "SUCCESS: mnt1 events isolated."
+else
+	echo "FAIL: mnt1 inotify confusion!"
+	[ ! -s $log1 ] && echo "  - mnt1 received no events."
+	grep -q "file_on_mnt2" $log1 && echo "  - mnt1 received event from mnt2."
+fi
+
+if grep -q "file_on_mnt2" $log2 && ! grep -q "file_on_mnt1" $log2; then
+	echo "SUCCESS: mnt2 events isolated."
+else
+	echo "FAIL: mnt2 inotify confusion!"
+	[ ! -s $log2 ] && echo "  - mnt2 received no events."
+	grep -q "file_on_mnt1" $log2 && echo "  - mnt2 received event from mnt1."
+fi
+
+status=0
+exit
diff --git a/tests/generic/790.out b/tests/generic/790.out
new file mode 100644
index 000000000000..6fc08af59301
--- /dev/null
+++ b/tests/generic/790.out
@@ -0,0 +1,7 @@
+QA output created by 790
+Setup inotify watchers on both mnt1 and mnt2
+Trigger file creation on mnt1
+Trigger file creation on mnt2
+Verify inotify isolation
+SUCCESS: mnt1 events isolated.
+SUCCESS: mnt2 events isolated.
-- 
2.43.0

