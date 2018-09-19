Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731450AbeISRgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 13:36:39 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8JBx2s2051770
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 07:59:02 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2mkkxjdby3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 07:59:00 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 19 Sep 2018 07:58:55 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V4 03/20] Fix xfs/050 to work with 64k block size
Date: Wed, 19 Sep 2018 17:30:36 +0530
In-Reply-To: <20180919120053.7339-1-chandan@linux.vnet.ibm.com>
References: <20180919120053.7339-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180919120053.7339-4-chandan@linux.vnet.ibm.com>
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
 tests/xfs/050     | 24 ++++++++++++++--------
 tests/xfs/050.out | 60 +++++++++++++++++++++++++++----------------------------
 2 files changed, 46 insertions(+), 38 deletions(-)

diff --git a/tests/xfs/050 b/tests/xfs/050
index 8569c2c..788ed7f 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -38,8 +38,13 @@ chmod a+rwx $seqres.full	# arbitrary users will write here
 _require_scratch
 _require_xfs_quota
 
-bsoft=100
-bhard=500
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+bsoft=$(( 200 * $bsize ))
+bhard=$(( 1000 * $bsize ))
 isoft=4
 ihard=10
 
@@ -55,7 +60,9 @@ _filter_report()
 		if ($ENV{'LARGE_SCRATCH_DEV'}) {
 			$val = $ENV{'NUM_SPACE_FILES'};
 		}
-		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g'
+		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
+	perl -npe '
+		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
 }
 
 # The actual point at which limit enforcement takes place for the
@@ -70,9 +77,10 @@ _filter_and_check_blks()
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
@@ -132,7 +140,7 @@ _exercise()
 	echo "ls -l $SCRATCH_MNT" >>$seqres.full
 	ls -l $SCRATCH_MNT >>$seqres.full
 	xfs_quota -D $tmp.projects -P $temp.projid -x \
-		-c "limit -$type bsoft=${bsoft}k bhard=${bhard}k $id" \
+		-c "limit -$type bsoft=${bsoft} bhard=${bhard} $id" \
 		-c "limit -$type isoft=$isoft ihard=$ihard $id" \
 		$SCRATCH_DEV
 	xfs_quota -D $tmp.projects -P $tmp.projid -x \
@@ -152,7 +160,7 @@ _exercise()
 
 	echo
 	echo "*** push past the soft block limit" | tee -a $seqres.full
-	_file_as_id $SCRATCH_MNT/softie $id $type 1024 140
+	_file_as_id $SCRATCH_MNT/softie $id $type $bsize 300
 	_qmount
 	xfs_quota -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
@@ -173,7 +181,7 @@ _exercise()
 	echo
 	# Note: for quota accounting (not enforcement), EDQUOT is not expected
 	echo "*** push past the hard block limit (expect EDQUOT)" | tee -a $seqres.full
-	_file_as_id $SCRATCH_MNT/softie $id $type 1024 540
+	_file_as_id $SCRATCH_MNT/softie $id $type $bsize 1200
 	echo "ls -l $SCRATCH_MNT" >>$seqres.full
 	ls -l $SCRATCH_MNT >>$seqres.full
 	_qmount
diff --git a/tests/xfs/050.out b/tests/xfs/050.out
index ff9eb1c..725cd79 100644
--- a/tests/xfs/050.out
+++ b/tests/xfs/050.out
@@ -12,23 +12,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 200 1000 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** unmount
 *** group
@@ -44,23 +44,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 200 1000 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** unmount
 *** uqnoenforce
@@ -76,23 +76,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 1200 200 1000 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** unmount
 *** gqnoenforce
@@ -108,23 +108,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 1200 200 1000 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** unmount
 *** pquota
@@ -140,23 +140,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 200 1000 0 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
 
 *** unmount
 *** pqnoenforce
@@ -172,22 +172,22 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 
 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 200 1000 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
 
 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 300 200 1000 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 1200 200 1000 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
 
 *** unmount
-- 
2.9.5
