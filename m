Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbeKJVgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 16:36:44 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: don't assume preallocation is always supported on XFS
Date: Sat, 10 Nov 2018 12:51:43 +0100
Message-Id: <20181110115145.30356-4-hch@lst.de>
In-Reply-To: <20181110115145.30356-1-hch@lst.de>
References: <20181110115145.30356-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

The always_cow mode can't usefull preallocate space gіven that it always
has to write out of place, and thus will reject falloc or ioctl calls to
preallocate space in a file.  Add explicit checks for preallocation
support in various XFS-specific tests to support this.
---
 tests/xfs/009 | 1 +
 tests/xfs/072 | 3 +--
 tests/xfs/084 | 1 +
 tests/xfs/104 | 1 +
 tests/xfs/128 | 1 +
 tests/xfs/164 | 1 +
 tests/xfs/165 | 1 +
 tests/xfs/166 | 2 ++
 tests/xfs/167 | 1 +
 tests/xfs/231 | 1 +
 tests/xfs/232 | 1 +
 tests/xfs/242 | 1 +
 tests/xfs/250 | 1 +
 tests/xfs/280 | 1 +
 tests/xfs/294 | 2 ++
 tests/xfs/312 | 1 +
 tests/xfs/313 | 1 +
 tests/xfs/316 | 1 +
 tests/xfs/324 | 1 +
 tests/xfs/326 | 1 +
 tests/xfs/328 | 1 +
 tests/xfs/330 | 1 +
 tests/xfs/444 | 1 +
 tests/xfs/445 | 1 +
 24 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/009 b/tests/xfs/009
