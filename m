Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E10A70CAA;
	Thu, 18 Apr 2024 07:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713426069; cv=none; b=U27IOzoqMTpvx9RDGLj61Dd4iQj3syG+9VbmQfbwGsrmm1ZuNHLnk/sr66ocQJem79ADlWI6MfeDwk7v2lwiM61Dg6p8abtpRpXpLSGgnM8moOqbjbxiA5AY/pcSA7FUx6tZsGoOGqSlvou7NqoPfNIAQsFp3yMLyxCubHAV8L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713426069; c=relaxed/simple;
	bh=bGIQsHoiORvPOi7ZtVT7+8tcgKpbWaAQH8lYxD6klOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d9JtN4upUE4FyYYU1QocrtnW7PLZYgQWJvEuiSIPFFC1+iZ5DtoxMp7Ep5YE3cfT2MsB3rjM3b2YnClKE67Xqt7IX69Xg6buqPV2zLX1Cg0wL4we4tLXrkgE2r9m0qBFZTOYcsVaKp4d2GOGlG5hUtmD67RpK27PIRLHnARqEFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0gMHlR4O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0gMHlR4O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PHPH+2rTlZBkcWWeNUkBkhR3vyx2Mh301mRl5dtiPEc=; b=0gMHlR4OVG2OCu4hK5pJBNyBiy
	c4vU3/YkbR47ztkAXum1urU//w9a6JCNlZnhKtb5JWqjdWmxAJcwrzRc85bjl0kFjo4CyEqZ8zUsD
	+cRUU6/FXqkKoLTAjAPNgSphL4ysNKjcDNaaz1tvAwz4vFurWcLg572z2DvvHut7ZYyvEqSz4vqBs
	vgPS36PTp9R6Bsy5x1xsS5nBIjf6H6NHKr4eGbdxy/bc7suErHG/evyaSIOtw8Yn48RerKwK6EhNe
	ZCGFGB0JzJ1NBja0bwYFg5As+tQ/kyFLaqyLO0pOrSRjDSk0rRB09zegUzl4RUQCapJpUHYAwlK1k
	PbK+/BIA==;
Received: from 3.95.143.157.bbcs.as8758.net ([157.143.95.3] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxMOJ-00000001Imp-2RKe;
	Thu, 18 Apr 2024 07:41:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 5/5] xfs: don't run tests that require v4 file systems when not supported
Date: Thu, 18 Apr 2024 09:40:46 +0200
Message-Id: <20240418074046.2326450-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240418074046.2326450-1-hch@lst.de>
References: <20240418074046.2326450-1-hch@lst.de>
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
 tests/xfs/095 |  1 +
 tests/xfs/096 |  1 +
 tests/xfs/132 |  1 +
 tests/xfs/148 |  6 ++++++
 tests/xfs/194 | 10 ++++++++++
 tests/xfs/199 |  1 +
 tests/xfs/300 |  1 +
 tests/xfs/526 |  3 +++
 tests/xfs/612 |  1 +
 tests/xfs/613 |  1 +
 12 files changed, 37 insertions(+)

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
diff --git a/tests/xfs/096 b/tests/xfs/096
index 7eff6cb1d..0a1bfb3fa 100755
--- a/tests/xfs/096
+++ b/tests/xfs/096
@@ -20,6 +20,7 @@ _supported_fs xfs
 
 _require_scratch
 _require_xfs_quota
+_require_xfs_nocrc
 
 function option_string()
 {
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
index c9f634cfd..fde3bf476 100755
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
@@ -40,6 +42,10 @@ test_names=("something" "$nullstr" "$slashstr" "another")
 rm -f $imgfile $imgfile.old
 
 # Format image file w/o crcs so we can sed the image file
+#
+# TODO: It might be possible to rewrite this using proper xfs_db
+# fs manipulation commands that would work with CRCs.
+#
 # We need to use 512 byte inodes to ensure the attr forks remain in short form
 # even when security xattrs are present so we are always doing name matches on
 # lookup and not name hash compares as leaf/node forms will do.
diff --git a/tests/xfs/194 b/tests/xfs/194
index 5a1dff5d2..2fcc55b3e 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -30,6 +30,16 @@ _supported_fs xfs
 # real QA test starts here
 
 _require_scratch
+
+#
+# This currently forces nocrc because only that can support 512 byte block size
+# and thus block size = 1/8 page size on 4k page size systems.
+# In theory we could run it on systems with larger page size with CRCs, or hope
+# that large folios would trigger the same issue.
+# But for now that is left as an exercise for the reader.
+#
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
 
diff --git a/tests/xfs/526 b/tests/xfs/526
index 4261e8497..c5c5f9b1a 100755
--- a/tests/xfs/526
+++ b/tests/xfs/526
@@ -27,6 +27,9 @@ _require_test
 _require_scratch_nocheck
 _require_xfs_mkfs_cfgfile
 
+# Currently the only conflicting options are v4 specific
+_require_xfs_nocrc
+
 cfgfile=$TEST_DIR/a
 rm -rf $cfgfile
 
diff --git a/tests/xfs/612 b/tests/xfs/612
index 4ae4d3977..0f6df7deb 100755
--- a/tests/xfs/612
+++ b/tests/xfs/612
@@ -17,6 +17,7 @@ _supported_fs xfs
 _require_scratch_xfs_inobtcount
 _require_command "$XFS_ADMIN_PROG" "xfs_admin"
 _require_xfs_repair_upgrade inobtcount
+_require_xfs_nocrc
 
 # Make sure we can't upgrade to inobt on a V4 filesystem
 _scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
diff --git a/tests/xfs/613 b/tests/xfs/613
index 522358cb3..8bff21711 100755
--- a/tests/xfs/613
+++ b/tests/xfs/613
@@ -34,6 +34,7 @@ _supported_fs xfs
 _fixed_by_kernel_commit 237d7887ae72 \
 	"xfs: show the proper user quota options"
 
+_require_xfs_nocrc
 _require_test
 _require_loop
 _require_xfs_io_command "falloc"
-- 
2.39.2

