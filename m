Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59178472;
	Thu,  8 May 2025 05:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682527; cv=none; b=hTWUAhlkmTTWlS2eWmEQODsdbgeunbXP8CoeSOzvh380GQE+5zGhfCf8hDiveeF/VwB15Tev3UZwVxgNh9PukpaEO2v3g/giWUYzm2wEZSdyA6hHPz0TV+6M/2hh9Eyxp+qui3f8FTMzfdvp/83gEJvAC3Wu7BcmI/gdV+rav2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682527; c=relaxed/simple;
	bh=V0R28ri/q7om3v1io+1wtUFSfuDkcK0PGlAlo2w8zHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fch9di4AwSI2AUDvZKi07sYya4Hpj0V0l9NeNTNc7qKenrrDc0qH/KjHvYvRpS7Y//+Gw/JKpVh5A1awjQo2/ieHj60uWdKdgBE2NBH6ZTkTvpxf5uzTMxYWo65sO8KxNIDq6HVOe6t7BlBGvTXtVLMjAxnl3VllNzYo+BMZklA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jAknQ3Kf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jAknQ3Kf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bPMqw3EUzSWK+WTSPH6R5axZ81RKRFayCblEZ0AYTvA=; b=jAknQ3KfBYnf8Say4hdb0yYYDz
	LMluN/xaLZNE9yIslDvSqoY2N6VAA9Ut6ZSpMJ2SMsUan9bA9KWERfWiGGCo55HjlAd/6txGmvqtL
	FZV0VapU2P4+QK0e5kf2cQ8zg/2+tqPJlWBHbXqmcSS1De55Ddh7YaFfXcpZLB1PiOGihXoMDIKGE
	iqtkdJrHkJcE9MxmGI3IvVifVAjBC+hltLdpKBjnzI/Nn36GnUO46QRNxnpsMXG8L2Llfl+iFwu65
	zKqIKZOsOwlok694AiXKa6/T3Vox+q2qpOV7/oJMe/Ir/krnRGZOTV07z2K076eYE/crUwCuR8xKr
	rZY4v9Ww==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtun-0000000HNjK-0T66;
	Thu, 08 May 2025 05:35:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/16] xfs: add a test for writeback after close
Date: Thu,  8 May 2025 07:34:37 +0200
Message-ID: <20250508053454.13687-9-hch@lst.de>
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

Test that files written back after closing are packed tightly instead of
using up open zone resources.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4206     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4206.out |  1 +
 2 files changed, 42 insertions(+)
 create mode 100755 tests/xfs/4206
 create mode 100644 tests/xfs/4206.out

diff --git a/tests/xfs/4206 b/tests/xfs/4206
new file mode 100755
index 000000000000..aa352d674398
--- /dev/null
+++ b/tests/xfs/4206
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4206
+#
+# Test that data is packed tighly for writeback after the files were
+# closed.
+#
+. ./common/preamble
+_begin_fstest auto quick rw zone
+
+. ./common/xfs
+
+_require_scratch
+
+_scratch_mkfs_xfs >>$seqres.full 2>&1
+_scratch_mount
+_require_xfs_scratch_zoned
+
+# Create a bunch of small files
+for i in `seq 1 100`; do
+	file=$SCRATCH_MNT/$i
+
+	$XFS_IO_PROG -f -c 'pwrite 0 8k' $file >>$seqres.full
+done
+
+sync
+
+# Check that all small files are placed together
+short_rg=`xfs_bmap -v $SCRATCH_MNT/1 | _filter_bmap_gno`
+for i in `seq 2 100`; do
+	file=$SCRATCH_MNT/$i
+	rg=`xfs_bmap -v $file | _filter_bmap_gno`
+	if [ "${rg}" != "${short_rg}" ]; then
+		echo "RG mismatch for file $i: $short_rg/$rg"
+	fi
+done
+
+status=0
+exit
diff --git a/tests/xfs/4206.out b/tests/xfs/4206.out
new file mode 100644
index 000000000000..4835b5053ae5
--- /dev/null
+++ b/tests/xfs/4206.out
@@ -0,0 +1 @@
+QA output created by 4206
-- 
2.47.2

