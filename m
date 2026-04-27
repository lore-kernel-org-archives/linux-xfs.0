Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5598D3B52EF;
	Mon, 27 Apr 2026 10:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285214; cv=none; b=Pk29X49VrmbpUk7Et9vKmYtJOq2Ii9kWe7Msi75VvnoPf3DlenPovNZAHEskS9iFDi7qSVA6TDlcdSaSnC9m+nGiMOQ9QI26WyKFz8GT8g7QIrZOaCPBjhO5D5NtKSoa3G3+CEkN1FfVz23bIGL2hp9JGuJHLvpI5lb4BBkPQ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285214; c=relaxed/simple;
	bh=+I4Av7ppRNVv1NUfWD+fNWXpFrT7K2fec1Lb09meN10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2q2UrLpceEwGju7Wfed3609lIZZaiuEMnZmqIt7bG6uL/ZZoYT4/G7xJNIZ+nfAZ+eAMOMBuW++PaFWwAF233MzILRHafGq30EaUCtNB0yW7inEMb5kH/+K3KiY/j9Krny+V4u7LwJbKfi6jl4wJuMXVY1D8jYINzgsG/7ehqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+tgfaMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+tgfaMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641B7C2BCB8;
	Mon, 27 Apr 2026 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285214;
	bh=+I4Av7ppRNVv1NUfWD+fNWXpFrT7K2fec1Lb09meN10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+tgfaMxHeOTM0wASqTJSHXn8E4E8qLwUFWsVsQmT1bkJCamcaR9ZYOCw+y2mdm/Y
	 UyMsOgNAjbbQZyfZ9/4tV5xLPrH/amBm0r/m2LJrNTRJlR//C8M+vFhUdAjzhRr/YW
	 GBZbSOKtxKC8kNwRuOFE+doFyjGUOrvQ9gv/fu9AWGSR8pigk2MDxtmGWqcvTM9Bk9
	 TBxrmKO1scHjE1ILspIEOeU/6Dg5q3II+rCCqy78BBVNVaLk2BCQ1C9SECi4SFZN1W
	 xI477PzXKW8G4CnIb4V/oYMOP1UFScBoZu5TeXA0SF5BXtxOsV36YDTELIvEE3vHre
	 +DFlRnaxcRD3Q==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v3 9/9] fstests: btrfs: test UUID consistency for clones with metadata_uuid
Date: Mon, 27 Apr 2026 18:19:41 +0800
Message-ID: <8751efbeb7edd81e56e2b60886ae00e47f26fdfd.1777281778.git.asj@kernel.org>
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

Btrfs uses the metadata_uuid superblock feature to change the on-disk UUID
without rewriting every block header. This patch adds a sanity check to
ensure UUID consistency when a filesystem with metadata_uuid enabled is
cloned.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/btrfs/348     | 91 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/348.out | 19 ++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 tests/btrfs/348
 create mode 100644 tests/btrfs/348.out

diff --git a/tests/btrfs/348 b/tests/btrfs/348
new file mode 100644
index 000000000000..cfa56fdb4a4a
--- /dev/null
+++ b/tests/btrfs/348
@@ -0,0 +1,91 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 348
+#
+# Verify that the cloned filesystem UUID remains consistent, even when the
+# `metadata_uuid` feature is enabled.
+#
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
+pre_clone_tune()
+{
+	local temp_mnt=$TEST_DIR/${seq}_mnt
+
+	_require_command "$BTRFS_TUNE_PROG" btrfstune
+	mkdir -p $temp_mnt
+	_mount ${devs[0]} $temp_mnt
+	$BTRFS_UTIL_PROG subvolume create $temp_mnt/sv1 &> /dev/null
+	_unmount $temp_mnt
+	rm -r -f $temp_mnt
+
+	$BTRFS_TUNE_PROG -m ${devs[0]}
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
+_loop_image_create_clone devs pre_clone_tune
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
diff --git a/tests/btrfs/348.out b/tests/btrfs/348.out
new file mode 100644
index 000000000000..4b102e986246
--- /dev/null
+++ b/tests/btrfs/348.out
@@ -0,0 +1,19 @@
+QA output created by 348
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

