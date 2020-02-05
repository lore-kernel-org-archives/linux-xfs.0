Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86411C3F68F
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DF8F214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EYomzGpV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgBEACo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:02:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42312 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgBEACo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:02:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NxqBL097352;
        Wed, 5 Feb 2020 00:02:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=2t+fsHsRr8ElPlfhPVU65WlCXl7s3WhOxSCZt9eVWDA=;
 b=EYomzGpVyM76Ii3fjoloLBMCExNz7yEgqUfvQSpHHGNypZHryBSUHatQ+lraVQE+j9iG
 Mrg5582ziVcHhwzLasl0ac+zAdQ2DqIImDs9f2BJ2esl1zB7Cxn/GxZuSXXdixTpCzhx
 tLvaSVOK/78mmrRXs/J3fU3HSH1DjBvq9NFEaynNuvh4z2/2mWBUbhVDis56HKHBFPWW
 EddLHHjNDZeQsSuKGmU2s/PiTo03QysksOqCBxOEhQlvvW8yyZjG511P3xdJJQOIPmJS
 2g7qvE8FA1TN8PUHzhTKK2fi34aA1ZMD6g4Tgut9Kz1YeO9niFb1NZM4+1y78eDdfpcs JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xyhkfg8ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NwNOF016085;
        Wed, 5 Feb 2020 00:02:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xyhmvj14e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01502e9L022091;
        Wed, 5 Feb 2020 00:02:40 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:02:40 -0800
Subject: [PATCH 2/2] xfs: test setting labels with xfs_admin
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:02:39 -0800
Message-ID: <158086095935.1990521.3334372807118647101.stgit@magnolia>
In-Reply-To: <158086094707.1990521.17646841467136148296.stgit@magnolia>
References: <158086094707.1990521.17646841467136148296.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Test setting filesystem labels with xfs_admin.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/912     |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/912.out |   43 ++++++++++++++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 147 insertions(+)
 create mode 100755 tests/xfs/912
 create mode 100644 tests/xfs/912.out


diff --git a/tests/xfs/912 b/tests/xfs/912
new file mode 100755
index 00000000..1eef36cd
--- /dev/null
+++ b/tests/xfs/912
@@ -0,0 +1,103 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 912
+#
+# Check that xfs_admin can set and clear filesystem labels offline and online.
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
+_require_xfs_db_command label
+_require_xfs_io_command label
+grep -q "xfs_io" "$(which xfs_admin)" || \
+	_notrun "xfs_admin does not support online label setting of any kind"
+
+rm -f $seqres.full
+
+echo
+echo "Format with label"
+_scratch_mkfs -L "label0" > $seqres.full
+
+echo "Read label offline"
+_scratch_xfs_admin -l
+
+echo "Read label online"
+_scratch_mount
+_scratch_xfs_admin -l
+
+echo
+echo "Set label offline"
+_scratch_unmount
+_scratch_xfs_admin -L "label1"
+
+echo "Read label offline"
+_scratch_xfs_admin -l
+
+echo "Read label online"
+_scratch_mount
+_scratch_xfs_admin -l
+
+echo
+echo "Set label online"
+_scratch_xfs_admin -L "label2"
+
+echo "Read label online"
+_scratch_xfs_admin -l
+
+echo "Read label offline"
+_scratch_unmount
+_scratch_xfs_admin -l
+
+echo
+echo "Clear label online"
+_scratch_mount
+_scratch_xfs_admin -L "--"
+
+echo "Read label online"
+_scratch_xfs_admin -l
+
+echo "Read label offline"
+_scratch_unmount
+_scratch_xfs_admin -l
+
+echo
+echo "Set label offline"
+_scratch_xfs_admin -L "label3"
+
+echo "Read label offline"
+_scratch_xfs_admin -l
+
+echo
+echo "Clear label offline"
+_scratch_xfs_admin -L "--"
+
+echo "Read label offline"
+_scratch_xfs_admin -l
+
+echo "Read label online"
+_scratch_mount
+_scratch_xfs_admin -l
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/912.out b/tests/xfs/912.out
new file mode 100644
index 00000000..186d827f
--- /dev/null
+++ b/tests/xfs/912.out
@@ -0,0 +1,43 @@
+QA output created by 912
+
+Format with label
+Read label offline
+label = "label0"
+Read label online
+label = "label0"
+
+Set label offline
+writing all SBs
+new label = "label1"
+Read label offline
+label = "label1"
+Read label online
+label = "label1"
+
+Set label online
+label = "label2"
+Read label online
+label = "label2"
+Read label offline
+label = "label2"
+
+Clear label online
+label = ""
+Read label online
+label = ""
+Read label offline
+label = ""
+
+Set label offline
+writing all SBs
+new label = "label3"
+Read label offline
+label = "label3"
+
+Clear label offline
+writing all SBs
+new label = ""
+Read label offline
+label = ""
+Read label online
+label = ""
diff --git a/tests/xfs/group b/tests/xfs/group
index edffef9a..898bd9e4 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -512,3 +512,4 @@
 512 auto quick acl attr
 747 auto quick scrub
 748 auto quick scrub
+912 auto quick label

