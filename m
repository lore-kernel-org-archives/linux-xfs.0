Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA20D1F03C5;
	Mon, 15 Dec 2025 09:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792245; cv=none; b=dvTgInRfQn+Z2V9Ly716+Kf2swZ2mVJOIe4HB8CGsu/HW2URFWfbe6TCdoKw850FXZvU92peEtyx8EJAOiE2samHieaUO7PFXk4jAYAgBh7qi6vlem/tqgM8vPxuMxpAphYS8ei2BFGeOs6ynD6WtKoqu9kWnLuFWCRXq7aezYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792245; c=relaxed/simple;
	bh=JV3Ukg/cOfkJc/O7qkcqpMewsLXSEwp+wGte3hTimfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Od1u4xZTccDGD9x2hc6AI0BVnUuCwxTjOuht8x+W4RX4K2ycbuU28YkPlhgTqg3hTzhldvDQRE6BJvFmkx4jS03+Nwcpj2Z2J8ZvB3wSA63bjQAUGsBLOS7v/2c91qmIYshTyurefKoC6cgZjnHKCIVZOe16o9MwpmPrHTEsO0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c6DgL3nQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c6DgL3nQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lxCS5/YLv1YbWJXfcxfXkaKMAsvlR+Yrv9zFyB9u6oA=; b=c6DgL3nQRVXUdCBnJ1OSb3NlkC
	+yy6CADdjYyuPD2GGGOPdr7iVH+bMGmdcqtLeIGwsyrIt/80w+RVioAtnHBXd3B18LU56HJWiOVCD
	OmCE23m52+tbAhqsSXPkXd7HhO7IieaUkkdu2yRxX1eC7I9Xs3RhwDw6Ryvqh2m7kBFcDYUfbugfK
	RB098n3Cy9/WAvxWKk7D+X5KPI4izzMa9bg08wmLIJwghVqyQyvEy3ak8HwrBDZzQB1GPSYdPsm9n
	OsrtXEDtkAdF++1+b4jQiN9LNWdlrR+JBiRMFmy6PBJy+RF1p1GdL8rHgaD0OQnkITR+PKLAE0tn3
	ki6qpvbA==;
Received: from [2001:4bb8:2d3:f4f4:dcee:db:50a:ae71] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV5E2-00000003OpD-36zT;
	Mon, 15 Dec 2025 09:50:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: add a test that zoned file systems with rump RTG can't be mounted
Date: Mon, 15 Dec 2025 10:50:27 +0100
Message-ID: <20251215095036.537938-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251215095036.537938-1-hch@lst.de>
References: <20251215095036.537938-1-hch@lst.de>
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
 tests/xfs/651     | 30 ++++++++++++++++++++++++++++++
 tests/xfs/651.out |  2 ++
 2 files changed, 32 insertions(+)
 create mode 100755 tests/xfs/651
 create mode 100644 tests/xfs/651.out

diff --git a/tests/xfs/651 b/tests/xfs/651
new file mode 100755
index 000000000000..1fa9627098f6
--- /dev/null
+++ b/tests/xfs/651
@@ -0,0 +1,30 @@
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
+_require_scratch_nocheck
+
+_scratch_mkfs > /dev/null 2>&1
+blocks=$(_scratch_xfs_db -c 'sb 0' -c 'print rblocks' | awk '{print $3}')
+blocks=$((blocks - 4096))
+_scratch_xfs_db -x -c 'sb 0' -c "write -d rblocks $blocks" > /dev/null 2>&1
+_scratch_xfs_db -x -c 'sb 0' -c "write -d rextents $blocks" > /dev/null 2>&1
+
+if _try_scratch_mount >/dev/null 2>&1; then
+	# for non-zoned file systems this can succeed just fine
+	_require_xfs_scratch_non_zoned
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

