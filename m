Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8BC3E5576;
	Tue,  9 Jun 2026 08:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780992062; cv=none; b=nqiaLaHEPk/uT+x5K2bOQ4ZGyNoZh4x4Dp+ZHIM5ubFSa7Gu9ij67+P/yCiVYl/A8wU522wMPkJeXlXk+pUdfs6V8jl7zUrw1vzbfjiAzE1rPrTCNuXnchjrjdGMG26PxS2Ob8DDv0UejYwQmt4uhCWQcuFnUvnWrUN+X1oYPnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780992062; c=relaxed/simple;
	bh=tBacwFS/BczM+sHs9KSU/gyEhz4Qw2HgZPcQn44qgYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnK6Hr009BJ8eNfR0dPWTN2r+4WmNs21BWkemGWubqKPLwe0qEH8bnK2OzrsomHVP958qjRH2YHvfiJXLckNXdXvGg6yJcT1ZzsbDHjwQ51km0NQFUyj6AOpZewBQmWM+yPe0j3uD06bifSoC6lF6/VKqj+tBmOw+uYApUUNAkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eQDsng5R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eQDsng5R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1029TNOsgX61sWwEzzed/mZCzr7LZfpAn8vlfI5rH6E=; b=eQDsng5RZ8XJnXoqyyH8hdfE78
	/DRKpFNIiUfsLghCT2v89OHE1FfAZ+IJyTeD2GKRJa7MWPG2NBiBSJtnHw45dd78QXIzhreKVbdeA
	jAUqUD1EM9953NaDYt2cHitMvMplHzYm5oW5IyyirLMCrJ0YWkTnYevLFzWenFdv63wnI5Menvo5B
	5cHlIjdwCvSoitDebyETYYWvPtw3DHTlkANSk8UJaCH9fm63fctiSFOAQwU3ZoL4EK/AWTOLba1eG
	/TF3UkgZf622yee/vaj7Sh1OCipOuGl352D/h53O8yD7GIFpJmV3Yq57JlkEXlxFnY2doU0xTVkQd
	kxyzho6w==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWrOO-000000051Gy-25k3;
	Tue, 09 Jun 2026 08:01:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: test that a grown RT section can be filled
Date: Tue,  9 Jun 2026 10:00:44 +0200
Message-ID: <20260609080051.1712103-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609080051.1712103-1-hch@lst.de>
References: <20260609080051.1712103-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This reproduces issues with zoned growfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4201     | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4201.out |  3 +++
 2 files changed, 61 insertions(+)
 create mode 100755 tests/xfs/4201
 create mode 100644 tests/xfs/4201.out

diff --git a/tests/xfs/4201 b/tests/xfs/4201
new file mode 100755
index 000000000000..1f1c8e7eb140
--- /dev/null
+++ b/tests/xfs/4201
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 4201
+#
+# Test that the entire device capacity can be used after resizing a realtime
+# device.
+#
+. ./common/preamble
+_begin_fstest auto quick realtime growfs zone
+
+. ./common/filter
+. ./common/zoned
+
+_require_scratch
+_require_external_realtime_device
+
+minrtdevsize=$((5 * 1024 * 1024)) #kB
+rtdevsize=`_get_device_size $SCRATCH_RTDEV`
+if [ $rtdevsize -lt $minrtdevsize ]; then
+	_notrun "SCRATCH_RTDEV device too small, $rtdevsize < $minrtdevsize"
+fi
+
+_scratch_mkfs -r size=1g  >> $seqres.full 2>&1
+rblocks=`_scratch_xfs_get_sb_field rblocks`
+
+_scratch_mount
+_xfs_force_bdev realtime $SCRATCH_MNT
+free_zones_pre=$(_xfs_get_mountstat $SCRATCH_MNT "free zones:")
+
+echo "Growing file system"
+$XFS_GROWFS_PROG $SCRATCH_MNT -R $((2 * rblocks)) >> $seqres.full 2>&1 || \
+	_fail "growfs failed"
+
+# For zoned file systems, check that the growfs did increase the available free
+# zones.  This avoids a hang on unfixed kernels when filling later.
+free_zones_post=$(_xfs_get_mountstat $SCRATCH_MNT "free zones:")
+if _has_fs_sysfs_attr $SCRATCH_DEV "zoned/max_open_zones"; then
+	if [ "$free_zones_pre" == "$free_zones_post" ]; then
+		_fail "growfs did not increase free zones"
+	fi
+fi
+
+echo "Filling grown file system"
+writesize_mb=32
+dd if=/dev/zero of=$SCRATCH_MNT/fill bs=${writesize_mb}M oflag=direct \
+	>> $seqres.full 2>&1
+
+blocksize=$(_get_block_size $SCRATCH_MNT)
+free_blocks=$(stat -f $SCRATCH_MNT -c '%f')
+
+# check that we really mostly filled the file system
+_within_tolerance "free space after fill" \
+	$free_blocks $((writesize_mb * 1024 * 1024 / blocksize)) 100%
+
+status=0
+exit
diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
new file mode 100644
index 000000000000..2e7ac4019f3f
--- /dev/null
+++ b/tests/xfs/4201.out
@@ -0,0 +1,3 @@
+QA output created by 4201
+Growing file system
+Filling grown file system
-- 
2.53.0

