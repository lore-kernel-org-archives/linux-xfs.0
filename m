Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371D72144A1;
	Thu,  8 May 2025 05:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682554; cv=none; b=L96hIRjYkOluUOb0YAAwDv1qeMcPahH29BNZ+Ec3cqUXY490rfe2+pGYx6/aTla8Arf3DqmKRXSv0DTNZmkpM/Pefh5g6A4+0qwrKAFNcxGFexe6wxd/3jIMgYVDiI5Fd+izrrjQNgwMj31nEShgB5k2qubImWyrhFr97G9LkPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682554; c=relaxed/simple;
	bh=yz7Ri7oNm+bS+tuRdh+hHGBpIafIKUIwSFYYjg5Yihs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRAjcpCBJCns0ehwAKTFQnQY8DRyqFWDyH8lKjhsYbLpyNtE+HvgILVTMhAwjj7N45uyN3bZOVqTKM3tADd7DmVzlu8gDv9qdt91+z/scrWkxjEjUXoxsHitChSj7a5df4d5paltha/Pbn1VycFC3io8H+QCngX9iCmCNuB/RY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P770NsSM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P770NsSM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fuJ4lOUn1vgz/IVQs4pyNiWwG6AzLXb1uLBxdSgcaBE=; b=P770NsSMN7BuVNEM3YOuGVyXSN
	SJ/0d7PRTE3pWiRHIKY6rTCR0nJbJtBjMW2d+vbnwI9hgoNBm6fxdWPNJtWnc45ldaQiJ5ixA2/n6
	acR3Gajd83JJV9dWCEkbONZCuPJhvAYPKFGpLXnx9RbM9/X61P2XxYfbmPNsaLTZCRVi011RsLhYX
	4v4SqsKUgUCHxQOFSNSC7ztED2a1wvzgoSaR0s6NhFX/6OWXTblTxOS9dSCGkTO/2Dy6DYvcs2Hdu
	WHbH3GKQd058fwxkoV3YzMx9kmCYolblX4mI6DrD167yRqleDxV1ml8/DshZpWfHQ1ts/C7l0sBbF
	96Or7sSA==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtvE-0000000HNpd-1TFD;
	Thu, 08 May 2025 05:35:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH 16/16] xfs: test that we can handle spurious zone wp advancements
Date: Thu,  8 May 2025 07:34:45 +0200
Message-ID: <20250508053454.13687-17-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508053454.13687-1-hch@lst.de>
References: <20250508053454.13687-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4214     | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4214.out |  2 ++
 2 files changed, 73 insertions(+)
 create mode 100755 tests/xfs/4214
 create mode 100644 tests/xfs/4214.out

diff --git a/tests/xfs/4214 b/tests/xfs/4214
new file mode 100755
index 000000000000..f5262a40b229
--- /dev/null
+++ b/tests/xfs/4214
@@ -0,0 +1,71 @@
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
+. ./common/zoned
+
+_require_scratch
+_require_realtime
+
+#
+# Figure out if the rt section is internal or not
+#
+if [ -z "$SCRATCH_RTDEV" ]; then
+	zdev=$SCRATCH_DEV
+else
+	zdev=$SCRATCH_RTDEV
+fi
+
+_require_zoned_device $zdev
+_require_command "$BLKZONE_PROG" blkzone
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+
+test_file=$SCRATCH_MNT/test.dat
+dd if=/dev/zero of=$test_file bs=1M count=16 oflag=direct >> $seqres.full 2>&1 \
+	|| _fail "file creation failed"
+
+_scratch_unmount
+
+#
+# Figure out which zone was opened to store the test file and where
+# the write pointer is in that zone
+#
+open_zone=$($BLKZONE_PROG report $zdev | \
+	$AWK_PROG '/oi/ { print $2 }' | sed 's/,//')
+open_zone_wp=$($BLKZONE_PROG report $zdev | \
+	grep "start: $open_zone" | $AWK_PROG '{ print $8 }')
+wp=$(( $open_zone + $open_zone_wp ))
+
+# Advance the write pointer manually by one block
+dd if=/dev/zero of=$zdev bs=$blksz count=1 seek=$(($wp * 512 / $blksz)) \
+	oflag=direct >> $seqres.full 2>&1 || _fail "wp advancement failed"
+
+_scratch_mount
+_scratch_unmount
+
+# Finish the open zone
+$BLKZONE_PROG finish -c 1 -o $open_zone $zdev
+
+_scratch_mount
+rm $test_file
+_scratch_unmount
+
+# The previously open zone, now finished and unused, should have been reset
+nr_open=$($BLKZONE_PROG report $zdev | grep -wc "oi")
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

