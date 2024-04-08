Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AE174BE5;
	Mon,  8 Apr 2024 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583198; cv=none; b=os1qc73F9/3JpUzcCVtjbfwdCyrQ4Fhlbl86/XbXXiIQA4KFaLCYcC6lGarbvow3iNFAdyv4Pc4Fd0k4MTET4xfttrBN3efhrgU8VG45BccOY7PV9xP49SYJEuMoh4LpqU4tzbHnPgd+vZAO2MOsjU6KWtZorH4cbH3JaE7h6H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583198; c=relaxed/simple;
	bh=0atrBh/X+sVAjmELXLIJFn7ClyhTYL6kv2Zjt55bUds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZRaFCTvfOPr5uKSt/0lPOsG02BimkZO8ftyaUDmeqqZpfGy114ejGFFpaKFMw3xFjE9shs6X9KWlJlHJFfdDZRhjCvgW31OOHtC2b/+Jn76vYXBVcz0v+QTvQ/mb5zbUgj2M/cHZ9wNHIJx1Qgl8rfRO4pK/am6NXyS5yUsZW7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x8UPO9CY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x8UPO9CY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W3fRzgr7JsJHFjx7BvPT8eIm8aOsABy0x8QIT8+oQMY=; b=x8UPO9CYOxeXhGEJGjdp+1sMC+
	2DR4yUdHtUiq6anRc1m+zd0Bwf6R+IAmFTDNmID5hyG+UEdRrxg8OWsDGKjKlcj0Z7Qv5qarrhOlh
	lSBw0doGBPWjqSmVUMyFGUEGhaojhZtnYHio6JCFoOtNj2yF5iW3yUsB0MroKP8XNQgrQhq9+B6j5
	5OsjKz7bp3PDVuBzC686ir5MMPi2GccK1eXou4fg5HT0kpVGz2EzMj9R9X2320sK3migmkdg5Zv1A
	U8SzRmUUGChqTDPZGOPSwOCJHfCK4XpL8YoLmTFuseZ2hkz6fPDrHsrJFdD3DWYw7E4tFD4NUiMTQ
	coWERilQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtp7b-0000000FjVR-2o3b;
	Mon, 08 Apr 2024 13:33:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 6/6] xfs: don't run tests that require v4 file systems when not supported
Date: Mon,  8 Apr 2024 15:32:43 +0200
Message-Id: <20240408133243.694134-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240408133243.694134-1-hch@lst.de>
References: <20240408133243.694134-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a _require_xfs_nocrc helper that checks that we can mkfs and mount
a crc=0 file systems before running tests that rely on it to avoid failures
on kernels with CONFIG_XFS_SUPPORT_V4 disabled.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs    | 10 ++++++++++
 tests/xfs/002 |  1 +
 tests/xfs/045 |  1 +
 tests/xfs/095 |  1 +
 tests/xfs/132 |  1 +
 tests/xfs/148 |  2 ++
 tests/xfs/158 |  1 +
 tests/xfs/160 |  1 +
 tests/xfs/194 |  2 ++
 tests/xfs/199 |  1 +
 tests/xfs/300 |  1 +
 tests/xfs/513 |  1 +
 tests/xfs/526 |  1 +
 13 files changed, 24 insertions(+)

diff --git a/common/xfs b/common/xfs
index 49ca5a2d5..733c3a5be 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1852,3 +1852,13 @@ _xfs_discard_max_offset_kb()
 	$XFS_IO_PROG -c 'statfs' "$1" | \
 		awk '{g[$1] = $3} END {print (g["geom.bsize"] * g["geom.datablocks"] / 1024)}'
 }
+
+# check if mkfs and the kernel support nocrc (v4) file systems
+_require_xfs_nocrc()
+{
+	_scratch_mkfs_xfs -m crc=0 > /dev/null 2>&1 || \
+		_notrun "v4 file systems not supported"
+	_try_scratch_mount > /dev/null 2>&1 || \
+		_notrun "v4 file systems not supported"
+	_scratch_unmount
+}
diff --git a/tests/xfs/002 b/tests/xfs/002
index 8dfd2693b..26d0cd6e4 100755
--- a/tests/xfs/002
+++ b/tests/xfs/002
@@ -23,6 +23,7 @@ _begin_fstest auto quick growfs
 _supported_fs xfs
 _require_scratch_nocheck
 _require_no_large_scratch_dev
+_require_xfs_nocrc
 
 _scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs failed"
 
diff --git a/tests/xfs/045 b/tests/xfs/045
index d8cc9ac29..69531ba71 100755
--- a/tests/xfs/045
+++ b/tests/xfs/045
@@ -22,6 +22,7 @@ _supported_fs xfs
 
 _require_test
 _require_scratch_nocheck
