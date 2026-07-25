Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0F62931C4;
	Sat, 25 Jul 2026 07:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965213; cv=none; b=BAFFehcKWBjNNFL4l2VA9Q1/ZB6kvNkSS2bfjp/bLxvQtYjdTCb37GFdH624bQvOHLC17UaXmLzN76i4u9awYMtkh9/zPGYetshdCYRBQn/JMfMiRTfXgdHPAMHPQwz1dMekhlVhzgK7vu13qYc1/GkGjuPmW2Dwyh56S3MQe4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965213; c=relaxed/simple;
	bh=dwf1Frz49BcW8zHTGUJ7/c5ax//HXgsZhx/8B4vFU80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMaHEcgHQmaQ04ZRmPxxU3Y1Q0FOSRaJcjH8cjhDLcHCWY2k2OgzBWzdeZpbZOIV3I+oogaUipW5W/1ewkELnCryFiJDudCjGntsEewfDDEeVqan94pRGJIt538eDmIeclzkSZ1QVWI1AP3f1sA+4i1xlVYXLtCi5SFgQJppn2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5UlTtLX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5UlTtLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAA91F000E9;
	Sat, 25 Jul 2026 07:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965211;
	bh=cA76/PYw1pPj8n2hc9fHEPPWqFsIP0EVym6yQnBFCxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5UlTtLXVyHfCTBI8/flTElF3CkpTJGwb+5wLfPQKhR4EkeTYHeHP7PBRSYVn0Cb4
	 VAFt5ge1o4ZKrfYjV/FIfvCqxL7ZZg/oI66rjvBoE2NFBznNzoRF8hPd9cvaNzsg3K
	 sylfya0/e2Xtb2vQCO8uuggVTikE6HDEoCNRhPd5hL8hqr4TP24PM6m2AwbLgpnM8C
	 S74uNkuK4Gfse4y+bdwGDLPTjfa4O1gFymza3eDlPQL8Q9mCqmLJmQ7rA/lQFHaNZN
	 l+F3ZrIdHeLh7TNc0Bk4eeS1NrhHd2zjw9zus7gokQ88jYrjb9DlNqxLEN/4UdqSrZ
	 bSpXP+uKjryIg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 11/13] fstests: verify exportfs file handles on cloned filesystems
Date: Sat, 25 Jul 2026 15:39:08 +0800
Message-ID: <7afe9c82cce1540ea0f8cc1f3d1306c24b6cc84d.1784949155.git.asj@kernel.org>
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

Ensure that exportfs can correctly decode file handles on a cloned
filesystem across a mount cycle, by file handles generated on a
cloned device remain valid after mount cycle.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/805     | 80 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/805.out |  2 ++
 2 files changed, 82 insertions(+)
 create mode 100644 tests/generic/805
 create mode 100644 tests/generic/805.out

diff --git a/tests/generic/805 b/tests/generic/805
new file mode 100644
index 000000000000..5827eee039df
--- /dev/null
+++ b/tests/generic/805
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 805
+# Verify that file handles encoded on a cloned filesystem remain valid and
+# resolvable via open_by_handle across a mount cycle and mount order swap.
+
+. ./common/preamble
+
+_begin_fstest auto quick exportfs clone
+
+_require_test
+_require_block_device $TEST_DEV
+_require_exportfs
+_require_loop
+_require_test_program "open_by_handle"
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
+# Create test dir and test files, encode file handles and store to tmp file
+create_test_files()
+{
+	rm -rf $testdir
+	mkdir -p $testdir
+	$here/src/open_by_handle -cwp -o $tmp.handles_file $testdir $NUMFILES
+}
+
+# Attempt to read and decode the saved file handles on the targeted mount point.
+test_file_handles()
+{
+	local opt=$1
+	local when=$2
+
+	echo test_file_handles after $when
+	$here/src/open_by_handle $opt -i $tmp.handles_file $mnt2 $NUMFILES
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
+# Mount both identical UUID filesystems simultaneously
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+NUMFILES=1
+testdir=$mnt2/testdir
+
+# Decode file handles of files/dir after cycle mount
+create_test_files
+
+# Cycle mounts and reverse initialization sequence to check if
+# file handle lookups are okay
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+# Verify file handles can still be resolved post-mount-cycle
+test_file_handles -rp "cycle mount"
+
+status=0
+exit
diff --git a/tests/generic/805.out b/tests/generic/805.out
new file mode 100644
index 000000000000..29b11ec77ffb
--- /dev/null
+++ b/tests/generic/805.out
@@ -0,0 +1,2 @@
+QA output created by 805
+test_file_handles after cycle mount
-- 
2.43.0

