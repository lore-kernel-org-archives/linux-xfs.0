Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D373B365;
	Wed, 14 Aug 2024 04:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723611169; cv=none; b=fjUnoZsfV2/fgUFFwgoqZSg3sRHKPw6Gq1yiQqz59XfC+b7TPxsQBY41EgUq7P5PvGPp+DGydXn+5vW30ccVwKWo4vMp6JOz+V+dcenerngxtbAmm+oP/eqothVHCsVWTku0YBEeVmfY8EKViG5gWM5rvbO62c099HV+IgSF9rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723611169; c=relaxed/simple;
	bh=17ZnMIvMbuAAkRsPQGTY8hA9J8r4josB+n9PZ57Ug4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjHmXeZ5HGzq2y7n54TMYlTPE/H69DuPyzGMWCIqd4lzlSQr3STRFmGVO82vPQ5M2U9p1HrTjMxPdzL+OPjsVGmbDRlFpkDIp1US2YJSNp1/zub7ZnLSqlK1dPCGEwzRqXhmsIzz+PHqGBYQSeJSeItjW1aJqJDxGgPclw4dKe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l2SDwtM/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l2SDwtM/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LEUMiQJJwz9xT9f4bL5G2uec/hGeR4kPIFPapWkNMHs=; b=l2SDwtM/hiiLLzTbJoG0zyQl9h
	MJE0Q3O1pG9WyoSt6If9gARwT9wfvzyyeOZjjv3wls8HSUwcCE9EuL/ETq0CT5CCWQ7Ud0HeYWK9f
	2hE+ZpuoKSReGPqO4rjERdam2BBBRlC+AUiN3TjSxK//3ibXkHYaDCnLy7g5bhQEYeDC9c23SjWcM
	UvXGCBOR1g3BcIlQey/VJkVXXpC4aQFFzrMiuFkKqUbNkeWDDJCSyqt84jk2kleWictoPkfsu7SxO
	TLaMGVg3AzqZJydz2KHKe79Ys2IHzKY6A2zAm3BePSHgXXzAwXakRpRCSStm8vNTr/iMuib+cLY2C
	dBCaXAmA==;
Received: from 2a02-8389-2341-5b80-fd16-64b9-63e2-2d30.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fd16:64b9:63e2:2d30] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1se606-00000005jP6-43jm;
	Wed, 14 Aug 2024 04:52:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] replace _min_dio_alignment with calls to src/min_dio_alignment
Date: Wed, 14 Aug 2024 06:52:14 +0200
Message-ID: <20240814045232.21189-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240814045232.21189-1-hch@lst.de>
References: <20240814045232.21189-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the min_dio_alignment C tool to check the minimum alignment.
This allows using the values obtained from statx instead of just guessing
based on the sector size and page size.

For tests using the scratch device this sometimes required moving code
around a bit to ensure the scratch device is actually mounted before
querying the alignment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         | 15 ---------------
 tests/generic/091 |  2 +-
 tests/generic/095 |  7 ++++---
 tests/generic/114 |  2 +-
 tests/generic/240 |  2 +-
 tests/generic/252 |  2 +-
 tests/generic/263 |  2 +-
 tests/generic/329 |  2 +-
 tests/generic/330 |  2 +-
 tests/generic/450 |  2 +-
 tests/generic/465 |  2 +-
 tests/generic/538 |  2 +-
 tests/generic/551 |  2 +-
 tests/generic/591 |  2 +-
 tests/xfs/194     | 11 ++++++-----
 tests/xfs/201     | 47 ++++++++++++++++++++++++-----------------------
 tests/xfs/237     |  2 +-
 tests/xfs/239     |  2 +-
 tests/xfs/556     |  2 +-
 19 files changed, 49 insertions(+), 61 deletions(-)

diff --git a/common/rc b/common/rc
index afc33bbc2..449ac9fbf 100644
--- a/common/rc
+++ b/common/rc
@@ -4296,21 +4296,6 @@ _scale_fsstress_args()
     printf '%s\n' "$args"
 }
 