+_require_xfs_nocrc
 
 echo "*** get uuid"
 uuid=`_get_existing_uuid`
diff --git a/tests/xfs/095 b/tests/xfs/095
index a3891c85e..e7dc3e9f4 100755
--- a/tests/xfs/095
+++ b/tests/xfs/095
@@ -19,6 +19,7 @@ _begin_fstest log v2log auto
 _supported_fs xfs
 _require_scratch
 _require_v2log
+_require_xfs_nocrc
 
 if [ "$(blockdev --getss $SCRATCH_DEV)" != "512" ]; then
 	_notrun "need 512b sector size"
diff --git a/tests/xfs/132 b/tests/xfs/132
index ee1c8c1ec..b46d3d28c 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -19,6 +19,7 @@ _supported_fs xfs
 
 # we intentionally corrupt the filesystem, so don't check it after the test
 _require_scratch_nocheck
+_require_xfs_nocrc
 
 # on success, we'll get a shutdown filesystem with a really noisy log message
 # due to transaction cancellation.  Hence we don't want to check dmesg here.
diff --git a/tests/xfs/148 b/tests/xfs/148
index c9f634cfd..72d05f12f 100755
--- a/tests/xfs/148
+++ b/tests/xfs/148
@@ -27,6 +27,8 @@ _cleanup()
 _supported_fs xfs
 _require_test
 _require_attrs
+_require_xfs_nocrc
+
 _disable_dmesg_check
 
 imgfile=$TEST_DIR/img-$seq
diff --git a/tests/xfs/158 b/tests/xfs/158
index 4440adf6e..0107fa3d6 100755
--- a/tests/xfs/158
+++ b/tests/xfs/158
@@ -18,6 +18,7 @@ _supported_fs xfs
 _require_scratch_xfs_inobtcount
 _require_command "$XFS_ADMIN_PROG" "xfs_admin"
 _require_xfs_repair_upgrade inobtcount
+_require_xfs_nocrc
 
 # Make sure we can't format a filesystem with inobtcount and not finobt.
 _scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
diff --git a/tests/xfs/160 b/tests/xfs/160
index 399fe4bcf..134b38a18 100755
--- a/tests/xfs/160
+++ b/tests/xfs/160
@@ -18,6 +18,7 @@ _supported_fs xfs
 _require_command "$XFS_ADMIN_PROG" "xfs_admin"
 _require_scratch_xfs_bigtime
 _require_xfs_repair_upgrade bigtime
+_require_xfs_nocrc
 
 date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
 	_notrun "Userspace does not support dates past 2038."
diff --git a/tests/xfs/194 b/tests/xfs/194
index 5a1dff5d2..2ef9403bb 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -30,6 +30,8 @@ _supported_fs xfs
 # real QA test starts here
 
 _require_scratch
+_require_xfs_nocrc
+
 _scratch_mkfs_xfs >/dev/null 2>&1
 
 # For this test we use block size = 1/8 page size
diff --git a/tests/xfs/199 b/tests/xfs/199
index 4669f2c3e..f99b04db3 100755
--- a/tests/xfs/199
+++ b/tests/xfs/199
@@ -26,6 +26,7 @@ _cleanup()
 _supported_fs xfs
 
 _require_scratch
+_require_xfs_nocrc
 
 # clear any mkfs options so that we can directly specify the options we need to
 # be able to test the features bitmask behaviour correctly.
diff --git a/tests/xfs/300 b/tests/xfs/300
index 2ee5eee71..bc1f0efc6 100755
--- a/tests/xfs/300
+++ b/tests/xfs/300
@@ -13,6 +13,7 @@ _begin_fstest auto fsr
 . ./common/filter
 
 _require_scratch
+_require_xfs_nocrc
 
 # real QA test starts here
 
diff --git a/tests/xfs/513 b/tests/xfs/513
index ce2bb3491..42eceeb90 100755
--- a/tests/xfs/513
+++ b/tests/xfs/513
@@ -37,6 +37,7 @@ _fixed_by_kernel_commit 237d7887ae72 \
 _require_test
 _require_loop
 _require_xfs_io_command "falloc"
+_require_xfs_nocrc
 
 LOOP_IMG=$TEST_DIR/$seq.dev
 LOOP_SPARE_IMG=$TEST_DIR/$seq.logdev
diff --git a/tests/xfs/526 b/tests/xfs/526
index 4261e8497..188d0d514 100755
--- a/tests/xfs/526
+++ b/tests/xfs/526
@@ -26,6 +26,7 @@ _supported_fs xfs
 _require_test
 _require_scratch_nocheck
 _require_xfs_mkfs_cfgfile
+_require_xfs_nocrc
 
 cfgfile=$TEST_DIR/a
 rm -rf $cfgfile
-- 
2.39.2

