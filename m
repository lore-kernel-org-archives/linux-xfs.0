Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E28AC55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F038721D42
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FHy1eGf2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829368AbgJ0TFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:05:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58450 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829360AbgJ0TFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:05:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItES7021975;
        Tue, 27 Oct 2020 19:05:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BMaXCWFSMmwAojaeTOdTeRGl90MlZt+Dh71dvLkUL6w=;
 b=FHy1eGf2GZBB+DDs8ke5k8K9yfE73XC5nN25/P+5trzT6pBSkxpIt0Sppgka2H6P6tM/
 uWqdwp+eef764693Apw7hCQB3s9z0aPBLi4nL6RzZ6yRDKwgIgA0SYKG8JPAeOh39X93
 JbyO/9Jnk1o4w9MxsDRLnRPdd71XigXTXXUHeKvyvHsw//bDYPExojvLesc3rfy4km4/
 6LkMQLrzJfp+ZJo/D9XDExkSa42V9EQiKJS9j0nrCzJ8LwcatGiCBozUIGtXCUGlEHtj
 TII2mxy99A0gzGZehoXJrn9IWpj0RCroEuf14gGBkaNL2IirzrmTtDDU/cuRHHcmp7D4 Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sav0m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:05:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIuLei090866;
        Tue, 27 Oct 2020 19:03:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1r3vpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:03:28 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ3R4D006652;
        Tue, 27 Oct 2020 19:03:27 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:03:27 -0700
Subject: [PATCH 1/2] xfs: test the xfs_db path command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:03:26 -0700
Message-ID: <160382540625.1203622.17204110057935852699.stgit@magnolia>
In-Reply-To: <160382540004.1203622.14607732322524118731.stgit@magnolia>
References: <160382540004.1203622.14607732322524118731.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new test to make sure the xfs_db path command works the way the
author thinks it should.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/917     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/917.out |   19 ++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 118 insertions(+)
 create mode 100755 tests/xfs/917
 create mode 100644 tests/xfs/917.out


diff --git a/tests/xfs/917 b/tests/xfs/917
new file mode 100755
index 00000000..32916135
--- /dev/null
+++ b/tests/xfs/917
@@ -0,0 +1,98 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 917
+#
+# Make sure the xfs_db path command works the way the author thinks it does.
+# This means that it can navigate to random inodes, fails on paths that don't
+# resolve.
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
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_db_command "path"
+_require_scratch
+
+echo "Format filesystem and populate"
+_scratch_mkfs > $seqres.full
+_scratch_mount >> $seqres.full
+
+mkdir $SCRATCH_MNT/a
+mkdir $SCRATCH_MNT/a/b
+$XFS_IO_PROG -f -c 'pwrite 0 61' $SCRATCH_MNT/a/c >> $seqres.full
+ln -s -f c $SCRATCH_MNT/a/d
+mknod $SCRATCH_MNT/a/e b 8 0
+ln -s -f b $SCRATCH_MNT/a/f
+
+_scratch_unmount
+
+echo "Check xfs_db path on directories"
+_scratch_xfs_db -c 'path /a' -c print | grep -q 'sfdir.*count.* 5$' || \
+	echo "Did not find directory /a"
+
+_scratch_xfs_db -c 'path /a/b' -c print | grep -q sfdir || \
+	echo "Did not find empty sf directory /a/b"
+
+echo "Check xfs_db path on files"
+_scratch_xfs_db -c 'path /a/c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file /a/c"
+
+echo "Check xfs_db path on file symlinks"
+_scratch_xfs_db -c 'path /a/d' -c print | grep -q symlink || \
+	echo "Did not find symlink /a/d"
+
+echo "Check xfs_db path on bdevs"
+_scratch_xfs_db -c 'path /a/e' -c print | grep -q 'format.*dev' || \
+	echo "Did not find bdev /a/e"
+
+echo "Check xfs_db path on dir symlinks"
+_scratch_xfs_db -c 'path /a/f' -c print | grep -q symlink || \
+	echo "Did not find symlink /a/f"
+
+echo "Check nonexistent path"
+_scratch_xfs_db -c 'path /does/not/exist'
+
+echo "Check xfs_db path on file path with multiple slashes"
+_scratch_xfs_db -c 'path /a////////c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file /a////////c"
+
+echo "Check xfs_db path on file path going in and out of /a to get to /a/c"
+_scratch_xfs_db -c 'path /a/.././a/.././a/c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file /a/.././a/.././a/c"
+
+echo "Check xfs_db path on file path going above the root to get to /a/c"
+_scratch_xfs_db -c 'path /../../../a/c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file  /../../../a/c"
+
+echo "Check xfs_db path on file path going to then above the root to get to /a/c"
+_scratch_xfs_db -c 'path /a/../../../a/c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file  /a/../../../a/c"
+
+echo "Check xfs_db path component that isn't a directory"
+_scratch_xfs_db -c 'path /a/c/b' -c print
+
+echo "Check xfs_db path on a dot-dot applied to a non-directory"
+_scratch_xfs_db -c 'path /a/c/../b' -c print
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/917.out b/tests/xfs/917.out
new file mode 100644
index 00000000..7c613c3d
--- /dev/null
+++ b/tests/xfs/917.out
@@ -0,0 +1,19 @@
+QA output created by 917
+Format filesystem and populate
+Check xfs_db path on directories
+Check xfs_db path on files
+Check xfs_db path on file symlinks
+Check xfs_db path on bdevs
+Check xfs_db path on dir symlinks
+Check nonexistent path
+/does/not/exist: No such file or directory
+Check xfs_db path on file path with multiple slashes
+Check xfs_db path on file path going in and out of /a to get to /a/c
+Check xfs_db path on file path going above the root to get to /a/c
+Check xfs_db path on file path going to then above the root to get to /a/c
+Check xfs_db path component that isn't a directory
+/a/c/b: Not a directory
+no current type
+Check xfs_db path on a dot-dot applied to a non-directory
+/a/c/../b: Not a directory
+no current type
diff --git a/tests/xfs/group b/tests/xfs/group
index 17f6bc6c..82e02196 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,3 +525,4 @@
 761 auto quick realtime
 763 auto quick rw realtime
 915 auto quick quota
+917 auto quick db

