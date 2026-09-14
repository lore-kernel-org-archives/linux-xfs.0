Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C43544213B;
	Mon, 14 Sep 2026 11:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385804; cv=none; b=mOiyrlWnl2nF3pbEwHGR3/hZfb8A9BVRaa2M/9bvkxA2tM4scv3hBk+qKC9zNZUM4pUIEzIkrcuRIAbg+Koqvq2dPEZa+DP9Ija+LTn0L/3t2hnumZj/PwspR8XwP8MyNpcLI/ztkHv+hob9L7Isn/X8zeWYDfZH5fJb9LQNS8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385804; c=relaxed/simple;
	bh=BYX9RatzEXcjhLUODV1SuX/RWcsLp+cwkSph+mhlgeU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eHdfUXDwb/8wx7S32UrlftO+jBTrqo6G+6+k0VIBCD7FTTH89JBvFsGQ+dyTjSXGoE0wAkau43+e200/ovdCfI96l1AwKumr8pHcfXfwtSGRCHzr/8D1koz19mq6uhatPcaY2wHXA9Fi5yca1CPcaWVmnFMmKdev274cc2iPLfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V+s4FVte; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V+s4FVte"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=NFuhnY2cskgxshgdlPfOduixuPwErBY8jlBhkHDZ0dc=; b=V+s4FVteBhlnBssem9mAwbZh3u
	FvpowGCRmWCYoH+DOw97+jDWj8ARs3bPAieNnF9+KayAfJKDjSkQDBoNL0jANaRYUUnpTD77achlr
	z5Embb8+ay1Y8FSoqkuEMBdYhp1D/RfTAc+hf3BjPboSrHMhBX2o+R49t1yePrKnjXzxPax15z22f
	Tshl3oPgLfO5KV26g/7kHgAeL6LwRwt1fboSqilt7Khm3lu/CnMTU8VsKULYQVAJtL4SrLpomhxUj
	xCTbJ255g8UmcemUva2xI4dxnIKM2VzLfJkf8QqYW0ymbcfc8ZNuKE+ry3898Zs9bmsZ7Cweg3bQn
	bS+P1ofA==;
Received: from [195.12.231.4] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x64zF-00000003Hfo-3C0O;
	Mon, 14 Sep 2026 11:36:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: test libxfs handling of missing RT devices
Date: Mon, 14 Sep 2026 13:36:34 +0200
Message-ID: <20260914113634.2448723-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Test that libxfs rejects initializing a file systems unless in debugger
mode by running xfs_repair and xfs_db with missing arguments.  For
db additionally test that command that require a RT device still do not
work even after libxfs can be initialized using a missing RT device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2300     | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2300.out | 14 ++++++++++++++
 2 files changed, 62 insertions(+)
 create mode 100755 tests/xfs/2300
 create mode 100644 tests/xfs/2300.out

diff --git a/tests/xfs/2300 b/tests/xfs/2300
new file mode 100755
index 000000000000..70c1d6bad9cc
--- /dev/null
+++ b/tests/xfs/2300
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 2300
+#
+# Tests that repair refuses to work without -r argument, and xfs_db works fine
+# even without it to check libxfs initialization behavior with missing RT
+# devices.
+#
+. ./common/preamble
+_begin_fstest auto quick repair db
+
+. ./common/filter
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
+_require_scratch_nocheck
+_require_realtime
+
+if [ -z "$SCRATCH_RTDEV" ]; then
+	_notrun "external RT device required"
+fi
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+echo "Dumping superblock using xfs_db without rtdev"
+$XFS_DB_PROG $SCRATCH_DEV -c 'sb 0' -c 'p' >> $seqres.full
+
+echo "Loading RT superblock using xfs_db without rtdev, should fail"
+$XFS_DB_PROG $SCRATCH_DEV -c 'rtsb'
+
+echo "Running xfs_repair -n without rt device, should fail"
+$XFS_REPAIR_PROG -n $SCRATCH_DEV
+
+echo "Running xfs_repair without rt device, should fail"
+$XFS_REPAIR_PROG $SCRATCH_DEV
+
+
+status=0
+exit
diff --git a/tests/xfs/2300.out b/tests/xfs/2300.out
new file mode 100644
index 000000000000..50aab2b83ec9
--- /dev/null
+++ b/tests/xfs/2300.out
@@ -0,0 +1,14 @@
+QA output created by 2300
+Dumping superblock using xfs_db without rtdev
+Loading RT superblock using xfs_db without rtdev, should fail
+realtime device not loaded, use -R.
+Running xfs_repair -n without rt device, should fail
+Phase 1 - find and verify superblock...
+xfs_repair: filesystem has a realtime subvolume
+xfs_repair: realtime device init failed
+xfs_repair: cannot repair this filesystem.  Sorry.
+Running xfs_repair without rt device, should fail
+Phase 1 - find and verify superblock...
+xfs_repair: filesystem has a realtime subvolume
+xfs_repair: realtime device init failed
+xfs_repair: cannot repair this filesystem.  Sorry.
-- 
2.53.0

