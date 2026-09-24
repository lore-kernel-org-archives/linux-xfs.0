Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA4943FD09;
	Thu, 24 Sep 2026 10:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244599; cv=none; b=GC2auk7XBS0nhc91y3BXusY3KOWIkYx7XQPeWixmXQJHCLsAkCnB+xq/OqCJiMeSdtXUKxwFUBh7e7Dfq2DUKjh6m0l4RphKtEdhWQ2iENJ9ouGU5FyBGCFSjVS6PFqR6Iw4/3OE2Nc9000o/LdaC218SuGdoRicP/yCI2pacOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244599; c=relaxed/simple;
	bh=B/D+vLalUso9MrxqbDtWX6s/ZaKa7ltduJOSatelMsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzWNAiu7MNGB2K7F9hRITNOA/iY4Hk82+yuOq6TdCNRS5i6P4ft0DReXNh6f6QPL2o0QZhX3qEFB6qKhQf0HWLD6PTbo/rApcd5WqahIYBoFYq0TVoRA7sDyz1B7j1nw7qQkFzZLrL3EV7W06YlHod/AibKLKd+Wsolalg0Drqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3bL+fnbv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3bL+fnbv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4qcMcqiVTDME+7j5PvuFR9jyT637WwJcKZpSkC0i1sI=; b=3bL+fnbvn/I9Yi7C0xEH4C+U54
	aTp9Q+6Mt7Hvdyv3AKzYZrSANWg3fo/jUQYCuiTKj/Lvmlo6kvXCD/y/wmfArEwGobI+b5QbuiI/v
	056MvbGfHmItxfsdNtgj8IoTDfHTbDUHpa86wOPxepmOH83WNxs/yrRgkQscpZba5s1yxwdr9SNgU
	GY23Zfge6sGpw5jtHmOFLfpTJaYhe04RM/njoSCaaLe0N8kA/ruJDcBk7hkkde1Oc7J5M6RdHTeTe
	rEw5258F4R4NZTYDbCCs8xRyDLqCvwRud9oW9QmV3brShYlRRG07JSD9MhNoIRi6NY1kzkRQreoss
	Ft8E91sA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOd-0000000Afqc-47gx;
	Thu, 24 Sep 2026 10:09:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/13] xfs/2307: test checksum handling using corrupted checksums
Date: Thu, 24 Sep 2026 12:07:53 +0200
Message-ID: <20260924100855.2734089-13-hch@lst.de>
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

Inject errors into the rtcsum files and check that the kernel handles
them gracefully and that repair fixes them, rebuilding the checksums if
needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2307     | 106 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2307.out |  93 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 199 insertions(+)
 create mode 100755 tests/xfs/2307
 create mode 100644 tests/xfs/2307.out

