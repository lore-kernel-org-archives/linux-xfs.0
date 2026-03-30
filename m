Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212463D330E;
	Mon, 30 Mar 2026 13:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774875643; cv=none; b=Nvfxj9PGbwvFFzoH/dAlH3r7EL2VmdMlYSfsUmdKXzth29AmN0fPALgNBFc7nmjTNGol/PsIIXkBfV852So719p3NrIl8URZD061JNejmIdXOVQ7jX6P7HykLcVHxKL4glvOdR5G2FB6pa8CIHRpCnGStm6REpf1xA1tUw2Hz4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774875643; c=relaxed/simple;
	bh=4ZXs+A9pcjMtLPNJwJ07VJXuQvoQXojsPMnzob1DonM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JLkRLhQA1LQz1VfLKSfgh0NmJtAR1qqQ17B8cYiuvdspt16GI5NKYtzE256dHvNjIeVU21w5ctL5xxNzS9Ak4jWIyvns7OJkG+jcrNgdli+hL6n6cQU0PFGgD4hVf0k5gy0JkReupU7YRIT3etLanhixKbISELeyfCUzVTpDKLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gQVBaVmY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gQVBaVmY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=0tEuToDFrQXSm22rDALVDqd92ZOgJz7gXRcVbj4Mjg0=; b=gQVBaVmY02XPlPp243KoxL0650
	qn8PVPOYyDl9AQks+VjLBSkvfuLDzqAKUhFPjlVCRizILWkxfHO2YM59hwShhFp56qTOjUXtJ8/yK
	SDxXKwWAKaYZ52j0koea7swK5kiXOdRvMj74bCvx8tHTry/jfoU71cJCZBXCtlpwL9Qi2JdYxnBs9
	r7HfUB9CX+XDRZx9WSVK1BDNQEh01qP2VQzhPRrBTxNmLmZkEDtK201W2vePiV4jyaHiiRQulm5UM
	76EiaU3jHmso8f2+K1hOoifiN8APSwF1FsYIt8Pp/OrOSPRBnPjY4WXzcEmDo4RIGg5NSEz+3I44Z
	1aVz0tmA==;
Received: from [94.154.173.90] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7CEQ-0000000BItQ-1ONT;
	Mon, 30 Mar 2026 13:00:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: add a test for number of open zones on conventional devices
Date: Mon, 30 Mar 2026 15:00:29 +0200
Message-ID: <20260330130029.3902654-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Test that mounts of zoned file systems on conventional devices don't
create more open zones than allowed when the last blocks in one or more
zones have been invalidated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4201     | 65 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4201.out |  1 +
 2 files changed, 66 insertions(+)
 create mode 100755 tests/xfs/4201
 create mode 100644 tests/xfs/4201.out

diff --git a/tests/xfs/4201 b/tests/xfs/4201
new file mode 100755
index 000000000000..a1f30cb7e739
--- /dev/null
+++ b/tests/xfs/4201
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 4201
+#
+# Test that mounts of zoned file systems on conventional devices don't create
+# more open zones than allowed when the last blocks in one or more zones have
+# been invalidated.
+#
+
+. ./common/preamble
+_begin_fstest auto quick zone
+
+_require_scratch
+_require_odirect
+_require_non_zoned_device $SCRATCH_DEV
+_require_non_zoned_device $SCRATCH_RTDEV
+
+open_zones=5
+blocks=65536
+bsize=4096
+
+zone_size_mib=$((blocks * bsize / 1024 / 1024))
+file_size_mib=$((zone_size_mib / 2))
+nr_files=$((open_zones * 3 - 1))
+
+echo "zone size: $zone_size_mib" >>$seqres.full
+echo "file size: $file_size_mib" >>$seqres.full
+echo "nr files: $nr_files" >>$seqres.full
+
+_scratch_mkfs -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
+	> "$seqres.full" 2>&1
+_scratch_mount -o max_open_zones=${open_zones}
+
+_require_fs_sysfs zoned/nr_open_zones
+
+for i in $(seq 1 $nr_files); do
+	dd if=/dev/zero of=$SCRATCH_MNT/$i bs=1M count=$file_size_mib \
+		 oflag=direct > /dev/null 2>&1
+done
+
+rm $SCRATCH_MNT/4
+rm $SCRATCH_MNT/5
+rm $SCRATCH_MNT/6
+rm $SCRATCH_MNT/7
+
+_scratch_unmount
+_scratch_mount -o max_open_zones=${open_zones}
+
+max_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/max_open_zones)
+nr_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones)
+
+if [ ${max_open} -ne $((open_zones - 1)) ]; then
+	_fail "Test needs adjustments for multiple open GC zones"
+fi
+
+if [ ${nr_open} -gt ${max_open} ]; then
+	_fail "Too many open zones: $nr_open/$max_open"
+fi
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
new file mode 100644
index 000000000000..32e395dd4d6d
--- /dev/null
+++ b/tests/xfs/4201.out
@@ -0,0 +1 @@
+QA output created by 4201
-- 
2.47.3

