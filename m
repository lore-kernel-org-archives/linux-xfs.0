Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EEA8472;
	Thu,  8 May 2025 05:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682523; cv=none; b=sfnO6L3MdDOtieYE3+Dnrcm/AiYYcDPEWNkfhHg+fry//GuRVgNnWQKswvQM8qU8kf0NRgKpvz7rnfM3SrKiPochRyKbUkeu05vlLFdmXTQk3uJ2ruSS+EEfQWxOq4ZCuX+NcjCakdiz9xIGMdHiWXzqIImPfbZfmBrbi1DhBGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682523; c=relaxed/simple;
	bh=oamQUtv6K/JSUuV64jb2X7Igvivq+xwY9r7O+3rkKC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWAm6zpfpeplVQflO68f33liNZE8nuoahUjAcYBLf10V3DlT002A9g7JR42xSVAobQzL5kc2ossVdeYG4Tivg9CKT6riA05KF9i5zHMFPL38/BR0OGy+nJDIKlEWHQwEV3+WKwHD3fLgXhSxmigx7paivxkVlDvkhdM6Y7kVuGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jig6831C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jig6831C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dpXwiR3x19ZT4/+UzPYPqBsS2eFqH+4vG6FGGb1Ck0I=; b=Jig6831CRdxtwYpH9SGyf3V5Dq
	bLhoXjkyHgoLhcGkhw8Q6QTimBGd2mR3m5/F1/z8cd65Fpg6CWb0JVHr6mrgdXeBr7G0m3n8jrwHQ
	k/AuJjVxOdZmSGyoISwYiCHiQbCRMmL+90LGSvitryyLW+vDu+NSfr5+XEZ885iw7RFTv23ldt3Yh
	IXE7DQDUjMnL3wZn7xzArwGQd7UeR3JdHREeaxAGFmsUi0WgzrCea/z53ZcqaLdhrpvnM0mSqe2WK
	XBzIlJFhBZlkMd4tXTurbIilqfy6qK8TI38c52jEGtLSR31hwIqNZt1Ws5rd2sRIhhzaXoG58vMH5
	JLFBLRUA==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtui-0000000HNhe-2l0s;
	Thu, 08 May 2025 05:35:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/16] xfs: add a test for write lifetime hints
Date: Thu,  8 May 2025 07:34:36 +0200
Message-ID: <20250508053454.13687-8-hch@lst.de>
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

Test that the zone allocator actually places by temperature bucket.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4205     | 90 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4205.out |  4 +++
 2 files changed, 94 insertions(+)
 create mode 100755 tests/xfs/4205
 create mode 100644 tests/xfs/4205.out

diff --git a/tests/xfs/4205 b/tests/xfs/4205
new file mode 100755
index 000000000000..3b05eb4e1dbf
--- /dev/null
+++ b/tests/xfs/4205
@@ -0,0 +1,90 @@
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
+. ./common/filter
+. ./common/xfs
+
+_require_scratch
+
+test_placement()
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
+	short_rg=`xfs_bmap -v $SCRATCH_MNT/short.1 | _filter_bmap_gno`
+	for i in `seq 2 100`; do
+		file=$SCRATCH_MNT/short.$i
+		rg=`xfs_bmap -v $file | _filter_bmap_gno`
+		if [ "${rg}" != "${short_rg}" ]; then
+			echo "short RG mismatch for file $i: $short_rg/$rg"
+		fi
+	done
+
+	# Check that all medium lifetime files are placed together,
+	# but not in the short RG
+	medium_rg=`xfs_bmap -v $SCRATCH_MNT/medium.1 | _filter_bmap_gno`
+	if [ "${medium}" == "${short_rg}" ]; then
+		echo "medium rg == short_rg"
+	fi
+	for i in `seq 2 100`; do
+		file=$SCRATCH_MNT/medium.$i
+		rg=`xfs_bmap -v $file | _filter_bmap_gno`
+		if [ "${rg}" != "${medium_rg}" ]; then
+			echo "medium RG mismatch for file $i: $medium_rg/$rg"
+		fi
+	done
+
+	# Check that none of the long lifetime files are colocated with
+	# short and medium ones
+	for i in `seq 1 100`; do
+		file=$SCRATCH_MNT/long.$i
+		rg=`xfs_bmap -v $file | _filter_bmap_gno`
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
+test_placement ""
+
+echo "Testing synchronous buffered I/O:"
+test_placement "-s"
+
+echo "Testing direct I/O:"
+test_placement "-d"
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

