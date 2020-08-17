Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632D3C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4049720760
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZG/H/ELS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHQXBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:01:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42244 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbgHQXBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:01:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMuu88136112;
        Mon, 17 Aug 2020 23:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fqdgjjuW2dHrcDJfxI+pqltMAYV2NzAWyCKmmkWGQ68=;
 b=ZG/H/ELS25qCFYRgCQfgcgx12At0E3wwTGhMDmJ8riAW+dZOIjWO/UJklLQpZ5lXTH9k
 7n0xdCvVAWUvd9y0IWEmhAjwYRH44ysShZHb0byanO7nsI46A0psfa2svUMw4r8pplSB
 YBJGQTYjpv6gRvkLSAPssy138hGjPvO4/l0A256Km2l2p61d5M7Gx/9EfCsvreAJ+931
 2woNVXuOajJFw2hUC8T2+tayHdhUbnBz0OFBSUa4RObfPuq1tIxjE6gYio50AHuPrV71
 8ARinNCxS8wxNx3daL/bDFO3VUM+dFnbtBNBaffsd4f38bXiV5iBNd3ngLMpBybNGLxN lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn1g8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:01:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw9wT084716;
        Mon, 17 Aug 2020 23:01:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32xsfr5c1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:01:15 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HN1Evi026405;
        Mon, 17 Aug 2020 23:01:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:01:13 -0700
Subject: [PATCH 3/4] xfs: detect time limits from filesystem
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:01:12 -0700
Message-ID: <159770527292.3960575.5093832087395279280.stgit@magnolia>
In-Reply-To: <159770525400.3960575.11977829712550002800.stgit@magnolia>
References: <159770525400.3960575.11977829712550002800.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
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
 tests/xfs/911     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/911.out |   15 +++++++++++++++
 tests/xfs/group   |    1 +
 5 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/911
 create mode 100644 tests/xfs/911.out


diff --git a/common/rc b/common/rc
index aa5a7409..4f76f18d 100644
--- a/common/rc
+++ b/common/rc
@@ -2058,7 +2058,7 @@ _filesystem_timestamp_range()
 		echo "0 $u32max"
 		;;
 	xfs)
-		echo "$s32min $s32max"
+		_xfs_timestamp_range "$device"
 		;;
 	btrfs)
 		echo "$s64min $s64max"
diff --git a/common/xfs b/common/xfs
index 05ed768a..252a5c0d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -971,3 +971,17 @@ _require_xfs_scratch_inobtcount()
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
index 00000000..2e161a74
--- /dev/null
+++ b/tests/xfs/911
@@ -0,0 +1,45 @@
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
+_supported_os Linux
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
index 00000000..b0408bac
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
+time.max = 16299260425
+dqtimer.min = 1
+dqtimer.max = 16299260425
+dqgrace.min = 0
+dqgrace.min = 4294967295
diff --git a/tests/xfs/group b/tests/xfs/group
index b144d391..0063fd19 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -532,4 +532,5 @@
 747 auto quick scrub
 748 auto quick scrub
 910 auto quick inobtcount
+911 auto quick bigtime
 915 auto quick quota

