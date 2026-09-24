Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38610468C2D;
	Thu, 24 Sep 2026 10:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244595; cv=none; b=HMhmsm7qqwNEkWq96SwmYONdnmHa4xutiu8a6oGvV9wCSedM1viWQuiRhOohB4U2Fw4Iy6DlfLiHdqnccOBDSMELRoN9YLpYHHC8HaUnhG+tJwlP7bwajfVcyhilKEMJS75ctE06JvVysY+zwoQW+GnYc321B9w27Xnjtx9PTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244595; c=relaxed/simple;
	bh=8ZCDfymFau5ILhctHHQzkzfmvft6xtkNME71BG1x2bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mzz1mGAMweg8Xi+SKVdjYSg7Kcsoxw3+yGYmpx5lKUVThnmQ5lDypSCNHKQKMfhO26GbrBey10Rr9yGHVt1c/sXHX+13nTDRC2eLSdgEbJ1GhZdMtPBdwh20p+HmDF3Of+Vz1A8R2nanv9TxHkVkXLZQ1yEA8QU/iM5ruaP2d+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D4So0s/z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D4So0s/z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bUcCbsc6N9hiUlXMVKFnURr0aXW2tWsluBe6Na4MAM0=; b=D4So0s/zR66ivxxKfpPvf6Ji+p
	5mhV5TCvJ9FVbG4K6ZDN0CsRtpZqCdq6LFRmdnWc5qTaCQzYcIeni35L5OTAJ56hE4m4hoMiFTc+/
	D1f1Dw45lFC//hrqkjKRWl92ILpRxqTjPuhOEgnUqBlTthnuLKnNas4wQgdEtfO9Pq0qrkryU6+it
	lMpWdfLvuCh+wDkoGADGOGcJJxE2cunrkFurBPSdwi6LYYVFKjth90ez81vO0UZjO5bkPyULAY6kl
	6PQRVKOooIuW0izefdOtm/oGupQcrG1fa+oxgfoFxGL0yljDKqMEOMNKOzzlw1bP7CvkqIpYKkTVo
	aGh8UkCQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOa-0000000AfqS-2mM2;
	Thu, 24 Sep 2026 10:09:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/13] xfs/2306: test mkfs input validation for RT data csum options
Date: Thu, 24 Sep 2026 12:07:52 +0200
Message-ID: <20260924100855.2734089-12-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2306     | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2306.out | 20 +++++++++++++++++++
 2 files changed, 70 insertions(+)
 create mode 100755 tests/xfs/2306
 create mode 100644 tests/xfs/2306.out

diff --git a/tests/xfs/2306 b/tests/xfs/2306
new file mode 100755
index 000000000000..76dac5bb2a69
--- /dev/null
+++ b/tests/xfs/2306
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 2306
+#
+# Test mkfs input checking for the csum and csumbsize options.
+#
+. ./common/preamble
+_begin_fstest auto quick mkfs zone datacsum
+
+. ./common/filter
+
+_require_scratch_nocheck
+
+expect_fail()
+{
+	opts=$1
+	msg=$2
+
+	echo "Testing $msg (expect failure)"
+	$MKFS_XFS_PROG -f $opts $SCRATCH_DEV 2>&1 | head -n1
+}
+
+expect_fail "-r csum=crc32c" "csum option without zoned"
+expect_fail "-r csumbsize=32k" "csumbsize option without zoned"
+expect_fail "-r zoned,csum=crc16" "invalid csum value"
+expect_fail "-r zoned,csum=crc32c,csumbsize=1k" "too small csumbsize"
+expect_fail "-r zoned,csum=crc32c,csumbsize=48k" "non-pow2 csumbsize"
+expect_fail "-r zoned,csum=crc32c,csumbsize=128k" "too large csumbsize"
+expect_fail "-b size=64k -r zoned,csum=crc32c,csumbsize=32k" "csumbsize < bsize"
+
+expect_pass()
+{
+	opts=$1
+	msg=$2
+
+	echo "Testing $msg (expect pass)"
+	$MKFS_XFS_PROG -f $opts $SCRATCH_DEV >> $seqres.full 2>&1 || \
+		_fail "could not mkfs for $opts"
+}
+
+expect_pass "-r zoned,csum=none" "csum=none"
+expect_pass "-r zoned,csum=crc32c" "csum=crc32c"
+expect_pass "-r zoned,csum=crc64" "csum=crc64"
+expect_pass "-r zoned,csum=crc64,csumbsize=32k" "csum=crc64,csumbsize=32k"
+expect_pass "-r zoned,csum=crc64,csumbsize=64k" "csum=crc64,csumbsize=64k"
+
+status=0
+exit
diff --git a/tests/xfs/2306.out b/tests/xfs/2306.out
new file mode 100644
index 000000000000..5e79103212ad
--- /dev/null
+++ b/tests/xfs/2306.out
@@ -0,0 +1,20 @@
+QA output created by 2306
+Testing csum option without zoned (expect failure)
+data checksums not supported without zoned mode
+Testing csumbsize option without zoned (expect failure)
+RT data csum block size options requires RT data csum type.
+Testing invalid csum value (expect failure)
+unknown option -r crc16
+Testing too small csumbsize (expect failure)
+Invalid value 1k for -r csumbsize option. Value is too small.
+Testing non-pow2 csumbsize (expect failure)
+RT data csum block size of 49152 bytes is not a power of 2
+Testing too large csumbsize (expect failure)
+Invalid value 128k for -r csumbsize option. Value is too large.
+Testing csumbsize < bsize (expect failure)
+RT data csum block size of 32768 bytes is smaller than fsblock size 65536.
+Testing csum=none (expect pass)
+Testing csum=crc32c (expect pass)
+Testing csum=crc64 (expect pass)
+Testing csum=crc64,csumbsize=32k (expect pass)
+Testing csum=crc64,csumbsize=64k (expect pass)
-- 
2.53.0

