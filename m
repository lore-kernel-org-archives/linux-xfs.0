Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D991E5716;
	Wed, 12 Mar 2025 06:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761991; cv=none; b=gTuUeIduy8wXYVE7hZe6kwIG8ASvqtq/MsUr49tRun5hBjKtrmtrImldRmb/j0sD20vQLkYyToR+ZZz9hPJcWPTOWVyPzwGtbZ12n8a+/vydsleuls/5ltnf2+Iv5Q4SP3+f96zzxjwxF5wNDkzfU7q9mF15BEEs9nsCg6wO99s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761991; c=relaxed/simple;
	bh=zDC6cpp5HFrfDTt+iU5Qmb65jD8P59RQOMSLuK864ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P+RciSAexMBoLk0ONdb6S2PgeCZnhmU6FH7qmH0/EGivNidegbyVgEXhIhQ469UC9Nz0l4SjNXbiJi5qicyywmb9lDTZr+QObCpfzjxeMQtc9FWi19AlQtzEA4EwwC9Zb00WkgAc6upA2HKcESox16LFRWlVR9LSefko6CaAXNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3iDRaqTO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3iDRaqTO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=ZOVb6koitkE1JUcpNWqVRAyps0IKE4mUivigBPMuwfo=; b=3iDRaqTOuYkppiG9+BHAHK8Cy/
	dRkqnVGBljmJCt5q+vZQGRYRYgIcw5GO0XvFTX+aqAyLd9fRo+w5+kzchOCjYms2uQXFa6lhYNMCv
	DjFavbBfWtScEFOdb7CqKlZ05kmWlxYChis1fsjWHA9oaV4Oa996KZoQDyS18WKxX+sz6zoYwHGmP
	9VSkewRRy+nie1UhsYSzfzCZtjWZRlHCEC+oMkNzlhp6K9CveQRcF68a5Tz6hSjrYPJB/RdTiJUBZ
	Ti23usz57IKDT9nOS9YcDr1+Eg+oQ5aMGqnvHcDjrIyVSiXj5kwXJKfkQeBCIyLmEATN8RwhFDUxz
	WGEj7zuw==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFrI-00000007cwJ-36bt;
	Wed, 12 Mar 2025 06:46:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 16/17] xfs: skip various tests when using the zoned allocator
Date: Wed, 12 Mar 2025 07:45:08 +0100
Message-ID: <20250312064541.664334-17-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Various file system features tested are incompatible with the zoned
allocator.  Add a _require_xfs_scratch_non_zoned to guard them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/015 |  7 +++++++
 tests/xfs/041 |  5 +++++
 tests/xfs/272 |  5 +++++
 tests/xfs/276 |  5 +++++
 tests/xfs/306 |  4 ++++
 tests/xfs/419 |  3 +++
 tests/xfs/449 |  3 +++
 tests/xfs/521 |  3 +++
 tests/xfs/524 |  4 ++++
 tests/xfs/540 |  3 +++
 tests/xfs/541 |  3 +++
 tests/xfs/556 | 13 +++++++++++++
 tests/xfs/596 |  3 +++
 13 files changed, 61 insertions(+)

diff --git a/tests/xfs/015 b/tests/xfs/015
index acaace0ce103..ddb3e0911813 100755
--- a/tests/xfs/015
+++ b/tests/xfs/015
@@ -38,6 +38,13 @@ _require_scratch
 # need 128M space, don't make any assumption
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
+
+# This test tries to grow the data device, which doesn't work for internal
+# zoned RT devices
+if [ -z "$SCRATCH_RTDEV" ]; then
+	_require_xfs_scratch_non_zoned
+fi
+
 _require_fs_space $SCRATCH_MNT 196608
 _scratch_unmount
 
diff --git a/tests/xfs/041 b/tests/xfs/041
index 780078d44eeb..6cbcef6cfff0 100755
--- a/tests/xfs/041
+++ b/tests/xfs/041
@@ -44,6 +44,11 @@ bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 | _filter_mkfs 2>&1 \
 onemeginblocks=`expr 1048576 / $bsize`
 _scratch_mount
 
+# Growing the data device doesn't work with an internal RT volume directly
+# following the data device.  But even without that this test forces data
+# to the data device, which often is tiny on zoned file systems.
+_require_xfs_scratch_non_zoned
+
 # We're growing the data device, so force new file creation there
 _xfs_force_bdev data $SCRATCH_MNT
 
diff --git a/tests/xfs/272 b/tests/xfs/272
index 0a7a7273ac92..aa5831dc0234 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -29,6 +29,11 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
+# The synthetic devices for internal zoned rt devices confuse the parser
+if [ -z "$SCRATCH_RTDEV" ]; then
+	_require_xfs_scratch_non_zoned
+fi
+
 # Make sure everything is on the data device
 _xfs_force_bdev data $SCRATCH_MNT
 
diff --git a/tests/xfs/276 b/tests/xfs/276
index b675e79b249a..2802fc03c473 100755
--- a/tests/xfs/276
+++ b/tests/xfs/276
@@ -32,6 +32,11 @@ _scratch_mkfs | _filter_mkfs 2> "$tmp.mkfs" >/dev/null
 cat "$tmp.mkfs" > $seqres.full
 _scratch_mount
 
+# The synthetic devices for internal zoned rt devices confuse the parser
+if [ -z "$SCRATCH_RTDEV" ]; then
+	_require_xfs_scratch_non_zoned
+fi
+
 # Don't let the rt extent size perturb the fsmap output with unwritten
 # extents in places we don't expect them
 test $rtextsz -eq $dbsize || _notrun "Skipping test due to rtextsize > 1 fsb"