index 7f95156c..9385d3b9 100755
--- a/tests/xfs/009
+++ b/tests/xfs/009
@@ -48,6 +48,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+_require_xfs_io_command "falloc"
 
 _filesize()
 {
diff --git a/tests/xfs/072 b/tests/xfs/072
index 735260b7..f86e4003 100755
--- a/tests/xfs/072
+++ b/tests/xfs/072
@@ -30,9 +30,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux
 
-[ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
-
 _require_scratch
+_require_xfs_io_command "falloc"
 
 rm -f $seqres.full
 _scratch_unmount >/dev/null 2>&1
diff --git a/tests/xfs/084 b/tests/xfs/084
index 8e9aff3c..fcdfc185 100755
--- a/tests/xfs/084
+++ b/tests/xfs/084
@@ -35,6 +35,7 @@ pgsize=`$here/src/feature -s`
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
+_require_xfs_io_command "falloc"
 _require_test
 
 echo
diff --git a/tests/xfs/104 b/tests/xfs/104
index 218e2b60..bc38f969 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -55,6 +55,7 @@ _stress_scratch()
 # real QA test starts here
 _supported_fs xfs
 _require_scratch
+_require_xfs_io_command "falloc"
 
 rm -f $seqres.full
 _scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
diff --git a/tests/xfs/128 b/tests/xfs/128
index 40ea0f04..f1b4fb4f 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -32,6 +32,7 @@ _supported_fs xfs
 _require_test_lsattr
 _require_scratch_reflink
 _require_cp_reflink
+_require_xfs_io_command "falloc"
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/xfs/164 b/tests/xfs/164
index fdd9293d..b0ec6df5 100755
--- a/tests/xfs/164
+++ b/tests/xfs/164
@@ -52,6 +52,7 @@ _filter_bmap()
 _supported_fs xfs
 _supported_os Linux
 _require_test
+_require_xfs_io_command "falloc"
 
 testfile=$TEST_DIR/file.$seq
 rm -f $seqres.full
diff --git a/tests/xfs/165 b/tests/xfs/165
index 4f6738d4..990d054c 100755
--- a/tests/xfs/165
+++ b/tests/xfs/165
@@ -49,6 +49,7 @@ _filter_bmap()
 _supported_fs xfs
 _supported_os Linux
 _require_test
+_require_xfs_io_command "falloc"
 
 # io tests 
 testfile=$TEST_DIR/file.$seq
diff --git a/tests/xfs/166 b/tests/xfs/166
index 9814e4a3..8dc7e080 100755
--- a/tests/xfs/166
+++ b/tests/xfs/166
@@ -60,6 +60,8 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+_require_xfs_io_command "falloc"
+
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
 
diff --git a/tests/xfs/167 b/tests/xfs/167
index 40b45e86..015002d4 100755
--- a/tests/xfs/167
+++ b/tests/xfs/167
@@ -41,6 +41,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_command "$KILLALL_PROG" killall
+_require_xfs_io_command "falloc"
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/231 b/tests/xfs/231
index 865c0331..12fdc490 100755
--- a/tests/xfs/231
+++ b/tests/xfs/231
@@ -38,6 +38,7 @@ _supported_fs xfs
 _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
 
 old_cow_lifetime=$(cat /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime)
diff --git a/tests/xfs/232 b/tests/xfs/232
index 3a88cc33..e768fa27 100755
--- a/tests/xfs/232
+++ b/tests/xfs/232
@@ -39,6 +39,7 @@ _supported_fs xfs
 _require_xfs_io_command "cowextsize"
 _require_scratch_reflink
 _require_cp_reflink
+_require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
 
 old_cow_lifetime=$(cat /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime)
diff --git a/tests/xfs/242 b/tests/xfs/242
index 9ae1aebd..5ce2c6f0 100755
--- a/tests/xfs/242
+++ b/tests/xfs/242
@@ -31,6 +31,7 @@ _supported_fs xfs
 _supported_os Linux
 _require_test
 
+_require_xfs_io_command "falloc"
 _require_xfs_io_command "zero"
 
 testfile=$TEST_DIR/242.$$
diff --git a/tests/xfs/250 b/tests/xfs/250
index f8b800e4..1f4d818e 100755
--- a/tests/xfs/250
+++ b/tests/xfs/250
@@ -32,6 +32,7 @@ _supported_fs xfs
 _supported_os Linux
 _require_test
 _require_loop
+_require_xfs_io_command "falloc"
 
 LOOP_DEV=$TEST_DIR/$seq.fs
 LOOP_MNT=$TEST_DIR/$seq.mnt
diff --git a/tests/xfs/280 b/tests/xfs/280
index 172eee21..76287c85 100755
--- a/tests/xfs/280
+++ b/tests/xfs/280
@@ -31,6 +31,7 @@ _supported_os Linux
 _supported_fs xfs
 _require_scratch_reflink
 _require_xfs_io_command "bmap"
+_require_xfs_io_command "falloc"
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/xfs/294 b/tests/xfs/294
index 4c919432..bce4d07b 100755
--- a/tests/xfs/294
+++ b/tests/xfs/294
@@ -42,6 +42,8 @@ _supported_fs xfs
 _supported_os Linux
 _require_scratch
 _require_test_program "punch-alternating"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
 
 # We want to mkfs with a very specific geometry
 MKFS_OPTIONS=""
diff --git a/tests/xfs/312 b/tests/xfs/312
index cdec9233..fa05754e 100755
--- a/tests/xfs/312
+++ b/tests/xfs/312
@@ -34,6 +34,7 @@ _supported_os Linux
 _supported_fs xfs
 _require_cp_reflink
 _require_scratch_reflink
+_require_xfs_io_command "fpunch"
 _require_xfs_io_error_injection "bmap_finish_one"
 
 rm -f $seqres.full
diff --git a/tests/xfs/313 b/tests/xfs/313
index 47ef7ec8..97c24f0a 100755
--- a/tests/xfs/313
+++ b/tests/xfs/313
@@ -34,6 +34,7 @@ _supported_os Linux
 _supported_fs xfs
 _require_cp_reflink
 _require_scratch_reflink
+_require_xfs_io_command "fpunch"
 _require_xfs_io_error_injection "refcount_finish_one"
 
 rm -f $seqres.full
diff --git a/tests/xfs/316 b/tests/xfs/316
index d0cd1e2f..063f0e43 100755
--- a/tests/xfs/316
+++ b/tests/xfs/316
@@ -35,6 +35,7 @@ _supported_fs xfs
 _require_cp_reflink
 _require_scratch_reflink
 _require_error_injection
+_require_xfs_io_command "fpunch"
 _require_xfs_io_error_injection "refcount_continue_update"
 
 rm -f $seqres.full
diff --git a/tests/xfs/324 b/tests/xfs/324
index a1be3318..e8ed2fc5 100755
--- a/tests/xfs/324
+++ b/tests/xfs/324
@@ -35,6 +35,7 @@ _supported_fs xfs
 _require_cp_reflink
 _require_scratch_reflink
 _require_error_injection
+_require_xfs_io_command "fpunch"
 _require_xfs_io_error_injection "refcount_continue_update"
 
 rm -f $seqres.full
diff --git a/tests/xfs/326 b/tests/xfs/326
index b6e01862..bb7e5590 100755
--- a/tests/xfs/326
+++ b/tests/xfs/326
@@ -37,6 +37,7 @@ _supported_fs xfs
 _require_cp_reflink
 _require_scratch_reflink
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "fpunch"
 _require_xfs_io_error_injection "refcount_finish_one"
 
 rm -f $seqres.full
diff --git a/tests/xfs/328 b/tests/xfs/328
index ab8af12f..55fe3ec9 100755
--- a/tests/xfs/328
+++ b/tests/xfs/328
@@ -33,6 +33,7 @@ _supported_fs xfs
 _require_scratch_reflink
 _require_cp_reflink
 _require_test_program "punch-alternating"
+_require_xfs_io_command "falloc" # used in FSR
 _require_command "$XFS_FSR_PROG" "xfs_fsr"
 
 rm -f "$seqres.full"
diff --git a/tests/xfs/330 b/tests/xfs/330
index 3682525d..66a9b6e2 100755
--- a/tests/xfs/330
+++ b/tests/xfs/330
@@ -33,6 +33,7 @@ _supported_os Linux
 _supported_fs xfs
 _require_scratch_reflink
 _require_cp_reflink
+_require_xfs_io_command "falloc" # used in FSR
 _require_command "$XFS_FSR_PROG" "xfs_fsr"
 _require_quota
 _require_nobody
diff --git a/tests/xfs/444 b/tests/xfs/444
index f1c0ed03..7a33b9e9 100755
--- a/tests/xfs/444
+++ b/tests/xfs/444
@@ -38,6 +38,7 @@ _supported_os Linux
 _require_check_dmesg
 _require_scratch
 _require_test_program "punch-alternating"
+_require_xfs_io_command "falloc"
 _require_xfs_db_write_array
 
 # This is only a v5 filesystem problem
diff --git a/tests/xfs/445 b/tests/xfs/445
index 2d205a40..800d5d28 100755
--- a/tests/xfs/445
+++ b/tests/xfs/445
@@ -53,6 +53,7 @@ drop_caches()
 _supported_fs generic
 _supported_os Linux
 _require_scratch_size $((2*1024*1024)) # kb
+_require_xfs_io_command "falloc"
 
 # check for filestreams
 _check_filestreams_support || _notrun "filestreams not available"
-- 
2.19.1
