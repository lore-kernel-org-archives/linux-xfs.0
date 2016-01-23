Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F28217F5E
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:37:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 814EBAC001
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:37:12 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 926NCSikCpzNObIe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:37:10 -0800 (PST)
Subject: [PATCH 4/5] dedupe: record dedupe errors in golden output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:37:07 -0800
Message-ID: <20160123003706.2666.81569.stgit@birch.djwong.org>
In-Reply-To: <20160123003648.2666.37062.stgit@birch.djwong.org>
References: <20160123003648.2666.37062.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

The xfs_io dedupe command originally didn't print dedupe errors
to stderr like you'd expect.  Since that was fixed, the golden
output should be changed to reflect that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/122.out |    1 +
 tests/generic/136     |    2 ++
 tests/generic/136.out |    3 +++
 tests/generic/137     |    2 +-
 tests/generic/182.out |    2 ++
 5 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/tests/generic/122.out b/tests/generic/122.out
index c7cfec2..7925e90 100644
--- a/tests/generic/122.out
+++ b/tests/generic/122.out
@@ -4,6 +4,7 @@ Create the original files
 5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
 Files 1-2 do not match (intentional)
 (Fail to) dedupe the middle blocks together
+dedupe: Extents did not match.
 Compare sections
 35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-122/file1
 5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
diff --git a/tests/generic/136 b/tests/generic/136
index 89ee751..5d021f8 100755
--- a/tests/generic/136
+++ b/tests/generic/136
@@ -82,7 +82,9 @@ test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
 test "${C3}" = "${C4}" || echo "file3 and file4 should match"
 
 echo "Dedupe the last blocks together"
+echo "1->2"
 _dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 37 >> "$seqres.full"
+echo "1->3"
 _dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 >> "$seqres.full"
 _test_remount
 
diff --git a/tests/generic/136.out b/tests/generic/136.out
index 99a5465..f76f40a 100644
--- a/tests/generic/136.out
+++ b/tests/generic/136.out
@@ -5,6 +5,9 @@ c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
 07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file3
 07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file4
 Dedupe the last blocks together
+1->2
+1->3
+dedupe: Extents did not match.
 c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file1
 c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
 07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file3
diff --git a/tests/generic/137 b/tests/generic/137
index a640f4f..9cc7948 100755
--- a/tests/generic/137
+++ b/tests/generic/137
@@ -83,7 +83,7 @@ done
 echo "Dedupe block two to the sevens"
 seq 1 $((NR_BLKS / 7)) | while read nr; do
 	_dedupe_range "$TESTDIR/file1" $((BLKSZ * 2)) "$TESTDIR/file1" \
-			$((nr * 7 * BLKSZ)) $BLKSZ >> "$seqres.full"
+			$((nr * 7 * BLKSZ)) $BLKSZ >> "$seqres.full" 2>&1
 done
 
 _test_remount
diff --git a/tests/generic/182.out b/tests/generic/182.out
index 9841b76..049a3ee 100644
--- a/tests/generic/182.out
+++ b/tests/generic/182.out
@@ -1,10 +1,12 @@
 QA output created by 182
 Create the original files
+dedupe: Extents did not match.
 f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
 69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2
 69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2.chk
 Compare against check files
 Make the original file almost dedup-able
+dedupe: Extents did not match.
 f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
 158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2
 158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2.chk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
