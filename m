Return-Path: <SRS0=9vdY=DY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC36DC433E7
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Oct 2020 21:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE07207BC
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Oct 2020 21:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NBAkFpVd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439598AbgJQVwF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Oct 2020 17:52:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439548AbgJQVwF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Oct 2020 17:52:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09HLnwZe099814;
        Sat, 17 Oct 2020 21:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FwM+Qt+/lhHYwGB/kuIUaTwkG4bQqlbyDd90Yy+ejY4=;
 b=NBAkFpVdU9/J/gXecZDIplW43iHTFtY7eUz/KO/cSOSaRPnY5/tiJilxJzZRlO/a5Man
 DNU3dqWnZNItquz/jpcr9TWbIqTcYnjA4UjvBEm60nZHUN519M/RJ3WXtazluejD66Co
 TDtQN0cvzeopCzzT7bRLO+UIYMne2EquQL58lo+Qnqx4LYhpi7BE+7HECWvKokuv/wrj
 5IITU5+ZQTJr6f8wNM1+bSfV7L4ZZ0twvqxN/d2xrU3ExWh6ENAB8Z/R2dIOt8JspsYf
 qSdh/DQuxRNeQ24dUJVD90/AsastguwvpMvw3yUz7SJR3GTeIUfr4er+d39HZWw1c1qY aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 347rjkhb3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 17 Oct 2020 21:52:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09HLokHr060852;
        Sat, 17 Oct 2020 21:52:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 347nqs63mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Oct 2020 21:51:59 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09HLpxrn027311;
        Sat, 17 Oct 2020 21:51:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 17 Oct 2020 14:51:58 -0700
Date:   Sat, 17 Oct 2020 14:51:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfstest: test fallocate ops when rt extent size is and isn't
 a power of 2
Message-ID: <20201017215158.GH9832@magnolia>
References: <20201017215011.GG9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201017215011.GG9832@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9777 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010170159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9777 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=1 clxscore=1015 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010170159
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that fallocate works when the rt extent size is and isn't a
power of 2.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/763     |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/763.out |   55 +++++++++++++++++++
 tests/xfs/group   |    1 
 3 files changed, 208 insertions(+)
 create mode 100755 tests/xfs/763
 create mode 100644 tests/xfs/763.out

