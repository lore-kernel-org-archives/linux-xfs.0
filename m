Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC70D8472;
	Thu,  8 May 2025 05:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682540; cv=none; b=jyzdNTqF9UiuWVIVUWDPTl9LoPZu1RY2pL4pz1eiLdZgPXPulwVlhMcuWgTxu4shecN0OZcGuT59IGPCZ5TT6yh8gFJRXgsO/0P8AICE3YDS5RGB+ID+FA2lesRE+aJIEN0BwdOqcfdkDYrgDy8Wcu4/ajSkxODlHsUZTnF31Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682540; c=relaxed/simple;
	bh=8ZPRBhi201bbQd2tQHwSQBbypWZq37P7hLvhJClatRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FazHDnHqy9Ax/MHH9D5ipkZ6trBd8ZnTjYY30t4PAr+ky7t+h/7l4z7Bl4CeR0NoJO/OGEnVueKFQka4mhGCHwtxFHWO012Z2Fa/7F2bn21bKPtwKydQbK65jrcKC2RKDG0u2VogRkYKxtnthEA8G87ChJfSHoKbn5j9ViWHBAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N7IN3BTm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N7IN3BTm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t084nobxxp7mmp81G2G5vHNUkRJ9LmrJCusMYoT2O2Y=; b=N7IN3BTmSdPGUtjnPoSqmNRTJr
	7cOJCxntNkn+biHmqPJR5Y5EflD+wWT4ToQYEoJcx0SOL0Gy8PjCDQsRo3F3f3tjKY7k56viDeWCG
	MILrX/osb8aDbxkiHvGDPEMY543o1eKduXc5dGK7JptqkIThqNQvE634BZITRl6ILQ6YiM2Ahwg/z
	hK9meM1txUkDA10FLG3xy5z+l+ZJ9Ra6a6y7ZVW4y4EyBei9ET0JY58WGw5Qn8DhOGpcJ7Akh9g25
	Ain0Re5BoJD9ULnEcbxHns8K176BsWXGCEkZBK3ezbKnj3ByNA/S2B/VP1qlJ7fNAT0RwJG3ZB/BY
	AUew9Enw==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtuz-0000000HNm4-41X2;
	Thu, 08 May 2025 05:35:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/16] xfs: test zoned GC file defragmentation for sequential writers
Date: Thu,  8 May 2025 07:34:41 +0200
Message-ID: <20250508053454.13687-13-hch@lst.de>
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
 tests/xfs/4210     | 119 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4210.out |   5 ++
 2 files changed, 124 insertions(+)
 create mode 100755 tests/xfs/4210
 create mode 100644 tests/xfs/4210.out

diff --git a/tests/xfs/4210 b/tests/xfs/4210
new file mode 100755
index 000000000000..3311f5365c9f
--- /dev/null
+++ b/tests/xfs/4210
@@ -0,0 +1,119 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4210
+#
+# Test that GC defragments sequentially written files.
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
+rw=write
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
+# fill up all remaining user capacity a few times to force GC
+for i in `seq 1 10`; do
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
diff --git a/tests/xfs/4210.out b/tests/xfs/4210.out
new file mode 100644
index 000000000000..488dd9db790b
--- /dev/null
+++ b/tests/xfs/4210.out
@@ -0,0 +1,5 @@
+QA output created by 4210
+file 2 extents is in range
+file 4 extents is in range
+file 6 extents is in range
+file 8 extents is in range
-- 
2.47.2

