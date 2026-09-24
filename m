Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA88B472076;
	Thu, 24 Sep 2026 10:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244609; cv=none; b=JN7TED1irepEkWykqQJD/zA2ZYDrml/TPDDcyCiaa8xrJDzWWVkWqay9LC4WvrQ+cgu7iNsSeijF4r6VV74NYCyOI4qtzPjYsJOG68K4ZX1CxmbajbcKL7yNsaubcwTOno1ju+w9LsSmbHfYNLA7yx8wgd3ms6k7bDTFnhn7rrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244609; c=relaxed/simple;
	bh=vCzC8tAyCTHowgx1v6eePqfNezBCXxgTLLsjiaVqhGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiozqCwm3YOnpWTgHrqXrCs3SEbiVSc0Fix+0NZTXm2ek638FBx5a0reiiv+bJDUABdNVfY26eY71aYKFH7LuGPmYA2NLtIuOiXE/yWACWAF6g+kMY5kOig+0GdnfcvS2ckZnhjLOQhDkhk5WinWsZFfXiZIumTZwpNaIjB9mm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KpbZMZOw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KpbZMZOw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HokaT/t81JSHhHKcF/0j9Vc5khw6N4Ze7Xf+3gWn9aQ=; b=KpbZMZOwUwNDFYBAjJzQ9pBrLU
	JSC4OQ5xIkqQFN3HYYqpDss4slnvwCOnproX4EHHtwZek0l+ccr3e+bJe3myzj/FFqTA0nEYXsLtk
	qZZqWObc5+pa7MlKosw+GJHvTtKL1KpA2M2Lbrx/NhxEtUT7SnJ+XMKctevzYdPOHf8egGtrzY9/j
	r2yqcSFDK83BoWzveJgv0Y1iX5k31Tg1/3RYq8Oa08dcNzOkgyqPK74z41VVDuD7kaWVTFD3cNF9c
	934YLUVqLVY/9Y50xfw06E83/uAEWUBYuHKSgpoBGnjBcyZeFV1KYHVnFqxCOvhGSvHhonh3Qama6
	wSVsXZjQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOh-0000000Afr9-1L1Y;
	Thu, 24 Sep 2026 10:09:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/13] xfs/2308: test rebuilding of csum files in xfs_repair
Date: Thu, 24 Sep 2026 12:07:54 +0200
Message-ID: <20260924100855.2734089-14-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100855.2734089-1-hch@lst.de>
References: <20260924100855.2734089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Plus handling of corrupted csum files in the kernel as a side effect.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2308     | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2308.out |  4 ++++
 2 files changed, 51 insertions(+)
 create mode 100755 tests/xfs/2308
 create mode 100644 tests/xfs/2308.out

diff --git a/tests/xfs/2308 b/tests/xfs/2308
new file mode 100755
index 000000000000..5c4f647ced7a
--- /dev/null
+++ b/tests/xfs/2308
@@ -0,0 +1,47 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 2308
+#
+# Corrupt rtcsum and check that scrub and different kinds of reads catch them.
+#
+. ./common/preamble
+_begin_fstest auto quick zone datacsum scrub
+
+. ./common/filter
+. ./common/fuzzy
+
+_require_scratch_nocheck
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+_require_xfs_data_csum $TEST_DIR
+
+cat /bin/sh > $SCRATCH_MNT/sh
+sync $SCRATCH_MNT
+
+rg=`xfs_bmap -v $SCRATCH_MNT/sh | _filter_bmap_gno`
+rg="${rg// /}"
+
+_scratch_unmount
+
+$XFS_DB_PROG -x $SCRATCH_DEV \
+	-c "path -m /rtgroups/$rg.csum" \
+	-c 'dblock 0' \
+	-c 'write csums[0] 4266'
+
+_scratch_mount
+$XFS_SCRUB_PROG -x -a 1 $SCRATCH_MNT >> $seqres.full 2>&1
+if [ $? -eq 0 ]; then
+	_fail "scrub did not find corruption"
+fi
+
+# Test buffered I/O
+$XFS_IO_PROG -c 'pread 0 64k' $SCRATCH_MNT/sh
+
+# Test direct  I/O
+$XFS_IO_PROG -d -c 'pread 0 64k' $SCRATCH_MNT/sh
+
+status=0
+exit
diff --git a/tests/xfs/2308.out b/tests/xfs/2308.out
new file mode 100644
index 000000000000..55f6a0c97264
--- /dev/null
+++ b/tests/xfs/2308.out
@@ -0,0 +1,4 @@
+QA output created by 2308
+csums[0] = 4266
+pread: Input/output error
+pread: Input/output error
-- 
2.53.0

