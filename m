Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8176BFC0;
	Wed,  7 May 2025 05:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594820; cv=none; b=Uv142SLsj0QrSVmF5rItzxnGVJQfXKATBWn9mvzY9YNHekKa1Utww+eYmy3tzvHyrxeeLAih9fp6/PnDfix1mRKbmrvnbLc/jaMXrbJYEDlb4RBmRLa86sX8C57bHzkmv7sm/1hL3EGF1dmbx+77KU9U7girplGy9Zg2phu8XGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594820; c=relaxed/simple;
	bh=BFI1vNgcSivrzryp2dn4ChvHmG+XzLZ96VSHmN0YOpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUNuFqrshQYwX7/y1HZ61MPeRpcoBJcsr5+f+EU+QLnY00OhqStq+VdPgqxoIBGNTzXWveUz5DVfFUpflpzhQG6SnIcajULN5q9nA7hJbxUADbiTeftM7QEJhw9VFSG9aWsMlxRJRjDXUXRR4NmSTUS6808ydeEtI8riEwXjTgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bi/z/283; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bi/z/283"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hc0Gsz9Xv/aftuicaMhhtjnLn8VxObMYqy13e4G3AD4=; b=bi/z/283Fy0XCkVnlGTh764O0T
	Z71iF1KM50u9WF5vdij9xt0OOpF9aziQXHgfnxIynpwOSVWnHkNzqOOESNglXdLZyXR3pbxIza1Sv
	npDA7XAArgzFRIZ48cDKNaxhSzSdVAfHkCOkyS+3hnUUQQmDqDoa4PAf0wzSL0OaLmFxgYOnpC8BF
	bkOvnUnK6EiV1fdoe/fAiA2HbPmPi3zcLutFoVUr/KoYPBaeuuGfBl1DwiXaPxB5DMuEvO7+TuiKk
	0jpQO61T6Zkasp9oIHLvNO8IpxFWjPv2YlX/ogPe0Sj8yq1xvNyMxD0Z2FZNa525HtNya/uy7kQCh
	D9WOKbLg==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX6A-0000000EF4F-0lMS;
	Wed, 07 May 2025 05:13:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/15] xfs: test that xfs_repair does not mess up the zone used counter
Date: Wed,  7 May 2025 07:12:34 +0200
Message-ID: <20250507051249.3898395-15-hch@lst.de>
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

Check that xfs_repair actually rebuilds the used counter after blowing
away the rmap inode and recreating it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4212     | 32 ++++++++++++++++++++++++++++++++
 tests/xfs/4212.out |  5 +++++
 2 files changed, 37 insertions(+)
 create mode 100755 tests/xfs/4212
 create mode 100644 tests/xfs/4212.out

diff --git a/tests/xfs/4212 b/tests/xfs/4212
new file mode 100755
index 000000000000..f392a978c7a6
--- /dev/null
+++ b/tests/xfs/4212
@@ -0,0 +1,32 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4212
+#
+# Regression test for xfs_repair messing up the per-zone used counter.
+#
+
+. ./common/preamble
+_begin_fstest auto quick zone repair
+
+_require_scratch
+_require_odirect
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+dd if=/dev/zero of=$SCRATCH_MNT/test1 oflag=direct bs=1M count=64
+
+_scratch_unmount
+
+echo "Repairing"
+_scratch_xfs_repair 2>> $seqres.full
+
+echo "Removing file after repair"
+_scratch_mount
+rm -f $SCRATCH_MNT/test1
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/4212.out b/tests/xfs/4212.out
new file mode 100644
index 000000000000..70a45a381f2d
--- /dev/null
+++ b/tests/xfs/4212.out
@@ -0,0 +1,5 @@
+QA output created by 4212
+64+0 records in
+64+0 records out
+Repairing
+Removing file after repair
-- 
2.47.2

