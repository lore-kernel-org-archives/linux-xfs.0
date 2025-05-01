Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931721CAA79;
	Thu,  1 May 2025 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106997; cv=none; b=q1wUD27+Ug4ZHJi77mj9U6VcMZ8JvXmw5iAH+GEyjTwI0gEVf7tBohfADiYCDPxgPEEFfC7Bl8uHjqrH9Ox1EOv9iU2z7MD77n8kBancJOmAvhb/pOU27E+wcFHEfGMy93+WTd/C0FXGjwIZpm/Q+crxWT8O9Xbbh5iQ/CGz8Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106997; c=relaxed/simple;
	bh=rW3/ZmHs2fRm7FIZkopMJSq3zwAO77/y5b4JNbD3MkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKAPjv354RXdZ1t7XXpn5lrIU/8vMK3Cp6nD8/FXzp/qKIVGWxBtWaV77Us88cZpFf7DnOcyiR4ldRBxaNNgrPdgnIkf7trZp4aBxLR3i4Kb2cZJyKTRcJDotwxN4/mdVF8BNdtlxxyO0aV/Pk+4A6qxWkLSj6pYey2cxi1eesM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lqrJNtlZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lqrJNtlZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SWIkgDOxwX7IC/MzoBlOjdflFJ62lF2bgSKwb8KckBM=; b=lqrJNtlZrRL1EH9PshG5yANKdd
	apYOarcPNPi7iUOfQc7imDe3QWk/SqvLtmjbzkynINosV0IIKrQigOFWrE5bUfl6ft41F0Y14US8k
	3JEEdyqT6SAoGBrNjsvdcHEzW6O2mWx8FXMdztWtIhm7r4qwOcy0VSxQOzhYnbBgaifn/bIpBQ7xX
	2jof4T3L59S0o8eYpFS9O9Y17L+ehtxOD7jE6DMDdjPD+RVDS3Y6HBcO+sYmCK5GZe1f0cQINnrjT
	NUOkIGKGINkzD9crOWz5Upqxkc43i2UwWLAzVY8fp2BN0rpIUEyvven6eRwOr2MH0wMOLFxY9AZZ9
	HVE3DLLg==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUC3-0000000FrTx-0r74;
	Thu, 01 May 2025 13:43:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH 15/15] xfs: test that we can handle spurious zone wp advancements
Date: Thu,  1 May 2025 08:42:52 -0500
Message-ID: <20250501134302.2881773-16-hch@lst.de>
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

From: Hans Holmberg <Hans.Holmberg@wdc.com>

Test that we can gracefully handle spurious zone write pointer
advancements while unmounted.

Any space covered by the wp unexpectedly moving forward should just
be treated as unused space, so check that we can still mount the file
system and that the zone will be reset when all used blocks have been
freed.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4214     | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4214.out |  2 ++
 2 files changed, 63 insertions(+)
 create mode 100755 tests/xfs/4214
 create mode 100644 tests/xfs/4214.out

diff --git a/tests/xfs/4214 b/tests/xfs/4214
new file mode 100755
index 000000000000..3e73a54614d5
--- /dev/null
+++ b/tests/xfs/4214
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 4214
+#
+# Test that we can gracefully handle spurious zone write pointer
+# advancements while unmounted.
+#
+
+. ./common/preamble
+_begin_fstest auto quick zone
+
+# Import common functions.
+. ./common/filter
+. ./common/zoned
+
+_require_scratch
+_require_zoned_device $SCRATCH_RTDEV
+_require_command "$BLKZONE_PROG" blkzone
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+
+test_file=$SCRATCH_MNT/test.dat
+dd if=/dev/zero of=$test_file bs=1M count=16 >> $seqres.full 2>&1 \
+	oflag=direct || _fail "file creation failed"
+
+_scratch_unmount
+
+#
+# Figure out which zone was opened to store the test file and where
+# the write pointer is in that zone
+#
+open_zone=$($BLKZONE_PROG report $SCRATCH_RTDEV | \
+	$AWK_PROG '/oi/ { print $2 }' | sed 's/,//')
+open_zone_wp=$($BLKZONE_PROG report $SCRATCH_RTDEV | \
+       	grep "start: $open_zone" | $AWK_PROG '{ print $8 }')
+wp=$(( $open_zone + $open_zone_wp ))
+
+# Advance the write pointer manually by one block
+dd if=/dev/zero of=$SCRATCH_RTDEV bs=$blksz count=1 seek=$(($wp * 512 / $blksz))\
+	oflag=direct >> $seqres.full 2>&1 || _fail "wp advancement failed"
+
+_scratch_mount
+_scratch_unmount
+
+# Finish the open zone
+$BLKZONE_PROG finish -c 1 -o $open_zone $SCRATCH_RTDEV
+
+_scratch_mount
+rm $test_file
+_scratch_unmount
+
+# The previously open zone, now finished and unused, should have been reset
+nr_open=$($BLKZONE_PROG report $SCRATCH_RTDEV | grep -wc "oi")
+echo "Number of open zones: $nr_open"
+
+status=0
+exit
diff --git a/tests/xfs/4214.out b/tests/xfs/4214.out
new file mode 100644
index 000000000000..a746546bc8f6
--- /dev/null
+++ b/tests/xfs/4214.out
@@ -0,0 +1,2 @@
+QA output created by 4214
+Number of open zones: 0
-- 
2.47.2

