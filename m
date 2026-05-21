Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DBA3002B9;
	Thu, 21 May 2026 13:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368433; cv=none; b=mMWR1nBj6JIG5s6ixF6MwrYy44BSj5Xyz5dCSTpcJDMS1OkFQUe13NKcxr2YDb7rKYndmbGPgFbTnvtASnJJPG6tEnih0OzHksBL7N9vS7cfCHDbn6WdpAkxZk1c/dxLb6hVDa2rHYf2/nYZ7rgZpTStwQU6zmbb8UZFs2GrwWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368433; c=relaxed/simple;
	bh=1VCsZaLychwUjTglK1LHCohKrYf0PRh0fttrUlRLgl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvRhoAgNZNWRT6OE86MOndR5eW++TZ9aHPzooErjB6gdY7J2yZQtYWKaFR1+xzfMFCYspZjjbiMoeAPySgDFbQfSxCeYRMYZYYkMITX8pK5+Z+3v/0aUc+wpWAL4OIbV1qjeMtxpWTEm1hz2thVS6xHQui0jchj9BBixbGMB00k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAudp9xc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAudp9xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646511F000E9;
	Thu, 21 May 2026 13:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368432;
	bh=Ax/dGJtO4dF0ujS9+MmMMmiTMEYEC52lNLY+OgLI0KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAudp9xcaQNYPTs+H/K2kO1qOBFxow4Ur64XTu4/QRxEybYZUj4Y03Mux90wabKhB
	 QQXzvGlTfHrlbXUkJ5hUtFILa5YjrSZ0zkbxUWV0BKiTW/sRwkqS96Mu/lADWFSsc1
	 br3fuI0zn+KaXlA2Pr04SpYMh3kZkOmPl1o06MHxGBt0dDyVv+emRqSXTAcr1p5KcG
	 t8T/QOd5n+n/aRufdf2Bk6joMtibBEwSrwj5SkMOohNdaxxxtuwc4bVf4H8+pgid5X
	 MjMx3W0msdSbGnAtaHHmgzqcsFMdcaMbolU5UoJVGkecqGmFly4asuuIpx+l63XwuG
	 r4CrhGYhZfF3A==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v5 06/10] fstests: verify libblkid resolution of duplicate UUIDs
Date: Thu, 21 May 2026 20:54:56 +0800
Message-ID: <2aa3b0750b0db982e7e150ed915271c00deeabbd.1779367627.git.asj@kernel.org>
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