diff --git a/tests/xfs/306 b/tests/xfs/306
index 8981cbd72e1c..e78493784233 100755
--- a/tests/xfs/306
+++ b/tests/xfs/306
@@ -33,6 +33,10 @@ unset SCRATCH_RTDEV
 _scratch_mkfs_xfs -d size=100m -n size=64k >> $seqres.full 2>&1
 _scratch_mount
 
+# When using the zone allotator, mkfs still creates an internal RT ѕection by
+# default and the above unsetting SCRATCH_RTDEV of doesn't work.
+_require_xfs_scratch_non_zoned
+
 # Fill a source directory with many largish-named files. 1k uuid-named entries
 # sufficiently populates a 64k directory block.
 mkdir $SCRATCH_MNT/src
diff --git a/tests/xfs/419 b/tests/xfs/419
index 5e122a0b8763..94ae18743da9 100755
--- a/tests/xfs/419
+++ b/tests/xfs/419
@@ -44,6 +44,9 @@ cat $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
 _scratch_mount
 
+# no support for rtextsize > 1 on zoned file systems
+_require_xfs_scratch_non_zoned
+
 test $rtextsz -ne $dbsize || \
 	_notrun "cannot set rt extent size ($rtextsz) larger than fs block size ($dbsize)"
 
diff --git a/tests/xfs/449 b/tests/xfs/449
index a739df50e319..d93d84952c6a 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -38,6 +38,9 @@ fi
 
 _scratch_mount
 
+# can't grow data volume on mixed configs
+_require_xfs_scratch_non_zoned
+
 $XFS_SPACEMAN_PROG -c "info" $SCRATCH_MNT > $tmp.spaceman
 echo SPACEMAN >> $seqres.full
 cat $tmp.spaceman >> $seqres.full
diff --git a/tests/xfs/521 b/tests/xfs/521
index c92c621a2fd4..0da05a55a276 100755
--- a/tests/xfs/521
+++ b/tests/xfs/521
@@ -43,6 +43,9 @@ export SCRATCH_RTDEV=$rtdev
 _scratch_mkfs -r size=100m > $seqres.full
 _try_scratch_mount || _notrun "Could not mount scratch with synthetic rt volume"
 
+# zoned file systems only support zoned size-rounded RT device sizes
+_require_xfs_scratch_non_zoned
+
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
diff --git a/tests/xfs/524 b/tests/xfs/524
index ef47a8461bf7..6251863476e5 100755
--- a/tests/xfs/524
+++ b/tests/xfs/524
@@ -25,6 +25,10 @@ _require_test
 _require_scratch_nocheck
 _require_xfs_mkfs_cfgfile
 
+# reflink is currently not supported for zoned devices, and the normal support
+# checks for it don't work at mkfs time.
+_require_non_zoned_device $SCRATCH_DEV
+
 echo "Silence is golden"
 
 def_cfgfile=$TEST_DIR/a
diff --git a/tests/xfs/540 b/tests/xfs/540
index 9c0fa3c6bb10..5595eee85a9b 100755
--- a/tests/xfs/540
+++ b/tests/xfs/540
@@ -34,6 +34,9 @@ test $rtextsz -ne $dbsize || \
 	_notrun "cannot set rt extent size ($rtextsz) larger than fs block size ($dbsize)"
 
 _scratch_mount >> $seqres.full 2>&1
+# no support for rtextsize > 1 on zoned file systems
+_require_xfs_scratch_non_zoned
+
 rootino=$(stat -c '%i' $SCRATCH_MNT)
 _scratch_unmount
 
diff --git a/tests/xfs/541 b/tests/xfs/541
index b4856d496d5e..2b8c7ba17ff8 100755
--- a/tests/xfs/541
+++ b/tests/xfs/541
@@ -30,6 +30,9 @@ _require_scratch
 SCRATCH_RTDEV="" _scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
 _try_scratch_mount || _notrun "Can't mount file system"
 
+# Zoned file systems don't support rtextsize > 1
+_require_xfs_scratch_non_zoned
+
 # Check that there's no realtime section.
 source $tmp.mkfs
 test $rtblocks -eq 0 || echo "expected 0 rtblocks, got $rtblocks"
diff --git a/tests/xfs/556 b/tests/xfs/556
index 83d5022e700c..f5ad90c869ba 100755
--- a/tests/xfs/556
+++ b/tests/xfs/556
@@ -35,6 +35,19 @@ filter_scrub_errors() {
 }
 
 _scratch_mkfs >> $seqres.full
+
+#
+# The dm-error map added by this test doesn't work on zoned devices because
+# table sizes need to be aligned to the zone size, and even for zoned on
+# conventional this test will get confused because of the internal RT device.
+#
+# That check requires a mounted file system, so do a dummy mount before setting
+# up DM.
+#
+_scratch_mount
+_require_xfs_scratch_non_zoned
+_scratch_unmount
+
 _dmerror_init
 _dmerror_mount >> $seqres.full 2>&1
 
diff --git a/tests/xfs/596 b/tests/xfs/596
index 12c38c2e9604..5827f045b4e6 100755
--- a/tests/xfs/596
+++ b/tests/xfs/596
@@ -44,6 +44,9 @@ _scratch_mkfs_xfs -rsize=${rtsize}m | _filter_mkfs 2> "$tmp.mkfs" >> $seqres.ful
 onemeginblocks=`expr 1048576 / $dbsize`
 _scratch_mount
 
+# growfs on zoned file systems only works on zone boundaries
+_require_xfs_scratch_non_zoned
+
 # We're growing the realtime device, so force new file creation there
 _xfs_force_bdev realtime $SCRATCH_MNT
 
-- 
2.45.2

