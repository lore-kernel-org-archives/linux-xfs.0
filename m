Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80452C388F9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B10E21D24
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iVlQ60Iv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501971AbgJ0TDU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:03:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56606 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444462AbgJ0TDU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:03:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIthIr022170;
        Tue, 27 Oct 2020 19:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uhPgof/e9B7qGxLr1P/KJ+Ja5erJrvSl03qEyIlJQ8s=;
 b=iVlQ60Iv7j3LJ9DLO27SN2jWSEI7r/zOmtsyVdt6WmCTn7PpuUUuP9pFkW+Z1bqY1WLl
 UFXdChnm5sbM6GiWSeMFRneEGz6PJS95Ledt4NWRWq2aY9CywdoD42FyelsjRkt6DvRq
 Hf2jdF+Tr8FmnlTO3PTTe3EKJMvMZWCi1ZX5rGKx72u94RG30qmqCljeV8L+Cq1HMbGP
 0C8nV0eWc4NMAG9XmtJh8Wl1sPbdWofsefyxqPdE55ft7bPT5SzufTf6PleJ96ZmC+gj
 Pjadv3oyADCYa/y1lPu96ooROdTPcsjkbYzxXUVLZ1nBX896bMzJF2Qa9jl6PUFpzwK1 sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9sav09x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:03:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItJsv019768;
        Tue, 27 Oct 2020 19:03:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6wbnaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:03:15 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ3EDO001593;
        Tue, 27 Oct 2020 19:03:15 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:03:10 -0700
Subject: [PATCH 6/7] xfs: test quota softlimit warning functionality
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:03:09 -0700
Message-ID: <160382538988.1203387.8122059769450904973.stgit@magnolia>
In-Reply-To: <160382535113.1203387.16777876271740782481.stgit@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
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

