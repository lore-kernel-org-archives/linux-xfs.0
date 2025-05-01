Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ED11C860B;
	Thu,  1 May 2025 13:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106990; cv=none; b=rpsKuBPLpNkTLKOFwI9m3QwVR0dazYnVoDZtKPU1XQObxsQz+3zXLYOZYkXGcBObV/vX/ao9Ep6bWSR1lfTHTWI+STRCCityHwUn6ok5VDRxrBsphRkA67+kz+PVbQd+tnPlJSMywT1kl7oXwxSd7zvLrxLIpjDVL5Bdnz1BCnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106990; c=relaxed/simple;
	bh=qDaI/hU7kVsV36c2Z8oTel4ZzyzfCZQL1/Lk8cYlUnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMssHSUOJPw/optuegl55jnXZbRSrBJzFnZfO+f4AD16MV/dXRGTsXFXsI1iI4frEgHzQz3sS9R+zur35bnjqVHqsc0H+MHH6UEm7eHLhiraPhecLOiF0208jEd2JdWkqI4/c5at9XwKxuqmoKz9bVV8tbInY5mTZvhCfwgObWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Txs8inWr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Txs8inWr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UVZ5n3yrVQt/gMC2VUjMh/WPQyiFwd2GHNU9U1LHOhY=; b=Txs8inWrJILDbEKEjDMW6llnLX
	bSQ9QN01CU32NUe/Zu17xC7zASjETRGFQjBuRw7yu7nBTH5n7W7QsW3cs0bcV9Frgoi+AWm0kinjO
	xh5UL4tetIQDrl/wQQKNX5Z1WM0wBC94ZC0I+jVA13u4kZmMxDtUVJkqxhtjrs0ghek0RMMJ0h/uD
	xwww/SkjoQjr79+rzVRO6xf3S236jCY5h39zzQY3zZ03Nx/GdMMAx7W7ySPNJlm4vjMDI6fsXk/Gl
	WcOnUmeLziVsCMKb+c7+Z8CFTJE65F1ULVxQiTHOk9x+z97DDh7zEAz7z4KmoSAR16LHRcUj1BCHA
	iXTAiwpA==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUBv-0000000FrQL-37rL;
	Thu, 01 May 2025 13:43:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/15] xfs: add a test for write lifetime hints
Date: Thu,  1 May 2025 08:42:43 -0500
Message-ID: <20250501134302.2881773-7-hch@lst.de>
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

Test that the zone allocator actually places by temperature bucket.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4205     | 105 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4205.out |   4 ++
 2 files changed, 109 insertions(+)
 create mode 100755 tests/xfs/4205
 create mode 100644 tests/xfs/4205.out

diff --git a/tests/xfs/4205 b/tests/xfs/4205
new file mode 100755
index 000000000000..be508806ec0a
--- /dev/null
+++ b/tests/xfs/4205
@@ -0,0 +1,105 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4205
+#
+# Test data placement by write hints.
+#
+. ./common/preamble
+_begin_fstest auto rw zone
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
+_test_placement()
+{
+	xfs_io_opts=$1
+
+	_scratch_mkfs_xfs >>$seqres.full 2>&1
+	_scratch_mount
+	_require_xfs_scratch_zoned 3
+
+	# Create a bunch of files for the three major temperature buckets
+	for i in `seq 1 100`; do
+		for hint in "short" "medium" "long"; do
+			file=$SCRATCH_MNT/$hint.$i
+
+			touch $file
+			$here/src/rw_hint $file $hint
+			$XFS_IO_PROG ${xfs_io_opts} \
+				-c 'pwrite 0 1m' \
+				$file >>$seqres.full
+		done
+	done
+
+	sync
+
+	# Check that all short lifetime files are placed together
+	short_rg=`xfs_bmap -v $SCRATCH_MNT/short.1 | _filter_rgno`
+	for i in `seq 2 100`; do
+		file=$SCRATCH_MNT/short.$i
+		rg=`xfs_bmap -v $file | _filter_rgno`
+		if [ "${rg}" != "${short_rg}" ]; then
+			echo "short RG mismatch for file $i: $short_rg/$rg"
+		fi
+	done
+
+	# Check that all medium lifetime files are placed together,
+	# but not in the short RG
+	medium_rg=`xfs_bmap -v $SCRATCH_MNT/medium.1 | _filter_rgno`
+	if [ "${medium}" == "${short_rg}" ]; then
+		echo "medium rg == short_rg"
+	fi
+	for i in `seq 2 100`; do
+		file=$SCRATCH_MNT/medium.$i
+		rg=`xfs_bmap -v $file | _filter_rgno`
+		if [ "${rg}" != "${medium_rg}" ]; then
+			echo "medium RG mismatch for file $i: $medium_rg/$rg"
+		fi
+	done
+
+	# Check that none of the long lifetime files are colocated with
+	# short and medium ones
+	for i in `seq 1 100`; do
+		file=$SCRATCH_MNT/long.$i
+		rg=`xfs_bmap -v $file | _filter_rgno`
+		if [ "${rg}" == "${short_rg}" ]; then
+			echo "long file $i placed into short RG "
+		fi
+		if [ "${rg}" == "${medium_rg}" ]; then
+			echo "long file $i placed into medium RG"
+		fi
+	done
+
+	_scratch_unmount
+}
+
+echo "Testing buffered I/O:"
+_test_placement ""
+
+echo "Testing synchronous buffered I/O:"
+_test_placement "-s"
+
+echo "Testing direct I/O:"
+_test_placement "-d"
+
+status=0
+exit
diff --git a/tests/xfs/4205.out b/tests/xfs/4205.out
new file mode 100644
index 000000000000..3331e361a36d
--- /dev/null
+++ b/tests/xfs/4205.out
@@ -0,0 +1,4 @@
+QA output created by 4205
+Testing buffered I/O:
+Testing synchronous buffered I/O:
+Testing direct I/O:
-- 
2.47.2

