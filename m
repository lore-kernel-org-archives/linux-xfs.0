Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6E51D95B3;
	Thu,  1 May 2025 13:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106992; cv=none; b=HXVAeFpuIhMr6W6iDZGkOszDFjkfmlOzJqYdazpRQ6JifU0qxu7y4HTsRGGjloaf/34hWzr+n9s1hIPiPgN94kxMW1X+IBBYlB1kkVGe8tM1QXEKvAcQamGfJStq5Xnu/HR3zvt75NL4StyMeDAplNOrqISUB4UbnMXZkl2Gj+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106992; c=relaxed/simple;
	bh=Zm44YVKUgGL5L6Erq6/I4cKdECNWNRMb1AKSYanUbsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkjww31Y+27FRyxGIpLNXj1L091RIIcn6tqEVdRaeMECphEd1iFtvYI5ubcJlYbPbJ4d2Fb/DK1kwjpzuNJxkcchjd/g6JsyX12LiPC1ulaw2Jzdc5A1fiLSkFuvBFwcbC0RBJry0CQHhyNFfoV1rulHEss7yDW0mHV69+yI+8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EajS/StX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EajS/StX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3H4Fp9HE9OHWuOnGdiVw+Tyl8/NQbBo+mUtSCdWRicg=; b=EajS/StXQxEDa76fRiB/Wp8GGZ
	mPc+y5GSd8X5B8SLWlyp0SecTjBH+pWjWTfF7WS4I8hy3DQHTJ+U+T6W+7Ol/SOta4fQHclP1aU69
	iB7eF6qQA92TItawz21U8MNQ2tl5Z3vUAI/rGVl6yyE1CwJGVq4qPvh5ZIEeCPKQc6svtdTdPdRUj
	5Pcq20qESws+JGpl4z3iZ2kz4q0ebglz41HDOWxvN8A6nCOb1ei9UAEFxWykk7TzsrV0f0WKmUabe
	B03HOBcDi0E1RD+vS9p2OBELyKWyEA8m7FBcPq5e8L9FON12Ntn1P3q/wwqcA1EFLedZD1wq2WsUJ
	0BR5X8AA==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUBz-0000000FrRJ-0Gye;
	Thu, 01 May 2025 13:43:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/15] xfs: test zoned ENOSPC behavior with multiple writers
Date: Thu,  1 May 2025 08:42:47 -0500
Message-ID: <20250501134302.2881773-11-hch@lst.de>
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

Test that multiple parallel writers can't accidentally dip into the reserved
space pool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4209     | 90 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4209.out |  2 ++
 2 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/4209
 create mode 100644 tests/xfs/4209.out

diff --git a/tests/xfs/4209 b/tests/xfs/4209
new file mode 100755
index 000000000000..18c84a968c40
--- /dev/null
+++ b/tests/xfs/4209
@@ -0,0 +1,90 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4209
+#
+# Test that multiple parallel writers can't accidentally dip into the reserved
+# space pool.
+#
+. ./common/preamble
+_begin_fstest quick auto rw zone enospc
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
+
+# limit to two max open zones so that all writes get thrown into the blender
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
+_try_scratch_mount || _notrun "mount option not supported"
+_require_xfs_scratch_zoned
+
+fio_config=$tmp.fio
+
+cat >$fio_config <<EOF
+[global]
+bs=64k
+iodepth=16
+iodepth_batch=8
+directory=$SCRATCH_MNT
+ioengine=libaio
+rw=write
+direct=1
+size=60m
+
+[file1]
+filename=file1
+
+[file2]
+filename=file2
+
+[file3]
+filename=file3
+
+[file4]
+filename=file4
+
+[file5]
+filename=file5
+
+[file6]
+filename=file6
+
+[file7]
+filename=file7
+
+[file8]
+filename=file8
+EOF
+
+_require_fio $fio_config
+
+# try to overfill the file system
+$FIO_PROG $fio_config 2>&1 | \
+	grep -q "No space left on dev" || \
+	_fail "Overfill did not cause ENOSPC"
+
+sync
+
+#
+# Compare the df and du values to ensure we did not overshoot
+#
+# Use within_tolerance to paper over the fact that the du output includes
+# the root inode, which does not sit in the RT device, while df does not
+#
+df_val=`df --output=size $SCRATCH_MNT | tail -n 1`
+du_val=`du -s $SCRATCH_MNT | awk '{print $1}'`
+_within_tolerance "file space usage" $df_val $du_val 64 -v
+
+status=0
+exit
diff --git a/tests/xfs/4209.out b/tests/xfs/4209.out
new file mode 100644
index 000000000000..cb72138a1bf6
--- /dev/null
+++ b/tests/xfs/4209.out
@@ -0,0 +1,2 @@
+QA output created by 4209
+file space usage is in range
-- 
2.47.2

