Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AC91DE4F1;
	Wed,  7 May 2025 05:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594801; cv=none; b=TnDw3YHgXCz27wgerrns+4+YFM+ukUODkvYSFHdqy3i5RdKzZSaPrdClx/CPYJpTNsV85LmyMTY9tMCR51xUxqQWTLLPeSWpYDxZWs/TyaVmQL7XQVwd9A3n9pUSeAFe7emLzc1IrIYxFMMg1E8ZwBHw5oxbhpTIv4Rga6XcFVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594801; c=relaxed/simple;
	bh=gfl/47be/ErCgpomadc5HUPifKUxaY6nO1J/aoGGb8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7rRW4LMPaIgln3FbC9K5/OBucJ/zXCmH5guzL/NqEIMzNbb0aldETdkiZlxJxavRs+YNFdbsc/u3vcnL1zKQeGuGezJyVpUPz1UTIptgtLOGmtT6LwHjEQEKsRibr14UIb2dVwSOrd+ECLBU7PvL/AE3fEFtYz2tP4AcKDgDww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=byq6mXgY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="byq6mXgY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=f+UTbSIejU0t8XDxAf73UkmrQ1JLza47CbeYOps/Mnc=; b=byq6mXgYl03oeOc1NxUruWPaRg
	fiKvGdTRY5nzInsFoI/PpbFkGvdq1QN9g7iybYmY8p2PDqqAYPK2xfbxubS+lQY95Ek+IwGlWG6pN
	G1SoE4EUqTOish8fMrjlwUlFnyWnSRve2okBkT3YDdMlNY22AcAJ6OREGohoDTVbP/aq9pqav2LNz
	0gVfu6KTW/YnAcmYD7qrNjZFg43eAfTpV5SKk4jLFRly+WyNTKVWG71BiiPk+pzMyTY0odpLnzCPS
	f63py/Q1PoGl+iLEUC51VPPToaiWR5opqD8hiybdcFMqMlqqolS5+xN2WHfHIVI4PSsrAL1q3c+xJ
	Ph8xYDLw==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5r-0000000EEy1-2QDG;
	Wed, 07 May 2025 05:13:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/15] xfs: test zone stream separation for two direct writers
Date: Wed,  7 May 2025 07:12:29 +0200
Message-ID: <20250507051249.3898395-10-hch@lst.de>
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
index 000000000000..e55d04f795ce
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
+rg1=`xfs_bmap -v $SCRATCH_MNT/file1 | _filter_rgno`
+rg2=`xfs_bmap -v $SCRATCH_MNT/file2 | _filter_rgno`
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

