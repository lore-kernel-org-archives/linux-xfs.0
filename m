Return-Path: <SRS0=myhp=BJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9D1C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 18:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8494920829
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 18:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X+ZNpjsr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgG3Seo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 14:34:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41788 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Sen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jul 2020 14:34:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UIGujA092305;
        Thu, 30 Jul 2020 18:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=mbvFblHRw7LzhN7MFNZv2uYnbWvgCt/mixrtTr/RGIs=;
 b=X+ZNpjsrb0iFDGSJuQhsf0ifOSUQSsrpPUnLplRR6+QjxyA2roIUSftOtXRsJ4mk40/a
 nNtV/tjj3QefMUyhCTXAV159s9F1jAjOMUCn+7f8g1aUIjhsoa7hen8D99IxYi2ghZR8
 GNCuLUBxAmgeKoYBdwZTwPMz1YR8rawMMUnQx2hftBuW477JiGdKe/HUxAUCyVL6u2om
 cItiSzMGGGgW71QV5tY/bDZANabQ60xivBAee+Kch8B/8GDqj8pBRwlPd8RY5p4GZvR0
 q1W2+tP00r6133WmtrW6NvAvaY986+zF2nUPQLrRcfp1RJWw2kzhcHAqFj7a9Z2Ijakv fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32hu1jnba3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 18:34:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UIIgMD049864;
        Thu, 30 Jul 2020 18:34:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32hu5x8xex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 18:34:40 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06UIYdFr006740;
        Thu, 30 Jul 2020 18:34:39 GMT
Received: from localhost (/10.159.249.46)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jul 2020 11:34:39 -0700
Date:   Thu, 30 Jul 2020 11:34:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: [PATCH] xfs/{050,299}: clear quota warnings in between checks
Message-ID: <20200730183438.GA67809@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=1 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Both of these quota tests contain the output of the xfs_quota repquota
command in the golden output.  Unfortunately, the output was recorded
before quota soft warnings were implemented, which means they'll regress
the output when we make quota warning work.  Fix this by resetting the
warning count to zero before generating output.

While we're at it, use $XFS_QUOTA_PROG instead of xfs_quota.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
note that these changes are necessary because we fixed a longstanding
warning counter bug for 5.9...
---
 tests/xfs/050 |   23 ++++++++++++++++-------
 tests/xfs/299 |   23 ++++++++++++++++-------
 2 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/tests/xfs/050 b/tests/xfs/050
index 788ed7f1..c765f00b 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -61,6 +61,7 @@ _filter_report()
 			$val = $ENV{'NUM_SPACE_FILES'};
 		}
 		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
+	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
 	perl -npe '
 		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
 }
@@ -128,9 +129,11 @@ _exercise()
 
 	echo "Using type=$type id=$id" >>$seqres.full
 
+	$XFS_QUOTA_PROG -x -c "warn -$type 65535 -d" $SCRATCH_DEV
+
 	echo
 	echo "*** report no quota settings" | tee -a $seqres.full
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -139,11 +142,11 @@ _exercise()
 	_file_as_id $SCRATCH_MNT/initme $id $type 1024 0
 	echo "ls -l $SCRATCH_MNT" >>$seqres.full
 	ls -l $SCRATCH_MNT >>$seqres.full
-	xfs_quota -D $tmp.projects -P $temp.projid -x \
+	$XFS_QUOTA_PROG -D $tmp.projects -P $temp.projid -x \
 		-c "limit -$type bsoft=${bsoft} bhard=${bhard} $id" \
 		-c "limit -$type isoft=$isoft ihard=$ihard $id" \
 		$SCRATCH_DEV
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -154,7 +157,8 @@ _exercise()
 	_file_as_id $SCRATCH_MNT/softie3 $id $type 1024 0
 	_file_as_id $SCRATCH_MNT/softie4 $id $type 1024 0
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" $SCRATCH_DEV
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -162,7 +166,9 @@ _exercise()
 	echo "*** push past the soft block limit" | tee -a $seqres.full
 	_file_as_id $SCRATCH_MNT/softie $id $type $bsize 300
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" \
+		-c "warn -b -$type 0 $id" $SCRATCH_DEV
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -174,7 +180,9 @@ _exercise()
 		_file_as_id $SCRATCH_MNT/hard$i $id $type 1024 0
 	done
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -x  -c "warn -b -$type 0 $id" \
+		-c "warn -i -$type 0 $id" $SCRATCH_DEV
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -185,7 +193,8 @@ _exercise()
 	echo "ls -l $SCRATCH_MNT" >>$seqres.full
 	ls -l $SCRATCH_MNT >>$seqres.full
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -x -c "warn -b -$type 0 $id" $SCRATCH_DEV
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_and_check_blks | LC_COLLATE=POSIX sort -ru
 
diff --git a/tests/xfs/299 b/tests/xfs/299
index adcf0e41..574a93b9 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -54,6 +54,7 @@ _filter_report()
 			$val = $ENV{'NUM_SPACE_FILES'};
 		}
 		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
+	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
 	perl -npe '
 		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
 }
@@ -114,9 +115,11 @@ _exercise()
 
 	echo "Using type=$type id=$id" >>$seqres.full
 
+	$XFS_QUOTA_PROG -x -c "warn -$type 65535 -d" $SCRATCH_DEV
+
 	echo
 	echo "*** report no quota settings" | tee -a $seqres.full
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -125,11 +128,11 @@ _exercise()
 	_file_as_id $SCRATCH_MNT/initme $id $type 1024 0
 	echo "ls -l $SCRATCH_MNT" >>$seqres.full
 	ls -l $SCRATCH_MNT >>$seqres.full
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "limit -$type bsoft=${bsoft} bhard=${bhard} $id" \
 		-c "limit -$type isoft=$isoft ihard=$ihard $id" \
 		$SCRATCH_DEV
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -140,7 +143,8 @@ _exercise()
 	_file_as_id $SCRATCH_MNT/softie3 $id $type 1024 0
 	_file_as_id $SCRATCH_MNT/softie4 $id $type 1024 0
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" $SCRATCH_DEV
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -148,7 +152,9 @@ _exercise()
 	echo "*** push past the soft block limit" | tee -a $seqres.full
 	_file_as_id $SCRATCH_MNT/softie $id $type $bsize 200
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" \
+		-c "warn -b -$type 0 $id" $SCRATCH_DEV
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -160,7 +166,9 @@ _exercise()
 		_file_as_id $SCRATCH_MNT/hard$i $id $type 1024 0
 	done
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -x  -c "warn -b -$type 0 $id" \
+		-c "warn -i -$type 0 $id" $SCRATCH_DEV
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_report | LC_COLLATE=POSIX sort -ru
 
@@ -171,7 +179,8 @@ _exercise()
 	echo "ls -l $SCRATCH_MNT" >>$seqres.full
 	ls -l $SCRATCH_MNT >>$seqres.full
 	_qmount
-	xfs_quota -D $tmp.projects -P $tmp.projid -x \
+	$XFS_QUOTA_PROG -x -c "warn -b -$type 0 $id" $SCRATCH_DEV
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "repquota -birnN -$type" $SCRATCH_DEV |
 		_filter_and_check_blks | LC_COLLATE=POSIX sort -ru
 
