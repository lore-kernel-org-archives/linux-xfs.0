Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3DE517CA3
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:28:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAE80304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:32 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mvsZ7ssTBorNT9lW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:30 -0700 (PDT)
Subject: [PATCH 01/13] tests/xfs: don't run tests if cowextsize isn't present
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:28:25 -0700
Message-ID: <147216770565.32641.5996523789425289351.stgit@birch.djwong.org>
In-Reply-To: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Some of the tests forgot to check that xfs_io has a cowextsize command,
so fix that here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/215 |    1 +
 tests/xfs/218 |    1 +
 tests/xfs/219 |    1 +
 tests/xfs/221 |    1 +
 tests/xfs/223 |    1 +
 tests/xfs/224 |    1 +
 tests/xfs/225 |    1 +
 tests/xfs/226 |    1 +
 tests/xfs/228 |    1 +
 tests/xfs/230 |    1 +
 tests/xfs/231 |    1 +
 tests/xfs/232 |    1 +
 tests/xfs/243 |    1 +
 tests/xfs/248 |    1 +
 tests/xfs/249 |    1 +
 tests/xfs/251 |    1 +
 tests/xfs/254 |    1 +
 tests/xfs/255 |    1 +
 tests/xfs/256 |    1 +
 tests/xfs/257 |    1 +
 tests/xfs/258 |    1 +
 tests/xfs/315 |    1 +
 tests/xfs/326 |    1 +
 23 files changed, 23 insertions(+)


diff --git a/tests/xfs/215 b/tests/xfs/215
index 7a517d7..b9c9ab4 100755
--- a/tests/xfs/215
+++ b/tests/xfs/215
@@ -50,6 +50,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/218 b/tests/xfs/218
index 0ab4102..887a135 100755
--- a/tests/xfs/218
+++ b/tests/xfs/218
@@ -50,6 +50,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/219 b/tests/xfs/219
index df57e07..5ae0714 100755
--- a/tests/xfs/219
+++ b/tests/xfs/219
@@ -50,6 +50,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/221 b/tests/xfs/221
index 03d81ac..3afc75f 100755
--- a/tests/xfs/221
+++ b/tests/xfs/221
@@ -50,6 +50,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/223 b/tests/xfs/223
index 7c990a2..3f34bcf 100755
--- a/tests/xfs/223
+++ b/tests/xfs/223
@@ -51,6 +51,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/224 b/tests/xfs/224
index bf33d1f..91033fa 100755
--- a/tests/xfs/224
+++ b/tests/xfs/224
@@ -51,6 +51,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/225 b/tests/xfs/225
index 749816f..2260441 100755
--- a/tests/xfs/225
+++ b/tests/xfs/225
@@ -50,6 +50,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/226 b/tests/xfs/226
index bb94d24..ac70239 100755
--- a/tests/xfs/226
+++ b/tests/xfs/226
@@ -50,6 +50,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/228 b/tests/xfs/228
index df1fd7a..65d7f51 100755
--- a/tests/xfs/228
+++ b/tests/xfs/228
@@ -54,6 +54,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_xfs_io_command "fpunch"
 _require_cp_reflink
 _require_odirect
diff --git a/tests/xfs/230 b/tests/xfs/230
index 73f599a..73c6267 100755
--- a/tests/xfs/230
+++ b/tests/xfs/230
@@ -54,6 +54,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_xfs_io_command "fpunch"
 _require_cp_reflink
 _require_odirect
diff --git a/tests/xfs/231 b/tests/xfs/231
index 166f6b0..d89139a 100755
--- a/tests/xfs/231
+++ b/tests/xfs/231
@@ -51,6 +51,7 @@ _supported_os Linux
 _supported_fs xfs
 _require_scratch_reflink
 _require_cp_reflink
+_require_xfs_io_command "cowextsize"
 _require_fiemap
 
 old_cow_lifetime=$(cat /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime)
diff --git a/tests/xfs/232 b/tests/xfs/232
index 0008dbf..2438f1f 100755
--- a/tests/xfs/232
+++ b/tests/xfs/232
@@ -50,6 +50,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_xfs_io_command "cowextsize"
 _require_scratch_reflink
 _require_cp_reflink
 _require_fiemap
diff --git a/tests/xfs/243 b/tests/xfs/243
index f6a8692..0bb69c4 100755
--- a/tests/xfs/243
+++ b/tests/xfs/243
@@ -55,6 +55,7 @@ _supported_os Linux
 _supported_fs xfs
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_xfs_io_command "fpunch"
 _require_xfs_io_command "bmap" "-c"
 _require_cp_reflink
diff --git a/tests/xfs/248 b/tests/xfs/248
index 7e25258..471205c 100755
--- a/tests/xfs/248
+++ b/tests/xfs/248
@@ -51,6 +51,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/249 b/tests/xfs/249
index b82d89c..0a7fbf1 100755
--- a/tests/xfs/249
+++ b/tests/xfs/249
@@ -51,6 +51,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/251 b/tests/xfs/251
index 4f74772..48a027c 100755
--- a/tests/xfs/251
+++ b/tests/xfs/251
@@ -53,6 +53,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/254 b/tests/xfs/254
index c8ac412..ac87e49 100755
--- a/tests/xfs/254
+++ b/tests/xfs/254
@@ -53,6 +53,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/255 b/tests/xfs/255
index 93ad13e..97cbb77 100755
--- a/tests/xfs/255
+++ b/tests/xfs/255
@@ -53,6 +53,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/256 b/tests/xfs/256
index d5cf71b..a182953 100755
--- a/tests/xfs/256
+++ b/tests/xfs/256
@@ -53,6 +53,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/257 b/tests/xfs/257
index 624f5e3..1fc401b 100755
--- a/tests/xfs/257
+++ b/tests/xfs/257
@@ -54,6 +54,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/258 b/tests/xfs/258
index 243e853..a3ffc89 100755
--- a/tests/xfs/258
+++ b/tests/xfs/258
@@ -54,6 +54,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "cowextsize"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/315 b/tests/xfs/315
index 62d7fcf..6170540 100755
--- a/tests/xfs/315
+++ b/tests/xfs/315
@@ -49,6 +49,7 @@ _supported_fs xfs
 _require_cp_reflink
 _require_scratch_reflink
 _require_error_injection
+_require_xfs_io_command "cowextsize"
 _require_xfs_io_error_injection "free_extent"
 
 rm -f $seqres.full
diff --git a/tests/xfs/326 b/tests/xfs/326
index 2cd6eda..36bdcf4 100755
--- a/tests/xfs/326
+++ b/tests/xfs/326
@@ -50,6 +50,7 @@ _supported_os Linux
 _supported_fs xfs
 _require_cp_reflink
 _require_scratch_reflink
+_require_xfs_io_command "cowextsize"
 _require_xfs_io_error_injection "refcount_finish_one"
 
 rm -f $seqres.full

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
