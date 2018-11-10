Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35900 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbeKJVgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 16:36:42 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] generic: don't assume preallocation is supported when reflinks are supported
Date: Sat, 10 Nov 2018 12:51:42 +0100
Message-Id: <20181110115145.30356-3-hch@lst.de>
In-Reply-To: <20181110115145.30356-1-hch@lst.de>
References: <20181110115145.30356-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Various reflink tests currently use fallocate to preallocate space without
first checking that preallocations are supported.  Add explicit checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/176 | 1 +
 tests/generic/372 | 1 +
 tests/generic/414 | 1 +
 tests/generic/415 | 1 +
 tests/generic/447 | 1 +
 tests/generic/515 | 1 +
 6 files changed, 6 insertions(+)

diff --git a/tests/generic/176 b/tests/generic/176
index e0c0f225..a084578a 100755
--- a/tests/generic/176
+++ b/tests/generic/176
@@ -31,6 +31,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
+_require_xfs_io_command "fpunch"
 _require_test_program "punch-alternating"
 
 rm -f "$seqres.full"
diff --git a/tests/generic/372 b/tests/generic/372
index 44914453..21cf283b 100755
--- a/tests/generic/372
+++ b/tests/generic/372
@@ -31,6 +31,7 @@ _cleanup()
 _supported_os Linux
 _supported_fs generic
 _require_scratch_reflink
+_require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
 _require_scratch_explicit_shared_extents
 
diff --git a/tests/generic/414 b/tests/generic/414
index 7c76d580..f9f26744 100755
--- a/tests/generic/414
+++ b/tests/generic/414
@@ -32,6 +32,7 @@ _cleanup()
 _supported_os Linux
 _supported_fs generic
 _require_scratch_reflink
+_require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
 
 echo "Format and mount"
diff --git a/tests/generic/415 b/tests/generic/415
index 14fbc232..0b7554ff 100755
--- a/tests/generic/415
+++ b/tests/generic/415
@@ -34,6 +34,7 @@ _supported_fs generic
 _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
+_require_xfs_io_command "fpunch"
 
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
diff --git a/tests/generic/447 b/tests/generic/447
index 3775e49f..1e7cb3c8 100755
--- a/tests/generic/447
+++ b/tests/generic/447
@@ -32,6 +32,7 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 _require_test_program "punch-alternating"
+_require_xfs_io_command "fpunch"
 
 rm -f "$seqres.full"
 
diff --git a/tests/generic/515 b/tests/generic/515
index 1ae9fbfe..f9e0b3be 100755
--- a/tests/generic/515
+++ b/tests/generic/515
@@ -31,6 +31,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 _require_scratch_reflink
+_require_xfs_io_command "falloc"
 
 rm -f $seqres.full
 
-- 
2.19.1
