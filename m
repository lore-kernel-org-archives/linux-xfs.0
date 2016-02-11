Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FE097F61
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:41:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0C3E30405F
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:00 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id le0RIQ03KmI1jcmx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:28 -0800 (PST)
Subject: [PATCH 10/32] reflink: fix style problems in existing tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:40:21 -0800
Message-ID: <20160211234021.2202.2919.stgit@birch.djwong.org>
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

Fix style problems such as unnecessary use of quotes, add helper
variables to reduce visual clutter, and other minor fixes to make the
first batch of tests more closely resemble the second round tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/110 |    2 -
 tests/generic/111 |    2 -
 tests/generic/115 |    2 -
 tests/generic/116 |   44 ++++++++--------
 tests/generic/118 |   42 +++++++--------
 tests/generic/119 |  102 ++++++++++++++++++------------------
 tests/generic/121 |   44 ++++++++--------
 tests/generic/122 |   44 ++++++++--------
 tests/generic/134 |   78 ++++++++++++++--------------
 tests/generic/136 |   78 ++++++++++++++--------------
 tests/generic/137 |   44 ++++++++--------
 tests/generic/138 |  104 ++++++++++++++++++-------------------
 tests/generic/139 |   98 +++++++++++++++++------------------
 tests/generic/140 |  104 ++++++++++++++++++-------------------
 tests/generic/142 |   37 +++++++------
 tests/generic/143 |   37 +++++++------
 tests/generic/144 |  124 ++++++++++++++++++++++----------------------
 tests/generic/145 |  150 +++++++++++++++++++++++++++--------------------------
 tests/generic/146 |  132 +++++++++++++++++++++++------------------------
 tests/generic/147 |  146 ++++++++++++++++++++++++++--------------------------
 tests/generic/148 |   84 +++++++++++++++---------------
 tests/generic/149 |  132 +++++++++++++++++++++++------------------------
 tests/generic/150 |   23 ++++----
 tests/generic/151 |   35 ++++++------
 tests/generic/152 |   39 +++++++-------
 tests/generic/153 |   41 +++++++-------
 tests/generic/154 |   43 ++++++++-------
 tests/generic/155 |   39 +++++++-------
 tests/generic/156 |   43 ++++++++-------
 tests/generic/157 |   60 +++++++++++----------
 tests/generic/158 |   62 +++++++++++-----------
 tests/generic/159 |   19 ++++---
 tests/generic/160 |   19 ++++---
 tests/generic/161 |   25 ++++-----
 tests/generic/162 |   31 +++++------
 tests/generic/163 |   31 +++++------
 tests/generic/164 |   35 ++++++------
 tests/generic/165 |   33 ++++++------
 tests/generic/166 |   25 ++++-----
 tests/generic/167 |   25 ++++-----
 tests/generic/168 |   31 +++++------
 tests/generic/170 |   31 +++++------
 tests/generic/171 |   55 ++++++++++---------
 tests/generic/172 |   55 ++++++++++---------
 tests/generic/173 |   47 ++++++++---------
 tests/generic/174 |   55 ++++++++++---------
 tests/generic/178 |   31 ++++++-----
 tests/generic/179 |   50 +++++++++---------
 tests/generic/180 |   50 +++++++++---------
 tests/generic/181 |   38 +++++++------
 tests/generic/182 |   80 ++++++++++++++--------------
 tests/generic/183 |   50 +++++++++---------
 tests/generic/185 |   50 +++++++++---------
 tests/generic/186 |   69 +++++++++++++-----------
 tests/generic/187 |   69 +++++++++++++-----------
 tests/generic/188 |   34 ++++++------
 tests/generic/189 |   34 ++++++------
 tests/generic/190 |   34 ++++++------
 tests/generic/191 |   34 ++++++------
 tests/generic/194 |   34 ++++++------
 tests/generic/195 |   34 ++++++------
 tests/generic/196 |   34 ++++++------
 tests/generic/197 |   34 ++++++------
 tests/generic/199 |   34 ++++++------
 tests/generic/200 |   34 ++++++------
 tests/generic/201 |   38 +++++++------
 tests/generic/202 |   37 ++++++-------
 tests/generic/203 |   37 ++++++-------
 tests/generic/205 |   47 ++++++++---------
 tests/generic/206 |   47 ++++++++---------
 tests/generic/216 |   47 ++++++++---------
 tests/generic/217 |   47 ++++++++---------
 tests/generic/218 |   39 +++++++-------
 tests/generic/220 |   39 +++++++-------
 tests/generic/222 |   47 ++++++++---------
 tests/generic/227 |   47 ++++++++---------
 tests/generic/229 |   73 +++++++++++++-------------
 tests/generic/238 |   73 +++++++++++++-------------
 tests/generic/242 |   47 ++++++++---------
 tests/generic/243 |   47 ++++++++---------
 tests/xfs/127     |   29 +++++-----
 tests/xfs/128     |   93 ++++++++++++++++-----------------
 tests/xfs/129     |   33 ++++++------
 tests/xfs/131     |   21 ++++---
 tests/xfs/132     |   43 ++++++++-------
 tests/xfs/139     |   31 +++++------
 tests/xfs/140     |   37 ++++++-------
 87 files changed, 2187 insertions(+), 2171 deletions(-)


diff --git a/tests/generic/110 b/tests/generic/110
index a43f02d..1fcdb56 100755
--- a/tests/generic/110
+++ b/tests/generic/110
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.* "$testdir"
+    rm -f $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/111 b/tests/generic/111
index ef9c424..dce9c84 100755
--- a/tests/generic/111
+++ b/tests/generic/111
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.* "$testdir"
+    rm -f $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/115 b/tests/generic/115
index 578d5bd..43ce59c 100755
--- a/tests/generic/115
+++ b/tests/generic/115
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.* "$testdir"
+    rm -f $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/116 b/tests/generic/116
index 5c361e2..18f8073 100755
--- a/tests/generic/116
+++ b/tests/generic/116
@@ -22,8 +22,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -46,44 +46,44 @@ _cleanup()
 _supported_os Linux
 _require_test_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 8)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 8)) \
        || echo "Files do not match"
 
 echo "Reflink the middle blocks together"
-free_before="$(stat -f -c '%a' "$testdir")"
-_reflink_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
-		$((blksz * 4)) $((blksz * 2)) >> "$seqres.full"
+free_before=$(stat -f -c '%a' $testdir)
+_reflink_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
+		$((blksz * 4)) $((blksz * 2)) >> $seqres.full
 _test_remount
-free_after="$(stat -f -c '%a' "$testdir")"
-echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+free_after=$(stat -f -c '%a' $testdir)
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
 
 echo "Compare sections"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 4)) \
        || echo "Start sections do not match"
 
-_compare_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+_compare_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
 		$((blksz * 4)) $((blksz * 2)) \
        || echo "Middle sections do not match"
 
-_compare_range "$testdir/file1" $((blksz * 6)) "$testdir/file2" \
+_compare_range $testdir/file1 $((blksz * 6)) $testdir/file2 \
 		$((blksz * 6)) $((blksz * 2)) \
        || echo "End sections do not match"
 
diff --git a/tests/generic/118 b/tests/generic/118
index 41e525c..6b6478b 100755
--- a/tests/generic/118
+++ b/tests/generic/118
@@ -23,7 +23,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
+seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -47,44 +47,44 @@ _cleanup()
 _supported_os Linux
 _require_test_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $((blksz * 2)) $((blksz * 6)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 8)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 8)) \
        || echo "Files do not match (intentional)"
 
 echo "Reflink the middle blocks together"
-free_before="$(stat -f -c '%a' "$testdir")"
-_reflink_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
-		$((blksz * 4)) $((blksz * 2)) >> "$seqres.full"
+free_before=$(stat -f -c '%a' $testdir)
+_reflink_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
+		$((blksz * 4)) $((blksz * 2)) >> $seqres.full
 _test_remount
-free_after="$(stat -f -c '%a' "$testdir")"
-echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+free_after=$(stat -f -c '%a' $testdir)
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
 
 echo "Compare sections"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 4)) \
        || echo "Start sections do not match (intentional)"
 
-_compare_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+_compare_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
 		$((blksz * 4)) $((blksz * 2)) \
        || echo "Middle sections do not match"
 
-_compare_range "$testdir/file1" $((blksz * 6)) "$testdir/file2" \
+_compare_range $testdir/file1 $((blksz * 6)) $testdir/file2 \
 		$((blksz * 6)) $((blksz * 2)) \
        || echo "End sections do not match (intentional)"
 
diff --git a/tests/generic/119 b/tests/generic/119
index 27e7604..1a7d26e 100755
--- a/tests/generic/119
+++ b/tests/generic/119
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,7 +48,7 @@ _cleanup()
 _supported_os Linux
 _require_test_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 testdir=$TEST_DIR/test-$seq
 rm -rf $testdir
@@ -56,112 +56,112 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz * 8)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * 8)) "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x63 0 $((blksz * 8)) "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x64 0 $((blksz * 8)) "$testdir/file4" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 8)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $((blksz * 8)) $testdir/file2 >> $seqres.full
+_pwrite_byte 0x63 0 $((blksz * 8)) $testdir/file3 >> $seqres.full
+_pwrite_byte 0x64 0 $((blksz * 8)) $testdir/file4 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 8)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 8)) \
        || echo "Files 1-2 do not match (intentional)"
 
-_compare_range "$testdir/file1" 0 "$testdir/file3" 0 $((blksz * 8)) \
+_compare_range $testdir/file1 0 $testdir/file3 0 $((blksz * 8)) \
        || echo "Files 1-3 do not match (intentional)"
 
-_compare_range "$testdir/file1" 0 "$testdir/file4" 0 $((blksz * 8)) \
+_compare_range $testdir/file1 0 $testdir/file4 0 $((blksz * 8)) \
        || echo "Files 1-4 do not match (intentional)"
 
 echo "Reflink the first four blocks together, 1-2 3-4"
-free_before="$(stat -f -c '%a' "$testdir")"
-_reflink_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) >> "$seqres.full"
-_reflink_range "$testdir/file3" 0 "$testdir/file4" 0 $((blksz * 4)) >> "$seqres.full"
+free_before=$(stat -f -c '%a' $testdir)
+_reflink_range $testdir/file1 0 $testdir/file2 0 $((blksz * 4)) >> $seqres.full
+_reflink_range $testdir/file3 0 $testdir/file4 0 $((blksz * 4)) >> $seqres.full
 _test_remount
-free_after="$(stat -f -c '%a' "$testdir")"
-echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+free_after=$(stat -f -c '%a' $testdir)
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
 
 echo "Compare sections"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 4)) \
        || echo "Sections of file 1-2 do not match"
 
-_compare_range "$testdir/file1" 0 "$testdir/file3" 0 $((blksz * 4)) \
+_compare_range $testdir/file1 0 $testdir/file3 0 $((blksz * 4)) \
        || echo "Sections of file 1-3 do not match (intentional)"
 
-_compare_range "$testdir/file1" 0 "$testdir/file4" 0 $((blksz * 4)) \
+_compare_range $testdir/file1 0 $testdir/file4 0 $((blksz * 4)) \
        || echo "Sections of file 1-4 do not match (intentional)"
 
-_compare_range "$testdir/file2" 0 "$testdir/file3" 0 $((blksz * 4)) \
+_compare_range $testdir/file2 0 $testdir/file3 0 $((blksz * 4)) \
        || echo "Sections of file 2-3 do not match (intentional)"
 
-_compare_range "$testdir/file2" 0 "$testdir/file4" 0 $((blksz * 4)) \
+_compare_range $testdir/file2 0 $testdir/file4 0 $((blksz * 4)) \
        || echo "Sections of file 2-4 do not match (intentional)"
 
-_compare_range "$testdir/file3" 0 "$testdir/file4" 0 $((blksz * 4)) \
+_compare_range $testdir/file3 0 $testdir/file4 0 $((blksz * 4)) \
        || echo "Sections of file 3-4 do not match"
 
 echo "Reflink the first two blocks together, 1-3 1-4"
-free_before="$(stat -f -c '%a' $testdir)"
-_reflink_range "$testdir/file1" 0 "$testdir/file3" 0 $((blksz * 2)) >> "$seqres.full"
-_reflink_range "$testdir/file1" 0 "$testdir/file4" 0 $((blksz * 2)) >> "$seqres.full"
+free_before=$(stat -f -c '%a' $testdir)
+_reflink_range $testdir/file1 0 $testdir/file3 0 $((blksz * 2)) >> $seqres.full
+_reflink_range $testdir/file1 0 $testdir/file4 0 $((blksz * 2)) >> $seqres.full
 _test_remount
-free_after="$(stat -f -c '%a' $testdir)"
-echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+free_after=$(stat -f -c '%a' $testdir)
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
 
 echo "Compare sections"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 2)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 2)) \
        || echo "Sections of files 1-2 do not match"
 
-_compare_range "$testdir/file1" 0 "$testdir/file3" 0 $((blksz * 2)) \
+_compare_range $testdir/file1 0 $testdir/file3 0 $((blksz * 2)) \
        || echo "Sections of files 1-3 do not match"
 
-_compare_range "$testdir/file1" 0 "$testdir/file4" 0 $((blksz * 2)) \
+_compare_range $testdir/file1 0 $testdir/file4 0 $((blksz * 2)) \
        || echo "Sections of files 1-4 do not match"
 
-_compare_range "$testdir/file2" 0 "$testdir/file3" 0 $((blksz * 2)) \
+_compare_range $testdir/file2 0 $testdir/file3 0 $((blksz * 2)) \
        || echo "Sections of files 2-3 do not match"
 
-_compare_range "$testdir/file2" 0 "$testdir/file4" 0 $((blksz * 2)) \
+_compare_range $testdir/file2 0 $testdir/file4 0 $((blksz * 2)) \
        || echo "Sections of files 2-4 do not match"
 
-_compare_range "$testdir/file3" 0 "$testdir/file4" 0 $((blksz * 2)) \
+_compare_range $testdir/file3 0 $testdir/file4 0 $((blksz * 2)) \
        || echo "Sections of files 3-4 do not match"
 
 echo "Compare previously reflinked sections"
-_compare_range "$testdir/file1" $((blksz * 2)) "$testdir/file2" \
+_compare_range $testdir/file1 $((blksz * 2)) $testdir/file2 \
 		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 1-2 do not match"
 
-_compare_range "$testdir/file1" $((blksz * 2)) "$testdir/file3" \
+_compare_range $testdir/file1 $((blksz * 2)) $testdir/file3 \
 		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 1-3 do not match (intentional)"
 
-_compare_range "$testdir/file1" $((blksz * 2)) "$testdir/file4" \
+_compare_range $testdir/file1 $((blksz * 2)) $testdir/file4 \
 		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 1-4 do not match (intentional)"
 
-_compare_range "$testdir/file2" $((blksz * 2)) "$testdir/file3" \
+_compare_range $testdir/file2 $((blksz * 2)) $testdir/file3 \
 		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 2-3 do not match (intentional)"
 
-_compare_range "$testdir/file2" $((blksz * 2)) "$testdir/file4" \
+_compare_range $testdir/file2 $((blksz * 2)) $testdir/file4 \
 		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 2-4 do not match (intentional)"
 
-_compare_range "$testdir/file3" $((blksz * 2)) "$testdir/file4" \
+_compare_range $testdir/file3 $((blksz * 2)) $testdir/file4 \
 		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 3-4 do not match"
 
diff --git a/tests/generic/121 b/tests/generic/121
index 0e15e8d..7d6f982 100755
--- a/tests/generic/121
+++ b/tests/generic/121
@@ -22,8 +22,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -46,44 +46,44 @@ _cleanup()
 _supported_os Linux
 _require_test_dedupe
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 8)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 8)) \
        || echo "Files 1-2 do not match (intentional)"
 
 echo "Dedupe the middle blocks together"
-free_before="$(stat -f -c '%a' "$testdir")"
-_dedupe_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
-		$((blksz * 4)) $((blksz * 2)) >> "$seqres.full"
+free_before=$(stat -f -c '%a' $testdir)
+_dedupe_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
+		$((blksz * 4)) $((blksz * 2)) >> $seqres.full
 _test_remount
-free_after="$(stat -f -c '%a' "$testdir")"
-echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+free_after=$(stat -f -c '%a' $testdir)
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
 
 echo "Compare sections"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 4)) \
        || echo "Start sections do not match"
 
-_compare_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+_compare_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
 		$((blksz * 4)) $((blksz * 2)) \
        || echo "Middle sections do not match"
 
-_compare_range "$testdir/file1" $((blksz * 6)) "$testdir/file2" \
+_compare_range $testdir/file1 $((blksz * 6)) $testdir/file2 \
 		$((blksz * 6)) $((blksz * 2)) \
        || echo "End sections do not match"
 
diff --git a/tests/generic/122 b/tests/generic/122
index e7585f7..d5cc3a2 100755
--- a/tests/generic/122
+++ b/tests/generic/122
@@ -22,8 +22,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -46,44 +46,44 @@ _cleanup()
 _supported_os Linux
 _require_test_dedupe
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $((blksz * 2)) $((blksz * 6)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 "$((blksz * 8))" \
+_compare_range $testdir/file1 0 $testdir/file2 0 "$((blksz * 8))" \
        || echo "Files 1-2 do not match (intentional)"
 
 echo "(Fail to) dedupe the middle blocks together"
-free_before="$(stat -f -c '%a' "$testdir")"
-_dedupe_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
-		$((blksz * 4)) $((blksz * 2)) >> "$seqres.full"
+free_before=$(stat -f -c '%a' $testdir)
+_dedupe_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
+		$((blksz * 4)) $((blksz * 2)) >> $seqres.full
 _test_remount
-free_after="$(stat -f -c '%a' "$testdir")"
-echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
+free_after=$(stat -f -c '%a' $testdir)
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
 
 echo "Compare sections"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
+_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 4)) \
        || echo "Start sections do not match (intentional)"
 
-_compare_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+_compare_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
 		$((blksz * 4)) $((blksz * 2)) \
        || echo "Middle sections do not match (intentional)"
 
-_compare_range "$testdir/file1" $((blksz * 6)) "$testdir/file2" \
+_compare_range $testdir/file1 $((blksz * 6)) $testdir/file2 \
 		$((blksz * 6)) $((blksz * 2)) \
        || echo "End sections do not match (intentional)"
 
diff --git a/tests/generic/134 b/tests/generic/134
index 1dda839..b1b1fa7 100755
--- a/tests/generic/134
+++ b/tests/generic/134
@@ -26,8 +26,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,46 +50,46 @@ _cleanup()
 _supported_os Linux
 _require_test_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz + 37)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((blksz + 37)) "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz + 37)) "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz + 37)) "$testdir/file4" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz + 37)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz + 37)) $testdir/file2 >> $seqres.full
+_pwrite_byte 0x62 0 $((blksz + 37)) $testdir/file3 >> $seqres.full
+_pwrite_byte 0x62 0 $((blksz + 37)) $testdir/file4 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
 
 c1="$(_md5_checksum $testdir/file1)"
 c2="$(_md5_checksum $testdir/file2)"
 c3="$(_md5_checksum $testdir/file3)"
 c4="$(_md5_checksum $testdir/file4)"
 
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
-test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
-test "${c3}" = "${c4}" || echo "file3 and file4 should match"
+test ${c1} = ${c2} || echo "file1 and file2 should match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c1} != ${c4} || echo "file1 and file4 should not match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
+test ${c2} != ${c4} || echo "file2 and file4 should not match"
+test ${c3} = ${c4} || echo "file3 and file4 should match"
 
 echo "Reflink the last blocks together, 1-2 1-3"
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $blksz 37 >> "$seqres.full"
-_reflink_range "$testdir/file1" $blksz "$testdir/file3" $blksz 37 >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $blksz 37 >> $seqres.full
+_reflink_range $testdir/file1 $blksz $testdir/file3 $blksz 37 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
 
 c1="$(_md5_checksum $testdir/file1)"
 c2="$(_md5_checksum $testdir/file2)"
@@ -97,30 +97,30 @@ c3="$(_md5_checksum $testdir/file3)"
 c4="$(_md5_checksum $testdir/file4)"
 
 echo "Compare files"
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
-test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
-test "${c3}" != "${c4}" || echo "file3 and file4 should match"
+test ${c1} = ${c2} || echo "file1 and file2 should match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c1} != ${c4} || echo "file1 and file4 should not match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
+test ${c2} != ${c4} || echo "file2 and file4 should not match"
+test ${c3} != ${c4} || echo "file3 and file4 should match"
 
 echo "Compare sections"
