Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A2118952C;
	Wed,  7 May 2025 05:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594792; cv=none; b=BL9mBdlFFOmykLniTbGcE7Srhfr/JMfqF86bTirvNgHOxB32ROO/b+mrXKUabbDpSwvgx5A/Jwhp/vxUFA6E7RdBFJ6n9UDM5BN5gUI+tHrsOmw6Hz74M/iF1E/UcBaLLndii7eSaAw/dBEfnYw9o1TLd6fK1Dz1/amxw1jaM6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594792; c=relaxed/simple;
	bh=3XQOA9WfShDjrswh/VyxP3prqNFHZI8JAkrsquaKCds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rp5EomoBMUd111GWCwurdR8RCQzuLDs/Xzw+ciyT7eqy8oKOKmbcDxezUZJCkHpknKkqfONP1EtW+fZU5rZgyCt8/BoZ7Zq7XY1C7mde5ZWze5SGRXj589mYVoVy6fhyNbDSj+2afcPGftlbjJGDHVnb65gGcFpQK6JqzyLR1a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yVDDAJ/e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yVDDAJ/e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ao+6jloS81qw9+x0oQx9mGTupLKfD/XEHBhPrluSvgA=; b=yVDDAJ/eZzhUt4MLXcqyfhT4LC
	x27DDX142MC6fNTAc+Uj3XtnCdVpfJ+C+UggOIaDScSyRp017Nb9zQJdYPxhMY1YNhb4dXxqJW4qu
	scSrZdP8vdn/hxt2gT+6+eV6Qm4kI5EnB5Wc5vX1jsCBkKQz8hXcFY1qxHbswu6XoUTBu+eMw/UI3
	3Keju4X22NaB4mexAr8Ehczq1aZOC7FPHXhlza5Ez0gOKm3kLSS5IQ72v0eioVjQHFYZYzXR3x5wL
	pkTtHCdEefkK5MUPX5qb/d8yesqmbBLzZg8uJakDfuW9UfqkZqCwnK4NvnIkD762I5JJVk6ujEGG7
	fnZHdpEQ==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5i-0000000EEtQ-14WO;
	Wed, 07 May 2025 05:13:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/15] xfs: add a test to check that data growfs fails with internal rt device
Date: Wed,  7 May 2025 07:12:26 +0200
Message-ID: <20250507051249.3898395-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507051249.3898395-1-hch@lst.de>
References: <20250507051249.3898395-1-hch@lst.de>
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

