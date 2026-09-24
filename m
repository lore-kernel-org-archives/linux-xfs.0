Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3784F463B9B;
	Thu, 24 Sep 2026 10:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244572; cv=none; b=jcY+SUqN7NPlkg4R42aRYqb85ulSt3qAdwTJGwOQB+bLq+OVFjb+He7EH8CqfytTeBxh1gDlbJPMro+96yTZr6spD2WV4UhpddAcN04YniiY6opbVBbImfXyoTl19hYh32lGWxoAkXKgwVdg+Zn1m1Ix5PpY1JahRjc+6qgOoBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244572; c=relaxed/simple;
	bh=42qG7JTS8VMGr36pl/krPrRYENjcWN8pPGGAFKwCJn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fp3EcTO5ccgfC0NKAFLe1quX2oIs/JVx6DTbvZWAwibUhZv6x0zQD99R9teXaVRISsqBCKWo1/+L6LOon9JlYz7lLdWNgmilGDSTOvrH2Y+FC/V3ezfKj9c9scaDVt6TsaPS4nrIstxDE3ptW9pHMw+ItJGdUUI0NI1YzwXKNa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PUT5rcON; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PUT5rcON"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NXb8RyKEEgKksQfo2Q8i1hbn4e0/7KYaNeOSh1LazUI=; b=PUT5rcONkIueo0uwS7WAwiJ8Ks
	1KDbMEErSKMhfXgV1l3s5YeoKwaPmdVlbJA+Rm7flSMUex+3S02WWSzrP6nbj3ajqJbiJ0bqMHbqj
	ieWRXmaZ/OnvZvJkpkbNK8n/SRX1ikIzFgBBtjyPZfdE8DLsrtKiJ2qUrOO+HzO0lD3A4lhpRgaAh
	VLP0ini1bDL4BdMAID+pAaxL/cuhnMZqFVkMCHORzrgEhv0F9kzVF5p/HB42O/kcDAqdLln2JR2EN
	OaRfDssNdJ+aNjmSpUHXjA5iMqc+P469kHTXPRBwlZbrwO56+Ecs5LxXILUZ3nr/7fsg/H45LxVEd
	BqKfAYfQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOJ-0000000Afoi-219H;
	Thu, 24 Sep 2026 10:09:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/13] xfs/2301: test lazy bounce buffering mode
Date: Thu, 24 Sep 2026 12:07:47 +0200
Message-ID: <20260924100855.2734089-7-hch@lst.de>
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

Run fsx (based on generic/091) while injecting lazy bounce buffer
retries for reads.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2301     | 43 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2301.out | 13 +++++++++++++
 2 files changed, 56 insertions(+)
 create mode 100755 tests/xfs/2301
 create mode 100644 tests/xfs/2301.out

diff --git a/tests/xfs/2301 b/tests/xfs/2301
new file mode 100755
index 000000000000..605510c6dbc8
--- /dev/null
+++ b/tests/xfs/2301
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 2301
+#
+# Run fsx with error injection for re-retries with bounce buffers, simulating
+# users modifying the in-flight data buffer.
+#
+. ./common/preamble
+_begin_fstest rw auto quick datacsum
+
+. ./common/filter
+. ./common/inject
+
+_require_test
+_require_odirect
+_require_xfs_data_csum $TEST_DIR
+
+psize=`$here/src/feature -s`
+bsize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
+
+_test_inject_error bounce_reread 100
+
+# fsx load similar to generic/091
+echo "Testing direct I/O"
+run_fsx -N 10000            -l 500000 -r BSIZE -w BSIZE -Z -R -W
+run_fsx -N 10000  -o 8192   -l 500000 -r BSIZE -w BSIZE -Z -R -W
+run_fsx -N 10000  -o 32768  -l 500000 -r BSIZE -w BSIZE -Z -R -W
+run_fsx -N 10000  -o 8192   -l 500000 -r BSIZE -w BSIZE -Z -R -W
+run_fsx -N 10000  -o 32768  -l 500000 -r BSIZE -w BSIZE -Z -R -W
+run_fsx -N 10000  -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
+
+# fsx load similar to generic/091 but using buffered I/O
+echo "Testing buffered I/O"
+run_fsx -N 10000            -l 500000
+run_fsx -N 10000  -o 8192   -l 500000
+run_fsx -N 10000  -o 32768  -l 500000
+run_fsx -N 10000  -o 128000 -l 500000
+
+status=0
+exit
diff --git a/tests/xfs/2301.out b/tests/xfs/2301.out
new file mode 100644
index 000000000000..221a3185970c
--- /dev/null
+++ b/tests/xfs/2301.out
@@ -0,0 +1,13 @@
+QA output created by 2301
+Testing direct I/O
+fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
+Testing buffered I/O
+fsx -N 10000 -l 500000
+fsx -N 10000 -o 8192 -l 500000
+fsx -N 10000 -o 32768 -l 500000
+fsx -N 10000 -o 128000 -l 500000
-- 
2.53.0

