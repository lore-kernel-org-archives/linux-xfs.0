Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C225A8472;
	Thu,  8 May 2025 05:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682530; cv=none; b=NJ17Yenyrz6nb3iD1S9PEITWs7Oxpi6Eh+cXyM/mEFBcxq3wBpn1jhFF0eKaO3F5LSRHuMdSOVXhYMB4QNlGtW1GeLhdjSm6JxuRgu1v+PkHqtUyq6qVHxXUsVK2RCppt7/1/m+tIxESFVMEzChQ+4rlzX+bwLtf41CgooMJZlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682530; c=relaxed/simple;
	bh=IH0zRZPjHZGa9u7YkfJoaYP0YAbb7+v1ESCtVM1rxsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Az5xuV9dbJs02Co4/YFHr9l2pMGatEq/I5V5yerHxl3z7szMwLWfN1YZVTGX+y9RvGZGTaYDp5M0Rn+9g4AyBBdqFZip+xCcsV+auhOjywvO1GG9pV1xUQXAaiACRhYhkaY02wYHsLxhhKAixPVp40j5FjJmkkuDx6SYW2nElMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PTDVTE4C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PTDVTE4C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I3Bd+3nbnKWxBuq5Z2zSfg0S7X6tLsH4IAs8juHguTM=; b=PTDVTE4C1NjtNW4u84R2aiCrTz
	IeHDB57+fV1bHEhi/PuwaEQ+j8+gRNuprLOls/jzjc7n+bRbRGaQnIVrAeWPy6G9uSm+J9DT+Qs1Z
	fWndiVNQY4AM3hSgGikg++0OdI8mCR3wFca8mAK8QIc6KBqqdaW9hZDNfkuB/RC5ciI4/lW2L5bO6
	WW5KgqSRJHQp/Rif80OHu2jolywujP1Whv3q3qH5wiyugwkd4mT9V0jH6+qQqO+h4niLOeXYgBldk
	0hRvvH0MYj8OAJxYTxhcvKMrNRlqlefbYWuUsDK3CMT2yYLgzctDme3BhU/9AG4my3jeZ8jL/iwgB
	TkcXsZwA==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtuq-0000000HNjR-0H3z;
	Thu, 08 May 2025 05:35:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/16] xfs: test zone stream separation for two direct writers
Date: Thu,  8 May 2025 07:34:38 +0200
Message-ID: <20250508053454.13687-10-hch@lst.de>
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

Check that two parallel direct sequential writers are separated into
different zones.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4207     | 65 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4207.out |  3 +++
 2 files changed, 68 insertions(+)
 create mode 100755 tests/xfs/4207
 create mode 100644 tests/xfs/4207.out

diff --git a/tests/xfs/4207 b/tests/xfs/4207
new file mode 100755
index 000000000000..cb5a2bb1f9e2
--- /dev/null
+++ b/tests/xfs/4207
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4207
+#
+# Test that multiple direct I/O write streams are directed to separate zones.
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
+ioengine=libaio
+rw=write
+direct=1
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
diff --git a/tests/xfs/4207.out b/tests/xfs/4207.out
new file mode 100644
index 000000000000..5d33658de474
--- /dev/null
+++ b/tests/xfs/4207.out
@@ -0,0 +1,3 @@
+QA output created by 4207
+number of file 1 extents: 1
+number of file 2 extents: 1
-- 
2.47.2

