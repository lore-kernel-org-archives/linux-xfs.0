Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACE68472;
	Thu,  8 May 2025 05:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682509; cv=none; b=PBZzGrUzD+NARTG+03PE5HGHUFHIxjX8lo55c9FcopAt4pliVRaLRIuOzp5xJDVB3n5851UPOunFPQTPbRQt5h/W8T8KPmxwfzwTAKzyXmXlnxXpQE0MyYRxdCsC70Bq0WEp9zZoU/+ICV8g0mVYScOXF0Ju27nZwMt3kGFC1ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682509; c=relaxed/simple;
	bh=99PmOYdiSTcfIncBSjwOpTtDlPntmLV0bF4C+DJ3cYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPVRX8hhn32ZsW3CDzE9l0Fda3YtSzLQcJ7EpU5h1UjiuBWOvOchAy0qbk5uBDJzJqjiWR+OIYWBEIwSiJOKsiAlY/izTrawGl4SB677ZfBzOg6e2cTy1w/r6TmspT3p3CVNoreb0EwhpKpIk8Zvh6REyZom7gLB6N5+IjbjKms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cVk4Vnfe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cVk4Vnfe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HrepzscOdERHt7eiXYrHhA+ECdTKjIWPGE6bx44lsnc=; b=cVk4Vnfel8u29o6xYcieFstH3t
	7L1RIYx/gZ/DqQA7LzTRD1hCjtpDHgKDFZuQGbrybx/5IX5SENlfgCFrb/qI+/5H+o+6k+5TvREJg
	fgc47Ed5jtGWz/V6YymLwde0v8ZKYdRwlo1Kg39BfrJCCD2u8Zm4gL4r+wSFg7MSrWjj5ff8pQVj5
	qASjBdKwSXbM9DFqryIIe9ZGww083T7jPxxjvYHskrtPw//4m2/gFFK76sP/C30OBDnBA9fk5naGR
	GztgACIBW9vNy7sdXI1iJb/N+pMhU2G66G58FzTF41LD75F+Jyd4a6TYZq4JSqhoufD+1VeF6xM0X
	+nRWXACg==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtuV-0000000HNeB-16jL;
	Thu, 08 May 2025 05:35:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/16] xfs: add a test for zoned block accounting after remount
Date: Thu,  8 May 2025 07:34:32 +0200
Message-ID: <20250508053454.13687-4-hch@lst.de>
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

Test for a problem with an earlier version of the zoned XFS mount code
where freeded blocks in an open zone weren't properly accounted for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4201     | 40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4201.out |  6 ++++++
 2 files changed, 46 insertions(+)
 create mode 100755 tests/xfs/4201
 create mode 100644 tests/xfs/4201.out

diff --git a/tests/xfs/4201 b/tests/xfs/4201
new file mode 100755
index 000000000000..5fc27c4d3593
--- /dev/null
+++ b/tests/xfs/4201
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4201
+#
+# Regression test for mount time accounting of an open zone with freed blocks.
+#
+
+. ./common/preamble
+_begin_fstest auto quick zone
+
+_require_scratch
+_require_odirect
+
+#
+# Create a 256MB file system.  This is picked as the lowest common zone size
+# to ensure both files are placed into the same zone.
+#
+_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mount
+
+dd if=/dev/zero of=$SCRATCH_MNT/test1 oflag=direct conv=fsync bs=1M count=32
+dd if=/dev/zero of=$SCRATCH_MNT/test2 oflag=direct conv=fsync bs=1M count=32
+rm $SCRATCH_MNT/test1
+
+# let delayed inode deactivate do its work
+sleep 1
+df -h $SCRATCH_MNT > $tmp.df.old
+
+_scratch_cycle_mount
+
+echo "Check that df output matches after remount"
+df -h $SCRATCH_MNT > $tmp.df.new
+diff -u $tmp.df.old $tmp.df.new
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
new file mode 100644
index 000000000000..4cff86d90b0f
--- /dev/null
+++ b/tests/xfs/4201.out
@@ -0,0 +1,6 @@
+QA output created by 4201
+32+0 records in
+32+0 records out
+32+0 records in
+32+0 records out
+Check that df output matches after remount
-- 
2.47.2

