Return-Path: <SRS0=54mU=DR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B572C43467
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB59320795
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NubdKGpB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390472AbgJJW5W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:57:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47324 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733270AbgJJUDg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Oct 2020 16:03:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09AHp2Hb025399;
        Sat, 10 Oct 2020 17:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SYM9eV0LOzCr36j9sphzzPSWHU/CgzVsDSnxFo231Ig=;
 b=NubdKGpBkBPzORtPg6HFFiwg77uH5R2uBzvyoWyjXS5sE90A4vzsRrNifI+tuzHkZ8Vh
 GFSkxv4uamC1pOrd8m4qQyZ8GjWeGY90jAo7Vg2Qig/kMuQ+MAuDCqEIXRARM64X0E4t
 Xod/YL5wzUTvJA+lMHXLmV0weIc1kKqajd37EeJQM7PaG07rACeNoCNr8q1NN0kRVegM
 ngMbTAEw0+TYPPhzQygc6/y5W0pAMoMP4eAp6R2gOj6Q+FRKqbb1sc2DFkFKXFuKmWfW
 0yvPQNAvSHFSDtIEDLLENGGhrRHFKrtItJ3Q/YbkcHbd/vfddYVucMJKhMnvGhQSkIdP rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3434wk9241-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 10 Oct 2020 17:51:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09AHjK4N095647;
        Sat, 10 Oct 2020 17:51:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34349jg5uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Oct 2020 17:51:01 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09AHp09w029355;
        Sat, 10 Oct 2020 17:51:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 10 Oct 2020 10:51:00 -0700
Date:   Sat, 10 Oct 2020 10:50:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com, hch@lst.de
Subject: [PATCH 4/2] xfs: test running growfs on the realtime volume
Message-ID: <20201010175059.GC6559@magnolia>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160235126125.1384192.1096112127332769120.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9770 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010100167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9770 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010100168
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
xfs: annotate grabbing the realtime bitmap/summary locks in growfs

Because the xfs maintainer realized that no, we have no tests for this
particular piece of functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/916     |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/916.out |   10 ++++++
 tests/xfs/group   |    1 +
 3 files changed, 93 insertions(+)
 create mode 100755 tests/xfs/916
 create mode 100644 tests/xfs/916.out

diff --git a/tests/xfs/916 b/tests/xfs/916
new file mode 100755
index 00000000..cde00314
--- /dev/null
+++ b/tests/xfs/916
@@ -0,0 +1,82 @@
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
+# xfs: annotate grabbing the realtime bitmap/summary locks in growfs
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
index c75d2b99..74a29bc0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -528,3 +528,4 @@
 910 auto quick inobtcount
 911 auto quick bigtime
 915 auto quick quota
+916 auto quick realtime growfs