-_compare_range "$testdir/file1" $blksz "$testdir/file2" $blksz 37 \
+_compare_range $testdir/file1 $blksz $testdir/file2 $blksz 37 \
        || echo "End sections of files 1-2 do not match"
 
-_compare_range "$testdir/file1" $blksz "$testdir/file3" $blksz 37 \
+_compare_range $testdir/file1 $blksz $testdir/file3 $blksz 37 \
        || echo "End sections of files 1-3 do not match"
 
-_compare_range "$testdir/file1" $blksz "$testdir/file4" $blksz 37 \
+_compare_range $testdir/file1 $blksz $testdir/file4 $blksz 37 \
        || echo "End sections of files 1-4 do not match (intentional)"
 
-_compare_range "$testdir/file2" $blksz "$testdir/file3" $blksz 37 \
+_compare_range $testdir/file2 $blksz $testdir/file3 $blksz 37 \
        || echo "End sections of files 2-3 do not match"
 
-_compare_range "$testdir/file2" $blksz "$testdir/file4" $blksz 37 \
+_compare_range $testdir/file2 $blksz $testdir/file4 $blksz 37 \
        || echo "End sections of files 2-4 do not match (intentional)"
 
-_compare_range "$testdir/file3" $blksz "$testdir/file4" $blksz 37 \
+_compare_range $testdir/file3 $blksz $testdir/file4 $blksz 37 \
        || echo "End sections of files 3-4 do not match (intentional)"
 
 # success, all done
diff --git a/tests/generic/136 b/tests/generic/136
index 6bd6b14..bc69fa7 100755
--- a/tests/generic/136
+++ b/tests/generic/136
@@ -26,8 +26,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,48 +50,48 @@ _cleanup()
 _supported_os Linux
 _require_test_dedupe
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz + 37)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((blksz + 37)) "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz + 37)) "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz + 37)) "$testdir/file4" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz + 37)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz + 37)) $testdir/file2 >> $seqres.full
+_pwrite_byte 0x62 0 $((blksz + 37)) $testdir/file3 >> $seqres.full
+_pwrite_byte 0x62 0 $((blksz + 37)) $testdir/file4 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
 
 c1="$(_md5_checksum $testdir/file1)"
 c2="$(_md5_checksum $testdir/file2)"
 c3="$(_md5_checksum $testdir/file3)"
 c4="$(_md5_checksum $testdir/file4)"
 
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
-test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
-test "${c3}" = "${c4}" || echo "file3 and file4 should match"
+test ${c1} = ${c2} || echo "file1 and file2 should match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c1} != ${c4} || echo "file1 and file4 should not match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
+test ${c2} != ${c4} || echo "file2 and file4 should not match"
+test ${c3} = ${c4} || echo "file3 and file4 should match"
 
 echo "Dedupe the last blocks together"
 echo "1->2"
-_dedupe_range "$testdir/file1" $blksz "$testdir/file2" $blksz 37 >> "$seqres.full"
+_dedupe_range $testdir/file1 $blksz $testdir/file2 $blksz 37 >> $seqres.full
 echo "1->3"
-_dedupe_range "$testdir/file1" $blksz "$testdir/file3" $blksz 37 >> "$seqres.full"
+_dedupe_range $testdir/file1 $blksz $testdir/file3 $blksz 37 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
 
 c1="$(_md5_checksum $testdir/file1)"
 c2="$(_md5_checksum $testdir/file2)"
@@ -99,30 +99,30 @@ c3="$(_md5_checksum $testdir/file3)"
 c4="$(_md5_checksum $testdir/file4)"
 
 echo "Compare files"
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
-test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
-test "${c3}" = "${c4}" || echo "file3 and file4 should match"
+test ${c1} = ${c2} || echo "file1 and file2 should match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c1} != ${c4} || echo "file1 and file4 should not match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
+test ${c2} != ${c4} || echo "file2 and file4 should not match"
+test ${c3} = ${c4} || echo "file3 and file4 should match"
 
 echo "Compare sections"
-_compare_range "$testdir/file1" $blksz "$testdir/file2" $blksz 37 \
+_compare_range $testdir/file1 $blksz $testdir/file2 $blksz 37 \
        || echo "End sections of files 1-2 do not match"
 
-_compare_range "$testdir/file1" $blksz "$testdir/file3" $blksz 37 \
+_compare_range $testdir/file1 $blksz $testdir/file3 $blksz 37 \
        || echo "End sections of files 1-3 do not match (intentional)"
 
-_compare_range "$testdir/file1" $blksz "$testdir/file4" $blksz 37 \
+_compare_range $testdir/file1 $blksz $testdir/file4 $blksz 37 \
        || echo "End sections of files 1-4 do not match (intentional)"
 
-_compare_range "$testdir/file2" $blksz "$testdir/file3" $blksz 37 \
+_compare_range $testdir/file2 $blksz $testdir/file3 $blksz 37 \
        || echo "End sections of files 2-3 do not match (intentional)"
 
-_compare_range "$testdir/file2" $blksz "$testdir/file4" $blksz 37 \
+_compare_range $testdir/file2 $blksz $testdir/file4 $blksz 37 \
        || echo "End sections of files 2-4 do not match (intentional)"
 
-_compare_range "$testdir/file3" $blksz "$testdir/file4" $blksz 37 \
+_compare_range $testdir/file3 $blksz $testdir/file4 $blksz 37 \
        || echo "End sections of files 3-4 do not match"
 
 # success, all done
diff --git a/tests/generic/137 b/tests/generic/137
index dcfd90d..19a7ab4 100755
--- a/tests/generic/137
+++ b/tests/generic/137
@@ -26,8 +26,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -52,57 +52,57 @@ _require_test_reflink
 _require_test_dedupe
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
 blksz=65536
-_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $((blksz * 2)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 $blksz $((blksz * 2)) $testdir/file1 >> $seqres.full
 
 nr_blks=1024
 
 echo "fallocate half the file"
-"$XFS_IO_PROG" -f -c "falloc $((nr_blks * blksz / 2)) $((nr_blks * blksz / 2))" "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc $((nr_blks * blksz / 2)) $((nr_blks * blksz / 2))" $testdir/file1 >> $seqres.full
 
 echo "Reflink block zero to the threes"
 seq 1 $((nr_blks / 3)) | while read nr; do
-	_reflink_range "$testdir/file1" 0 "$testdir/file1" $((nr * 3 * blksz)) \
-			$blksz >> "$seqres.full"
+	_reflink_range $testdir/file1 0 $testdir/file1 $((nr * 3 * blksz)) \
+			$blksz >> $seqres.full
 done
 
 echo "Reflink block one to the fives"
 seq 1 $((nr_blks / 5)) | while read nr; do
-	_reflink_range "$testdir/file1" $blksz "$testdir/file1" \
-			$((nr * 5 * blksz)) $blksz >> "$seqres.full"
+	_reflink_range $testdir/file1 $blksz $testdir/file1 \
+			$((nr * 5 * blksz)) $blksz >> $seqres.full
 done
 
 echo "Dedupe block two to the sevens"
 seq 1 $((nr_blks / 7)) | while read nr; do
-	_dedupe_range "$testdir/file1" $((blksz * 2)) "$testdir/file1" \
-			$((nr * 7 * blksz)) $blksz >> "$seqres.full" 2>&1
+	_dedupe_range $testdir/file1 $((blksz * 2)) $testdir/file1 \
+			$((nr * 7 * blksz)) $blksz >> $seqres.full 2>&1
 done
 
 _test_remount
 
 echo "Check block mappings"
-md5sum "$testdir/file1" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
 
 crcZ=$(_md5_range_checksum /dev/zero 0 $blksz)
-crc0=$(_md5_range_checksum "$testdir/file1" 0 $blksz)
-crc1=$(_md5_range_checksum "$testdir/file1" $blksz $blksz)
-crc2=$(_md5_range_checksum "$testdir/file1" $((blksz * 2)) $blksz)
+crc0=$(_md5_range_checksum $testdir/file1 0 $blksz)
+crc1=$(_md5_range_checksum $testdir/file1 $blksz $blksz)
+crc2=$(_md5_range_checksum $testdir/file1 $((blksz * 2)) $blksz)
 
 check_block() {
-	lblk="$1"
+	lblk=$1
 	rem7=$((lblk % 7))
 	rem5=$((lblk % 5))
 	rem3=$((lblk % 3))
 
-	crc=$(_md5_range_checksum "$testdir/file1" $((lblk * blksz)) $blksz)
+	crc=$(_md5_range_checksum $testdir/file1 $((lblk * blksz)) $blksz)
 
 	if [ $rem7 -eq 0 ]; then
 		if [ $rem5 -eq 0 ]; then
diff --git a/tests/generic/138 b/tests/generic/138
index 59d23e9..c8b4255 100755
--- a/tests/generic/138
+++ b/tests/generic/138
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,103 +48,103 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) $testdir/file3 >> $seqres.full
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
 
-cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 do not match"
-cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 do not match"
-cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 do not match"
+cmp -s $testdir/file1 $testdir/file2 || echo "Files 1-2 do not match"
+cmp -s $testdir/file1 $testdir/file3 || echo "Files 1-3 do not match"
+cmp -s $testdir/file2 $testdir/file3 || echo "Files 2-3 do not match"
 
 echo "pagecache CoW the second file"
-_pwrite_byte 0x62 0 17 "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 17 "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 17 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x62 0 17 $testdir/file3 >> $seqres.full
 
-_pwrite_byte 0x62 $((blksz * 16 - 34)) 17 "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x62 $((blksz * 16 - 34)) 17 "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 16 - 34)) 17 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 16 - 34)) 17 $testdir/file3 >> $seqres.full
 
-_pwrite_byte 0x62 $((blksz * 48 - 8)) 17 "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x62 $((blksz * 48 - 8)) 17 "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 48 - 8)) 17 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 48 - 8)) 17 $testdir/file3 >> $seqres.full
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
 
-cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 do not match (intentional)"
-cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 do not match (intentional)"
-cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 do not match"
+cmp -s $testdir/file1 $testdir/file2 || echo "Files 1-2 do not match (intentional)"
+cmp -s $testdir/file1 $testdir/file3 || echo "Files 1-3 do not match (intentional)"
+cmp -s $testdir/file2 $testdir/file3 || echo "Files 2-3 do not match"
 
 echo "Compare the CoW'd section to the before file"
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 17 \
+_compare_range $testdir/file1 0 $testdir/file2 0 17 \
        || echo "Start sections do not match (intentional)"
 
-_compare_range  "$testdir/file1" $((blksz * 16 - 34)) \
-		"$testdir/file2" $((blksz * 16 - 34)) 17 \
+_compare_range  $testdir/file1 $((blksz * 16 - 34)) \
+		$testdir/file2 $((blksz * 16 - 34)) 17 \
        || echo "Middle sections do not match (intentional)"
 
-_compare_range  "$testdir/file1" $((blksz * 48 - 8)) \
-		"$testdir/file2" $((blksz * 48 - 8)) 17 \
+_compare_range  $testdir/file1 $((blksz * 48 - 8)) \
+		$testdir/file2 $((blksz * 48 - 8)) 17 \
        || echo "End sections do not match (intentional)"
 
 echo "Compare the CoW'd section to the after file"
-_compare_range "$testdir/file2" 0 "$testdir/file3" 0 17 \
+_compare_range $testdir/file2 0 $testdir/file3 0 17 \
        || echo "Start sections do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 16 - 34)) \
-		"$testdir/file3" $((blksz * 16 - 34)) 17 \
+_compare_range  $testdir/file2 $((blksz * 16 - 34)) \
+		$testdir/file3 $((blksz * 16 - 34)) 17 \
        || echo "Middle sections do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 48 - 8)) \
-		"$testdir/file3" $((blksz * 48 - 8)) 17 \
+_compare_range  $testdir/file2 $((blksz * 48 - 8)) \
+		$testdir/file3 $((blksz * 48 - 8)) 17 \
        || echo "End sections do not match"
 
 echo "Compare the not CoW'd sections"
-_compare_range "$testdir/file1" 18 "$testdir/file2" 18 17 \
+_compare_range $testdir/file1 18 $testdir/file2 18 17 \
        || echo "Start sections of 1-2 do not match"
 
-_compare_range "$testdir/file2" 18 "$testdir/file3" 18 17 \
+_compare_range $testdir/file2 18 $testdir/file3 18 17 \
        || echo "Start sections of 2-3 do not match"
 
 
-_compare_range  "$testdir/file1" $((blksz * 16 - 17)) \
-		"$testdir/file2" $((blksz * 16 - 17)) 82 \
+_compare_range  $testdir/file1 $((blksz * 16 - 17)) \
+		$testdir/file2 $((blksz * 16 - 17)) 82 \
        || echo "Middle sections of 1-2 do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 16 - 17)) \
-		"$testdir/file3" $((blksz * 16 - 17)) 82 \
+_compare_range  $testdir/file2 $((blksz * 16 - 17)) \
+		$testdir/file3 $((blksz * 16 - 17)) 82 \
        || echo "Middle sections of 2-3 do not match"
 
-_compare_range  "$testdir/file1" $((blksz * 48 - 108)) \
-		"$testdir/file2" $((blksz * 48 - 108)) 100 \
+_compare_range  $testdir/file1 $((blksz * 48 - 108)) \
+		$testdir/file2 $((blksz * 48 - 108)) 100 \
        || echo "End sections of 1-2 do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 48 - 108)) \
-		"$testdir/file3" $((blksz * 48 - 108)) 100 \
+_compare_range  $testdir/file2 $((blksz * 48 - 108)) \
+		$testdir/file3 $((blksz * 48 - 108)) 100 \
        || echo "End sections of 2-3 do not match"
 
 
-_compare_range  "$testdir/file1" $((blksz * 14)) \
-		"$testdir/file2" $((blksz * 14)) $blksz \
+_compare_range  $testdir/file1 $((blksz * 14)) \
+		$testdir/file2 $((blksz * 14)) $blksz \
        || echo "Untouched sections of 1-2 do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 14)) \
-		"$testdir/file3" $((blksz * 14)) $blksz \
+_compare_range  $testdir/file2 $((blksz * 14)) \
+		$testdir/file3 $((blksz * 14)) $blksz \
        || echo "Untouched sections of 2-3 do not match"
 
 # success, all done
diff --git a/tests/generic/139 b/tests/generic/139
index 59e5bff..5e7b631 100755
--- a/tests/generic/139
+++ b/tests/generic/139
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,7 +48,7 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 testdir=$TEST_DIR/test-$seq
 rm -rf $testdir
@@ -56,94 +56,94 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) $testdir/file3 >> $seqres.full
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
 
-cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 should match"
-cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 should match"
-cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 should match"
+cmp -s $testdir/file1 $testdir/file2 || echo "Files 1-2 should match"
+cmp -s $testdir/file1 $testdir/file3 || echo "Files 1-3 should match"
+cmp -s $testdir/file2 $testdir/file3 || echo "Files 2-3 should match"
 
 echo "directio CoW the second file"
-_pwrite_byte 0x62 0 $blksz "$testdir/file2" -d >> "$seqres.full"
-_pwrite_byte 0x62 0 $blksz "$testdir/file3" -d >> "$seqres.full"
+_pwrite_byte 0x62 0 $blksz $testdir/file2 -d >> $seqres.full
+_pwrite_byte 0x62 0 $blksz $testdir/file3 -d >> $seqres.full
 
-_pwrite_byte 0x62 $((blksz * 16 - 512)) 512 "$testdir/file2" -d >> "$seqres.full"
-_pwrite_byte 0x62 $((blksz * 16 - 512)) 512 "$testdir/file3" -d >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 16 - 512)) 512 $testdir/file2 -d >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 16 - 512)) 512 $testdir/file3 -d >> $seqres.full
 
-_pwrite_byte 0x62 $((blksz * 48)) $blksz "$testdir/file2" -d >> "$seqres.full"
-_pwrite_byte 0x62 $((blksz * 48)) $blksz "$testdir/file3" -d >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 48)) $blksz $testdir/file2 -d >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 48)) $blksz $testdir/file3 -d >> $seqres.full
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
 
-cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 should not match (intentional)"
-cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 should not match (intentional)"
-cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 should match"
+cmp -s $testdir/file1 $testdir/file2 || echo "Files 1-2 should not match (intentional)"
+cmp -s $testdir/file1 $testdir/file3 || echo "Files 1-3 should not match (intentional)"
+cmp -s $testdir/file2 $testdir/file3 || echo "Files 2-3 should match"
 
 echo "Compare the CoW'd section to the before file"
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $blksz \
+_compare_range $testdir/file1 0 $testdir/file2 0 $blksz \
        || echo "Start sections do not match (intentional)"
 
-_compare_range  "$testdir/file1" $((blksz * 16 - 512)) \
-		"$testdir/file2" $((blksz * 16 - 512)) 512 \
+_compare_range  $testdir/file1 $((blksz * 16 - 512)) \
+		$testdir/file2 $((blksz * 16 - 512)) 512 \
        || echo "Middle sections do not match (intentional)"
 
-_compare_range  "$testdir/file1" $((blksz * 48 - 512)) \
-		"$testdir/file2" $((blksz * 48 - 512)) $blksz \
+_compare_range  $testdir/file1 $((blksz * 48 - 512)) \
+		$testdir/file2 $((blksz * 48 - 512)) $blksz \
        || echo "End sections do not match (intentional)"
 
 echo "Compare the CoW'd section to the after file"
-_compare_range "$testdir/file2" 0 "$testdir/file3" 0 $blksz \
+_compare_range $testdir/file2 0 $testdir/file3 0 $blksz \
        || echo "Start sections do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 16 - 512)) \
-		"$testdir/file3" $((blksz * 16 - 512)) 512 \
+_compare_range  $testdir/file2 $((blksz * 16 - 512)) \
+		$testdir/file3 $((blksz * 16 - 512)) 512 \
        || echo "Middle sections do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 48 - 512)) \
-		"$testdir/file3" $((blksz * 48 - 512)) $blksz \
+_compare_range  $testdir/file2 $((blksz * 48 - 512)) \
+		$testdir/file3 $((blksz * 48 - 512)) $blksz \
        || echo "End sections do not match"
 
 echo "Compare the not CoW'd sections"
-_compare_range "$testdir/file1" $blksz "$testdir/file2" $blksz 512 \
+_compare_range $testdir/file1 $blksz $testdir/file2 $blksz 512 \
        || echo "Start sections of 1-2 do not match"
-_compare_range "$testdir/file2" $blksz "$testdir/file3" $blksz 512 \
+_compare_range $testdir/file2 $blksz $testdir/file3 $blksz 512 \
        || echo "Start sections of 2-3 do not match"
 
 
-_compare_range  "$testdir/file1" $((blksz * 16 - 1024)) \
-		"$testdir/file2" $((blksz * 16 - 1024)) 512 \
+_compare_range  $testdir/file1 $((blksz * 16 - 1024)) \
+		$testdir/file2 $((blksz * 16 - 1024)) 512 \
        || echo "Middle sections of 1-2 do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 16 - 1024)) \
-		"$testdir/file3" $((blksz * 16 - 1024)) 512 \
+_compare_range  $testdir/file2 $((blksz * 16 - 1024)) \
+		$testdir/file3 $((blksz * 16 - 1024)) 512 \
        || echo "Middle sections of 2-3 do not match"
 
-_compare_range  "$testdir/file1" $((blksz * 48 - 1024)) \
-		"$testdir/file2" $((blksz * 48 - 1024)) 512 \
+_compare_range  $testdir/file1 $((blksz * 48 - 1024)) \
+		$testdir/file2 $((blksz * 48 - 1024)) 512 \
        || echo "End sections of 1-2 do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 48 - 1024)) \
-		"$testdir/file3" $((blksz * 48 - 1024)) 512 \
+_compare_range  $testdir/file2 $((blksz * 48 - 1024)) \
+		$testdir/file3 $((blksz * 48 - 1024)) 512 \
        || echo "End sections of 2-3 do not match"
 
 
-_compare_range  "$testdir/file1" $((blksz * 16)) \
-		"$testdir/file2" $((blksz * 16)) 512 \
+_compare_range  $testdir/file1 $((blksz * 16)) \
+		$testdir/file2 $((blksz * 16)) 512 \
        || echo "Untouched sections of 1-2 do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 16)) \
-		"$testdir/file3" $((blksz * 16)) 512 \
+_compare_range  $testdir/file2 $((blksz * 16)) \
+		$testdir/file3 $((blksz * 16)) 512 \
        || echo "Untouched sections of 2-3 do not match"
 
 # success, all done
diff --git a/tests/generic/140 b/tests/generic/140
index e8e7655..5bcd4ef 100755
--- a/tests/generic/140
+++ b/tests/generic/140
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,103 +48,103 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) $testdir/file3 >> $seqres.full
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
 
-cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 do not match"
-cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 do not match"
-cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 do not match"
+cmp -s $testdir/file1 $testdir/file2 || echo "Files 1-2 do not match"
+cmp -s $testdir/file1 $testdir/file3 || echo "Files 1-3 do not match"
+cmp -s $testdir/file2 $testdir/file3 || echo "Files 2-3 do not match"
 
 echo "mmap CoW the second file"
-_mwrite_byte 0x62 0 17 $((blksz * 48 - 3)) "$testdir/file2" >> "$seqres.full"
-_mwrite_byte 0x62 0 17 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
+_mwrite_byte 0x62 0 17 $((blksz * 48 - 3)) $testdir/file2 >> $seqres.full
+_mwrite_byte 0x62 0 17 $((blksz * 48 - 3)) $testdir/file3 >> $seqres.full
 
-_mwrite_byte 0x62 $((blksz * 16 - 34)) 17 $((blksz * 48 - 3)) "$testdir/file2" >> "$seqres.full"
-_mwrite_byte 0x62 $((blksz * 16 - 34)) 17 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
+_mwrite_byte 0x62 $((blksz * 16 - 34)) 17 $((blksz * 48 - 3)) $testdir/file2 >> $seqres.full
+_mwrite_byte 0x62 $((blksz * 16 - 34)) 17 $((blksz * 48 - 3)) $testdir/file3 >> $seqres.full
 
-_mwrite_byte 0x62 $((blksz * 48 - 20)) 17 $((blksz * 48 - 3)) "$testdir/file2" >> "$seqres.full"
-_mwrite_byte 0x62 $((blksz * 48 - 20)) 17 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
+_mwrite_byte 0x62 $((blksz * 48 - 20)) 17 $((blksz * 48 - 3)) $testdir/file2 >> $seqres.full
+_mwrite_byte 0x62 $((blksz * 48 - 20)) 17 $((blksz * 48 - 3)) $testdir/file3 >> $seqres.full
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
 
-cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 do not match (intentional)"
-cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 do not match (intentional)"
-cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 do not match"
+cmp -s $testdir/file1 $testdir/file2 || echo "Files 1-2 do not match (intentional)"
+cmp -s $testdir/file1 $testdir/file3 || echo "Files 1-3 do not match (intentional)"
+cmp -s $testdir/file2 $testdir/file3 || echo "Files 2-3 do not match"
 
 echo "Compare the CoW'd section to the before file"
-_compare_range "$testdir/file1" 0 "$testdir/file2" 0 17 \
+_compare_range $testdir/file1 0 $testdir/file2 0 17 \
        || echo "Start sections do not match (intentional)"
 
-_compare_range  "$testdir/file1" $((blksz * 16 - 34)) \
-		"$testdir/file2" $((blksz * 16 - 34)) 17 \
+_compare_range  $testdir/file1 $((blksz * 16 - 34)) \
+		$testdir/file2 $((blksz * 16 - 34)) 17 \
        || echo "Middle sections do not match (intentional)"
 
-_compare_range  "$testdir/file1" $((blksz * 48 - 20)) \
-		"$testdir/file2" $((blksz * 48 - 20)) 17 \
+_compare_range  $testdir/file1 $((blksz * 48 - 20)) \
+		$testdir/file2 $((blksz * 48 - 20)) 17 \
        || echo "End sections do not match (intentional)"
 
 echo "Compare the CoW'd section to the after file"
-_compare_range "$testdir/file2" 0 "$testdir/file3" 0 17 \
+_compare_range $testdir/file2 0 $testdir/file3 0 17 \
        || echo "Start sections do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 16 - 34)) \
-		"$testdir/file3" $((blksz * 16 - 34)) 17 \
+_compare_range  $testdir/file2 $((blksz * 16 - 34)) \
+		$testdir/file3 $((blksz * 16 - 34)) 17 \
        || echo "Middle sections do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 48 - 20)) \
-		"$testdir/file3" $((blksz * 48 - 20)) 17 \
+_compare_range  $testdir/file2 $((blksz * 48 - 20)) \
+		$testdir/file3 $((blksz * 48 - 20)) 17 \
        || echo "End sections do not match"
 
 echo "Compare the not CoW'd sections"
-_compare_range "$testdir/file1" 18 "$testdir/file2" 18 17 \
+_compare_range $testdir/file1 18 $testdir/file2 18 17 \
        || echo "Start sections of 1-2 do not match"
 
-_compare_range "$testdir/file2" 18 "$testdir/file3" 18 17 \
+_compare_range $testdir/file2 18 $testdir/file3 18 17 \
        || echo "Start sections of 2-3 do not match"
 
 
-_compare_range  "$testdir/file1" $((blksz * 16 - 17)) \
-		"$testdir/file2" $((blksz * 16 - 17)) 82 \
+_compare_range  $testdir/file1 $((blksz * 16 - 17)) \
+		$testdir/file2 $((blksz * 16 - 17)) 82 \
        || echo "Middle sections of 1-2 do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 16 - 17)) \
-		"$testdir/file3" $((blksz * 16 - 17)) 82 \
+_compare_range  $testdir/file2 $((blksz * 16 - 17)) \
+		$testdir/file3 $((blksz * 16 - 17)) 82 \
        || echo "Middle sections of 2-3 do not match"
 
-_compare_range  "$testdir/file1" $((blksz * 48 - 120)) \
-		"$testdir/file2" $((blksz * 48 - 120)) 100 \
+_compare_range  $testdir/file1 $((blksz * 48 - 120)) \
+		$testdir/file2 $((blksz * 48 - 120)) 100 \
        || echo "End sections of 1-2 do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 48 - 120)) \
-		"$testdir/file3" $((blksz * 48 - 120)) 100 \
+_compare_range  $testdir/file2 $((blksz * 48 - 120)) \
+		$testdir/file3 $((blksz * 48 - 120)) 100 \
        || echo "End sections of 2-3 do not match"
 
 
-_compare_range  "$testdir/file1" $((blksz * 14)) \
-		"$testdir/file2" $((blksz * 14)) $blksz \
+_compare_range  $testdir/file1 $((blksz * 14)) \
+		$testdir/file2 $((blksz * 14)) $blksz \
        || echo "Untouched sections of 1-2 do not match"
 
-_compare_range  "$testdir/file2" $((blksz * 14)) \
-		"$testdir/file3" $((blksz * 14)) $blksz \
+_compare_range  $testdir/file2 $((blksz * 14)) \
+		$testdir/file3 $((blksz * 14)) $blksz \
        || echo "Untouched sections of 2-3 do not match"
 
 # success, all done
diff --git a/tests/generic/142 b/tests/generic/142
index 2ac4d10..e9a2d5e 100755
--- a/tests/generic/142
+++ b/tests/generic/142
@@ -25,8 +25,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,41 +50,42 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
 blksz=65536
 nr=9
-_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $((blksz * 256)) $testdir/file1 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-csum="$(_md5_checksum "$testdir/file1")"
+md5sum $testdir/file1 | _filter_test_dir
+csum=$(_md5_checksum $testdir/file1)
 
 echo "Create the reflink copies"
 seq 2 $nr | while read i; do
-	_cp_reflink "$testdir/file1" "$testdir/file$i"
+	_cp_reflink $testdir/file1 $testdir/file$i
 done
 _test_remount
 
 echo "Rewrite the copies"
 seq 2 $nr | while read i; do
-	_pwrite_byte 0x62 0 $((blksz * 256)) "$testdir/file$i" >> "$seqres.full"
+	_pwrite_byte 0x62 0 $((blksz * 256)) $testdir/file$i >> $seqres.full
 done
 _test_remount
 
 echo "Examine original file"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-mod_csum="$(_md5_checksum "$testdir/file2")"
-new_csum="$(_md5_checksum "$testdir/file1")"
-test "${csum}" != "${mod_csum}" || echo "checksums do not match"
-test "${csum}" = "${new_csum}" || echo "checksums do not match"
+mod_csum=$(_md5_checksum $testdir/file2)
+new_csum=$(_md5_checksum $testdir/file1)
+test ${csum} != ${mod_csum} || echo "checksums do not match"
+test ${csum} = ${new_csum} || echo "checksums do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/143 b/tests/generic/143
index c0bc672..586cf5c 100755
--- a/tests/generic/143
+++ b/tests/generic/143
@@ -25,8 +25,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,41 +50,42 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
 blksz=65536
 nr=9
-_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $((blksz * 256)) $testdir/file1 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-csum="$(_md5_checksum "$testdir/file1")"
+md5sum $testdir/file1 | _filter_test_dir
+csum=$(_md5_checksum $testdir/file1)
 
 echo "Create the reflink copies"
 seq 2 $nr | while read i; do
-	_cp_reflink "$testdir/file1" "$testdir/file$i"
+	_cp_reflink $testdir/file1 $testdir/file$i
 done
 _test_remount
 
 echo "Rewrite the copies"
 seq 2 $nr | while read i; do
-	_pwrite_byte 0x62 0 $((blksz * 256)) "$testdir/file$i" -d >> "$seqres.full"
+	_pwrite_byte 0x62 0 $((blksz * 256)) $testdir/file$i -d >> $seqres.full
 done
 _test_remount
 
 echo "Examine original file"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
-mod_csum="$(_md5_checksum "$testdir/file2")"
-new_csum="$(_md5_checksum "$testdir/file1")"
-test "${csum}" != "${mod_csum}" || echo "checksums do not match"
-test "${csum}" = "${new_csum}" || echo "checksums do not match"
+mod_csum=$(_md5_checksum $testdir/file2)
+new_csum=$(_md5_checksum $testdir/file1)
+test ${csum} != ${mod_csum} || echo "checksums do not match"
+test ${csum} = ${new_csum} || echo "checksums do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/144 b/tests/generic/144
index 631fa33..71020ab 100755
--- a/tests/generic/144
+++ b/tests/generic/144
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,92 +50,92 @@ _require_cp_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "truncate"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz * 5 + 37)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 5 + 37)) $testdir/file1 >> $seqres.full
 
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $blksz \
-		$((blksz * 4 + 37)) >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $blksz \
+		$((blksz * 4 + 37)) >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $((blksz * 5 + 37))" "$testdir/file3" >> "$seqres.full"
-_reflink_range "$testdir/file1" 0 "$testdir/file3" 0 $blksz >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * 5 + 37))" $testdir/file3 >> $seqres.full
+_reflink_range $testdir/file1 0 $testdir/file3 0 $blksz >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $((blksz * 5 + 37))" "$testdir/file4" >> "$seqres.full"
-_reflink_range "$testdir/file1" $blksz "$testdir/file4" $blksz $blksz >> "$seqres.full"
-_reflink_range "$testdir/file1" $((blksz * 3)) "$testdir/file4" $((blksz * 3)) \
-		$blksz >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * 5 + 37))" $testdir/file4 >> $seqres.full
+_reflink_range $testdir/file1 $blksz $testdir/file4 $blksz $blksz >> $seqres.full
+_reflink_range $testdir/file1 $((blksz * 3)) $testdir/file4 $((blksz * 3)) \
+		$blksz >> $seqres.full
 
-_cp_reflink "$testdir/file1" "$testdir/file5"
+_cp_reflink $testdir/file1 $testdir/file5
 _test_remount
 
 echo "Compare sections"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file5" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file5 | _filter_test_dir
 
-_compare_range "$testdir/file1" $blksz "$testdir/file2" $blksz \
+_compare_range $testdir/file1 $blksz $testdir/file2 $blksz \
 		$((blksz * 4 + 37)) \
 	|| echo "shared parts of files 1-2 changed"
 
-_compare_range "$testdir/file1" 0 "$testdir/file3" 0 $blksz \
+_compare_range $testdir/file1 0 $testdir/file3 0 $blksz \
 	|| echo "shared parts of files 1-3 changed"
 
-_compare_range "$testdir/file1" $blksz "$testdir/file4" $blksz $blksz \
+_compare_range $testdir/file1 $blksz $testdir/file4 $blksz $blksz \
 	|| echo "shared parts of files 1-4 changed"
 
-_compare_range "$testdir/file1" 0 "$testdir/file5" 0 $((blksz * 5 + 37)) \
+_compare_range $testdir/file1 0 $testdir/file5 0 $((blksz * 5 + 37)) \
 	|| echo "shared parts of files 1-5 changed"
 
 echo "Compare files"
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
-c4="$(_md5_checksum "$testdir/file4")"
-c5="$(_md5_checksum "$testdir/file5")"
-
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
-test "${c1}"  = "${c5}" || echo "file1 and file5 should match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
-test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
-test "${c2}" != "${c5}" || echo "file2 and file5 should not match"
-test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
-test "${c3}" != "${c5}" || echo "file3 and file5 should not match"
-test "${c4}" != "${c5}" || echo "file4 and file5 should not match"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
+c4=$(_md5_checksum $testdir/file4)
+c5=$(_md5_checksum $testdir/file5)
+
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c1} != ${c4} || echo "file1 and file4 should not match"
+test ${c1}  = ${c5} || echo "file1 and file5 should match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
+test ${c2} != ${c4} || echo "file2 and file4 should not match"
+test ${c2} != ${c5} || echo "file2 and file5 should not match"
+test ${c3} != ${c4} || echo "file3 and file4 should not match"
+test ${c3} != ${c5} || echo "file3 and file5 should not match"
+test ${c4} != ${c5} || echo "file4 and file5 should not match"
 
 echo "falloc everything"
-"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 5))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 5))" "$testdir/file3" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 5))" "$testdir/file4" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * 5))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * 5))" $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * 5))" $testdir/file4 >> $seqres.full
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file5" | _filter_test_dir
-
-d1="$(_md5_checksum "$testdir/file1")"
-d2="$(_md5_checksum "$testdir/file2")"
-d3="$(_md5_checksum "$testdir/file3")"
-d4="$(_md5_checksum "$testdir/file4")"
-d5="$(_md5_checksum "$testdir/file5")"
-
-test "${c1}" = "${d1}" || echo "file1 should not change"
-test "${c2}" = "${d2}" || echo "file2 should not change"
-test "${c3}" = "${d3}" || echo "file3 should not change"
-test "${c4}" = "${d4}" || echo "file4 should not change"
-test "${c5}" = "${d5}" || echo "file2 should not change"
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file5 | _filter_test_dir
+
+d1=$(_md5_checksum $testdir/file1)
+d2=$(_md5_checksum $testdir/file2)
+d3=$(_md5_checksum $testdir/file3)
+d4=$(_md5_checksum $testdir/file4)
+d5=$(_md5_checksum $testdir/file5)
+
+test ${c1} = ${d1} || echo "file1 should not change"
+test ${c2} = ${d2} || echo "file2 should not change"
+test ${c3} = ${d3} || echo "file3 should not change"
+test ${c4} = ${d4} || echo "file4 should not change"
+test ${c5} = ${d5} || echo "file2 should not change"
 
 # success, all done
 status=0
diff --git a/tests/generic/145 b/tests/generic/145
index 2b8d74f..dac2b27 100755
--- a/tests/generic/145
+++ b/tests/generic/145
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -51,91 +51,91 @@ _require_cp_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fcollapse"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file1" >> "$seqres.full"
-
-_cp_reflink "$testdir/file1" "$testdir/file2"
-_cp_reflink "$testdir/file1" "$testdir/file3"
-_cp_reflink "$testdir/file1" "$testdir/file4"
-
-"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 4))" "$testdir/file1"
-"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 4))" "$testdir/file2"
-"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 4))" "$testdir/file3"
-"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 4))" "$testdir/file4"
-
-_pwrite_byte 0x62 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $blksz $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $blksz "$testdir/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file1 >> $seqres.full
+
+_cp_reflink $testdir/file1 $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file3
+_cp_reflink $testdir/file1 $testdir/file4
+
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * 4))" $testdir/file1
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * 4))" $testdir/file2
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * 4))" $testdir/file3
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * 4))" $testdir/file4
+
+_pwrite_byte 0x62 0 $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x63 $blksz $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
+
+_pwrite_byte 0x61 0 $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x63 $blksz $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz * 2)) $blksz $testdir/file3.chk >> $seqres.full
+
+_pwrite_byte 0x61 0 $blksz $testdir/file4.chk >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file4.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz * 2)) $blksz $testdir/file4.chk >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
-md5sum "$testdir/file4.chk" | _filter_test_dir
-
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
-c4="$(_md5_checksum "$testdir/file4")"
-
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
-test "${c1}" = "${c3}" || echo "file1 and file3 should match"
-test "${c1}" = "${c4}" || echo "file1 and file4 should match"
-test "${c2}" = "${c3}" || echo "file2 and file3 should match"
-test "${c2}" = "${c4}" || echo "file2 and file4 should match"
-test "${c3}" = "${c4}" || echo "file3 and file4 should match"
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
+md5sum $testdir/file4.chk | _filter_test_dir
+
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
+c4=$(_md5_checksum $testdir/file4)
+
+test ${c1} = ${c2} || echo "file1 and file2 should match"
+test ${c1} = ${c3} || echo "file1 and file3 should match"
+test ${c1} = ${c4} || echo "file1 and file4 should match"
+test ${c2} = ${c3} || echo "file2 and file3 should match"
+test ${c2} = ${c4} || echo "file2 and file4 should match"
+test ${c3} = ${c4} || echo "file3 and file4 should match"
 
 echo "fcollapse files"
-"$XFS_IO_PROG" -f -c "fcollapse 0 $blksz" "$testdir/file2"
-"$XFS_IO_PROG" -f -c "fcollapse $blksz $blksz" "$testdir/file3"
-"$XFS_IO_PROG" -f -c "fcollapse $((blksz * 2)) $blksz" "$testdir/file4"
+$XFS_IO_PROG -f -c "fcollapse 0 $blksz" $testdir/file2
+$XFS_IO_PROG -f -c "fcollapse $blksz $blksz" $testdir/file3
+$XFS_IO_PROG -f -c "fcollapse $((blksz * 2)) $blksz" $testdir/file4
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
-md5sum "$testdir/file4.chk" | _filter_test_dir
-
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
-c4="$(_md5_checksum "$testdir/file4")"
-
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
-test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
-test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
+md5sum $testdir/file4.chk | _filter_test_dir
+
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
+c4=$(_md5_checksum $testdir/file4)
+
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c1} != ${c4} || echo "file1 and file4 should not match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
+test ${c2} != ${c4} || echo "file2 and file4 should not match"
+test ${c3} != ${c4} || echo "file3 and file4 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
-cmp -s "$testdir/file4" "$testdir/file4.chk" || echo "file4 and file4.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file3 $testdir/file3.chk || echo "file3 and file3.chk do not match"
+cmp -s $testdir/file4 $testdir/file4.chk || echo "file4 and file4.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/146 b/tests/generic/146
index 17dc306..98f0621 100755
--- a/tests/generic/146
+++ b/tests/generic/146
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,86 +50,86 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "fpunch"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file1 >> $seqres.full
 
-_cp_reflink "$testdir/file1" "$testdir/file2"
-_cp_reflink "$testdir/file1" "$testdir/file3"
-_cp_reflink "$testdir/file1" "$testdir/file4"
+_cp_reflink $testdir/file1 $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file3
+_cp_reflink $testdir/file1 $testdir/file4
 
-_pwrite_byte 0x00 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x00 0 $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 
-_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $blksz $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x00 $blksz $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file3.chk >> $seqres.full
 
-_pwrite_byte 0x61 0 $blksz "$testdir/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file4.chk >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file4.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz * 2)) $blksz $testdir/file4.chk >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
-md5sum "$testdir/file4.chk" | _filter_test_dir
-
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
-c4="$(_md5_checksum "$testdir/file4")"
-
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
-test "${c1}" = "${c3}" || echo "file1 and file3 should match"
-test "${c1}" = "${c4}" || echo "file1 and file4 should match"
-test "${c2}" = "${c3}" || echo "file2 and file3 should match"
-test "${c2}" = "${c4}" || echo "file2 and file4 should match"
-test "${c3}" = "${c4}" || echo "file3 and file4 should match"
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
+md5sum $testdir/file4.chk | _filter_test_dir
+
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
+c4=$(_md5_checksum $testdir/file4)
+
+test ${c1} = ${c2} || echo "file1 and file2 should match"
+test ${c1} = ${c3} || echo "file1 and file3 should match"
+test ${c1} = ${c4} || echo "file1 and file4 should match"
+test ${c2} = ${c3} || echo "file2 and file3 should match"
+test ${c2} = ${c4} || echo "file2 and file4 should match"
+test ${c3} = ${c4} || echo "file3 and file4 should match"
 
 echo "fpunch files"
