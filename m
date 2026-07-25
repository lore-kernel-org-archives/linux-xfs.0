Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A433E2931C4;
	Sat, 25 Jul 2026 07:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965202; cv=none; b=m93iYCpytlFoxCb2KduEP9lcfbYZ9j6mgKd5aqK3WOv4g/gb8BJ9nHBFhGb0hKtQ3TWGLpVR4brvlqQkIkq4T50aGNflfL7HR3zLkVKQAzuolNMs68u81u1BTWUC3IQiMY0JxYcXKgLN8ssob+fBTOtcxG7UEhmUDVvAUz9Wkvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965202; c=relaxed/simple;
	bh=MREnbjvEBqMpy7wpSCVhm497D7ruPet95cTI7ds4mXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1/QWqX5uOp4XIyd+cd5dBLWUW/r3ACLmisdTTo3V8NBvHm9thwLGL5pWEMYO6ySzMnRO9VHFXKqvD11jJcNyRjtUvi0PI8CfMrhlL6Mrr2bUGl66qq5eql1jZRo7yg9GK7GWlUt40KUopjY8JYvrOoXZsd7twCel5hgrIzVzJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gj1xu1qF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gj1xu1qF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6321F000E9;
	Sat, 25 Jul 2026 07:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965201;
	bh=59hR12Fh7OpPXrpLzZyElHGF/zwJFzn0kyHqlK4pJZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gj1xu1qFRtHFOglUxDz7eyx1nye8DqukMZuKtlauWLMs0U+4Znpb0NR5q1+RdWLmW
	 YnTh9FAG84igIshKYia6BHphZtmsLlC21rq2JAOudM6odJ9PZJ9AV7UEuzUaKGFhjT
	 I2kSNevThSitAKDSTzgT9lk7sayxQMvLx/YdzCldG3yDdPxPbIuSN/d+jKUbbEth9U
	 kuFT5LEMVECkcERxZ6Kulw0Yi6RfVHvoF3ACwtg1hjmKrQQmdXIk7rZE+5d6DPwN4V
	 6rEBX4WZjKhcExMhKIxEZRqjARS8UTtI1f4IZXbHzWRJ4NbC1U+8WTsgLCdrV4koJt
	 /f8NOW5sHEpVA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 09/13] fstests: verify libblkid resolution of duplicate UUIDs
Date: Sat, 25 Jul 2026 15:39:06 +0800
Message-ID: <0e530686fa2bfb9a4b8ec4596484a4fec6d849e4.1784949155.git.asj@kernel.org>
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

