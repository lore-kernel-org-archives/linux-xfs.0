Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D5B193062;
	Wed,  7 May 2025 05:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594781; cv=none; b=OlN3S/oHPc6VJFK+BYkaDDRk9zd0QNSTkKQJqHgx5gsw38D5AbxowvoKYvNG2p3Z6vPCMe2SOJWdfMZO/IxJZ+d7HPV9OPqognZ0GO4LIrPLk8xJ4fmq+0oVPzGnnvJ6BHkx64rcCH+Mut+OtCPiX/o8h+ir++45xlB5ushemUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594781; c=relaxed/simple;
	bh=99PmOYdiSTcfIncBSjwOpTtDlPntmLV0bF4C+DJ3cYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7/nWSGXcxKDete9MI+FPuGm3YcA4h4pSJKgYOotx33516dnYtbkOl1XMKHPIfeXrjF6N1KiegF4lGyWwQZyhneX9XMo6VT5jzYjJBS8ltJChNV2zzsod4HmhGqYVYrbOM1ajT7SX8/EarhIuoEsVjrrH8wI4Z7ZlkQns8itDlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ob5ka1Lm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ob5ka1Lm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HrepzscOdERHt7eiXYrHhA+ECdTKjIWPGE6bx44lsnc=; b=ob5ka1LmllLsW2hdNMeJe2Wl7n
	yKHjeSEArQbJa99PazNjXy2RxRZIgDOGEx3fOuAfa5TF2xBknnAukCey/wvzztcDRNyGOapLliaVx
	xf2wf5oJ3WdBC1giYNrtzq95bMmrUcGuE3IMWv+5Fbk6rjUpHKPGbOWAySzk6lUetBWQVJ7k7bvIa
	ySWTT+k1IHnWZ53jDc3JsKfEgV1hJbER6XMMJvml0+0IrsMky6QRCi2Ps3aQqNMYV8cCj3Qh2yfzs
	2P0XRgqdBe2EypLgceRwpeFZScL1gddfIrP7TqFokkJmMJXQ17KCRqa6/EOmlWeVxTlnWr7eJSn9f
	0/ytNBdQ==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5X-0000000EEpg-0GUE;
	Wed, 07 May 2025 05:12:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/15] xfs: add a test for zoned block accounting after remount
Date: Wed,  7 May 2025 07:12:23 +0200
Message-ID: <20250507051249.3898395-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507051249.3898395-1-hch@lst.de>
References: <20250507051249.3898395-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Test for a problem with an earlier version of the zoned XFS mount code
where freeded blocks in an open zone weren't properly accounted for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4201     | 40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4201.out |  6 ++++++
 2 files changed, 46 insertions(+)
 create mode 100755 tests/xfs/4201
 create mode 100644 tests/xfs/4201.out

diff --git a/tests/xfs/4201 b/tests/xfs/4201
new file mode 100755
index 000000000000..5fc27c4d3593
--- /dev/null
+++ b/tests/xfs/4201
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4201
+#
+# Regression test for mount time accounting of an open zone with freed blocks.
+#
+
+. ./common/preamble
+_begin_fstest auto quick zone
+
+_require_scratch
+_require_odirect
+
+#
+# Create a 256MB file system.  This is picked as the lowest common zone size
+# to ensure both files are placed into the same zone.
+#
+_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mount
+
+dd if=/dev/zero of=$SCRATCH_MNT/test1 oflag=direct conv=fsync bs=1M count=32
+dd if=/dev/zero of=$SCRATCH_MNT/test2 oflag=direct conv=fsync bs=1M count=32
+rm $SCRATCH_MNT/test1
+
+# let delayed inode deactivate do its work
+sleep 1
+df -h $SCRATCH_MNT > $tmp.df.old
+
+_scratch_cycle_mount
+
+echo "Check that df output matches after remount"
+df -h $SCRATCH_MNT > $tmp.df.new
+diff -u $tmp.df.old $tmp.df.new
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
new file mode 100644
index 000000000000..4cff86d90b0f
--- /dev/null
+++ b/tests/xfs/4201.out
@@ -0,0 +1,6 @@
+QA output created by 4201
+32+0 records in
+32+0 records out
+32+0 records in
+32+0 records out
+Check that df output matches after remount
-- 
2.47.2