-#
-# Return the logical block size if running on a block device,
-# else substitute the page size.
-#
-_min_dio_alignment()
-{
-    local dev=$1
-
-    if [ -b "$dev" ]; then
-        blockdev --getss $dev
-    else
-        $here/src/feature -s
-    fi
-}
-
 run_check()
 {
 	echo "# $@" >> $seqres.full 2>&1
diff --git a/tests/generic/091 b/tests/generic/091
index 8f7c13da8..5cdf04890 100755
--- a/tests/generic/091
+++ b/tests/generic/091
@@ -16,7 +16,7 @@ _require_test
 _require_odirect
 
 psize=`$here/src/feature -s`
-bsize=`_min_dio_alignment $TEST_DEV`
+bsize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
 # fsx usage:
 # 
diff --git a/tests/generic/095 b/tests/generic/095
index 7a0adf880..47e3b1e61 100755
--- a/tests/generic/095
+++ b/tests/generic/095
@@ -16,12 +16,15 @@ _require_scratch
 _require_odirect
 _require_aio
 
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
 iodepth=$((16 * LOAD_FACTOR))
 iodepth_batch=$((8 * LOAD_FACTOR))
 numjobs=$((5 * LOAD_FACTOR))
 fio_config=$tmp.fio
 fio_out=$tmp.fio.out
-blksz=$(_min_dio_alignment $SCRATCH_DEV)
+blksz=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
 cat >$fio_config <<EOF
 [global]
 bs=8k
@@ -82,8 +85,6 @@ EOF
 echo 'bs=$pagesize' >> $fio_config
 
 _require_fio $fio_config
-_scratch_mkfs >>$seqres.full 2>&1
-_scratch_mount
 
 # There's a known EIO failure to report collisions between directio and buffered
 # writes to userspace, refer to upstream linux 5a9d929d6e13. So ignore EIO error
diff --git a/tests/generic/114 b/tests/generic/114
index 068ed9e26..e0696ad92 100755
--- a/tests/generic/114
+++ b/tests/generic/114
@@ -25,7 +25,7 @@ _require_sparse_files
 _require_aiodio aio-dio-eof-race
 
 # Test does 512 byte DIO, so make sure that'll work
-logical_block_size=`_min_dio_alignment $TEST_DEV`
+logical_block_size=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
 if [ "$logical_block_size" -gt "512" ]; then
 	_notrun "device block size: $logical_block_size greater than 512"
diff --git a/tests/generic/240 b/tests/generic/240
index a333873ec..66a2ff74c 100755
--- a/tests/generic/240
+++ b/tests/generic/240
@@ -29,7 +29,7 @@ echo "Silence is golden."
 
 rm -f $TEST_DIR/aiodio_sparse
 
-logical_block_size=`_min_dio_alignment $TEST_DEV`
+logical_block_size=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 fs_block_size=`_get_block_size $TEST_DIR`
 file_size=$((8 * $fs_block_size))
 
diff --git a/tests/generic/252 b/tests/generic/252
index 39fa5531f..3ee2b0a67 100755
--- a/tests/generic/252
+++ b/tests/generic/252
@@ -49,7 +49,7 @@ nr=640
 bufnr=128
 filesize=$((blksz * nr))
 bufsize=$((blksz * bufnr))
-alignment=`_min_dio_alignment $TEST_DEV`
+alignment=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 5 / 4))
 
diff --git a/tests/generic/263 b/tests/generic/263
index 62eaec1d7..91cfbe525 100755
--- a/tests/generic/263
+++ b/tests/generic/263
@@ -16,7 +16,7 @@ _require_test
 _require_odirect
 
 psize=`$here/src/feature -s`
-bsize=`_min_dio_alignment $TEST_DEV`
+bsize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
 run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
 run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
diff --git a/tests/generic/329 b/tests/generic/329
index e29a8ca4c..ab37e047f 100755
--- a/tests/generic/329
+++ b/tests/generic/329
@@ -40,7 +40,7 @@ nr=640
 bufnr=128
 filesize=$((blksz * nr))
 bufsize=$((blksz * bufnr))
