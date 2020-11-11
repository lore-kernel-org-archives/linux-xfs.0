Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC53CC388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA5E21D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w/2b7Njl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbgKKAoW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:44:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48132 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731713AbgKKAoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:44:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0XmNV110546;
        Wed, 11 Nov 2020 00:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GMDBIQZgzTV4yfSlXmY2gi1N9EFGXPHdydeM8RSOY7E=;
 b=w/2b7NjlbwkXMmmkdNZGOODwozsyvQrsQlckD5uOeqogZp0jxu4On/nZX/RPycewK7X/
 uYkl5orh/jks4io2ztG9Q/jGBi/+uW15TVnE6V/fad5jffhbDEBwXJJEXUAk8Q97dxd8
 3P+tUn665UFhFxpUB1WM2zryOdhX/j56LJ78ZMcyko5/CUSOTkaAWS18JSptWqTBrKDI
 jJWfODeTtGM1I6G9u7J+htBIjXGJ8fm8/kh/A87lu6cIWIEQ+8XN7OvQOsY2DUdCt2Qd
 TmEe+8WLh/NQkzeChsgB3gosnuRVNLf5bmNSc++6C3KpWVjZmbAx8NiRC1y/xKY8XzZI Nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34nkhkxnnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:44:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0V7pT027737;
        Wed, 11 Nov 2020 00:44:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34qgp7kqyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:44:17 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB0iG7l029148;
        Wed, 11 Nov 2020 00:44:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:44:16 -0800
Subject: [PATCH 4/7] xfs: test rtalloc alignment and math errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:44:15 -0800
Message-ID: <160505545554.1388823.7888218443336440186.stgit@magnolia>
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

Add a couple of regression tests for "xfs: make sure the rt allocator
doesn't run off the end" and "xfs: ensure that fpunch, fcollapse, and
finsert operations are aligned to rt extent size".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/759     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/759.out |    2 +
 tests/xfs/760     |   66 +++++++++++++++++++++++++++++++++++
 tests/xfs/760.out |    9 +++++
 tests/xfs/group   |    2 +
 5 files changed, 178 insertions(+)
 create mode 100755 tests/xfs/759
 create mode 100644 tests/xfs/759.out
 create mode 100755 tests/xfs/760
 create mode 100644 tests/xfs/760.out


