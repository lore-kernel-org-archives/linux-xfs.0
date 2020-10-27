Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E56C55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1956D20878
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dhe2XsVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501931AbgJ0TCt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:02:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49052 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501925AbgJ0TCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:02:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsWk3111613;
        Tue, 27 Oct 2020 19:02:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=x6X8CAPXSwzRKFdwyvfXNGe4FWpLJ7uTCv7q/sUXCQU=;
 b=Dhe2XsVk7g4MQNeA9sK6fN7dldEisRJ688VFcDkBV8YnjjtSJp+TEPgqziPNN6WAwk+D
 gMq4TByARuIXCeEThceuMgEdTCqRH9NuryX8puxqdkhREheqRL8/9vrLn/RAHRZ4q0tz
 7n9GW54tgOc2uj/JG1v3HKKQAEupkAuVbDNea0QOV0vExrKCeh7b9jUlAiD6AZv4HJQN
 W4328lQVMmBPVKFOhdSvcer2c78kga+9WH6ax3vk1vnwKZf4SdEqmDM5r1bEJ/4w7KnR
 QUXnhPAMgi1N6cbTRnNAaOWee/m2umkhd4COAJwGXQW1UyUKU59QksDktf/IPY37QcLt pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm41f29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:02:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsQDD076607;
        Tue, 27 Oct 2020 19:02:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwumrj9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:02:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ2ii4001365;
        Tue, 27 Oct 2020 19:02:45 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:02:44 -0700
Subject: [PATCH 2/7] xfs: test regression in xfs_bmap_validate_extent
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:02:43 -0700
Message-ID: <160382536365.1203387.5299416996869850602.stgit@magnolia>
In-Reply-To: <160382535113.1203387.16777876271740782481.stgit@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This is a regression test to make sure that we can have realtime files
with xattr blocks and not trip the verifiers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/758     |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/758.out |    2 ++
 tests/xfs/group   |    1 +
 3 files changed, 62 insertions(+)
 create mode 100755 tests/xfs/758
 create mode 100644 tests/xfs/758.out


diff --git a/tests/xfs/758 b/tests/xfs/758
new file mode 100755
index 00000000..e522ae28
--- /dev/null
+++ b/tests/xfs/758
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 758
+#
+# This is a regression test for "xfs: fix xfs_bmap_validate_extent_raw when
+# checking attr fork of rt files", which fixes the bmap record validator so
+# that it will not check the attr fork extent mappings of a realtime file
+# against the size of the realtime volume.
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
+
+rm -f $seqres.full
+
+# Format filesystem with very tiny realtime volume
+_scratch_mkfs -r size=256k > $seqres.full
+_scratch_mount >> $seqres.full
+
+# Create a realtime file
+$XFS_IO_PROG -f -R -c 'pwrite 0 64k' -c stat $SCRATCH_MNT/v >> $seqres.full
+
+# Add enough xattr data to force creation of xattr blocks at a higher address
+# on the data device than the size of the realtime volume
+for i in `seq 0 16`; do
+	$ATTR_PROG -s user.test$i $SCRATCH_MNT/v < $SCRATCH_MNT/v >> $seqres.full
+done
+
+# Force flushing extent maps to disk to trip the verifier
+_scratch_cycle_mount
+
+# Now let that unmount
+echo Silence is golden.
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/758.out b/tests/xfs/758.out
new file mode 100644
index 00000000..6d219f8e
--- /dev/null
+++ b/tests/xfs/758.out
@@ -0,0 +1,2 @@
+QA output created by 758
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index ffd18166..771680cf 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -519,4 +519,5 @@
 519 auto quick reflink
 520 auto quick reflink
 521 auto quick realtime growfs
+758 auto quick rw attr realtime
 763 auto quick rw realtime

