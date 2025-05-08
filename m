Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5077E8472;
	Thu,  8 May 2025 05:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682515; cv=none; b=MKfjlFCM+9LBBjsbGsRUEPaPFtTXRhVR86vzCks0/6ZNaNpg9FJ+O6RQg6AIUv94vGdlm1dnMIbbaN8zbJo2Hs8dL8wTPTC+UxiGq9HHFkmFfjwkvb4Eme531Qk0ahlpdVikoInqkOyNexqxzoM8/ayIJRJkFcR8jdNYcWMCC+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682515; c=relaxed/simple;
	bh=XL4+v7GtjbhuEVkkU0GgwtCfhxhGd3FN7Jx9s8NIv8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l78oMEeKEfEcwqbeIuDeFljST9vWnLKpcI+tlYWZpa0KiJ2VOo50oxTKBkbHw409LAf9b+fO+Bj7FsriqndzjLj9jJt+pLF6LFak57Soz1+pJu0d7PAziF8XoMCkzMgAvB7C3+MWIsPZIwcZhOOUthfl6WBDprIvApJvei8LG9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1EEwCRBV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1EEwCRBV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Xf7m7fE6wR/Sypabp69ED0yxgmXn95QP4qTXM4zTH5c=; b=1EEwCRBVKHA/zn9IVQeAdN7BoJ
	KjlscqzxDMox/9o0YySorT7dX20N9QZMyglceMgIYmIQZewS/oGnan43EOvfjSnfhnb9f8DzYmY35
	TtBtAGsredYnCSP15F/gMgQYm2SX6ayuB2tzwpzERSlIxqqRWV0fdLWVqHgxkFq1Jl1oSEep2eF2w
	Cyqxah4AjnkKyL7wz6z4gfTq6z/rgqUcE0lKH08lvgQDK1BMoet49q0tHIKWPHH6qrLDlq7EktXIG
	K2jrbjL0yNVd+tZWz3tP+fNWmWrabDBb6n4nxw6FfgLIDfFx3r7AH9lLI5HfjeKJ2JECD1xJb1n7k
	bXpjUZ6g==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtub-0000000HNey-2uMI;
	Thu, 08 May 2025 05:35:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/16] xfs: add test to check for block layer reordering
Date: Thu,  8 May 2025 07:34:34 +0200
Message-ID: <20250508053454.13687-6-hch@lst.de>
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

