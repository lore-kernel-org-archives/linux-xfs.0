Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4A17BAEE;
	Mon,  8 Apr 2024 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583176; cv=none; b=gQSmIMAVubjBUKT9GqSYF1XwriOA7D+5pXDLc9udny/JR5pOX7GbVU2ymFd30gsxeCwWCkT31ancK/LvlxldTfDYTMyJFlmhfHtsHg0Uxx0YztPc0QOWDzlR1Ja0m7smJ59dJ8eP8ihdiduccVVdQIbVi9ij9Rh8wOOa73fHmvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583176; c=relaxed/simple;
	bh=t51xpbJsq1rRZ3gASRj5AMyJPYMbKYa7iPpcse60M0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b+zI2M472CZ06IJh+F/WOQl/D8EKTz1J3OAJV/BNF1i0nfekueldyzMJwVmGtMXriGmNC4G75LERoVuieqp91q/nKmVi1DnqsSgGoZwy6gWbKh3HyhYmrD/yy6EWCQ0U+39P8XNsEEeSSelxIB/SFJZWKdqMVf+Vn/BR2uZXi70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oBjt8pJf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oBjt8pJf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qwU5aLGzrSuWoiJb7KyORZqjaJKV5qfAaVa2OrhE5GA=; b=oBjt8pJfbgCvyBVgq+bzE/w3UG
	b3on1dv02qPfJe3Us2HvFEA4sSOBZpriaqS83onoGzMWtKB234ElGUhMhi3va6fnBH3tELrrldULP
	YTQsZEALzL6YlygOuDLEdzoyetbPsWeBLEKuQy+dCWTHDueELe5pGbbBDoxKZbuT/2PM+93fVNxn9
	oIJaA69BhAs+0GPreCsywNRhZDEJWbez2KnWAZ1tnswNVe0xUz6wWJ+Wy1UKDZEJln+ZOTiuVEB+r
	tbp33wC+N2hRflQD7keGOXwiVPlowCp+ku6D2dVQgaoKxMdvyxeZKsESF25bmxO1yHCtDF5kVH4HL
	TMiYxTaw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtp7F-0000000FjRi-0krh;
	Mon, 08 Apr 2024 13:32:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 1/6] xfs: remove support for tools and kernels with v5 support
Date: Mon,  8 Apr 2024 15:32:38 +0200
Message-Id: <20240408133243.694134-2-hch@lst.de>
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

v5 file systems have been the default for more than 10 years.  Drop
support for non-v5 enabled kernels and xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/config | 13 -------------
 common/xfs    | 26 --------------------------
 tests/xfs/002 |  3 ---
 tests/xfs/005 |  1 -
 tests/xfs/077 |  1 -
 tests/xfs/083 |  2 --
 tests/xfs/132 |  1 -
 tests/xfs/148 |  1 -
 tests/xfs/263 |  5 -----
 tests/xfs/299 |  2 --
 tests/xfs/304 |  2 --
 tests/xfs/305 |  2 --
 12 files changed, 59 deletions(-)

diff --git a/common/config b/common/config
index 2a1434bb1..6a0496fdd 100644
--- a/common/config
+++ b/common/config
@@ -329,19 +329,6 @@ if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
 	export SELINUX_MOUNT_OPTIONS
 fi
 
