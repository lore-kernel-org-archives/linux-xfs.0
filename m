Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73A657887;
	Thu, 28 Mar 2024 12:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711628276; cv=none; b=IxVLLdtJZWEYNFb01FbVO5NZnhzgX0kTdguZibc2atSU1nNFCnrw71yWQ2X3vWWCAJxph2huZAAhqkwz6EZaCvZN6XiX1HmRFgeaCl3RhY0FQOcXr2GrT97AnyFv10nd308PB0mi1LehxoxCoCjXEZmsw6FTVlu/itoQdIQ6kts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711628276; c=relaxed/simple;
	bh=4YBQQyYuqNCOgcMkuqoqHnXPT99Jmu7JOUKYG3Neg7c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jyIPIBBiCxo7eK+O1zAVUTLioCV6u8RlBbxg7yrff/45zceJ4tymxfODDoBVcp/19iHhO7ShXJq9rhCyEzATD51m6M26t4euyw9bzQXaobKCbmgOMEoEuZGC5OTHXPmeq7XdPdFXqJNcC5BAbyTLNnZ0uYGPQ1Y93HZPs2gZjKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M0JxAFAA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M0JxAFAA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=fYcVsvzSzgRT2hWUN2C8LYLHIN23HduZRyNulyjglkc=; b=M0JxAFAAOaz0uu7FD2N3JJ2qQ2
	JapPLRvaDvhIt1K//kXHgwIFhuHgHKIw32ikngguskFJcoKCxsv9EZBk+A4l8RYpPbcfLygnF3Te0
	cHlyoQ4EQKG664XPSanGF0oIPpHNLrmmrbF62K2fx+0MC0B3nU7won0361zwQa/IbUixnpSMfCj7h
	qYI8dwso6l7xOQzDriPJKUj0IaCZ6ugumMEoE5bIJmKGeP1TMOzUONY+DfP1hN2k50z+L+5fFv3gl
	JCftAMaboIRW1fzFmbdfwG54HQmtWPyYmgDCE9q7y5bfs8PLkxjf7gR+5kHvKB/ZTDh+F/uycXdXS
	FMaDedyw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpohc-0000000Dryh-3nOE;
	Thu, 28 Mar 2024 12:17:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs: don't run tests that require v4 file systems when not supported
Date: Thu, 28 Mar 2024 13:17:49 +0100
Message-Id: <20240328121749.15274-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
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
 tests/xfs/002 |  4 +---
 tests/xfs/045 |  1 +
 tests/xfs/095 |  1 +
 tests/xfs/132 |  3 ++-
 tests/xfs/148 |  2 +-
 tests/xfs/158 |  1 +
 tests/xfs/160 |  1 +
 tests/xfs/194 |  2 ++
 tests/xfs/199 |  1 +
 tests/xfs/263 |  1 +
 tests/xfs/513 |  1 +
 tests/xfs/522 |  1 +
 tests/xfs/526 |  1 +
 14 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/common/xfs b/common/xfs
index 65b509691..5da6987b2 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1887,3 +1887,13 @@ _xfs_discard_max_offset_kb()
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
index 6c0bb4d04..26d0cd6e4 100755
--- a/tests/xfs/002
+++ b/tests/xfs/002
@@ -23,9 +23,7 @@ _begin_fstest auto quick growfs
 _supported_fs xfs
 _require_scratch_nocheck
 _require_no_large_scratch_dev
-
-# So we can explicitly turn it _off_:
-_require_xfs_mkfs_crc
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
index fa36c09c2..1b8de82f5 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -19,12 +19,13 @@ _supported_fs xfs
 
 # we intentionally corrupt the filesystem, so don't check it after the test
 _require_scratch_nocheck
+_require_xfs_nocrc
 
 # on success, we'll get a shutdown filesystem with a really noisy log message
 # due to transaction cancellation.  Hence we don't want to check dmesg here.
 _disable_dmesg_check
 
-_require_xfs_mkfs_crc
+
 _scratch_mkfs -m crc=0 > $seqres.full 2>&1
 
 # The files that EIO in the golden output changes if we have quotas enabled
diff --git a/tests/xfs/148 b/tests/xfs/148
index 5d0a0bf42..789b8d0a4 100755
--- a/tests/xfs/148
+++ b/tests/xfs/148
@@ -27,7 +27,7 @@ _cleanup()
 _supported_fs xfs
 _require_test
 _require_attrs
-_require_xfs_mkfs_crc
+_require_xfs_nocrc
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
diff --git a/tests/xfs/263 b/tests/xfs/263
index bce4e13f9..99c97a104 100755
--- a/tests/xfs/263
+++ b/tests/xfs/263
@@ -25,6 +25,7 @@ _require_xfs_quota
 # Only test crc and beyond (but we will test with and without the feature)
 _require_xfs_mkfs_crc
 _require_xfs_crc
+_require_xfs_nocrc
 
 function option_string()
 {
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
diff --git a/tests/xfs/522 b/tests/xfs/522
index 2475d5844..7db3bb9fc 100755
--- a/tests/xfs/522
+++ b/tests/xfs/522
@@ -27,6 +27,7 @@ _supported_fs xfs
 _require_test
 _require_scratch_nocheck
 _require_xfs_mkfs_cfgfile
+_require_xfs_nocrc
 
 def_cfgfile=$TEST_DIR/a
 fsimg=$TEST_DIR/a.img
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

