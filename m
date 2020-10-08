Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4B8C4363C
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC7BF2085B
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:00:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X0/vo7Lv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJHEAG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 00:00:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgJHEAG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 00:00:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983q173022276;
        Thu, 8 Oct 2020 04:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Axgp1WhcYaon0Tasz6siQqvnIgVaKo4ughqpt5Nd3J8=;
 b=X0/vo7LvTX8WZrb550OiWAXx3bfblvxDZOgpG88yyDq+VOdEZORZ/8boaHQNjk3uq0W0
 1AMfU6kp4U/CxiNSjPcnLfkFo0RESe+8CaOmuzmpwSiZf46IhfzZchyp1AAQh6+5wCqL
 8nJcz9cEamCgTPXd0NQpTqo4ZvQhSpGNcRNitN6WCJ+ezuf1TtyJgxHyVVorGhCEEnuj
 aVQC5B8r2lFGK9G39zPsyaw0Xh0BCAZB+xOyNBIX39GtU/+yZGlsdiBLLeLQLLwpXUJX
 hVkN5VlC7GaiPpu5DKz5aYnX2KyENBLLFpcX1cao8zKA2zzM0cfypkziJViHiLZv52fK gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34tejs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 04:00:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983isZ4142445;
        Thu, 8 Oct 2020 04:00:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3410k0fjjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 04:00:00 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0983xwWa024235;
        Thu, 8 Oct 2020 03:59:58 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:59:58 -0700
Date:   Wed, 7 Oct 2020 20:59:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        sandeen@redhat.com
Cc:     fstests <fstests@vger.kernel.org>
Subject: [RFC PATCH 3/2] xfstest: test running growfs on the realtime volume
Message-ID: <20201008035957.GJ6540@magnolia>
References: <160212936001.248573.7813264584242634489.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160212936001.248573.7813264584242634489.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that we can run growfs to expand the realtime volume without
it blowing up.  This is a regression test for the following patches:

xfs: Set xfs_buf type flag when growing summary/bitmap files
xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files
xfs: fix realtime bitmap/summary file truncation when growing rt volume
xfs: make xfs_growfs_rt update secondary superblocks

Because the xfs maintainer realized that no, we have no tests for this
particular piece of functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/916     |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/916.out |   10 +++++++
 tests/xfs/group   |    1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/916
 create mode 100644 tests/xfs/916.out

diff --git a/tests/xfs/916 b/tests/xfs/916
new file mode 100755
index 00000000..c2484376
--- /dev/null
+++ b/tests/xfs/916
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 916
+#
+# Tests xfs_growfs on the realtime volume to make sure none of it blows up.
+# This is a regression test for the following patches:
+#
+# xfs: Set xfs_buf type flag when growing summary/bitmap files
+# xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files
+# xfs: fix realtime bitmap/summary file truncation when growing rt volume
+# xfs: make xfs_growfs_rt update secondary superblocks
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
+# Note that we don't _require_realtime because we synthesize a rt volume
+# below.
+_require_scratch_nocheck
+_require_no_large_scratch_dev
+
+echo "Create fake rt volume"
+truncate -s 400m $TEST_DIR/$seq.rtvol
+rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
+
+echo "Format and mount 100m rt volume"
+export USE_EXTERNAL=yes
+export SCRATCH_RTDEV=$rtdev
+_scratch_mkfs -r size=100m > $seqres.full
+_scratch_mount || _notrun "Could not mount scratch with synthetic rt volume"
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Check rt volume stats"
+$XFS_IO_PROG -c 'chattr +t' $testdir
+$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
+before=$(stat -f -c '%b' $testdir)
+
+echo "Create some files"
+_pwrite_byte 0x61 0 1m $testdir/original >> $seqres.full
+
+echo "Grow fs"
+$XFS_GROWFS_PROG $SCRATCH_MNT 2>&1 |  _filter_growfs >> $seqres.full
+_scratch_cycle_mount
+
+echo "Recheck 400m rt volume stats"
+$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
+after=$(stat -f -c '%b' $testdir)
+_within_tolerance "rt volume size" $after $((before * 4)) 5% -v
+
+echo "Create more copies to make sure the bitmap really works"
+cp -p $testdir/original $testdir/copy3
+
+echo "Check filesystem"
+_check_xfs_filesystem $SCRATCH_DEV none $rtdev
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/916.out b/tests/xfs/916.out
new file mode 100644
index 00000000..55f2356a
--- /dev/null
+++ b/tests/xfs/916.out
@@ -0,0 +1,10 @@
+QA output created by 916
+Create fake rt volume
+Format and mount 100m rt volume
+Check rt volume stats
+Create some files
+Grow fs
+Recheck 400m rt volume stats
+rt volume size is in range
+Create more copies to make sure the bitmap really works
+Check filesystem
diff --git a/tests/xfs/group b/tests/xfs/group
index ef375397..4e58b5cc 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -549,6 +549,7 @@
 910 auto quick inobtcount
 911 auto quick bigtime
 915 auto quick quota
+916 auto quick realtime growfs
 1202 auto quick swapext
 1208 auto quick swapext
 1500 dangerous_fuzzers dangerous_bothrepair
