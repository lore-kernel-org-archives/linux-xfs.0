Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA80C2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AD522087E
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:34:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I/B/ukl8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgDWXe1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:34:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgDWXe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:34:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNWwSx143404;
        Thu, 23 Apr 2020 23:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2New5V5MvHezX9t1CQMJzqVfFPrbzmyCnQW8iwQXsRg=;
 b=I/B/ukl8FwKOL5BlsbtcBELviTuTBBSOeukSrlXnEmodTw/ijxntNs8pxb9Frn8XEZQT
 ELs/QJ1Vjr1cDXpzAYmcjcREHt1aguDB6DLNDpztnKzT41fqSszim55sMFaQELXJSxEU
 hUu72JD9dXToFjnBQxbN4nnV0ivUh3/WLdIdU+SJcR3r36FGDfjymj/878kyULJDVLKm
 UxaeZVYo9tt9hSFvO2ClVtrkEsO2+f9DU4uXRzpkrZ6zR4ce4GwkEijqcLY6gvJTKJ/5
 DHmfrPBleNSgT7cio2W5o+GYzMU/RwvV/dIq4LYsGKEu72FlhQYBn1i1UG5KrpH10lgE FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30ketdhmaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:34:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNWOZL043483;
        Thu, 23 Apr 2020 23:32:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30gb1nmsrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:32:23 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03NNWArq032559;
        Thu, 23 Apr 2020 23:32:10 GMT
Received: from localhost (/10.159.232.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:32:10 -0700
Subject: [PATCH 3/4] xfs: make sure our default quota warning limits and
 grace periods survive quotacheck
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 23 Apr 2020 16:32:08 -0700
Message-ID: <158768472874.3019475.13731875015196637937.stgit@magnolia>
In-Reply-To: <158768470761.3019475.18353274420657119359.stgit@magnolia>
References: <158768470761.3019475.18353274420657119359.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that the default quota grace period and maximum warning limits
set by the administrator survive quotacheck.  This is a regression test
for 5885539f0af371 ("xfs: preserve default grace interval during
quotacheck").

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/913     |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/913.out |   13 ++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 83 insertions(+)
 create mode 100755 tests/xfs/913
 create mode 100644 tests/xfs/913.out


diff --git a/tests/xfs/913 b/tests/xfs/913
new file mode 100755
index 00000000..94681b02
--- /dev/null
+++ b/tests/xfs/913
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 913
+#
+# Make sure that the quota default grace period and maximum warning limits
+# survive quotacheck.
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
+_supported_os Linux
+_require_quota
+
+rm -f $seqres.full
+
+# Format filesystem and set up quota limits
+_scratch_mkfs > $seqres.full
+_qmount_option "usrquota"
+_scratch_mount >> $seqres.full
+
+$XFS_QUOTA_PROG -x -c 'timer -u 300m' $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+_scratch_unmount
+
+# Remount and check the limits
+_scratch_mount >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+_scratch_unmount
+
+# Run repair to force quota check
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+# Remount (this time to run quotacheck) and check the limits.  There's a bug
+# in quotacheck where we would reset the ondisk default grace period to zero
+# while the incore copy stays at whatever was read in prior to quotacheck.
+# This will show up after the /next/ remount.
+_scratch_mount >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+_scratch_unmount
+
+# Remount and check the limits
+_scratch_mount >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/913.out b/tests/xfs/913.out
new file mode 100644
index 00000000..ee989388
--- /dev/null
+++ b/tests/xfs/913.out
@@ -0,0 +1,13 @@
+QA output created by 913
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
diff --git a/tests/xfs/group b/tests/xfs/group
index b0e4816f..a626b786 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -514,4 +514,5 @@
 514 auto quick db
 515 auto quick quota
 755 auto quick fsmap freeze
+913 auto quick quota
 914 auto quick reflink

