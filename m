Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A383134D4D6;
	Tue, 28 Apr 2026 06:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358605; cv=none; b=e9dZtA4h5QLZuV0QJtJHbgmruSjK+6KKnoerqjs7YqpDKo/9CWz3c8J6iUAsF4p+DJareh4UQ5iNW9v11stQ2bbs4glNzQadiF/O+3a7N/75GYZrjr6eUJSTz64xd4akCsKXec84FqBOTWR7b8JHGibSqXnoXPp+ATobHwUkjhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358605; c=relaxed/simple;
	bh=1VCsZaLychwUjTglK1LHCohKrYf0PRh0fttrUlRLgl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/DvsH7zw/b7YS7ZIHSVX+ppn43ivLifn04kzioAccZIZW7r8oHzxiFdP8nDAQjRRpzi2DAosvQAygBlR4O1IQegg5kjI4KS/vmk2FBYXyNfJj29w0ciDOJRBA4A2ZfJh+7rtnM/hnvwerBDNxHsCpmuOmJgktbLwD0IpIffFVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCnd799q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCnd799q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0996C2BCAF;
	Tue, 28 Apr 2026 06:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358605;
	bh=1VCsZaLychwUjTglK1LHCohKrYf0PRh0fttrUlRLgl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCnd799qxvNbq3q0F0JEBDk5WK7Z+6MDiM8AF9EwoWTNGc6WBFqVmU+MomA+xmQqo
	 6W6kd6yaG70KHAnMMNHY6lmg6cHuvKE+G0EtmZAGOR9CUhqAn9SbsA31YzcP5cCk1p
	 S8uKg2ARZalZDlmkZO2T2ouhcmeyp5SLypuZ7qXWge7lXr//gWBcnaAaAgs5R/0x33
	 M5wS98KVltpKSaIaE9WlsGlTxr6Hyi2+mycx6l25DeeqOcXjKNeGRIdNd3Tw+M2EA8
	 w2aTUTXdJQPLaPUiz4TGuQc7l1dlVPpc2F8bj59tHPAjlvVVcI4Nyml+z4f/vRtQ8T
	 JqhutziKb6sAQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v4 6/9] fstests: verify libblkid resolution of duplicate UUIDs
Date: Tue, 28 Apr 2026 14:42:56 +0800
Message-ID: <ebe532776d060ac2d8233ca466c96ae9e25efd9c.1777357321.git.asj@kernel.org>
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

Verify how findmnt, df (libblkid) resolve device paths when multiple
block devices share the same FSUUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/803     | 76 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/803.out | 19 +++++++++++
 2 files changed, 95 insertions(+)
 create mode 100644 tests/generic/803
 create mode 100644 tests/generic/803.out

diff --git a/tests/generic/803 b/tests/generic/803
new file mode 100644
index 000000000000..36de7887065e
--- /dev/null
+++ b/tests/generic/803
@@ -0,0 +1,76 @@
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

