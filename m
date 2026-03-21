Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77DC38B7A6;
	Sat, 21 Mar 2026 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094334; cv=none; b=rtFuvrgq3VyEEx0VjFWGEU/qk/YjyA8H8kVLx8uSOaIe17rFHxZ7JnUSRO+ltHekkGtTJE5QsrkImIukNBegWeuywDCj7YGiJTS24dfhuxRTclijdmte2bxpYKR/2KZj8Ddp2ynOoQTgsY/vTuPvN3+saUE6rzsEwwz8n7JlYNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094334; c=relaxed/simple;
	bh=fvDM65WhOxGR5oGE1ktB/lHmh2LQHQxywWt81VzlxOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ar6uL+ey2eiiNK9YqbkDeAqjUzXKDf/uBZaiDdhmwPjLr52XZV/4u34LenO9ngtdDNDPgFiUtvcpdUDfMAxQ2fIZOlubGI+jEAbgNLuGQvZx8EtLTdu9TWtKibMcwdTU4jWezVC6o0EDwNO/8x/hy4pwpFDU0FkbX6s6eqchZ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6F3rzMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6F3rzMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B23CC2BCB2;
	Sat, 21 Mar 2026 11:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094334;
	bh=fvDM65WhOxGR5oGE1ktB/lHmh2LQHQxywWt81VzlxOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6F3rzMNObtR55FWBFV6itJzmz8odKHzWosH6QpWvA7SefJAj+Iyk+doXlmCOh0pN
	 RK/hH2Ewp6CjDCN6uVecjS3Mv75fTxWVW+fmfb7WJqMhtneoSwIFV0w12z6bIcsZ69
	 qsw/iTlKiODQYKpyayM3RvvCX4eErU33jH6bgUKv/YJkwRq7+I0A+KLFJQF02TXoFF
	 f8+IF0DCcgQ/BC1A5B6P4Ip7d1foI4VQkRayzPqfPpr/qyC7e1Rdu7gviKoo1HWG8u
	 RAa7eHF1xlMi6aQaiDDZNpaVDSZ2+EGIeNckhWdSy4p5hGWzJAXpsLVvHDTLXMRmxe
	 MiIlot+txNRdw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v2 7/9] fstests: verify libblkid resolution of duplicate UUIDs
Date: Sat, 21 Mar 2026 19:58:28 +0800
Message-ID: <59fd8eede6a4ff6dd931a6cdec07608f3b435d84.1774090817.git.asj@kernel.org>
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

Verify how findmnt, df (libblkid) resolve device paths when multiple
block devices share the same FSUUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/793     | 76 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/793.out | 19 +++++++++++
 2 files changed, 95 insertions(+)
 create mode 100644 tests/generic/793
 create mode 100644 tests/generic/793.out

diff --git a/tests/generic/793 b/tests/generic/793
new file mode 100644
index 000000000000..fa5d8a6fe642
--- /dev/null
+++ b/tests/generic/793
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 793
+# Verify how libblkid resolve devices when multiple devices sharing the
+# same FSUUID.
+
+. ./common/preamble
+. ./common/filter
+
+_begin_fstest auto quick mount clone
+
+_require_test
+_require_loop
+_require_nouuid_mountopt
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	umount $mnt1 $mnt2 2>/dev/null
+	_loop_image_destroy "${devs[@]}" 2> /dev/null
+}
+
+filter_pool()
+{
+	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
+	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
+}
+
+print_info()
+{
+	local mntpt=$1
+	local tgt=$(findmnt -no SOURCE $mntpt)
+	local fsuuid=$(blkid -s UUID -o value $tgt)
+
+	echo "mntpt=$mntpt tgt=$tgt fsuuid=$fsuuid" >> $seqres.full
+	echo
+	findmnt -o SOURCE,TARGET,UUID "$tgt" | tail -n +2 | \
+				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
+	awk -v dev="$tgt" '$1 == dev { print $1, $2 }' /proc/self/mounts | \
+								filter_pool
+	df --all --output=source,target "$tgt" | tail -n +2 | filter_pool
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
+print_info $mnt1
+print_info $mnt2
+
+echo
+echo "**** mount cycle ****"
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+print_info $mnt1
+print_info $mnt2
+
+status=0
+exit
diff --git a/tests/generic/793.out b/tests/generic/793.out
new file mode 100644
index 000000000000..53cb4d850d93
--- /dev/null
+++ b/tests/generic/793.out
@@ -0,0 +1,19 @@
+QA output created by 793
+
+DEV1 MNT1 FSUUID
+DEV1 MNT1
+DEV1 MNT1
+
+DEV2 MNT2 FSUUID
+DEV2 MNT2
+DEV2 MNT2
+
+**** mount cycle ****
+
+DEV1 MNT1 FSUUID
+DEV1 MNT1
+DEV1 MNT1
+
+DEV2 MNT2 FSUUID
+DEV2 MNT2
+DEV2 MNT2
-- 
2.43.0

