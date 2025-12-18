Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7773F36A012;
	Thu, 18 Dec 2025 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766074254; cv=none; b=plAvIUAjiEoYboyNvg17k8veZWotPfSLt6hiMVNMbAAE1ctpBd2CBl4p6RbJDUlFsUew+lzdb7RiCKlMwvT4O08O4J7GhYB2MAA2cUZOtwo6ShV2gBbMFJn+JJk2d4/Qgmzwg8HjQ9GRaIZTv6+pPIpDvc7LH63qJqk93T0T+pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766074254; c=relaxed/simple;
	bh=XApwh50BIH9LBJZDz7CT1BdIR3l/ssHWzaE4ziL/44M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tspg+8EdTNoglBrSVBfnl1xG2NCFWrDg0fAbX5VpF4JQpPAt4hfsIHzDjF+qKLcN7jVP260Dcm4GmB8yrBpkdA5ZG98JO4q8PjDBN/32bCKWujoTyIQIsOp+e/ZguxzC2HDOsb9SCvFF2wvhlrDrtRnjQeCp73wvhzr2l5Y4mC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xVrcwNm+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xVrcwNm+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pBZIEEvyiW/xO8pWYMkU4XD+ygjoBTWmczbgmrgo1fY=; b=xVrcwNm+w33TOc50HbIhPWa2Ix
	W0DMAqpNdoBPRqUPoHIVmLh8m0EnKIqb0NvhKtFMPgC/nRLne/g3p7VcW9UmH2X6GyNttGrNG8NIt
	aDO2mcAxs0yMNRVvu1GnJidZ0y8F8D3EMM3fkujNXMLtp9ZGH+ofHLnbJlqX/dtPpfblXa0YiO+ff
	giuIP3YZEQrGSc0A4LYVTFjh2t9PZCzoyLIPmN4pVGz4cW01Hd3M5Knx+CN6MQOuuJ/bnTnC3iUmX
	TcM/5zDzgojX9wXKcNNE1oQpwewVl5lrcSypAgFyh4/mKmKAjfCBMohthR69ggxEw0dIASMsxww4/
	t7AipF7w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWGaZ-00000008n2h-2aF5;
	Thu, 18 Dec 2025 16:10:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: add a test that zoned file systems with rump RTG can't be mounted
Date: Thu, 18 Dec 2025 17:10:16 +0100
Message-ID: <20251218161045.1652741-2-hch@lst.de>
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

Garbage collection assumes all zones contain the full amount of blocks.
Mkfs already ensures this happens, but the kernel mount code did not
verify this.  Instead such a file system would eventually fail scrub.

Add a test to verify the new superblock verifier check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/651     | 33 +++++++++++++++++++++++++++++++++
 tests/xfs/651.out |  2 ++
 2 files changed, 35 insertions(+)
 create mode 100755 tests/xfs/651
 create mode 100644 tests/xfs/651.out

diff --git a/tests/xfs/651 b/tests/xfs/651
new file mode 100755
index 000000000000..1e36fec408ff
--- /dev/null
+++ b/tests/xfs/651
@@ -0,0 +1,33 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Christoph Hellwig.
+#
+# FS QA Test No. 651
+#
+# Test that the sb verifier rejects zoned file system with rump RTGs.
+#
+. ./common/preamble
+_begin_fstest auto quick zone
+
+. ./common/zoned
+
+# we intentionally corrupt the superblock
+_require_scratch_nocheck
+
+_try_scratch_mkfs_xfs -r zoned=1 >> $seqres.full 2>&1 || \
+	_notrun "Can't create zoned file system"
+
+# adjust rblocks/rextents to not be zone aligned
+blocks=$(_scratch_xfs_get_sb_field rblocks)
+blocks=$((blocks - 4096))
+_scratch_xfs_set_sb_field rblocks ${blocks} >> $seqres.full 2>&1
+_scratch_xfs_set_sb_field rextents ${blocks} >> $seqres.full 2>&1
+
+if _try_scratch_mount >/dev/null 2>&1; then
+	echo "Mounted rump RTG file system (bad)"
+fi
+
+echo "Can't mount rump RTG file system (good)"
+
+status=0
+exit
diff --git a/tests/xfs/651.out b/tests/xfs/651.out
new file mode 100644
index 000000000000..5d491b1894ea
--- /dev/null
+++ b/tests/xfs/651.out
@@ -0,0 +1,2 @@
+QA output created by 651
+Can't mount rump RTG file system (good)
-- 
2.47.3

