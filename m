Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1FAC33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 450D7208C3
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gs/KMN7Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgAPFNr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:13:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49414 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgAPFNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:13:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G5DAV1173172;
        Thu, 16 Jan 2020 05:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=sBxCc7zlXvHTS4R6nVhRZR8sYDfaNlzvU6VqknYBivw=;
 b=Gs/KMN7YbMWCnTXdegCx+NNzE/8IPsM0gKDfGk4hEt3plscsYUUSV3JosEqN/Bj9LjLA
 70MRtWsF5fAk/O99m0/lytHmOkkiyIj3Lq4+vrpqizZqdzWiGWuaiopA+DLOeNeFc4Ro
 dP4AB2jJ6ZAW16w6KfUKER4iw/qOPY8V2kCOf7aot5I1pOuxPnQlrgfEjd/Icrihw+HT
 KyPvNtB41zBxjteaGlIJJzy8hhV0e5IwK9OD+javFrCbhb5VTuOcOiG5Az1md4rz0Ai7
 xxz6DsuPIerWyGAGqqI40Tn4/FH5TCEefwi6/HvA6yqcPJruU6lVudCrk2eTBoQRgDWy tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xf73yr7fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:13:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59DQg085357;
        Thu, 16 Jan 2020 05:11:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xj1psd1mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:44 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G5Bisl024449;
        Thu, 16 Jan 2020 05:11:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:11:43 -0800
Subject: [PATCH 2/2] xfs: test setting labels with xfs_admin
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:11:42 -0800
Message-ID: <157915150275.2375135.12157351351400702116.stgit@magnolia>
In-Reply-To: <157915149017.2375135.14166864164575311878.stgit@magnolia>
References: <157915149017.2375135.14166864164575311878.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160043
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
index a6c9ef08..cc1d122a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -511,3 +511,4 @@
 511 auto quick quota
 747 auto quick scrub
 748 auto quick scrub
+912 auto quick label

