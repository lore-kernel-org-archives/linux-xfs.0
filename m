Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB7338B7B8;
	Sat, 21 Mar 2026 11:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094338; cv=none; b=nFqIYy/xeY1/f1Ngywba0Bz2JdLW8A+5cQj9JbYZA9BCtwUO7V/sVPBbPLXw3216h2VDNSMJpN+uQofTR1jb0M5zh1I37wUCu1ct5RxUV3AHvf8/pU56DzY6gz6PxzNITySaM65oS8t78Q7DXIADHm4Lorpq3IiyHzjKKTlHcnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094338; c=relaxed/simple;
	bh=vkD0TMxCQA1e6lAgbwcqQ3f1iU5VP/mMQrrQ8vZ1S1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPpo+AgNAlh6hbnXtWYToejMd2oVNwgzfA9B4fdJ34c5iBeL8s6s1jgkVNWkt/EajtVK/RRxriZXJP/GoV50lmlD+06tX8dOAOATrik8N2j0f32FAgyGB1eNXJcMBXxNvjyr8jUSKd91pR5xCkiLUp43SNXmBuHwgbePboUEBso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXidf/sq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXidf/sq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B64C2BC87;
	Sat, 21 Mar 2026 11:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094338;
	bh=vkD0TMxCQA1e6lAgbwcqQ3f1iU5VP/mMQrrQ8vZ1S1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXidf/sq9eENtimtVptQGgnFzbwZ4NPtTE3g67w/ygJNiu9ID2pSI4WrSncYemtfF
	 FjdqqiNTWWqzBtSS6zTfg06KaK997rQnoh9UL1aK8Nt0HPvi/evnzDy094rhNph65q
	 7l8kxkbGslx9l4Tg6czMLniv6mA+du0j+E5SnBeogA9OkMpzdYBMRGr6qp3Sc2Ccw0
	 0I0l11cR9KcjnMaZawhl2jLV/BYdK6GrIpFSjb2bNzmQmFvygfjO+oC42Wch1TMUz7
	 EYIPwqB6ajaV0x/Z7OGYKL+1uhqG8OXh/bKtB9fPgmoh1CDQJQbAKQCoTrdI4h+zVE
	 ZNUApxKL+KthQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v2 9/9] fstests: verify exportfs file handles on cloned filesystems
Date: Sat, 21 Mar 2026 19:58:30 +0800
Message-ID: <736c214977f6cd2ce25aaa237a49d0907481ee38.1774090817.git.asj@kernel.org>
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

Ensure that exportfs can correctly decode file handles on a cloned
filesystem across a mount cycle, by file handles generated on a
cloned device remain valid after mount cycle.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/795     | 73 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/795.out |  2 ++
 2 files changed, 75 insertions(+)
 create mode 100644 tests/generic/795
 create mode 100644 tests/generic/795.out

diff --git a/tests/generic/795 b/tests/generic/795
new file mode 100644
index 000000000000..e7ba146350ee
--- /dev/null
+++ b/tests/generic/795
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 795
+
+. ./common/preamble
+
+_begin_fstest auto quick exportfs clone
+
+_require_test
+_require_exportfs
+_require_loop
+_require_nouuid_mountopt
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
+# Decode file handles loaded from tmp file
+test_file_handles()
+{
+	local opt=$1
+	local when=$2
+
+	echo test_file_handles after $when
+	$here/src/open_by_handle $opt -i $tmp.handles_file $mnt2 $NUMFILES
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
+NUMFILES=1
+testdir=$mnt2/testdir
+
+# Decode file handles of files/dir after cycle mount
+create_test_files
+
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+test_file_handles -rp "cycle mount"
+
+status=0
+exit
diff --git a/tests/generic/795.out b/tests/generic/795.out
new file mode 100644
index 000000000000..774fe7487d65
--- /dev/null
+++ b/tests/generic/795.out
@@ -0,0 +1,2 @@
+QA output created by 795
+test_file_handles after cycle mount
-- 
2.43.0

