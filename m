Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D3827E074;
	Fri, 19 Dec 2025 05:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122564; cv=none; b=MtpiLDChKnq0zvWFTK+GaK9+66XGg8SiWRTSrd67Gis9P1lnEPrjxKVPvmy/qeMdMBYrqNGznJ0OmsFtoK1b3jb0FZ9RW+mOpeLRnCZX9nfQKU3e5foq8qx30AfFlqqQpR5ifRCf377LoBdtAdUO9vYFULz/TXGdtAdRVnuRu1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122564; c=relaxed/simple;
	bh=mXqpgAHOd6kZzO6VFm7vhvRMzylSwa0nxewv7f2ulWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pcfqfqg39PC/77rNBOT+u9Mq7as8WfF5CY4sNMS02Zh/H3nC4hxMW7aNEWUEUCyYyB6jkJzSfxiRmFPCd7vbDexM94e/EMn0ceEGTJA6Wc5c9QJaW0zuOcL13zYGCw31EBFu+hfUSDXEIcnzpRj4vzClzsoOAI2xDwnA0rFs3mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3d3g9vw1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3d3g9vw1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PMKlxdSEvj97bnWnwd1Iv/Os/IMacfdZQcyePm8FpPY=; b=3d3g9vw1oOuiJxyXWQ+eicWAhD
	7W3lM3eV6whZXmys5TzV5MjalYazPuuaX9wCf8aG/uMBsYMCYY3r1BTZ3EIJzcoKCzgb75aMKikrA
	1hdBqY/77G5/SNIvyX0wMHtyAo71GakojrxeRIkskNQZEz0AT/FlqmUJuLVwkqfMqudcxyo0/qXrV
	kT1K4EUPCMTAm5bCFQsbxey31UhebnNT8gSokJBOmdseEMLCtPlkWyBhBbC8X+zQ5Gu0aItHO8jWH
	xjF1GEcQuqI+XtP4iPiyWkVd67FHYs8845faTBPlf6LeYx2r9LuxMsveqNYRFAK80ZmQi5p28H1Qz
	p3JjWM/w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWT9m-00000009eWp-11J1;
	Fri, 19 Dec 2025 05:36:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: add a test that zoned file systems with rump RTG can't be mounted
Date: Fri, 19 Dec 2025 06:35:44 +0100
Message-ID: <20251219053553.1770721-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251219053553.1770721-1-hch@lst.de>
References: <20251219053553.1770721-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Garbage collection assumes all zones contain the full amount of blocks.
Mkfs already ensures this happens, but the kernel mount code did not
verify this.  Instead such a file system would eventually fail scrub.

Add a test to verify the new superblock verifier check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/651     | 34 ++++++++++++++++++++++++++++++++++
 tests/xfs/651.out |  2 ++
 2 files changed, 36 insertions(+)
 create mode 100755 tests/xfs/651
 create mode 100644 tests/xfs/651.out

diff --git a/tests/xfs/651 b/tests/xfs/651
new file mode 100755
index 000000000000..b2d34af32286
--- /dev/null
+++ b/tests/xfs/651
@@ -0,0 +1,34 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Christoph Hellwig.
+#
+# FS QA Test No. 651
+#
+# Test that the sb verifier rejects zoned file system with rump RTGs.
+#
+. ./common/preamble
+_begin_fstest auto quick zone
+
+. ./common/zoned
+
+# we intentionally corrupt the superblock
+_require_scratch_nocheck
+
+_try_scratch_mkfs_xfs -r zoned=1 >> $seqres.full 2>&1 || \
+	_notrun "Can't create zoned file system"
+
+# adjust rblocks/rextents to not be zone aligned
+blocks=$(_scratch_xfs_get_sb_field rblocks)
+blocks=$((blocks - 4096))
+_scratch_xfs_set_sb_field rblocks ${blocks} >> $seqres.full 2>&1
+_scratch_xfs_set_sb_field rextents ${blocks} >> $seqres.full 2>&1
+
+if _try_scratch_mount >/dev/null 2>&1; then
+	echo "Mounted rump RTG file system (bad)"
+else
+	echo "Can't mount rump RTG file system (good)"
+fi
+
+
+status=0
+exit
diff --git a/tests/xfs/651.out b/tests/xfs/651.out
new file mode 100644
index 000000000000..5d491b1894ea
--- /dev/null
+++ b/tests/xfs/651.out
@@ -0,0 +1,2 @@
+QA output created by 651
+Can't mount rump RTG file system (good)
-- 
2.47.3

