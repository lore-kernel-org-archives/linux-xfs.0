Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB23193062;
	Wed,  7 May 2025 05:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594789; cv=none; b=CinEUtli3dx02dT23KupuxeXthaRA99xc5a9W45oZI/CzQzBwilUkM9ZrRE2tZ8sp6FvReoQ1zjJcxMJXOSO1/7bHEiD66u8BQD8JhW4fYwwBz1yFhnWPHYKQjZ//R7FG/9d39RtdZTaJoK5QKLcpUC7ANYdsfIqn96WA0LOx24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594789; c=relaxed/simple;
	bh=XL4+v7GtjbhuEVkkU0GgwtCfhxhGd3FN7Jx9s8NIv8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l12vn5/ab6lh6GSIbKwz/sxMOaWaVKn5subYWdXBaS9Pdx2kA2qSS3V3PvtGjCkwy9AifN7wQEVeDCgoa+kmo0IuJHzRWt+cc/Su1t9ZyzHaK+xR4k81t5wO+Eit/M0pi1uubQggvjXgURy6PH7rbE5RiIFQMvbNbbzboGBbMUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FDDXK7SU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FDDXK7SU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Xf7m7fE6wR/Sypabp69ED0yxgmXn95QP4qTXM4zTH5c=; b=FDDXK7SUCDmPMV9fXlaYQeKSQh
	xa4jbQ43yXz88YAKV4q7MeB/MnqDa6Tl6QzztOAcByZxJCYxxH9Uf6NotvuWFjXQj5ZNYiVRm18CU
	LbPhTgvvX6nqo7mFvWEMCBkqicD4M6JYTQIukIVntKKQog318t8mVWKWBNeQk8yX5m5LCEOqMyjNJ
	veJc94mbHBhuktEa7lsxrjICuZzE6O99vDtJ52a4ebS6nff+BtY1TrsCc9LkMCmXTs9DakuR7BHDC
	QIfMop7nThTmbGb11ero24Sq2kx0DFmpf+s68/t5mogCSba6fwG/Hxy8bhJgJ47jh8MkhGGOOJAXE
	lWcQT4qA==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5e-0000000EEsB-3fub;
	Wed, 07 May 2025 05:13:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/15] xfs: add test to check for block layer reordering
Date: Wed,  7 May 2025 07:12:25 +0200
Message-ID: <20250507051249.3898395-6-hch@lst.de>
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

Zoned writes using zone append can be easily fragmented when the block
layer or the driver reorders I/O.  Check that a simple sequential
direct write creates a single extent.  This was broken in the kernel
until recently when using the ->commit_rqs interface on devices with
a relatively small max_hw_sectors / max_zone_append_sectors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4203     | 37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/4203.out |  5 +++++
 2 files changed, 42 insertions(+)
 create mode 100755 tests/xfs/4203
 create mode 100644 tests/xfs/4203.out

diff --git a/tests/xfs/4203 b/tests/xfs/4203
new file mode 100755
index 000000000000..9f0280c26fc8
--- /dev/null
+++ b/tests/xfs/4203
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig
+#
+# FS QA Test No. 4203
+#
+# Ensure that direct I/O writes are not pointlessly reordered on zoned
+# devices.
+#
+# This is a regression test for the block layer or drivers reordering
+# writes and thus creating more extents than required.
+#
+. ./common/preamble
+_begin_fstest quick auto rw zone
+
+. ./common/filter
+. ./common/zoned
+
+_require_scratch
+_require_realtime
+
+_scratch_mkfs >/dev/null 2>&1
+
+_scratch_mount
+_require_xfs_scratch_zoned
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+dd if=/dev/zero of=$SCRATCH_MNT/test bs=1M count=16 oflag=direct
+
+echo "Check extent counts"
+extents=$(_count_extents $SCRATCH_MNT/test)
+
+# There should not be more than a single extent when there are
+# no other concurrent writers
+echo "number of extents: $extents"
+
+status=0
diff --git a/tests/xfs/4203.out b/tests/xfs/4203.out
new file mode 100644
index 000000000000..f5aaece908fa
--- /dev/null
+++ b/tests/xfs/4203.out
@@ -0,0 +1,5 @@
+QA output created by 4203
+16+0 records in
+16+0 records out
+Check extent counts
+number of extents: 1
-- 
2.47.2

