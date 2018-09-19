Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33998 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731485AbeISRg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 13:36:58 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8JBsKmb134884
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 07:59:21 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mkk577naw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 07:59:19 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 19 Sep 2018 07:59:19 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V4 10/20] Fix xfs/299 to work with 64k block size
Date: Wed, 19 Sep 2018 17:30:43 +0530
In-Reply-To: <20180919120053.7339-1-chandan@linux.vnet.ibm.com>
References: <20180919120053.7339-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180919120053.7339-11-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

This commit changes the test to calculate quota limits based on the
block size of the underlying filesystem. Also, the sizes of the test
files are now made to be a multiple of the filesystem block size.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/299     | 27 +++++++++++++++----------
 tests/xfs/299.out | 60 +++++++++++++++++++++++++++----------------------------
 2 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/tests/xfs/299 b/tests/xfs/299
index bbf7f61..eed304c 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -41,11 +41,6 @@ _require_xfs_quota
 _require_xfs_mkfs_crc
 _require_xfs_crc
 
-bsoft=100
-bhard=500
-isoft=4
-ihard=10
-
 _filter_report()
 {
 	tr -s '[:space:]' | \
@@ -58,7 +53,9 @@ _filter_report()
 		if ($ENV{'LARGE_SCRATCH_DEV'}) {
 			$val = $ENV{'NUM_SPACE_FILES'};
 		}
-		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g'
+		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
+	perl -npe '
+		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
 }
 
 # The actual point at which limit enforcement takes place for the
@@ -73,9 +70,10 @@ _filter_and_check_blks()
 		if (/^\#'$id'\s+(\d+)/ && '$enforce') {
 			$maximum = '$bhard';
 			$minimum = '$bhard' * 85/100;
-			if (($1 < $minimum || $1 > $maximum) && '$noextsz') {
+			$used = $1 * 1024;
+			if (($used < $minimum || $used > $maximum) && '$noextsz') {
 				printf(" URK %d: %d is out of range! [%d,%d]\n",
-					'$id', $1, $minimum, $maximum);
+					'$id', $used, $minimum, $maximum);
 			}
 			s/^(\#'$id'\s+)(\d+)/\1 =OK=/g;
 		}
@@ -128,7 +126,7 @@ _exercise()
 	echo "ls -l $SCRATCH_MNT" >>$seqres.full
 	ls -l $SCRATCH_MNT >>$seqres.full
 	xfs_quota -D $tmp.projects -P $tmp.projid -x \
-		-c "limit -$type bsoft=${bsoft}k bhard=${bhard}k $id" \
+		-c "limit -$type bsoft=${bsoft} bhard=${bhard} $id" \
 		-c "limit -$type isoft=$isoft ihard=$ihard $id" \
 		$SCRATCH_DEV
 	xfs_quota -D $tmp.projects -P $tmp.projid -x \
@@ -148,7 +146,7 @@ _exercise()
 
 	echo
 	echo "*** push past the soft block limit" | tee -a $seqres.full
-	_file_as_id $SCRATCH_MNT/softie $id $type 1024 140
+	_file_as_id $SCRATCH_MNT/softie $id $type $bsize 35
 	_qmount
 	xfs_quota -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
@@ -169,7 +167,7 @@ _exercise()
 	echo
 	# Note: for quota accounting (not enforcement), EDQUOT is not expected
 	echo "*** push past the hard block limit (expect EDQUOT)" | tee -a $seqres.full
-	_file_as_id $SCRATCH_MNT/softie $id $type 1024 540
+	_file_as_id $SCRATCH_MNT/softie $id $type $bsize 135
 	echo "ls -l $SCRATCH_MNT" >>$seqres.full
 	ls -l $SCRATCH_MNT >>$seqres.full
 	_qmount
@@ -204,6 +202,13 @@ echo "*** user, group, and project"
 _qmount_option "uquota,gquota,pquota"
 _qmount
 
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+bsoft=$(( 25 * $bsize ))
+bhard=$(( 125 * $bsize ))
+isoft=4
+ihard=10
+
 # non-root users need to be able to write to this filesystem
 chmod 777 $SCRATCH_MNT
 
diff --git a/tests/xfs/299.out b/tests/xfs/299.out
index f1a1e48..93e89a9 100644
--- a/tests/xfs/299.out
+++ b/tests/xfs/299.out
@@ -12,23 +12,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 25 125 0 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
 
 
 *** report no quota settings
@@ -36,23 +36,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 25 125 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 
 *** report no quota settings
@@ -60,23 +60,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 25 125 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** unmount
 meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
@@ -92,23 +92,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 135 25 125 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 
 *** report no quota settings
@@ -116,23 +116,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 135 25 125 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 
 *** report no quota settings
@@ -140,22 +140,22 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 25 125 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 35 25 125 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 135 25 125 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** unmount
-- 
2.9.5
