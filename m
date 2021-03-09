Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDD1C43381
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBABC6529E
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCIEkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:40:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:32936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhCIEkh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE12865275;
        Tue,  9 Mar 2021 04:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264837;
        bh=kxWH7F4brECXLYtjcDpMuJt2/GCOUol5Wd8naC3DfBc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dCst7V+c+g4VD52VSzim5IFGf32Sa9HFnGbzzJjbiUe4DvMzdfRSk0x/344f2LlNt
         xreqIBroq8hhl4fZ0x/pYm1tAhbNDPUZ/BztYjdlcxTVz0QUV5Spk8d37hjis0Hzs4
         E6W4YAQ0RTZs5wbJe5zVI74SCG+6vGZIe+Kbe3Lv9v+Q+R+vbaSP5z5GckNhUnqEDM
         ZMwnsNY2o43x4PfrQKzM3zCYqsC3Ep/r7lDQ7jVq3ACPLZkAKe97v300kUVnJJPb4G
         rqjuIokEA63MGD/Ta/DxcYl5F9qrlBTEta8yw/D9cIFY1V0GBJmuYkc78AFJ9e11dg
         yh8iOOgX0Rd5A==
Subject: [PATCH 06/10] xfs: test quota softlimit warning functionality
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:36 -0800
Message-ID: <161526483668.1214319.17667836667890283825.stgit@magnolia>
In-Reply-To: <161526480371.1214319.3263690953532787783.stgit@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that quota softlimits work, which is to say that one can
exceed the softlimit up to warnlimit times before it starts enforcing
that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/915     |  162 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/915.out |  151 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |    1 
 3 files changed, 314 insertions(+)
 create mode 100755 tests/xfs/915
 create mode 100644 tests/xfs/915.out


diff --git a/tests/xfs/915 b/tests/xfs/915
new file mode 100755
index 00000000..a2cdbbb7
--- /dev/null
+++ b/tests/xfs/915
@@ -0,0 +1,162 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 915
+#
+# Check that quota softlimit warnings work the way they should.  This means
+# that we can disobey the softlimit up to warnlimit times before it turns into
+# hard(er) enforcement.  This is a functional test for quota warnings, but
+# since the functionality has been broken for decades, this is also a
+# regression test for commit 4b8628d57b72 ("xfs: actually bump warning counts
+# when we send warnings").
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
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** push past the soft inode limit" | tee -a $seqres.full
+	_file_as_id $SCRATCH_MNT/softok1 $id $type $bsize 0
+	_file_as_id $SCRATCH_MNT/softok2 $id $type $bsize 0
+	_file_as_id $SCRATCH_MNT/softok3 $id $type $bsize 0
+	_file_as_id $SCRATCH_MNT/softwarn1 $id $type $bsize 0
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** push further past the soft inode limit" | tee -a $seqres.full
+	for warn_nr in $(seq 2 5); do
+		_file_as_id $SCRATCH_MNT/softwarn$warn_nr $id $type $bsize 0
+	done
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
+
+	echo
+	echo "*** push past the soft inode warning limit" | tee -a $seqres.full
+	for warn_nr in $(seq 6 15); do
+		_file_as_id $SCRATCH_MNT/softwarn$warn_nr $id $type $bsize 0
+	done
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -birnN -$type" $SCRATCH_DEV |
+		_filter_quota_report | LC_COLLATE=POSIX sort -ru
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
index 87badd56..d7aafc94 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -505,3 +505,4 @@
 760 auto quick rw collapse punch insert zero prealloc
 761 auto quick realtime
 763 auto quick rw realtime
+915 auto quick quota

