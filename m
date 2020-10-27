Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75904C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CFAC21D42
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cWr2AzOF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829287AbgJ0TES (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:04:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47834 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829284AbgJ0TES (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:04:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIt2W0108016;
        Tue, 27 Oct 2020 19:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=79MuuFDS1BTCk5xIZQJVJpUrApbqEYZZwrRDqFvo0lI=;
 b=cWr2AzOFtc+3aOGd1gXoHg3+3ctd/NWqQ1OLnYwxSZoyn8Pn7q/G7P3RwFK/I9tup9FQ
 Z8PPl7rO1oVzGoauYo7kZMclwsVDJoythlQgnRQ8XjfJZFKQl6bny/nwv9KKBb759COs
 MwyQ0Ang/66XppQ3XVeTDScCtCD7nYCAIGCi9oWJKOoM6upuxLzm0YkFszH4+JfJIz0J
 x8dM7o/jj2Z3hv2hU5RUlxV2+Gfkk2bBZaD8wVEK8kamgJQmKsVbGY8LS2NdVs3TeU/+
 i64PFNh/3K1w48w+BdCUZpq+PXFEty98DZ+e8F2Xg4PZ6WGW9cL1IPBAkmP2/gJMgBKV nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kuv0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:04:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItJfr019783;
        Tue, 27 Oct 2020 19:04:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6wbp54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:04:15 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ4E7j025696;
        Tue, 27 Oct 2020 19:04:14 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:04:14 -0700
Subject: [PATCH 3/4] xfs: detect time limits from filesystem
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:04:13 -0700
Message-ID: <160382545348.1203848.12227735405144915534.stgit@magnolia>
In-Reply-To: <160382543472.1203848.8335854864075548402.stgit@magnolia>
References: <160382543472.1203848.8335854864075548402.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach fstests to extract timestamp limits of a filesystem using the new
xfs_db timelimit command.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |    2 +-
 common/xfs        |   14 ++++++++++++++
 tests/xfs/911     |   44 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/911.out |   15 +++++++++++++++
 tests/xfs/group   |    1 +
 5 files changed, 75 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/911
 create mode 100644 tests/xfs/911.out


diff --git a/common/rc b/common/rc
index 41f93047..162d957a 100644
--- a/common/rc
+++ b/common/rc
@@ -2029,7 +2029,7 @@ _filesystem_timestamp_range()
 		echo "0 $u32max"
 		;;
 	xfs)
-		echo "$s32min $s32max"
+		_xfs_timestamp_range "$device"
 		;;
 	btrfs)
 		echo "$s64min $s64max"
diff --git a/common/xfs b/common/xfs
index e548a0a1..19ccee03 100644
--- a/common/xfs
+++ b/common/xfs
@@ -994,3 +994,17 @@ _require_xfs_scratch_inobtcount()
 		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
 	_scratch_unmount
 }
+
+_xfs_timestamp_range()
+{
+	local use_db=0
+	local dbprog="$XFS_DB_PROG $device"
+	test "$device" = "$SCRATCH_DEV" && dbprog=_scratch_xfs_db
+
+	$dbprog -f -c 'help timelimit' | grep -v -q 'not found' && use_db=1
+	if [ $use_db -eq 0 ]; then
+		echo "-$((1<<31)) $(((1<<31)-1))"
+	else
+		$dbprog -f -c 'timelimit --compact' | awk '{printf("%s %s", $1, $2);}'
+	fi
+}
diff --git a/tests/xfs/911 b/tests/xfs/911
new file mode 100755
index 00000000..bccd1e8f
--- /dev/null
+++ b/tests/xfs/911
@@ -0,0 +1,44 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 911
+#
+# Check that the xfs_db timelimit command prints the ranges that we expect.
+# This in combination with an xfs_ondisk.h build time check in the kernel
+# ensures that the kernel agrees with userspace.
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_db_command timelimit
+
+rm -f $seqres.full
+
+# Format filesystem without bigtime support and populate it
+_scratch_mkfs > $seqres.full
+echo classic xfs timelimits
+_scratch_xfs_db -c 'timelimit --classic'
+echo bigtime xfs timelimits
+_scratch_xfs_db -c 'timelimit --bigtime'
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/911.out b/tests/xfs/911.out
new file mode 100644
index 00000000..84dc475b
--- /dev/null
+++ b/tests/xfs/911.out
@@ -0,0 +1,15 @@
+QA output created by 911
+classic xfs timelimits
+time.min = -2147483648
+time.max = 2147483647
+dqtimer.min = 1
+dqtimer.max = 4294967295
+dqgrace.min = 0
+dqgrace.min = 4294967295
+bigtime xfs timelimits
+time.min = -2147483648
+time.max = 16299260424
+dqtimer.min = 4
+dqtimer.max = 16299260424
+dqgrace.min = 0
+dqgrace.min = 4294967295
diff --git a/tests/xfs/group b/tests/xfs/group
index 862df3be..f61d46a1 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,6 +525,7 @@
 761 auto quick realtime
 763 auto quick rw realtime
 910 auto quick inobtcount
+911 auto quick bigtime
 915 auto quick quota
 917 auto quick db
 918 auto quick db