diff --git a/tests/xfs/763 b/tests/xfs/763
new file mode 100755
index 00000000..a4351bd9
--- /dev/null
+++ b/tests/xfs/763
@@ -0,0 +1,152 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 763
+#
+# Make sure that regular fallocate functions work ok when the realtime extent
+# size is and isn't a power of 2.
+#
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
+	_scratch_unmount >> $seqres.full 2>&1
+	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
+	rm -f $tmp.* $TEST_DIR/$seq.rtvol
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "fzero"
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "finsert"
+# Note that we don't _require_realtime because we synthesize a rt volume
+# below.  This also means we cannot run the post-test check.
+_require_scratch_nocheck
+
+log() {
+	echo "$@" | tee -a $seqres.full
+}
+
+mk_file() {
+	local file="$1"
+	local rextsize="$2"
+
+	$XFS_IO_PROG -f \
+		-c "pwrite -S 0x57 -b $rextsize 0 $rextsize" \
+		-c "pwrite -S 0x58 -b $rextsize $rextsize $rextsize" \
+		-c "pwrite -S 0x59 -b $rextsize $((rextsize * 2)) $rextsize" \
+		-c fsync \
+		"$file" >> $seqres.full
+}
+
+check_file() {
+	filefrag -v "$1" >> $seqres.full
+	od -tx1 -Ad -c "$1" >> $seqres.full
+	md5sum "$1" | _filter_scratch | tee -a $seqres.full
+}
+
+test_ops() {
+	local rextsize=$1
+	local unaligned_sz=65536
+	local sz=$((rextsize * 3))
+
+	log "Format rtextsize=$rextsize"
+	_scratch_unmount
+	_scratch_mkfs -r extsize=$rextsize >> $seqres.full
+	_scratch_mount || \
+		_notrun "Could not mount rextsize=$rextsize with synthetic rt volume"
+
+	# Force all files to be realtime files
+	$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+
+	log "Test regular write, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/write $rextsize
+	check_file $SCRATCH_MNT/write
+
+	log "Test aligned falloc, rextsize=$rextsize"
+	$XFS_IO_PROG -f -c "falloc 0 $sz" $SCRATCH_MNT/falloc >> $seqres.full
+	check_file $SCRATCH_MNT/falloc
+
+	log "Test aligned fcollapse, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/collapse $rextsize
+	$XFS_IO_PROG -f -c "fcollapse $rextsize $rextsize" $SCRATCH_MNT/collapse >> $seqres.full
+	check_file $SCRATCH_MNT/collapse
+
+	log "Test aligned finsert, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/insert $rextsize
+	$XFS_IO_PROG -f -c "finsert $rextsize $rextsize" $SCRATCH_MNT/insert >> $seqres.full
+	check_file $SCRATCH_MNT/insert
+
+	log "Test aligned fzero, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/zero $rextsize
+	$XFS_IO_PROG -f -c "fzero $rextsize $rextsize" $SCRATCH_MNT/zero >> $seqres.full
+	check_file $SCRATCH_MNT/zero
+
+	log "Test aligned fpunch, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/punch $rextsize
+	$XFS_IO_PROG -f -c "fpunch $rextsize $rextsize" $SCRATCH_MNT/punch >> $seqres.full
+	check_file $SCRATCH_MNT/punch
+
+	log "Test unaligned falloc, rextsize=$rextsize"
+	$XFS_IO_PROG -f -c "falloc $unaligned_sz $unaligned_sz" $SCRATCH_MNT/ufalloc >> $seqres.full
+	check_file $SCRATCH_MNT/ufalloc
+
+	log "Test unaligned fcollapse, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/ucollapse $rextsize
+	$XFS_IO_PROG -f -c "fcollapse $unaligned_sz $unaligned_sz" $SCRATCH_MNT/ucollapse >> $seqres.full
+	check_file $SCRATCH_MNT/ucollapse
+
+	log "Test unaligned finsert, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/uinsert $rextsize
+	$XFS_IO_PROG -f -c "finsert $unaligned_sz $unaligned_sz" $SCRATCH_MNT/uinsert >> $seqres.full
+	check_file $SCRATCH_MNT/uinsert
+
+	log "Test unaligned fzero, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/uzero $rextsize
+	$XFS_IO_PROG -f -c "fzero $unaligned_sz $unaligned_sz" $SCRATCH_MNT/uzero >> $seqres.full
+	check_file $SCRATCH_MNT/uzero
+
+	log "Test unaligned fpunch, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/upunch $rextsize
+	$XFS_IO_PROG -f -c "fpunch $unaligned_sz $unaligned_sz" $SCRATCH_MNT/upunch >> $seqres.full
+	check_file $SCRATCH_MNT/upunch
+
+	log "Check everything, rextsize=$rextsize"
+	_check_scratch_fs
+}
+
+echo "Create fake rt volume"
+truncate -s 400m $TEST_DIR/$seq.rtvol
+rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
+
+echo "Make sure synth rt volume works"
+export USE_EXTERNAL=yes
+export SCRATCH_RTDEV=$rtdev
+_scratch_mkfs > $seqres.full
+_scratch_mount || \
+	_notrun "Could not mount with synthetic rt volume"
+
+# power of two
+test_ops 262144
+
+# not a power of two
+test_ops 327680
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/763.out b/tests/xfs/763.out
new file mode 100644
index 00000000..b6633fd2
--- /dev/null
+++ b/tests/xfs/763.out
@@ -0,0 +1,55 @@
+QA output created by 763
+Create fake rt volume
+Make sure synth rt volume works
+Format rtextsize=262144
+Test regular write, rextsize=262144
+2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/write
+Test aligned falloc, rextsize=262144
+cb18a5d28e77522dfec6a6255bc3847e  SCRATCH_MNT/falloc
+Test aligned fcollapse, rextsize=262144
+2e94746ab733025c21a9cae7d19c18d0  SCRATCH_MNT/collapse
+Test aligned finsert, rextsize=262144
+24e228d3d5f68b612eceec47f8416a7d  SCRATCH_MNT/insert
+Test aligned fzero, rextsize=262144
+ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/zero
+Test aligned fpunch, rextsize=262144
+ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/punch
+Test unaligned falloc, rextsize=262144
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/ufalloc
+Test unaligned fcollapse, rextsize=262144
+fallocate: Invalid argument
+2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/ucollapse
+Test unaligned finsert, rextsize=262144
+fallocate: Invalid argument
+2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/uinsert
+Test unaligned fzero, rextsize=262144
+8d87ed880ce111829bab56322a26bad0  SCRATCH_MNT/uzero
+Test unaligned fpunch, rextsize=262144
+8d87ed880ce111829bab56322a26bad0  SCRATCH_MNT/upunch
+Check everything, rextsize=262144
+Format rtextsize=327680
+Test regular write, rextsize=327680
+dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/write
+Test aligned falloc, rextsize=327680
+63a6c5a8b8da92e30cd0ef23c56d4f06  SCRATCH_MNT/falloc
+Test aligned fcollapse, rextsize=327680
+8bdd728a7a4af4ac18bbcbe39dea14d5  SCRATCH_MNT/collapse
+Test aligned finsert, rextsize=327680
+2b178c860f7bef4c0e55399be5172c5e  SCRATCH_MNT/insert
+Test aligned fzero, rextsize=327680
+350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/zero
+Test aligned fpunch, rextsize=327680
+350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/punch
+Test unaligned falloc, rextsize=327680
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/ufalloc
+Test unaligned fcollapse, rextsize=327680
+fallocate: Invalid argument
+dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/ucollapse
+Test unaligned finsert, rextsize=327680
+fallocate: Invalid argument
+dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/uinsert
+Test unaligned fzero, rextsize=327680
+7b728ff6048f52fa533fd902995da41b  SCRATCH_MNT/uzero
+Test unaligned fpunch, rextsize=327680
+7b728ff6048f52fa533fd902995da41b  SCRATCH_MNT/upunch
+Check everything, rextsize=327680
diff --git a/tests/xfs/group b/tests/xfs/group
index 61d9e82b..2b3159ec 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -543,6 +543,7 @@
 760 auto quick rw collapse punch insert zero prealloc
 761 auto quick realtime
 762 auto quick rw scrub realtime
+763 auto quick rw realtime
 908 auto quick bigtime
 909 auto quick bigtime quota
 910 auto quick inobtcount
