Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2FCC55192
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CEA620784
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AosyFxsP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgDWXeB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:34:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59902 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWXeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:34:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNX2T8143431;
        Thu, 23 Apr 2020 23:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=i1VBjbzyACnS7ie40jsO9uUgfVwFWq5OInGK1HzgCnI=;
 b=AosyFxsPUYwaFzr8r0jDMuJdyOqai2bPNSIC9/St6Q4eL0yLQ2XnnYGevXlKiMRuiqfz
 QMN89uEajRqd2lh0MQRIn+eR9k7PSsLshWwXOadqMhK1hv36ak6xhpEuMvfSqUjeTjIC
 GW1QNYmVv/Vjyxk1NipeckjlmtJ1AyA5iHoqfNqPg7IPFYzkdZsTaIwqRx7jhbIePdTf
 GzcR1rPFDa5EGUEfO26AahmYHfyfzVde2rv/B0OvsqX+5Bz9DTxwsliviFDPQ6Zre1PA
 F5areFmyYuam88nN1soKzrJVSrPUDZa1/wyHvsI0JyFDVlGm/5zk31aUu3K+c+CljSaB XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30ketdhm9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:33:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNReMw160665;
        Thu, 23 Apr 2020 23:31:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30k7qw2ch0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:58 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03NNVv3D021521;
        Thu, 23 Apr 2020 23:31:57 GMT
Received: from localhost (/10.159.232.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:31:57 -0700
Subject: [PATCH 1/4] xfs: test that reflink forces the log if mounted with
 wsync
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 23 Apr 2020 16:31:53 -0700
Message-ID: <158768471382.3019475.14095534927414395012.stgit@magnolia>
In-Reply-To: <158768470761.3019475.18353274420657119359.stgit@magnolia>
References: <158768470761.3019475.18353274420657119359.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230168
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

A code inspection revealed that reflink does not force the log to disk
even if the filesystem is mounted with wsync.  Add a regression test for
commit 5833112df7e9a ("xfs: reflink should force the log out if mounted
with wsync").

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/914     |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/914.out |    7 ++++++
 tests/xfs/group   |    1 +
 3 files changed, 73 insertions(+)
 create mode 100755 tests/xfs/914
 create mode 100644 tests/xfs/914.out


diff --git a/tests/xfs/914 b/tests/xfs/914
new file mode 100755
index 00000000..b835394a
--- /dev/null
+++ b/tests/xfs/914
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 914
+#
+# Make sure that reflink forces the log out if we mount with wsync.  We test
+# that it actually forced the log by immediately shutting down the fs without
+# flushing the log and then remounting to check file contents.
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
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f $seqres.full
+
+# Format filesystem and set up quota limits
+_scratch_mkfs > $seqres.full
+_scratch_mount -o wsync >> $seqres.full
+
+# Set up initial files
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 1m -b 1m' $SCRATCH_MNT/a >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 1m -b 1m' $SCRATCH_MNT/c >> $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/e
+_cp_reflink $SCRATCH_MNT/c $SCRATCH_MNT/d
+touch $SCRATCH_MNT/b
+sync
+
+# Test that setting the reflink flag on the dest file forces the log
+echo "test reflink flag not set"
+$XFS_IO_PROG -x -c "reflink $SCRATCH_MNT/a" -c 'shutdown' $SCRATCH_MNT/b >> $seqres.full
+_scratch_cycle_mount wsync
+md5sum $SCRATCH_MNT/a $SCRATCH_MNT/b | _filter_scratch
+
+# Test forcing the log even if both files are already reflinked
+echo "test reflink flag already set"
+$XFS_IO_PROG -x -c "reflink $SCRATCH_MNT/a" -c 'shutdown' $SCRATCH_MNT/d >> $seqres.full
+_scratch_cycle_mount wsync
+md5sum $SCRATCH_MNT/a $SCRATCH_MNT/d | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/914.out b/tests/xfs/914.out
new file mode 100644
index 00000000..6b19fc65
--- /dev/null
+++ b/tests/xfs/914.out
@@ -0,0 +1,7 @@
+QA output created by 914
+test reflink flag not set
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/b
+test reflink flag already set
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/d
diff --git a/tests/xfs/group b/tests/xfs/group
index 12eb55c9..d39daf00 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -513,3 +513,4 @@
 513 auto mount
 514 auto quick db
 515 auto quick quota
+914 auto quick reflink

