Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84F7C7F37
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 08:40:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 671E28F8035
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 06:40:40 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GG1J5DCRZzFeTzA1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Dec 2015 06:40:39 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 815D7C0B020F
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 14:40:38 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] fsx: Small improvements and fixes
Date: Tue,  8 Dec 2015 15:40:35 +0100
Message-Id: <1449585635-25123-1-git-send-email-agruenba@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Move the run_fsx shell function into common/rc.  Fix it to avoid
duplicate output on errors.  Write the actual fsx parameters used into
$seqres.full instead of the BSIZE and PSIZE placeholders.

Include the symbolic fallocate mode in fsx error messages instead of the
numeric value.  Use fprintf(stderr, ...) instead of warn() when
including strerror(errno) doesn't make sense.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 common/rc         | 14 ++++++++++++++
 ltp/fsx.c         | 13 ++++++++-----
 tests/generic/091 | 12 ------------
 tests/generic/263 | 12 ------------
 4 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/common/rc b/common/rc
index 4c2f42c..702ef47 100644
--- a/common/rc
+++ b/common/rc
@@ -3151,6 +3151,20 @@ get_block_size()
 	echo `stat -f -c %S $1`
 }
 
+run_fsx()
+{
+	echo fsx $@
+	args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
+	set -- $here/ltp/fsx $args $FSX_AVOID $TEST_DIR/junk
+	echo "$@" >>$seqres.full
+	rm -f $TEST_DIR/junk
+	"$@" 2>&1 | tee -a $seqres.full >$tmp.fsx
+	if [ ${PIPESTATUS[0]} -ne 0 ]; then
+		cat $tmp.fsx
+		exit 1
+	fi
+}
+
 init_rc
 
 ################################################################################
diff --git a/ltp/fsx.c b/ltp/fsx.c
index 6da51e9..805fdfb 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1557,16 +1557,20 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
 
 #endif
 
+#define test_fallocate(mode) __test_fallocate(mode, #mode)
+
 int
-test_fallocate(int mode)
+__test_fallocate(int mode, const char *mode_str)
 {
 #ifdef HAVE_LINUX_FALLOC_H
 	int ret = 0;
 	if (!lite) {
 		if (fallocate(fd, mode, 0, 1) && errno == EOPNOTSUPP) {
 			if(!quiet)
-				warn("main: filesystem does not support "
-				     "fallocate mode 0x%x, disabling!\n", mode);
+				fprintf(stderr,
+					"main: filesystem does not support "
+					"fallocate mode %s, disabling!\n",
+					mode_str);
 		} else {
 			ret = 1;
 			ftruncate(fd, 0);
@@ -1862,8 +1866,7 @@ main(int argc, char **argv)
 	if (keep_size_calls)
 		keep_size_calls = test_fallocate(FALLOC_FL_KEEP_SIZE);
 	if (punch_hole_calls)
-		punch_hole_calls = test_fallocate(FALLOC_FL_PUNCH_HOLE |
-						  FALLOC_FL_KEEP_SIZE);
+		punch_hole_calls = test_fallocate(FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE);
 	if (zero_range_calls)
 		zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
 	if (collapse_range_calls)
diff --git a/tests/generic/091 b/tests/generic/091
index 30491bf..da54397 100755
--- a/tests/generic/091
+++ b/tests/generic/091
@@ -43,18 +43,6 @@ _require_odirect
 
 rm -f $seqres.full
 
-run_fsx()
-{
-	echo fsx $@ | tee -a $seqres.full
-	args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
-	rm -f $TEST_DIR/junk
-	$here/ltp/fsx $args $FSX_AVOID $TEST_DIR/junk >>$seqres.full 2>&1
-	if [ $? -ne 0 ]; then
-		cat $seqres.full
-		exit 1
-	fi
-}
-
 psize=`$here/src/feature -s`
 bsize=`_min_dio_alignment $TEST_DEV`
 
diff --git a/tests/generic/263 b/tests/generic/263
index 7584bc7..b460c82 100755
--- a/tests/generic/263
+++ b/tests/generic/263
@@ -43,18 +43,6 @@ _require_odirect
 
 rm -f $seqres.full
 
-run_fsx()
-{
-	echo fsx $@ | tee -a $seqres.full
-	args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
-	rm -f $TEST_DIR/junk
-	$here/ltp/fsx $args $FSX_AVOID $TEST_DIR/junk >>$seqres.full 2>&1
-	if [ $? -ne 0 ]; then
-		cat $seqres.full
-		exit 1
-	fi
-}
-
 psize=`$here/src/feature -s`
 bsize=`_min_dio_alignment $TEST_DEV`
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
