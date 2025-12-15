Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588AA242D70;
	Mon, 15 Dec 2025 09:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792253; cv=none; b=o4qYZuezBsc55UJeEnU6ElRzJKQbQCIkfaQ+VKvNljsAUmVH8Yk0UrigMmrVvdS21M0BATV+vDqkUwPvzsTT8HdIlT9tWAqzdF8PG3iMgI/rJpxRo580ioyQW1y/hhM5mNdxwUmEV58+0w1ztCnKMDjfEGEc4nCJBzMmP4oY7Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792253; c=relaxed/simple;
	bh=zqhgjbA1e+H7Z2J4zaMzXMbyBbDI3pV5s8OBYqod13g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfszzenZCgtfomsxQcyHZ11TXVsfJ0G20+2+TpXOTbShfD4PRQA/BAhupLZ0xR5XUKpJbGH/lziy64Yq8Kcy9OIEEbt9K+DxJk0EWfAKqjLDyRPIcHq4HVw12jTh5l93HxBeI71juMEjI6EdvAKnFJ1srX3lgE+lHWAyWcybtO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OpZ+z5n9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OpZ+z5n9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0PRjTVeVXt0PT6UHACGelSj5/2ltzXK+Tbdd1xXN7lQ=; b=OpZ+z5n9czf/ylnFFCBZtTO6Wg
	UaDVFjEszqy884bQCM2Egw+0pB/oTN0VZnnYg/tDPaIRpFA+MZt7PxJ3L5R7PWnrxK7/HCRRju07w
	2nzmXGcsKvjw3wWyeK4k3FICd0eaojCOcVci4mS7OrCsDpMsSlCMm3M+bvLwnI6GCMxyy2aWYZUpk
	fLTq0LsW/vD+Gap4LocWFjrfMt2HVmaq8wb51mhvR+kwEjElfvp94gYsQxFy7+Sqe9XigIHKMGELb
	k4TapF6TCHCAnIfbkd0cyocG3O6/i+q4LnWvm+yumUBG12Z63sWycGplwEfTZ9bQcqDDqW1SZ+BXT
	8XeLyOTg==;
Received: from [2001:4bb8:2d3:f4f4:dcee:db:50a:ae71] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV5E7-00000003Opo-0DyV;
	Mon, 15 Dec 2025 09:50:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: test that RT growfs not aligned to zone size fails
Date: Mon, 15 Dec 2025 10:50:28 +0100
Message-ID: <20251215095036.537938-3-hch@lst.de>
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

Check that a file system with a zoned RT subvolume can't be resized to
a size not aligned to the zone size.

Uses a zloop device so that we can control the exact zone size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/652     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/652.out |  4 ++++
 2 files changed, 62 insertions(+)
 create mode 100755 tests/xfs/652
 create mode 100644 tests/xfs/652.out

diff --git a/tests/xfs/652 b/tests/xfs/652
new file mode 100755
index 000000000000..91399be28df0
--- /dev/null
+++ b/tests/xfs/652
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2025 Christoph Hellwig.
+#
+# FS QA Test No. 652
+#
+# Tests that xfs_growfs to a realtime volume size that is not zone aligned is
+# rejected.
+#
+. ./common/preamble
+_begin_fstest auto quick realtime growfs zone
+
+. ./common/filter
+. ./common/zoned
+
+_require_realtime
+_require_zloop
+_require_scratch
+_require_scratch_size $((16 * 1024 * 1024)) # 16GiB in kiB units
+
+_cleanup()
+{
+	if [ -n "$mnt" ]; then
+		_unmount $mnt 2>/dev/null
+	fi
+	_destroy_zloop $zloop
+	cd /
+	rm -r -f $tmp.*
+}
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+fsbsize=4096
+unaligned_size=$((((12 * 1024 * 1024 * 1024) + (fsbsize * 13)) / fsbsize))
+
+mnt="$SCRATCH_MNT/mnt"
+zloopdir="$SCRATCH_MNT/zloop"
+
+mkdir -p $mnt
+zloop=$(_create_zloop $zloopdir 256 2)
+
+echo "Format and mount zloop file system"
+_try_mkfs_dev -b size=4k -r size=10g $zloop >> $seqres.full 2>&1 ||\
+	_notrun "cannot mkfs zoned filesystem"
+_mount $zloop $mnt
+
+echo "Try to grow file system to a not zone aligned size"
+$XFS_GROWFS_PROG -R $unaligned_size $mnt >> $seqres.full 2>&1 && \
+	_fail "growfs to unaligned size succeeded"
+
+echo "Remount file system"
+umount $mnt
+_mount $zloop $mnt
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/652.out b/tests/xfs/652.out
new file mode 100644
index 000000000000..8de9ab41d47f
--- /dev/null
+++ b/tests/xfs/652.out
@@ -0,0 +1,4 @@
+QA output created by 652
+Format and mount zloop file system
+Try to grow file system to a not zone aligned size
+Remount file system
-- 
2.47.3

