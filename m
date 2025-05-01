Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2911D7E37;
	Thu,  1 May 2025 13:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106992; cv=none; b=Fpi0SvRZpETyNF3gMSwPlMS/3CC0LZDfYoZtfka6dV9iQZPPoe8ENHZ7tp1cNHEf0BMZMXEsB5y/CScicemxouqRg6lhTeyVkYSIyTQN47lhFw843oimbsIZH8gnIgyQi3MASY+hz1n/OkY8QQPo3pHNFH5Q0A7kEZniIefp5Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106992; c=relaxed/simple;
	bh=ak6axSH0D5LjXIvPJiIwEjEjSDsuGRA3ZpeEBoiMGIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHy0wQTOrQUnqCMhUcvxcvSHMQ/QcyZNdNK0mfmNzkxaKk1hA0i01gDbRE+drvOM0GdK+FSIJDQLdcYAH9TjvDQ66ZQQt0uXaXgTLgBvhYwQRkb7eSnYbxlhwqrbkpN2Cp+8r7i8bKvqAFf806x8WsYuH0ctb6KeCq62ukvnAIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n0ZQBKcU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n0ZQBKcU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=x24VHD0O+kRRMhNxX3E8qpXvhxsIO1S+YvdnqzqHCfU=; b=n0ZQBKcUXZejFjgGHW5F++y2w4
	j+Snt2tB5MV5sFFGouAAn8tT2+KJjzppu3iY4pFAamkMt/9bWTKDtxPD5jYU6kG6s+yJV5531fCDL
	Cwj45ogDeHyRBx9t3rE/gtfBX9fDovWYCYZGc9bByDc3YCtdGXi4NdRqS5aVCMfaJQEo6wcEuyyTh
	+5jce7SwL7IIUt+f06hj/MNZSaSPZizSxpj6VRoTcfPlpJVMvRmyIgRB1dRVBK+/DSQW7wX7ct0sg
	CUDKpo7yBODRFyzEPKY4lFjExlyxqpR948pxMProrrtINraDD8GZVpxadLIyW1GEtGJjXk+JXfkLx
	BnWMmG8w==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUBy-0000000FrR0-10Dr;
	Thu, 01 May 2025 13:43:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/15] xfs: test zone stream separation for two buffered writers
Date: Thu,  1 May 2025 08:42:46 -0500
Message-ID: <20250501134302.2881773-10-hch@lst.de>
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

Check that two parallel buffered sequential writers are separated into
different zones when writeback happens before closing the files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4208     | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4208.out |  3 ++
 2 files changed, 82 insertions(+)
 create mode 100755 tests/xfs/4208
 create mode 100644 tests/xfs/4208.out

diff --git a/tests/xfs/4208 b/tests/xfs/4208
new file mode 100755
index 000000000000..b85105704b65
--- /dev/null
+++ b/tests/xfs/4208
@@ -0,0 +1,79 @@
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
+_cleanup()
+{
+	cd /
+	_scratch_unmount >/dev/null 2>&1
+}
+
+# Import common functions.
+. ./common/filter
+
+_require_scratch
+
+_filter_rgno()
+{
+	# the rg number is in column 4 of xfs_bmap output
+	perl -ne '
+		$rg = (split /\s+/)[4] ;
+		if ($rg =~ /\d+/) {print "$rg "} ;
+	'
+}
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

