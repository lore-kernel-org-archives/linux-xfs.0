Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDC9C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 965742070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZXqukSGX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389476AbfIEWTY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39336 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389368AbfIEWTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ84R084693
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=bmum3NnWX5T8XNcKTD1sm+/CbQOuetqgo5UZZD3oAko=;
 b=ZXqukSGX4FQEEqVFg+gG151az27rEKLtD79H1P6P7Dp6UfIBkkcAKeZi/DgzVeLIWIhl
 lYdq23UMC43FpYpmjgSbbeJI/bjVKQrhk9rD4WTtuiMek5HLp418MWaHJJUH8rNdE/6G
 RogRwJtlK2emvkoljU9khumz7zmJEQobEpH11S4toYXYbx2Vk2iJl4cvkZDbDnP24KFl
 bdAJAwAjL5qVSSsQnwpna7L+mB+BGni0y/PTh//1/JZXVufOieIAusQlpuYpYCN+05B2
 jQr2zlAg/RIAQ6ePhQN9p5rwgZo0DKTaHd5bPQUOY5AbCBAK8j32yExiYWccMMpOumK4 Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uuaqxr2fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ5aI076753
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2utvr4a18x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85MJLLV032764
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:21 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:21 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/1] xfstests: Add Delayed Attribute test
Date:   Thu,  5 Sep 2019 15:19:17 -0700
Message-Id: <20190905221917.17733-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221917.17733-1-allison.henderson@oracle.com>
References: <20190905221917.17733-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a test to exercise the delayed attribute error
inject and log replay.  Attributes are added in increaseing
sizes up to 64k, and the error inject is used to replay them
from the log

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 common/rc         |   3 ++
 common/xfs        |   7 +++
 tests/xfs/512     | 101 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out | 131 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |   1 +
 5 files changed, 243 insertions(+)

diff --git a/common/rc b/common/rc
index feb001b..e2d2eb8 100644
--- a/common/rc
+++ b/common/rc
@@ -2116,6 +2116,9 @@ _require_xfs_io_command()
 		rm -f $testcopy > /dev/null 2>&1
 		param_checked="$param"
 		;;
+	"delayed_attr")
+		testio=`$XFS_IO_PROG -x -c "delayed_attr" $TEST_DIR 2>&1`
+		;;
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`
 		param_checked="$param"
diff --git a/common/xfs b/common/xfs
index 1bce3c1..b8a4734 100644
--- a/common/xfs
+++ b/common/xfs
@@ -262,6 +262,13 @@ _require_projid32bit()
 	   || _notrun "mkfs.xfs doesn't have projid32bit feature"
 }
 
+_require_delattr()
+{
+	echo "_require_delattr"
+	_scratch_mkfs_xfs_supported -n delattr >/dev/null 2>&1 \
+	   || _notrun "mkfs.xfs doesn't have delattr feature"
+}
+
 _require_projid16bit()
 {
 	_scratch_mkfs_xfs_supported -i projid32bit=0 >/dev/null 2>&1 \
diff --git a/tests/xfs/512 b/tests/xfs/512
new file mode 100755
index 0000000..0efae05
--- /dev/null
+++ b/tests/xfs/512
@@ -0,0 +1,101 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 512
+#
+# Delayed attr log replay test
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0	# success is the default!
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/inject
+
+_cleanup()
+{
+	echo "*** unmount"
+	_scratch_unmount 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_test_attr_replay()
+{
+	attr_name=$1
+	attr_value=$2
+	touch $testfile.1
+
+	echo "Inject error"
+	_scratch_inject_error "delayed_attr"
+
+	echo "Set attribute"
+	echo "$attr_value" | ${ATTR_PROG} -s "$attr_name" $testfile.1 | \
+			    _filter_scratch
+
+	echo "FS should be shut down, touch will fail"
+	touch $testfile.1
+
+	echo "Remount to replay log"
+	_scratch_inject_logprint >> $seqres.full
+
+	echo "FS should be online, touch should succeed"
+	touch $testfile.1
+
+	echo "Verify attr recovery"
+	_getfattr --absolute-names $testfile.1 | _filter_scratch
+}
+
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_attrs
+_require_xfs_io_error_injection "delayed_attr"
+_require_delattr
+
+# turn on delayed attributes
+MKFS_OPTIONS="-n delattr"
+
+rm -f $seqres.full
+_scratch_unmount >/dev/null 2>&1
+
+#attributes of increaseing sizes
+attr16="0123456789ABCDEFG"
+attr64="$attr16$attr16$attr16$attr16"
+attr256="$attr64$attr64$attr64$attr64"
+attr1k="$attr256$attr256$attr256$attr256"
+attr4k="$attr1k$attr1k$attr1k$attr1k"
+attr8k="$attr4k$attr4k$attr4k$attr4k"
+attr32k="$attr8k$attr8k$attr8k$attr8k"
+attr64k="$attr32k$attr32k"
+
+echo "*** mkfs"
+_scratch_mkfs_xfs >/dev/null
+
+echo "*** mount FS"
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+echo "*** make test file 1"
+
+_test_attr_replay "attr_name1" $attr16
+_test_attr_replay "attr_name2" $attr64
+_test_attr_replay "attr_name3" $attr256
+_test_attr_replay "attr_name4" $attr1k
+_test_attr_replay "attr_name5" $attr4k
+_test_attr_replay "attr_name6" $attr8k
+_test_attr_replay "attr_name7" $attr32k
+_test_attr_replay "attr_name8" $attr64k
+
+echo "*** done"
+exit
diff --git a/tests/xfs/512.out b/tests/xfs/512.out
new file mode 100644
index 0000000..53843ad
--- /dev/null
+++ b/tests/xfs/512.out
@@ -0,0 +1,131 @@
+QA output created by 512
+_require_delattr
+*** mkfs
+*** mount FS
+*** make test file 1
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name1" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name2" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name3" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name4" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name5" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name6" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name7" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+user.attr_name7
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name8" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+user.attr_name7
+user.attr_name8
+
+*** done
+*** unmount
diff --git a/tests/xfs/group b/tests/xfs/group
index a7ad300..a9dab7c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -509,3 +509,4 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+512 auto quick attr
-- 
2.7.4

