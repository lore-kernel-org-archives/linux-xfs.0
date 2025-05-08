Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8326B8472;
	Thu,  8 May 2025 05:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682543; cv=none; b=e4/bfxGbuZ5y6LzQ6QGVc77Sqpd99wLkypn8F+GDH7dst71mlLy8WPeo91yAufa9pM81tYuNi/A2cgv+aiwgaRLzulD8kTPUbA7o7XPuQ8sF9VQ6xca1N4K8q/4R+5IQq1hgLGjy3aEMcfdnZWg7FY7G7AE7q41vrzXsVAmsHhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682543; c=relaxed/simple;
	bh=63UC66cHUxY302sBFQRGITh9q52LjN84Ur45p5yQD0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiegAwu8rng62t5zR5ey6OF3hE7CtriAtHsEBeDwoPs2vkQOoxYdoAX5y4T1Seh9Rgl2TwpHG1GZXntqjWX5iR7sHhSqG2kg6kPMZp5btktNdBqZzwZvaIx7hzI1KewVd94yunatEjDfV4ecXmhLB5GoQF03vPgipRoAkbsE1mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pJsQ6VDr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pJsQ6VDr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PDs25tgaPtLkj5DKp3OR+AtBvxLt6k+bO1VlrFLqsA4=; b=pJsQ6VDrkhB991C7jGsC2RQ6M8
	uWKVz05TDGqIGTaCkE1brlIPeApqlH/RpCQxsQXpxCditDgufw78qdQ+ELYHKLihRSNUhnwA1DRe2
	FFiM73f6fMpylZrssaQizMMbRkhdITlm5tvytnF1A1vXXH+BteLgxDEXarFm7ShRMQtStdDaI2qxx
	+QytJYz3/Io9Q9NDm3L/NVEjex3CwAfwS0aTWeM6bP+rHH7jCFDDMVLsp/osW5paWVxxLRK4X38sV
	OOKlO3/hbiTL12CBflWsERbbjIUFhfUhsoeMeecjHf/3cj+wVLm9sQb+KBEl++W3w9ckGLf7nShFH
	231ozKFA==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtv3-0000000HNmc-2j5M;
	Thu, 08 May 2025 05:35:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/16] xfs: test zoned GC file defragmentation for random writers
Date: Thu,  8 May 2025 07:34:42 +0200
Message-ID: <20250508053454.13687-14-hch@lst.de>
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

Test that zoned GC defragments sequential writers forced into the same
zone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4211     | 124 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4211.out |   5 ++
 2 files changed, 129 insertions(+)
 create mode 100755 tests/xfs/4211
 create mode 100644 tests/xfs/4211.out

diff --git a/tests/xfs/4211 b/tests/xfs/4211
new file mode 100755
index 000000000000..2b88e3bc3730
--- /dev/null
+++ b/tests/xfs/4211
@@ -0,0 +1,124 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4211
+#
+# Test that GC defragments randomly written files.
+#
+. ./common/preamble
+_begin_fstest auto rw zone
+
+. ./common/filter
+. ./common/zoned
+
+_require_scratch
+_require_odirect
+_require_aio
+
+_scratch_mkfs_sized $((256 * 1024 * 1024))  >>$seqres.full 2>&1
+
+# limit to two max open zones so that all writes get thrown into the blender
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
+_try_scratch_mount || _notrun "mount option not supported"
+_require_xfs_scratch_zoned
+
+fio_config=$tmp.fio
+fio_out=$tmp.fio.out
+fio_err=$tmp.fio.err
+
+cat >$fio_config <<EOF
+[global]
+bs=64k
+iodepth=16
+iodepth_batch=8
+directory=$SCRATCH_MNT
+ioengine=libaio
+rw=randwrite
+direct=1
+size=30m
+
+[file1]
+filename=file1
+
+[file2]
+filename=file2
+
+[file3]
+filename=file3
+
+[file4]
+filename=file4
+
+[file5]
+filename=file5
+
+[file6]
+filename=file6
+
+[file7]
+filename=file7
+
+[file8]
+filename=file8
+EOF
+
+_require_fio $fio_config
+
+# create fragmented files
+$FIO_PROG $fio_config --output=$fio_out
+cat $fio_out >> $seqres.full
+
+# fill up all remaining user capacity
+dd if=/dev/zero of=$SCRATCH_MNT/fill bs=4k >> $seqres.full 2>&1
+
+sync
+
+# all files should be badly fragmented now
+extents2=$(_count_extents $SCRATCH_MNT/file2)
+echo "number of file 2 extents: $extents2" >>$seqres.full
+test $extents2 -gt 200 || _fail "fio did not fragment file"
+
+extents4=$(_count_extents $SCRATCH_MNT/file4)
+echo "number of file 4 extents: $extents4" >>$seqres.full
+test $extents4 -gt 200 || _fail "fio did not fragment file"
+
+extents6=$(_count_extents $SCRATCH_MNT/file6)
+echo "number of file 6 extents: $extents6" >>$seqres.full
+test $extents6 -gt 200 || _fail "fio did not fragment file"
+
+extents8=$(_count_extents $SCRATCH_MNT/file8)
+echo "number of file 8 extents: $extents8" >>$seqres.full
+test $extents8 -gt 200 || _fail "fio did not fragment file"
+
+# remove half of the files to create work for GC
+rm $SCRATCH_MNT/file1
+rm $SCRATCH_MNT/file3
+rm $SCRATCH_MNT/file5
+rm $SCRATCH_MNT/file7
+
+#
+# Fill up all remaining user capacity a few times to force GC.
+#
+# This needs to be a very large number of larger zones sizes that have a lot
+# of OP for the small file system size
+#
+for i in `seq 1 200`; do
+	dd if=/dev/zero of=$SCRATCH_MNT/fill bs=4k >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/fill >> $seqres.full 2>&1
+done
+
+#
+# All files should have a no more than a handful of extents now
+#
+extents2=$(_count_extents $SCRATCH_MNT/file2)
+_within_tolerance "file 2 extents" $extents2 3 2 -v
+extents4=$(_count_extents $SCRATCH_MNT/file4)
+_within_tolerance "file 4 extents" $extents4 3 2 -v
+extents6=$(_count_extents $SCRATCH_MNT/file6)
+_within_tolerance "file 6 extents" $extents6 3 2 -v
+extents8=$(_count_extents $SCRATCH_MNT/file8)
+_within_tolerance "file 8 extents" $extents8 3 2 -v
+
+status=0
+exit
diff --git a/tests/xfs/4211.out b/tests/xfs/4211.out
new file mode 100644
index 000000000000..348e59950a47
--- /dev/null
+++ b/tests/xfs/4211.out
@@ -0,0 +1,5 @@
+QA output created by 4211
+file 2 extents is in range
+file 4 extents is in range
+file 6 extents is in range
+file 8 extents is in range
-- 
2.47.2

