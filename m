Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1F534D901;
	Tue, 28 Apr 2026 06:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358609; cv=none; b=JbA9K4dG2PyuK8SogT6oB3zjoeiK5ahUjOTYdsaC3xmq8KFQGyKdvimvcvNa+9a+gZVVracokxmlDIJ5yUymFBDTtLcGvuKlCdOAoz3GtGYuUe5bMbd7+qtEVWshiqH0bH+uCyvwPpaR0BI7KP+1s3WWZCViDGDvgkNfwN1jzGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358609; c=relaxed/simple;
	bh=MU0+wWD5RZ6FgcZ3PtZtBCvGmv1SZt87kcHtgv2OsQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbjllGR3QMTmGRCftjhfr1pJtt5jutRnjNcXLbdOvClhZQqC0n9+CrR3GKihfQ5KdSiToh7LG1GALN9JON6LnDlK/GQ9BB5A8GcXHLUKP/xVe9w6wjteg1F6L+tEC6L8nJqAeWTY03k7ZR23rPoc18fvGX2NSYpqYvNlFJiTieg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PIdcSzJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PIdcSzJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02409C2BCB7;
	Tue, 28 Apr 2026 06:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358609;
	bh=MU0+wWD5RZ6FgcZ3PtZtBCvGmv1SZt87kcHtgv2OsQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIdcSzJa5Go2gNn2MzNLJW1WNXRIC9PJEsKa/mJHX25Gx3wkNrCGrmeZOykMZ3MKw
	 /TMT26Ng3cxlVgTloh0TgHhzYVhS1VQWL9aGs7ANl6TFxibd1kH2vEIxDuT8i5O1Hz
	 0ZRWX8Z3zQc9k0AvCkTArQ71HEKMgPUhEjhJPWDfSt22pNlNFLlIH2iLnqcE5DftCR
	 OK0taxybljbhh5IEFH8kVKB7t3zrZXVeK+BbCt/z43HYc9QqOuuTWeY6q++eaOHuMa
	 LdhCpbgn3cLi9aBmPynYCmbPvSvwEhdXP7Pi/conATZkPTUymlLfBYCUJOywiUASqb
	 sGATI2OIxLXHA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v4 8/9] fstests: verify exportfs file handles on cloned filesystems
Date: Tue, 28 Apr 2026 14:42:58 +0800
Message-ID: <b18811c1a8dedca0c8035dbd4da5b96d6cc456fa.1777357321.git.asj@kernel.org>
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

