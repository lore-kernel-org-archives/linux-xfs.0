Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFA78472;
	Thu,  8 May 2025 05:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682533; cv=none; b=iXfK3ImFyux/AL9skM1efSRk3f4/JYk3iA3EkMynYSRNoO40mbBNWNIe5fERCp1kjYfNwLGbzdKDTfBOcJgW2HdD9dJ+1KmEDCNfqS/YdON6fcUXzFxY9RJpaMLIJwoBwbQddm5H8Ltvis9m5j2dd48Jdh7r6oF2T0+SpYqr68o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682533; c=relaxed/simple;
	bh=NiJ4b9EqPTugS3IyZvKD6EtC+cxdhsLr0r8ewvcczpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCWr+dN4q+HwW1qAh6CN7wPuBu/FEY/o7L7YTuU9AaP1iWDMDd1D5TPEZeoDXQWUa9eZIKNlPqFSm/3NbOrKtNQZmYRNHZ9eltZWOZezbr1dUScpKWO2Mw2OOG/dzW8DQhBjrvfT9+hoB1Jvkn3xNbjdIa4ILM+wE+1n7/EoDh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xX6WPGe9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xX6WPGe9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oxCPpiqjJih5tWfNklV4V84xlRgcXKiVgUlWMMLvbjA=; b=xX6WPGe9D/GMDx5TwbyJjoJOUq
	dQpbVVDY+VhS4/nl39oCXtfNAhX4shrIffCN6A8UbfLNEz4wh19fVrT32J9SLNZZd/JqN7c2Neaw8
	98YX0Oc4ytd0pcNBcY0uz/dnQkeWfIFVhNasBBvWFbRgZoIFEFb9mGlU4+Uq3Ham6Dsw04E4D5x18
	Tvb878YDMKeAxQqT4oOZ8vv8ySNPW+to5ZR81zdx7Ye0L2xlgA56q9vyH9qTOwv2/VHfdzqHdu08B
	m9aCRTh4UHUkXmusDsQSyMzAMCgUccecZCiDP6t5WQpmuJ9NQ9CZDYKpzLk/GPuOYerq/j9zePdoP
	Q4atHTvg==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtut-0000000HNk8-0kOe;
	Thu, 08 May 2025 05:35:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/16] xfs: test zone stream separation for two buffered writers
Date: Thu,  8 May 2025 07:34:39 +0200
Message-ID: <20250508053454.13687-11-hch@lst.de>
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

Check that two parallel buffered sequential writers are separated into
different zones when writeback happens before closing the files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4208     | 65 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4208.out |  3 +++
 2 files changed, 68 insertions(+)
 create mode 100755 tests/xfs/4208
 create mode 100644 tests/xfs/4208.out

diff --git a/tests/xfs/4208 b/tests/xfs/4208
new file mode 100755
index 000000000000..b67422b5bbc0
--- /dev/null
+++ b/tests/xfs/4208
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4208
+#
+# Test that multiple buffered I/O write streams are directed to separate zones
+# when written back with the file still open.
+#
+. ./common/preamble
+_begin_fstest quick auto rw zone
+
+. ./common/xfs
+
+_require_scratch
+_require_odirect
+_require_aio
+
+_scratch_mkfs_xfs >>$seqres.full 2>&1
+_scratch_mount
+_require_xfs_scratch_zoned 3
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
+size=1m
+directory=$SCRATCH_MNT
+rw=write
+fsync_on_close=1
+
+[file1]
+filename=file1
+size=128m
+
+[file2]
+filename=file2
+size=128m
+EOF
+
+_require_fio $fio_config
+
+$FIO_PROG $fio_config --output=$fio_out
+cat $fio_out >> $seqres.full
+
+# Check the files only have a single extent each and are in separate zones
+extents1=$(_count_extents $SCRATCH_MNT/file1)
+extents2=$(_count_extents $SCRATCH_MNT/file2)
+
+echo "number of file 1 extents: $extents1"
+echo "number of file 2 extents: $extents2"
+
+rg1=`xfs_bmap -v $SCRATCH_MNT/file1 | _filter_bmap_gno`
+rg2=`xfs_bmap -v $SCRATCH_MNT/file2 | _filter_bmap_gno`
+if [ "${rg1}" == "${rg2}" ]; then
+	echo "same RG used for both files"
+fi
+
+status=0
+exit
diff --git a/tests/xfs/4208.out b/tests/xfs/4208.out
new file mode 100644
index 000000000000..1aaea308fe6a
--- /dev/null
+++ b/tests/xfs/4208.out
@@ -0,0 +1,3 @@
+QA output created by 4208
+number of file 1 extents: 1
+number of file 2 extents: 1
-- 
2.47.2

