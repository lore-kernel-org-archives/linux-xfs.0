Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F781C860F;
	Thu,  1 May 2025 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106996; cv=none; b=edzZnJXwEi+oHywMGrBnE2msfv6WWGntPtET/OqyiD+v8F2OLuk3tvF0JcXsYjjYWpDNGMMbHBKvuXdOy/rNpE6oSP+B78Ol2HEduNMu4Eo5t2sXmpM80IWmkEtdLQxEmjBUuvqfOjSpR7W55hgEuheynOS6wr8aPsygT+yGQHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106996; c=relaxed/simple;
	bh=iGEb6yLb2Dvltnkl0d+28VeJci7L8lH7yd1QME3nggQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDdd7X+eD+F+p62RWc87HoXUdltlWA4rRTS3p7wOs/F+XaLqYpoidG+n5sD8V8IeodMnBz91QhJdDiEXSCgPMelCB1k/e7E9jOSuYXO4sDov/guZWI6L3HJiyh6ebpcXc3SqijKqn0c1cNMawQPMROxSYRv4iEh/qIhRU1NLdb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qcAmTRmw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qcAmTRmw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5YR7cjho7EfEwULglvztJNNQmdvE7ebQcr9f3JHWj7E=; b=qcAmTRmwpOAlNwZjBdlRamZE/n
	vjjdnFCgE2r8nzH4laYrlkwfEiQbHDjWvuilOdc/Ry8OGBI9UaR8yYWh4lbckYRs+HzW9hnwewnFq
	rrPlpyvEkgmU8AvZFIRbHLUn/1bLR96SZKugdgSdz0DVQLhcLadfAjH4UBAvxwQqFd772+maXM076
	SVKdD9g0mcQOwpj6rgqmK6zQw0ewQklHFSzNCpAa6QBoVnkXqJYo5pHa8D+9jR0v23jgV+uIZiQLH
	lGlwML5FfJmdMatJcOTSiv+RPb5Au8XJauKQzVDPWXtrAWjQlXDlUwjmN+y1FXhaBrkj29QM2wm5F
	tT/dFEYQ==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUC2-0000000FrTf-1Z3S;
	Thu, 01 May 2025 13:43:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/15] xfs: test that truncate does not spuriously return ENOSPC
Date: Thu,  1 May 2025 08:42:51 -0500
Message-ID: <20250501134302.2881773-15-hch@lst.de>
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

For zoned file systems, truncate to an offset not aligned to the block
size need to allocate a new block for zeroing the remainder.

Test that this allocation can dip into the reserved pool even when other
threads are waiting for space freed by GC.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4213     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4213.out |  1 +
 2 files changed, 46 insertions(+)
 create mode 100755 tests/xfs/4213
 create mode 100644 tests/xfs/4213.out

diff --git a/tests/xfs/4213 b/tests/xfs/4213
new file mode 100755
index 000000000000..1509307d39d0
--- /dev/null
+++ b/tests/xfs/4213
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4213
+#
+# Ensure that a truncate that needs to zero the EOFblock doesn't get ENOSPC
+# when another thread is waiting for space to become available through GC.
+#
+. ./common/preamble
+_begin_fstest auto rw zone
+
+_cleanup()
+{
+	cd /
+	_scratch_unmount >/dev/null 2>&1
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/zoned
+
+_require_scratch
+
+_scratch_mkfs_sized $((256 * 1024 * 1024))  >>$seqres.full 2>&1
+_scratch_mount
+_require_xfs_scratch_zoned
+
+for i in `seq 1 20`; do
+	# fill up all user capacity
+	PUNCH_FILE=$SCRATCH_MNT/punch.$i
+	TEST_FILE=$SCRATCH_MNT/file.$i
+
+	dd if=/dev/zero of=$PUNCH_FILE bs=1M count=128 conv=fdatasync \
+		>> $seqres.full 2>&1
+
+	dd if=/dev/zero of=$TEST_FILE bs=4k >> $seqres.full 2>&1 &
+	# truncate to a value not rounded to the block size
+	$XFS_IO_PROG -c "truncate 3275" $PUNCH_FILE
+	sync $SCRATCH_MNT
+	rm -f $TEST_FILE
+done
+
+status=0
+exit
diff --git a/tests/xfs/4213.out b/tests/xfs/4213.out
new file mode 100644
index 000000000000..acf8716f9e13
--- /dev/null
+++ b/tests/xfs/4213.out
@@ -0,0 +1 @@
+QA output created by 4213
-- 
2.47.2

