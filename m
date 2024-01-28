Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B963428DC8;
	Sun, 28 Jan 2024 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706457417; cv=none; b=C7VB+xtSowQ8/F1nWwsJNdfuP1ITPdsf2HdmkfMoiBh8VyCASUo0TKSBZf3pnz4897Se9PJrtlzHR2yuCpKq+vOth5e9pfqiaZyksj6f/46Cpci1LcuZX+VKnS2rM0A3IXFmS6pmqhhrcyAM/qFQ0KAOZwV/N7yYQEDqUk9gyqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706457417; c=relaxed/simple;
	bh=56E5WiLLMuMG2dxnRIUD0Rdu2oqizEKM8RTTn63YZN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h89WkaMfVayojmqjK4nk/5ImRIeXSQQ0e2r1ZuVzPoLiwKvNf5vLk+2gvxkZBzm1dc6PFUASn1UkQ0ZitDKiaJOZKCenyhnat/qbJMOAe8qGtB9MH4Ybunshc9MulG16shTIleXfvgUgAzFiEqJ0XZDEZ2Le3L6ZGZr+3LX5ZsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQ3QQS47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQ3QQS47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF4EC433C7;
	Sun, 28 Jan 2024 15:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706457417;
	bh=56E5WiLLMuMG2dxnRIUD0Rdu2oqizEKM8RTTn63YZN0=;
	h=From:To:Cc:Subject:Date:From;
	b=HQ3QQS47tqGHlLIJPVS0Zhroi+7lNtyBfylBD4meFDpHi65oxOBFQwStNznXiqsXa
	 vOQURiijBxlIyeFo6/RKiIGEW6buumSDGdhNSjVCmhCWGdLFYzttWexM9Y9dkSVGoy
	 ZDUux8m0baO6RI0CEZCLROIjoZHn434I6f4Ip/aoLvdfEI3wQOWGj6IwDc5+9gBAVG
	 WeZTKcM5qtPiXMHiULuCOkVlfY4ED1lnB7MFZCHiqQWqXawvIopBCVg5strgTbGaPY
	 +twMFsq/Pp2NczfkyZQlE9MfVyjkiMQYALQ7j8O8hihLp88aBwG8f9pXuqUMjJJFGr
	 4QQ8TXibUr2Iw==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: test xfs_growfs with too-small size expansion
Date: Sun, 28 Jan 2024 23:56:53 +0800
Message-ID: <20240128155653.1533493-1-zlang@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This's a regression test of 84712492e6da ("xfs: short circuit
xfs_growfs_data_private() if delta is zero").

If try to do growfs with "too-small" size expansion, might lead to a
delta of "0" in xfs_growfs_data_private(), then end up in the shrink
case and emit the EXPERIMENTAL warning even if we're not changing
anything at all.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 tests/xfs/999     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |  2 ++
 2 files changed, 55 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..09192ba3
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 999
+#
+# Test xfs_growfs with "too-small" size expansion, which lead to a delta of "0"
+# in xfs_growfs_data_private. This's a regression test of 84712492e6da ("xfs:
+# short circuit xfs_growfs_data_private() if delta is zero").
+#
+. ./common/preamble
+_begin_fstest auto quick growfs
+
+_cleanup()
+{
+	local dev
+        $UMOUNT_PROG $LOOP_MNT 2>/dev/null
+	dev=$(losetup -j testfile | cut -d: -f1)
+	losetup -d $dev 2>/dev/null
+        rm -rf $LOOP_IMG $LOOP_MNT
+        cd /
+        rm -f $tmp.*
+}
+
+# real QA test starts here
+_supported_fs xfs
+_fixed_by_kernel_commit 84712492e6da \
+	"xfs: short circuit xfs_growfs_data_private() if delta is zero"
+_require_test
+_require_loop
+_require_xfs_io_command "truncate"
+
+LOOP_IMG=$TEST_DIR/$seq.dev
+LOOP_MNT=$TEST_DIR/$seq.mnt
+rm -rf $LOOP_IMG $LOOP_MNT
+mkdir -p $LOOP_MNT
+# 1G image
+$XFS_IO_PROG -f -c "truncate 1073741824" $LOOP_IMG
+$MKFS_XFS_PROG -f $LOOP_IMG >$seqres.full
+# extend by just 8K
+$XFS_IO_PROG -f -c "truncate 1073750016" $LOOP_IMG
+_mount -oloop $LOOP_IMG $LOOP_MNT
+# A known bug shows "XFS_IOC_FSGROWFSDATA xfsctl failed: No space left on
+# device" at here, refer to _fixed_by_kernel_commit above
+$XFS_GROWFS_PROG $LOOP_MNT >$seqres.full
+if [ $? -ne 0 ];then
+	echo "xfs_growfs fails!"
+fi
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 00000000..3b276ca8
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
-- 
2.43.0

