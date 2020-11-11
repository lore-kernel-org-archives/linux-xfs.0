Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15A1C5517A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D252221E9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T4WWrlZi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbgKKAof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:44:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731713AbgKKAof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:44:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0Xm4j110545;
        Wed, 11 Nov 2020 00:44:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uhPgof/e9B7qGxLr1P/KJ+Ja5erJrvSl03qEyIlJQ8s=;
 b=T4WWrlZiy2cKNtofel7yKTI0hmdirJqKSv0KhXlLqfFLkcY9swURJYwf5VJysy8WD885
 4KA5v+jNEKdR13UuRsoyMF9Pft/0NxoUSRDRfhQkjcK1fRio/oa0O9n2djObQxiL0SMo
 sgU8mL6cALI5+gjgap7rAJ51FzzghkexF9C5q6U/Ci5nWa7NRt2I/tiD+ZPsE+OoZvi5
 zBTWXrx8GdA8onQEELEuU0aWF5S43kwxGvL7yB5bN24pdk/z/scLOtfRzPzMl8SvP2fH
 JSiIg4kkUdfRKQDfeJEXB0oBzyyV68Wp6yMz/ZqAuwSDnRIjFA9+nk35e+l98H7RXVKU AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34nkhkxnnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:44:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0V65b027434;
        Wed, 11 Nov 2020 00:44:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp7kr2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:44:30 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB0iTFU014020;
        Wed, 11 Nov 2020 00:44:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:44:29 -0800
Subject: [PATCH 6/7] xfs: test quota softlimit warning functionality
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:44:28 -0800
Message-ID: <160505546820.1388823.9325928100187068577.stgit@magnolia>
In-Reply-To: <160505542802.1388823.10368384826199448253.stgit@magnolia>
References: <160505542802.1388823.10368384826199448253.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that quota softlimits work, which is to say that one can
exceed the softlimit up to warnlimit times before it starts enforcing
that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/915     |  176 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/915.out |  151 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |    1 
 3 files changed, 328 insertions(+)
 create mode 100755 tests/xfs/915
 create mode 100644 tests/xfs/915.out