-alignment=`_min_dio_alignment $TEST_DEV`
+alignment=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 
diff --git a/tests/generic/330 b/tests/generic/330
index 83e1459fa..4fa81f991 100755
--- a/tests/generic/330
+++ b/tests/generic/330
@@ -36,7 +36,7 @@ nr=640
 bufnr=128
 filesize=$((blksz * nr))
 bufsize=$((blksz * bufnr))
-alignment=`_min_dio_alignment $TEST_DEV`
+alignment=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 
diff --git a/tests/generic/450 b/tests/generic/450
index 96e559da6..689f1051e 100755
--- a/tests/generic/450
+++ b/tests/generic/450
@@ -31,7 +31,7 @@ _require_test
 _require_odirect
 
 tfile=$TEST_DIR/testfile_${seq}
-ssize=`_min_dio_alignment $TEST_DEV`
+ssize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 bsize=`_get_block_size $TEST_DIR`
 
 # let's focus on the specific bug that only happens when $ssize <= $bsize
diff --git a/tests/generic/465 b/tests/generic/465
index eba3629ab..f8c4ea967 100755
--- a/tests/generic/465
+++ b/tests/generic/465
@@ -26,7 +26,7 @@ _require_aiodio aio-dio-append-write-read-race
 _require_test_program "feature"
 
 testfile=$TEST_DIR/$seq.$$
-min_dio_align=`_min_dio_alignment $TEST_DEV`
+min_dio_align=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 page_size=`$here/src/feature -s`
 
 echo "non-aio dio test"
diff --git a/tests/generic/538 b/tests/generic/538
index d6933cbb9..b9cf05de1 100755
--- a/tests/generic/538
+++ b/tests/generic/538
@@ -28,7 +28,7 @@ _require_test
 _require_aiodio aio-dio-write-verify
 
 localfile=$TEST_DIR/${seq}-aio-dio-write-verify-testfile
-diosize=`_min_dio_alignment $TEST_DEV`
+diosize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 blocksize=`_get_block_size $TEST_DIR`
 bufsize=$((blocksize * 2))
 truncsize=$((bufsize+diosize))
diff --git a/tests/generic/551 b/tests/generic/551
index f2907ac23..4a7f0a638 100755
--- a/tests/generic/551
+++ b/tests/generic/551
@@ -19,7 +19,7 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount
 
 localfile=$SCRATCH_MNT/testfile
-diosize=`_min_dio_alignment $SCRATCH_DEV`
+diosize=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
 
 # The maximum write size and offset are both 32k diosize. So the maximum
 # file size will be (32 * 2)k
diff --git a/tests/generic/591 b/tests/generic/591
index c22dc701b..f2fcd6162 100755
--- a/tests/generic/591
+++ b/tests/generic/591
@@ -22,7 +22,7 @@ _require_test
 _require_odirect
 _require_test_program "splice-test"
 
-diosize=`_min_dio_alignment $TEST_DEV`
+diosize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
 $here/src/splice-test -s $diosize -r $TEST_DIR/a
 $here/src/splice-test -rd $TEST_DIR/a
diff --git a/tests/xfs/194 b/tests/xfs/194
index 9abd2c321..1f83d534c 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -43,11 +43,6 @@ _scratch_mkfs_xfs >/dev/null 2>&1
 # For this test we use block size = 1/8 page size
 pgsize=`$here/src/feature -s`
 blksize=`expr $pgsize / 8`
-secsize=`_min_dio_alignment $SCRATCH_DEV`
-
-if [ $secsize -gt $blksize ];then
-	_notrun "sector size($secsize) too large for platform page size($pgsize)"
-fi
 
 # Filter out file mountpoint and physical location info
 # Input:
@@ -84,6 +79,12 @@ unset XFS_MKFS_OPTIONS
 # we need 512 byte block size, so crc's are turned off
 _scratch_mkfs_xfs -m crc=0 -b size=$blksize >/dev/null 2>&1
 _scratch_mount
+
+secsize=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
+if [ $secsize -gt $blksize ];then
+	_notrun "sector size($secsize) too large for platform page size($pgsize)"
+fi
+
 test "$(_get_block_size $SCRATCH_MNT)" = $blksize || \
 	_notrun "Could not get $blksize-byte blocks"
 