diff --git a/tests/xfs/2307 b/tests/xfs/2307
new file mode 100755
index 000000000000..47d5be36623d
--- /dev/null
+++ b/tests/xfs/2307
@@ -0,0 +1,106 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 2307
+#
+# Inject errors into the rtcsum files and check that the kernel handles
+# them gracefully and that repair fixes them, rebuilding the checksums if
+# needed.
+#
+. ./common/preamble
+_begin_fstest auto quick repair zone datacsum
+
+. ./common/filter
+. ./common/repair
+
+_require_scratch_nocheck
+
+
+prepare_fs()
+{
+	_scratch_mkfs >> $seqres.full 2>&1
+	_scratch_mount
+	_require_xfs_data_csum $TEST_DIR
+	cat /bin/sh > $SCRATCH_MNT/sh
+	_scratch_unmount
+}
+
+exercise_repair()
+{
+	echo "Checking corrupted file system"
+	_scratch_xfs_repair -P -n >> $seqres.full 2>&1
+
+	echo "Repairing corrupted file system"
+	_scratch_xfs_repair -P >> $seqres.full 2>&1
+}
+
+check_corrupted()
+{
+	echo "Checking corrupted file system"
+	_scratch_xfs_repair -P -n >> $seqres.full 2>&1
+	if [ $? -eq 0 ]; then
+		_fail "xfs_repair -n succeeded"
+	fi
+
+	_scratch_mount
+
+	echo "Reading from corrupted file system"
+	cmp /bin/sh $SCRATCH_MNT/sh
+	_scratch_unmount
+}
+
+check_fixed()
+{
+	echo "Checking repaired file system"
+	_scratch_xfs_repair -P -n 2>&1 | _filter_repair
+
+	_scratch_mount
+
+	echo "Scrubbing repaired file system"
+	$XFS_SCRUB_PROG -x -a 0 $SCRATCH_MNT >> $seqres.full
+	if [ $? -ne 0 ]; then
+		_fail "xfs_scrub failed"
+	fi
+
+	echo "Reading from repaired file system"
+	cmp /bin/sh $SCRATCH_MNT/sh
+	_scratch_unmount
+}
+
+echo
+echo
+echo "Corrupting rtcsum inode size"
+echo
+prepare_fs
+_scratch_xfs_set_metadata_field core.size 18 "path -m /rtgroups/0.csum"
+check_corrupted
+exercise_repair
+check_fixed
+
+echo
+echo
+echo "Corrupting rtcsum inode mode"
+echo
+prepare_fs
+_scratch_xfs_set_metadata_field core.mode 0 "path -m /rtgroups/0.csum"
+if _try_scratch_mount >>$seqres.full 2>&1; then
+	_fail "mount succeeded with corrupted nextents"
+fi
+exercise_repair
+check_fixed
+
+echo
+echo
+echo "Corrupting rtcsum inode nextents"
+echo
+prepare_fs
+_scratch_xfs_set_metadata_field core.nextents 2 "path -m /rtgroups/0.csum"
+if _try_scratch_mount >>$seqres.full 2>&1; then
+	_fail "mount succeeded with corrupted nextents"
+fi
+exercise_repair
+check_fixed
+
+status=0
+exit
diff --git a/tests/xfs/2307.out b/tests/xfs/2307.out
new file mode 100644
index 000000000000..2016c27ee280
--- /dev/null
+++ b/tests/xfs/2307.out
@@ -0,0 +1,93 @@
+QA output created by 2307
+
+
+Corrupting rtcsum inode size
+
+Allowing write of corrupted data with good CRC
+core.size = 18
+Checking corrupted file system
+Reading from corrupted file system
+Checking corrupted file system
+Repairing corrupted file system
+Checking repaired file system
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan (but don't clear) agi unlinked lists...
+        - process known inodes and perform inode discovery...
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+No modify flag set, skipping phase 5
+Phase 6 - check inode connectivity...
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify link counts...
+No modify flag set, skipping filesystem flush and exiting.
+Scrubbing repaired file system
+Reading from repaired file system
+
+
+Corrupting rtcsum inode mode
+
+Allowing write of corrupted data with good CRC
+core.mode = 0
+Checking corrupted file system
+Repairing corrupted file system
+Checking repaired file system
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan (but don't clear) agi unlinked lists...
+        - process known inodes and perform inode discovery...
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+No modify flag set, skipping phase 5
+Phase 6 - check inode connectivity...
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify link counts...
+No modify flag set, skipping filesystem flush and exiting.
+Scrubbing repaired file system
+Reading from repaired file system
+
+
+Corrupting rtcsum inode nextents
+
+Allowing write of corrupted data with good CRC
+core.nextents = 2
+Checking corrupted file system
+Repairing corrupted file system
+Checking repaired file system
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan (but don't clear) agi unlinked lists...
+        - process known inodes and perform inode discovery...
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+No modify flag set, skipping phase 5
+Phase 6 - check inode connectivity...
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify link counts...
+No modify flag set, skipping filesystem flush and exiting.
+Scrubbing repaired file system
+Reading from repaired file system
-- 
2.53.0