-# check if mkfs.xfs supports v5 xfs
-if [ "$FSTYP" == "xfs" ]; then
-	XFS_MKFS_HAS_NO_META_SUPPORT=""
-	touch /tmp/crc_check.img
-	$MKFS_XFS_PROG -N -d file,name=/tmp/crc_check.img,size=32m -m crc=0 \
-		>/dev/null 2>&1;
-	if [ $? -ne 0 ]; then
-		XFS_MKFS_HAS_NO_META_SUPPORT=true
-	fi
-	rm -f /tmp/crc_check.img
-	export XFS_MKFS_HAS_NO_META_SUPPORT
-fi
-
 _common_mount_opts()
 {
 	case $FSTYP in
diff --git a/common/xfs b/common/xfs
index 65b509691..57d21762c 100644
--- a/common/xfs
+++ b/common/xfs
@@ -59,11 +59,6 @@ _scratch_mkfs_xfs_opts()
 {
 	mkfs_opts=$*
 
-	# remove metadata related mkfs options if mkfs.xfs doesn't them
-	if [ -n "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
-		mkfs_opts=`echo $mkfs_opts | sed "s/-m\s\+\S\+//g"`
-	fi
-
 	_scratch_options mkfs
 
 	echo "$MKFS_XFS_PROG $SCRATCH_OPTIONS $mkfs_opts"
@@ -439,24 +434,6 @@ _require_projid16bit()
 	   || _notrun "16 bit project IDs not supported on $SCRATCH_DEV"
 }
 
-# this test requires the crc feature to be available in mkfs.xfs
-#
-_require_xfs_mkfs_crc()
-{
-	_scratch_mkfs_xfs_supported -m crc=1 >/dev/null 2>&1 \
-	   || _notrun "mkfs.xfs doesn't have crc feature"
-}
-
-# this test requires the xfs kernel support crc feature
-#
-_require_xfs_crc()
-{
-	_scratch_mkfs_xfs -m crc=1 >/dev/null 2>&1
-	_try_scratch_mount >/dev/null 2>&1 \
-	   || _notrun "Kernel doesn't support crc feature"
-	_scratch_unmount
-}
-
 # If the xfs_info output for the given XFS filesystem mount mentions the given
 # feature.  If so, return 0 for success.  If not, return 1 for failure.  If the
 # third option is -v, echo 1 for success and 0 for not.
@@ -1268,9 +1245,6 @@ _require_scratch_xfs_shrink()
 #
 _require_meta_uuid()
 {
-	# This will create a crc fs on $SCRATCH_DEV
-	_require_xfs_crc
-
 	_scratch_xfs_db -x -c "uuid restore" 2>&1 \
 	   | grep -q "invalid UUID\|supported on V5 fs" \
 	   && _notrun "Userspace doesn't support meta_uuid feature"
diff --git a/tests/xfs/002 b/tests/xfs/002
index 6c0bb4d04..8dfd2693b 100755
--- a/tests/xfs/002
+++ b/tests/xfs/002
@@ -24,9 +24,6 @@ _supported_fs xfs
 _require_scratch_nocheck
 _require_no_large_scratch_dev
 
-# So we can explicitly turn it _off_:
-_require_xfs_mkfs_crc
-
 _scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs failed"
 
 # Scribble past a couple V4 secondary superblocks to populate sb_crc
diff --git a/tests/xfs/005 b/tests/xfs/005
index 5f1ab8348..019790295 100755
--- a/tests/xfs/005
+++ b/tests/xfs/005
@@ -20,7 +20,6 @@ _begin_fstest auto quick
 _supported_fs xfs
 
 _require_scratch_nocheck
-_require_xfs_mkfs_crc
 
 _scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
 
diff --git a/tests/xfs/077 b/tests/xfs/077
index f24f6f004..37ea931f1 100755
--- a/tests/xfs/077
+++ b/tests/xfs/077
@@ -24,7 +24,6 @@ _supported_fs xfs
 _require_xfs_copy
 _require_scratch
 _require_no_large_scratch_dev
-_require_xfs_crc
 _require_meta_uuid
 
 # Takes 2 args, 2nd optional:
diff --git a/tests/xfs/083 b/tests/xfs/083
index edab3b7b0..e8ce2221c 100755
--- a/tests/xfs/083
+++ b/tests/xfs/083
@@ -28,8 +28,6 @@ _cleanup()
 _supported_fs xfs
 
 _require_scratch
-#_require_xfs_crc	# checksum not required, but you probably want it anyway...
-#_require_xfs_mkfs_crc
 _require_attrs
 _require_populate_commands
 
diff --git a/tests/xfs/132 b/tests/xfs/132
index fa36c09c2..ee1c8c1ec 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -24,7 +24,6 @@ _require_scratch_nocheck
 # due to transaction cancellation.  Hence we don't want to check dmesg here.
 _disable_dmesg_check
 
-_require_xfs_mkfs_crc
 _scratch_mkfs -m crc=0 > $seqres.full 2>&1
 
 # The files that EIO in the golden output changes if we have quotas enabled
diff --git a/tests/xfs/148 b/tests/xfs/148
index 5d0a0bf42..c9f634cfd 100755
--- a/tests/xfs/148
+++ b/tests/xfs/148
@@ -27,7 +27,6 @@ _cleanup()
 _supported_fs xfs
 _require_test
 _require_attrs
-_require_xfs_mkfs_crc
 _disable_dmesg_check
 
 imgfile=$TEST_DIR/img-$seq
diff --git a/tests/xfs/263 b/tests/xfs/263
index bce4e13f9..bd30dab11 100755
--- a/tests/xfs/263
+++ b/tests/xfs/263
@@ -21,11 +21,6 @@ _supported_fs xfs
 _require_scratch
 _require_xfs_quota
 
-# We could test older, non-project capable kernels but keep it simpler;
-# Only test crc and beyond (but we will test with and without the feature)
-_require_xfs_mkfs_crc
-_require_xfs_crc
-
 function option_string()
 {
 	VAL=$1
diff --git a/tests/xfs/299 b/tests/xfs/299
index 4b9df3c6a..1df1988ac 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -31,8 +31,6 @@ chmod a+rwx $seqres.full	# arbitrary users will write here
 
 _require_scratch
 _require_xfs_quota
-_require_xfs_mkfs_crc
-_require_xfs_crc
 
 # The actual point at which limit enforcement takes place for the
 # hard block limit is variable depending on filesystem blocksize,
diff --git a/tests/xfs/304 b/tests/xfs/304
index 3c38e6132..0ee6dad63 100755
--- a/tests/xfs/304
+++ b/tests/xfs/304
@@ -19,8 +19,6 @@ _supported_fs xfs
 
 _require_scratch
 _require_xfs_quota
-_require_xfs_mkfs_crc
-_require_xfs_crc
 
 _scratch_mkfs_xfs -m crc=1 >/dev/null 2>&1
 
diff --git a/tests/xfs/305 b/tests/xfs/305
index d8a6712e5..e76dfdec1 100755
--- a/tests/xfs/305
+++ b/tests/xfs/305
@@ -19,8 +19,6 @@ _supported_fs xfs
 
 _require_scratch
 _require_xfs_quota
-_require_xfs_mkfs_crc
-_require_xfs_crc
 _require_command "$KILLALL_PROG" killall
 
 _scratch_mkfs_xfs -m crc=1 >/dev/null 2>&1
-- 
2.39.2

