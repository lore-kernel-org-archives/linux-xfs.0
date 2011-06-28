Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S4P9SE177357 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 23:25:10 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66DFE32B74
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 21:25:09 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id TK4Q9wrr1w4ArHuK for
	<xfs@oss.sgi.com>; Mon, 27 Jun 2011 21:25:09 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5S43JWl010918
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:03:19 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5S4P8hr164370 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:25:08 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5S4P8b4014787 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:25:08 -0400
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/3 v2] XFS TESTS: Fix 252 Failure: Relax fiemap filter
Date: Mon, 27 Jun 2011 21:27:25 -0700
Message-Id: <1309235247-32650-2-git-send-email-achender@linux.vnet.ibm.com>
In-Reply-To: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

The current test 252 tests punch hole by collecting fiemap information
on the test file.  However this does not work for all file systems since
not all file systems layout their extents in the same way.

This patch corrects this by adding a -h flag to the fiemap filter that ignores
the extent types in the fiemaps.  The result is that the fiemap contains only
"extent" or "hole", instead of "unwritten", "data" or "hole".  A checksum has
also been added to each test to help ensure the file contents are correct.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
v1 -> v2
Moved new golden output for 252 into a seperate patch to help make the set
easier to read

:100755 100755 5efa243... 1289094... M	252
:100644 100644 ddf63b0... d3c89eb... M	common.punch
 252          |    8 ++++----
 common.punch |   38 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/252 b/252
index 5efa243..1289094 100755
--- a/252
+++ b/252
@@ -53,15 +53,15 @@ _require_xfs_io_fiemap
 testfile=$TEST_DIR/252.$$
 
 # Standard punch hole tests
-_test_generic_punch falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
+_test_generic_punch falloc fpunch fpunch fiemap "_filter_fiemap -h" $testfile -F
 
 # Delayed allocation punch hole tests
-_test_generic_punch -d falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
+_test_generic_punch -d falloc fpunch fpunch fiemap "_filter_fiemap -h" $testfile -F
 
 # Multi hole punch tests
-_test_generic_punch -k falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
+_test_generic_punch -k falloc fpunch fpunch fiemap "_filter_fiemap -h" $testfile -F
 
 # Delayed allocation multi punch hole tests
-_test_generic_punch -d -k falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
+_test_generic_punch -d -k falloc fpunch fpunch fiemap "_filter_fiemap -h" $testfile -F
 
 status=0 ; exit
diff --git a/common.punch b/common.punch
index ddf63b0..d3c89eb 100644
--- a/common.punch
+++ b/common.punch
@@ -203,17 +203,34 @@ _coalesce_extents()
 
 _filter_fiemap()
 {
+
+	UNWRITTEN_EX="\"unwritten\""
+	DATA_EX="\"data\""
+	OPTIND=1
+	while getopts 'h' OPTION
+	do
+		case $OPTION in
+		h)      UNWRITTEN_EX="\"extent\""
+			DATA_EX="\"extent\""
+		;;
+		?)      echo Invalid flag
+		exit 1
+		;;
+		esac
+	done
+	shift $(($OPTIND - 1))
+
 	awk --posix '
 		$3 ~ /hole/ {
 			print $1, $2, $3;
 			next;
 		}
 		$5 ~ /0x[[:digit:]]*8[[:digit:]]{2}/ {
-			print $1, $2, "unwritten";
+			print $1, $2, '$UNWRITTEN_EX';
 			next;
 		}
 		$5 ~ /0x[[:digit:]]+/ {
-			print $1, $2, "data";
+			print $1, $2, '$DATA_EX';
 		}' |
 	_coalesce_extents
 }
@@ -305,6 +322,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	2. into allocated space"
 	if [ "$remove_testfile" ]; then
@@ -315,6 +333,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	3. into unwritten space"
 	if [ "$remove_testfile" ]; then
@@ -325,6 +344,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	4. hole -> data"
 	if [ "$remove_testfile" ]; then
@@ -335,6 +355,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	5. hole -> unwritten"
 	if [ "$remove_testfile" ]; then
@@ -345,6 +366,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	6. data -> hole"
 	if [ "$remove_testfile" ]; then
@@ -355,6 +377,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	7. data -> unwritten"
 	if [ "$remove_testfile" ]; then
@@ -366,6 +389,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	8. unwritten -> hole"
 	if [ "$remove_testfile" ]; then
@@ -376,6 +400,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	9. unwritten -> data"
 	if [ "$remove_testfile" ]; then
@@ -387,6 +412,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	10. hole -> data -> hole"
 	if [ "$remove_testfile" ]; then
@@ -397,6 +423,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	11. data -> hole -> data"
 	if [ "$remove_testfile" ]; then
@@ -410,6 +437,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	12. unwritten -> data -> unwritten"
 	if [ "$remove_testfile" ]; then
@@ -421,6 +449,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	13. data -> unwritten -> data"
 	if [ "$remove_testfile" ]; then
@@ -433,6 +462,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	14. data -> hole @ EOF"
 	rm -f $testfile
@@ -441,6 +471,7 @@ _test_generic_punch()
 		-c "$zero_cmd 12k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	15. data -> hole @ 0"
 	if [ "$remove_testfile" ]; then
@@ -451,6 +482,7 @@ _test_generic_punch()
 		-c "$zero_cmd 0k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	16. data -> cache cold ->hole"
 	if [ "$remove_testfile" ]; then
@@ -470,6 +502,7 @@ _test_generic_punch()
 	diff $testfile $testfile.2
 	[ $? -ne 0 ] && die_now
 	rm -f $testfile.2
+	md5sum $testfile | cut -d ' ' -f1
 
 	echo "	17. data -> hole in single block file"
 	if [ "$remove_testfile" ]; then
@@ -481,5 +514,6 @@ _test_generic_punch()
 		-c "$zero_cmd 128 128" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	md5sum $testfile | cut -d ' ' -f1
 
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
