Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C754C302753;
	Thu, 28 May 2026 04:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941187; cv=none; b=jU1fWeyoS2+bp6XQ5nzK6Pg7/5PfpgmGdxGyhe9IDkgP1pvXOIePX0F87qionRNV4mPRHo/ZPM+FLtKt6JFdqhRIBNsB0V2MetqV9vNpPo3nzx2+lLw2TMeT6px8sYVOvfKkPzOOVllyUyPazYPGXDi+3KmG2pkme7P9kMNyfYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941187; c=relaxed/simple;
	bh=hLf6zWkDJYLsUx4UOK4L5QzPO2onR26HWz6KYuW53HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmN+uPWNxAOiY64OdmybMlcXUXWGrE+lgCWeYi4iCQqO4Laeh2wjw/qzZXIoTtVtd8CFb0kiIXyPfietXaH1Rs4c75XqJq69WmtiqWOsc/vyxBPWNMPF6NFTL5wMxb+9h5CmMIWZSTdl3nBecRXVNq+CL92bQLTKUEcWAcbUWBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3wDIG89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3wDIG89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECFA1F00A3A;
	Thu, 28 May 2026 04:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941186;
	bh=Y93qz9EZ2B+IYD7ga2KhpSAY8L3hm1RH+zshYysoJKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f3wDIG89iJ2gMobfLifgntqY9aIktq+GOwH8mHNgyQNfyzV57JmMYkgKG6XRmysIg
	 c5Ndszji/sccXvhlrUfVDyUo7snV3OQ1v6/v6hLC0s5pfxhUmRnPK77DzVe3h6TrSG
	 iAjAamXXKTPLd9Ke6yWe9Sga2SXsC/hR8DaHtLx+q9NlVKXfX1IWshkQKP93RHI+88
	 ICqFaWJjALaK2gz6xFxdq/maI+0+ssF1bydXIMekikHMPtY9iM0F+UK7PahIAYuQvI
	 yoxuROvzmdSsjDKL9jey35IsqNqfquyCk61wIz6pU34NAOkuwIzhH6sIiaKSqoGKLc
	 ZbhKdox8wTwlg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 07/11] fstests: verify libblkid resolution of duplicate UUIDs
Date: Thu, 28 May 2026 12:05:38 +0800
Message-ID: <b4d359210f1233c416f70599e5df65a9e3c423ea.1779939330.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779939330.git.asj@kernel.org>
References: <cover.1779939330.git.asj@kernel.org>
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
 tests/generic/803     | 84 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/803.out | 19 ++++++++++
 2 files changed, 103 insertions(+)
 create mode 100644 tests/generic/803
 create mode 100644 tests/generic/803.out

diff --git a/tests/generic/803 b/tests/generic/803
new file mode 100644
index 000000000000..b304a2743604
--- /dev/null
+++ b/tests/generic/803
@@ -0,0 +1,84 @@
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
+# Normalize pool devices and mount points names
+filter_pool()
+{
+	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
+	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
+}
+
+# Collect and print device tracking info from findmnt, /proc/mounts, and df.
+# This checks whether user-space tools get confused or remain accurate when
+# resolving a duplicate/cloned filesystem UUID.
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
+print_info $mnt1
+print_info $mnt2
+
+# Cycle mounts and reverse the initialization order to see if libblkid / findmnt
+# resolution changes based on mount order.
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

