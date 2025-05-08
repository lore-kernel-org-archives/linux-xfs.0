Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1FB8472;
	Thu,  8 May 2025 05:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682519; cv=none; b=AWYgmxtc+i0Vo1GfTHuW8kHfWA8BgkgjfcI47JcxvsJ//HUoTZw0Qzmt7OsTz396TgK7TITJCLor66KrUJbvHtN9mssVJtsCtx4+K5G/XnLqx3nfxf9rEk837AOkgryKovJyI+lda9J3QcUV/j2KkpRkn0tooK4IoOrAnKGCO/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682519; c=relaxed/simple;
	bh=3XQOA9WfShDjrswh/VyxP3prqNFHZI8JAkrsquaKCds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFcB2jXWiaBHZpbt8hal0XVd7hRdAM/jC3Z+fObUxwRE/lFJGxUUY/gtB5+DAjEotJRbn3OVTHpsl8qSD7HpF3vlkVsUhpndZikgK4jS9xUvdJgT4erPPTKEHNbq22xiF4mw4PY3rRlwEGTv+S6U4J0WLcE5JS+k/jZmrV6GjZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q7UpxILm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q7UpxILm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ao+6jloS81qw9+x0oQx9mGTupLKfD/XEHBhPrluSvgA=; b=Q7UpxILm3W//lbGW1mNQv+FQop
	2FyEVQkFwnVB5yHAwz2hEwR2oYhX5Cu5VFCEkm8QgtBubWTftA+um6dfN0xFrEDp2Rx6s/MIhFTvo
	iSG89CcrqNzUuoC/EVjXA+miKcrBtnMnjEt/yClgeLIx6Sg6Y4inz5jTdP95oI8WuCZykVUFuiJ+1
	SJ4P0SOjpoZdQzaEO7S8cOcuiyIywr6OV+IIjQtmHyQiR6axXm9C4eo2maI5CRxv8qy11LkZmrbl6
	PeRrhtkcFrP/OI6j1Uh/0YCTzkjOqaHpab0gR4YmOB7xHIdLB2eETLLhaEuCImpIbUyrBjCxtqU27
	3A2C1byg==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtuf-0000000HNh0-0QHi;
	Thu, 08 May 2025 05:35:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/16] xfs: add a test to check that data growfs fails with internal rt device
Date: Thu,  8 May 2025 07:34:35 +0200
Message-ID: <20250508053454.13687-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508053454.13687-1-hch@lst.de>
References: <20250508053454.13687-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The internal RT device directly follows the data device on the same
block device.  This implies the data device can't be grown, and growfs
should handle this gracefully.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4204     | 24 ++++++++++++++++++++++++
 tests/xfs/4204.out |  3 +++
 2 files changed, 27 insertions(+)
 create mode 100755 tests/xfs/4204
 create mode 100644 tests/xfs/4204.out

diff --git a/tests/xfs/4204 b/tests/xfs/4204
new file mode 100755
index 000000000000..753c414e38a2
--- /dev/null
+++ b/tests/xfs/4204
@@ -0,0 +1,24 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4204
+#
+# Check that trying to grow a data device followed by the internal RT device
+# fails gracefully with EINVAL.
+#
+. ./common/preamble
+_begin_fstest quick auto growfs ioctl zone
+
+_require_scratch
+_require_zoned_device $SCRATCH_DEV
+
+echo "Creating file system"
+_scratch_mkfs_xfs >>$seqres.full 2>&1
+_scratch_mount
+
+echo "Trying to grow file system (should fail)"
+$XFS_GROWFS_PROG -d $SCRATCH_MNT >>$seqres.full 2>&1
+
+status=0
+exit
diff --git a/tests/xfs/4204.out b/tests/xfs/4204.out
new file mode 100644
index 000000000000..b3593cf60d16
--- /dev/null
+++ b/tests/xfs/4204.out
@@ -0,0 +1,3 @@
+QA output created by 4204
+Creating file system
+Trying to grow file system (should fail)
-- 
2.47.2

