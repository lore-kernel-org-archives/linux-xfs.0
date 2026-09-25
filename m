Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ECA407CCC;
	Fri, 25 Sep 2026 05:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313326; cv=none; b=bki3L8iqBBIkhCI8dJ7Pvj6pMbbJFqeLTYRHUHbXN5Sc+xPr6Po1BKSuhtQ/4KbgfQjtEJ+QZol3IW0oTOL6UGIAFMPyH5Afut/OFE/5nphhesw8WR9uGRaoUJ7YxsnIa4TqgSq8wOEjbp1mqSK6rhsiwyM8DNFnopFQE7eABX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313326; c=relaxed/simple;
	bh=12Zh2un4yoQWgZ8GTNVo+O5+6CgbhswSF318kSRU1IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l6gU6rzOhfbaFmeVnjTe9Ti6NrUNIP8sx9yz3Fr183+nvYp105ww6cWcKbQE0T1lR6LmozB7atQP2UXETmjjqBqX8hHNLsMe/N1z5JdJHjmJdJhrpAEZsNw2FFtL+UV0aWPmWHeKlV6aNeZenxdNzX/aWs6wWV0Hyi7Z6rtGvcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AGbGOgOA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AGbGOgOA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=dteNNQcwYomE3JmnFPr/l7ko1ljvC2T8zGrD74EjsHs=; b=AGbGOgOA3DtBMAq7JJZBdVcf3N
	q4qrVw60qT0sbTAZoXkULu+3NXPvGzTDQtdcHZr9CrtLuzU5HaDSz+sNYSs0xYwgIZ52OwwscGxnx
	Eyb/l7UuWwmz06LJKbciFQhodUl1TGvSbfjLq6WSl5dM+gVr376D+IYoqagfZtDg0p9jpedRWHMMQ
	L74EB+4MurqHhPSL5XblLNssdhiht+0jp8zarZE2coI6Wci7/e/Ujgvr9FIIFaKGKD8BCoaIAfMgj
	8tEI4kkEwlAQkb4ZxkjOGLQtPkNtx0DjaqlYvd2V2L5t9hrjTlyf9pk9sVaVbfGg7sG6Kw+Li2gd7
	A6uDbkUw==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yHJ-0000000CghE-2oZw;
	Fri, 25 Sep 2026 05:15:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: test libxfs handling of missing RT devices
Date: Fri, 25 Sep 2026 07:15:15 +0200
Message-ID: <20260925051519.3002168-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Test that libxfs rejects initializing a file systems unless in debugger
mode by running xfs_repair and xfs_db with missing arguments.  For
db additionally test that command that require a RT device still do not
work even after libxfs can be initialized using a missing RT device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2300     | 39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/2300.out | 14 ++++++++++++++
 2 files changed, 53 insertions(+)
 create mode 100755 tests/xfs/2300
 create mode 100644 tests/xfs/2300.out

diff --git a/tests/xfs/2300 b/tests/xfs/2300
new file mode 100755
index 000000000000..9d8bd9c6ae44
--- /dev/null
+++ b/tests/xfs/2300
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 2300
+#
+# Tests that repair refuses to work without -r argument, and xfs_db works fine
+# even without it to check libxfs initialization behavior with missing RT
+# devices.
+#
+. ./common/preamble
+_begin_fstest auto quick repair db
+
+. ./common/filter
+
+_require_scratch_nocheck
+_require_realtime
+
+if [ -z "$SCRATCH_RTDEV" ]; then
+	_notrun "external RT device required"
+fi
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+echo "Dumping superblock using xfs_db without rtdev"
+$XFS_DB_PROG $SCRATCH_DEV -c 'sb 0' -c 'p' >> $seqres.full
+
+echo "Loading RT superblock using xfs_db without rtdev, should fail"
+$XFS_DB_PROG $SCRATCH_DEV -c 'rtsb'
+
+echo "Running xfs_repair -n without rt device, should fail"
+$XFS_REPAIR_PROG -n $SCRATCH_DEV
+
+echo "Running xfs_repair without rt device, should fail"
+$XFS_REPAIR_PROG $SCRATCH_DEV
+
+
+status=0
+exit
diff --git a/tests/xfs/2300.out b/tests/xfs/2300.out
new file mode 100644
index 000000000000..50aab2b83ec9
--- /dev/null
+++ b/tests/xfs/2300.out
@@ -0,0 +1,14 @@
+QA output created by 2300
+Dumping superblock using xfs_db without rtdev
+Loading RT superblock using xfs_db without rtdev, should fail
+realtime device not loaded, use -R.
+Running xfs_repair -n without rt device, should fail
+Phase 1 - find and verify superblock...
+xfs_repair: filesystem has a realtime subvolume
+xfs_repair: realtime device init failed
+xfs_repair: cannot repair this filesystem.  Sorry.
+Running xfs_repair without rt device, should fail
+Phase 1 - find and verify superblock...
+xfs_repair: filesystem has a realtime subvolume
+xfs_repair: realtime device init failed
+xfs_repair: cannot repair this filesystem.  Sorry.
-- 
2.53.0

