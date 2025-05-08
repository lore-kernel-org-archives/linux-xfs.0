Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DA52147EB;
	Thu,  8 May 2025 05:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682547; cv=none; b=n7BOsZWgcZ+AJTWyDb8X5RqvFOGZZX3mBOdoWtYEsidwvVdMItlt4+1T0n5BaCg5U9cdcQrrSsncI3mjz+B4G4w33PBnQcAxruGN6ITDtatgSa4AbL/CsqtuX/W4jO9OIsiODPCd/G2b/fbtQdOfzusjl4xG5L1WYNqp21wNhF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682547; c=relaxed/simple;
	bh=BFI1vNgcSivrzryp2dn4ChvHmG+XzLZ96VSHmN0YOpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZ+tpsKJpT5/oorizZ/SumXqBjcEO5d9UPWbjEM/mJobo1+rLJsSOAC8nkEG+T5+E32R5Z5AaqvSy8WHL19qwkJPXFkHpTcK+Hb6UkK47TTprmdyj8mVU4x0i5ILfxcitykQlXgPHbrSYwbHYPj2tRWkCxh4mE6S6zijOjV3zTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qQ2ixjSt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qQ2ixjSt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hc0Gsz9Xv/aftuicaMhhtjnLn8VxObMYqy13e4G3AD4=; b=qQ2ixjStbFYz+GIqK0q0MMX51v
	UIG1e7NsC9CJtYi771R1fBejjyCFVRjq9uzzCJ6rKrtl04s3YEGjq9+2dboks1pM4dQt32mdlD0qf
	31+C6+SXhCBebTaMI5Jc8EIkfQivMlM9X/uQXFG4ggsWbmv/fewLOylf5mhPwWt4RHgcYFRMqjqPq
	CnpS0V6EETNPCYLUNZa9zqfqhacphh4Y7b2/roPCIVwr+b5RbWqUXL70hhZj0Ms4bcfT0Arf1c/pf
	8dt4MpYLA4M70asrs48IP7hnZhUeXYJNLIrp68BKLSiC7XcBB/zsEbNTgFs9yiIqC+OuLW50emR6j
	bxYhKMBA==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtv7-0000000HNnx-2GYY;
	Thu, 08 May 2025 05:35:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/16] xfs: test that xfs_repair does not mess up the zone used counter
Date: Thu,  8 May 2025 07:34:43 +0200
Message-ID: <20250508053454.13687-15-hch@lst.de>
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