-"$XFS_IO_PROG" -f -c "fpunch 0 $blksz" "$testdir/file2"
-"$XFS_IO_PROG" -f -c "fpunch $blksz $blksz" "$testdir/file3"
-"$XFS_IO_PROG" -f -c "fpunch $((blksz * 2)) $blksz" "$testdir/file4"
+$XFS_IO_PROG -f -c "fpunch 0 $blksz" $testdir/file2
+$XFS_IO_PROG -f -c "fpunch $blksz $blksz" $testdir/file3
+$XFS_IO_PROG -f -c "fpunch $((blksz * 2)) $blksz" $testdir/file4
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
-md5sum "$testdir/file4.chk" | _filter_test_dir
-
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
-c4="$(_md5_checksum "$testdir/file4")"
-
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
-test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
-test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
+md5sum $testdir/file4.chk | _filter_test_dir
+
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
+c4=$(_md5_checksum $testdir/file4)
+
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c1} != ${c4} || echo "file1 and file4 should not match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
+test ${c2} != ${c4} || echo "file2 and file4 should not match"
+test ${c3} != ${c4} || echo "file3 and file4 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
-cmp -s "$testdir/file4" "$testdir/file4.chk" || echo "file4 and file4.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file3 $testdir/file3.chk || echo "file3 and file3.chk do not match"
+cmp -s $testdir/file4 $testdir/file4.chk || echo "file4 and file4.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/147 b/tests/generic/147
index b160131..8706f83 100755
--- a/tests/generic/147
+++ b/tests/generic/147
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,89 +50,89 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "finsert"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file1" >> "$seqres.full"
-
-_cp_reflink "$testdir/file1" "$testdir/file2"
-_cp_reflink "$testdir/file1" "$testdir/file3"
-_cp_reflink "$testdir/file1" "$testdir/file4"
-
-_pwrite_byte 0x00 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $blksz $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $((blksz * 2)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 3)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $blksz "$testdir/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 3)) $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file1 >> $seqres.full
+
+_cp_reflink $testdir/file1 $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file3
+_cp_reflink $testdir/file1 $testdir/file4
+
+_pwrite_byte 0x00 0 $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x61 $blksz $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 3)) $blksz $testdir/file2.chk >> $seqres.full
+
+_pwrite_byte 0x61 0 $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x00 $blksz $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 2)) $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 3)) $blksz $testdir/file3.chk >> $seqres.full
+
+_pwrite_byte 0x61 0 $blksz $testdir/file4.chk >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file4.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz * 2)) $blksz $testdir/file4.chk >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 3)) $blksz $testdir/file4.chk >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
-md5sum "$testdir/file4.chk" | _filter_test_dir
-
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
-c4="$(_md5_checksum "$testdir/file4")"
-
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
-test "${c1}" = "${c3}" || echo "file1 and file3 should match"
-test "${c1}" = "${c4}" || echo "file1 and file4 should match"
-test "${c2}" = "${c3}" || echo "file2 and file3 should match"
-test "${c2}" = "${c4}" || echo "file2 and file4 should match"
-test "${c3}" = "${c4}" || echo "file3 and file4 should match"
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
+md5sum $testdir/file4.chk | _filter_test_dir
+
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
+c4=$(_md5_checksum $testdir/file4)
+
+test ${c1} = ${c2} || echo "file1 and file2 should match"
+test ${c1} = ${c3} || echo "file1 and file3 should match"
+test ${c1} = ${c4} || echo "file1 and file4 should match"
+test ${c2} = ${c3} || echo "file2 and file3 should match"
+test ${c2} = ${c4} || echo "file2 and file4 should match"
+test ${c3} = ${c4} || echo "file3 and file4 should match"
 
 echo "finsert files"
-"$XFS_IO_PROG" -f -c "finsert 0 $blksz" "$testdir/file2"
-"$XFS_IO_PROG" -f -c "finsert $blksz $blksz" "$testdir/file3"
-"$XFS_IO_PROG" -f -c "finsert $((blksz * 2)) $blksz" "$testdir/file4"
+$XFS_IO_PROG -f -c "finsert 0 $blksz" $testdir/file2
+$XFS_IO_PROG -f -c "finsert $blksz $blksz" $testdir/file3
+$XFS_IO_PROG -f -c "finsert $((blksz * 2)) $blksz" $testdir/file4
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
-md5sum "$testdir/file4.chk" | _filter_test_dir
-
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
-c4="$(_md5_checksum "$testdir/file4")"
-
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
-test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
-test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
+md5sum $testdir/file4.chk | _filter_test_dir
+
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
+c4=$(_md5_checksum $testdir/file4)
+
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c1} != ${c4} || echo "file1 and file4 should not match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
+test ${c2} != ${c4} || echo "file2 and file4 should not match"
+test ${c3} != ${c4} || echo "file3 and file4 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
-cmp -s "$testdir/file4" "$testdir/file4.chk" || echo "file4 and file4.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file3 $testdir/file3.chk || echo "file3 and file3.chk do not match"
+cmp -s $testdir/file4 $testdir/file4.chk || echo "file4 and file4.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/148 b/tests/generic/148
index cf5567b..af60ab8 100755
--- a/tests/generic/148
+++ b/tests/generic/148
@@ -25,8 +25,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -51,65 +51,65 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "truncate"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz 37 "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 $blksz 37 $testdir/file1 >> $seqres.full
 
-_cp_reflink "$testdir/file1" "$testdir/file2"
-_cp_reflink "$testdir/file1" "$testdir/file3"
+_cp_reflink $testdir/file1 $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file3
 
-_pwrite_byte 0x61 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz 34 "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x62 $blksz 34 $testdir/file2.chk >> $seqres.full
 
-_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz 37 "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz + 37)) 3 "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x62 $blksz 37 $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz + 37)) 3 $testdir/file3.chk >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
 
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
-test "${c1}" = "${c3}" || echo "file1 and file3 should match"
-test "${c2}" = "${c3}" || echo "file2 and file3 should match"
+test ${c1} = ${c2} || echo "file1 and file2 should match"
+test ${c1} = ${c3} || echo "file1 and file3 should match"
+test ${c2} = ${c3} || echo "file2 and file3 should match"
 
 echo "truncate files"
-"$XFS_IO_PROG" -f -c "truncate $((blksz + 34))" "$testdir/file2"
-"$XFS_IO_PROG" -f -c "truncate $((blksz + 40))" "$testdir/file3"
+$XFS_IO_PROG -f -c "truncate $((blksz + 34))" $testdir/file2
+$XFS_IO_PROG -f -c "truncate $((blksz + 40))" $testdir/file3
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
 
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file3 $testdir/file3.chk || echo "file3 and file3.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/149 b/tests/generic/149
index 7d3189e..b5f9f4a 100755
--- a/tests/generic/149
+++ b/tests/generic/149
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,86 +50,86 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "fzero"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file1 >> $seqres.full
 
-_cp_reflink "$testdir/file1" "$testdir/file2"
-_cp_reflink "$testdir/file1" "$testdir/file3"
-_cp_reflink "$testdir/file1" "$testdir/file4"
+_cp_reflink $testdir/file1 $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file3
+_cp_reflink $testdir/file1 $testdir/file4
 
-_pwrite_byte 0x00 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x00 0 $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 
-_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $blksz $blksz "$testdir/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x00 $blksz $blksz $testdir/file3.chk >> $seqres.full
+_pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file3.chk >> $seqres.full
 
-_pwrite_byte 0x61 0 $blksz "$testdir/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz $testdir/file4.chk >> $seqres.full
+_pwrite_byte 0x62 $blksz $blksz $testdir/file4.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz * 2)) $blksz $testdir/file4.chk >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
-md5sum "$testdir/file4.chk" | _filter_test_dir
-
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
-c4="$(_md5_checksum "$testdir/file4")"
-
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
-test "${c1}" = "${c3}" || echo "file1 and file3 should match"
-test "${c1}" = "${c4}" || echo "file1 and file4 should match"
-test "${c2}" = "${c3}" || echo "file2 and file3 should match"
-test "${c2}" = "${c4}" || echo "file2 and file4 should match"
-test "${c3}" = "${c4}" || echo "file3 and file4 should match"
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
+md5sum $testdir/file4.chk | _filter_test_dir
+
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
+c4=$(_md5_checksum $testdir/file4)
+
+test ${c1} = ${c2} || echo "file1 and file2 should match"
+test ${c1} = ${c3} || echo "file1 and file3 should match"
+test ${c1} = ${c4} || echo "file1 and file4 should match"
+test ${c2} = ${c3} || echo "file2 and file3 should match"
+test ${c2} = ${c4} || echo "file2 and file4 should match"
+test ${c3} = ${c4} || echo "file3 and file4 should match"
 
 echo "fzero files"
-"$XFS_IO_PROG" -f -c "fzero 0 $blksz" "$testdir/file2"
-"$XFS_IO_PROG" -f -c "fzero $blksz $blksz" "$testdir/file3"
-"$XFS_IO_PROG" -f -c "fzero $((blksz * 2)) $blksz" "$testdir/file4"
+$XFS_IO_PROG -f -c "fzero 0 $blksz" $testdir/file2
+$XFS_IO_PROG -f -c "fzero $blksz $blksz" $testdir/file3
+$XFS_IO_PROG -f -c "fzero $((blksz * 2)) $blksz" $testdir/file4
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file3" | _filter_test_dir
-md5sum "$testdir/file4" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
-md5sum "$testdir/file3.chk" | _filter_test_dir
-md5sum "$testdir/file4.chk" | _filter_test_dir
-
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
-c3="$(_md5_checksum "$testdir/file3")"
-c4="$(_md5_checksum "$testdir/file4")"
-
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
-test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
-test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
-test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
-test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
-test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file3 | _filter_test_dir
+md5sum $testdir/file4 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
+md5sum $testdir/file3.chk | _filter_test_dir
+md5sum $testdir/file4.chk | _filter_test_dir
+
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
+c3=$(_md5_checksum $testdir/file3)
+c4=$(_md5_checksum $testdir/file4)
+
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
+test ${c1} != ${c3} || echo "file1 and file3 should not match"
+test ${c1} != ${c4} || echo "file1 and file4 should not match"
+test ${c2} != ${c3} || echo "file2 and file3 should not match"
+test ${c2} != ${c4} || echo "file2 and file4 should not match"
+test ${c3} != ${c4} || echo "file3 and file4 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
-cmp -s "$testdir/file4" "$testdir/file4.chk" || echo "file4 and file4.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file3 $testdir/file3.chk || echo "file3 and file3.chk do not match"
+cmp -s $testdir/file4 $testdir/file4.chk || echo "file4 and file4.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/150 b/tests/generic/150
index 90ac46b..88814b1 100755
--- a/tests/generic/150
+++ b/tests/generic/150
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,11 +48,11 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
 blksz="$(stat -f $testdir -c '%S')"
@@ -60,16 +60,17 @@ blks=2000
 margin='15%'
 sz=$((blksz * blks))
 nr=7
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 sync
-free_blocks0=$(stat -f "$testdir" -c '%f')
+free_blocks0=$(stat -f $testdir -c '%f')
 
 echo "Create the reflink copies"
 for i in `seq 2 $nr`; do
-	_cp_reflink "$testdir/file1" "$testdir/file.$i"
+	_cp_reflink $testdir/file1 $testdir/file.$i
 done
 _test_remount
-free_blocks1=$(stat -f "$testdir" -c '%f')
+free_blocks1=$(stat -f $testdir -c '%f')
 
 _within_tolerance "free blocks after reflink" $free_blocks1 $free_blocks0 $margin -v
 
diff --git a/tests/generic/151 b/tests/generic/151
index c67a12c..207378c 100755
--- a/tests/generic/151
+++ b/tests/generic/151
@@ -27,8 +27,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -39,7 +39,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -52,39 +52,40 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
-free_blocks0=$(stat -f "$testdir" -c '%f')
+free_blocks0=$(stat -f $testdir -c '%f')
 nr=7
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 sync
 
 echo "Create the reflink copies"
 for i in `seq 2 $nr`; do
-	_cp_reflink "$testdir/file1" "$testdir/file.$i"
+	_cp_reflink $testdir/file1 $testdir/file.$i
 done
-_cp_reflink "$testdir/file1" "$testdir/survivor"
+_cp_reflink $testdir/file1 $testdir/survivor
 _test_remount
-free_blocks1=$(stat -f "$testdir" -c '%f')
+free_blocks1=$(stat -f $testdir -c '%f')
 
 echo "Delete most of the files"
-rm -rf "$testdir"/file*
+rm -rf $testdir/file*
 _test_remount
-free_blocks2=$(stat -f "$testdir" -c '%f')
+free_blocks2=$(stat -f $testdir -c '%f')
 
 echo "Delete all the files"
