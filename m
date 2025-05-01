Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F111B85FD;
	Thu,  1 May 2025 13:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106987; cv=none; b=vEXh6HQgrIwKSe1YenHyuJoigSuUPpw52LTLsszVYZP28+ZMBnZwkJMCGrJMMDZ/Ajj+qiy/p1tatXRD0YwOPxJ/1aScHsUEpGME87wAFQcN85BCSM+lYPkwftL29ZQLr9pwQ/lg65iyIotzTkx2Lw/r7pxmfRQTdF/y+XbRT6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106987; c=relaxed/simple;
	bh=45em4ck0mRVZ0bSVQnIUbFcs53cDPY3ZSUvNmXk2tl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyJFLAgH2av+Qt0gHesMIwfN9oPXNTEGcOcZi+kV9uBiFaM6VVgb6qlpdRzgz5erauuiFodSImUwXdvYfcyAAR/wWpSWwBgsA5i1EkNRMInIwFsAVsD0DV3qPhbbpukwxf4UydqEbPv+sFFlbV90r8gtd2lDroHuTty0krVyVYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y0UOKA/p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y0UOKA/p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZFG45WqDj1eaGRZDxMN7MQxw9yUlFiQjrvX0vo8Fc28=; b=Y0UOKA/ppM2jf6WtzmndK3LfoF
	h1KavVnUn1xlalSbZkGGNiP5cvW9BqXcA5EnIz0Udcdari3OCthFR+r4sTRIK3WV0WGWupUbYUGgk
	JMgE1/850lFwhyo+Iu5qYJTQSCLh5/1Fi5fJRLZaxI1skCxTCmHXIClYUcV9Co2mmWtvzy1deeN/D
	qRgYWy0fO7Hkng6v6A1S5Z3JWckHTTgbIkCuNqbd0nLecnMnRKSrgDYckqp/kJdzjx9TBqlg1bB6Q
	DRRFNZ34tKLP2uOf0XXsuR7mk0oupoCinkcHYiwZ/aSIP7anJ9s4MM0+lZ2qyW2ClxNI7yiEyPrbJ
	Lbfrv4iQ==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUBt-0000000FrPb-1JSp;
	Thu, 01 May 2025 13:43:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/15] xfs: add test to check for block layer reordering
Date: Thu,  1 May 2025 08:42:40 -0500
Message-ID: <20250501134302.2881773-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501134302.2881773-1-hch@lst.de>
References: <20250501134302.2881773-1-hch@lst.de>
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

