Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9113E2144A1;
	Thu,  8 May 2025 05:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682550; cv=none; b=iDBdvyVjJZhyOn0VzEEp4NtyhDE3TqBNqezOM02S8dfelZqf42sTGc3v/aXr8ExSwFFRdBs23Rugb2AYDCjd/0+/+4DGTnkFjGRC0pR/dCp83xmsVOSDnhcD702s+bCED7x26JXKjI8dIq/rFeWWbZj6OPTaoXSIt2u8TEKJdYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682550; c=relaxed/simple;
	bh=BlEQcFzxy/z7w8CP3dvH+d+ncHRTZJHMAcQUQwy8ffw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ou8/TeqxtcvotzTsrTlF8CIf5TIups48CPWOKQnM6xDb9hwb0Uc+NRv9fN9ly28Cw1WvxCbp8zbn512XDlY/oewveuF/6EIzGWlqd3SVQrRZnLwtYDlQNVVdvEDNCExBZ9KmD7pCrtKIPaRAM2EQ6GfvOUqK4xVzRqU3UpipqU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dfo8gNNm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dfo8gNNm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H+XcG7sp5QYRrcZ9ynLNyRPm2Nx1MXEmkpkLIV3MUdc=; b=dfo8gNNmL/QTrZaKVsLh6enHx0
	DnW0T8cdP/PN4pEdvyquYVsPRzgJwfc8qOwsB6NL/yz1ECIKNYENBbTnMPax5n/WGPxrkuiW+z13P
	egAqimW4lLZ5GrA8SMooDVYuZRxrllKd+a/Xa16oInnSKE4CERkGoTJ+jlpo9XGham6qMXk533PD9
	B480g+7WvAQU/A3yeSHC0g0HUmI/mBbVmuoKJMWwWuWr9N6azdyZX2o1PVx3xfYZ66UaRG9EU8eqd
	SWdSkGyZ/2kIf2dWidlschSFNjXHoYl+FzRA0Q2YIpnb2zJXZK8mgkUYsp4gkv2/k/9DtMU7b/Go9
	g6Cc4gwg==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtvA-0000000HNok-37Y3;
	Thu, 08 May 2025 05:35:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 15/16] xfs: test that truncate does not spuriously return ENOSPC
Date: Thu,  8 May 2025 07:34:44 +0200
Message-ID: <20250508053454.13687-16-hch@lst.de>
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

For zoned file systems, truncate to an offset not aligned to the block
size need to allocate a new block for zeroing the remainder.

Test that this allocation can dip into the reserved pool even when other
threads are waiting for space freed by GC.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4213     | 37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/4213.out |  1 +
 2 files changed, 38 insertions(+)
 create mode 100755 tests/xfs/4213
 create mode 100644 tests/xfs/4213.out

diff --git a/tests/xfs/4213 b/tests/xfs/4213
new file mode 100755
index 000000000000..a99a34a1a220
--- /dev/null
+++ b/tests/xfs/4213
@@ -0,0 +1,37 @@
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

