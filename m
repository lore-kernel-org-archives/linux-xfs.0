Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26747C388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC0FC221E9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NaihXQzf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732293AbgKKAo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:44:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731713AbgKKAo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:44:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0XwYX110639;
        Wed, 11 Nov 2020 00:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=p3IoS/TCxNzUjHVvmJQZ5eqdpq30LQbi99ALCACjd5E=;
 b=NaihXQzfgrB1kJnKPGCGvD6C1tjresYSWms9L1Yql9J9mQnl+p3TNYx/a9woeIUHnmBv
 dfE291CmyWaPaj0eOBp/zlrs75KuGmYF6SDHusgWmWsXuNlJTL4Tsq489aHrsNTI4zBI
 K3qO1Gx2bXgakY6LDX/pv1Ozi1KEyZ9ZBLcw4o+o5QemDo69NUfCAAKZLCJLRiaU22a9
 8cj62HefWRGG18ebimwYh4wZKrCBOuC2XNnE8F1YReUaf6RxrABDGoUrYXmHF/dbGNq/
 X8H6fX9UZ47if6IgGz4g60VRa6vKdxNYKjGxOlWCCsq5ZnUyNGk0ERvbvPtHWnwTjxrc tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhkxnnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:44:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0VEtk095433;
        Wed, 11 Nov 2020 00:44:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34p55pau7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:44:24 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB0iNkl000863;
        Wed, 11 Nov 2020 00:44:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:44:22 -0800
Subject: [PATCH 5/7] xfs: test mkfs min log size calculation w/ rt volumes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:44:21 -0800
Message-ID: <160505546184.1388823.6675430976638809308.stgit@magnolia>
In-Reply-To: <160505542802.1388823.10368384826199448253.stgit@magnolia>
References: <160505542802.1388823.10368384826199448253.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
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

