Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6751DE3A7;
	Wed,  7 May 2025 05:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594805; cv=none; b=E3aPj1Ms+7laGy5MZBIRtZN894PnYoFgnJNrgUfR1f7D/wM67ydAnh3SEX7l6TbvTVXO9GSG8duiICCqcM8B4Oxqp+O/KrQ3+mA/Xmf8meXziU9G5D49BW4ixLYPCA1JW9zm9wXjc6IliHsnmcYp/7mRYUvaYXKHgkl1BSBvBnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594805; c=relaxed/simple;
	bh=OaLwN9d18BHsM13hVt05hs6rWfAswNrHrTgoixUuKrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqIyFRDXkzOXjWm23PxPFQO1zBOps7vO48jcWoSsIXoYzN4bSc5NuIEdikVqVg3MKPH2B/nZHV/of56VbYq3yLEbqH/PCW3TpZLSpgS2n/Hb2nLHM+nN/2WFdOE/QUJjgOmTPWq1X/U6bk+S0RTLBVzcq5jED4sK2zz3zAH5avY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yJuyldw9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yJuyldw9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vQLwqwo1yr8JONAHnHc77yPI/JvyBdjiMqH+OP7IlIY=; b=yJuyldw9jX1d9DFx56GzL2y9YA
	YCyctmIPYO9dO8s3EBjKy+E/mhEG7FVmrv0Dtg0uNaCxY5A3xFRsXsDX5hBQ161VoO9im6Cb+6XUZ
	TFjfQkQlw8njExiCmUeU7B+EfOoQrBWXCW9eT8jJfpoV8DO5v0OcnAnHQzFhFGUneDj+WdyuMiaQT
	UEycZSVqtXrcEH/aJnhOVqKNbleABaSbMuxYemzl8NiaWEa1JmLqexaRfjc+2Sizos6RxN5bmfDZ0
	S1LgP3lkvwxhovXWKVbaDTNcHZSPgUfZL/Ota7/r3dqSTBsaQtHggDd8X81q+lYJsFxmwjVWfB1p3
	tg195eFQ==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5u-0000000EEzA-40Ih;
	Wed, 07 May 2025 05:13:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/15] xfs: test zone stream separation for two buffered writers
Date: Wed,  7 May 2025 07:12:30 +0200
Message-ID: <20250507051249.3898395-11-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507051249.3898395-1-hch@lst.de>
References: <20250507051249.3898395-1-hch@lst.de>
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
index 000000000000..ce490afd4dde
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
+rg1=`xfs_bmap -v $SCRATCH_MNT/file1 | _filter_rgno`
+rg2=`xfs_bmap -v $SCRATCH_MNT/file2 | _filter_rgno`
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