diff --git a/tests/xfs/759 b/tests/xfs/759
new file mode 100755
index 00000000..00573786
--- /dev/null
+++ b/tests/xfs/759
@@ -0,0 +1,99 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 759
+#
+# This is a regression test for an overflow error in the _near realtime
+# allocator.  If the rt bitmap ends exactly at the end of a block and the
+# number of rt extents is large enough to allow an allocation request larger
+# than the maximum extent size, it's possible that during a large allocation
+# request, the allocator will fail to constrain maxlen on the second run
+# through the loop, and the rt bitmap range check will run right off the end of
+# the rtbitmap file.  When this happens, xfs triggers a verifier error and
+# returns EFSCORRUPTED.
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
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_realtime
+_require_test_program "punch-alternating"
+
+rm -f $seqres.full
+
+# Format filesystem to get the block size
+_scratch_mkfs > $seqres.full
+_scratch_mount >> $seqres.full
+
+blksz=$(_get_block_size $SCRATCH_MNT)
+rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+rextblks=$((rextsize / blksz))
+
+echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
+
+_scratch_unmount
+
+# Format filesystem with a realtime volume whose size fits the following:
+# 1. Longer than (XFS MAXEXTLEN * blocksize) bytes.
+# 2. Exactly a multiple of (NBBY * blksz * rextsize) bytes.
+
+rtsize1=$((2097151 * blksz))
+rtsize2=$((8 * blksz * rextsize))
+rtsize=$(( $(blockdev --getsz $SCRATCH_RTDEV) * 512 ))
+
+echo "rtsize1 $rtsize1 rtsize2 $rtsize2 rtsize $rtsize" >> $seqres.full
+
+test $rtsize -gt $rtsize1 || \
+	_notrun "scratch rt device too small, need $rtsize1 bytes"
+test $rtsize -gt $rtsize2 || \
+	_notrun "scratch rt device too small, need $rtsize2 bytes"
+
+rtsize=$((rtsize - (rtsize % rtsize2)))
+
+echo "rt size will be $rtsize" >> $seqres.full
+
+_scratch_mkfs -r size=$rtsize >> $seqres.full
+_scratch_mount >> $seqres.full
+
+# Make sure the root directory has rtinherit set so our test file will too
+$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+
+# Allocate some stuff at the start, to force the first falloc of the ouch file
+# to happen somewhere in the middle of the rt volume
+$XFS_IO_PROG -f -c 'falloc 0 64m' "$SCRATCH_MNT/b"
+$here/src/punch-alternating -i $((rextblks * 2)) -s $((rextblks)) "$SCRATCH_MNT/b"
+
+avail="$(df -P "$SCRATCH_MNT" | awk 'END {print $4}')"1
+toobig="$((avail * 2))"
+
+# falloc the ouch file in the middle of the rt extent to exercise the near
+# allocator in the last step.
+$XFS_IO_PROG -f -c 'falloc 0 1g' "$SCRATCH_MNT/ouch"
+
+# Try to get the near allocator to overflow on an allocation that matches
+# exactly one of the rtsummary size levels.  This should return ENOSPC and
+# not EFSCORRUPTED.
+$XFS_IO_PROG -f -c "falloc 0 ${toobig}k" "$SCRATCH_MNT/ouch"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/759.out b/tests/xfs/759.out
new file mode 100644
index 00000000..df693d50
--- /dev/null
+++ b/tests/xfs/759.out
@@ -0,0 +1,2 @@
+QA output created by 759
+fallocate: No space left on device
diff --git a/tests/xfs/760 b/tests/xfs/760
new file mode 100755
index 00000000..7baa346c
--- /dev/null
+++ b/tests/xfs/760
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 760
+#
+# Make sure we validate realtime extent size alignment for fallocate modes.
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
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_realtime
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "funshare"
+_require_xfs_io_command "fzero"
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+# Format filesystem with a 256k realtime extent size
+_scratch_mkfs -r extsize=256k > $seqres.full
+_scratch_mount >> $seqres.full
+
+blksz=$(_get_block_size $SCRATCH_MNT)
+rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+rextblks=$((rextsize / blksz))
+
+echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
+
+# Make sure the root directory has rtinherit set so our test file will too
+$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+
+sz=$((rextsize * 100))
+range="$((blksz * 3)) $blksz"
+
+for verb in fpunch finsert fcollapse fzero funshare falloc; do
+	echo "test $verb"
+	$XFS_IO_PROG -f -c "falloc 0 $sz" "$SCRATCH_MNT/b"
+	$XFS_IO_PROG -f -c "$verb $range" "$SCRATCH_MNT/b"
+	rm -f "$SCRATCH_MNT/b"
+	_scratch_cycle_mount
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/760.out b/tests/xfs/760.out
new file mode 100644
index 00000000..3d73c6fa
--- /dev/null
+++ b/tests/xfs/760.out
@@ -0,0 +1,9 @@
+QA output created by 760
+test fpunch
+test finsert
+fallocate: Invalid argument
+test fcollapse
+fallocate: Invalid argument
+test fzero
+test funshare
+test falloc
diff --git a/tests/xfs/group b/tests/xfs/group
index 771680cf..cb55a8ff 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -520,4 +520,6 @@
 520 auto quick reflink
 521 auto quick realtime growfs
 758 auto quick rw attr realtime
+759 auto quick rw realtime
+760 auto quick rw collapse punch insert zero prealloc
 763 auto quick rw realtime

