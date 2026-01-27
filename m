Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDB535F8AD;
	Tue, 27 Jan 2026 16:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769530153; cv=none; b=eq8mRF238DG0b8weBrL5KN0/QuyIZzg0FNUpQusOEjYuhyaJyVqVgxPcenVdMROUvlmxa2izhzy/1NuqjjqeBKLvXJdfW5RqJY48AzIFhcztgbCzKFlvpLM4HhB5neeV8wQFlCqeDY/fY46D12oz8QGiKzPf07Rwz9GZ/kUOFOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769530153; c=relaxed/simple;
	bh=DGJm/DlAo8k6JBlDUDjJZkMRv/LMhtnCZFfrEn07dqA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DeApMuzdLKY212RNdqfDrupZlT6ZQDuNEv4y/fBFHcd4/bxiz76Vq5TVxCoj8pHrl32+z0g3pVZ+PZF81MY34Vrx2IzbB2Doc+GGa+Oaddbp9PcxDvQVOhXcgJ3xaNAxiPCMjNNgBf2/H4/s46NiMzTMKIz++zy/YUiPINuZsQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sUx3lV6z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sUx3lV6z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZoOQyjVw/MyWXIPvSx+mLcL6v70dPOkdij1IAxVRBfg=; b=sUx3lV6znam1k59LuUr69WjP3k
	Rjc/easX2/zXHyJTrSHdnjF4c8d+G6T1njd6dG8zgA4GZjntFq1mM++lYeLWL4Ju3aR4Zc+E2MXqk
	VgqaLetfOlgUQ792zcspYto26HwbVC9+tQMhb3RKO6r9p7nT81wnqq0M3yhWKobmZPUN6zxBXMohk
	CmfeCtHsUFgW5ckZoK53SC3CVxf4X5KcIjNAe3HSkQ9KNlvNr5vlhDJdCcfMbGsPn+H8Nqlkb4gr2
	oOajn+B9YEvChOI2slCpytwsG/9A4Ss9BVneA1MfXxrWmJhhi2vqz9ni18sihALqXqJYEgRpJ2Rnn
	bnp4U/XA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklcs-0000000Ec90-2wm2;
	Tue, 27 Jan 2026 16:09:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs: test zone reset error handling
Date: Tue, 27 Jan 2026 17:09:06 +0100
Message-ID: <20260127160906.330682-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a test that exercises the zone gc error handling, aka shutting
down the file system or not mounting it using the new error
injection knob and stats.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/842     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/842.out |  2 ++
 2 files changed, 65 insertions(+)
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 000000000000..8f6c13f1b19c
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 842
+#
+# Test that GC defragments sequentially written files.
+#
+. ./common/preamble
+_begin_fstest auto quick mount zone
+
+. ./common/filter
+. ./common/zoned
+
+_require_scratch
+_require_fs_sysfs stats/stats
+
+count_zone_resets() {
+	_get_fs_sysfs_attr $SCRATCH_DEV stats/stats | awk '/zoned/ {print $4}'
+}
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+# figure out how much space we need for 3 zones worth of user data...
+blocksize=`_scratch_xfs_get_sb_field blocksize`
+rgblocks=`_scratch_xfs_get_sb_field rgextents`
+rgsize=$((3 * rgblocks * blocksize))
+echo "blocksize=${blocksize}, rgblocks=${rgblocks}, rgsize=${rgsize}" >>$seqres.full 2>&1
+
+# .. and create a file system with that size
+_scratch_mkfs_sized $rgsize >>$seqres.full 2>&1
+
+SAVED_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o errortag=zone_reset"
+_try_scratch_mount || _notrun "mount option not supported"
+_require_xfs_scratch_zoned
+
+# fill the file system and remove the data again, this should trigger zone
+# resets that will fail due to the error detection
+dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M >/dev/null 2>&1
+sync $SCRATCH_MNT
+rm $SCRATCH_MNT/foo
+sync $SCRATCH_MNT
+sleep 1
+
+touch $SCRATCH_MNT/bar 2>/dev/null && _fail "file system not shutdown"
+
+# unmount the shutdown file system
+_scratch_unmount
+
+# try mounting with error injection still enabled.  This should fail.
+_try_scratch_mount && _fail "file system mounted despite zone reset errors"
+
+# now try without the error injection
+MOUNT_OPTIONS="$SAVED_MOUNT_OPTIONS"
+_scratch_mount
+
+# all three zones should be reset on mount
+nr_resets=$(count_zone_resets)
+echo "zone resets: $nr_resets"
+
+status=0
+exit
diff --git a/tests/xfs/842.out b/tests/xfs/842.out
new file mode 100644
index 000000000000..718805b5766e
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,2 @@
+QA output created by 842
+zone resets: 3
-- 
2.47.3

