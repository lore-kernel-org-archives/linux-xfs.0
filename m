Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BB9C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3BDC21D42
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h4L7KTAa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460393AbgJ0TFI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:05:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48576 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S460386AbgJ0TFI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:05:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIt6wZ108088;
        Tue, 27 Oct 2020 19:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=p3IoS/TCxNzUjHVvmJQZ5eqdpq30LQbi99ALCACjd5E=;
 b=h4L7KTAay9aF1tTU6Os5KDzGUSul5bG4gJBt2lT+yysEnTChQFGbldb42CLNJqQjxu9p
 i11yr0Wi3yT6K4sl99mQ7QRhzdJRwQFoV9oCizIKF1MThSgLAN3aCgHr4TfOSS2uxaH1
 WyWV+M+17HguHsa9K/RLqTB7vWk+AWcipHlBVQTHPGShKv1UvVGbaYedkMI5GYwxahOV
 j7rq1ME755q1STUtDD9BOousKo+nS3SCHAimb0vt/Pvufo6FyNKvyJkm2QLBxbBBzjDO
 U7Eh4neiSb5NO1FFcyU0iQIbI7ZRvzD1Qd2ZPqXC6RR4XR+EGoWKlUk/jdqc34XQtH3J Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kuv48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:05:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIu2LW133050;
        Tue, 27 Oct 2020 19:03:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx5xg8u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:03:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ34nb027928;
        Tue, 27 Oct 2020 19:03:05 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:03:04 -0700
Subject: [PATCH 5/7] xfs: test mkfs min log size calculation w/ rt volumes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:03:03 -0700
Message-ID: <160382538373.1203387.11759890489099193473.stgit@magnolia>
In-Reply-To: <160382535113.1203387.16777876271740782481.stgit@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In "mkfs: set required parts of the realtime geometry before computing
log geometry" we made sure that mkfs set up enough of the fs geometry to
compute the minimum xfs log size correctly when formatting the
filesystem.  This is the regression test for that issue.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/761     |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/761.out |    1 +
 tests/xfs/group   |    1 +
 3 files changed, 44 insertions(+)
 create mode 100755 tests/xfs/761
 create mode 100644 tests/xfs/761.out


diff --git a/tests/xfs/761 b/tests/xfs/761
new file mode 100755
index 00000000..36877bc9
--- /dev/null
+++ b/tests/xfs/761
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 761
+#
+# Make sure mkfs sets up enough of the rt geometry that we can compute the
+# correct min log size for formatting the fs.
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
+# Format a tiny filesystem to force minimum log size, then see if it mounts
+_scratch_mkfs -r size=1m -d size=100m > $seqres.full
+_scratch_mount >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/761.out b/tests/xfs/761.out
new file mode 100644
index 00000000..8c9d9e90
--- /dev/null
+++ b/tests/xfs/761.out
@@ -0,0 +1 @@
+QA output created by 761
diff --git a/tests/xfs/group b/tests/xfs/group
index cb55a8ff..74f0d37c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -522,4 +522,5 @@
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
+761 auto quick realtime
 763 auto quick rw realtime

