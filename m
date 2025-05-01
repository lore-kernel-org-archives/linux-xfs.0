Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A191C860B;
	Thu,  1 May 2025 13:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106987; cv=none; b=skGutdzttdLEZ0aFakpFNKZ6BsrMFOMUIkDpKa4CqGKtRosW0SfcWJVkdYhIAfljWrfGn1AaOGEeeQuCkAfAy/hdCUfFmvNiIZs+Cb1yLoKHzBzoo7lhdztEEpCQ4dxGgL7y1FmEnCC7OEYspKzJMPzsZUVoQUt5TeRxXsuab8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106987; c=relaxed/simple;
	bh=+RvkdVE0MVMQeZVvkthmF3HHNeGsU7q4agdmWW2Z4R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbfhs+270mO12t2SzbkaZZKsWsybvo+UD8/9PUhk+OUyF9a8epT3A0ODzj3ci6TPHZuApH5F+W/XgEfhRfWScD7kmAgFtcD+GRvbtM8jR4Q4JLWfAsheDAAoA1XAximGKQ+UfYQWZjp9MPZzVAvuGlZgc5HD6IyV+HT2CR+jn8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K2VALn51; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K2VALn51"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I1KRjhHAFHXe27Bs6/fQTzZlIqlHj2eM5N5Xl/Gx7js=; b=K2VALn517G/V8YTP/kryNqvDCI
	lnBBd9uajCsZTvShlC40pcSfdiLGHRg25LcxBxip1y70wKCs+OmImfL4K5weE3VAlMq76hGwpAfJL
	sVJ0NeCDg80G7GDfQqKO/1Sj/LlMdBWAuJA/WYh3p3WNUrka06voDaVUklEEWwbsNHmXuJp9HPDNO
	v8EVvV70TChCpvGD/d0wlAhy3TAqKRwoMmZzd9xSr2t/qjNsbZR9XNNErX1stbF0mKSdB0lr6unEl
	Joi3d4As3E3ZyKXk7pEx1PRLr+RSHqnW+HBOARfIinRluO4lHQ1ocAKmfL9us/6p86Kq4N6y3/Y+y
	NFQ4c3hQ==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUBu-0000000FrPk-0WpM;
	Thu, 01 May 2025 13:43:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/15] xfs: add a test to check that data growfs fails with internal rt device
Date: Thu,  1 May 2025 08:42:41 -0500
Message-ID: <20250501134302.2881773-5-hch@lst.de>
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

The internal RT device directly follows the data device on the same
block device.  This implies the data device can't be grown, and growfs
should handle this gracefully.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4204     | 33 +++++++++++++++++++++++++++++++++
 tests/xfs/4204.out |  3 +++
 2 files changed, 36 insertions(+)
 create mode 100755 tests/xfs/4204
 create mode 100644 tests/xfs/4204.out

diff --git a/tests/xfs/4204 b/tests/xfs/4204
new file mode 100755
index 000000000000..0b73cee23ba5
--- /dev/null
+++ b/tests/xfs/4204
@@ -0,0 +1,33 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4204
+#
+# Check that trying to grow a data device followed by the internal RT device
+# fails gracefully with EINVAL.
+#
+. ./common/preamble
+_begin_fstest quick auto growfs ioctl zone
+
+_cleanup()
+{
+	cd /
+	_scratch_unmount
+}
+
+# Import common functions.
+. ./common/filter
+
+_require_scratch
+_require_zoned_device $SCRATCH_DEV
+
+echo "Creating file system"
+_scratch_mkfs_xfs >>$seqres.full 2>&1
+_scratch_mount
+
+echo "Trying to grow file system (should fail)"
+$XFS_GROWFS_PROG -d $SCRATCH_MNT >>$seqres.full 2>&1
+
+status=0
+exit
diff --git a/tests/xfs/4204.out b/tests/xfs/4204.out
new file mode 100644
index 000000000000..b3593cf60d16
--- /dev/null
+++ b/tests/xfs/4204.out
@@ -0,0 +1,3 @@
+QA output created by 4204
+Creating file system
+Trying to grow file system (should fail)
-- 
2.47.2

