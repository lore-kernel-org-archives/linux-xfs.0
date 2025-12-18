Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AA236A01B;
	Thu, 18 Dec 2025 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766074260; cv=none; b=BXvzipfkhmA0zd5Q1+WQE5DXzHY4ANPbpvJ1VY1fwv+y1Gzwl1A9/u+tc6qc9QJUjc6EezR3ymHv0B8wQvVMVp0MxpueYJVwlK6sT1NouUNHAqMP1rZeU909+BVuVo8jQVXKh8mUkyXngiG627yHHNOjmKpOAcdZbgmNe2B/v8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766074260; c=relaxed/simple;
	bh=sCTGmkKSyIupDvPCz2f7hdgqTrjmbjH2kQWlfv/6MFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyeCEzCSrssTmT/BiefiNwSd381E2SZOgJ8ejgxd5kU6yI8pX9SLyLPt+naYJyqwB0z6UU0R681HF0qRRHEkrRGlmDMLScndbDgHaODev716kKh1kWpjuUfXxTrtNFK7onYbZnAH2M6yS2Tn+xAnC2ylyfvx3rvpRX3Jo2nTzSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zg8fVJ6a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zg8fVJ6a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0sWYCVrIvjccUFSdy5j1fhUVGmTxKDDS9ScSM6qDwlA=; b=zg8fVJ6a9s2R0ZBBM/qOie7mVh
	spKTQvsav4jcbWRcuVPm0XgN9M7ZMZfOu3gIis13VrMFs43hjAsd4yhYh267yxGYYGSWtgR4XTRaF
	fkOOddeV9wHS1X2x5nTTP/aysOJP6drysvcoCCV8yBYrjeevauchxDUzy/kllGvbU3uEWX2vyCsmh
	N0H2BQf/BnPJ7SICiVtCHJPLpIK3b8nWpjksCeObIzl2HABIpHmT4biq2heSJf57dPOPnACrnXVki
	VItuORhq3/eMUuuX+Qvrhol2Uh/OLE1aLC1oyKAHQs8wtyjCWnxwGr+UhGw6YLvjSHlcQ3WLk6kD8
	ggb2ZP0A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWGag-00000008n4H-34aH;
	Thu, 18 Dec 2025 16:10:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: test that mkfs creates zone-aligned RT devices
Date: Thu, 18 Dec 2025 17:10:18 +0100
Message-ID: <20251218161045.1652741-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218161045.1652741-1-hch@lst.de>
References: <20251218161045.1652741-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Make sure mkfs doesn't create unmountable file systems and instead rounds
down the RT subvolume size to a multiple of the zone size.

Two passes: one with a device that is not aligned, and one for an
explicitly specified unaligned RT device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/653     | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/653.out |  3 +++
 2 files changed, 69 insertions(+)
 create mode 100755 tests/xfs/653
 create mode 100644 tests/xfs/653.out

diff --git a/tests/xfs/653 b/tests/xfs/653
new file mode 100755
index 000000000000..12d606c436f0
--- /dev/null
+++ b/tests/xfs/653
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2025 Christoph Hellwig.
+#
+# FS QA Test No. 653
+#
+# Tests that mkfs for a zoned file system rounds realtime subvolume sizes up to
+# the zone size to create mountable file systems.
+#
+. ./common/preamble
+_begin_fstest auto quick realtime growfs zone
+
+. ./common/filter
+. ./common/zoned
+
+_cleanup()
+{
+	_unmount $LOOP_MNT 2>/dev/null
+	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
+	rm -rf $LOOP_IMG $LOOP_MNT
+	cd /
+	rm -f $tmp.*
+}
+
+_require_test
+_require_loop
+_require_xfs_io_command "truncate"
+
+fsbsize=4096
+aligned_size=$((3 * 1024 * 1024 * 1024))
+unaligned_size=$((2 * 1024 * 1024 * 1024 + fsbsize * 13))
+
+_require_fs_space $TEST_DIR $((aligned_size / 1024))
+
+LOOP_IMG=$TEST_DIR/$seq.dev
+LOOP_MNT=$TEST_DIR/$seq.mnt
+rm -rf $LOOP_IMG $LOOP_MNT
+mkdir -p $LOOP_MNT
+
+# try to create an unaligned RT volume by manually specifying the RT device size
+$XFS_IO_PROG -f -c "truncate ${aligned_size}" $LOOP_IMG
+loop_dev=$(_create_loop_device $LOOP_IMG)
+
+echo "Formatting file system (unaligned specified size)"
+_try_mkfs_dev -b size=4k -r zoned=1,size=$((unaligned_size / fsbsize))b $loop_dev \
+		>> $seqres.full 2>&1 ||\
+	_notrun "cannot mkfs zoned filesystem"
+_mount $loop_dev $LOOP_MNT
+umount $LOOP_MNT
+_destroy_loop_device $loop_dev
+rm -rf $LOOP_IMG
+
+# try to create an unaligned RT volume on on an oddly sized device
+$XFS_IO_PROG -f -c "truncate ${unaligned_size}" $LOOP_IMG
+loop_dev=$(_create_loop_device $LOOP_IMG)
+
+echo "Formatting file system (unaligned device)"
+_try_mkfs_dev -b size=4k -r zoned=1 $loop_dev \
+		>> $seqres.full 2>&1 ||\
+	_notrun "cannot mkfs zoned filesystem"
+_mount $loop_dev $LOOP_MNT
+umount $LOOP_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/653.out b/tests/xfs/653.out
new file mode 100644
index 000000000000..96158d93f55c
--- /dev/null
+++ b/tests/xfs/653.out
@@ -0,0 +1,3 @@
+QA output created by 653
+Formatting file system (unaligned specified size)
+Formatting file system (unaligned device)
-- 
2.47.3

