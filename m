Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1399329E2A
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:11:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0465D8F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:10 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id KmTpHEqS1gZJH9iv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:09 -0800 (PST)
Subject: [PATCH 02/11] tests: don't leave cruft behind on the TEST_MNT
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:11:05 -0800
Message-ID: <20151219091105.15320.69176.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Don't leave cruft behind on the test device's filesystem, so as to
avoid filling it with debris.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/110 |    2 +-
 tests/generic/111 |    2 +-
 tests/generic/115 |    2 +-
 tests/generic/159 |    2 +-
 tests/generic/160 |    2 +-
 tests/xfs/129     |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/tests/generic/110 b/tests/generic/110
index 468d859..fffadbc 100755
--- a/tests/generic/110
+++ b/tests/generic/110
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.*
+    rm -f $tmp.* "$TESTDIR"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/111 b/tests/generic/111
index 1797233..98077d8 100755
--- a/tests/generic/111
+++ b/tests/generic/111
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.*
+    rm -f $tmp.* "$TESTDIR"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/115 b/tests/generic/115
index b5c64ec..6c8d92d 100755
--- a/tests/generic/115
+++ b/tests/generic/115
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.*
+    rm -f $tmp.* "$TESTDIR"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/159 b/tests/generic/159
index 7944267..369663d 100755
--- a/tests/generic/159
+++ b/tests/generic/159
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
- #   rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$TESTDIR1"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/160 b/tests/generic/160
index e8c43df..4dfee12 100755
--- a/tests/generic/160
+++ b/tests/generic/160
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
- #   rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$TESTDIR1"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/xfs/129 b/tests/xfs/129
index 6279d69..6fb9bac 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -35,7 +35,7 @@ _cleanup()
 {
     cd /
     umount "$SCRATCH_MNT" > /dev/null 2>&1
-    rm -rf "$tmp".* "$TESTDIR" "$METADUMP_FILE"
+    rm -rf "$tmp".* "$TESTDIR" "$METADUMP_FILE" "$TEST_DIR/image"
 }
 
 # get standard environment, filters and checks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
