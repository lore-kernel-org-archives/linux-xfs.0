Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C49387CAE
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:40:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47105AC006
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:37 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mDQE2PhrDK9gxSrl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:34 -0800 (PST)
Subject: [PATCH 11/32] reflink: add _require_odirect to the directio tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:40:29 -0800
Message-ID: <20160211234029.2202.82743.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

For the tests that test O_DIRECT, we need to _require_odirect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/139 |    1 +
 tests/generic/143 |    1 +
 tests/generic/155 |    1 +
 tests/generic/165 |    1 +
 tests/generic/166 |    1 +
 tests/generic/170 |    1 +
 tests/generic/174 |    1 +
 tests/generic/183 |    1 +
 tests/generic/187 |    1 +
 tests/generic/188 |    1 +
 tests/generic/190 |    1 +
 tests/generic/194 |    1 +
 tests/generic/196 |    1 +
 tests/generic/199 |    1 +
 tests/generic/200 |    1 +
 tests/generic/203 |    1 +
 tests/generic/206 |    1 +
 tests/generic/217 |    1 +
 tests/generic/220 |    1 +
 tests/generic/227 |    1 +
 tests/generic/238 |    1 +
 tests/generic/243 |    1 +
 22 files changed, 22 insertions(+)


diff --git a/tests/generic/139 b/tests/generic/139
index 5e7b631..989b054 100755
--- a/tests/generic/139
+++ b/tests/generic/139
@@ -47,6 +47,7 @@ _cleanup()
 _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/143 b/tests/generic/143
index 586cf5c..703b585 100755
--- a/tests/generic/143
+++ b/tests/generic/143
@@ -49,6 +49,7 @@ _cleanup()
 _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/155 b/tests/generic/155
index c6416a1..e96bda7 100755
--- a/tests/generic/155
+++ b/tests/generic/155
@@ -55,6 +55,7 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "fzero"
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/165 b/tests/generic/165
index e4c9a9d..1ae08a4 100755
--- a/tests/generic/165
+++ b/tests/generic/165
@@ -47,6 +47,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
+_require_odirect
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/generic/166 b/tests/generic/166
index 9be753d..9b177be 100755
--- a/tests/generic/166
+++ b/tests/generic/166
@@ -47,6 +47,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
+_require_odirect
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/generic/170 b/tests/generic/170
index dbf1564..0f29b3a 100755
--- a/tests/generic/170
+++ b/tests/generic/170
@@ -46,6 +46,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _require_scratch_reflink
+_require_odirect
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/generic/174 b/tests/generic/174
index cec2f05..edfc2bc 100755
--- a/tests/generic/174
+++ b/tests/generic/174
@@ -46,6 +46,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/183 b/tests/generic/183
index 0f35da2..0ab4afe 100755
--- a/tests/generic/183
+++ b/tests/generic/183
@@ -49,6 +49,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _require_scratch_reflink
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/187 b/tests/generic/187
index b8fade2..ac6037d 100755
--- a/tests/generic/187
+++ b/tests/generic/187
@@ -55,6 +55,7 @@ _require_cp_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
 test $FSTYP = "btrfs" && _notrun "Can't fragment free space on btrfs."
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/188 b/tests/generic/188
index 7be1080..bb293b1 100755
--- a/tests/generic/188
+++ b/tests/generic/188
@@ -49,6 +49,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/190 b/tests/generic/190
index a5c2137..b4de3ed 100755
--- a/tests/generic/190
+++ b/tests/generic/190
@@ -49,6 +49,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/194 b/tests/generic/194
index 69a3e6c..f67e567 100755
--- a/tests/generic/194
+++ b/tests/generic/194
@@ -50,6 +50,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/196 b/tests/generic/196
index 951079c..1505de8 100755
--- a/tests/generic/196
+++ b/tests/generic/196
@@ -49,6 +49,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/199 b/tests/generic/199
index f457245..04380ed 100755
--- a/tests/generic/199
+++ b/tests/generic/199
@@ -55,6 +55,7 @@ _require_scratch_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
 _require_cp_reflink
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/200 b/tests/generic/200
index ffb5869..2aa0315 100755
--- a/tests/generic/200
+++ b/tests/generic/200
@@ -55,6 +55,7 @@ _require_scratch_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
 _require_cp_reflink
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/203 b/tests/generic/203
index 5d9bfc4..2ffb311 100755
--- a/tests/generic/203
+++ b/tests/generic/203
@@ -44,6 +44,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/206 b/tests/generic/206
index 4054626..6b3e200 100755
--- a/tests/generic/206
+++ b/tests/generic/206
@@ -47,6 +47,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _require_scratch_reflink
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/217 b/tests/generic/217
index b1bd635..ce8e0a1 100755
--- a/tests/generic/217
+++ b/tests/generic/217
@@ -48,6 +48,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/220 b/tests/generic/220
index edb8432..3bce21b 100755
--- a/tests/generic/220
+++ b/tests/generic/220
@@ -48,6 +48,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/227 b/tests/generic/227
index abaf8f7..00985d3 100755
--- a/tests/generic/227
+++ b/tests/generic/227
@@ -48,6 +48,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/238 b/tests/generic/238
index ce7408c..3b46492 100755
--- a/tests/generic/238
+++ b/tests/generic/238
@@ -48,6 +48,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/243 b/tests/generic/243
index 127070e..e1d698b 100755
--- a/tests/generic/243
+++ b/tests/generic/243
@@ -47,6 +47,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
+_require_odirect
 
 rm -f $seqres.full
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