diff --git a/tests/xfs/201 b/tests/xfs/201
index a0d2c9150..60cc84ed2 100755
--- a/tests/xfs/201
+++ b/tests/xfs/201
@@ -24,10 +24,9 @@ _cleanup()
 
 file=$SCRATCH_MNT/f
 
-min_align=`_min_dio_alignment $SCRATCH_DEV`
-
 do_pwrite()
 {
+	min_align=$3
 	offset=`expr $1 \* $min_align`
 	end=`expr $2 \* $min_align`
 	length=`expr $end - $offset`
@@ -40,28 +39,30 @@ _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
 
+min_align=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
+
 # Create a fragmented file
-do_pwrite 30792 31039
-do_pwrite 30320 30791
-do_pwrite 29688 30319
-do_pwrite 29536 29687
-do_pwrite 27216 29535
-do_pwrite 24368 27215
-do_pwrite 21616 24367
-do_pwrite 20608 21615
-do_pwrite 19680 20607
-do_pwrite 19232 19679
-do_pwrite 17840 19231
-do_pwrite 16928 17839
-do_pwrite 15168 16927
-do_pwrite 14048 15167
-do_pwrite 12152 14047
-do_pwrite 11344 12151
-do_pwrite 8792 11343
-do_pwrite 6456 8791
-do_pwrite 5000 6455
-do_pwrite 1728 4999
-do_pwrite 0 1727
+do_pwrite 30792 31039 $min_align
+do_pwrite 30320 30791 $min_align
+do_pwrite 29688 30319 $min_align
+do_pwrite 29536 29687 $min_align
+do_pwrite 27216 29535 $min_align
+do_pwrite 24368 27215 $min_align
+do_pwrite 21616 24367 $min_align
+do_pwrite 20608 21615 $min_align
+do_pwrite 19680 20607 $min_align
+do_pwrite 19232 19679 $min_align
+do_pwrite 17840 19231 $min_align
+do_pwrite 16928 17839 $min_align
+do_pwrite 15168 16927 $min_align
+do_pwrite 14048 15167 $min_align
+do_pwrite 12152 14047 $min_align
+do_pwrite 11344 12151 $min_align
+do_pwrite 8792 11343 $min_align
+do_pwrite 6456 8791 $min_align
+do_pwrite 5000 6455 $min_align
+do_pwrite 1728 4999 $min_align
+do_pwrite 0 1727 $min_align
 
 sync
 sync
diff --git a/tests/xfs/237 b/tests/xfs/237
index 5f264ff44..194cd0459 100755
--- a/tests/xfs/237
+++ b/tests/xfs/237
@@ -41,7 +41,7 @@ nr=640
 bufnr=128
 filesize=$((blksz * nr))
 bufsize=$((blksz * bufnr))
-alignment=`_min_dio_alignment $TEST_DEV`
+alignment=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 _require_congruent_file_oplen $SCRATCH_MNT $blksz
diff --git a/tests/xfs/239 b/tests/xfs/239
index 277bd4548..bfe722c0a 100755
--- a/tests/xfs/239
+++ b/tests/xfs/239
@@ -40,7 +40,7 @@ filesize=$((blksz * nr))
 bufsize=$((blksz * bufnr))
 filesize=$filesize
 bufsize=$bufsize
-alignment=`_min_dio_alignment $TEST_DEV`
+alignment=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 
diff --git a/tests/xfs/556 b/tests/xfs/556
index 5a2e7fd6d..79e03caf4 100755
--- a/tests/xfs/556
+++ b/tests/xfs/556
@@ -82,7 +82,7 @@ ENDL
 
 # All sector numbers that we feed to the kernel must be in units of 512b, but
 # they also must be aligned to the device's logical block size.
-logical_block_size=$(_min_dio_alignment $SCRATCH_DEV)
+logical_block_size=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
 kernel_sectors_per_device_lba=$((logical_block_size / 512))
 
 # Mark as bad one of the device LBAs in the middle of the extent.  Target the
-- 
2.43.0

