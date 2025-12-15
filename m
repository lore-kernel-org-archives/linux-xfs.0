Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4E28CF6F;
	Mon, 15 Dec 2025 09:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792256; cv=none; b=LAP63jfWc3eoEPxwZfP9JPpPebHOx9hHGcFx60dj7iY2AhHlVcgyGogfHyYED+oX9deWwYJkgYHY0c9HNzvJx3BmlOx0UDt4YahuWBwLM6R3q/Dj2l7dk+k87QoR2Uv5b99KmVEgkv86oV4+cC+5TqshBxiYDnjhgVU21zaee5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792256; c=relaxed/simple;
	bh=knyQ+OBaeqWnb90rRIj6w+TJnFo7QcMZsOcfn1qqINg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2ftdI9TLu3buy9iSU9gd2VDtRbwJW44Nwkhyr04Iw1T20QeKvZwEqe/wnphwhHSnvRgg7qB/9TOqHgONfsMEC+PpgmAz1OKGmN4N+vuZJfTW7lPFgWTHHanqRrbiwLHwBEcPqp/rgy3dKvpr7DQfGqSpPPExqSdIByveZhua3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gdIhNGIN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gdIhNGIN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zLzvjx5K8C4z7XBJkkL8ekvlYlxqw9abxGNoDncelWk=; b=gdIhNGIN6LRgPXlXPctDIIPvoJ
	YGgKM6tA45TgWV3P8IRwNpUFMZ4UBD9x5/T9jKGr7D1UUVixKvT/Havm8KWLiI3T+2R0PmKK7h8dY
	ZJ1v+3HupHWpd+jDH8gbdy6b72X0FSTR79lY/GFcaOT5QpmZap8FEfxx8DhE2881T0HlpiqRYqQQK
	5bj02SnbSNfZda4XVf89DwiUj7WmKyFa60zr/okj5hKPrV0aPCbH6D3KlV83ohUf4CfKaSjROOkYj
	bdrLAC/FAsfD1NwERIcrfQLY6apW0OVA4JADRUAFA5A/yEzBtB+5qQ8TkBt34qfMImhaW5croB1FI
	U6oU0+Ww==;
Received: from [2001:4bb8:2d3:f4f4:dcee:db:50a:ae71] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV5EE-00000003OqE-19zj;
	Mon, 15 Dec 2025 09:50:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: add a test that mkfs round up realtime subvolume sizes to the zone size
Date: Mon, 15 Dec 2025 10:50:29 +0100
Message-ID: <20251215095036.537938-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251215095036.537938-1-hch@lst.de>
References: <20251215095036.537938-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Make sure mkfs doesn't create unmountable file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/653     | 33 +++++++++++++++++++++++++++++++++
 tests/xfs/653.out |  2 ++
 2 files changed, 35 insertions(+)
 create mode 100755 tests/xfs/653
 create mode 100644 tests/xfs/653.out

diff --git a/tests/xfs/653 b/tests/xfs/653
new file mode 100755
index 000000000000..07d9125c2ff0
--- /dev/null
+++ b/tests/xfs/653
@@ -0,0 +1,33 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2025 Christoph Hellwig.
+#
+# FS QA Test No. 653
+#
+# Tests that mkfs for a zoned file system rounds realtime subvolume sizes up to
+# the zone size to create mountable file systems.
+#
+. ./common/preamble
+_begin_fstest auto quick realtime growfs zone
+
+. ./common/filter
+. ./common/zoned
+
+_require_realtime
+_require_scratch
+_require_scratch_size $((2 * 1024 * 1024)) # 1GiB in kiB units
+
+fsbsize=4096
+unaligned_size=$((((1 * 1024 * 1024 * 1024) + (fsbsize * 13)) / fsbsize))
+
+# Manual mkfs and mount to not inject an existing RT device
+echo "Try to format file system"
+_try_mkfs_dev -b size=4k -r zoned=1,size=${unaligned_size}b $SCRATCH_DEV \
+		>> $seqres.full 2>&1 ||\
+	_notrun "cannot mkfs zoned filesystem"
+_mount $SCRATCH_DEV $SCRATCH_MNT
+umount $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/653.out b/tests/xfs/653.out
new file mode 100644
index 000000000000..2cba5cdf1171
--- /dev/null
+++ b/tests/xfs/653.out
@@ -0,0 +1,2 @@
+QA output created by 653
+Try to format file system
-- 
2.47.3