-rm -rf "$testdir"/*
+rm -rf $testdir/*
 _test_remount
-free_blocks3=$(stat -f "$testdir" -c '%f')
+free_blocks3=$(stat -f $testdir -c '%f')
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3
 
 _within_tolerance "free blocks after reflink" $free_blocks1 $((free_blocks0 - blks)) $margin -v
diff --git a/tests/generic/152 b/tests/generic/152
index cdb2bf9..b221f8f 100755
--- a/tests/generic/152
+++ b/tests/generic/152
@@ -27,8 +27,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -39,7 +39,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -53,43 +53,44 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "fpunch"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
-free_blocks0=$(stat -f "$testdir" -c '%f')
+free_blocks0=$(stat -f $testdir -c '%f')
 nr=4
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 sync
 
 echo "Create the reflink copies"
 for i in `seq 2 $nr`; do
-	_cp_reflink "$testdir/file1" "$testdir/file$i"
+	_cp_reflink $testdir/file1 $testdir/file$i
 done
 _test_remount
-free_blocks1=$(stat -f "$testdir" -c '%f')
+free_blocks1=$(stat -f $testdir -c '%f')
 
 echo "Punch most of the blocks"
-"$XFS_IO_PROG" -f -c "fpunch 0 $sz" "$testdir/file2"
-"$XFS_IO_PROG" -f -c "fpunch 0 $((sz / 2))" "$testdir/file3"
-"$XFS_IO_PROG" -f -c "fpunch $((sz / 2)) $((sz / 2))" "$testdir/file4"
+$XFS_IO_PROG -f -c "fpunch 0 $sz" $testdir/file2
+$XFS_IO_PROG -f -c "fpunch 0 $((sz / 2))" $testdir/file3
+$XFS_IO_PROG -f -c "fpunch $((sz / 2)) $((sz / 2))" $testdir/file4
 _test_remount
-free_blocks2=$(stat -f "$testdir" -c '%f')
+free_blocks2=$(stat -f $testdir -c '%f')
 
 echo "Punch all the files"
 for i in `seq 2 $nr`; do
-	"$XFS_IO_PROG" -f -c "fpunch 0 $sz" "$testdir/file$i"
+	$XFS_IO_PROG -f -c "fpunch 0 $sz" $testdir/file$i
 done
-"$XFS_IO_PROG" -f -c "fpunch 0 $sz" "$testdir/file1"
+$XFS_IO_PROG -f -c "fpunch 0 $sz" $testdir/file1
 _test_remount
-free_blocks3=$(stat -f "$testdir" -c '%f')
+free_blocks3=$(stat -f $testdir -c '%f')
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3
 
 _within_tolerance "free blocks after reflink" $free_blocks1 $((free_blocks0 - blks)) $margin -v
diff --git a/tests/generic/153 b/tests/generic/153
index b2f4022..550aa95 100755
--- a/tests/generic/153
+++ b/tests/generic/153
@@ -27,8 +27,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -39,7 +39,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -53,42 +53,43 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "fcollapse"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
-free_blocks0=$(stat -f "$testdir" -c '%f')
+free_blocks0=$(stat -f $testdir -c '%f')
 nr=4
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 _test_remount
 
 echo "Create the reflink copies"
 for i in `seq 2 $nr`; do
-	_cp_reflink "$testdir/file1" "$testdir/file$i"
+	_cp_reflink $testdir/file1 $testdir/file$i
 done
 _test_remount
-free_blocks1=$(stat -f "$testdir" -c '%f')
+free_blocks1=$(stat -f $testdir -c '%f')
 
 echo "Collapse most of the blocks"
-"$XFS_IO_PROG" -f -c "fcollapse 0 $(((blks - 1) * blksz))" $testdir/file2
-"$XFS_IO_PROG" -f -c "fcollapse 0 $((sz / 2))" $testdir/file3
-"$XFS_IO_PROG" -f -c "fcollapse $((sz / 2)) $(( ((blks / 2) - 1) * blksz))" $testdir/file4
+$XFS_IO_PROG -f -c "fcollapse 0 $(((blks - 1) * blksz))" $testdir/file2
+$XFS_IO_PROG -f -c "fcollapse 0 $((sz / 2))" $testdir/file3
+$XFS_IO_PROG -f -c "fcollapse $((sz / 2)) $(( ((blks / 2) - 1) * blksz))" $testdir/file4
 _test_remount
-free_blocks2=$(stat -f "$testdir" -c '%f')
+free_blocks2=$(stat -f $testdir -c '%f')
 
 echo "Collpase nearly all the files"
-"$XFS_IO_PROG" -f -c "fcollapse 0 $(( ((blks / 2) - 1) * blksz))" $testdir/file3
-"$XFS_IO_PROG" -f -c "fcollapse 0 $((sz / 2))" $testdir/file4
-"$XFS_IO_PROG" -f -c "fcollapse 0 $(( (blks - 1) * blksz))" $testdir/file1
+$XFS_IO_PROG -f -c "fcollapse 0 $(( ((blks / 2) - 1) * blksz))" $testdir/file3
+$XFS_IO_PROG -f -c "fcollapse 0 $((sz / 2))" $testdir/file4
+$XFS_IO_PROG -f -c "fcollapse 0 $(( (blks - 1) * blksz))" $testdir/file1
 _test_remount
-free_blocks3=$(stat -f "$testdir" -c '%f')
+free_blocks3=$(stat -f $testdir -c '%f')
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3
 
 _within_tolerance "free blocks after reflink" $free_blocks1 $((free_blocks0 - blks)) $margin -v
diff --git a/tests/generic/154 b/tests/generic/154
index 579f78b..c0c3142 100755
--- a/tests/generic/154
+++ b/tests/generic/154
@@ -28,7 +28,7 @@
 #-----------------------------------------------------------------------
 
 seq=`basename $0`
-seqres="$RESULT_DIR/$seq"
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -39,7 +39,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -52,47 +52,48 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 blks=2000
 margin='15%'
-free_blocks0=$(stat -f "$testdir" -c '%f')
+free_blocks0=$(stat -f $testdir -c '%f')
 nr=4
+filesize=$((blksz * nr))
 sz=$((blks * blksz))
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 _test_remount
 
 echo "Create the reflink copies"
 for i in `seq 2 $nr`; do
-	_cp_reflink "$testdir/file1" "$testdir/file$i"
+	_cp_reflink $testdir/file1 $testdir/file$i
 done
 _test_remount
-free_blocks1=$(stat -f "$testdir" -c '%f')
+free_blocks1=$(stat -f $testdir -c '%f')
 
 echo "Rewrite some of the blocks"
-_pwrite_byte 0x62 0 $sz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x63 0 $((sz / 2)) "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x64 $((sz / 2)) $((sz / 2)) "$testdir/file4" >> "$seqres.full"
+_pwrite_byte 0x62 0 $sz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x63 0 $((sz / 2)) $testdir/file3 >> $seqres.full
+_pwrite_byte 0x64 $((sz / 2)) $((sz / 2)) $testdir/file4 >> $seqres.full
 _test_remount
-free_blocks2=$(stat -f "$testdir" -c '%f')
+free_blocks2=$(stat -f $testdir -c '%f')
 
 echo "Rewrite all the files"
-_pwrite_byte 0x62 0 $sz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x63 0 $sz "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x64 0 $sz "$testdir/file4" >> "$seqres.full"
+_pwrite_byte 0x62 0 $sz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x63 0 $sz $testdir/file3 >> $seqres.full
+_pwrite_byte 0x64 0 $sz $testdir/file4 >> $seqres.full
 _test_remount
-free_blocks3=$(stat -f "$testdir" -c '%f')
+free_blocks3=$(stat -f $testdir -c '%f')
 
 echo "Rewrite the original file"
-_pwrite_byte 0x65 0 $sz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x65 0 $sz $testdir/file1 >> $seqres.full
 _test_remount
-free_blocks4=$(stat -f "$testdir" -c '%f')
+free_blocks4=$(stat -f $testdir -c '%f')
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
 _within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
diff --git a/tests/generic/155 b/tests/generic/155
index 56d2912..c6416a1 100755
--- a/tests/generic/155
+++ b/tests/generic/155
@@ -30,8 +30,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -42,7 +42,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -56,47 +56,48 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "fzero"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 testdir=$TEST_DIR/test-$seq
 rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
-free_blocks0=$(stat -f "$testdir" -c '%f')
+free_blocks0=$(stat -f $testdir -c '%f')
 nr=4
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 _test_remount
 
 echo "Create the reflink copies"
 for i in `seq 2 $nr`; do
-	_cp_reflink "$testdir/file1" "$testdir/file$i"
+	_cp_reflink $testdir/file1 $testdir/file$i
 done
 _test_remount
-free_blocks1=$(stat -f "$testdir" -c '%f')
+free_blocks1=$(stat -f $testdir -c '%f')
 
 echo "Rewrite some of the blocks"
-"$XFS_IO_PROG" -f -c "fzero 0 $sz" "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x63 0 $((sz / 2)) "$testdir/file3" -d >> "$seqres.full"
-_mwrite_byte 0x64 $((sz / 2)) $((sz / 2)) $sz "$testdir/file4" >> "$seqres.full"
+$XFS_IO_PROG -f -c "fzero 0 $sz" $testdir/file2 >> $seqres.full
+_pwrite_byte 0x63 0 $((sz / 2)) $testdir/file3 -d >> $seqres.full
+_mwrite_byte 0x64 $((sz / 2)) $((sz / 2)) $sz $testdir/file4 >> $seqres.full
 _test_remount
-free_blocks2=$(stat -f "$testdir" -c '%f')
+free_blocks2=$(stat -f $testdir -c '%f')
 
 echo "Rewrite all the files"
-_pwrite_byte 0x62 0 $sz "$testdir/file2" -d >> "$seqres.full"
-_mwrite_byte 0x63 0 $sz $sz "$testdir/file3" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "fzero 0 $sz" $testdir/file4 >> "$seqres.full"
+_pwrite_byte 0x62 0 $sz $testdir/file2 -d >> $seqres.full
+_mwrite_byte 0x63 0 $sz $sz $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "fzero 0 $sz" $testdir/file4 >> $seqres.full
 _test_remount
-free_blocks3=$(stat -f "$testdir" -c '%f')
+free_blocks3=$(stat -f $testdir -c '%f')
 
 echo "Rewrite the original file"
-_pwrite_byte 0x65 0 $sz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x65 0 $sz $testdir/file1 >> $seqres.full
 _test_remount
-free_blocks4=$(stat -f "$testdir" -c '%f')
+free_blocks4=$(stat -f $testdir -c '%f')
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
 _within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
diff --git a/tests/generic/156 b/tests/generic/156
index 9fea988..de2d9b1 100755
--- a/tests/generic/156
+++ b/tests/generic/156
@@ -33,8 +33,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -45,7 +45,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -64,49 +64,50 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
-free_blocks0=$(stat -f "$testdir" -c '%f')
+free_blocks0=$(stat -f $testdir -c '%f')
 nr=4
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 _test_remount
 
 echo "Create the reflink copies"
 for i in `seq 2 $nr`; do
-	_cp_reflink "$testdir/file1" "$testdir/file$i"
+	_cp_reflink $testdir/file1 $testdir/file$i
 done
 _test_remount
-free_blocks1=$(stat -f "$testdir" -c '%f')
+free_blocks1=$(stat -f $testdir -c '%f')
 
 echo "funshare part of a file"
-"$XFS_IO_PROG" -f -c "falloc 0 $((sz / 2))" "$testdir/file2"
+$XFS_IO_PROG -f -c "falloc 0 $((sz / 2))" $testdir/file2
 _test_remount
 
 echo "funshare some of the copies"
-"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file2"
-"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file3"
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file2
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file3
 _test_remount
-free_blocks2=$(stat -f "$testdir" -c '%f')
+free_blocks2=$(stat -f $testdir -c '%f')
 
 echo "funshare the rest of the files"
-"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file4"
-"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file1"
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file4
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1
 _test_remount
-free_blocks3=$(stat -f "$testdir" -c '%f')
+free_blocks3=$(stat -f $testdir -c '%f')
 
 echo "Rewrite the original file"
-_pwrite_byte 0x65 0 $sz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x65 0 $sz $testdir/file1 >> $seqres.full
 _test_remount
-free_blocks4=$(stat -f "$testdir" -c '%f')
+free_blocks4=$(stat -f $testdir -c '%f')
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
 _within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
diff --git a/tests/generic/157 b/tests/generic/157
index 19a9a18..fe294c8 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -20,8 +20,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf $tmp.* $testdir1
 }
 
 # get standard environment, filters and checks
@@ -46,19 +46,18 @@ _supported_os Linux
 _require_test_reflink
 _require_scratch_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
 testdir1="$TEST_DIR/test-$seq"
-rm -rf "$testdir1"
-mkdir "$testdir1"
+rm -rf $testdir1
+mkdir $testdir1
 
 testdir2=$SCRATCH_MNT/test-$seq
-rm -rf "$testdir2"
-mkdir "$testdir2"
+mkdir $testdir2
 
 echo "Create the original files"
 blksz="$(stat -f $testdir1 -c '%S')"
@@ -67,16 +66,17 @@ margin='7%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f $testdir1 -c '%f')
 nr=4
-_pwrite_byte 0x61 0 $sz "$testdir1/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir1/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir2/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir2/file2" >> "$seqres.full"
-mkdir "$testdir1/dir1"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir1/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir1/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir2/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir2/file2 >> $seqres.full
+mkdir $testdir1/dir1
 seq 1 $((2 * blksz / 250)) | while read f; do
-	touch "$testdir1/dir1/$f"
+	touch $testdir1/dir1/$f
 done
-mknod "$testdir1/dev1" c 1 3
-mkfifo "$testdir1/fifo1"
+mknod $testdir1/dev1 c 1 3
+mkfifo $testdir1/fifo1
 sync
 
 _filter_enotty() {
@@ -88,38 +88,38 @@ _filter_einval() {
 }
 
 echo "Try cross-device reflink"
-_reflink_range "$testdir1/file1" 0 "$testdir2/file1" 0 $blksz
+_reflink_range $testdir1/file1 0 $testdir2/file1 0 $blksz
 
 echo "Try unaligned reflink"
-_reflink_range "$testdir1/file1" 37 "$testdir1/file1" 59 23
+_reflink_range $testdir1/file1 37 $testdir1/file1 59 23
 
 echo "Try overlapping reflink"
-_reflink_range "$testdir1/file1" 0 "$testdir1/file1" 1 $((blksz * 2))
+_reflink_range $testdir1/file1 0 $testdir1/file1 1 $((blksz * 2))
 
 echo "Try reflink past EOF"
-_reflink_range "$testdir1/file1" $(( (blks + 10) * blksz)) "$testdir1/file1" 0 $blksz
+_reflink_range $testdir1/file1 $(( (blks + 10) * blksz)) $testdir1/file1 0 $blksz
 
 echo "Try to reflink a dir"
-_reflink_range "$testdir1/dir1" 0 "$testdir1/file2" 0 $blksz
+_reflink_range $testdir1/dir1 0 $testdir1/file2 0 $blksz
 
 echo "Try to reflink a device"
-_reflink_range "$testdir1/dev1" 0 "$testdir1/file2" 0 $blksz
+_reflink_range $testdir1/dev1 0 $testdir1/file2 0 $blksz
 
 echo "Try to reflink to a dir"
-_reflink_range "$testdir1/file1" 0 "$testdir1/dir1" 0 $blksz 2>&1 | _filter_test_dir
+_reflink_range $testdir1/file1 0 $testdir1/dir1 0 $blksz 2>&1 | _filter_test_dir
 
 echo "Try to reflink to a device"
-_reflink_range "$testdir1/file1" 0 "$testdir1/dev1" 0 $blksz 2>&1 | _filter_enotty
+_reflink_range $testdir1/file1 0 $testdir1/dev1 0 $blksz 2>&1 | _filter_enotty
 
 echo "Try to reflink to a fifo"
-_reflink_range "$testdir1/file1" 0 "$testdir1/fifo1" 0 $blksz -n 2>&1 | _filter_enotty
+_reflink_range $testdir1/file1 0 $testdir1/fifo1 0 $blksz -n 2>&1 | _filter_enotty
 
 echo "Try to reflink an append-only file"
-_reflink_range "$testdir1/file1" 0 "$testdir1/file3" 0 $blksz -a 2>&1 | _filter_einval
+_reflink_range $testdir1/file1 0 $testdir1/file3 0 $blksz -a 2>&1 | _filter_einval
 
 echo "Reflink two files"
-_reflink_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz >> "$seqres.full"
-_reflink_range "$testdir2/file1" 0 "$testdir2/file2" 0 $blksz >> "$seqres.full"
+_reflink_range $testdir1/file1 0 $testdir1/file2 0 $blksz >> $seqres.full
+_reflink_range $testdir2/file1 0 $testdir2/file2 0 $blksz >> $seqres.full
 
 # success, all done
 status=0
diff --git a/tests/generic/158 b/tests/generic/158
index 4b51973..0da5daa 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -20,8 +20,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf $tmp.* $testdir1
 }
 
 # get standard environment, filters and checks
@@ -46,19 +46,18 @@ _supported_os Linux
 _require_test_dedupe
 _require_scratch_dedupe
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
 testdir1="$TEST_DIR/test-$seq"
-rm -rf "$testdir1"
-mkdir "$testdir1"
+rm -rf $testdir1
+mkdir $testdir1
 
 testdir2=$SCRATCH_MNT/test-$seq
-rm -rf "$testdir2"
-mkdir "$testdir2"
+mkdir $testdir2
 
 echo "Create the original files"
 blksz="$(stat -f $testdir1 -c '%S')"
@@ -67,17 +66,18 @@ margin='7%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f $testdir1 -c '%f')
 nr=4
-_pwrite_byte 0x61 0 $sz "$testdir1/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir1/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir1/file3" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir2/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir2/file2" >> "$seqres.full"
-mkdir "$testdir1/dir1"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir1/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir1/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir1/file3 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir2/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir2/file2 >> $seqres.full
+mkdir $testdir1/dir1
 seq 1 $((2 * blksz / 250)) | while read f; do
-	touch "$testdir1/dir1/$f"
+	touch $testdir1/dir1/$f
 done
-mknod "$testdir1/dev1" c 1 3
-mkfifo "$testdir1/fifo1"
+mknod $testdir1/dev1 c 1 3
+mkfifo $testdir1/fifo1
 sync
 
 _filter_enotty() {
@@ -89,38 +89,38 @@ _filter_eperm() {
 }
 
 echo "Try cross-device dedupe"
-_dedupe_range "$testdir1/file1" 0 "$testdir2/file1" 0 $blksz
+_dedupe_range $testdir1/file1 0 $testdir2/file1 0 $blksz
 
 echo "Try unaligned dedupe"
-_dedupe_range "$testdir1/file1" 37 "$testdir1/file1" 59 23
+_dedupe_range $testdir1/file1 37 $testdir1/file1 59 23
 
 echo "Try overlapping dedupe"
-_dedupe_range "$testdir1/file1" 0 "$testdir1/file1" 1 $((blksz * 2))
+_dedupe_range $testdir1/file1 0 $testdir1/file1 1 $((blksz * 2))
 
 echo "Try dedupe past EOF"
-_dedupe_range "$testdir1/file1" $(( (blks + 10) * blksz)) "$testdir1/file1" 0 $blksz
+_dedupe_range $testdir1/file1 $(( (blks + 10) * blksz)) $testdir1/file1 0 $blksz
 
 echo "Try to dedupe a dir"
-_dedupe_range "$testdir1/dir1" 0 "$testdir1/file2" 0 $blksz
+_dedupe_range $testdir1/dir1 0 $testdir1/file2 0 $blksz
 
 echo "Try to dedupe a device"
-_dedupe_range "$testdir1/dev1" 0 "$testdir1/file2" 0 $blksz 2>&1 | _filter_enotty
+_dedupe_range $testdir1/dev1 0 $testdir1/file2 0 $blksz 2>&1 | _filter_enotty
 
 echo "Try to dedupe to a dir"
-_dedupe_range "$testdir1/file1" 0 "$testdir1/dir1" 0 $blksz 2>&1 | _filter_test_dir
+_dedupe_range $testdir1/file1 0 $testdir1/dir1 0 $blksz 2>&1 | _filter_test_dir
 
 echo "Try to dedupe to a device"
-_dedupe_range "$testdir1/file1" 0 "$testdir1/dev1" 0 $blksz 2>&1 | _filter_eperm
+_dedupe_range $testdir1/file1 0 $testdir1/dev1 0 $blksz 2>&1 | _filter_eperm
 
 echo "Try to dedupe to a fifo"
-_dedupe_range "$testdir1/file1" 0 "$testdir1/fifo1" 0 $blksz -n 2>&1 | _filter_eperm
+_dedupe_range $testdir1/file1 0 $testdir1/fifo1 0 $blksz -n 2>&1 | _filter_eperm
 
 echo "Try to dedupe an append-only file"
-_dedupe_range "$testdir1/file1" 0 "$testdir1/file3" 0 $blksz -a >> "$seqres.full"
+_dedupe_range $testdir1/file1 0 $testdir1/file3 0 $blksz -a >> $seqres.full
 
 echo "Dedupe two files"
-_dedupe_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz >> "$seqres.full"
-_dedupe_range "$testdir2/file1" 0 "$testdir2/file2" 0 $blksz >> "$seqres.full"
+_dedupe_range $testdir1/file1 0 $testdir1/file2 0 $blksz >> $seqres.full
+_dedupe_range $testdir2/file1 0 $testdir2/file2 0 $blksz >> $seqres.full
 
 # success, all done
 status=0
diff --git a/tests/generic/159 b/tests/generic/159
index 88a0c7e..8898d58 100755
--- a/tests/generic/159
+++ b/tests/generic/159
@@ -20,8 +20,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf $tmp.* $testdir1
 }
 
 # get standard environment, filters and checks
@@ -46,12 +46,12 @@ _supported_os Linux
 _require_test_lsattr
 _require_test_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
 testdir1="$TEST_DIR/test-$seq"
-rm -rf "$testdir1"
-mkdir "$testdir1"
+rm -rf $testdir1
+mkdir $testdir1
 
 echo "Create the original files"
 blksz="$(stat -f $testdir1 -c '%S')"
@@ -60,13 +60,14 @@ margin='7%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f $testdir1 -c '%f')
 nr=4
-_pwrite_byte 0x61 0 $sz "$testdir1/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir1/file2" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir1/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir1/file2 >> $seqres.full
 sync
 
 echo "Try reflink on immutable files"
 $CHATTR_PROG +i $testdir1/file1 $testdir1/file2
-_reflink_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz 2>&1 | _filter_test_dir
+_reflink_range $testdir1/file1 0 $testdir1/file2 0 $blksz 2>&1 | _filter_test_dir
 $CHATTR_PROG -i $testdir1/file1 $testdir1/file2
 
 # success, all done
diff --git a/tests/generic/160 b/tests/generic/160
index 83325d5..3a91dc8 100755
--- a/tests/generic/160
+++ b/tests/generic/160
@@ -20,8 +20,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf $tmp.* $testdir1
 }
 
 # get standard environment, filters and checks
@@ -46,12 +46,12 @@ _supported_os Linux
 _require_test_lsattr
 _require_test_dedupe
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
 testdir1="$TEST_DIR/test-$seq"
-rm -rf "$testdir1"
-mkdir "$testdir1"
+rm -rf $testdir1
+mkdir $testdir1
 
 echo "Create the original files"
 blksz="$(stat -f $testdir1 -c '%S')"
@@ -60,13 +60,14 @@ margin='7%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f $testdir1 -c '%f')
 nr=4
-_pwrite_byte 0x61 0 $sz "$testdir1/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir1/file2" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir1/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir1/file2 >> $seqres.full
 sync
 
 echo "Try dedupe on immutable files"
 $CHATTR_PROG +i $testdir1/file1 $testdir1/file2
-_dedupe_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz 2>&1 | _filter_test_dir
+_dedupe_range $testdir1/file1 0 $testdir1/file2 0 $blksz 2>&1 | _filter_test_dir
 $CHATTR_PROG -i $testdir1/file1 $testdir1/file2
 
 # success, all done
diff --git a/tests/generic/161 b/tests/generic/161
index 1d5364e..7776b83 100755
--- a/tests/generic/161
+++ b/tests/generic/161
@@ -21,8 +21,8 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".*
+    rm -rf $tmp.*
     wait
 }
 
@@ -48,25 +48,24 @@ _require_scratch_reflink
 _require_cp_reflink
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 loops=4096
 blksz=65536
 
 echo "Initialize files"
-echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2
 _scratch_remount
 
 echo "Delete while rewriting"
-rm -rf "$testdir/file1" &
-_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+rm -rf $testdir/file1 &
+_pwrite_byte 0x62 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
 wait
 
 # success, all done
diff --git a/tests/generic/162 b/tests/generic/162
index 9044545..6d5bb7a 100755
--- a/tests/generic/162
+++ b/tests/generic/162
@@ -21,8 +21,8 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".*
+    rm -rf $tmp.*
     wait
 }
 
@@ -47,27 +47,26 @@ _supported_os Linux
 _require_scratch_dedupe
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 loops=512
 nr_loops=$((loops - 1))
 blksz=65536
 
 echo "Initialize files"
-echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file2 >> $seqres.full
 _scratch_remount
 
 overwrite() {
-	while [ ! -e "$testdir/finished" ]; do
+	while [ ! -e $testdir/finished ]; do
 		seq $nr_loops -1 0 | while read i; do
-			_pwrite_byte 0x61 $((i * blksz)) $blksz "$testdir/file2" >> "$seqres.full"
+			_pwrite_byte 0x61 $((i * blksz)) $blksz $testdir/file2 >> $seqres.full
 		done
 	done
 }
@@ -76,13 +75,13 @@ echo "Dedupe and rewrite the file!"
 overwrite &
 for i in `seq 1 2`; do
 	seq $nr_loops -1 0 | while read i; do
-		_dedupe_range   "$testdir/file1" $((i * blksz)) \
-				"$testdir/file2" $((i * blksz)) $blksz >> "$seqres.full"
+		_dedupe_range   $testdir/file1 $((i * blksz)) \
+				$testdir/file2 $((i * blksz)) $blksz >> $seqres.full
 		[ $? -ne 0 ] && break
 	done
 done
 echo "Finished dedupeing"
-touch "$testdir/finished"
+touch $testdir/finished
 wait
 
 # success, all done
diff --git a/tests/generic/163 b/tests/generic/163
index 651d445..b9b0cd7 100755
--- a/tests/generic/163
+++ b/tests/generic/163
@@ -21,8 +21,8 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".*
+    rm -rf $tmp.*
     wait
 }
 
@@ -47,27 +47,26 @@ _supported_os Linux
 _require_scratch_dedupe
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 loops=512
 nr_loops=$((loops - 1))
 blksz=65536
 
 echo "Initialize files"
-echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file2 >> $seqres.full
 _scratch_remount
 
 overwrite() {
-	while [ ! -e "$testdir/finished" ]; do
+	while [ ! -e $testdir/finished ]; do
 		seq $nr_loops -1 0 | while read i; do
-			_pwrite_byte 0x61 $((i * blksz)) $blksz "$testdir/file1" >> "$seqres.full"
+			_pwrite_byte 0x61 $((i * blksz)) $blksz $testdir/file1 >> $seqres.full
 		done
 	done
 }
@@ -76,13 +75,13 @@ echo "Dedupe and rewrite the file!"
 overwrite &
 for i in `seq 1 2`; do
 	seq $nr_loops -1 0 | while read i; do
-		_dedupe_range   "$testdir/file1" $((i * blksz)) \
-				"$testdir/file2" $((i * blksz)) $blksz >> "$seqres.full"
+		_dedupe_range   $testdir/file1 $((i * blksz)) \
+				$testdir/file2 $((i * blksz)) $blksz >> $seqres.full
 		[ $? -ne 0 ] && break
 	done
 done
 echo "Finished dedupeing"
-touch "$testdir/finished"
+touch $testdir/finished
 wait
 
 # success, all done
diff --git a/tests/generic/164 b/tests/generic/164
index 6c19c7d..6c12724 100755
--- a/tests/generic/164
+++ b/tests/generic/164
@@ -22,7 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
+seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".*
+    rm -rf $tmp.*
     wait
 }
 
@@ -49,22 +49,21 @@ _require_scratch_reflink
 _require_cp_reflink
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 loops=512
 nr_loops=$((loops - 1))
 blksz=65536
 
 echo "Initialize files"
-echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file3"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $((loops * blksz)) $testdir/file2 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file3
 _scratch_remount
 
 fbytes() {
@@ -72,8 +71,8 @@ fbytes() {
 }
 
 reader() {
-	while [ ! -e "$testdir/finished" ]; do
-		_read_range "$testdir/file3" 0 $((loops * blksz)) | fbytes
+	while [ ! -e $testdir/finished ]; do
+		_read_range $testdir/file3 0 $((loops * blksz)) | fbytes
 	done
 }
 
@@ -81,18 +80,18 @@ echo "Reflink and reread the files!"
 reader &
 for i in `seq 1 2`; do
 	seq $nr_loops -1 0 | while read i; do
-		_reflink_range  "$testdir/file1" $((i * blksz)) \
-				"$testdir/file3" $((i * blksz)) $blksz >> "$seqres.full"
+		_reflink_range  $testdir/file1 $((i * blksz)) \
+				$testdir/file3 $((i * blksz)) $blksz >> $seqres.full
 		[ $? -ne 0 ] && break
 	done
 	seq $nr_loops -1 0 | while read i; do
-		_reflink_range  "$testdir/file2" $((i * blksz)) \
-				"$testdir/file3" $((i * blksz)) $blksz >> "$seqres.full"
+		_reflink_range  $testdir/file2 $((i * blksz)) \
+				$testdir/file3 $((i * blksz)) $blksz >> $seqres.full
 		[ $? -ne 0 ] && break
 	done
 done
 echo "Finished reflinking"
-touch "$testdir/finished"
+touch $testdir/finished
 wait
 
 # success, all done
diff --git a/tests/generic/165 b/tests/generic/165
index 2e380a9..e4c9a9d 100755
--- a/tests/generic/165
+++ b/tests/generic/165
@@ -22,7 +22,7 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
+seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".*
+    rm -rf $tmp.*
     wait
 }
 
@@ -49,21 +49,20 @@ _require_scratch_reflink
 _require_cp_reflink
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 loops=512
 nr_loops=$((loops - 1))
 blksz=65536
 
 echo "Initialize files"
-echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $((loops * blksz)) $testdir/file2 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file3
 _scratch_remount
 
@@ -72,8 +71,8 @@ fbytes() {
 }
 
 reader() {
-	while [ ! -e "$testdir/finished" ]; do
-		_read_range "$testdir/file3" 0 $((loops * blksz)) -d | fbytes
+	while [ ! -e $testdir/finished ]; do
+		_read_range $testdir/file3 0 $((loops * blksz)) -d | fbytes
 	done
 }
 
@@ -81,18 +80,18 @@ echo "Reflink and dio reread the files!"
 reader &
 for i in `seq 1 2`; do
 	seq $nr_loops -1 0 | while read i; do
-		_reflink_range  "$testdir/file1" $((i * blksz)) \
-				"$testdir/file3" $((i * blksz)) $blksz >> "$seqres.full"
+		_reflink_range  $testdir/file1 $((i * blksz)) \
+				$testdir/file3 $((i * blksz)) $blksz >> $seqres.full
 		[ $? -ne 0 ] && break
 	done
 	seq $nr_loops -1 0 | while read i; do
-		_reflink_range  "$testdir/file2" $((i * blksz)) \
-				"$testdir/file3" $((i * blksz)) $blksz >> "$seqres.full"
+		_reflink_range  $testdir/file2 $((i * blksz)) \
+				$testdir/file3 $((i * blksz)) $blksz >> $seqres.full
 		[ $? -ne 0 ] && break
 	done
 done
 echo "Finished reflinking"
-touch "$testdir/finished"
+touch $testdir/finished
 wait
 
 # success, all done
diff --git a/tests/generic/166 b/tests/generic/166
index 028ee11..9be753d 100755
--- a/tests/generic/166
+++ b/tests/generic/166
@@ -22,8 +22,8 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".*
+    rm -rf $tmp.*
     wait
 }
 
@@ -49,27 +49,26 @@ _require_scratch_reflink
 _require_cp_reflink
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 loops=1024
 nr_loops=$((loops - 1))
 blksz=65536
 
 echo "Initialize file"
-echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
 _scratch_remount
 
 # Snapshot creator...
 snappy() {
 	n=0
-	while [ ! -e "$testdir/finished" ]; do
-		_cp_reflink "$testdir/file1" "$testdir/snap_$n" || break
+	while [ ! -e $testdir/finished ]; do
+		_cp_reflink $testdir/file1 $testdir/snap_$n || break
 		n=$((n + 1))
 	done
 }
@@ -77,7 +76,7 @@ snappy() {
 echo "Snapshot a file undergoing directio rewrite"
 snappy &
 seq $nr_loops -1 0 | while read i; do
-	_pwrite_byte 0x63 $((i * blksz)) $blksz -d "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x63 $((i * blksz)) $blksz -d $testdir/file1 >> $seqres.full
 done
 touch $testdir/finished
 wait
diff --git a/tests/generic/167 b/tests/generic/167
index a4bf4f4..ef8e75b 100755
--- a/tests/generic/167
+++ b/tests/generic/167
@@ -22,8 +22,8 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".*
+    rm -rf $tmp.*
     wait
 }
 
@@ -49,27 +49,26 @@ _require_scratch_reflink
 _require_cp_reflink
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 loops=1024
 nr_loops=$((loops - 1))
 blksz=65536
 
 echo "Initialize file"
-echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
 _scratch_remount
 
 # Snapshot creator...
 snappy() {
 	n=0
-	while [ ! -e "$testdir/finished" ]; do
-		_cp_reflink "$testdir/file1" "$testdir/snap_$n" || break
+	while [ ! -e $testdir/finished ]; do
+		_cp_reflink $testdir/file1 $testdir/snap_$n || break
 		n=$((n + 1))
 	done
 }
@@ -77,7 +76,7 @@ snappy() {
 echo "Snapshot a file undergoing buffered rewrite"
 snappy &
 seq $nr_loops -1 0 | while read i; do
-	_pwrite_byte 0x63 $((i * blksz)) $blksz "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x63 $((i * blksz)) $blksz $testdir/file1 >> $seqres.full
 done
 touch $testdir/finished
 wait
diff --git a/tests/generic/168 b/tests/generic/168
index 2ffc5b6..bb4a5a1 100755
--- a/tests/generic/168
+++ b/tests/generic/168
@@ -22,8 +22,8 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".*
+    rm -rf $tmp.*
     wait
 }
 
@@ -48,28 +48,27 @@ _supported_os Linux
 _require_scratch_reflink
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 loops=1024
 nr_loops=$((loops - 1))
 blksz=65536
 
 echo "Initialize files"
-echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $((loops * blksz)) $testdir/file2 >> $seqres.full
 _scratch_remount
 
 # Direct I/O overwriter...
 overwrite() {
-	while [ ! -e "$testdir/finished" ]; do
+	while [ ! -e $testdir/finished ]; do
 		seq $nr_loops -1 0 | while read i; do
-			_pwrite_byte 0x63 $((i * blksz)) $blksz "$testdir/file2" >> "$seqres.full"
+			_pwrite_byte 0x63 $((i * blksz)) $blksz $testdir/file2 >> $seqres.full
 		done
 	done
 }
@@ -78,12 +77,12 @@ echo "Reflink and write the target"
 overwrite &
 seq 1 10 | while read j; do
 	seq 0 $nr_loops | while read i; do
-		_reflink_range  "$testdir/file1" $((i * blksz)) \
-				"$testdir/file2" $((i * blksz)) $blksz >> "$seqres.full"
+		_reflink_range  $testdir/file1 $((i * blksz)) \
+				$testdir/file2 $((i * blksz)) $blksz >> $seqres.full
 		[ $? -ne 0 ] && exit
 	done
 done
-touch "$testdir/finished"
+touch $testdir/finished
 wait
 
 # success, all done
diff --git a/tests/generic/170 b/tests/generic/170
index 2a81cad..dbf1564 100755
--- a/tests/generic/170
+++ b/tests/generic/170
@@ -22,8 +22,8 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".*
+    rm -rf $tmp.*
     wait
 }
 
@@ -48,28 +48,27 @@ _supported_os Linux
 _require_scratch_reflink
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 loops=1024
 nr_loops=$((loops - 1))
 blksz=65536
 
 echo "Initialize files"
-echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $((loops * blksz)) $testdir/file2 >> $seqres.full
 _scratch_remount
 
 # Direct I/O overwriter...
 overwrite() {
-	while [ ! -e "$testdir/finished" ]; do
+	while [ ! -e $testdir/finished ]; do
 		seq $nr_loops -1 0 | while read i; do
-			_pwrite_byte 0x63 $((i * blksz)) $blksz -d "$testdir/file2" >> "$seqres.full"
+			_pwrite_byte 0x63 $((i * blksz)) $blksz -d $testdir/file2 >> $seqres.full
 		done
 	done
 }
@@ -78,12 +77,12 @@ echo "Reflink and dio write the target"
 overwrite &
 seq 1 10 | while read j; do
 	seq 0 $nr_loops | while read i; do
-		_reflink_range  "$testdir/file1" $((i * blksz)) \
-				"$testdir/file2" $((i * blksz)) $blksz >> "$seqres.full"
+		_reflink_range  $testdir/file1 $((i * blksz)) \
+				$testdir/file2 $((i * blksz)) $blksz >> $seqres.full
 		[ $? -ne 0 ] && exit
 	done
 done
-touch "$testdir/finished"
+touch $testdir/finished
 wait
 
 # success, all done
diff --git a/tests/generic/171 b/tests/generic/171
index d865f64..8a3f246 100755
--- a/tests/generic/171
+++ b/tests/generic/171
@@ -21,8 +21,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf $tmp.* $testdir1
 }
 
 # get standard environment, filters and checks
@@ -47,53 +47,52 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 nr_blks=10240
-umount "$SCRATCH_MNT"
+umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
 if [ $sz_bytes -lt $((32 * 1048576)) ]; then
 	sz_bytes=$((32 * 1048576))
 fi
-_scratch_mkfs_sized $sz_bytes >> "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
-rm -rf "$testdir"
-mkdir "$testdir"
+_scratch_mkfs_sized $sz_bytes >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create a big file and reflink it"
-_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/bigfile" >> "$seqres.full" 2>&1
-_cp_reflink "$testdir/bigfile" "$testdir/clonefile"
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/bigfile >> $seqres.full 2>&1
+_cp_reflink $testdir/bigfile $testdir/clonefile
 sync
 
 echo "Allocate the rest of the space"
-nr_free="$(stat -f -c '%f' "$testdir")"
-touch "$testdir/file0" "$testdir/file1"
-_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/eat_my_space" >> "$seqres.full" 2>&1
+nr_free=$(stat -f -c '%f' $testdir)
+touch $testdir/file0 $testdir/file1
+_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
 sync
 
 echo "CoW the big file"
-out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
-echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
-echo "${out}" >> "$seqres.full" 2>&1
-echo "${out}"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) $testdir/bigfile 2>&1)"
+echo ${out} | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo ${out} >> $seqres.full 2>&1
+echo ${out}
 
 echo "Remount and try CoW again"
 _scratch_remount
 
-out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
-echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
-echo "${out}" >> "$seqres.full" 2>&1
-echo "${out}"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) $testdir/bigfile 2>&1)"
+echo ${out} | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo ${out} >> $seqres.full 2>&1
+echo ${out}
 
 # success, all done
 status=0
diff --git a/tests/generic/172 b/tests/generic/172
index e6020f1..3e32644 100755
--- a/tests/generic/172
+++ b/tests/generic/172
@@ -21,8 +21,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf $tmp.* $testdir1
 }
 
 # get standard environment, filters and checks
@@ -47,53 +47,52 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 nr_blks=10240
-umount "$SCRATCH_MNT"
+umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 3 / 2 * blksz))
 if [ $sz_bytes -lt $((32 * 1048576)) ]; then
 	sz_bytes=$((32 * 1048576))
 fi
-_scratch_mkfs_sized $sz_bytes >> "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
-rm -rf "$testdir"
-mkdir "$testdir"
+_scratch_mkfs_sized $sz_bytes >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create a big file and reflink it"
-_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/bigfile" >> "$seqres.full" 2>&1
-_cp_reflink "$testdir/bigfile" "$testdir/clonefile"
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/bigfile >> $seqres.full 2>&1
+_cp_reflink $testdir/bigfile $testdir/clonefile
 sync
 
 echo "Allocate the rest of the space"
-nr_free="$(stat -f -c '%f' "$testdir")"
-touch "$testdir/file0" "$testdir/file1"
-_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/eat_my_space" >> "$seqres.full" 2>&1
+nr_free=$(stat -f -c '%f' $testdir)
+touch $testdir/file0 $testdir/file1
+_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
 sync
 
 echo "CoW the big file"
-out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
-echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
-echo "${out}" >> "$seqres.full" 2>&1
-echo "${out}"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) $testdir/bigfile 2>&1)"
+echo ${out} | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo ${out} >> $seqres.full 2>&1
+echo ${out}
 
 echo "Remount and try CoW again"
 _scratch_remount
 
-out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
-echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
-echo "${out}" >> "$seqres.full" 2>&1
-echo "${out}"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) $testdir/bigfile 2>&1)"
+echo ${out} | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo ${out} >> $seqres.full 2>&1
+echo ${out}
 
 # success, all done
 status=0
diff --git a/tests/generic/173 b/tests/generic/173
index 61c6b32..fe085a6 100755
--- a/tests/generic/173
+++ b/tests/generic/173
@@ -21,8 +21,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf $tmp.* $testdir1
 }
 
 # get standard environment, filters and checks
@@ -47,53 +47,52 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 nr_blks=10240
-umount "$SCRATCH_MNT"
+umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
 if [ $sz_bytes -lt $((32 * 1048576)) ]; then
 	sz_bytes=$((32 * 1048576))
 fi
-_scratch_mkfs_sized $sz_bytes >> "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
-rm -rf "$testdir"
-mkdir "$testdir"
+_scratch_mkfs_sized $sz_bytes >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create a big file and reflink it"
-_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/bigfile" >> "$seqres.full" 2>&1
-_cp_reflink "$testdir/bigfile" "$testdir/clonefile"
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/bigfile >> $seqres.full 2>&1
+_cp_reflink $testdir/bigfile $testdir/clonefile
 sync
 
 echo "Allocate the rest of the space"
-nr_free="$(stat -f -c '%f' "$testdir")"
-touch "$testdir/file0" "$testdir/file1"
-_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/eat_my_space" >> "$seqres.full" 2>&1
+nr_free=$(stat -f -c '%f' $testdir)
+touch $testdir/file0 $testdir/file1
+_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
 sync
 
 echo "mmap CoW the big file"
-out="$(_mwrite_byte 0x62 0 $((blksz * nr_blks)) $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
+out="$(_mwrite_byte 0x62 0 $((blksz * nr_blks)) $((blksz * nr_blks)) $testdir/bigfile 2>&1)"
 err="$?"
-if [ "$err" -lt 128 ]; then
+if [ $err -lt 128 ]; then
 	echo "mmap CoW should have failed with SIGBUS, got SIG$(kill -l $err)"
 fi
 
 echo "Remount and try CoW again"
 _scratch_remount
 
-out="$(_mwrite_byte 0x62 0 $((blksz * nr_blks)) $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
+out="$(_mwrite_byte 0x62 0 $((blksz * nr_blks)) $((blksz * nr_blks)) $testdir/bigfile 2>&1)"
 err="$?"
-if [ "$err" -lt 128 ]; then
+if [ $err -lt 128 ]; then
 	echo "mmap CoW should have failed with SIGBUS, got SIG$(kill -l $err)"
 fi
 
diff --git a/tests/generic/174 b/tests/generic/174
index dd6fe5a..cec2f05 100755
--- a/tests/generic/174
+++ b/tests/generic/174
@@ -21,8 +21,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf $tmp.* $testdir1
 }
 
 # get standard environment, filters and checks
@@ -47,53 +47,52 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 nr_blks=10240
-umount "$SCRATCH_MNT"
+umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
 if [ $sz_bytes -lt $((32 * 1048576)) ]; then
 	sz_bytes=$((32 * 1048576))
 fi
-_scratch_mkfs_sized $sz_bytes >> "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
-rm -rf "$testdir"
-mkdir "$testdir"
+_scratch_mkfs_sized $sz_bytes >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create a big file and reflink it"
-_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/bigfile" >> "$seqres.full" 2>&1
-_cp_reflink "$testdir/bigfile" "$testdir/clonefile"
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/bigfile >> $seqres.full 2>&1
+_cp_reflink $testdir/bigfile $testdir/clonefile
 sync
 
 echo "Allocate the rest of the space"
-nr_free="$(stat -f -c '%f' "$testdir")"
-touch "$testdir/file0" "$testdir/file1"
-_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/eat_my_space" >> "$seqres.full" 2>&1
+nr_free=$(stat -f -c '%f' $testdir)
+touch $testdir/file0 $testdir/file1
+_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
 sync
 
 echo "CoW the big file"
-out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" -d 2>&1)"
-echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
-echo "${out}" >> "$seqres.full" 2>&1
-echo "${out}"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) $testdir/bigfile -d 2>&1)"
+echo ${out} | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo ${out} >> $seqres.full 2>&1
+echo ${out}
 
 echo "Remount and try CoW again"
 _scratch_remount
 
-out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" -d 2>&1)"
-echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
-echo "${out}" >> "$seqres.full" 2>&1
-echo "${out}"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) $testdir/bigfile -d 2>&1)"
+echo ${out} | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo ${out} >> $seqres.full 2>&1
+echo ${out}
 
 # success, all done
 status=0
diff --git a/tests/generic/178 b/tests/generic/178
index f1bc963..68432e7 100755
--- a/tests/generic/178
+++ b/tests/generic/178
@@ -20,8 +20,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -46,31 +46,32 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "fpunch"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=512
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
 
-_cp_reflink "$testdir/file1" "$testdir/file2"
+_cp_reflink $testdir/file1 $testdir/file2
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
 echo "Write and punch"
-_pwrite_byte 0x62 0 $((blksz * 256)) "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "fpunch $blksz $((blksz * 254))" "$testdir/file2"
+_pwrite_byte 0x62 0 $((blksz * 256)) $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "fpunch $blksz $((blksz * 254))" $testdir/file2
 _test_remount
 
 echo "Compare results"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
 
 # success, all done
 status=0
diff --git a/tests/generic/179 b/tests/generic/179
index 8e1e059..27c25e7 100755
--- a/tests/generic/179
+++ b/tests/generic/179
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,47 +49,47 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "fpunch"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz * 3)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 3)) $testdir/file1 >> $seqres.full
 
-_cp_reflink "$testdir/file1" "$testdir/file2"
+_cp_reflink $testdir/file1 $testdir/file2
 
-_pwrite_byte 0x61 0 $((blksz * 3)) "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz - 17)) $((blksz + 17)) "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 3)) $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz - 17)) $((blksz + 17)) $testdir/file2.chk >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
 
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test ${c1} = ${c2} || echo "file1 and file2 should match"
 
 echo "fpunch files"
-"$XFS_IO_PROG" -f -c "fpunch $((blksz - 17)) $((blksz + 17))" "$testdir/file2"
+$XFS_IO_PROG -f -c "fpunch $((blksz - 17)) $((blksz + 17))" $testdir/file2
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
 
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/180 b/tests/generic/180
index dc6cbbb..a0f30a2 100755
--- a/tests/generic/180
+++ b/tests/generic/180
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,47 +49,47 @@ _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "fzero"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz * 3)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 3)) $testdir/file1 >> $seqres.full
 
-_cp_reflink "$testdir/file1" "$testdir/file2"
+_cp_reflink $testdir/file1 $testdir/file2
 
-_pwrite_byte 0x61 0 $((blksz * 3)) "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz - 17)) $((blksz + 17)) "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 3)) $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz - 17)) $((blksz + 17)) $testdir/file2.chk >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
 
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test ${c1} = ${c2} || echo "file1 and file2 should match"
 
 echo "fzero files"
-"$XFS_IO_PROG" -f -c "fzero $((blksz - 17)) $((blksz + 17))" "$testdir/file2"
+$XFS_IO_PROG -f -c "fzero $((blksz - 17)) $((blksz + 17))" $testdir/file2
 _test_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
 
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/181 b/tests/generic/181
index cb6639f..9c640e4 100755
--- a/tests/generic/181
+++ b/tests/generic/181
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,32 +48,32 @@ _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * 256)) "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * 2)) "$testdir/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 255)) "$testdir/file2.chk" >> "$seqres.full"
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) 0 >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 256)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $((blksz * 256)) $testdir/file2 >> $seqres.full
+_pwrite_byte 0x62 0 $((blksz * 2)) $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 255)) $testdir/file2.chk >> $seqres.full
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) 0 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
 
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/182 b/tests/generic/182
index ef10af8..fddacc4 100755
--- a/tests/generic/182
+++ b/tests/generic/182
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -47,69 +47,69 @@ _cleanup()
 _supported_os Linux
 _require_test_dedupe
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * 257)) "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * 257)) "$testdir/file2.chk" >> "$seqres.full"
-_dedupe_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) 0 >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 256)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $((blksz * 257)) $testdir/file2 >> $seqres.full
+_pwrite_byte 0x62 0 $((blksz * 257)) $testdir/file2.chk >> $seqres.full
+_dedupe_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) 0 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
 
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
 
 echo "Make the original file almost dedup-able"
-_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file2.chk" >> "$seqres.full"
-_dedupe_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) 0 >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 256)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz * 256)) $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz * 256)) $testdir/file2.chk >> $seqres.full
+_dedupe_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) 0 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
 
-test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test ${c1} != ${c2} || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
 
 echo "Make the original file dedup-able"
-_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((blksz * 257)) "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((blksz * 257)) "$testdir/file2.chk" >> "$seqres.full"
-_dedupe_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) 0 >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 256)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz * 257)) $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz * 257)) $testdir/file2.chk >> $seqres.full
+_dedupe_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) 0 >> $seqres.full
 _test_remount
 
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
-md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum $testdir/file1 | _filter_test_dir
+md5sum $testdir/file2 | _filter_test_dir
+md5sum $testdir/file2.chk | _filter_test_dir
 
-c1="$(_md5_checksum "$testdir/file1")"
-c2="$(_md5_checksum "$testdir/file2")"
+c1=$(_md5_checksum $testdir/file1)
+c2=$(_md5_checksum $testdir/file2)
 
-test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test ${c1} = ${c2} || echo "file1 and file2 should match"
 
 echo "Compare against check files"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/183 b/tests/generic/183
index c928acd..0f35da2 100755
--- a/tests/generic/183
+++ b/tests/generic/183
@@ -26,8 +26,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,47 +50,49 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file2" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $filesize $testdir/file2 >> $seqres.full
 seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+	_reflink_range $testdir/file1 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x61 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
 done
 seq 1 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file2" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+	_reflink_range $testdir/file2 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x62 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "directio CoW across the transition"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/185 b/tests/generic/185
index fb05e6d..28826d0 100755
--- a/tests/generic/185
+++ b/tests/generic/185
@@ -26,8 +26,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,47 +50,49 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file2" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $filesize $testdir/file2 >> $seqres.full
 seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+	_reflink_range $testdir/file1 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x61 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
 done
 seq 1 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file2" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+	_reflink_range $testdir/file2 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x62 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "CoW across the transition"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/186 b/tests/generic/186
index e495cbc..9839a22 100755
--- a/tests/generic/186
+++ b/tests/generic/186
@@ -28,8 +28,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -40,7 +40,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-#    rm -rf "$tmp".* "$testdir"
+#    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -54,88 +54,91 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
-test "$FSTYP" = "btrfs" && _notrun "Can't fragment free space on btrfs."
+test $FSTYP = "btrfs" && _notrun "Can't fragment free space on btrfs."
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 _fragment_freesp()
 {
-	file="$1"
+	file=$1
 
 	# consume nearly all available space (leave ~1MB)
 	avail=`_get_available_space $SCRATCH_MNT`
 	echo "$avail bytes left"
 	filesize=$((avail - 1048576))
-	$XFS_IO_PROG -fc "truncate $filesize" "$file"
+	$XFS_IO_PROG -fc "truncate $filesize" $file
 
 	chunks=20
 	chunksizemb=$((filesize / chunks / 1048576))
 	seq 1 $chunks | while read f; do
 		echo "$((f * chunksizemb)) file size $f / 20"
-		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" "$file"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" $file
 	done
 
 	chunks=100
 	chunksizemb=$((filesize / chunks / 1048576))
 	seq 80 $chunks | while read f; do
 		echo "$((f * chunksizemb)) file size $f / $chunks"
-		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" "$file"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" $file
 	done
 
 	filesizemb=$((filesize / 1048576))
-	$XFS_IO_PROG -fc "falloc -k 0 ${filesizemb}m" "$file"
+	$XFS_IO_PROG -fc "falloc -k 0 ${filesizemb}m" $file
 
 	# Try again anyway
 	avail=`_get_available_space $SCRATCH_MNT`
-	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" "${file}.${i}"
+	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}.${i}
 
 	# Punch out whatever we need
 	seq 1 $((nr * 4)) | while read f; do
-		$XFS_IO_PROG -f -c "fpunch $((f * 2 * blksz)) $blksz" "$file"
+		$XFS_IO_PROG -f -c "fpunch $((f * 2 * blksz)) $blksz" $file
 	done
 }
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=1024
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file2" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $filesize $testdir/file2 >> $seqres.full
 seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+	_reflink_range $testdir/file1 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x61 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
 done
 seq 1 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file2" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+	_reflink_range $testdir/file2 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x62 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
 done
 _scratch_remount
-_fragment_freesp "$testdir/bigfile" >> "$seqres.full" 2>&1
+_fragment_freesp $testdir/bigfile >> $seqres.full 2>&1
+filesize=$((blksz * nr))
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "CoW with multiple extents?"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/187 b/tests/generic/187
index e3461ab..b8fade2 100755
--- a/tests/generic/187
+++ b/tests/generic/187
@@ -28,8 +28,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -40,7 +40,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-#    rm -rf "$tmp".* "$testdir"
+#    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -54,88 +54,91 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
-test "$FSTYP" = "btrfs" && _notrun "Can't fragment free space on btrfs."
+test $FSTYP = "btrfs" && _notrun "Can't fragment free space on btrfs."
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 _fragment_freesp()
 {
-	file="$1"
+	file=$1
 
 	# consume nearly all available space (leave ~1MB)
 	avail=`_get_available_space $SCRATCH_MNT`
 	echo "$avail bytes left"
 	filesize=$((avail - 1048576))
-	$XFS_IO_PROG -fc "truncate $filesize" "$file"
+	$XFS_IO_PROG -fc "truncate $filesize" $file
 
 	chunks=20
 	chunksizemb=$((filesize / chunks / 1048576))
 	seq 1 $chunks | while read f; do
 		echo "$((f * chunksizemb)) file size $f / 20"
-		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" "$file"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" $file
 	done
 
 	chunks=100
 	chunksizemb=$((filesize / chunks / 1048576))
 	seq 80 $chunks | while read f; do
 		echo "$((f * chunksizemb)) file size $f / $chunks"
-		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" "$file"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" $file
 	done
 
 	filesizemb=$((filesize / 1048576))
-	$XFS_IO_PROG -fc "falloc -k 0 ${filesizemb}m" "$file"
+	$XFS_IO_PROG -fc "falloc -k 0 ${filesizemb}m" $file
 
 	# Try again anyway
 	avail=`_get_available_space $SCRATCH_MNT`
-	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" "${file}.${i}"
+	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}.${i}
 
 	# Punch out whatever we need
 	seq 1 $((nr * 4)) | while read f; do
-		$XFS_IO_PROG -f -c "fpunch $((f * 2 * blksz)) $blksz" "$file"
+		$XFS_IO_PROG -f -c "fpunch $((f * 2 * blksz)) $blksz" $file
 	done
 }
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=1024
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file2" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $filesize $testdir/file2 >> $seqres.full
 seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+	_reflink_range $testdir/file1 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x61 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
 done
 seq 1 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file2" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+	_reflink_range $testdir/file2 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x62 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
 done
 _scratch_remount
-_fragment_freesp "$testdir/bigfile" >> "$seqres.full" 2>&1
+_fragment_freesp $testdir/bigfile >> $seqres.full 2>&1
+filesize=$((blksz * nr))
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "CoW with multiple extents?"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/188 b/tests/generic/188
index 86980cc..7be1080 100755
--- a/tests/generic/188
+++ b/tests/generic/188
@@ -25,8 +25,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,36 +50,38 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "directio CoW across the transition"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/189 b/tests/generic/189
index 8f5a338..5b409be 100755
--- a/tests/generic/189
+++ b/tests/generic/189
@@ -25,8 +25,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,36 +50,38 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "CoW across the transition"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/190 b/tests/generic/190
index 8edfeb7..a5c2137 100755
--- a/tests/generic/190
+++ b/tests/generic/190
@@ -25,8 +25,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,36 +50,38 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "directio CoW across the transition"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/191 b/tests/generic/191
index dd97baa..cfedcde 100755
--- a/tests/generic/191
+++ b/tests/generic/191
@@ -25,8 +25,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,36 +50,38 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "CoW across the transition"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/194 b/tests/generic/194
index 82b3100..69a3e6c 100755
--- a/tests/generic/194
+++ b/tests/generic/194
@@ -26,8 +26,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -51,37 +51,39 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "directio CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
 _weave_reflink_holes_delalloc $blksz $nr $testdir/file3 >> $seqres.full
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/195 b/tests/generic/195
index ce4c0a9..51f10f3 100755
--- a/tests/generic/195
+++ b/tests/generic/195
@@ -26,8 +26,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -51,37 +51,39 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
 _weave_reflink_holes_delalloc $blksz $nr $testdir/file3 >> $seqres.full
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/196 b/tests/generic/196
index a7a0035..951079c 100755
--- a/tests/generic/196
+++ b/tests/generic/196
@@ -25,8 +25,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,36 +50,38 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "directio CoW across the transition"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/197 b/tests/generic/197
index 84a14ff..cfdbf1b 100755
--- a/tests/generic/197
+++ b/tests/generic/197
@@ -25,8 +25,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -50,36 +50,38 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "CoW across the transition"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/199 b/tests/generic/199
index 6a65533..f457245 100755
--- a/tests/generic/199
+++ b/tests/generic/199
@@ -29,8 +29,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -41,7 +41,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -56,38 +56,40 @@ _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "directio CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
 _weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
 # now cow
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/200 b/tests/generic/200
index 541d16d..ffb5869 100755
--- a/tests/generic/200
+++ b/tests/generic/200
@@ -29,8 +29,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -41,7 +41,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -56,38 +56,40 @@ _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
+filesize=$((blksz * nr))
 _weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "directio CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
 _weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
 # now cow
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/201 b/tests/generic/201
index 90087ef..634dec9 100755
--- a/tests/generic/201
+++ b/tests/generic/201
@@ -21,8 +21,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -46,36 +46,38 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_pwrite_byte 0x62 0 $filesize $testdir/file3 >> $seqres.full
+_pwrite_byte 0x62 0 $filesize $testdir/file3.chk >> $seqres.full
 seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+	_reflink_range $testdir/file1 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x61 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file3.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
-rm "$testdir/file3"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+rm $testdir/file3
 
 # success, all done
 status=0
diff --git a/tests/generic/202 b/tests/generic/202
index e034e4e..a7f4004 100755
--- a/tests/generic/202
+++ b/tests/generic/202
@@ -20,8 +20,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -45,37 +45,36 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz + 17)) "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2"
-_pwrite_byte 0x61 0 $((blksz + 17)) "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz + 17)) $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2
+_pwrite_byte 0x61 0 $((blksz + 17)) $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file2.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) 17" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) 17" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) 17" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) 17" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file2.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/203 b/tests/generic/203
index 2b6db7e..5d9bfc4 100755
--- a/tests/generic/203
+++ b/tests/generic/203
@@ -20,8 +20,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -45,37 +45,36 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
-_pwrite_byte 0x61 0 $((blksz + 17)) "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2"
-_pwrite_byte 0x61 0 $((blksz + 17)) "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz + 17)) $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2
+_pwrite_byte 0x61 0 $((blksz + 17)) $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file2.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $blksz" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $blksz" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 $blksz $blksz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $blksz $blksz" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file2.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/205 b/tests/generic/205
index 8955e67..683849e 100755
--- a/tests/generic/205
+++ b/tests/generic/205
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,50 +48,49 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz $testdir/file1 >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2.chk >> $seqres.full
 
-_pwrite_byte 0x61 $blksz $blksz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 $blksz $blksz $testdir/file2.chk >> $seqres.full
 
-_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 3)) $blksz $testdir/file2.chk >> $seqres.full
 
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) $blksz >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 # success, all done
 status=0
diff --git a/tests/generic/206 b/tests/generic/206
index 12ad745..4054626 100755
--- a/tests/generic/206
+++ b/tests/generic/206
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,50 +48,49 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz $testdir/file1 >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2.chk >> $seqres.full
 
-_pwrite_byte 0x61 $blksz $blksz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 $blksz $blksz $testdir/file2.chk >> $seqres.full
 
-_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 3)) $blksz $testdir/file2.chk >> $seqres.full
 
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) $blksz >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 # success, all done
 status=0
diff --git a/tests/generic/216 b/tests/generic/216
index 3e0084e..d9f7e21 100755
--- a/tests/generic/216
+++ b/tests/generic/216
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,50 +49,49 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz $testdir/file1 >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2.chk >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "falloc -k $blksz $blksz" "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x00 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc -k $blksz $blksz" $testdir/file2 >> $seqres.full
+_pwrite_byte 0x00 $blksz $blksz $testdir/file2.chk >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "falloc -k $((blksz * 3)) $blksz" "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc -k $((blksz * 3)) $blksz" $testdir/file2 >> $seqres.full
+_pwrite_byte 0x00 $((blksz * 3)) $blksz $testdir/file2.chk >> $seqres.full
 
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) $blksz >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 # success, all done
 status=0
diff --git a/tests/generic/217 b/tests/generic/217
index 3470d25..b1bd635 100755
--- a/tests/generic/217
+++ b/tests/generic/217
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,50 +49,49 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz $testdir/file1 >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2.chk >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "falloc -k $blksz $blksz" "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x00 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc -k $blksz $blksz" $testdir/file2 >> $seqres.full
+_pwrite_byte 0x00 $blksz $blksz $testdir/file2.chk >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "falloc -k $((blksz * 3)) $blksz" "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x00 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc -k $((blksz * 3)) $blksz" $testdir/file2 >> $seqres.full
+_pwrite_byte 0x00 $((blksz * 3)) $blksz $testdir/file2.chk >> $seqres.full
 
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) $blksz >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 # success, all done
 status=0
diff --git a/tests/generic/218 b/tests/generic/218
index 220cda3..ecc009a 100755
--- a/tests/generic/218
+++ b/tests/generic/218
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,44 +49,43 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz $testdir/file1 >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2.chk >> $seqres.full
 
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) $blksz >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 # success, all done
 status=0
diff --git a/tests/generic/220 b/tests/generic/220
index 151bf76..edb8432 100755
--- a/tests/generic/220
+++ b/tests/generic/220
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,44 +49,43 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz $testdir/file1 >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2.chk >> $seqres.full
 
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) $blksz >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 # success, all done
 status=0
diff --git a/tests/generic/222 b/tests/generic/222
index c95a1d6..58ca8f5 100755
--- a/tests/generic/222
+++ b/tests/generic/222
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,50 +49,49 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz $testdir/file1 >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2.chk >> $seqres.full
 
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) $blksz >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-_pwrite_byte 0x61 $blksz $blksz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 $blksz $blksz $testdir/file2.chk >> $seqres.full
 
-_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 3)) $blksz $testdir/file2.chk >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 # success, all done
 status=0
diff --git a/tests/generic/227 b/tests/generic/227
index d62ab52..abaf8f7 100755
--- a/tests/generic/227
+++ b/tests/generic/227
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,50 +49,49 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz $testdir/file1 >> $seqres.full
 
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $pagesz" $testdir/file2.chk >> $seqres.full
 
-_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 2)) $blksz >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-_pwrite_byte 0x61 $blksz $blksz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 $blksz $blksz $testdir/file2.chk >> $seqres.full
 
-_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 3)) $blksz $testdir/file2.chk >> $seqres.full
 
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
-cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s $testdir/file1 $testdir/file2 || _fail "file1 and file2 don't match."
+cmp -s $testdir/file2 $testdir/file2.chk || _fail "file2 and file2.chk don't match."
 
 # success, all done
 status=0
diff --git a/tests/generic/229 b/tests/generic/229
index cc86b4e..b6359e8 100755
--- a/tests/generic/229
+++ b/tests/generic/229
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,21 +49,20 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {
 	echo "runtest $1 $2"
@@ -72,20 +71,20 @@ runtest() {
 	dir=$3
 
 	echo "Create the original files"
-	mkdir -p "$dir"
-	_pwrite_byte 0x61 0 $pagesz "$dir/file1" >> "$seqres.full"
+	mkdir -p $dir
+	_pwrite_byte 0x61 0 $pagesz $dir/file1 >> $seqres.full
 
-	"$XFS_IO_PROG" -f -c "truncate $pagesz" "$dir/file2" >> "$seqres.full"
-	"$XFS_IO_PROG" -f -c "truncate $pagesz" "$dir/file2.chk" >> "$seqres.full"
+	$XFS_IO_PROG -f -c "truncate $pagesz" $dir/file2 >> $seqres.full
+	$XFS_IO_PROG -f -c "truncate $pagesz" $dir/file2.chk >> $seqres.full
 
-	case "$b2" in
+	case $b2 in
 	"regular")
-		_pwrite_byte 0x61 $blksz $blksz "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz $dir/file2 >> $seqres.full
+		_pwrite_byte 0x61 $blksz $blksz $dir/file2.chk >> $seqres.full
 		;;
 	"unwritten")
-		"$XFS_IO_PROG" -f -c "falloc -k $blksz $blksz" "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x00 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
+		$XFS_IO_PROG -f -c "falloc -k $blksz $blksz" $dir/file2 >> $seqres.full
+		_pwrite_byte 0x00 $blksz $blksz $dir/file2.chk >> $seqres.full
 		;;
 	"hole")
 		;;
@@ -93,45 +92,45 @@ runtest() {
 
 
 
-	case "$b4" in
+	case $b4 in
 	"regular")
-		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz $dir/file2 >> $seqres.full
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz $dir/file2.chk >> $seqres.full
 		;;
 	"unwritten")
-		"$XFS_IO_PROG" -f -c "falloc -k $((blksz * 3)) $blksz" "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x00 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
+		$XFS_IO_PROG -f -c "falloc -k $((blksz * 3)) $blksz" $dir/file2 >> $seqres.full
+		_pwrite_byte 0x00 $((blksz * 3)) $blksz $dir/file2.chk >> $seqres.full
 		;;
 	"hole")
 		;;
 	esac
 
-	_reflink_range "$dir/file1" $blksz "$dir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * 2)) $blksz "$dir/file2.chk" >> "$seqres.full"
+	_reflink_range $dir/file1 $blksz $dir/file2 $((blksz * 2)) $blksz >> $seqres.full
+	_pwrite_byte 0x61 $((blksz * 2)) $blksz $dir/file2.chk >> $seqres.full
 	_scratch_remount
 
 	echo "Compare files"
-	! cmp -s "$dir/file1" "$dir/file2" || _fail "file1 and file2 don't match."
-	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
+	! cmp -s $dir/file1 $dir/file2 || _fail "file1 and file2 don't match."
+	cmp -s $dir/file2 $dir/file2.chk || _fail "file2 and file2.chk don't match."
 
 	echo "CoW and unmount"
-	if [ "$b2" = "delalloc" ]; then
-		_pwrite_byte 0x61 $blksz $blksz "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
+	if [ $b2 = "delalloc" ]; then
+		_pwrite_byte 0x61 $blksz $blksz $dir/file2 >> $seqres.full
+		_pwrite_byte 0x61 $blksz $blksz $dir/file2.chk >> $seqres.full
 	fi
 
-	if [ "$b4" = "delalloc" ]; then
-		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
+	if [ $b4 = "delalloc" ]; then
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz $dir/file2 >> $seqres.full
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz $dir/file2.chk >> $seqres.full
 	fi
 
-	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$dir/file2" >> "$seqres.full"
-	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$dir/file2.chk" >> "$seqres.full"
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $dir/file2 >> $seqres.full
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" $dir/file2.chk >> $seqres.full
 	_scratch_remount
 
 	echo "Compare files"
-	! cmp -s "$dir/file1" "$dir/file2" || _fail "file1 and file2 don't match."
-	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
+	! cmp -s $dir/file1 $dir/file2 || _fail "file1 and file2 don't match."
+	cmp -s $dir/file2 $dir/file2.chk || _fail "file2 and file2.chk don't match."
 }
 
 runtest regular delalloc "$testdir/r-d"
diff --git a/tests/generic/238 b/tests/generic/238
index c726770..ce7408c 100755
--- a/tests/generic/238
+++ b/tests/generic/238
@@ -24,8 +24,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -49,21 +49,20 @@ _supported_os Linux
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 pagesz=$(getconf PAGE_SIZE)
 blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 real_blksz=$(stat -f -c '%S' $testdir)
-test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
+test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {
 	echo "runtest $1 $2"
@@ -72,20 +71,20 @@ runtest() {
 	dir=$3
 
 	echo "Create the original files"
-	mkdir -p "$dir"
-	_pwrite_byte 0x61 0 $pagesz "$dir/file1" >> "$seqres.full"
+	mkdir -p $dir
+	_pwrite_byte 0x61 0 $pagesz $dir/file1 >> $seqres.full
 
-	"$XFS_IO_PROG" -f -c "truncate $pagesz" "$dir/file2" >> "$seqres.full"
-	"$XFS_IO_PROG" -f -c "truncate $pagesz" "$dir/file2.chk" >> "$seqres.full"
+	$XFS_IO_PROG -f -c "truncate $pagesz" $dir/file2 >> $seqres.full
+	$XFS_IO_PROG -f -c "truncate $pagesz" $dir/file2.chk >> $seqres.full
 
-	case "$b2" in
+	case $b2 in
 	"regular")
-		_pwrite_byte 0x61 $blksz $blksz "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz $dir/file2 >> $seqres.full
+		_pwrite_byte 0x61 $blksz $blksz $dir/file2.chk >> $seqres.full
 		;;
 	"unwritten")
-		"$XFS_IO_PROG" -f -c "falloc -k $blksz $blksz" "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x00 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
+		$XFS_IO_PROG -f -c "falloc -k $blksz $blksz" $dir/file2 >> $seqres.full
+		_pwrite_byte 0x00 $blksz $blksz $dir/file2.chk >> $seqres.full
 		;;
 	"hole")
 		;;
@@ -93,45 +92,45 @@ runtest() {
 
 
 
-	case "$b4" in
+	case $b4 in
 	"regular")
-		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz $dir/file2 >> $seqres.full
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz $dir/file2.chk >> $seqres.full
 		;;
 	"unwritten")
-		"$XFS_IO_PROG" -f -c "falloc -k $((blksz * 3)) $blksz" "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x00 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
+		$XFS_IO_PROG -f -c "falloc -k $((blksz * 3)) $blksz" $dir/file2 >> $seqres.full
+		_pwrite_byte 0x00 $((blksz * 3)) $blksz $dir/file2.chk >> $seqres.full
 		;;
 	"hole")
 		;;
 	esac
 
-	_reflink_range "$dir/file1" $blksz "$dir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * 2)) $blksz "$dir/file2.chk" >> "$seqres.full"
+	_reflink_range $dir/file1 $blksz $dir/file2 $((blksz * 2)) $blksz >> $seqres.full
+	_pwrite_byte 0x61 $((blksz * 2)) $blksz $dir/file2.chk >> $seqres.full
 	_scratch_remount
 
 	echo "Compare files"
-	! cmp -s "$dir/file1" "$dir/file2" || _fail "file1 and file2 don't match."
-	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
+	! cmp -s $dir/file1 $dir/file2 || _fail "file1 and file2 don't match."
+	cmp -s $dir/file2 $dir/file2.chk || _fail "file2 and file2.chk don't match."
 
 	echo "CoW and unmount"
-	if [ "$b2" = "delalloc" ]; then
-		_pwrite_byte 0x61 $blksz $blksz "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
+	if [ $b2 = "delalloc" ]; then
+		_pwrite_byte 0x61 $blksz $blksz $dir/file2 >> $seqres.full
+		_pwrite_byte 0x61 $blksz $blksz $dir/file2.chk >> $seqres.full
 	fi
 
-	if [ "$b4" = "delalloc" ]; then
-		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
+	if [ $b4 = "delalloc" ]; then
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz $dir/file2 >> $seqres.full
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz $dir/file2.chk >> $seqres.full
 	fi
 
-	"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$dir/file2" >> "$seqres.full"
-	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$dir/file2.chk" >> "$seqres.full"
+	$XFS_IO_PROG -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $dir/file2 >> $seqres.full
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" $dir/file2.chk >> $seqres.full
 	_scratch_remount
 
 	echo "Compare files"
-	! cmp -s "$dir/file1" "$dir/file2" || _fail "file1 and file2 don't match."
-	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
+	! cmp -s $dir/file1 $dir/file2 || _fail "file1 and file2 don't match."
+	cmp -s $dir/file2 $dir/file2.chk || _fail "file2 and file2.chk don't match."
 }
 
 runtest regular delalloc "$testdir/r-d"
diff --git a/tests/generic/242 b/tests/generic/242
index 1141aa4..1f174df 100755
--- a/tests/generic/242
+++ b/tests/generic/242
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,47 +48,48 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
 nr=6400
-bsz=1280
+filesize=$((blksz * nr))
+bufnr=1280
+bufsize=$((blksz * bufnr))
 
-free_blocks=$(stat -f -c '%a' "$testdir")
-real_blksz=$(stat -f -c '%S' "$testdir")
-space_needed=$(((blksz * nr * 3) * 5 / 4))
+free_blocks=$(stat -f -c '%a' $testdir)
+real_blksz=$(stat -f -c '%S' $testdir)
+space_needed=$(((filesize * 3) * 5 / 4))
 space_avail=$((free_blocks * real_blksz))
 test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
 
 echo "Create the original files"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file2.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file2.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/generic/243 b/tests/generic/243
index a514591..127070e 100755
--- a/tests/generic/243
+++ b/tests/generic/243
@@ -23,8 +23,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -48,47 +48,48 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf $testdir
+testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
 nr=6400
-bsz=1280
+filesize=$((blksz * nr))
+bufnr=1280
+bufsize=$((blksz * bufnr))
 
-free_blocks=$(stat -f -c '%a' "$testdir")
-real_blksz=$(stat -f -c '%S' "$testdir")
-space_needed=$(((blksz * nr * 3) * 5 / 4))
+free_blocks=$(stat -f -c '%a' $testdir)
+real_blksz=$(stat -f -c '%S' $testdir)
+space_needed=$(((filesize * 3) * 5 / 4))
 space_avail=$((free_blocks * real_blksz))
 test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
 
 echo "Create the original files"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file2.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2.chk" >> "$seqres.full"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file2.chk" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/xfs/127 b/tests/xfs/127
index 392e63c..67a8c96 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -21,8 +21,8 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f "$tmp".*
+    rm -f $tmp.*
 }
 
 # get standard environment, filters and checks
@@ -48,27 +48,26 @@ _require_scratch_reflink
 _require_cp_reflink
 
 echo "Format and mount"
-_scratch_mkfs -d size=$((2 * 4096 * 4096)) -l size=4194304 > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs -d size=$((2 * 4096 * 4096)) -l size=4194304 > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 echo "Create the original file and reflink to copy1, copy2"
-blksz="$(stat -f "$testdir" -c '%S')"
-_pwrite_byte 0x61 0 $((blksz * 14 + 71)) "$testdir/original" >> "$seqres.full"
-_cp_reflink "$testdir/original" "$testdir/copy1"
-_cp_reflink "$testdir/copy1" "$testdir/copy2"
+blksz="$(stat -f $testdir -c '%S')"
+_pwrite_byte 0x61 0 $((blksz * 14 + 71)) $testdir/original >> $seqres.full
+_cp_reflink $testdir/original $testdir/copy1
+_cp_reflink $testdir/copy1 $testdir/copy2
 
 echo "Grow fs"
-"$XFS_GROWFS_PROG" "$SCRATCH_MNT" 2>&1 |  _filter_growfs >> "$seqres.full"
+$XFS_GROWFS_PROG $SCRATCH_MNT 2>&1 |  _filter_growfs >> $seqres.full
 _scratch_remount
 
 echo "Create more reflink copies"
-_cp_reflink "$testdir/original" "$testdir/copy3"
+_cp_reflink $testdir/original $testdir/copy3
 
-xfs_info "$SCRATCH_MNT" >> "$seqres.full"
+xfs_info $SCRATCH_MNT >> $seqres.full
 
 # success, all done
 status=0
diff --git a/tests/xfs/128 b/tests/xfs/128
index f230adf..56778fc 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -21,8 +21,8 @@
 #-----------------------------------------------------------------------
 #
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f "$tmp".*
+    rm -f $tmp.*
 }
 
 # get standard environment, filters and checks
@@ -49,13 +49,12 @@ _require_scratch_reflink
 _require_cp_reflink
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
-free_blocks0=$(stat -f "$testdir" -c '%f')
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+free_blocks0=$(stat -f $testdir -c '%f')
 
 echo "Create the original file and reflink to file2, file3"
 blks=2000
@@ -63,57 +62,57 @@ margin=160
 blksz=65536
 real_blksz="$(stat -f $testdir -c '%S')"
 blksz_factor=$((blksz / real_blksz))
-_pwrite_byte 0x61 0 $((blks * blksz)) "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2"
-_cp_reflink "$testdir/file2" "$testdir/file3"
-_cp_reflink "$testdir/file3" "$testdir/file4"
+_pwrite_byte 0x61 0 $((blks * blksz)) $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2
+_cp_reflink $testdir/file2 $testdir/file3
+_cp_reflink $testdir/file3 $testdir/file4
 _test_remount
-free_blocks1=$(stat -f "$testdir" -c '%f')
+free_blocks1=$(stat -f $testdir -c '%f')
 
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file4" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file4 | _filter_scratch
 
-c01=$(_md5_checksum "$testdir/file1")
-c02=$(_md5_checksum "$testdir/file2")
-c03=$(_md5_checksum "$testdir/file3")
-c04=$(_md5_checksum "$testdir/file4")
+c01=$(_md5_checksum $testdir/file1)
+c02=$(_md5_checksum $testdir/file2)
+c03=$(_md5_checksum $testdir/file3)
+c04=$(_md5_checksum $testdir/file4)
 
 echo "CoW the reflink copies"
-_pwrite_byte 0x62 $blksz $blksz "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x63 $(( blksz * (blks - 1) )) $blksz "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz $testdir/file2 >> $seqres.full
+_pwrite_byte 0x63 $(( blksz * (blks - 1) )) $blksz $testdir/file3 >> $seqres.full
 _test_remount
-free_blocks2=$(stat -f "$testdir" -c '%f')
+free_blocks2=$(stat -f $testdir -c '%f')
 
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file4" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file4 | _filter_scratch
 
-c11=$(_md5_checksum "$testdir/file1")
-c12=$(_md5_checksum "$testdir/file2")
-c13=$(_md5_checksum "$testdir/file3")
-c14=$(_md5_checksum "$testdir/file4")
+c11=$(_md5_checksum $testdir/file1)
+c12=$(_md5_checksum $testdir/file2)
+c13=$(_md5_checksum $testdir/file3)
+c14=$(_md5_checksum $testdir/file4)
 
 echo "Defragment"
-lsattr -l "$testdir/" | _filter_scratch | _filter_spaces
-xfs_fsr -v -d "$testdir/file1" >> "$seqres.full"
-xfs_fsr -v -d "$testdir/file2" >> "$seqres.full" # fsr probably breaks the link
-xfs_fsr -v -d "$testdir/file3" >> "$seqres.full" # fsr probably breaks the link
-xfs_fsr -v -d "$testdir/file4" >> "$seqres.full" # fsr probably ignores this file
+lsattr -l $testdir/ | _filter_scratch | _filter_spaces
+xfs_fsr -v -d $testdir/file1 >> $seqres.full
+xfs_fsr -v -d $testdir/file2 >> $seqres.full # fsr probably breaks the link
+xfs_fsr -v -d $testdir/file3 >> $seqres.full # fsr probably breaks the link
+xfs_fsr -v -d $testdir/file4 >> $seqres.full # fsr probably ignores this file
 _test_remount
-free_blocks3=$(stat -f "$testdir" -c '%f')
+free_blocks3=$(stat -f $testdir -c '%f')
 
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-md5sum "$testdir/file3" | _filter_scratch
-md5sum "$testdir/file4" | _filter_scratch
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file4 | _filter_scratch
 
-c21=$(_md5_checksum "$testdir/file1")
-c22=$(_md5_checksum "$testdir/file2")
-c23=$(_md5_checksum "$testdir/file3")
-c24=$(_md5_checksum "$testdir/file4")
+c21=$(_md5_checksum $testdir/file1)
+c22=$(_md5_checksum $testdir/file2)
+c23=$(_md5_checksum $testdir/file3)
+c24=$(_md5_checksum $testdir/file4)
 
 echo "Check files"
 test $c01 = $c02 || echo "Files 1-2 do not match"
diff --git a/tests/xfs/129 b/tests/xfs/129
index 8d608f2..d29f842 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -22,7 +22,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
+seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
@@ -34,8 +34,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    umount "$SCRATCH_MNT" > /dev/null 2>&1
-    rm -rf "$tmp".* "$testdir" "$metadump_file" "$TEST_DIR/image"
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image
 }
 
 # get standard environment, filters and checks
@@ -49,39 +49,38 @@ _supported_fs xfs
 _require_loop
 _require_scratch_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
-metadump_file="$TEST_DIR/${seq}_metadump"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+metadump_file=$TEST_DIR/${seq}_metadump
 
 echo "Create the original file blocks"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 nr_blks=$((4 * blksz / 12))
-_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/file1 >> $seqres.full
 
 echo "Reflink every other block"
 seq 1 2 $((nr_blks - 1)) | while read nr; do
-	_reflink_range  "$testdir/file1" $((nr * blksz)) \
-			"$testdir/file2" $((nr * blksz)) $blksz >> "$seqres.full"
+	_reflink_range  $testdir/file1 $((nr * blksz)) \
+			$testdir/file2 $((nr * blksz)) $blksz >> $seqres.full
 done
 
 echo "Create metadump file"
 _scratch_unmount
-_scratch_metadump "$metadump_file"
+_scratch_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
-xfs_mdrestore "$metadump_file" "$TEST_DIR/image"
-_mount -t $FSTYP "$TEST_DIR/image" "$SCRATCH_MNT"
-umount "$SCRATCH_MNT"
+xfs_mdrestore $metadump_file $TEST_DIR/image
+_mount -t $FSTYP $TEST_DIR/image $SCRATCH_MNT
+umount $SCRATCH_MNT
 
 echo "Check restored fs"
-_check_generic_filesystem "$metadump_file"
+_check_generic_filesystem $metadump_file
 
 # success, all done
 status=0
diff --git a/tests/xfs/131 b/tests/xfs/131
index f553a44..8df77ff 100755
--- a/tests/xfs/131
+++ b/tests/xfs/131
@@ -20,7 +20,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
+seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
@@ -32,8 +32,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    umount "$SCRATCH_MNT" > /dev/null 2>&1
-    rm -rf "$tmp".* "$testdir" "$metadump_file"
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.* $testdir $metadump_file
 }
 
 # get standard environment, filters and checks
@@ -48,24 +48,23 @@ _require_realtime
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount scratch device"
-_scratch_mkfs >> "$seqres.full"
+_scratch_mkfs >> $seqres.full
 _scratch_mount
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
 
 echo "Create the original file blocks"
 blksz=65536
-$XFS_IO_PROG -R -f -c "truncate $blksz" "$testdir/file1"
+$XFS_IO_PROG -R -f -c "truncate $blksz" $testdir/file1
 
 echo "Reflink every block"
-_cp_reflink "$testdir/file1" "$testdir/file2" 2>&1 | _filter_scratch
+_cp_reflink $testdir/file1 $testdir/file2 2>&1 | _filter_scratch
 
-test -s "$testdir/file2" && _fail "Should not be able to reflink a realtime file."
+test -s $testdir/file2 && _fail "Should not be able to reflink a realtime file."
 
 # success, all done
 status=0
diff --git a/tests/xfs/132 b/tests/xfs/132
index 9c57c3b..cf3d645 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -37,8 +37,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -49,7 +49,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -65,53 +65,54 @@ _require_test_lsattr
 _require_cp_reflink
 _require_xfs_io_command "falloc"
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
-testdir="$TEST_DIR/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(stat -f $testdir -c '%S')"
 blks=2000
 margin=100
 sz=$((blksz * blks))
-free_blocks0=$(stat -f "$testdir" -c '%f')
+free_blocks0=$(stat -f $testdir -c '%f')
 nr=4
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+filesize=$((blksz * nr))
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 _test_remount
 
 echo "Create the reflink copies"
 for i in `seq 2 $nr`; do
-	_cp_reflink "$testdir/file1" "$testdir/file$i"
+	_cp_reflink $testdir/file1 $testdir/file$i
 done
 _test_remount
-free_blocks1=$(stat -f "$testdir" -c '%f')
+free_blocks1=$(stat -f $testdir -c '%f')
 lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare part of a file"
-"$XFS_IO_PROG" -f -c "falloc 0 $((sz / 2))" "$testdir/file2"
+$XFS_IO_PROG -f -c "falloc 0 $((sz / 2))" $testdir/file2
 _test_remount
 lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare some of the copies"
-"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file2"
-"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file3"
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file2
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file3
 _test_remount
-free_blocks2=$(stat -f "$testdir" -c '%f')
+free_blocks2=$(stat -f $testdir -c '%f')
 lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare the rest of the files"
-"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file4"
-"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file1"
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file4
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1
 _test_remount
-free_blocks3=$(stat -f "$testdir" -c '%f')
+free_blocks3=$(stat -f $testdir -c '%f')
 lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "Rewrite the original file"
-_pwrite_byte 0x65 0 $sz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x65 0 $sz $testdir/file1 >> $seqres.full
 _test_remount
-free_blocks4=$(stat -f "$testdir" -c '%f')
+free_blocks4=$(stat -f $testdir -c '%f')
 lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
diff --git a/tests/xfs/139 b/tests/xfs/139
index 55dd7d0..ecd88e6 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -21,8 +21,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -46,32 +46,31 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs -d agsize=$((32 * 1048576)) > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs -d agsize=$((32 * 1048576)) > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
-blksz="$(stat -f "$testdir" -c '%S')"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+blksz="$(stat -f $testdir -c '%S')"
 
 echo "Create the original files"
 sz=$((48 * 1048576))
 nr=$((sz / blksz))
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 _scratch_remount
 
 echo "CoW every other block"
-_pwrite_byte 0x62 0 $sz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $sz $testdir/file1 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_scratch
-md5sum "$testdir/file2" | _filter_scratch
-#filefrag -v "$testdir/file1" "$testdir/file2"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+#filefrag -v $testdir/file1 $testdir/file2
 
 # success, all done
 status=0
diff --git a/tests/xfs/140 b/tests/xfs/140
index a379ca7..6dfe581 100644
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -21,8 +21,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 
-seq=`basename "$0"`
-seqres="$RESULT_DIR/$seq"
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir"
+    rm -rf $tmp.* $testdir
 }
 
 # get standard environment, filters and checks
@@ -46,39 +46,38 @@ _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
 
-rm -f "$seqres.full"
+rm -f $seqres.full
 
 echo "Format and mount"
-_scratch_mkfs -d agsize=$((32 * 1048576)) > "$seqres.full" 2>&1
-_scratch_mount >> "$seqres.full" 2>&1
+_scratch_mkfs -d agsize=$((32 * 1048576)) > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
 
-testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
-mkdir "$testdir"
-blksz="$(stat -f -c '%S' "$testdir")"
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+blksz=$(stat -f -c '%S' $testdir)
 
 echo "Create the original files"
 sz=$((48 * 1048576))
 nr=$((sz / blksz))
-_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $sz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir/file2.chk >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
-cmp -s "$testdir/file1" "$testdir/file2" || echo "file1 and file2 do not match"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s $testdir/file1 $testdir/file2 || echo "file1 and file2 do not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
 
 echo "CoW every other block"
 seq 1 2 $((nr - 1)) | while read f; do
-	_pwrite_byte 0x62 $((f * blksz)) $blksz "$testdir/file2" >> "$seqres.full"
-	_pwrite_byte 0x62 $((f * blksz)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+	_pwrite_byte 0x62 $((f * blksz)) $blksz $testdir/file2 >> $seqres.full
+	_pwrite_byte 0x62 $((f * blksz)) $blksz $testdir/file2.chk >> $seqres.full
 done
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$testdir/file1" "$testdir/file2" || echo "file1 and file2 must not match"
-cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+! cmp -s $testdir/file1 $testdir/file2 || echo "file1 and file2 must not match"
+cmp -s $testdir/file2 $testdir/file2.chk || echo "file2 and file2.chk do not match"
 
 # success, all done
 status=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
