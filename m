Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD18C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D4B21556
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K4GKCSyN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829275AbgJ0TEA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:04:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47590 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502031AbgJ0TEA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:04:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItFRB108131;
        Tue, 27 Oct 2020 19:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aNzFQjUD0KUFfzzHEbVeuyAyb/ef8YzsjF3JDaGFDlI=;
 b=K4GKCSyNoOw+OE6tbvDb7zmIBdBzzayXeUI5H7RPMLeLpam7/yvujB0uP5ZUgwTNT4yO
 1GRustMS+lUhyDCt9KBWZl6N74FLxFya3hY09/jMISrqQ/0M8Q7+bOO2w82D7Hh1wDjW
 IyL5w5AA9uLcLQzvZG8qtthKtM2jwTmJF1KEUSzj5ZClBKxskaH6/R8WebCagqb3u56c
 vDKSi8FZC/TAkLdYBKsn/RyIBeQvvIc6frJ7WJezNoLVJTncLbEgi7plM3dMg9QPPQSi
 V9+XTwISCt7IRaBdWCUC3uEn8eByycpUE0ooFBynlgLzHOp1L/p96fiJGSbrs0x2dMbC aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kuuy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:03:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItJYs019776;
        Tue, 27 Oct 2020 19:03:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6wbnuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:03:56 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ3ueJ025554;
        Tue, 27 Oct 2020 19:03:56 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:03:51 -0700
Subject: [PATCH 2/2] xfs: test inobtcount upgrade
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:03:48 -0700
Message-ID: <160382542877.1203756.11339393830951325848.stgit@magnolia>
In-Reply-To: <160382541643.1203756.12015378093281554469.stgit@magnolia>
References: <160382541643.1203756.12015378093281554469.stgit@magnolia>
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

Make sure we can actually upgrade filesystems to support inobtcounts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs        |   16 ++++++++++++
 tests/xfs/910     |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/910.out |    3 ++
 tests/xfs/group   |    1 +
 4 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out


diff --git a/common/xfs b/common/xfs
index 3f5c14ba..e548a0a1 100644
--- a/common/xfs
+++ b/common/xfs
@@ -978,3 +978,19 @@ _require_xfs_copy()
 	[ "$USE_EXTERNAL" = yes ] && \
 		_notrun "Cannot xfs_copy with external devices"
 }
+
+_require_xfs_mkfs_inobtcount()
+{
+	_scratch_mkfs_xfs_supported -m inobtcount=1 >/dev/null 2>&1 \
+	   || _notrun "mkfs.xfs doesn't have inobtcount feature"
+}
+
+_require_xfs_scratch_inobtcount()
+{
+	_require_scratch
+
+	_scratch_mkfs -m inobtcount=1 > /dev/null
+	_try_scratch_mount || \
+		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
+	_scratch_unmount
+}
diff --git a/tests/xfs/910 b/tests/xfs/910
new file mode 100755
index 00000000..1924d9ea
--- /dev/null
+++ b/tests/xfs/910
@@ -0,0 +1,72 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 910
+#
+# Check that we can upgrade a filesystem to support inobtcount and that
+# everything works properly after the upgrade.
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
+# We have very specific formatting parameters, so don't let things get complex
+# with realtime devices and external logs.
+unset USE_EXTERNAL
+
+# real QA test starts here
+_supported_fs xfs
+_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+_require_xfs_mkfs_inobtcount
+_require_xfs_scratch_inobtcount
+
+rm -f $seqres.full
+
+# Make sure we can't format a filesystem with inobtcount and not finobt.
+_scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
+	echo "Should not be able to format with inobtcount but not finobt."
+
+# Make sure we can't upgrade a filesystem to inobtcount without finobt.
+_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 &> $seqres.full
+_scratch_xfs_admin -O inobtcount >> $seqres.full && \
+	echo "Should not be able to upgrade to inobtcount without finobt."
+
+# Format V5 filesystem without inode btree counter support and populate it
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+_scratch_mount >> $seqres.full
+
+echo moo > $SCRATCH_MNT/urk
+
+_scratch_unmount
+_check_scratch_fs
+
+# Now upgrade to inobtcount support
+_scratch_xfs_admin -O inobtcount >> $seqres.full
+_check_scratch_fs
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
+
+# Mount again, look at our files
+_scratch_mount >> $seqres.full
+cat $SCRATCH_MNT/urk
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/xfs/910.out b/tests/xfs/910.out
new file mode 100644
index 00000000..83992f49
--- /dev/null
+++ b/tests/xfs/910.out
@@ -0,0 +1,3 @@
+QA output created by 910
+moo
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 4b0caea4..862df3be 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -524,6 +524,7 @@
 760 auto quick rw collapse punch insert zero prealloc
 761 auto quick realtime
 763 auto quick rw realtime
+910 auto quick inobtcount
 915 auto quick quota
 917 auto quick db
 918 auto quick db

