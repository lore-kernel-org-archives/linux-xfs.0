Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C5A27603C;
	Mon, 27 Apr 2026 10:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285212; cv=none; b=gxRkJjkWR7CSTUqTrZK3c6GTFQsTuLGvcRyah43hC2To8f1jAi265wo58uiZntd3qzUGrodZW/GitFCAB9R+ZF+YQQOy8WH8STV52C1umrWW0+6yqqNponGICmjkGlngMcUbZGpw5+7oQ77rw3/tJ3NVCGz81oso72EZwDdbOiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285212; c=relaxed/simple;
	bh=gOGc+LByiUJHyxOpgVlEhWER00jitWEP0oGaVTPapCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLi30CmitLDfq1Rq3r5/e4BHX5MRmi1X0pYf7JBYzjNRc3HUOFFaMxl/Eb4oYn0M3Q8H5pxFO/B8f+bpxv9R3iOljKM5Arx3LTh4vm/ClNvtLRcK5irZdkrAl16zCf6IT0tvHgEUrvlDOmbyx2gSoa/WsEKj+895mKJu5kS2fWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mncN7G43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mncN7G43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B4AC19425;
	Mon, 27 Apr 2026 10:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285212;
	bh=gOGc+LByiUJHyxOpgVlEhWER00jitWEP0oGaVTPapCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mncN7G43qZqtS2m46Ok5MuNxd7XFcyLyXNepdOqhakJT0ZRtF8Ca/K76UlkOpVvU5
	 tZLcusCmBz7Dx86sHAntHwa9pnKhd6u/b/rvrybzbpJrseRA8g4Nd40QmfDiBJhuZ9
	 ma5brsNKxZbpB8KD+Sf7ssHifXoYyqVZHwkfcbQIgWOFrKq3aCeCGHWfm8pK/cq5b0
	 EwOkm5e9lsmhx9nQCrDmttUwcV/4pPaVgxoZuC1hFNAwvfFFzRZOfx9LfFXZMGD3A1
	 6aXtFIV57Mmud/bgAJyXPb18ODaVeuoVpGaZwlb/F3Z5c+r2ll88JrmKBA1N76cKZj
	 qbv0kz40q0ZKw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v3 8/9] fstests: verify exportfs file handles on cloned filesystems
Date: Mon, 27 Apr 2026 18:19:40 +0800
Message-ID: <b089ba5bb0dedf6f8cf1deb61fa0579a1a67c2ea.1777281778.git.asj@kernel.org>
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

Ensure that exportfs can correctly decode file handles on a cloned
filesystem across a mount cycle, by file handles generated on a
cloned device remain valid after mount cycle.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/805     | 72 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/805.out |  2 ++
 2 files changed, 74 insertions(+)
 create mode 100644 tests/generic/805
 create mode 100644 tests/generic/805.out

diff --git a/tests/generic/805 b/tests/generic/805
new file mode 100644
index 000000000000..18c92205304c
--- /dev/null
+++ b/tests/generic/805
@@ -0,0 +1,72 @@
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