diff --git a/tests/xfs/915 b/tests/xfs/915
new file mode 100755
index 00000000..0a37a1b5
--- /dev/null
+++ b/tests/xfs/915
@@ -0,0 +1,176 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 915
+#
+# Check that quota softlimit warnings work the way they should.  This means
+# that we can disobey the softlimit up to warnlimit times before it turns into
+# hard(er) enforcement.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_quota
+_require_scratch
+
+rm -f $seqres.full
+
+filter_report()
+{
+	tr -s '[:space:]' | \
+	perl -npe '
+		s/^\#'$id' /[NAME] /g;
+		s/^\#0 \d+ /[ROOT] 0 /g;
+		s/6 days/7 days/g' |
+	perl -npe '
+		$val = 0;
+		if ($ENV{'LARGE_SCRATCH_DEV'}) {
+			$val = $ENV{'NUM_SPACE_FILES'};
+		}
+		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
+	perl -npe '
+		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
+}
+
+qsetup()
+{
+	opt=$1
+	enforce=0
+	if [ $opt = "u" -o $opt = "uno" ]; then
+		type=u
+		eval `_choose_uid`
+	elif [ $opt = "g" -o $opt = "gno" ]; then
+		type=g
+		eval `_choose_gid`
+	elif [ $opt = "p" -o $opt = "pno" ]; then
+		type=p
+		eval `_choose_prid`
+	fi
+	[ $opt = "u" -o $opt = "g" -o $opt = "p" ] && enforce=1
+
+	echo "Using type=$type id=$id" >> $seqres.full
+}
+
+exercise() {
+	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+	cat $tmp.mkfs >>$seqres.full
+
+	# keep the blocksize and data size for dd later
+	. $tmp.mkfs
+
+	_qmount
+
+	qsetup $1
+
+	echo "Using type=$type id=$id" >>$seqres.full
+
+	echo
+	echo "*** report initial settings" | tee -a $seqres.full
+	$XFS_QUOTA_PROG -x \
+		-c "limit -$type isoft=3 ihard=500000 $id" \
+		-c "warn -$type -i -d 13" \
+		$SCRATCH_DEV
+	$XFS_QUOTA_PROG -x \
+		-c "state -$type" >> $seqres.full
+	$XFS_QUOTA_PROG -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		filter_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** push past the soft inode limit" | tee -a $seqres.full
+	_file_as_id $SCRATCH_MNT/softok1 $id $type $bsize 0
+	_file_as_id $SCRATCH_MNT/softok2 $id $type $bsize 0
+	_file_as_id $SCRATCH_MNT/softok3 $id $type $bsize 0
+	_file_as_id $SCRATCH_MNT/softwarn1 $id $type $bsize 0
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		filter_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** push further past the soft inode limit" | tee -a $seqres.full
+	for warn_nr in $(seq 2 5); do
+		_file_as_id $SCRATCH_MNT/softwarn$warn_nr $id $type $bsize 0
+	done
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		filter_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** push past the soft inode warning limit" | tee -a $seqres.full
+	for warn_nr in $(seq 6 15); do
+		_file_as_id $SCRATCH_MNT/softwarn$warn_nr $id $type $bsize 0
+	done
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		filter_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** unmount"
+	_scratch_unmount
+}
+
+_scratch_mkfs > $seqres.full
+_scratch_mount >> $seqres.full
+
+chmod a+rwx $SCRATCH_MNT $seqres.full	# arbitrary users will write here
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+_scratch_unmount
+
+cat >$tmp.projects <<EOF
+1:$SCRATCH_MNT
+EOF
+
+cat >$tmp.projid <<EOF
+root:0
+scratch:1
+EOF
+
+projid_file="$tmp.projid"
+
+echo "*** user"
+_qmount_option "uquota"
+exercise u
+
+echo "*** group"
+_qmount_option "gquota"
+exercise g
+
+echo "*** uqnoenforce"
+_qmount_option "uqnoenforce"
+exercise uno
+
+echo "*** gqnoenforce"
+_qmount_option "gqnoenforce"
+exercise gno
+
+echo "*** pquota"
+_qmount_option "pquota"
+exercise p
+
+echo "*** pqnoenforce"
+_qmount_option "pqnoenforce"
+exercise pno
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/915.out b/tests/xfs/915.out
new file mode 100644
index 00000000..c3bb855e
--- /dev/null
+++ b/tests/xfs/915.out
@@ -0,0 +1,151 @@
+QA output created by 915
+*** user
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 4 3 500000 01 [7 days] 0 0 0 00 [--------]
+
+*** push further past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 8 3 500000 05 [7 days] 0 0 0 00 [--------]
+
+*** push past the soft inode warning limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 16 3 500000 13 [7 days] 0 0 0 00 [--------]
+
+*** unmount
+*** group
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 4 3 500000 01 [7 days] 0 0 0 00 [--------]
+
+*** push further past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 8 3 500000 05 [7 days] 0 0 0 00 [--------]
+
+*** push past the soft inode warning limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 16 3 500000 13 [7 days] 0 0 0 00 [--------]
+
+*** unmount
+*** uqnoenforce
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 4 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push further past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 8 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode warning limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 18 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** unmount
+*** gqnoenforce
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 4 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push further past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 8 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode warning limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 18 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** unmount
+*** pquota
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 4 3 500000 02 [7 days] 0 0 0 00 [--------]
+
+*** push further past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 8 3 500000 06 [7 days] 0 0 0 00 [--------]
+
+*** push past the soft inode warning limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 15 3 500000 13 [7 days] 0 0 0 00 [--------]
+
+*** unmount
+*** pqnoenforce
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+
+*** report initial settings
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 4 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push further past the soft inode limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 8 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** push past the soft inode warning limit
+[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
+[NAME] 0 0 0 00 [--------] 18 3 500000 00 [--------] 0 0 0 00 [--------]
+
+*** unmount
diff --git a/tests/xfs/group b/tests/xfs/group
index 74f0d37c..17f6bc6c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -524,3 +524,4 @@
 760 auto quick rw collapse punch insert zero prealloc
 761 auto quick realtime
 763 auto quick rw realtime
+915 auto quick quota

