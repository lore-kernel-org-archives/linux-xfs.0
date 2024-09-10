Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1E918E1E;
	Tue, 10 Sep 2024 04:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725942693; cv=none; b=B9Sv0njqQw171Qq2W2VaFYwKgXb9Xbe4WQOZe4fZctOYkZLMfEUylEkEbylznXwJW3tG0uUNmZKVMMRw86zTXC+xcJZU+H++aZcVwx+af16UMEy1KU6j+tDIvOiqlsLvE+aJGsc8mMGBJlEvQeibt+qTPjhQZlx0i3F5BoGDQ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725942693; c=relaxed/simple;
	bh=CyWqPLn5DL2FhUqms0nxZKvRGJY2v45bx3AQzOeE8Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hfUNoes5QkVWYgX7R31LI37q6gwH2zGERZK1SvZKf5JHL8fjEqYOIaxazap7m0QTXY65OOaXm44lX2zfDfhpzh614+0ESdkoaehxXgHiyKujtevKuVEMXEHlPNSt2c7scnTyhBKhsdg05BZQNV+adAfyID70mOfh505LNiJEUJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jFl7ZKPn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jFl7ZKPn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=qFgMwMUVrmSoi1w2B47y4V+EDsgYokY8m/V4IEBOZ2k=; b=jFl7ZKPnPT9vY+zBHS0X4D3LH7
	LHa78Fqg3RsiNcJYK3VVea8Oqb96HbnPt1oP/cGrEUdN8Zq41T/pzCOfXlt+/L4y1e5DqaGmnNyHC
	vS9/mcAph4L8nxrQ564TMcrKWBwtcW2h9VgZXOdPce/Lrs+RRXTvaHrb7kUl1TdBcAqJkZl4ExUN8
	H4wPjUBkuJ/OUwqZ5RR8f53saC+lDwF6bll6Q60VLdiKYWcX7FjkramWNhWGiUrVcbCIG16Z577do
	tVHEnY1zBp3fvdpWj9oWn1jIAf92Lortru6fO+eL+j7NyB/Q3H0a8THs9/X4RENesFA96NDgJsmVA
	ImHcB3BQ==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snsXJ-00000004DQm-46yp;
	Tue, 10 Sep 2024 04:31:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: test log recovery for extent frees right after growfs
Date: Tue, 10 Sep 2024 07:31:17 +0300
Message-ID: <20240910043127.3480554-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Reproduce a bug where log recovery fails when an unfinised extent free
intent is in the same log as the growfs transaction that added the AG.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/1323     | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1323.out | 14 +++++++++++
 2 files changed, 75 insertions(+)
 create mode 100755 tests/xfs/1323
 create mode 100644 tests/xfs/1323.out

diff --git a/tests/xfs/1323 b/tests/xfs/1323
new file mode 100755
index 000000000..a436510b0
--- /dev/null
+++ b/tests/xfs/1323
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024, Christoph Hellwig
+#
+# FS QA Test No. 1323
+#
+# Test that recovering an extfree item residing on a freshly grown AG works.
+#
+. ./common/preamble
+_begin_fstest auto quick growfs
+
+. ./common/filter
+. ./common/inject
+
+_require_xfs_io_error_injection "free_extent"
+
+_xfs_force_bdev data $SCRATCH_MNT
+
+_cleanup()
+{
+	cd /
+	_scratch_unmount > /dev/null 2>&1
+	rm -rf $tmp.*
+}
+
+echo "Format filesystem"
+_scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+echo "Fill file system"
+dd if=/dev/zero of=$SCRATCH_MNT/filler1 bs=64k oflag=direct &>/dev/null
+sync
+dd if=/dev/zero of=$SCRATCH_MNT/filler2 bs=64k oflag=direct &>/dev/null
+sync
+
+echo "Grow file system"
+$XFS_GROWFS_PROG $SCRATCH_MNT >>$seqres.full
+
+echo "Create test files"
+dd if=/dev/zero of=$SCRATCH_MNT/test1 bs=8M count=4 oflag=direct | \
+	 _filter_dd
+dd if=/dev/zero of=$SCRATCH_MNT/test2 bs=8M count=4 oflag=direct | \
+	 _filter_dd
+
+echo "Inject error"
+_scratch_inject_error "free_extent"
+
+echo "Remove test file"
+rm $SCRATCH_MNT/test2
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/test1 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_remount_dump_log >> $seqres.full
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1323.out b/tests/xfs/1323.out
new file mode 100644
index 000000000..1740f9a1f
--- /dev/null
+++ b/tests/xfs/1323.out
@@ -0,0 +1,14 @@
+QA output created by 1323
+Format filesystem
+Fill file system
+Grow file system
+Create test files
+4+0 records in
+4+0 records out
+4+0 records in
+4+0 records out
+Inject error
+Remove test file
+FS should be shut down, touch will fail
+Remount to replay log
+Done
-- 
2.45.2

