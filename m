Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043A83DA7C4;
	Thu, 21 May 2026 13:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368438; cv=none; b=eX+7fGydNkZhBi27xc3skz2v6wLCPgTLA5AUuuTx+0GYnjhdqMX3jbdKzWyeQR6jU6WN7+rY6BITQyRsHkp00kboiDOqZ7uyUghPaGESSDSe2FIfMfMLHSrumB9r6TChRbCpLrDpe5dkonVeGCyIrFtNAiATaHejMP2LTVBS3Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368438; c=relaxed/simple;
	bh=MU0+wWD5RZ6FgcZ3PtZtBCvGmv1SZt87kcHtgv2OsQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdIXdH7rvEgeSQRuZLLghouZCnOHVNTnh1DqmWy6QA6Rds4c+2Owd6ZrbsumoBUrfQ/qKu8fRYzDUi5kn2O5l8FhDVSiv6Dp/dB6lH6c6N4kig3xrOLQeF0QuCyQ+ov9SLjWHCmKf66QEA80xifSm6OzlBS8mDLZR9JmskY2qL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4IkcKav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4IkcKav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9741F000E9;
	Thu, 21 May 2026 13:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368436;
	bh=bNkRcVo5sV9htfKfRcXEn6CqlV/SMdBn2+ivACnAaP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4IkcKavTWN2QaL+fdcshOdf20VFQwjNy0sDLsotdWTeU5cRDy9SEMIKW26iCs2Xa
	 eollT33B6sHFSvlQglzjkq7s5lzg72/M1vivFgIYFQOowOGafLe0FFH/sK8CA9QzSN
	 Xc1txzKbe0q5jkWETtGbBZ6Yjk5311R1ElizwI9Y3DEt7+pPhiYFSL0JEef4sl0Wyx
	 MS0vKqFIXLIJIDtQ/TDfuiYNmojJdp92vl/tyC4VNRdfuZIs+gUCz8qTPAdMojm7Wa
	 AMFgYohi0Am5s1Bs2WLP3la2PNwSLOK1m2xPSk72rYZrG478lXJNSax6GmYoDI2X1x
	 b4u0x9kU/ls2A==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v5 08/10] fstests: verify exportfs file handles on cloned filesystems
Date: Thu, 21 May 2026 20:54:58 +0800
Message-ID: <eba7acc2280948dc40cc664e1feb2505335d1ca1.1779367627.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779367627.git.asj@kernel.org>
References: <cover.1779367627.git.asj@kernel.org>
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
 tests/generic/805     | 73 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/805.out |  2 ++
 2 files changed, 75 insertions(+)
 create mode 100644 tests/generic/805
 create mode 100644 tests/generic/805.out

diff --git a/tests/generic/805 b/tests/generic/805
new file mode 100644
index 000000000000..98e7172e141f
--- /dev/null
+++ b/tests/generic/805
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 805
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

