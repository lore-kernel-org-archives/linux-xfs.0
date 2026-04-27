Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3395E30DD2F;
	Mon, 27 Apr 2026 10:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285208; cv=none; b=vF3mVtTzXGI6LA/6Gkf4ouW/7lJmglbl8aygjnsrNigzJPXcqilH/spB4ZM0/0BqghvZpJ9WpACNOrgrbNiXV4mFo4G5zPcyP6iU+whoqlgc1/B7aM4+r7X0LcIEO5G/ncpIhBl7XRoqrUxlgzrjtHyEYqRJa/1crm1cYZGclPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285208; c=relaxed/simple;
	bh=GeCRGUMlxCMoTsQDYMvYEUb+PVYW3F1M11Rsxh3th4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIHDui8r1fS3eQnDPOqaCo9IDRCvnPfCjDYzMhK6Ej10PeT1Vz8wuPGB9zViQGZOBgSvF4mMHTO/2+K2k5+jpGVy4Wnyqd4IjpC/CmcE60Of0tMp3ScDlkcq41gjaUciE3al03Bkf2w4uPKBU/mdK/ZLbKMyKVlAXTzQMta5lsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8OKTJI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8OKTJI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410D5C19425;
	Mon, 27 Apr 2026 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285207;
	bh=GeCRGUMlxCMoTsQDYMvYEUb+PVYW3F1M11Rsxh3th4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8OKTJI1Ypa+yy06CtQ7Q4aonQD58tTTR/esnf59/geJC+AGJOa1SVpj08M5/q903
	 yNgmR5IqCmBO+40PP4fHghmRdnqeCN91CJchWNcjR19sNhlwzXHdIcFKs2o6vZ2NYt
	 pW+/SNOqKyDDic5D7awyvPQ/3+a78JItdhxaKCBJgYaYxw22xHPcJ18Vjl7TaymeWw
	 0q1nNZbjhvCLNn7JIHgmPQ4nI6kGJl8nNyLi8pBK41Kdof/Bt/3IHDce1CckR4pFWr
	 9OqymCyzVMPAAMGcJIFvGBZ9A1oFoDldGMDobcpr9i2AjfQO2ky6tMdvSkU8bOYpvh
	 kdIjPWFuhuuFw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v3 6/9] fstests: verify libblkid resolution of duplicate UUIDs
Date: Mon, 27 Apr 2026 18:19:38 +0800
Message-ID: <e5d0f9f18d9e5f2d1bfa9ab4b747721b13e8d8ba.1777281778.git.asj@kernel.org>
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

Verify how findmnt, df (libblkid) resolve device paths when multiple
block devices share the same FSUUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/803     | 75 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/803.out | 19 +++++++++++
 2 files changed, 94 insertions(+)
 create mode 100644 tests/generic/803
 create mode 100644 tests/generic/803.out

diff --git a/tests/generic/803 b/tests/generic/803
new file mode 100644
index 000000000000..1e0fbc768050
--- /dev/null
+++ b/tests/generic/803
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 803
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
diff --git a/tests/generic/803.out b/tests/generic/803.out
new file mode 100644
index 000000000000..20a1cb36a213
--- /dev/null
+++ b/tests/generic/803.out
@@ -0,0 +1,19 @@
+QA output created by 803
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

